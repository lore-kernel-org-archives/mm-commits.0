From: akpm@linux-foundation.org
Subject: - update-checkpatchpl-to-version-016.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:17:43 -0700
Message-ID: <200803312017.m2VKHh8K023992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577AbYCaUav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     update checkpatch.pl to version 0.16
has been removed from the -mm tree.  Its filename was
     update-checkpatchpl-to-version-016.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update checkpatch.pl to version 0.16
From: Andy Whitcroft <apw@shadowen.org>

This version brings proper quote tracking across lines, and brings the
handling of comments into the same mechanism ensuring nesting is correctly
handled.  It brings the usual flurry of fixes for false positives.  It also
brings a number of new checks.  The most contentious change will likely be
the checks for NR_CPUS as this throws some new warnings in kernel/sched.c.

Of note:
 - all new quote tracking across lines
 - all new comment tracking
 - new more direct, less ambigious wording for some warnings
 - recommends mutexes and completions over semaphores
 - recommends strict_strto* over simple_strto*
 - report on direct use of NR_CPUS

Andy Whitcroft (22):
      Version: 0.16
      string quote tracking should cross line boundaries
      check spacing round -> correctly across newlines
      checks for linux/ against asm/ include files should be warnings
      standardise on 'required' and 'prohibited'
      take the first end of condition when parsing statements
      values: cope with unbalanced brackets
      preprocessor #elif is not a function
      preprocessor #if should not trigger trailing statement checks
      test: allow us to limit output to a single error
      recommend real mutexes over semaphores
      asm checks should mirror those for __asm__
      warn on semaphores being used in place of completions
      trailing ; on control structure should ignore do {} while ();
      recommend strict_strtoX over simple_strtoX
      redo comment handling as a quote type
      use of NR_CPUS is normally wrong
      consistant spacing should only be about spaces
      if brace check suppression should only apply to the top-levels
      use tr/// to align spacing for operators
      move to using four parameter form of substr
      check and report modifications to include/asm

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  463 ++++++++++++++++++++++++----------------
 1 file changed, 279 insertions(+), 184 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-016 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-016
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.15';
+my $V = '0.16';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -18,6 +18,7 @@ my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
 my $tst_type = 0;
+my $tst_only;
 my $emacs = 0;
 my $terse = 0;
 my $file = 0;
@@ -44,6 +45,7 @@ GetOptions(
 
 	'debug=s'	=> \%debug,
 	'test-type!'	=> \$tst_type,
+	'test-only=s'	=> \$tst_only,
 ) or exit;
 
 my $exit = 0;
