From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-007.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:15 -0700
Message-ID: <200707162048.l6GKmFM9001021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758476AbXGPUtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, dwmw2@infradead.org, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.07
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-007.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update checkpatch.pl to version 0.07
From: Andy Whitcroft <apw@shadowen.org>

This version brings a number of new checks, fixes for flase
positives, plus a clarification of the output to better guide use.  Of
note:

  - checks for documentation for new __setup calls
  - clearer reporting where braces and parenthesis are involved
  - reports for closing brace and semi-colon spacing
  - reports on unwanted externs

This patch includes an update to the documentation on checkpatch.pl
itself to clarify when it should be used and to indicate that it
is not intended as the final arbitor of style.

Full changelog:

Andy Whitcroft (19):
      Version: 0.07
      ensure we do not apply control brace checks to preprocesor directives
      add {u,s}{8,16,32,64} to the type matcher
      accept lack of spacing after the semicolons in for (;;)
      report new externs in .c files
      fix up typedef exclusion for function prototypes
      else trailing statements check need to account for \ at end of line
      add enums to the type matcher
      add missing check descriptions
      suppress double reporting of ** spacing
      report on do{ spacing issues
      include an example of the brace/parenthesis in output
      check for spacing after closing braces
      prevent double reports on pointer spacing issues
      handle blank continuation lines on macros
      classify all reports error, warning, or check
      revamp hanging { checks and apply in context
      no spaces after the last ; in a for is ok
      check __setup has a corresponding addition to documentation

David Woodhouse (1):
      limit character set used in patches and descriptions to UTF-8

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   20 +
 scripts/checkpatch.pl           |  374 ++++++++++++++----------------
 2 files changed, 196 insertions(+), 198 deletions(-)

diff -puN Documentation/SubmittingPatches~update-checkpatchpl-to-version-007 Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~update-checkpatchpl-to-version-007
+++ a/Documentation/SubmittingPatches
@@ -464,9 +464,25 @@ section Linus Computer Science 101.
 Nuff said.  If your code deviates too much from this, it is likely
 to be rejected without further review, and without comment.
 
+Once significant exception is when moving code from one file to
+another in this case you should not modify the moved code at all in
+the same patch which moves it.  This clearly delineates the act of
+moving the code and your changes.  This greatly aids review of the
+actual differences and allows tools to better track the history of
+the code itself.
+
 Check your patches with the patch style checker prior to submission
-(scripts/checkpatch.pl).  You should be able to justify all
-violations that remain in your patch.
+(scripts/checkpatch.pl).  The style checker should be viewed as
+a guide not as the final word.  If your code looks better with
+a violation then its probably best left alone.
+
+The checker reports at three levels:
+ - ERROR: things that are very likely to be wrong
+ - WARNING: things requiring careful review
+ - CHECK: things requiring thought
+
+You should be able to justify all violations that remain in your
+patch.
 
 
 
diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-007 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-007
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.06';
+my $V = '0.07';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -246,6 +246,19 @@ sub cat_vet {
 	return $vet;
 }
 
+sub ERROR {
+	print "ERROR: $_[0]\n";
+	our $clean = 0;
+}
+sub WARN {
+	print "WARNING: $_[0]\n";
+	our $clean = 0;
+}
+sub CHK {
+	print "CHECK: $_[0]\n";
+	our $clean = 0;
+}
+
 sub process {
 	my $filename = shift;
 	my @lines = @_;
@@ -259,7 +272,7 @@ sub process {
 	my $previndent=0;
 	my $stashindent=0;
 
-	my $clean = 1;
+	our $clean = 1;
 	my $signoff = 0;
 	my $is_patch = 0;
 
@@ -290,8 +303,11 @@ sub process {
 					long\s+int|
 					long\s+long|
 					long\s+long\s+int|
+					u8|u16|u32|u64|
+					s8|s16|s32|s64|
 					struct\s+$Ident|
 					union\s+$Ident|
+					enum\s+$Ident|
 					${Ident}_t
 				)
 				(?:\s+$Sparse)*
@@ -304,6 +320,23 @@ sub process {
 	my $Declare	= qr{(?:$Storage\s+)?$Type};
 	my $Attribute	= qr{__read_mostly|__init|__initdata};
 
+	# Pre-scan the patch looking for any __setup documentation.
+	my @setup_docs = ();
+	my $setup_docs = 0;
+	foreach my $line (@lines) {
+		if ($line=~/^\+\+\+\s+(\S+)/) {
+			$setup_docs = 0;
+			if ($1 =~ m@Documentation/kernel-parameters.txt$@) {
+				$setup_docs = 1;
+			}
+			next;
+		}
+
+		if ($setup_docs && $line =~ /^\+/) {
+			push(@setup_docs, $line);
+		}
+	}
+
 	foreach my $line (@lines) {
 		$linenr++;
 
@@ -369,30 +402,42 @@ sub process {
 		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
 
 		my $hereline = "$here\n$line\n";
-		my $herecurr = "$here\n$line\n\n";
-		my $hereprev = "$here\n$prevline\n$line\n\n";
+		my $herecurr = "$here\n$line\n";
+		my $hereprev = "$here\n$prevline\n$line\n";
 
 #check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
 			$signoff++;
 			if (!($line =~ /^\s*Signed-off-by:/)) {
-				print "Signed-off-by: is the preferred form\n";
-				print "$herecurr";
-				$clean = 0;
+				WARN("Signed-off-by: is the preferred form\n" .
+					$herecurr);
 			}
 			if ($line =~ /^\s*signed-off-by:\S/i) {
-				print "need space after Signed-off-by:\n";
-				print "$herecurr";
-				$clean = 0;
+				WARN("need space after Signed-off-by:\n" .
+					$herecurr);
 			}
 		}
 
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |$)}) {
-			print "patch seems to be corrupt (line wrapped?) [$realcnt]\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("patch seems to be corrupt (line wrapped?)\n" .
+				$herecurr);
+		}
+
+# UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
+		if (($realfile =~ /^$/ || $line =~ /^\+/) &&
+		     !($line =~ m/^(
+				[\x09\x0A\x0D\x20-\x7E]              # ASCII
+				| [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
+				|  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
+				| [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
+				|  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
+				|  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
+				| [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
+				|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
+				)*$/x )) {
+			ERROR("Invalid UTF-8\n" . $herecurr);
 		}
 
 #ignore lines being removed
@@ -403,16 +448,12 @@ sub process {
 
 #trailing whitespace
 		if ($line =~ /^\+.*\S\s+$/ || $line =~ /^\+\s+$/) {
-			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
-			print "trailing whitespace\n";
-			print "$herevet";
-			$clean = 0;
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("trailing whitespace\n" . $herevet);
 		}
 #80 column limit
 		if ($line =~ /^\+/ && !($prevline=~/\/\*\*/) && $length > 80) {
-			print "line over 80 characters\n";
-			print "$herecurr";
-			$clean = 0;
+			WARN("line over 80 characters\n" . $herecurr);
 		}
 
 # check we are in a valid source file *.[hc] if not then ignore this hunk
@@ -421,10 +462,8 @@ sub process {
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
 		if ($line=~/^\+\s* \t\s*\S/ or $line=~/^\+\s*        \s*/) {
-			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
-			print "use tabs not spaces\n";
-			print "$herevet";
-			$clean = 0;
+			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			ERROR("use tabs not spaces\n" . $herevet);
 		}
 
 		#
@@ -463,9 +502,27 @@ sub process {
 				}
 			}
 			if ($err ne '') {
-				print "switch and case should be at the same indent\n";
-				print "$here\n$line\n$err\n";
-				$clean = 0;
+				ERROR("switch and case should be at the same indent\n$hereline\n$err\n");
+			}
+		}
+
+# if/while/etc brace do not go on next line, unless defining a do while loop,
+# or if that brace on the next line is for something else
+		if ($line =~ /\b(?:(if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
+			my @ctx = ctx_statement($linenr, $realcnt);
+			my $ctx_ln = $linenr + $#ctx + 1;
+			my $ctx_cnt = $realcnt - $#ctx - 1;
+			my $ctx = join("\n", @ctx);
+
+			while ($ctx_cnt > 0 && $lines[$ctx_ln - 1] =~ /^-/) {
+				$ctx_ln++;
+				$ctx_cnt--;
+			}
+			##warn "line<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>";
+
+			if ($ctx !~ /{\s*/ && $ctx_cnt > 0 && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
+				ERROR("That { should be on the previous line\n" .
+					"$here\n$ctx\n$lines[$ctx_ln - 1]");
 			}
 		}
 
@@ -474,9 +531,7 @@ sub process {
 
 # TEST: allow direct testing of the type matcher.
 		if ($tst_type && $line =~ /^.$Declare$/) {
-			print "TEST: is type $Declare\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("TEST: is type $Declare\n" . $herecurr);
 			next;
 		}
 
@@ -488,9 +543,8 @@ sub process {
 		if ($rawline =~ m{^.#\s*include\s+[<"](.*)[">]}) {
 			my $path = $1;
 			if ($path =~ m{//}) {
-				print "malformed #include filename\n";
-				print "$herecurr";
-				$clean = 0;
+				ERROR("malformed #include filename\n" .
+					$herecurr);
 			}
 			# Sanitise this special form of string.
 			$path = 'X' x length($path);
@@ -499,9 +553,7 @@ sub process {
 
 # no C99 // comments
 		if ($line =~ m{//}) {
-			print "do not use C99 // comments\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("do not use C99 // comments\n" . $herecurr);
 		}
 		# Remove C99 comments.
 		$line =~ s@//.*@@;
@@ -514,49 +566,40 @@ sub process {
 			   ($prevline !~ /^\+}/) &&
 			   ($prevline !~ /^ }/) &&
 			   ($prevline !~ /\s$name(?:\s+$Attribute)?\s*(?:;|=)/)) {
-				print "EXPORT_SYMBOL(foo); should immediately follow its function/variable\n";
-				print "$herecurr";
-				$clean = 0;
+				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 			}
 		}
 
 # check for static initialisers.
 		if ($line=~/\s*static\s.*=\s+(0|NULL);/) {
-			print "do not initialise statics to 0 or NULL\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("do not initialise statics to 0 or NULL\n" .
+				$herecurr);
 		}
 
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
-		    $line !~ /\btypedef\s+$Type\s+\(\s*$Ident\s*\)\s*\(/ &&
+		    $line !~ /\btypedef\s+$Type\s+\(\s*\*$Ident\s*\)\s*\(/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
-			print "do not add new typedefs\n";
-			print "$herecurr";
-			$clean = 0;
+			WARN("do not add new typedefs\n" . $herecurr);
 		}
 
 # * goes on variable not on type
 		if ($line =~ m{\($NonptrType(\*+)(?:\s+const)?\)}) {
-			print "\"(foo$1)\" should be \"(foo $1)\"\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("\"(foo$1)\" should be \"(foo $1)\"\n" .
+				$herecurr);
 
 		} elsif ($line =~ m{\($NonptrType\s+(\*+)(?!\s+const)\s+\)}) {
-			print "\"(foo $1 )\" should be \"(foo $1)\"\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n" .
+				$herecurr);
 
 		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+const)?\s+[A-Za-z\d_]+}) {
-			print "\"foo$1 bar\" should be \"foo $1bar\"\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n" .
+				$herecurr);
 
 		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+const)\s+[A-Za-z\d_]+}) {
-			print "\"foo $1 bar\" should be \"foo $1bar\"\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n" .
+				$herecurr);
 		}
 
 # # no BUG() or BUG_ON()
@@ -585,9 +628,7 @@ sub process {
 				}
 			}
 			if ($ok == 0) {
-				print "printk() should include KERN_ facility level\n";
-				print "$herecurr";
-				$clean = 0;
+				WARN("printk() should include KERN_ facility level\n" . $herecurr);
 			}
 		}
 
@@ -595,9 +636,7 @@ sub process {
 # or if closed on same line
 		if (($line=~/$Type\s*[A-Za-z\d_]+\(.*\).* {/) and
 		    !($line=~/\#define.*do\s{/) and !($line=~/}/)) {
-			print "braces following function declarations go on the next line\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
 # Check operator spacing.
@@ -633,27 +672,27 @@ sub process {
 				}
 
 				# Pick up the preceeding and succeeding characters.
-				my $ca = substr($opline, $off - 1, 1);
+				my $ca = substr($opline, 0, $off);
 				my $cc = '';
 				if (length($opline) >= ($off + length($elements[$n + 1]))) {
 					$cc = substr($opline, $off + length($elements[$n + 1]));
 				}
+				my $cb = "$ca$;$cc";
 
 				my $ctx = "${a}x${c}";
 
 				my $at = "(ctx:$ctx)";
 
 				my $ptr = (" " x $off) . "^";
-				my $hereptr = "$hereline$ptr\n\n";
+				my $hereptr = "$hereline$ptr\n";
 
 				##print "<$s1:$op:$s2> <$elements[$n]:$elements[$n + 1]:$elements[$n + 2]>\n";
 
 				# ; should have either the end of line or a space or \ after it
 				if ($op eq ';') {
-					if ($ctx !~ /.x[WE]/ && $cc !~ /^\\/) {
-						print "need space after that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+					if ($ctx !~ /.x[WEB]/ && $cc !~ /^\\/ &&
+					    $cc !~ /^;/) {
+						ERROR("need space after that '$op' $at\n" . $hereptr);
 					}
 
 				# // is a comment
@@ -662,43 +701,31 @@ sub process {
 				# -> should have no spaces
 				} elsif ($op eq '->') {
 					if ($ctx =~ /Wx.|.xW/) {
-						print "no spaces around that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+						ERROR("no spaces around that '$op' $at\n" . $hereptr);
 					}
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
 					if ($ctx !~ /.xW|.xE/ && $cc !~ /^}/) {
-						print "need space after that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+						ERROR("need space after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ! and unary ~ are allowed no space on the right
 				} elsif ($op eq '!' or $op eq '~') {
 					if ($ctx !~ /[WOEB]x./) {
-						print "need space before that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+						ERROR("need space before that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /.xW/) {
-						print "no space after that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+						ERROR("no space after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
 					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOBE]/) {
-						print "need space one side of that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+						ERROR("need space one side of that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /Wx./ && $cc =~ /^;/) {
-						print "no space before that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+						ERROR("no space before that '$op' $at\n" . $hereptr);
 					}
 
 				# & is both unary and binary
@@ -715,9 +742,7 @@ sub process {
 				#
 				} elsif ($op eq '&' or $op eq '-') {
 					if ($ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]/) {
-						print "need space before that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+						ERROR("need space before that '$op' $at\n" . $hereptr);
 					}
 
 				# * is the same as & only adding:
@@ -726,16 +751,9 @@ sub process {
 				#	(foo **)
 				#
 				} elsif ($op eq '*') {
-					if ($ca eq '*') {
-						if ($cc =~ /^\s(?!\s*const)/) {
-							print "no space after that '$op' $at\n";
-							print "$hereptr";
-							$clean = 0;
-						}
-					} elsif ($ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]|OxV|WxB|BxB/) {
-						print "need space before that '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+					if ($ca !~ /$Type$/ && $cb !~ /(\*$;|$;\*)/ &&
+					    $ctx !~ /VxV|[EW]x[WE]|[EWB]x[VO]|OxV|WxB|BxB/) {
+						ERROR("need space before that '$op' $at\n" . $hereptr);
 					}
 
 				# << and >> may either have or not have spaces both sides
@@ -743,58 +761,51 @@ sub process {
 					 $op eq '^' or $op eq '|')
 				{
 					if ($ctx !~ /VxV|WxW|VxE|WxE/) {
-						print "need consistent spacing around '$op' $at\n";
-						print "$hereptr";
-						$clean = 0;
+						ERROR("need consistent spacing around '$op' $at\n" .
+							$hereptr);
 					}
 
 				# All the others need spaces both sides.
 				} elsif ($ctx !~ /[EW]x[WE]/) {
-					print "need spaces around that '$op' $at\n";
-					print "$hereptr";
-					$clean = 0;
+					ERROR("need spaces around that '$op' $at\n" . $hereptr);
 				}
 				$off += length($elements[$n + 1]);
 			}
 		}
 
 #need space before brace following if, while, etc
-		if ($line=~/\(.*\){/) {
-			print "need a space before the brace\n";
-			print "$herecurr";
-			$clean = 0;
+		if ($line =~ /\(.*\){/ || $line =~ /do{/) {
+			ERROR("need a space before the open brace '{'\n" . $herecurr);
+		}
+
+# closing brace should have a space following it when it has anything
+# on the line
+		if ($line =~ /}(?!(?:,|;|\)))\S/) {
+			ERROR("need a space after that close brace '}'\n" . $herecurr);
 		}
 
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
-			print "labels should not be indented\n";
-			print "$herecurr";
-			$clean = 0;
+			WARN("labels should not be indented\n" . $herecurr);
 		}
 
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
-			print "need a space before the open parenthesis\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("need a space before the open parenthesis '('\n" . $herecurr);
 		}
 
 # Check for illegal assignment in if conditional.
 		if ($line=~/\bif\s*\(.*[^<>!=]=[^=].*\)/) {
 			#next if ($line=~/\".*\Q$op\E.*\"/ or $line=~/\'\Q$op\E\'/);
-			print "do not use assignment in if condition\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("do not use assignment in if condition\n" . $herecurr);
 		}
 
 		# Check for }<nl>else {, these must be at the same
 		# indent level to be relevant to each other.
 		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ and
 						$previndent == $indent) {
-			print "else should follow close brace\n";
-			print "$hereprev";
-			$clean = 0;
+			ERROR("else should follow close brace '}'\n" . $hereprev);
 		}
 
 #studly caps, commented out until figure out how to distinguish between use of existing and adding new
@@ -806,57 +817,22 @@ sub process {
 
 #no spaces allowed after \ in define
 		if ($line=~/\#define.*\\\s$/) {
-			print("Whitepspace after \\ makes next lines useless\n");
-			print "$herecurr";
-			$clean = 0;
+			WARN("Whitepspace after \\ makes next lines useless\n" . $herecurr);
 		}
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
 		if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
 			my $checkfile = "include/linux/$1.h";
 			if (-f $checkfile) {
-				print "Use #include <linux/$1.h> instead of <asm/$1.h>\n";
-				print $herecurr;
-				$clean = 0;
-			}
-		}
-
-# if/while/etc brace do not go on next line, unless defining a do while loop,
-# or if that brace on the next line is for something else
-		if ($prevline=~/\b(?:(if|while|for|switch)\s*\(|do\b|else\b)/) {
-			my @opened = $prevline=~/\(/g;
-			my @closed = $prevline=~/\)/g;
-			my $nr_line = $linenr;
-			my $remaining = $realcnt - 1;
-			my $next_line = $line;
-			my $extra_lines = 0;
-			my $display_segment = $prevline;
-
-			while ($remaining > 0 && scalar @opened > scalar @closed) {
-				$prevline .= $next_line;
-				$display_segment .= "\n" . $next_line;
-				$next_line = $lines[$nr_line];
-				$nr_line++;
-				$remaining--;
-
-				@opened = $prevline=~/\(/g;
-				@closed = $prevline=~/\)/g;
-			}
-
-			if (($prevline=~/\b(?:(if|while|for|switch)\s*\(.*\)|do|else)\s*$/) and ($next_line=~/{/) and
-			   !($next_line=~/\b(?:if|while|for|switch|do|else)\b/) and !($next_line=~/\#define.*do.*while/)) {
-				print "That { should be on the previous line\n";
-				print "$here\n$display_segment\n$next_line\n\n";
-				$clean = 0;
+				CHK("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
+					$herecurr);
 			}
 		}
 
 # if and else should not have general statements after it
 		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
-		    $1 !~ /^\s*(?:\sif|{|$)/) {
-			print "trailing statements should be on next line\n";
-			print "$herecurr";
-			$clean = 0;
+		    $1 !~ /^\s*(?:\sif|{|\\|$)/) {
+			ERROR("trailing statements should be on next line\n" . $herecurr);
 		}
 
 # multi-statement macros should be enclosed in a do while loop, grab the
@@ -877,49 +853,49 @@ sub process {
 				$ln--;
 				$cnt++;
 			}
-			my $ctx = join('', ctx_statement($ln, $cnt));
+			my @ctx = ctx_statement($ln, $cnt);
+			my $ctx_ln = $ln + $#ctx + 1;
+			my $ctx = join("\n", @ctx);
+
+			# Pull in any empty extension lines.
+			while ($ctx =~ /\\$/ &&
+			       $lines[$ctx_ln - 1] =~ /^.\s*(?:\\)?$/) {
+				$ctx .= $lines[$ctx_ln - 1];
+				$ctx_ln++;
+			}
 
 			if ($ctx =~ /\\$/) {
 				if ($ctx =~ /;/) {
-					print "Macros with multiple statements should be enclosed in a do - while loop\n";
+					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
 				} else {
-					print "Macros with complex values should be enclosed in parenthesis\n";
+					ERROR("Macros with complex values should be enclosed in parenthesis\n" . "$here\n$ctx\n");
 				}
-				print "$hereprev";
-				$clean = 0;
 			}
 		}
 
 # don't include deprecated include files (uses RAW line)
 		for my $inc (@dep_includes) {
 			if ($rawline =~ m@\#\s*include\s*\<$inc>@) {
-				print "Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n";
-				print "$herecurr";
-				$clean = 0;
+				ERROR("Don't use <$inc>: see Documentation/feature-removal-schedule.txt\n" . $herecurr);
 			}
 		}
 
 # don't use deprecated functions
 		for my $func (@dep_functions) {
 			if ($line =~ /\b$func\b/) {
-				print "Don't use $func(): see Documentation/feature-removal-schedule.txt\n";
-				print "$herecurr";
-				$clean = 0;
+				ERROR("Don't use $func(): see Documentation/feature-removal-schedule.txt\n" . $herecurr);
 			}
 		}
 
 # no volatiles please
 		if ($line =~ /\bvolatile\b/ && $line !~ /\basm\s+volatile\b/) {
-			print "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n";
-			print "$herecurr";
-			$clean = 0;
+			WARN("Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
 # warn about #if 0
 		if ($line =~ /^.#\s*if\s+0\b/) {
-			print "#if 0 -- if this code redundant remove it\n";
-			print "$herecurr";
-			$clean = 0;
+			CHK("if this code is redundant consider removing it\n" .
+				$herecurr);
 		}
 
 # warn about #ifdefs in C files
@@ -933,41 +909,47 @@ sub process {
 		if ($line =~ /^.\s*(struct\s+mutex|spinlock_t)\s+\S+;/) {
 			my $which = $1;
 			if (!ctx_has_comment($first_line, $linenr)) {
-				print "$1 definition without comment\n";
-				print "$herecurr";
-				$clean = 0;
+				CHK("$1 definition without comment\n" . $herecurr);
 			}
 		}
 # check for memory barriers without a comment.
 		if ($line =~ /\b(mb|rmb|wmb|read_barrier_depends|smp_mb|smp_rmb|smp_wmb|smp_read_barrier_depends)\(/) {
 			if (!ctx_has_comment($first_line, $linenr)) {
-				print "memory barrier without comment\n";
-				print "$herecurr";
-				$clean = 0;
+				CHK("memory barrier without comment\n" . $herecurr);
 			}
 		}
 # check of hardware specific defines
 		if ($line =~ m@^.#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@) {
-			print "architecture specific defines should be avoided\n";
-			print "$herecurr";
-			$clean = 0;
+			CHK("architecture specific defines should be avoided\n" .  $herecurr);
 		}
 
+# check the location of the inline attribute, that it is between
+# storage class and type.
 		if ($line =~ /$Type\s+(?:inline|__always_inline)\b/ ||
 		    $line =~ /\b(?:inline|always_inline)\s+$Storage/) {
-			print "inline keyword should sit between storage class and type\n";
-			print "$herecurr";
-			$clean = 0;
+			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
+		}
+
+# check for new externs in .c files.
+		if ($line =~ /^.\s*extern\s/ && ($realfile =~ /\.c$/)) {
+			WARN("externs should be avoided in .c files\n" .  $herecurr);
+		}
+
+# checks for new __setup's
+		if ($rawline =~ /\b__setup\("([^"]*)"/) {
+			my $name = $1;
+
+			if (!grep(/$name/, @setup_docs)) {
+				CHK("__setup appears un-documented -- check Documentation/kernel-parameters.txt\n" . $herecurr);
+			}
 		}
 	}
 
 	if ($chk_patch && !$is_patch) {
-		$clean = 0;
-		print "Does not appear to be a unified-diff format patch\n";
+		ERROR("Does not appear to be a unified-diff format patch\n");
 	}
 	if ($is_patch && $chk_signoff && $signoff == 0) {
-		$clean = 0;
-		print "Missing Signed-off-by: line(s)\n";
+		ERROR("Missing Signed-off-by: line(s)\n");
 	}
 
 	if ($clean == 1 && $quiet == 0) {
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
i386-move-the-kernel-to-16mb-for-numa-q.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-generic.patch
add-a-movablecore=-parameter-for-sizing-zone_movable.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
lumpy-reclaim-v4.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
