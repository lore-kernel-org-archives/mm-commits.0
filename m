From: akpm@linux-foundation.org
Subject: + update-checkpatchpl-to-version-014.patch added to -mm tree
Date: Wed, 06 Feb 2008 10:02:50 -0800
Message-ID: <200802061802.m16I2VBC023253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35924 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316AbYBFSDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 13:03:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     update checkpatch.pl to version 0.14
has been added to the -mm tree.  Its filename is
     update-checkpatchpl-to-version-014.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update checkpatch.pl to version 0.14
From: Andy Whitcroft <apw@shadowen.org>

This version brings the remainder of the queued fixes.  A number of fixes
for items missed reported by Andrew Morton and others.  Also a handful
of new checks and fixes for false positives.  Of note:

 - new warning associated with --file to try and avoid cleanup only patches,
 - corrected handling of completly empty files,
 - corrected report handling with multiple files,
 - handling of possible types in the face of multiple declarations,
 - detection of unnessary braces on complex if statements (where present), and
 - all new comment spacing handling.

Andi Kleen (1):
      Introduce a warning when --file mode is used

Andy Whitcroft (14):
      Version: 0.14
      clean up some space violations in checkpatch.pl
      a completly empty file should not provoke a whinge
      reset report lines buffers between files
      unary ++/-- may abutt close braces
      __typeof__ is also unary
      comments: revamp comment handling
      add --summary-file option adding filename to summary line
      trailing backslashes are not trailing statements
      handle operators passed as parameters such as to ASSERTCMP
      possible types -- enhance debugging
      check for boolean operations with constants
      possible types: handle multiple declarations
      detect and report if statements where all branches are single statements

Arjan van de Ven (1):
      quiet option should not print the summary on no errors

Bartlomiej Zolnierkiewicz (1):
      warn about using __FUNCTION__

Timur Tabi (1):
      loosen spacing checks for __asm__

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  226 ++++++++++++++++++++++++++++++++--------
 1 file changed, 184 insertions(+), 42 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-014 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-014
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.13';
+my $V = '0.14';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -24,6 +24,7 @@ my $file = 0;
 my $check = 0;
 my $summary = 1;
 my $mailback = 0;
