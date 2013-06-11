From: akpm@linux-foundation.org
Subject: +
 checkpatch-create-an-experimental-fix-option-to-correct-patches.patch added to -mm tree
Date: Tue, 11 Jun 2013 15:50:43 -0700
Message-ID: <51b7a9c3.Lyk+EYQnqx7v5A4m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3FKWuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-create-an-experimental-fix-option-to-correct-patches.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:50:43 -0700


The patch titled
     Subject: checkpatch: create an EXPERIMENTAL --fix option to correct patches
has been added to the -mm tree.  Its filename is
     checkpatch-create-an-experimental-fix-option-to-correct-patches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: create an EXPERIMENTAL --fix option to correct patches

Some patches have simple defects in whitespace and formatting that
checkpatch could correct automatically.  Attempt to do so.

Add a --fix option to create a "<inputfile>.EXPERIMENTAL-checkpatch-fixes"
file that tries to use normal kernel style for some of these formatting
errors.

Add warnings against using this file without verifying the changes.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  442 ++++++++++++++++++++++++++++++++--------
 1 file changed, 354 insertions(+), 88 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-create-an-experimental-fix-option-to-correct-patches scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-create-an-experimental-fix-option-to-correct-patches
+++ a/scripts/checkpatch.pl
@@ -27,6 +27,7 @@ my $summary = 1;
 my $mailback = 0;
 my $summary_file = 0;
 my $show_types = 0;
+my $fix = 0;
 my $root;
 my %debug;
 my %ignore_type = ();
@@ -63,6 +64,11 @@ Options:
                              is all off)
   --test-only=WORD           report only warnings/errors containing WORD
                              literally