@@ -263,17 +265,7 @@ sub expand_tabs {
 	return $res;
 }
 sub copy_spacing {
-	my ($str) = @_;
-
-	my $res = '';
-	for my $c (split(//, $str)) {
-		if ($c eq "\t") {
-			$res .= $c;
-		} else {
-			$res .= ' ';
-		}
-	}
-
+	(my $res = shift) =~ tr/\t/ /c;
 	return $res;
 }
 
@@ -290,53 +282,76 @@ sub line_stats {
 	return (length($line), length($white));
 }
 
+my $sanitise_quote = '';
+
+sub sanitise_line_reset {
+	my ($in_comment) = @_;
+
+	if ($in_comment) {
+		$sanitise_quote = '*/';
+	} else {
+		$sanitise_quote = '';
+	}
+}
 sub sanitise_line {
 	my ($line) = @_;
 
 	my $res = '';
 	my $l = '';
 
-	my $quote = '';
 	my $qlen = 0;
+	my $off = 0;
+	my $c;
 
-	foreach my $c (split(//, $line)) {
-		# The second backslash of a pair is not a "quote".
-		if ($l eq "\\" && $c eq "\\") {
-			$c = 'X';
-		}
-		if ($l ne "\\" && ($c eq "'" || $c eq '"')) {
-			if ($quote eq '') {
-				$quote = $c;
-				$res .= $c;
-				$l = $c;
-				$qlen = 0;
-				next;
-			} elsif ($quote eq $c) {
-				$quote = '';
-			}
+	# Always copy over the diff marker.
+	$res = substr($line, 0, 1);
+
+	for ($off = 1; $off < length($line); $off++) {
+		$c = substr($line, $off, 1);
+
+		# Comments we are wacking completly including the begin
+		# and end, all to $;.
+		if ($sanitise_quote eq '' && substr($line, $off, 2) eq '/*') {
+			$sanitise_quote = '*/';
+
+			substr($res, $off, 2, "$;$;");
+			$off++;
+			next;
 		}
-		if ($quote eq "'" && $qlen > 1) {
-			$quote = '';
+		if (substr($line, $off, 2) eq $sanitise_quote) {
+			$sanitise_quote = '';
+			substr($res, $off, 2, "$;$;");
+			$off++;
+			next;
 		}
-		if ($quote && $c ne "\t") {
-			$res .= "X";
-			$qlen++;
-		} else {
-			$res .= $c;
+
+		# A \ in a string means ignore the next character.
+		if (($sanitise_quote eq "'" || $sanitise_quote eq '"') &&
+		    $c eq "\\") {
+			substr($res, $off, 2, 'XX');
+			$off++;
+			next;
 		}
+		# Regular quotes.
+		if ($c eq "'" || $c eq '"') {
+			if ($sanitise_quote eq '') {
+				$sanitise_quote = $c;
 
-		$l = $c;
-	}
+				substr($res, $off, 1, $c);
+				next;
+			} elsif ($sanitise_quote eq $c) {
+				$sanitise_quote = '';
+			}
+		}
 
-	# Clear out the comments.
-	while ($res =~ m@(/\*.*?\*/)@g) {
-		substr($res, $-[1], $+[1] - $-[1]) = $; x ($+[1] - $-[1]);
-	}
-	if ($res =~ m@(/\*.*)@) {
-		substr($res, $-[1], $+[1] - $-[1]) = $; x ($+[1] - $-[1]);
-	}
-	if ($res =~ m@^.(.*\*/)@) {
-		substr($res, $-[1], $+[1] - $-[1]) = $; x ($+[1] - $-[1]);
+		#print "SQ:$sanitise_quote\n";
+		if ($off != 0 && $sanitise_quote eq '*/' && $c ne "\t") {
+			substr($res, $off, 1, $;);
+		} elsif ($off != 0 && $sanitise_quote && $c ne "\t") {
+			substr($res, $off, 1, 'X');
+		} else {
+			substr($res, $off, 1, $c);
+		}
 	}
 
 	# The pathname on a #include may be surrounded by '<' and '>'.
@@ -359,6 +374,7 @@ sub ctx_statement_block {
 	my $blk = '';
 	my $soff = $off;
 	my $coff = $off - 1;
+	my $coff_set = 0;
 
 	my $loff = 0;
 
@@ -370,7 +386,7 @@ sub ctx_statement_block {
 
 	my $remainder;
 	while (1) {
-		#warn "CSB: blk<$blk>\n";
+		#warn "CSB: blk<$blk> remain<$remain>\n";
 		# If we are about to drop off the end, pull in more
 		# context.
 		if ($off >= $len) {
@@ -393,7 +409,7 @@ sub ctx_statement_block {
 		$c = substr($blk, $off, 1);
 		$remainder = substr($blk, $off);
 
-		#warn "CSB: c<$c> type<$type> level<$level>\n";
+		#warn "CSB: c<$c> type<$type> level<$level> remainder<$remainder> coff_set<$coff_set>\n";
 		# Statement ends at the ';' or a close '}' at the
 		# outermost level.
 		if ($level == 0 && $c eq ';') {
@@ -401,10 +417,14 @@ sub ctx_statement_block {
 		}
 
 		# An else is really a conditional as long as its not else if
-		if ($level == 0 && (!defined($p) || $p =~ /(?:\s|\})/) &&
-				$remainder =~ /(else)(?:\s|{)/ &&
-				$remainder !~ /else\s+if\b/) {
-			$coff = $off + length($1);
+		if ($level == 0 && $coff_set == 0 &&
+				(!defined($p) || $p =~ /(?:\s|\}|\+)/) &&
+				$remainder =~ /^(else)(?:\s|{)/ &&
+				$remainder !~ /^else\s+if\b/) {
+			$coff = $off + length($1) - 1;
+			$coff_set = 1;
+			#warn "CSB: mark coff<$coff> soff<$soff> 1<$1>\n";
+			#warn "[" . substr($blk, $soff, $coff - $soff + 1) . "]\n";
 		}
 
 		if (($type eq '' || $type eq '(') && $c eq '(') {
@@ -417,6 +437,8 @@ sub ctx_statement_block {
 
 			if ($level == 0 && $coff < $soff) {
 				$coff = $off;
+				$coff_set = 1;
+				#warn "CSB: mark coff<$coff>\n";
 			}
 		}
 		if (($type eq '' || $type eq '{') && $c eq '{') {
@@ -444,7 +466,7 @@ sub ctx_statement_block {
 	#warn "STATEMENT<$statement>\n";
 	#warn "CONDITION<$condition>\n";
 
-	#print "off<$off> loff<$loff>\n";
+	#print "coff<$coff> soff<$off> loff<$loff>\n";
 
 	return ($statement, $condition,
 			$line, $remain + 1, $off - $loff + 1, $level);
@@ -502,7 +524,7 @@ sub ctx_statement_full {
 	# Grab the first conditional/block pair.
 	($statement, $condition, $linenr, $remain, $off, $level) =
 				ctx_statement_block($linenr, $remain, $off);
-	#print "F: c<$condition> s<$statement>\n";
+	#print "F: c<$condition> s<$statement> remain<$remain>\n";
 	push(@chunks, [ $condition, $statement ]);
 	if (!($remain > 0 && $condition =~ /^\s*(?:\n[+-])?\s*(?:if|else|do)\b/s)) {
 		return ($level, $linenr, @chunks);
@@ -514,7 +536,7 @@ sub ctx_statement_full {
 		($statement, $condition, $linenr, $remain, $off, $level) =
 				ctx_statement_block($linenr, $remain, $off);
 		#print "C: c<$condition> s<$statement> remain<$remain>\n";
-		last if (!($remain > 0 && $condition =~ /^\s*(?:\n[+-])?\s*(?:else|do)\b/s));
+		last if (!($remain > 0 && $condition =~ /^(?:\s*\n[+-])*\s*(?:else|do)\b/s));
 		#print "C: push\n";
 		push(@chunks, [ $condition, $statement ]);
 	}
@@ -668,6 +690,7 @@ sub annotate_values {
 	print "$stream\n" if ($dbg_values > 1);
 
 	while (length($cur)) {
+		@av_paren_type = ('E') if ($#av_paren_type < 0);
 		print " <" . join('', @av_paren_type) .
 					"> <$type> " if ($dbg_values > 1);
 		if ($cur =~ /^(\s+)/o) {
@@ -804,28 +827,34 @@ sub possible {
 my $prefix = '';
 
 sub report {
+	if (defined $tst_only && $_[0] !~ /\Q$tst_only\E/) {
+		return 0;
+	}
 	my $line = $prefix . $_[0];
 
 	$line = (split('\n', $line))[0] . "\n" if ($terse);
 
 	push(our @report, $line);
+
+	return 1;
 }
 sub report_dump {
 	our @report;
 }
 sub ERROR {
-	report("ERROR: $_[0]\n");
-	our $clean = 0;
-	our $cnt_error++;
+	if (report("ERROR: $_[0]\n")) {
+		our $clean = 0;
+		our $cnt_error++;
+	}
 }
 sub WARN {
-	report("WARNING: $_[0]\n");
-	our $clean = 0;
-	our $cnt_warn++;
+	if (report("WARNING: $_[0]\n")) {
+		our $clean = 0;
+		our $cnt_warn++;
+	}
 }
 sub CHK {
-	if ($check) {
-		report("CHECK: $_[0]\n");
+	if ($check && report("CHECK: $_[0]\n")) {
 		our $clean = 0;
 		our $cnt_chk++;
 	}
@@ -867,30 +896,76 @@ sub process {
 	my $prev_values = 'E';
 
 	# suppression flags
-	my $suppress_ifbraces = 0;
+	my %suppress_ifbraces;
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
 	#
 	my @setup_docs = ();
 	my $setup_docs = 0;
+
+	sanitise_line_reset();
 	my $line;
 	foreach my $rawline (@rawlines) {
-		# Standardise the strings and chars within the input to
-		# simplify matching.
-		$line = sanitise_line($rawline);
-		push(@lines, $line);
-
-		##print "==>$rawline\n";
-		##print "-->$line\n";
+		$linenr++;
+		$line = $rawline;
 
-		if ($line=~/^\+\+\+\s+(\S+)/) {
+		if ($rawline=~/^\+\+\+\s+(\S+)/) {
 			$setup_docs = 0;
 			if ($1 =~ m@Documentation/kernel-parameters.txt$@) {
 				$setup_docs = 1;
 			}
-			next;
+			#next;
 		}
+		if ($rawline=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
+			$realline=$1-1;
+			if (defined $2) {
+				$realcnt=$3+1;
+			} else {
+				$realcnt=1+1;
+			}
+
+			# Guestimate if this is a continuing comment.  Run
+			# the context looking for a comment "edge".  If this
+			# edge is a close comment then we must be in a comment
+			# at context start.
+			my $edge;
+			for (my $ln = $linenr; $ln < ($linenr + $realcnt); $ln++) {
+				next if ($line =~ /^-/);
+				($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
+				last if (defined $edge);
+			}
+			if (defined $edge && $edge eq '*/') {
+				$in_comment = 1;
+			}
+
+			# Guestimate if this is a continuing comment.  If this
+			# is the start of a diff block and this line starts
+			# ' *' then it is very likely a comment.
+			if (!defined $edge &&
+			    $rawlines[$linenr] =~ m@^.\s* \*(?:\s|$)@)
+			{
+				$in_comment = 1;
+			}
+
+			##print "COMMENT:$in_comment edge<$edge> $rawline\n";
+			sanitise_line_reset($in_comment);
+
+		} elsif ($realcnt) {
+			# Standardise the strings and chars within the input to
+			# simplify matching.
+			$line = sanitise_line($rawline);
+		}
+		push(@lines, $line);
+
+		if ($realcnt > 1) {
+			$realcnt-- if ($line =~ /^(?:\+| |$)/);
+		} else {
+			$realcnt = 0;
+		}
+
+		#print "==>$rawline\n";
+		#print "-->$line\n";
 
 		if ($setup_docs && $line =~ /^\+/) {
 			push(@setup_docs, $line);
@@ -899,23 +974,17 @@ sub process {
 
 	$prefix = '';
 
+	$realcnt = 0;
+	$linenr = 0;
 	foreach my $line (@lines) {
 		$linenr++;
 
 		my $rawline = $rawlines[$linenr - 1];
 
-#extract the filename as it passes
-		if ($line=~/^\+\+\+\s+(\S+)/) {
-			$realfile=$1;
-			$realfile =~ s@^[^/]*/@@;
-			$in_comment = 0;
-			next;
-		}
 #extract the line range in the file after the patch is applied
 		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
 			$is_patch = 1;
 			$first_line = $linenr + 1;
-			$in_comment = 0;
 			$realline=$1-1;
 			if (defined $2) {
 				$realcnt=$3+1;
@@ -925,50 +994,16 @@ sub process {
 			annotate_reset();
 			$prev_values = 'E';
 
-			$suppress_ifbraces = $linenr - 1;
+			%suppress_ifbraces = ();
 			next;
-		}
 
 # track the line number as we move through the hunk, note that
 # new versions of GNU diff omit the leading space on completely
 # blank context lines so we need to count that too.
-		if ($line =~ /^( |\+|$)/) {
+		} elsif ($line =~ /^( |\+|$)/) {
 			$realline++;
 			$realcnt-- if ($realcnt != 0);
 
-			# Guestimate if this is a continuing comment.  Run
-			# the context looking for a comment "edge".  If this
-			# edge is a close comment then we must be in a comment
-			# at context start.
-			if ($linenr == $first_line) {
-				my $edge;
-				for (my $ln = $first_line; $ln < ($linenr + $realcnt); $ln++) {
-					($edge) = ($rawlines[$ln - 1] =~ m@(/\*|\*/)@);
-					last if (defined $edge);
-				}
-				if (defined $edge && $edge eq '*/') {
-					$in_comment = 1;
-				}
-			}
-
-			# Guestimate if this is a continuing comment.  If this
-			# is the start of a diff block and this line starts
-			# ' *' then it is very likely a comment.
-			if ($linenr == $first_line and $rawline =~ m@^.\s* \*(?:\s|$)@) {
-				$in_comment = 1;
-			}
-
-			# Find the last comment edge on _this_ line.
-			$comment_edge = 0;
-			while (($rawline =~ m@(/\*|\*/)@g)) {
-				if ($1 eq '/*') {
-					$in_comment = 1;
-				} else {
-					$in_comment = 0;
-				}
-				$comment_edge = 1;
-			}
-
 			# Measure the line length and indent.
 			($length, $indent) = line_stats($rawline);
 
@@ -977,23 +1012,36 @@ sub process {
 			($previndent, $stashindent) = ($stashindent, $indent);
 			($prevrawline, $stashrawline) = ($stashrawline, $rawline);
 
-			#warn "ic<$in_comment> ce<$comment_edge> line<$line>\n";
+			#warn "line<$line>\n";
 
 		} elsif ($realcnt == 1) {
 			$realcnt--;
 		}
 
 #make up the handle for any error we report on this line
+		$prefix = "$filename:$realline: " if ($emacs && $file);
+		$prefix = "$filename:$linenr: " if ($emacs && !$file);
+
 		$here = "#$linenr: " if (!$file);
 		$here = "#$realline: " if ($file);
+
+		# extract the filename as it passes
+		if ($line=~/^\+\+\+\s+(\S+)/) {
+			$realfile = $1;
+			$realfile =~ s@^[^/]*/@@;
+
+			if ($realfile =~ m@include/asm/@) {
+				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
+			}
+			next;
+		}
+
 		$here .= "FILE: $realfile:$realline:" if ($realcnt != 0);
 
 		my $hereline = "$here\n$rawline\n";
 		my $herecurr = "$here\n$rawline\n";
 		my $hereprev = "$here\n$prevrawline\n$rawline\n";
 
-		$prefix = "$filename:$realline: " if ($emacs && $file);
-		$prefix = "$filename:$linenr: " if ($emacs && !$file);
 		$cnt_lines++ if ($realcnt != 0);
 
 #check the patch for a signoff:
@@ -1005,7 +1053,7 @@ sub process {
 					$herecurr);
 			}
 			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("need space after Signed-off-by:\n" .
+				WARN("space required after Signed-off-by:\n" .
 					$herecurr);
 			}
 		}
@@ -1072,11 +1120,6 @@ sub process {
 			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
 		}
 
-# The rest of our checks refer specifically to C style
-# only apply those _outside_ comments.  Only skip
-# lines in the middle of comments.
-		next if (!$comment_edge && $in_comment);
-
 # Check for potential 'bare' types
 		if ($realcnt) {
 			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
@@ -1110,7 +1153,7 @@ sub process {
 				my ($name_len) = length($1);
 
 				my $ctx = $s;
-				substr($ctx, 0, $name_len + 1) = '';
+				substr($ctx, 0, $name_len + 1, '');
 				$ctx =~ s/\)[^\)]*$//;
 
 				for my $arg (split(/\s*,\s*/, $ctx)) {
@@ -1151,27 +1194,33 @@ sub process {
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
-		if ($line =~ /\b(?:(if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
+		if ($line =~ /(.*)\b((?:if|while|for|switch)\s*\(|do\b|else\b)/ && $line !~ /^.#/) {
+			my $pre_ctx = "$1$2";
+
 			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
 			my $ctx_ln = $linenr + $#ctx + 1;
 			my $ctx_cnt = $realcnt - $#ctx - 1;
 			my $ctx = join("\n", @ctx);
 
+			##warn "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
+
 			# Skip over any removed lines in the context following statement.
-			while ($ctx_cnt > 0 && $lines[$ctx_ln - 1] =~ /^-/) {
+			while (defined($lines[$ctx_ln - 1]) && $lines[$ctx_ln - 1] =~ /^-/) {
 				$ctx_ln++;
-				$ctx_cnt--;
 			}
-			##warn "line<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>";
+			##warn "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
-			if ($ctx !~ /{\s*/ && $ctx_cnt > 0 && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
-				ERROR("That open brace { should be on the previous line\n" .
+			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
+				ERROR("that open brace { should be on the previous line\n" .
 					"$here\n$ctx\n$lines[$ctx_ln - 1]");
 			}
-			if ($level == 0 && $ctx =~ /\)\s*\;\s*$/ && defined $lines[$ctx_ln - 1]) {
+			if ($level == 0 && $pre_ctx !~ /}\s*while\s*\($/ &&
+			    $ctx =~ /\)\s*\;\s*$/ &&
+			    defined $lines[$ctx_ln - 1])
+			{
 				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);
 				if ($nindent > $indent) {
-					WARN("Trailing semicolon indicates no statements, indent implies otherwise\n" .
+					WARN("trailing semicolon indicates no statements, indent implies otherwise\n" .
 						"$here\n$ctx\n$lines[$ctx_ln - 1]");
 				}
 			}
@@ -1200,7 +1249,7 @@ sub process {
 # check for initialisation to aggregates open brace on the next line
 		if ($prevline =~ /$Declare\s*$Ident\s*=\s*$/ &&
 		    $line =~ /^.\s*{/) {
-			ERROR("That open brace { should be on the previous line\n" . $hereprev);
+			ERROR("that open brace { should be on the previous line\n" . $hereprev);
 		}
 
 #
@@ -1325,22 +1374,31 @@ sub process {
 # check for spaces between functions and their parentheses.
 		while ($line =~ /($Ident)\s+\(/g) {
 			my $name = $1;
-			my $ctx = substr($line, 0, $-[1]);
+			my $ctx_before = substr($line, 0, $-[1]);
+			my $ctx = "$ctx_before$name";
 
 			# Ignore those directives where spaces _are_ permitted.
-			if ($name =~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case|__asm__)$/) {
+			if ($name =~ /^(?:
+				if|for|while|switch|return|case|
+				volatile|__volatile__|
+				__attribute__|format|__extension__|
+				asm|__asm__)$/x)
+			{
 
 			# cpp #define statements have non-optional spaces, ie
 			# if there is a space between the name and the open
 			# parenthesis it is simply not a parameter group.
-			} elsif ($ctx =~ /^.\#\s*define\s*$/) {
+			} elsif ($ctx_before =~ /^.\#\s*define\s*$/) {
+
+			# cpp #elif statement condition may start with a (
+			} elsif ($ctx =~ /^.\#\s*elif\s*$/) {
 
 			# If this whole things ends with a type its most
 			# likely a typedef for a function.
-			} elsif ("$ctx$name" =~ /$Type$/) {
+			} elsif ($ctx =~ /$Type$/) {
 
 			} else {
-				WARN("no space between function name and open parenthesis '('\n" . $herecurr);
+				WARN("space prohibited between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
 # Check operator spacing.
@@ -1359,13 +1417,21 @@ sub process {
 			for (my $n = 0; $n < $#elements; $n += 2) {
 				$off += length($elements[$n]);
 
+				# Pick up the preceeding and succeeding characters.
+				my $ca = substr($opline, 0, $off);
+				my $cc = '';
+				if (length($opline) >= ($off + length($elements[$n + 1]))) {
+					$cc = substr($opline, $off + length($elements[$n + 1]));
+				}
+				my $cb = "$ca$;$cc";
+
 				my $a = '';
 				$a = 'V' if ($elements[$n] ne '');
 				$a = 'W' if ($elements[$n] =~ /\s$/);
 				$a = 'C' if ($elements[$n] =~ /$;$/);
 				$a = 'B' if ($elements[$n] =~ /(\[|\()$/);
 				$a = 'O' if ($elements[$n] eq '');
-				$a = 'E' if ($elements[$n] eq '' && $n == 0);
+				$a = 'E' if ($ca =~ /^\s*$/);
 
 				my $op = $elements[$n + 1];
 
@@ -1381,14 +1447,6 @@ sub process {
 					$c = 'E';
 				}
 
-				# Pick up the preceeding and succeeding characters.
-				my $ca = substr($opline, 0, $off);
-				my $cc = '';
-				if (length($opline) >= ($off + length($elements[$n + 1]))) {
-					$cc = substr($opline, $off + length($elements[$n + 1]));
-				}
-				my $cb = "$ca$;$cc";
-
 				my $ctx = "${a}x${c}";
 
 				my $at = "(ctx:$ctx)";
@@ -1424,7 +1482,7 @@ sub process {
 				} elsif ($op eq ';') {
 					if ($ctx !~ /.x[WEBC]/ &&
 					    $cc !~ /^\\/ && $cc !~ /^;/) {
-						ERROR("need space after that '$op' $at\n" . $hereptr);
+						ERROR("space required after that '$op' $at\n" . $hereptr);
 					}
 
 				# // is a comment
@@ -1433,13 +1491,13 @@ sub process {
 				# -> should have no spaces
 				} elsif ($op eq '->') {
 					if ($ctx =~ /Wx.|.xW/) {
-						ERROR("no spaces around that '$op' $at\n" . $hereptr);
+						ERROR("spaces prohibited around that '$op' $at\n" . $hereptr);
 					}
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
-						ERROR("need space after that '$op' $at\n" . $hereptr);
+						ERROR("space required after that '$op' $at\n" . $hereptr);
 					}
 
 				# '*' as part of a type definition -- reported already.
@@ -1452,21 +1510,26 @@ sub process {
 				} elsif ($op eq '!' || $op eq '~' ||
 				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
-						ERROR("need space before that '$op' $at\n" . $hereptr);
+						ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /.xW/) {
-						ERROR("no space after that '$op' $at\n" . $hereptr);
+						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
-					if ($ctx !~ /[WOBC]x[^W]/ && $ctx !~ /[^W]x[WOBEC]/) {
-						ERROR("need space one side of that '$op' $at\n" . $hereptr);
+					if ($ctx !~ /[WEOBC]x[^W]/ && $ctx !~ /[^W]x[WOBEC]/) {
+						ERROR("space required one side of that '$op' $at\n" . $hereptr);
+					}
+					if ($ctx =~ /Wx[BE]/ ||
+					    ($ctx =~ /Wx./ && $cc =~ /^;/)) {
+						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
 					}
-					if ($ctx =~ /WxB/ || ($ctx =~ /Wx./ && $cc =~ /^;/)) {
-						ERROR("no space before that '$op' $at\n" . $hereptr);
+					if ($ctx =~ /ExW/) {
+						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
+
 				# << and >> may either have or not have spaces both sides
 				} elsif ($op eq '<<' or $op eq '>>' or
 					 $op eq '&' or $op eq '^' or $op eq '|' or
@@ -1474,7 +1537,7 @@ sub process {
 					 $op eq '*' or $op eq '/' or
 					 $op eq '%')
 				{
-					if ($ctx !~ /VxV|WxW|VxE|WxE|VxO|Cx.|.xC/) {
+					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
 						ERROR("need consistent spacing around '$op' $at\n" .
 							$hereptr);
 					}
@@ -1484,7 +1547,7 @@ sub process {
 					# Ignore email addresses <foo@bar>
 					if (!($op eq '<' && $cb =~ /$;\S+\@\S+>/) &&
 					    !($op eq '>' && $cb =~ /<\S+\@\S+$;/)) {
-						ERROR("need spaces around that '$op' $at\n" . $hereptr);
+						ERROR("spaces required around that '$op' $at\n" . $hereptr);
 					}
 				}
 				$off += length($elements[$n + 1]);
@@ -1514,31 +1577,31 @@ sub process {
 #need space before brace following if, while, etc
 		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
 		    $line =~ /do{/) {
-			ERROR("need a space before the open brace '{'\n" . $herecurr);
+			ERROR("space required before the open brace '{'\n" . $herecurr);
 		}
 
 # closing brace should have a space following it when it has anything
 # on the line
 		if ($line =~ /}(?!(?:,|;|\)))\S/) {
-			ERROR("need a space after that close brace '}'\n" . $herecurr);
+			ERROR("space required after that close brace '}'\n" . $herecurr);
 		}
 
 # check spacing on square brackets
 		if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
-			ERROR("no space after that open square bracket '['\n" . $herecurr);
+			ERROR("space prohibited after that open square bracket '['\n" . $herecurr);
 		}
 		if ($line =~ /\s\]/) {
-			ERROR("no space before that close square bracket ']'\n" . $herecurr);
+			ERROR("space prohibited before that close square bracket ']'\n" . $herecurr);
 		}
 
 # check spacing on paretheses
 		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
 		    $line !~ /for\s*\(\s+;/) {
-			ERROR("no space after that open parenthesis '('\n" . $herecurr);
+			ERROR("space prohibited after that open parenthesis '('\n" . $herecurr);
 		}
 		if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
 		    $line !~ /for\s*\(.*;\s+\)/) {
-			ERROR("no space before that close parenthesis ')'\n" . $herecurr);
+			ERROR("space prohibited before that close parenthesis ')'\n" . $herecurr);
 		}
 
 #goto labels aren't indented, allow a single space however
@@ -1549,7 +1612,7 @@ sub process {
 
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
-			ERROR("need a space before the open parenthesis '('\n" . $herecurr);
+			ERROR("space required before the open parenthesis '('\n" . $herecurr);
 		}
 
 # Check for illegal assignment in if conditional.
@@ -1562,10 +1625,12 @@ sub process {
 
 			# Find out what is on the end of the line after the
 			# conditional.
-			substr($s, 0, length($c)) = '';
+			substr($s, 0, length($c), '');
 			$s =~ s/\n.*//g;
 			$s =~ s/$;//g; 	# Remove any comments
-			if (length($c) && $s !~ /^\s*({|;|)\s*\\*\s*$/) {
+			if (length($c) && $s !~ /^\s*({|;|)\s*\\*\s*$/ &&
+			    $c !~ /^.\#\s*if/)
+			{
 				ERROR("trailing statements should be on next line\n" . $herecurr);
 			}
 		}
@@ -1607,7 +1672,7 @@ sub process {
 
 			# Find out what is on the end of the line after the
 			# conditional.
-			substr($s, 0, length($c)) = '';
+			substr($s, 0, length($c), '');
 			$s =~ s/\n.*//g;
 
 			if ($s =~ /^\s*;/) {
@@ -1631,7 +1696,7 @@ sub process {
 		if ($tree && $rawline =~ m{^.\#\s*include\s*\<asm\/(.*)\.h\>}) {
 			my $checkfile = "$root/include/linux/$1.h";
 			if (-f $checkfile && $1 ne 'irq.h') {
-				CHK("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
+				WARN("Use #include <linux/$1.h> instead of <asm/$1.h>\n" .
 					$herecurr);
 			}
 		}
@@ -1692,15 +1757,24 @@ sub process {
 			if ($#chunks > 0 && $level == 0) {
 				my $allowed = 0;
 				my $seen = 0;
-				my $herectx = $here . "\n";;
+				my $herectx = $here . "\n";
 				my $ln = $linenr - 1;
 				for my $chunk (@chunks) {
 					my ($cond, $block) = @{$chunk};
 
-					$herectx .= "$rawlines[$ln]\n[...]\n";
+					# If the condition carries leading newlines, then count those as offsets.
+					my ($whitespace) = ($cond =~ /^((?:\s*\n[+-])*\s*)/s);
+					my $offset = statement_rawlines($whitespace) - 1;
+
+					#print "COND<$cond> whitespace<$whitespace> offset<$offset>\n";
+
+					# We have looked at and allowed this specific line.
+					$suppress_ifbraces{$ln + $offset} = 1;
+
+					$herectx .= "$rawlines[$ln + $offset]\n[...]\n";
 					$ln += statement_rawlines($block) - 1;
 
-					substr($block, 0, length($cond)) = '';
+					substr($block, 0, length($cond), '');
 
 					$seen++ if ($block =~ /^\s*{/);
 
@@ -1721,16 +1795,10 @@ sub process {
 				if ($seen && !$allowed) {
 					WARN("braces {} are not necessary for any arm of this statement\n" . $herectx);
 				}
-				# Either way we have looked over this whole
-				# statement and said what needs to be said.
-				$suppress_ifbraces = $endln;
 			}
 		}
-		if ($linenr > $suppress_ifbraces &&
+		if (!defined $suppress_ifbraces{$linenr - 1} &&
 					$line =~ /\b(if|while|for|else)\b/) {
-			my ($level, $endln, @chunks) =
-				ctx_statement_full($linenr, $realcnt, $-[0]);
-
 			my $allowed = 0;
 
 			# Check the pre-context.
@@ -1738,10 +1806,15 @@ sub process {
 				#print "APW: ALLOWED: pre<$1>\n";
 				$allowed = 1;
 			}
+
+			my ($level, $endln, @chunks) =
+				ctx_statement_full($linenr, $realcnt, $-[0]);
+
 			# Check the condition.
 			my ($cond, $block) = @{$chunks[0]};
+			#print "CHECKING<$linenr> cond<$cond> block<$block>\n";
 			if (defined $cond) {
-				substr($block, 0, length($cond)) = '';
+				substr($block, 0, length($cond), '');
 			}
 			if (statement_lines($cond) > 1) {
 				#print "APW: ALLOWED: cond<$cond>\n";
@@ -1759,7 +1832,7 @@ sub process {
 			if (defined $chunks[1]) {
 				my ($cond, $block) = @{$chunks[1]};
 				if (defined $cond) {
-					substr($block, 0, length($cond)) = '';
+					substr($block, 0, length($cond), '');
 				}
 				if ($block =~ /^\s*\{/) {
 					#print "APW: ALLOWED: chunk-1 block<$block>\n";
@@ -1882,6 +1955,28 @@ sub process {
 		if ($line =~ /__FUNCTION__/) {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
+
+# check for semaphores used as mutexes
+		if ($line =~ /\b(DECLARE_MUTEX|init_MUTEX)\s*\(/) {
+			WARN("mutexes are preferred for single holder semaphores\n" . $herecurr);
+		}
+# check for semaphores used as mutexes
+		if ($line =~ /\binit_MUTEX_LOCKED\s*\(/) {
+			WARN("consider using a completion\n" . $herecurr);
+		}
+# recommend strict_strto* over simple_strto*
+		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
+			WARN("consider using strict_$1 in preference to simple_$1\n" . $herecurr);
+		}
+
+# use of NR_CPUS is usually wrong
+# ignore definitions of NR_CPUS and usage to define arrays as likely right
+		if ($line =~ /\bNR_CPUS\b/ &&
+		    $line !~ /^.#\s*define\s+NR_CPUS\s+/ &&
+		    $line !~ /^.\s*$Declare\s.*\[[^\]]*NR_CPUS[^\]]*\]/)
+		{
+			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
mm-make-early_pfn_to_nid-a-c-function.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
page-owner-tracking-leak-detector.patch