+my $summary_file = 0;
 my $root;
 my %debug;
 GetOptions(
@@ -31,7 +32,6 @@ GetOptions(
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
 	'patch!'	=> \$chk_patch,
-	'test-type!'	=> \$tst_type,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
 	'file!'		=> \$file,
@@ -40,7 +40,10 @@ GetOptions(
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
+	'summary-file!'	=> \$summary_file,
+
 	'debug=s'	=> \%debug,
+	'test-type!'	=> \$tst_type,
 ) or exit;
 
 my $exit = 0;
@@ -48,13 +51,15 @@ my $exit = 0;
 if ($#ARGV < 0) {
 	print "usage: $P [options] patchfile\n";
 	print "version: $V\n";
-	print "options: -q           => quiet\n";
-	print "         --no-tree    => run without a kernel tree\n";
-	print "         --terse      => one line per report\n";
-	print "         --emacs      => emacs compile window format\n";
-	print "         --file       => check a source file\n";
-	print "         --strict     => enable more subjective tests\n";
-	print "         --root       => path to the kernel tree root\n";
+	print "options: -q               => quiet\n";
+	print "         --no-tree        => run without a kernel tree\n";
+	print "         --terse          => one line per report\n";
+	print "         --emacs          => emacs compile window format\n";
+	print "         --file           => check a source file\n";
+	print "         --strict         => enable more subjective tests\n";
+	print "         --root           => path to the kernel tree root\n";
+	print "         --no-summary     => suppress the per-file summary\n";
+	print "         --summary-file   => include the filename in summary\n";
 	exit(1);
 }
 
@@ -213,6 +218,7 @@ for my $filename (@ARGV) {
 		$exit = 1;
 	}
 	@rawlines = ();
+	@lines = ();
 }
 
 exit($exit);
@@ -321,14 +327,14 @@ sub sanitise_line {
 	}
 
 	# Clear out the comments.
-	while ($res =~ m@(/\*.*?\*/)@) {
-		substr($res, $-[1], $+[1] - $-[1]) = ' ' x ($+[1] - $-[1]);
+	while ($res =~ m@(/\*.*?\*/)@g) {
+		substr($res, $-[1], $+[1] - $-[1]) = $; x ($+[1] - $-[1]);
 	}
 	if ($res =~ m@(/\*.*)@) {
-		substr($res, $-[1], $+[1] - $-[1]) = ' ' x ($+[1] - $-[1]);
+		substr($res, $-[1], $+[1] - $-[1]) = $; x ($+[1] - $-[1]);
 	}
 	if ($res =~ m@^.(.*\*/)@) {
-		substr($res, $-[1], $+[1] - $-[1]) = ' ' x ($+[1] - $-[1]);
+		substr($res, $-[1], $+[1] - $-[1]) = $; x ($+[1] - $-[1]);
 	}
 
 	# The pathname on a #include may be surrounded by '<' and '>'.
@@ -352,10 +358,14 @@ sub ctx_statement_block {
 	my $soff = $off;
 	my $coff = $off - 1;
 
+	my $loff = 0;
+
 	my $type = '';
 	my $level = 0;
 	my $c;
 	my $len = 0;
+
+	my $remainder;
 	while (1) {
 		#warn "CSB: blk<$blk>\n";
 		# If we are about to drop off the end, pull in more
@@ -364,6 +374,7 @@ sub ctx_statement_block {
 			for (; $remain > 0; $line++) {
 				next if ($lines[$line] =~ /^-/);
 				$remain--;
+				$loff = $len;
 				$blk .= $lines[$line] . "\n";
 				$len = length($blk);
 				$line++;
@@ -371,11 +382,12 @@ sub ctx_statement_block {
 			}
 			# Bail if there is no further context.
 			#warn "CSB: blk<$blk> off<$off> len<$len>\n";
-			if ($off == $len) {
+			if ($off >= $len) {
 				last;
 			}
 		}
 		$c = substr($blk, $off, 1);
+		$remainder = substr($blk, $off);
 
 		#warn "CSB: c<$c> type<$type> level<$level>\n";
 		# Statement ends at the ';' or a close '}' at the
@@ -384,6 +396,12 @@ sub ctx_statement_block {
 			last;
 		}
 
+		# An else is really a conditional as long as its not else if
+		if ($level == 0 && $remainder =~ /(\s+else)(?:\s|{)/ &&
+					$remainder !~ /\s+else\s+if\b/) {
+			$coff = $off + length($1);
+		}
+
 		if (($type eq '' || $type eq '(') && $c eq '(') {
 			$level++;
 			$type = '(';
@@ -410,6 +428,10 @@ sub ctx_statement_block {
 		}
 		$off++;
 	}
+	if ($off == $len) {
+		$line++;
+		$remain--;
+	}
 
 	my $statement = substr($blk, $soff, $off - $soff + 1);
 	my $condition = substr($blk, $soff, $coff - $soff + 1);
@@ -417,7 +439,30 @@ sub ctx_statement_block {
 	#warn "STATEMENT<$statement>\n";
 	#warn "CONDITION<$condition>\n";
 
-	return ($statement, $condition);
+	#print "off<$off> loff<$loff>\n";
+
+	return ($statement, $condition,
+			$line, $remain + 1, $off - $loff + 1, $level);
+}
+
+sub ctx_statement_full {
+	my ($linenr, $remain, $off) = @_;
+	my ($statement, $condition, $level);
+
+	my (@chunks);
+
+	($statement, $condition, $linenr, $remain, $off, $level) =
+				ctx_statement_block($linenr, $remain, $off);
+	#print "F: c<$condition> s<$statement>\n";
+	for (;;) {
+		push(@chunks, [ $condition, $statement ]);
+		last if (!($remain > 0 && $condition =~ /^.\s*(?:if|else|do)/));
+		($statement, $condition, $linenr, $remain, $off, $level) =
+				ctx_statement_block($linenr, $remain, $off);
+		#print "C: c<$condition> s<$statement>\n";
+	}
+
+	return ($level, $linenr, @chunks);
 }
 
 sub ctx_block_get {
@@ -598,7 +643,7 @@ sub annotate_values {
 			}
 			$type = 'N';
 
-		} elsif ($cur =~ /^(if|while|typeof|for)\b/o) {
+		} elsif ($cur =~ /^(if|while|typeof|__typeof__|for)\b/o) {
 			print "COND($1)\n" if ($dbg_values > 1);
 			$av_paren_type[$av_paren] = 'N';
 			$type = 'N';
@@ -635,8 +680,12 @@ sub annotate_values {
 			print "ASSIGN($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
-		} elsif ($cur =~ /^(;|{|}|\?|:|\[)/o) {
+		} elsif ($cur =~/^(;)/) {
 			print "END($1)\n" if ($dbg_values > 1);
+			$type = 'E';
+
+		} elsif ($cur =~ /^(;|{|}|\?|:|\[)/o) {
+			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
 		} elsif ($cur =~ /^($Operators)/o) {
@@ -658,7 +707,7 @@ sub annotate_values {
 }
 
 sub possible {
-	my ($possible) = @_;
+	my ($possible, $line) = @_;
 
 	#print "CHECK<$possible>\n";
 	if ($possible !~ /^(?:$Storage|$Type|DEFINE_\S+)$/ &&
@@ -666,7 +715,7 @@ sub possible {
 	    $possible ne 'struct' && $possible ne 'enum' &&
 	    $possible ne 'case' && $possible ne 'else' &&
 	    $possible ne 'typedef') {
-		warn "POSSIBLE: $possible\n" if ($dbg_possible);
+		warn "POSSIBLE: $possible ($line)\n" if ($dbg_possible);
 		push(@typeList, $possible);
 		build_types();
 	}
@@ -674,16 +723,15 @@ sub possible {
 
 my $prefix = '';
 
-my @report = ();
 sub report {
 	my $line = $prefix . $_[0];
 
 	$line = (split('\n', $line))[0] . "\n" if ($terse);
 
-	push(@report, $line);
+	push(our @report, $line);
 }
 sub report_dump {
-	@report;
+	our @report;
 }
 sub ERROR {
 	report("ERROR: $_[0]\n");
@@ -721,6 +769,7 @@ sub process {
 	my $signoff = 0;
 	my $is_patch = 0;
 
+	our @report = ();
 	our $cnt_lines = 0;
 	our $cnt_error = 0;
 	our $cnt_warn = 0;
@@ -735,7 +784,10 @@ sub process {
 	my $comment_edge = 0;
 	my $first_line = 0;
 
-	my $prev_values = 'N';
+	my $prev_values = 'E';
+
+	# suppression flags
+	my $suppress_ifbraces = 0;
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -791,7 +843,9 @@ sub process {
 				$realcnt=1+1;
 			}
 			annotate_reset();
-			$prev_values = 'N';
+			$prev_values = 'E';
+
+			$suppress_ifbraces = $linenr - 1;
 			next;
 		}
 
@@ -953,22 +1007,22 @@ sub process {
 
 			# definitions in global scope can only start with types
 			} elsif ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/) {
-				possible($1);
+				possible($1, $line);
 
 			# declarations always start with types
-			} elsif ($prev_values eq 'N' && $line =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=)/) {
+			} elsif ($prev_values eq 'E' && $line =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=|,)/) {
 				possible($1);
 			}
 
 			# any (foo ... *) is a pointer cast, and foo is a type
 			while ($line =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/g) {
-				possible($1);
+				possible($1, $line);
 			}
 
 			# Check for any sort of function declaration.
 			# int foo(something bar, other baz);
 			# void (*store_gdt)(x86_descr_ptr *);
-			if ($prev_values eq 'N' && $line =~ /^(.(?:typedef\s*)?(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {
+			if ($prev_values eq 'E' && $line =~ /^(.(?:typedef\s*)?(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {
 				my ($name_len) = length($1);
 				my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, $name_len);
 				my $ctx = join("\n", @ctx);
@@ -979,7 +1033,7 @@ sub process {
 				for my $arg (split(/\s*,\s*/, $ctx)) {
 					if ($arg =~ /^(?:const\s+)?($Ident)(?:\s+$Sparse)*\s*\**\s*(:?\b$Ident)?$/ || $arg =~ /^($Ident)$/) {
 
-						possible($1);
+						possible($1, $line);
 					}
 				}
 			}
@@ -1189,7 +1243,7 @@ sub process {
 			my $ctx = substr($line, 0, $-[1]);
 
 			# Ignore those directives where spaces _are_ permitted.
-			if ($name =~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/) {
+			if ($name =~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case|__asm__)$/) {
 
 			# cpp #define statements have non-optional spaces, ie
 			# if there is a space between the name and the open
@@ -1212,7 +1266,7 @@ sub process {
 				=>|->|<<|>>|<|>|=|!|~|
 				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
 			}x;
-			my @elements = split(/($ops|;)/, $opline);
+			my @elements = split(/($;+|$ops|;)/, $opline);
 			my $off = 0;
 
 			my $blank = copy_spacing($opline);
@@ -1272,8 +1326,15 @@ sub process {
 				#	print "UNARY: <$op_left$op_type $is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
 				#}
 
+				# Ignore operators passed as parameters.
+				if ($op_type ne 'V' &&
+				    $ca =~ /\s$/ && $cc =~ /^\s*,/) {
+
+				# Ignore comments
+				} elsif ($op =~ /^$;+$/) {
+
 				# ; should have either the end of line or a space or \ after it
-				if ($op eq ';') {
+				} elsif ($op eq ';') {
 					if ($ctx !~ /.x[WEB]/ && $cc !~ /^\\/ &&
 					    $cc !~ /^;/) {
 						ERROR("need space after that '$op' $at\n" . $hereptr);
@@ -1315,7 +1376,7 @@ sub process {
 					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOBE]/) {
 						ERROR("need space one side of that '$op' $at\n" . $hereptr);
 					}
-					if ($ctx =~ /Wx./ && $cc =~ /^;/) {
+					if ($ctx =~ /WxB/ || ($ctx =~ /Wx./ && $cc =~ /^;/)) {
 						ERROR("no space before that '$op' $at\n" . $hereptr);
 					}
 
@@ -1388,7 +1449,7 @@ sub process {
 		    $line !~ /for\s*\(\s+;/) {
 			ERROR("no space after that open parenthesis '('\n" . $herecurr);
 		}
-		if ($line =~ /\s\)/ && $line !~ /^.\s*\)/ &&
+		if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
 		    $line !~ /for\s*\(.*;\s+\)/) {
 			ERROR("no space before that close parenthesis ')'\n" . $herecurr);
 		}
@@ -1416,16 +1477,34 @@ sub process {
 			# conditional.
 			substr($s, 0, length($c)) = '';
 			$s =~ s/\n.*//g;
-
-			if (length($c) && $s !~ /^\s*({|;|\/\*.*\*\/)?\s*\\*\s*$/) {
+			$s =~ s/$;//g; 	# Remove any comments
+			if (length($c) && $s !~ /^\s*({|;|)\s*\\*\s*$/) {
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
 		}
 
+# Check for bitwise tests written as boolean
+		if ($line =~ /
+			(?:
+				(?:\[|\(|\&\&|\|\|)
+				\s*0[xX][0-9]+\s*
+				(?:\&\&|\|\|)
+			|
+				(?:\&\&|\|\|)
+				\s*0[xX][0-9]+\s*
+				(?:\&\&|\|\||\)|\])
+			)/x)
+		{
+			WARN("boolean test with hexadecimal, perhaps just 1 \& or \|?\n" . $herecurr);
+		}
+
 # if and else should not have general statements after it
-		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
-		    $1 !~ /^\s*(?:\sif|{|\\|$)/) {
-			ERROR("trailing statements should be on next line\n" . $herecurr);
+		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/) {
+			my $s = $1;
+			$s =~ s/$;//g; 	# Remove any comments
+			if ($s !~ /^\s*(?:\sif|(?:{|)\s*\\?\s*$)/) {
+				ERROR("trailing statements should be on next line\n" . $herecurr);
+			}
 		}
 
 		# Check for }<nl>else {, these must be at the same
@@ -1518,7 +1597,48 @@ sub process {
 		}
 
 # check for redundant bracing round if etc
-		if ($line =~ /\b(if|while|for|else)\b/) {
+		if ($line =~ /(^.*)\bif\b/ && $1 !~ /else\s*$/) {
+			my ($level, $endln, @chunks) =
+				ctx_statement_full($linenr, $realcnt, 0);
+			#print "chunks<$#chunks> linenr<$linenr> endln<$endln> level<$level>\n";
+			if ($#chunks > 1 && $level == 0) {
+				my $allowed = 0;
+				my $seen = 0;
+				for my $chunk (@chunks) {
+					my ($cond, $block) = @{$chunk};
+
+					substr($block, 0, length($cond)) = '';
+
+					$seen++ if ($block =~ /^\s*{/);
+
+					$block =~ s/(^|\n)./$1/g;
+					$block =~ s/^\s*{//;
+					$block =~ s/}\s*$//;
+					$block =~ s/^\s*//;
+					$block =~ s/\s*$//;
+
+					my @lines = ($block =~ /\n/g);
+					my @statements = ($block =~ /;/g);
+
+					#print "cond<$cond> block<$block> lines<" . scalar(@lines) . "> statements<" . scalar(@statements) . "> seen<$seen> allowed<$allowed>\n";
+					if (scalar(@lines) != 0) {
+						$allowed = 1;
+					}
+					if ($block =~/\b(?:if|for|while)\b/) {
+						$allowed = 1;
+					}
+					if (scalar(@statements) > 1) {
+						$allowed = 1;
+					}
+				}
+				if ($seen && !$allowed) {
+					WARN("braces {} are not necessary for any arm of this statement\n" . $herecurr);
+					$suppress_ifbraces = $endln;
+				}
+			}
+		}
+		if ($linenr > $suppress_ifbraces &&
+					$line =~ /\b(if|while|for|else)\b/) {
 			# Locate the end of the opening statement.
 			my @control = ctx_statement($linenr, $realcnt, 0);
 			my $nr = $linenr + (scalar(@control) - 1);
@@ -1541,7 +1661,7 @@ sub process {
 				my $after = $1;
 
 				#print "block<" . join(' ', @block) . "><" . scalar(@block) . ">\n";
-				#print "stmt<$stmt>\n\n";
+				#print "before<$before> stmt<$stmt> after<$after>\n\n";
 
 				# Count the newlines, if there is only one
 				# then the block should not have {}'s.
@@ -1659,6 +1779,17 @@ sub process {
 		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
 			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
+
+# check for gcc specific __FUNCTION__
+		if ($line =~ /__FUNCTION__/) {
+			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
+		}
+	}
+
+	# If we have no input at all, then there is nothing to report on
+	# so just keep quiet.
+	if ($#rawlines == -1) {
+		exit(0);
 	}
 
 	# In mailback mode only produce a report in the negative, for
@@ -1681,7 +1812,8 @@ sub process {
 	}
 
 	print report_dump();
-	if ($summary) {
+	if ($summary && !($clean == 1 && $quiet == 1)) {
+		print "$filename " if ($summary_file);
 		print "total: $cnt_error errors, $cnt_warn warnings, " .
 			(($check)? "$cnt_chk checks, " : "") .
 			"$cnt_lines lines checked\n";
@@ -1696,5 +1828,15 @@ sub process {
 		print "are false positives report them to the maintainer, see\n";
 		print "CHECKPATCH in MAINTAINERS.\n";
 	}
+	print <<EOL if ($file == 1 && $quiet == 0);
+
+WARNING: Using --file mode. Please do not send patches to linux-kernel
+that change whole existing files if you did not significantly change most
+of the the file for other reasons anyways or just wrote the file newly
+from scratch. Pure code style patches have a significant cost in a
+quickly changing code base like Linux because they cause rejects
+with other changes.
+EOL
+
 	return $clean;
 }
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
claim-maintainership-for-block2mtd-and-update-email-addresses.patch
update-checkpatchpl-to-version-013.patch
update-checkpatchpl-to-version-014.patch
page-owner-tracking-leak-detector.patch
