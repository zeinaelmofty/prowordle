

main:- write("Welcome to Pro-Wordle! \n"),
     write("---------------------- \n"),
     build_kb, 
     play.

build_kb:-  write("Please enter a word and its category on separate lines:"),nl,
       read(W),
       ((W= done, 
       	write("Done building the words database...")) ;
       	(W\= done,
       	read(C),
       	assert(word(W,C)),
       	build_kb)).

is_category(C):-
     word(_,C).

categories(L):- setof(C, is_category(C), L).

available_lengths(N):- word(W,_),
						string_length(W,N).


pick_word(W,L,C):- available_lengths(L),
                    word(W,C),
                  string_length(W,L).

correct_letters(L1,L2,CL):- setof(Letter, (member(Letter,L1), member(Letter,L2)), CL);
                             CL=[].

correct_positions([],_ , []).
correct_positions(_,[],[]).
correct_positions([H|T1],[H|T2], [H|T]):- correct_positions(T1,T2,T).
correct_positions([H1|T1],[H2|T2],T):- H1\= H2,
                                       correct_positions(T1,T2,T).

readC(C,C1):-
((is_category(C),
    C1=C);
(write("This category does not exist."),nl,
    write("Choose a category:"),nl,
    read(CNew),
    readC(CNew,C1))).

readL(C,L,L1):- 
((available_lengths(L),
    L1=L);
    (nl,
    write("There are no words of this length."), nl,
    write("Choose a length:"), nl,
     read(LNew),
    readL(C,LNew,L1))).


readW(WP,Length, 1):-
write("Enter a word composed of "),
        write(Length),
        write(" letters."), nl,
        read(W), 
        atom_chars(W,List),
        length(List,L),
        (
         Length==L,
         WP=W,
         write('You Won!'),nl;
         write('You Lost!'),nl
        ).


readW(WP,Length, Guesses):-  
        Guesses>1,
        Guesses1 is Guesses-1,
        write("Enter a word composed of "),
        write(Length),
        write(" letters."), nl,
        read(W1),
        string_chars(W1,LW),
        string_chars(WP,LWP),
        length(LW,L),
        (
         L==Length,
         W1=WP,
         write('You Won!'),nl;
         Length\=L,
         write('Word is not composed of '),
         write(Length), write(' letters. Try again.'),nl,
         write('Remaining Guesses are '),
         write(Guesses),nl,nl,
         readW(WP,Length,Guesses);
         Length==L,
         correct_letters(LWP,LW,L1),
         write('Correct letters are: '), write(L1),nl,
         correct_positions(LWP,LW,L2),
         write('Correct letters in correct positions are: '),
         write(L2),nl,
         write('Remaining Guesses are '),
         write(Guesses1),nl,
         readW(WP,Length,Guesses1)).


play:-write("The available categories are: "),
        categories(L),
        write(L),nl,
        write("Choose a category:"),nl,
        read(C),
        readC(C,C1),
        write("Choose a length:"), nl,
        read(Length),
        readL(C1,Length, LengthRes),
        write("Game started. You have "),
        Guesses is  LengthRes + 1,
        write(Guesses),
        write(" guesses.") ,nl,nl,
        pick_word(WP,LengthRes,C1),
        readW(WP, LengthRes, Guesses).













