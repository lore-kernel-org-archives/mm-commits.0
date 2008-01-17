From: akpm@linux-foundation.org
Subject: + update-checkpatchpl-to-version-013.patch added to -mm tree
Date: Thu, 17 Jan 2008 11:19:34 -0800
Message-ID: <200801171919.m0HJJF5K008416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbYAQTT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 14:19:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     update checkpatch.pl to version 0.13
has been added to the -mm tree.  Its filename is
     update-checkpatchpl-to-version-013.patch

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
Subject: update checkpatch.pl to version 0.13
From: Andy Whitcroft <apw@shadowen.org>

This version brings a large number of fixes which have built up over
the Christmas period.  Mostly these are fixes for false positives, both
through improvments to unary checks and possible type detection.  It
also brings new checks for while location and CVS keywords.  Of note:

  - a number of fixes to unary detection
  - detection of a number of new forms of types to improve type matching
  - better inline handling
  - recognision of '%' as an operator

Andy Whitcroft (28):
      Version: 0.13
      unary detection: maintain bracket state across lines
      move to pre-sanitising the entire file
      the text of a #error statement should be treated like it is in quotes
      line sanitisation needs to target double backslash correctly
      tighten comment guestimation for lines starting ' * '
      debug: add a debug framework
      prevent unclosed single quotes from spreading
      add % as an operator
      the text of a #warning statement should be treated like it is in quotes
      possible matching applies in typedefs
      single statement block checks must not trigger when two or more statements
      possible types: local variables may also be const
      treat inline as a type attribute to even when out of place
      possible types: sparse annotations are valid indicators
      possible types: beef up the possible type testing
      check for hanging while statements on the wrong line
      utf8 checks need to occur against the raw lines
      function brace checks should use any whitespece matches
      comments should take up space in the line when sanitised
      remove debugging from if assignment checks
      possible types -- ensure we detect all pointer casts
      fix tests for function spacing in the presence of #define
      clean up the UTF-8 error message to be clearer
      test-lib: invert the status report, output success counts
      detect and report CVS keywords
      tests: break out tests
      Add $Id$ to the CVS keyword checks

Benny Halevy (1):
      checkpatch.pl: recognize the #elif preprocessor directive

Geert Uytterhoeven (1):
      print the filenames of patches where available

Mauro Carvalho Chehab (1):
      Fix missing \n in checkpatch.pl

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  296 ++++++++++++++++++++++++++--------------
 1 file changed, 199 insertions(+), 97 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-013 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-013
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.12';
+my $V = '0.13';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -25,6 +25,7 @@ my $check = 0;
 my $summary = 1;
 my $mailback = 0;
 my $root;
+my %debug;
 GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
@@ -39,6 +40,7 @@ GetOptions(
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
+	'debug=s'	=> \%debug,
 ) or exit;
 
 my $exit = 0;
@@ -56,6 +58,12 @@ if ($#ARGV < 0) {
 	exit(1);
 }
 