+  --fix                      EXPERIMENTAL - may create horrible results
+                             If correctable single-line errors exist, create
+                             "<inputfile>.EXPERIMENTAL-checkpatch-fixes"
+                             with potential errors corrected to the preferred
+                             checkpatch style
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -114,7 +120,7 @@ GetOptions(
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
 	'summary-file!'	=> \$summary_file,
-
+	'fix!'		=> \$fix,
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
 	'h|help'	=> \$help,
@@ -367,6 +373,7 @@ $chk_signoff = 0 if ($file);
 
 my @rawlines = ();
 my @lines = ();
+my @fixed = ();
 my $vname;
 for my $filename (@ARGV) {
 	my $FILE;
@@ -394,6 +401,7 @@ for my $filename (@ARGV) {
 	}
 	@rawlines = ();
 	@lines = ();
+	@fixed = ();
 }
 
 exit($exit);
@@ -434,7 +442,7 @@ sub parse_email {
 		$comment = $2 if defined $2;
 		$formatted_email =~ s/$address.*$//;
 		$name = $formatted_email;
-		$name =~ s/^\s+|\s+$//g;
+		$name = trim($name);
 		$name =~ s/^\"|\"$//g;
 		# If there's a name left after stripping spaces and
 		# leading quotes, and the address doesn't have both
@@ -449,9 +457,9 @@ sub parse_email {
 		}
 	}
 
-	$name =~ s/^\s+|\s+$//g;
+	$name = trim($name);
 	$name =~ s/^\"|\"$//g;
-	$address =~ s/^\s+|\s+$//g;
+	$address = trim($address);
 	$address =~ s/^\<|\>$//g;
 
 	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
@@ -467,9 +475,9 @@ sub format_email {
 
 	my $formatted_email;
 
-	$name =~ s/^\s+|\s+$//g;
+	$name = trim($name);
 	$name =~ s/^\"|\"$//g;
-	$address =~ s/^\s+|\s+$//g;
+	$address = trim($address);
 
 	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
 		$name =~ s/(?<!\\)"/\\"/g; ##escape quotes
@@ -1291,19 +1299,25 @@ sub ERROR {
 	if (report("ERROR", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_error++;
+		return 1;
 	}
+	return 0;
 }
 sub WARN {
 	if (report("WARNING", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_warn++;
+		return 1;
 	}
+	return 0;
 }
 sub CHK {
 	if ($check && report("CHECK", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_chk++;
+		return 1;
 	}
+	return 0;
 }
 
 sub check_absolute_file {
@@ -1334,6 +1348,29 @@ sub check_absolute_file {
 	}
 }
 
+sub trim {
+	my ($string) = @_;
+
+	$string =~ s/(^\s+|\s+$)//g;
+
+	return $string;
+}
+
+sub tabify {
+	my ($leading) = @_;
+
+	my $source_indent = 8;
+	my $max_spaces_before_tab = $source_indent - 1;
+	my $spaces_to_tab = " " x $source_indent;
+
+	#convert leading spaces to tabs
+	1 while $leading =~ s@^([\t]*)$spaces_to_tab@$1\t@g;
+	#Remove spaces before a tab
+	1 while $leading =~ s@^([\t]*)( {1,$max_spaces_before_tab})\t@$1\t@g;
+
+	return "$leading";
+}
+
 sub pos_last_openparen {
 	my ($line) = @_;
 
@@ -1425,6 +1462,8 @@ sub process {
 		$linenr++;
 		$line = $rawline;
 
+		push(@fixed, $rawline) if ($fix);
+
 		if ($rawline=~/^\+\+\+\s+(\S+)/) {
 			$setup_docs = 0;
 			if ($1 =~ m@Documentation/kernel-parameters.txt$@) {
@@ -1616,16 +1655,29 @@ sub process {
 				     "Non-standard signature: $sign_off\n" . $herecurr);
 			}
 			if (defined $space_before && $space_before ne "") {
-				WARN("BAD_SIGN_OFF",
-				     "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);
+				if (WARN("BAD_SIGN_OFF",
+					 "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$linenr - 1] =
+					    "$ucfirst_sign_off $email";
+				}
 			}
 			if ($sign_off =~ /-by:$/i && $sign_off ne $ucfirst_sign_off) {
-				WARN("BAD_SIGN_OFF",
-				     "'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr);
+				if (WARN("BAD_SIGN_OFF",
+					 "'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$linenr - 1] =
+					    "$ucfirst_sign_off $email";
+				}
+
 			}
 			if (!defined $space_after || $space_after ne " ") {
-				WARN("BAD_SIGN_OFF",
-				     "Use a single space after $ucfirst_sign_off\n" . $herecurr);
+				if (WARN("BAD_SIGN_OFF",
+					 "Use a single space after $ucfirst_sign_off\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$linenr - 1] =
+					    "$ucfirst_sign_off $email";
+				}
 			}
 
 			my ($email_name, $email_address, $comment) = parse_email($email);
@@ -1715,8 +1767,12 @@ sub process {
 
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("TRAILING_WHITESPACE",
-			      "trailing whitespace\n" . $herevet);
+			if (ERROR("TRAILING_WHITESPACE",
+				  "trailing whitespace\n" . $herevet) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/^(\+.*?)\s+$/$1/;
+			}
+
 			$rpt_cleaners = 1;
 		}
 
@@ -1811,8 +1867,12 @@ sub process {
 
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
-			WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
-			     "unnecessary whitespace before a quoted newline\n" . $herecurr);
+			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
+				 "unnecessary whitespace before a quoted newline\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
+			}
+
 		}
 
 # check for adding lines without a newline.
@@ -1843,16 +1903,23 @@ sub process {
 		if ($rawline =~ /^\+\s* \t\s*\S/ ||
 		    $rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("CODE_INDENT",
-			      "code indent should use tabs where possible\n" . $herevet);
 			$rpt_cleaners = 1;
+			if (ERROR("CODE_INDENT",
+				  "code indent should use tabs where possible\n" . $herevet) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
+			}
 		}
 
 # check for space before tabs.
 		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			WARN("SPACE_BEFORE_TAB",
-			     "please, no space before tabs\n" . $herevet);
+			if (WARN("SPACE_BEFORE_TAB",
+				"please, no space before tabs\n" . $herevet) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/(^\+.*) +\t/$1\t/;
+			}
 		}
 
 # check for && or || at the start of a line
@@ -1880,15 +1947,24 @@ sub process {
 
 				if ($newindent ne $goodtabindent &&
 				    $newindent ne $goodspaceindent) {
-					CHK("PARENTHESIS_ALIGNMENT",
-					    "Alignment should match open parenthesis\n" . $hereprev);
+
+					if (CHK("PARENTHESIS_ALIGNMENT",
+						"Alignment should match open parenthesis\n" . $hereprev) &&
+					    $fix && $line =~ /^\+/) {
+						$fixed[$linenr - 1] =~
+						    s/^\+[ \t]*/\+$goodtabindent/;
+					}
 				}
 			}
 		}
 
 		if ($line =~ /^\+.*\*[ \t]*\)[ \t]+(?!$Assignment|$Arithmetic)/) {
-			CHK("SPACING",
-			    "No space is necessary after a cast\n" . $hereprev);
+			if (CHK("SPACING",
+				"No space is necessary after a cast\n" . $hereprev) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(\+.*\*[ \t]*\))[ \t]+/$1/;
+			}
 		}
 
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
@@ -1920,10 +1996,13 @@ sub process {
 #  1) within comments
 #  2) indented preprocessor commands
 #  3) hanging labels
-		if ($rawline =~ /^\+ / && $line !~ /\+ *(?:$;|#|$Ident:)/)  {
+		if ($rawline =~ /^\+ / && $line !~ /^\+ *(?:$;|#|$Ident:)/)  {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			WARN("LEADING_SPACE",
-			     "please, no spaces at the start of a line\n" . $herevet);
+			if (WARN("LEADING_SPACE",
+				 "please, no spaces at the start of a line\n" . $herevet) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
+			}
 		}
 
 # check we are in a valid C source file if not then ignore this hunk
@@ -2213,7 +2292,7 @@ sub process {
 		$prev_values = substr($curr_values, -1);
 
 #ignore lines not being added
-		if ($line=~/^[^\+]/) {next;}
+		next if ($line =~ /^[^\+]/);
 
 # TEST: allow direct testing of the type matcher.
 		if ($dbg_type) {
@@ -2264,8 +2343,15 @@ sub process {
 
 # no C99 // comments
 		if ($line =~ m{//}) {
-			ERROR("C99_COMMENTS",
-			      "do not use C99 // comments\n" . $herecurr);
+			if (ERROR("C99_COMMENTS",
+				  "do not use C99 // comments\n" . $herecurr) &&
+			    $fix) {
+				my $line = $fixed[$linenr - 1];
+				if ($line =~ /\/\/(.*)$/) {
+					my $comment = trim($1);
+					$fixed[$linenr - 1] =~ s@\/\/(.*)$@/\* $comment \*/@;
+				}
+			}
 		}
 		# Remove C99 comments.
 		$line =~ s@//.*@@;
@@ -2364,7 +2450,7 @@ sub process {
 		# (char*[ const])
 		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
 			#print "AA<$1>\n";
-			my ($from, $to) = ($2, $2);
+			my ($ident, $from, $to) = ($1, $2, $2);
 
 			# Should start with a space.
 			$to =~ s/^(\S)/ $1/;
@@ -2374,15 +2460,22 @@ sub process {
 			while ($to =~ s/\*\s+\*/\*\*/) {
 			}
 
-			#print "from<$from> to<$to>\n";
+##			print "1: from<$from> to<$to> ident<$ident>\n";
 			if ($from ne $to) {
-				ERROR("POINTER_LOCATION",
-				      "\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
+				if (ERROR("POINTER_LOCATION",
+					  "\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr) &&
+				    $fix) {
+					my $sub_from = $ident;
+					my $sub_to = $ident;
+					$sub_to =~ s/\Q$from\E/$to/;
+					$fixed[$linenr - 1] =~
+					    s@\Q$sub_from\E@$sub_to@;
+				}
 			}
 		}
 		while ($line =~ m{(\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident))}g) {
 			#print "BB<$1>\n";
-			my ($from, $to, $ident) = ($2, $2, $3);
+			my ($match, $from, $to, $ident) = ($1, $2, $2, $3);
 
 			# Should start with a space.
 			$to =~ s/^(\S)/ $1/;
@@ -2394,10 +2487,18 @@ sub process {
 			# Modifiers should have spaces.
 			$to =~ s/(\b$Modifier$)/$1 /;
 
-			#print "from<$from> to<$to> ident<$ident>\n";
+##			print "2: from<$from> to<$to> ident<$ident>\n";
 			if ($from ne $to && $ident !~ /^$Modifier$/) {
-				ERROR("POINTER_LOCATION",
-				      "\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
+				if (ERROR("POINTER_LOCATION",
+					  "\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr) &&
+				    $fix) {
+
+					my $sub_from = $match;
+					my $sub_to = $match;
+					$sub_to =~ s/\Q$from\E/$to/;
+					$fixed[$linenr - 1] =~
+					    s@\Q$sub_from\E@$sub_to@;
+				}
 			}
 		}
 
@@ -2483,9 +2584,13 @@ sub process {
 		}
 
 # missing space after union, struct or enum definition
-		if ($line =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?(?:\s+$Ident)?[=\{]/) {
-		    WARN("SPACING",
-			 "missing space after $1 definition\n" . $herecurr);
+		if ($line =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident){1,2}[=\{]/) {
+			if (WARN("SPACING",
+				 "missing space after $1 definition\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(.\s*(?:typedef\s+)?(?:enum|union|struct)(?:\s+$Ident){1,2})([=\{])/$1 $2/;
+			}
 		}
 
 # check for spacing round square brackets; allowed:
@@ -2497,8 +2602,12 @@ sub process {
 			if ($prefix !~ /$Type\s+$/ &&
 			    ($where != 0 || $prefix !~ /^.\s+$/) &&
 			    $prefix !~ /[{,]\s+$/) {
-				ERROR("BRACKET_SPACE",
-				      "space prohibited before open square bracket '['\n" . $herecurr);
+				if (ERROR("BRACKET_SPACE",
+					  "space prohibited before open square bracket '['\n" . $herecurr) &&
+				    $fix) {
+				    $fixed[$linenr - 1] =~
+					s/^(\+.*?)\s+\[/$1\[/;
+				}
 			}
 		}
 
@@ -2515,7 +2624,6 @@ sub process {
 				__attribute__|format|__extension__|
 				asm|__asm__)$/x)
 			{
-
 			# cpp #define statements have non-optional spaces, ie
 			# if there is a space between the name and the open
 			# parenthesis it is simply not a parameter group.
@@ -2529,19 +2637,30 @@ sub process {
 			} elsif ($ctx =~ /$Type$/) {
 
 			} else {
-				WARN("SPACING",
-				     "space prohibited between function name and open parenthesis '('\n" . $herecurr);
+				if (WARN("SPACING",
+					 "space prohibited between function name and open parenthesis '('\n" . $herecurr) &&
+					     $fix) {
+					$fixed[$linenr - 1] =~
+					    s/\b$name\s+\(/$name\(/;
+				}
 			}
 		}
 
 # check for whitespace before a non-naked semicolon
 		if ($line =~ /^\+.*\S\s+;/) {
-			WARN("SPACING",
-			     "space prohibited before semicolon\n" . $herecurr);
+			if (WARN("SPACING",
+				 "space prohibited before semicolon\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(\+.*\S)\s+;/$1;/;
+			}
 		}
 
 # Check operator spacing.
 		if (!($line=~/\#\s*include/)) {
+			my $fixed_line = "";
+			my $line_fixed = 0;
+
 			my $ops = qr{
 				<<=|>>=|<=|>=|==|!=|
 				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
@@ -2550,11 +2669,30 @@ sub process {
 				\?|:
 			}x;
 			my @elements = split(/($ops|;)/, $opline);
+
+##			print("element count: <" . $#elements . ">\n");
+##			foreach my $el (@elements) {
+##				print("el: <$el>\n");
+##			}
+
+			my @fix_elements = ();
 			my $off = 0;
 
+			foreach my $el (@elements) {
+				push(@fix_elements, substr($rawline, $off, length($el)));
+				$off += length($el);
+			}
+
+			$off = 0;
+
 			my $blank = copy_spacing($opline);
 
 			for (my $n = 0; $n < $#elements; $n += 2) {
+
+				my $good = $fix_elements[$n] . $fix_elements[$n + 1];
+
+##				print("n: <$n> good: <$good>\n");
+
 				$off += length($elements[$n]);
 
 				# Pick up the preceding and succeeding characters.
@@ -2611,8 +2749,11 @@ sub process {
 				} elsif ($op eq ';') {
 					if ($ctx !~ /.x[WEBC]/ &&
 					    $cc !~ /^\\/ && $cc !~ /^;/) {
-						ERROR("SPACING",
-						      "space required after that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "space required after that '$op' $at\n" . $hereptr)) {
+							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							$line_fixed = 1;
+						}
 					}
 
 				# // is a comment
@@ -2623,15 +2764,24 @@ sub process {
 				#   :   when part of a bitfield
 				} elsif ($op eq '->' || $opv eq ':B') {
 					if ($ctx =~ /Wx.|.xW/) {
-						ERROR("SPACING",
-						      "spaces prohibited around that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "spaces prohibited around that '$op' $at\n" . $hereptr)) {
+							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$line_fixed = 1;
+							if (defined $fix_elements[$n + 2]) {
+								$fix_elements[$n + 2] =~ s/^\s+//;
+							}
+						}
 					}
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
-						ERROR("SPACING",
-						      "space required after that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "space required after that '$op' $at\n" . $hereptr)) {
+							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]) . " ";
+							$line_fixed = 1;
+						}
 					}
 
 				# '*' as part of a type definition -- reported already.
@@ -2645,34 +2795,58 @@ sub process {
 					 $opv eq '*U' || $opv eq '-U' ||
 					 $opv eq '&U' || $opv eq '&&U') {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
-						ERROR("SPACING",
-						      "space required before that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "space required before that '$op' $at\n" . $hereptr)) {
+							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]);
+							$line_fixed = 1;
+						}
 					}
 					if ($op eq '*' && $cc =~/\s*$Modifier\b/) {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
-						ERROR("SPACING",
-						      "space prohibited after that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "space prohibited after that '$op' $at\n" . $hereptr)) {
+							$fixed_line =~ s/\s+$//;
+							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$line_fixed = 1;
+							if (defined $fix_elements[$n + 2]) {
+								$fix_elements[$n + 2] =~ s/^\s+//;
+							}
+						}
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
 					if ($ctx !~ /[WEOBC]x[^W]/ && $ctx !~ /[^W]x[WOBEC]/) {
-						ERROR("SPACING",
-						      "space required one side of that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "space required one side of that '$op' $at\n" . $hereptr)) {
+							$fixed_line =~ s/\s+$//;
+							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]) . " ";
+							$line_fixed = 1;
+						}
 					}
 					if ($ctx =~ /Wx[BE]/ ||
 					    ($ctx =~ /Wx./ && $cc =~ /^;/)) {
-						ERROR("SPACING",
-						      "space prohibited before that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "space prohibited before that '$op' $at\n" . $hereptr)) {
+							$fixed_line =~ s/\s+$//;
+							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$line_fixed = 1;
+						}
 					}
 					if ($ctx =~ /ExW/) {
-						ERROR("SPACING",
-						      "space prohibited after that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "space prohibited after that '$op' $at\n" . $hereptr)) {
+							$fixed_line =~ s/\s+$//;
+							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$line_fixed = 1;
+							if (defined $fix_elements[$n + 2]) {
+								$fix_elements[$n + 2] =~ s/^\s+//;
+							}
+						}
 					}
 
-
 				# << and >> may either have or not have spaces both sides
 				} elsif ($op eq '<<' or $op eq '>>' or
 					 $op eq '&' or $op eq '^' or $op eq '|' or
@@ -2681,17 +2855,23 @@ sub process {
 					 $op eq '%')
 				{
 					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
-						ERROR("SPACING",
-						      "need consistent spacing around '$op' $at\n" .
-							$hereptr);
+						if (ERROR("SPACING",
+							  "need consistent spacing around '$op' $at\n" . $hereptr)) {
+							$fixed_line =~ s/\s+$//;
+							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							$line_fixed = 1;
+						}
 					}
 
 				# A colon needs no spaces before when it is
 				# terminating a case value or a label.
 				} elsif ($opv eq ':C' || $opv eq ':L') {
 					if ($ctx =~ /Wx./) {
-						ERROR("SPACING",
-						      "space prohibited before that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "space prohibited before that '$op' $at\n" . $hereptr)) {
+							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$line_fixed = 1;
+						}
 					}
 
 				# All the others need spaces both sides.
@@ -2714,12 +2894,30 @@ sub process {
 					}
 
 					if ($ok == 0) {
-						ERROR("SPACING",
-						      "spaces required around that '$op' $at\n" . $hereptr);
+						if (ERROR("SPACING",
+							  "spaces required around that '$op' $at\n" . $hereptr)) {
+							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							$good = $fix_elements[$n] . " " . trim($fix_elements[$n + 1]) . " ";
+							$line_fixed = 1;
+						}
 					}
 				}
 				$off += length($elements[$n + 1]);
+
+##				print("n: <$n> GOOD: <$good>\n");
+
+				$fixed_line = $fixed_line . $good;
 			}
+
+			if (($#elements % 2) == 0) {
+				$fixed_line = $fixed_line . $fix_elements[$#elements];
+			}
+
+			if ($fix && $line_fixed && $fixed_line ne $fixed[$linenr - 1]) {
+				$fixed[$linenr - 1] = $fixed_line;
+			}
+
+
 		}
 
 # check for multiple assignments
@@ -2747,8 +2945,12 @@ sub process {
 #need space before brace following if, while, etc
 		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
 		    $line =~ /do{/) {
-			ERROR("SPACING",
-			      "space required before the open brace '{'\n" . $herecurr);
+			if (ERROR("SPACING",
+				  "space required before the open brace '{'\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(\+.*(?:do|\))){/$1 {/;
+			}
 		}
 
 ## # check for blank lines before declarations
@@ -2768,32 +2970,52 @@ sub process {
 
 # check spacing on square brackets
 		if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
-			ERROR("SPACING",
-			      "space prohibited after that open square bracket '['\n" . $herecurr);
+			if (ERROR("SPACING",
+				  "space prohibited after that open square bracket '['\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/\[\s+/\[/;
+			}
 		}
 		if ($line =~ /\s\]/) {
-			ERROR("SPACING",
-			      "space prohibited before that close square bracket ']'\n" . $herecurr);
+			if (ERROR("SPACING",
+				  "space prohibited before that close square bracket ']'\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/\s+\]/\]/;
+			}
 		}
 
 # check spacing on parentheses
 		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
 		    $line !~ /for\s*\(\s+;/) {
-			ERROR("SPACING",
-			      "space prohibited after that open parenthesis '('\n" . $herecurr);
+			if (ERROR("SPACING",
+				  "space prohibited after that open parenthesis '('\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/\(\s+/\(/;
+			}
 		}
 		if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
 		    $line !~ /for\s*\(.*;\s+\)/ &&
 		    $line !~ /:\s+\)/) {
-			ERROR("SPACING",
-			      "space prohibited before that close parenthesis ')'\n" . $herecurr);
+			if (ERROR("SPACING",
+				  "space prohibited before that close parenthesis ')'\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/\s+\)/\)/;
+			}
 		}
 
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
-			WARN("INDENTED_LABEL",
-			     "labels should not be indented\n" . $herecurr);
+			if (WARN("INDENTED_LABEL",
+				 "labels should not be indented\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(.)\s+/$1/;
+			}
 		}
 
 # Return is not a function.
@@ -2830,8 +3052,13 @@ sub process {
 		}
 
 # Need a space before open parenthesis after if, while etc
-		if ($line=~/\b(if|while|for|switch)\(/) {
-			ERROR("SPACING", "space required before the open parenthesis '('\n" . $herecurr);
+		if ($line =~ /\b(if|while|for|switch)\(/) {
+			if (ERROR("SPACING",
+				  "space required before the open parenthesis '('\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/\b(if|while|for|switch)\(/$1 \(/;
+			}
 		}
 
 # Check for illegal assignment in if conditional -- and check for trailing
@@ -3329,8 +3556,13 @@ sub process {
 
 # warn about spacing in #ifdefs
 		if ($line =~ /^.\s*\#\s*(ifdef|ifndef|elif)\s\s+/) {
-			ERROR("SPACING",
-			      "exactly one space required after that #$1\n" . $herecurr);
+			if (ERROR("SPACING",
+				  "exactly one space required after that #$1\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(.\s*\#\s*(ifdef|ifndef|elif))\s{2,}/$1 /;
+			}
+
 		}
 
 # check for spinlock_t definitions without a comment.
@@ -3793,6 +4025,40 @@ sub process {
 	    print "\n\n";
 	}
 
+	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
+		my $newfile = $filename . ".EXPERIMENTAL-checkpatch-fixes";
+		my $linecount = 0;
+		my $f;
+
+		open($f, '>', $newfile)
+		    or die "$P: Can't open $newfile for write\n";
+		foreach my $fixed_line (@fixed) {
+			$linecount++;
+			if ($file) {
+				if ($linecount > 3) {
+					$fixed_line =~ s/^\+//;
+					print $f $fixed_line. "\n";
+				}
+			} else {
+				print $f $fixed_line . "\n";
+			}
+		}
+		close($f);
+
+		if (!$quiet) {
+			print << "EOM";
+Wrote EXPERIMENTAL --fix correction(s) to '$newfile'
+
+Do _NOT_ trust the results written to this file.
+Do _NOT_ submit these changes without inspecting them for correctness.
+
+This EXPERIMENTAL file is simply a convenience to help rewrite patches.
+No warranties, expressed or implied...
+
+EOM
+		}
+	}
+
 	if ($clean == 1 && $quiet == 0) {
 		print "$vname has no obvious style problems and is ready for submission.\n"
 	}
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
checkpatch-remove-quote-from-camelcase-test.patch
checkpatch-improve-network-block-comment-test-and-message.patch
checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
checkpatch-warn-on-comparisons-to-jiffies.patch
checkpatch-warn-on-comparisons-to-get_jiffies_64.patch
checkpatch-reduce-false-positive-rate-of-complex-macros.patch
checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch
checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
checkpatch-add-a-strict-test-for-comparison-to-true-false.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-create-an-experimental-fix-option-to-correct-patches.patch
checkpatch-move-test-for-space-before-semicolon-after-operator-spacing.patch