+my $dbg_values = 0;
+my $dbg_possible = 0;
+for my $key (keys %debug) {
+	eval "\${dbg_$key} = '$debug{$key}';"
+}
+
 if ($terse) {
 	$emacs = 1;
 	$quiet++;
@@ -110,7 +118,7 @@ our $Assignment	= qr{(?:\*\=|/=|%=|\+=|-
 our $Operators	= qr{
 			<=|>=|==|!=|
 			=>|->|<<|>>|<|>|!|~|
-			&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/
+			&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
 		  }x;
 
 our $NonptrType;
@@ -152,7 +160,7 @@ sub build_types {
 	$Type	= qr{
 			\b$NonptrType\b
 			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
-			(?:\s+$Sparse|\s+$Attribute)*
+			(?:\s+$Inline|\s+$Sparse|\s+$Attribute)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
 }
@@ -181,6 +189,8 @@ if ($tree && -f "$root/$removal") {
 }
 
 my @rawlines = ();
+my @lines = ();
+my $vname;
 for my $filename (@ARGV) {
 	if ($file) {
 		open(FILE, "diff -u /dev/null $filename|") ||
@@ -189,12 +199,17 @@ for my $filename (@ARGV) {
 		open(FILE, "<$filename") ||
 			die "$P: $filename: open failed - $!\n";
 	}
+	if ($filename eq '-') {
+		$vname = 'Your patch';
+	} else {
+		$vname = $filename;
+	}
 	while (<FILE>) {
 		chomp;
 		push(@rawlines, $_);
 	}
 	close(FILE);
-	if (!process($filename, @rawlines)) {
+	if (!process($filename)) {
 		$exit = 1;
 	}
 	@rawlines = ();
@@ -274,20 +289,30 @@ sub sanitise_line {
 	my $l = '';
 
 	my $quote = '';
+	my $qlen = 0;
 
 	foreach my $c (split(//, $line)) {
+		# The second backslash of a pair is not a "quote".
+		if ($l eq "\\" && $c eq "\\") {
+			$c = 'X';
+		}
 		if ($l ne "\\" && ($c eq "'" || $c eq '"')) {
 			if ($quote eq '') {
 				$quote = $c;
 				$res .= $c;
 				$l = $c;
+				$qlen = 0;
 				next;
 			} elsif ($quote eq $c) {
 				$quote = '';
 			}
 		}
+		if ($quote eq "'" && $qlen > 1) {
+			$quote = '';
+		}
 		if ($quote && $c ne "\t") {
 			$res .= "X";
+			$qlen++;
 		} else {
 			$res .= $c;
 		}
@@ -295,6 +320,28 @@ sub sanitise_line {
 		$l = $c;
 	}
 
+	# Clear out the comments.
+	while ($res =~ m@(/\*.*?\*/)@) {
+		substr($res, $-[1], $+[1] - $-[1]) = ' ' x ($+[1] - $-[1]);
+	}
+	if ($res =~ m@(/\*.*)@) {
+		substr($res, $-[1], $+[1] - $-[1]) = ' ' x ($+[1] - $-[1]);
+	}
+	if ($res =~ m@^.(.*\*/)@) {
+		substr($res, $-[1], $+[1] - $-[1]) = ' ' x ($+[1] - $-[1]);
+	}
+
+	# The pathname on a #include may be surrounded by '<' and '>'.
+	if ($res =~ /^.#\s*include\s+\<(.*)\>/) {
+		my $clean = 'X' x length($1);
+		$res =~ s@\<.*\>@<$clean>@;
+
+	# The whole of a #error is a string.
+	} elsif ($res =~ /^.#\s*(?:error|warning)\s+(.*)\b/) {
+		my $clean = 'X' x length($1);
+		$res =~ s@(#\s*(?:error|warning)\s+).*@$1$clean@;
+	}
+
 	return $res;
 }
 
@@ -315,9 +362,9 @@ sub ctx_statement_block {
 		# context.
 		if ($off >= $len) {
 			for (; $remain > 0; $line++) {
-				next if ($rawlines[$line] =~ /^-/);
+				next if ($lines[$line] =~ /^-/);
 				$remain--;
-				$blk .= sanitise_line($rawlines[$line]) . "\n";
+				$blk .= $lines[$line] . "\n";
 				$len = length($blk);
 				$line++;
 				last;
@@ -500,103 +547,106 @@ sub cat_vet {
 	return $res;
 }
 
+my $av_preprocessor = 0;
+my $av_paren = 0;
+my @av_paren_type;
+
+sub annotate_reset {
+	$av_preprocessor = 0;
+	$av_paren = 0;
+	@av_paren_type = ();
+}
+
 sub annotate_values {
 	my ($stream, $type) = @_;
 
 	my $res;
 	my $cur = $stream;
 
-	my $debug = 0;
-
-	print "$stream\n" if ($debug);
-
-	##my $type = 'N';
-	my $pos = 0;
-	my $preprocessor = 0;
-	my $paren = 0;
-	my @paren_type;
+	print "$stream\n" if ($dbg_values > 1);
 
 	while (length($cur)) {
-		print " <$type> " if ($debug);
+		print " <$type> " if ($dbg_values > 1);
 		if ($cur =~ /^(\s+)/o) {
-			print "WS($1)\n" if ($debug);
-			if ($1 =~ /\n/ && $preprocessor) {
-				$preprocessor = 0;
+			print "WS($1)\n" if ($dbg_values > 1);
+			if ($1 =~ /\n/ && $av_preprocessor) {
+				$av_preprocessor = 0;
 				$type = 'N';
 			}
 
 		} elsif ($cur =~ /^($Type)/) {
-			print "DECLARE($1)\n" if ($debug);
+			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
 
 		} elsif ($cur =~ /^(#\s*define\s*$Ident)(\(?)/o) {
-			print "DEFINE($1)\n" if ($debug);
-			$preprocessor = 1;
-			$paren_type[$paren] = 'N';
-
-		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if|else|endif))/o) {
-			print "PRE($1)\n" if ($debug);
-			$preprocessor = 1;
+			print "DEFINE($1)\n" if ($dbg_values > 1);
+			$av_preprocessor = 1;
+			$av_paren_type[$av_paren] = 'N';
+
+		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if|else|elif|endif))/o) {
+			print "PRE($1)\n" if ($dbg_values > 1);
+			$av_preprocessor = 1;
 			$type = 'N';
 
 		} elsif ($cur =~ /^(\\\n)/o) {
-			print "PRECONT($1)\n" if ($debug);
+			print "PRECONT($1)\n" if ($dbg_values > 1);
 
 		} elsif ($cur =~ /^(sizeof)\s*(\()?/o) {
-			print "SIZEOF($1)\n" if ($debug);
+			print "SIZEOF($1)\n" if ($dbg_values > 1);
 			if (defined $2) {
-				$paren_type[$paren] = 'V';
+				$av_paren_type[$av_paren] = 'V';
 			}
 			$type = 'N';
 
 		} elsif ($cur =~ /^(if|while|typeof|for)\b/o) {
-			print "COND($1)\n" if ($debug);
-			$paren_type[$paren] = 'N';
+			print "COND($1)\n" if ($dbg_values > 1);
+			$av_paren_type[$av_paren] = 'N';
 			$type = 'N';
 
 		} elsif ($cur =~/^(return|case|else)/o) {
-			print "KEYWORD($1)\n" if ($debug);
+			print "KEYWORD($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
 		} elsif ($cur =~ /^(\()/o) {
-			print "PAREN('$1')\n" if ($debug);
-			$paren++;
+			print "PAREN('$1')\n" if ($dbg_values > 1);
+			$av_paren++;
 			$type = 'N';
 
 		} elsif ($cur =~ /^(\))/o) {
-			$paren-- if ($paren > 0);
-			if (defined $paren_type[$paren]) {
-				$type = $paren_type[$paren];
-				undef $paren_type[$paren];
-				print "PAREN('$1') -> $type\n" if ($debug);
+			$av_paren-- if ($av_paren > 0);
+			if (defined $av_paren_type[$av_paren]) {
+				$type = $av_paren_type[$av_paren];
+				undef $av_paren_type[$av_paren];
+				print "PAREN('$1') -> $type\n"
+							if ($dbg_values > 1);
 			} else {
-				print "PAREN('$1')\n" if ($debug);
+				print "PAREN('$1')\n" if ($dbg_values > 1);
 			}
 
 		} elsif ($cur =~ /^($Ident)\(/o) {
-			print "FUNC($1)\n" if ($debug);
-			$paren_type[$paren] = 'V';
+			print "FUNC($1)\n" if ($dbg_values > 1);
+			$av_paren_type[$av_paren] = 'V';
 
 		} elsif ($cur =~ /^($Ident|$Constant)/o) {
-			print "IDENT($1)\n" if ($debug);
+			print "IDENT($1)\n" if ($dbg_values > 1);
 			$type = 'V';
 
 		} elsif ($cur =~ /^($Assignment)/o) {
-			print "ASSIGN($1)\n" if ($debug);
+			print "ASSIGN($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
 		} elsif ($cur =~ /^(;|{|}|\?|:|\[)/o) {
-			print "END($1)\n" if ($debug);
+			print "END($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
 		} elsif ($cur =~ /^($Operators)/o) {
-			print "OP($1)\n" if ($debug);
+			print "OP($1)\n" if ($dbg_values > 1);
 			if ($1 ne '++' && $1 ne '--') {
 				$type = 'N';
 			}
 
 		} elsif ($cur =~ /(^.)/o) {
-			print "C($1)\n" if ($debug);
+			print "C($1)\n" if ($dbg_values > 1);
 		}
 		if (defined $1) {
 			$cur = substr($cur, length($1));
@@ -616,7 +666,7 @@ sub possible {
 	    $possible ne 'struct' && $possible ne 'enum' &&
 	    $possible ne 'case' && $possible ne 'else' &&
 	    $possible ne 'typedef') {
-		#print "POSSIBLE<$possible>\n";
+		warn "POSSIBLE: $possible\n" if ($dbg_possible);
 		push(@typeList, $possible);
 		build_types();
 	}
@@ -655,11 +705,12 @@ sub CHK {
 
 sub process {
 	my $filename = shift;
-	my @lines = @_;
 
 	my $linenr=0;
 	my $prevline="";
+	my $prevrawline="";
 	my $stashline="";
+	my $stashrawline="";
 
 	my $length;
 	my $indent;
@@ -681,14 +732,26 @@ sub process {
 	my $realcnt = 0;
 	my $here = '';
 	my $in_comment = 0;
+	my $comment_edge = 0;
 	my $first_line = 0;
 
 	my $prev_values = 'N';
 
+	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
+	#
 	my @setup_docs = ();
 	my $setup_docs = 0;
-	foreach my $line (@lines) {
+	my $line;
+	foreach my $rawline (@rawlines) {
+		# Standardise the strings and chars within the input to
+		# simplify matching.
+		$line = sanitise_line($rawline);
+		push(@lines, $line);
+
+		##print "==>$rawline\n";
+		##print "-->$line\n";
+
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$setup_docs = 0;
 			if ($1 =~ m@Documentation/kernel-parameters.txt$@) {
@@ -707,8 +770,7 @@ sub process {
 	foreach my $line (@lines) {
 		$linenr++;
 
-		my $rawline = $line;
-
+		my $rawline = $rawlines[$linenr - 1];
 
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
@@ -728,6 +790,7 @@ sub process {
 			} else {
 				$realcnt=1+1;
 			}
+			annotate_reset();
 			$prev_values = 'N';
 			next;
 		}
@@ -746,7 +809,7 @@ sub process {
 			if ($linenr == $first_line) {
 				my $edge;
 				for (my $ln = $first_line; $ln < ($linenr + $realcnt); $ln++) {
-					($edge) = ($lines[$ln - 1] =~ m@(/\*|\*/)@);
+					($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
 					last if (defined $edge);
 				}
 				if (defined $edge && $edge eq '*/') {
@@ -757,25 +820,30 @@ sub process {
 			# Guestimate if this is a continuing comment.  If this
 			# is the start of a diff block and this line starts
 			# ' *' then it is very likely a comment.
-			if ($linenr == $first_line and $line =~ m@^.\s*\*@) {
+			if ($linenr == $first_line and $rawline =~ m@^.\s* \*(?:\s|$)@) {
 				$in_comment = 1;
 			}
 
 			# Find the last comment edge on _this_ line.
-			while (($line =~ m@(/\*|\*/)@g)) {
+			$comment_edge = 0;
+			while (($rawline =~ m@(/\*|\*/)@g)) {
 				if ($1 eq '/*') {
 					$in_comment = 1;
 				} else {
 					$in_comment = 0;
 				}
+				$comment_edge = 1;
 			}
 
 			# Measure the line length and indent.
-			($length, $indent) = line_stats($line);
+			($length, $indent) = line_stats($rawline);
 
 			# Track the previous line.
 			($prevline, $stashline) = ($stashline, $line);
 			($previndent, $stashindent) = ($stashindent, $indent);
+			($prevrawline, $stashrawline) = ($stashrawline, $rawline);
+
+			#warn "ic<$in_comment> ce<$comment_edge> line<$line>\n";
 
 		} elsif ($realcnt == 1) {
 			$realcnt--;
@@ -786,9 +854,9 @@ sub process {
 		$here = "#$realline: " if ($file);
 		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
 
-		my $hereline = "$here\n$line\n";
-		my $herecurr = "$here\n$line\n";
-		my $hereprev = "$here\n$prevline\n$line\n";
+		my $hereline = "$here\n$rawline\n";
+		my $herecurr = "$here\n$rawline\n";
+		my $hereprev = "$here\n$prevrawline\n$rawline\n";
 
 		$prefix = "$filename:$realline: " if ($emacs && $file);
 		$prefix = "$filename:$linenr: " if ($emacs && !$file);
@@ -816,7 +884,7 @@ sub process {
 
 # UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
 		if (($realfile =~ /^$/ || $line =~ /^\+/) &&
-		     !($line =~ m/^(
+		     !($rawline =~ m/^(
 				[\x09\x0A\x0D\x20-\x7E]              # ASCII
 				| [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
 				|  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
@@ -826,7 +894,7 @@ sub process {
 				| [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
 				|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
 				)*$/x )) {
-			ERROR("Invalid UTF-8\n" . $herecurr);
+			ERROR("Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $herecurr);
 		}
 
 #ignore lines being removed
@@ -837,15 +905,15 @@ sub process {
 
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
-			my $herevet = "$here\n" . cat_vet($line) . "\n";
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("DOS line endings\n" . $herevet);
 
-		} elsif ($line =~ /^\+.*\S\s+$/ || $line =~ /^\+\s+$/) {
-			my $herevet = "$here\n" . cat_vet($line) . "\n";
+		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("trailing whitespace\n" . $herevet);
 		}
 #80 column limit
-		if ($line =~ /^\+/ && !($prevline=~/\/\*\*/) && $length > 80) {
+		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && $length > 80) {
 			WARN("line over 80 characters\n" . $herecurr);
 		}
 
@@ -859,46 +927,48 @@ sub process {
 
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
-		if ($line=~/^\+\s* \t\s*\S/ or $line=~/^\+\s*        \s*/) {
-			my $herevet = "$here\n" . cat_vet($line) . "\n";
+		if ($rawline =~ /^\+\s* \t\s*\S/ ||
+		    $rawline =~ /^\+\s*        \s*/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("use tabs not spaces\n" . $herevet);
 		}
 
-# Remove comments from the line before processing.
-		my $comment_edge = ($line =~ s@/\*.*\*/@@g) +
-				   ($line =~ s@/\*.*@@) +
-				   ($line =~ s@^(.).*\*/@$1@);
+# check for RCS/CVS revision markers
+		if ($rawline =~ /\$(Revision|Log|Id)(?:\$|)/) {
+			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
+		}
 
 # The rest of our checks refer specifically to C style
 # only apply those _outside_ comments.  Only skip
 # lines in the middle of comments.
 		next if (!$comment_edge && $in_comment);
 
-# Standardise the strings and chars within the input to simplify matching.
-		$line = sanitise_line($line);
-
 # Check for potential 'bare' types
-		if ($realcnt &&
-		    $line !~ /$Ident:\s*$/ &&
-		    ($line =~ /^.\s*$Ident\s*\(\*+\s*$Ident\)\s*\(/ ||
-		     $line !~ /^.\s*$Ident\s*\(/)) {
+		if ($realcnt) {
+			# Ignore goto labels.
+			if ($line =~ /$Ident:\*$/) {
+
+			# Ignore functions being called
+			} elsif ($line =~ /^.\s*$Ident\s*\(/) {
+
 			# definitions in global scope can only start with types
-			if ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/) {
+			} elsif ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/) {
 				possible($1);
 
 			# declarations always start with types
-			} elsif ($prev_values eq 'N' && $line =~ /^.\s*(?:$Storage\s+)?($Ident)\b\s*\**\s*$Ident\s*(?:;|=)/) {
+			} elsif ($prev_values eq 'N' && $line =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=)/) {
 				possible($1);
+			}
 
 			# any (foo ... *) is a pointer cast, and foo is a type
-			} elsif ($line =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/) {
+			while ($line =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/g) {
 				possible($1);
 			}
 
 			# Check for any sort of function declaration.
 			# int foo(something bar, other baz);
 			# void (*store_gdt)(x86_descr_ptr *);
-			if ($prev_values eq 'N' && $line =~ /^(.(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {
+			if ($prev_values eq 'N' && $line =~ /^(.(?:typedef\s*)?(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {
 				my ($name_len) = length($1);
 				my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, $name_len);
 				my $ctx = join("\n", @ctx);
@@ -974,8 +1044,11 @@ sub process {
 		my $opline = $line; $opline =~ s/^./ /;
 		my $curr_values = annotate_values($opline . "\n", $prev_values);
 		$curr_values = $prev_values . $curr_values;
-		#warn "--> $opline\n";
-		#warn "--> $curr_values ($prev_values)\n";
+		if ($dbg_values) {
+			my $outline = $opline; $outline =~ s/\t/ /g;
+			warn "--> .$outline\n";
+			warn "--> $curr_values\n";
+		}
 		$prev_values = substr($curr_values, -1);
 
 #ignore lines not being added
@@ -1004,9 +1077,6 @@ sub process {
 				ERROR("malformed #include filename\n" .
 					$herecurr);
 			}
-			# Sanitise this special form of string.
-			$path = 'X' x length($path);
-			$line =~ s{\<.*\>}{<$path>};
 		}
 
 # no C99 // comments
@@ -1074,7 +1144,7 @@ sub process {
 # 		}
 
 		if ($line =~ /\bLINUX_VERSION_CODE\b/) {
-			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged" . $herecurr);
+			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
 		}
 
 # printk should use KERN_* levels.  Note that follow on printk's on the
@@ -1102,7 +1172,7 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/$Type\s*[A-Za-z\d_]+\(.*\).* {/) and
+		if (($line=~/$Type\s*[A-Za-z\d_]+\(.*\).*\s{/) and
 		    !($line=~/\#define.*do\s{/) and !($line=~/}/)) {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
@@ -1115,8 +1185,22 @@ sub process {
 
 # check for spaces between functions and their parentheses.
 		while ($line =~ /($Ident)\s+\(/g) {
-			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/ &&
-		            $line !~ /$Type\s+\(/ && $line !~ /^.\#\s*define\b/) {
+			my $name = $1;
+			my $ctx = substr($line, 0, $-[1]);
+
+			# Ignore those directives where spaces _are_ permitted.
+			if ($name =~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/) {
+
+			# cpp #define statements have non-optional spaces, ie
+			# if there is a space between the name and the open
+			# parenthesis it is simply not a parameter group.
+			} elsif ($ctx =~ /^.\#\s*define\s*$/) {
+
+			# If this whole things ends with a type its most
+			# likely a typedef for a function.
+			} elsif ("$ctx$name" =~ /$Type$/) {
+
+			} else {
 				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
@@ -1126,7 +1210,7 @@ sub process {
 				<<=|>>=|<=|>=|==|!=|
 				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
 				=>|->|<<|>>|<|>|=|!|~|
-				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/
+				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
 			}x;
 			my @elements = split(/($ops|;)/, $opline);
 			my $off = 0;
@@ -1239,7 +1323,8 @@ sub process {
 				} elsif ($op eq '<<' or $op eq '>>' or
 					 $op eq '&' or $op eq '^' or $op eq '|' or
 					 $op eq '+' or $op eq '-' or
-					 $op eq '*' or $op eq '/')
+					 $op eq '*' or $op eq '/' or
+					 $op eq '%')
 				{
 					if ($ctx !~ /VxV|WxW|VxE|WxE|VxO/) {
 						ERROR("need consistent spacing around '$op' $at\n" .
@@ -1324,7 +1409,7 @@ sub process {
 			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
 
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
-				ERROR("do not use assignment in if condition ($c)\n" . $herecurr);
+				ERROR("do not use assignment in if condition\n" . $herecurr);
 			}
 
 			# Find out what is on the end of the line after the
@@ -1350,6 +1435,20 @@ sub process {
 			ERROR("else should follow close brace '}'\n" . $hereprev);
 		}
 
+		if ($prevline=~/}\s*$/ and $line=~/^.\s*while\s*/ and
+						$previndent == $indent) {
+			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
+
+			# Find out what is on the end of the line after the
+			# conditional.
+			substr($s, 0, length($c)) = '';
+			$s =~ s/\n.*//g;
+
+			if ($s =~ /^\s*;/) {
+				ERROR("while should follow close brace '}'\n" . $hereprev);
+			}
+		}
+
 #studly caps, commented out until figure out how to distinguish between use of existing and adding new
 #		if (($line=~/[\w_][a-z\d]+[A-Z]/) and !($line=~/print/)) {
 #		    print "No studly caps, use _\n";
@@ -1447,8 +1546,11 @@ sub process {
 				# Count the newlines, if there is only one
 				# then the block should not have {}'s.
 				my @lines = ($stmt =~ /\n/g);
+				my @statements = ($stmt =~ /;/g);
 				#print "lines<" . scalar(@lines) . ">\n";
+				#print "statements<" . scalar(@statements) . ">\n";
 				if ($lvl == 0 && scalar(@lines) == 0 &&
+				    scalar(@statements) < 2 &&
 				    $stmt !~ /{/ && $stmt !~ /\bif\b/ &&
 				    $before !~ /}/ && $after !~ /{/) {
 				    	my $herectx = "$here\n" . join("\n", @control, @block[1 .. $#block]) . "\n";
@@ -1587,10 +1689,10 @@ sub process {
 	}
 
 	if ($clean == 1 && $quiet == 0) {
-		print "Your patch has no obvious style problems and is ready for submission.\n"
+		print "$vname has no obvious style problems and is ready for submission.\n"
 	}
 	if ($clean == 0 && $quiet == 0) {
-		print "Your patch has style problems, please review.  If any of these errors\n";
+		print "$vname has style problems, please review.  If any of these errors\n";
 		print "are false positives report them to the maintainer, see\n";
 		print "CHECKPATCH in MAINTAINERS.\n";
 	}
_

Patches currently in -mm which might be from apw@shadowen.org are

git-x86.patch
fix-missing-n-in-checkpatchpl.patch
claim-maintainership-for-block2mtd-and-update-email-addresses.patch
update-checkpatchpl-to-version-013.patch
page-owner-tracking-leak-detector.patch
