From: akpm@linux-foundation.org
Subject: + update-checkpatchpl-to-version-012.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:14:10 -0800
Message-ID: <200711152214.lAFMEA1e018496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934008AbXKOWOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:14:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     update checkpatch.pl to version 0.12
has been added to the -mm tree.  Its filename is
     update-checkpatchpl-to-version-012.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update checkpatch.pl to version 0.12
From: Andy Whitcroft <apw@shadowen.org>

This version brings a new terse output mode as well as many improvements to
the unary detection and bare type regcognition.  It also brings the usual
updates for false positives, though these seem to be slowing markedly
now that the unary detector is no longer just putting its finger in the
air and guessing.  Of note:

  - new --terse mode producing a single line per report
  - loosening of the block brace checks
  - new checks for enum/union/struch brace placements
  - hugely expanded "bare type" detection
  - checks for inline usage
  - better handling of already open comment blocks
  - handle patches which introduce or remove lines without newlines

Andy Whitcroft (19):
      Version: 0.12
      style fixes as spotted by checkpatch
      add a --terse options of a single line of output per report
      block brace checks should only apply for single line blocks
      all new bare type detector
      check spacing for open braces with enum, union and struct
      check for LINUX_VERSION_CODE
      macros definition bracketing checks need to ignore -ve context
      clean up the mail-back mode, -q et al
      expand possible type matching to declarations
      allow const and sparse annotations on possible types
      handle possible types as regular types everywhere
      prefer plain inline over __inline__ and __inline
      all new open comment detection
      fix up conditional extraction for if assignment checks
      add const to the possible type matcher
      unary checks: a for loop is a conditional too
      possible types: detect function pointer definitions
      handle missind newlines at end of file, report addition

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  395 +++++++++++++++++++++++++++++-----------
 1 file changed, 287 insertions(+), 108 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-012 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-012
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.11';
+my $V = '0.12';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -19,8 +19,11 @@ my $chk_signoff = 1;
 my $chk_patch = 1;
 my $tst_type = 0;
 my $emacs = 0;
+my $terse = 0;
 my $file = 0;
 my $check = 0;
+my $summary = 1;
+my $mailback = 0;
 my $root;
 GetOptions(
 	'q|quiet+'	=> \$quiet,
@@ -29,10 +32,13 @@ GetOptions(
 	'patch!'	=> \$chk_patch,
 	'test-type!'	=> \$tst_type,
 	'emacs!'	=> \$emacs,
+	'terse!'	=> \$terse,
 	'file!'		=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'root=s'	=> \$root,
+	'summary!'	=> \$summary,
+	'mailback!'	=> \$mailback,
 ) or exit;
 
 my $exit = 0;
@@ -42,6 +48,7 @@ if ($#ARGV < 0) {
 	print "version: $V\n";
 	print "options: -q           => quiet\n";
 	print "         --no-tree    => run without a kernel tree\n";
+	print "         --terse      => one line per report\n";
 	print "         --emacs      => emacs compile window format\n";
 	print "         --file       => check a source file\n";
 	print "         --strict     => enable more subjective tests\n";
@@ -49,6 +56,11 @@ if ($#ARGV < 0) {
 	exit(1);
 }
 
+if ($terse) {
+	$emacs = 1;
+	$quiet++;
+}
+
 if ($tree) {
 	if (defined $root) {
 		if (!top_of_kernel_tree($root)) {
@@ -90,41 +102,6 @@ our $Attribute	= qr{
 			__(?:mem|cpu|dev|)(?:initdata|init)
 		  }x;
 our $Inline	= qr{inline|__always_inline|noinline};
-our $NonptrType	= qr{
-			\b
-			(?:const\s+)?
-			(?:unsigned\s+)?
-			(?:
-				void|
-				char|
-				short|
-				int|
-				long|
-				unsigned|
-				float|
-				double|
-				bool|
-				long\s+int|
-				long\s+long|
-				long\s+long\s+int|
-				(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
-				struct\s+$Ident|
-				union\s+$Ident|
-				enum\s+$Ident|
-				${Ident}_t|
-				${Ident}_handler|
-				${Ident}_handler_fn
-			)
-			(?:\s+$Sparse)*
-			\b
-		  }x;
-
-our $Type	= qr{
-			\b$NonptrType\b
-			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
-			(?:\s+$Sparse|\s+$Attribute)*
-		  }x;
-our $Declare	= qr{(?:$Storage\s+)?$Type};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
@@ -136,7 +113,50 @@ our $Operators	= qr{
 			&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/
 		  }x;
 
-our $Bare = '';
+our $NonptrType;
+our $Type;
+our $Declare;
+
+our @typeList = (
+	qr{void},
+	qr{char},
+	qr{short},
+	qr{int},
+	qr{long},
+	qr{unsigned},
+	qr{float},
+	qr{double},
+	qr{bool},
+	qr{long\s+int},
+	qr{long\s+long},
+	qr{long\s+long\s+int},
+	qr{(?:__)?(?:u|s|be|le)(?:8|16|32|64)},
+	qr{struct\s+$Ident},
+	qr{union\s+$Ident},
+	qr{enum\s+$Ident},
+	qr{${Ident}_t},
+	qr{${Ident}_handler},
+	qr{${Ident}_handler_fn},
+);
+
+sub build_types {
+	my $all = "(?:  \n" . join("|\n  ", @typeList) . "\n)";
+	$NonptrType	= qr{
+			\b
+			(?:const\s+)?
+			(?:unsigned\s+)?
+			$all
+			(?:\s+$Sparse|\s+const)*
+			\b
+		  }x;
+	$Type	= qr{
+			\b$NonptrType\b
+			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
+			(?:\s+$Sparse|\s+$Attribute)*
+		  }x;
+	$Declare	= qr{(?:$Storage\s+)?$Type};
+}
+build_types();
 
 $chk_signoff = 0 if ($file);
 
@@ -278,6 +298,81 @@ sub sanitise_line {
 	return $res;
 }
 
+sub ctx_statement_block {
+	my ($linenr, $remain, $off) = @_;
+	my $line = $linenr - 1;
+	my $blk = '';
+	my $soff = $off;
+	my $coff = $off - 1;
+
+	my $type = '';
+	my $level = 0;
+	my $c;
+	my $len = 0;
+	while (1) {
+		#warn "CSB: blk<$blk>\n";
+		# If we are about to drop off the end, pull in more
+		# context.
+		if ($off >= $len) {
+			for (; $remain > 0; $line++) {
+				next if ($rawlines[$line] =~ /^-/);
+				$remain--;
+				$blk .= sanitise_line($rawlines[$line]) . "\n";
+				$len = length($blk);
+				$line++;
+				last;
+			}
+			# Bail if there is no further context.
+			#warn "CSB: blk<$blk> off<$off> len<$len>\n";
+			if ($off == $len) {
+				last;
+			}
+		}
+		$c = substr($blk, $off, 1);
+
+		#warn "CSB: c<$c> type<$type> level<$level>\n";
+		# Statement ends at the ';' or a close '}' at the
+		# outermost level.
+		if ($level == 0 && $c eq ';') {
+			last;
+		}
+
+		if (($type eq '' || $type eq '(') && $c eq '(') {
+			$level++;
+			$type = '(';
+		}
+		if ($type eq '(' && $c eq ')') {
+			$level--;
+			$type = ($level != 0)? '(' : '';
+
+			if ($level == 0 && $coff < $soff) {
+				$coff = $off;
+			}
+		}
+		if (($type eq '' || $type eq '{') && $c eq '{') {
+			$level++;
+			$type = '{';
+		}
+		if ($type eq '{' && $c eq '}') {
+			$level--;
+			$type = ($level != 0)? '{' : '';
+
+			if ($level == 0) {
+				last;
+			}
+		}
+		$off++;
+	}
+
+	my $statement = substr($blk, $soff, $off - $soff + 1);
+	my $condition = substr($blk, $soff, $coff - $soff + 1);
+
+	#warn "STATEMENT<$statement>\n";
+	#warn "CONDITION<$condition>\n";
+
+	return ($statement, $condition);
+}
+
 sub ctx_block_get {
 	my ($linenr, $remain, $outer, $open, $close, $off) = @_;
 	my $line;
@@ -421,9 +516,6 @@ sub annotate_values {
 	my $paren = 0;
 	my @paren_type;
 
-	# Include any user defined types we may have found as we went.
-	my $type_match = "(?:$Type$Bare)";
-
 	while (length($cur)) {
 		print " <$type> " if ($debug);
 		if ($cur =~ /^(\s+)/o) {
@@ -433,7 +525,7 @@ sub annotate_values {
 				$type = 'N';
 			}
 
-		} elsif ($cur =~ /^($type_match)/) {
+		} elsif ($cur =~ /^($Type)/) {
 			print "DECLARE($1)\n" if ($debug);
 			$type = 'T';
 
@@ -457,7 +549,7 @@ sub annotate_values {
 			}
 			$type = 'N';
 
-		} elsif ($cur =~ /^(if|while|typeof)\b/o) {
+		} elsif ($cur =~ /^(if|while|typeof|for)\b/o) {
 			print "COND($1)\n" if ($debug);
 			$paren_type[$paren] = 'N';
 			$type = 'N';
@@ -515,11 +607,30 @@ sub annotate_values {
 	return $res;
 }
 
+sub possible {
+	my ($possible) = @_;
+
+	#print "CHECK<$possible>\n";
+	if ($possible !~ /^(?:$Storage|$Type|DEFINE_\S+)$/ &&
+	    $possible ne 'goto' && $possible ne 'return' &&
+	    $possible ne 'struct' && $possible ne 'enum' &&
+	    $possible ne 'case' && $possible ne 'else' &&
+	    $possible ne 'typedef') {
+		#print "POSSIBLE<$possible>\n";
+		push(@typeList, $possible);
+		build_types();
+	}
+}
+
 my $prefix = '';
 
 my @report = ();
 sub report {
-	push(@report, $prefix . $_[0]);
+	my $line = $prefix . $_[0];
+
+	$line = (split('\n', $line))[0] . "\n" if ($terse);
+
+	push(@report, $line);
 }
 sub report_dump {
 	@report;
@@ -574,9 +685,6 @@ sub process {
 
 	my $prev_values = 'N';
 
-	# Possible bare types.
-	my @bare = ();
-
 	# Pre-scan the patch looking for any __setup documentation.
 	my @setup_docs = ();
 	my $setup_docs = 0;
@@ -631,21 +739,35 @@ sub process {
 			$realline++;
 			$realcnt-- if ($realcnt != 0);
 
-			# track any sort of multi-line comment.  Obviously if
-			# the added text or context do not include the whole
-			# comment we will not see it. Such is life.
-			#
+			# Guestimate if this is a continuing comment.  Run
+			# the context looking for a comment "edge".  If this
+			# edge is a close comment then we must be in a comment
+			# at context start.
+			if ($linenr == $first_line) {
+				my $edge;
+				for (my $ln = $first_line; $ln < ($linenr + $realcnt); $ln++) {
+					($edge) = ($lines[$ln - 1] =~ m@(/\*|\*/)@);
+					last if (defined $edge);
+				}
+				if (defined $edge && $edge eq '*/') {
+					$in_comment = 1;
+				}
+			}
+
 			# Guestimate if this is a continuing comment.  If this
 			# is the start of a diff block and this line starts
 			# ' *' then it is very likely a comment.
 			if ($linenr == $first_line and $line =~ m@^.\s*\*@) {
 				$in_comment = 1;
 			}
-			if ($line =~ m@/\*@) {
-				$in_comment = 1;
-			}
-			if ($line =~ m@\*/@) {
-				$in_comment = 0;
+
+			# Find the last comment edge on _this_ line.
+			while (($line =~ m@(/\*|\*/)@g)) {
+				if ($1 eq '/*') {
+					$in_comment = 1;
+				} else {
+					$in_comment = 0;
+				}
 			}
 
 			# Measure the line length and indent.
@@ -687,7 +809,7 @@ sub process {
 		}
 
 # Check for wrappage within a valid hunk of the file
-		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |$)}) {
+		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("patch seems to be corrupt (line wrapped?)\n" .
 				$herecurr) if (!$emitted_corrupt++);
 		}
@@ -727,6 +849,11 @@ sub process {
 			WARN("line over 80 characters\n" . $herecurr);
 		}
 
+# check for adding lines without a newline.
+		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
+			WARN("adding a line without newline at end of file\n" . $herecurr);
+		}
+
 # check we are in a valid source file *.[hc] if not then ignore this hunk
 		next if ($realfile !~ /\.[hc]$/);
 
@@ -752,30 +879,41 @@ sub process {
 
 # Check for potential 'bare' types
 		if ($realcnt &&
-		    $line !~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?$Type\b/ &&
 		    $line !~ /$Ident:\s*$/ &&
-		    $line !~ /^.\s*$Ident\s*\(/ &&
-		     # definitions in global scope can only start with types
-		    ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?($Ident)\b/ ||
-		     # declarations always start with types
-		     $line =~ /^.\s*(?:$Storage\s+)?($Ident)\b\s*\**\s*$Ident\s*(?:;|=)/) ||
-		     # any (foo ... *) is a pointer cast, and foo is a type
-		     $line =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/) {
-			my $possible = $1;
-			if ($possible !~ /^(?:$Storage|$Type|DEFINE_\S+)$/ &&
-			    $possible ne 'goto' && $possible ne 'return' &&
-			    $possible ne 'struct' && $possible ne 'enum' &&
-			    $possible ne 'case' && $possible ne 'else' &&
-			    $possible ne 'typedef') {
-				#print "POSSIBLE<$possible>\n";
-				push(@bare, $possible);
-				my $bare = join("|", @bare);
-				$Bare	= '|' . qr{
-						\b(?:$bare)\b
-						(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
-						(?:\s+$Sparse)*
-					  }x;
+		    ($line =~ /^.\s*$Ident\s*\(\*+\s*$Ident\)\s*\(/ ||
+		     $line !~ /^.\s*$Ident\s*\(/)) {
+			# definitions in global scope can only start with types
+			if ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/) {
+				possible($1);
+
+			# declarations always start with types
+			} elsif ($prev_values eq 'N' && $line =~ /^.\s*(?:$Storage\s+)?($Ident)\b\s*\**\s*$Ident\s*(?:;|=)/) {
+				possible($1);
+
+			# any (foo ... *) is a pointer cast, and foo is a type
+			} elsif ($line =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/) {
+				possible($1);
+			}
+
+			# Check for any sort of function declaration.
+			# int foo(something bar, other baz);
+			# void (*store_gdt)(x86_descr_ptr *);
+			if ($prev_values eq 'N' && $line =~ /^(.(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {
+				my ($name_len) = length($1);
+				my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, $name_len);
+				my $ctx = join("\n", @ctx);
+
+				$ctx =~ s/\n.//;
+				substr($ctx, 0, $name_len + 1) = '';
+				$ctx =~ s/\)[^\)]*$//;
+				for my $arg (split(/\s*,\s*/, $ctx)) {
+					if ($arg =~ /^(?:const\s+)?($Ident)(?:\s+$Sparse)*\s*\**\s*(:?\b$Ident)?$/ || $arg =~ /^($Ident)$/) {
+
+						possible($1);
+					}
+				}
 			}
+
 		}
 
 #
@@ -935,6 +1073,10 @@ sub process {
 # 			$clean = 0;
 # 		}
 
+		if ($line =~ /\bLINUX_VERSION_CODE\b/) {
+			WARN("LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged" . $herecurr);
+		}
+
 # printk should use KERN_* levels.  Note that follow on printk's on the
 # same line do not need a level, so we use the current block context
 # to try and find and validate the current printk.  In summary the current
@@ -965,6 +1107,12 @@ sub process {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
+# open braces for enum, union and struct go on the same line.
+		if ($line =~ /^.\s*{/ &&
+		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
+			ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
+		}
+
 # check for spaces between functions and their parentheses.
 		while ($line =~ /($Ident)\s+\(/g) {
 			if ($1 !~ /^(?:if|for|while|switch|return|volatile|__volatile__|__attribute__|format|__extension__|Copyright|case)$/ &&
@@ -1172,9 +1320,27 @@ sub process {
 		}
 
 # Check for illegal assignment in if conditional.
-		if ($line=~/\bif\s*\(.*[^<>!=]=[^=]/) {
-			#next if ($line=~/\".*\Q$op\E.*\"/ or $line=~/\'\Q$op\E\'/);
-			ERROR("do not use assignment in if condition\n" . $herecurr);
+		if ($line =~ /\bif\s*\(/) {
+			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
+
+			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/) {
+				ERROR("do not use assignment in if condition ($c)\n" . $herecurr);
+			}
+
+			# Find out what is on the end of the line after the
+			# conditional.
+			substr($s, 0, length($c)) = '';
+			$s =~ s/\n.*//g;
+
+			if (length($c) && $s !~ /^\s*({|;|\/\*.*\*\/)?\s*\\*\s*$/) {
+				ERROR("trailing statements should be on next line\n" . $herecurr);
+			}
+		}
+
+# if and else should not have general statements after it
+		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
+		    $1 !~ /^\s*(?:\sif|{|\\|$)/) {
+			ERROR("trailing statements should be on next line\n" . $herecurr);
 		}
 
 		# Check for }<nl>else {, these must be at the same
@@ -1205,12 +1371,6 @@ sub process {
 			}
 		}
 
-# if and else should not have general statements after it
-		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
-		    $1 !~ /^\s*(?:\sif|{|\\|$)/) {
-			ERROR("trailing statements should be on next line\n" . $herecurr);
-		}
-
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
 # in a known goot container
@@ -1233,6 +1393,10 @@ sub process {
 				$off = length($1);
 				$ln--;
 				$cnt++;
+				while ($lines[$ln - 1] =~ /^-/) {
+					$ln--;
+					$cnt++;
+				}
 			}
 			my @ctx = ctx_statement($ln, $cnt, $off);
 			my $ctx_ln = $ln + $#ctx + 1;
@@ -1268,25 +1432,23 @@ sub process {
 			if ($lines[$nr - 1] =~ /{\s*$/) {
 				my ($lvl, @block) = ctx_block_level($nr, $cnt);
 
-				my $stmt = join(' ', @block);
-				$stmt =~ s/(^[^{]*){//;
+				my $stmt = join("\n", @block);
+				# Drop the diff line leader.
+				$stmt =~ s/\n./\n/g;
+				# Drop the code outside the block.
+				$stmt =~ s/(^[^{]*){\s*//;
 				my $before = $1;
-				$stmt =~ s/}([^}]*$)//;
+				$stmt =~ s/\s*}([^}]*$)//;
 				my $after = $1;
 
 				#print "block<" . join(' ', @block) . "><" . scalar(@block) . ">\n";
 				#print "stmt<$stmt>\n\n";
 
-				# Count the ;'s if there is fewer than two
-				# then there can only be one statement,
-				# if there is a brace inside we cannot
-				# trivially detect if its one statement.
-				# Also nested if's often require braces to
-				# disambiguate the else binding so shhh there.
-				my @semi = ($stmt =~ /;/g);
-				push(@semi, "/**/") if ($stmt =~ m@/\*@);
-				##print "semi<" . scalar(@semi) . ">\n";
-				if ($lvl == 0 && scalar(@semi) < 2 &&
+				# Count the newlines, if there is only one
+				# then the block should not have {}'s.
+				my @lines = ($stmt =~ /\n/g);
+				#print "lines<" . scalar(@lines) . ">\n";
+				if ($lvl == 0 && scalar(@lines) == 0 &&
 				    $stmt !~ /{/ && $stmt !~ /\bif\b/ &&
 				    $before !~ /}/ && $after !~ /{/) {
 				    	my $herectx = "$here\n" . join("\n", @control, @block[1 .. $#block]) . "\n";
@@ -1372,6 +1534,11 @@ sub process {
 			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
 		}
 
+# Check for __inline__ and __inline, prefer inline
+		if ($line =~ /\b(__inline__|__inline)\b/) {
+			WARN("plain inline is preferred over $1\n" . $herecurr);
+		}
+
 # check for new externs in .c files.
 		if ($line =~ /^.\s*extern\s/ && ($realfile =~ /\.c$/)) {
 			WARN("externs should be avoided in .c files\n" .  $herecurr);
@@ -1392,21 +1559,33 @@ sub process {
 		}
 	}
 
-	if ($chk_patch && !$is_patch) {
+	# In mailback mode only produce a report in the negative, for
+	# things that appear to be patches.
+	if ($mailback && ($clean == 1 || !$is_patch)) {
+		exit(0);
+	}
+
+	# This is not a patch, and we are are in 'no-patch' mode so
+	# just keep quiet.
+	if (!$chk_patch && !$is_patch) {
+		exit(0);
+	}
+
+	if (!$is_patch) {
 		ERROR("Does not appear to be a unified-diff format patch\n");
 	}
 	if ($is_patch && $chk_signoff && $signoff == 0) {
 		ERROR("Missing Signed-off-by: line(s)\n");
 	}
 
-	if ($clean == 0 && ($chk_patch || $is_patch)) {
-		print report_dump();
-		if ($quiet < 2) {
-			print "total: $cnt_error errors, $cnt_warn warnings, " .
-				(($check)? "$cnt_chk checks, " : "") .
-				"$cnt_lines lines checked\n";
-		}
+	print report_dump();
+	if ($summary) {
+		print "total: $cnt_error errors, $cnt_warn warnings, " .
+			(($check)? "$cnt_chk checks, " : "") .
+			"$cnt_lines lines checked\n";
+		print "\n" if ($quiet == 0);
 	}
+
 	if ($clean == 1 && $quiet == 0) {
 		print "Your patch has no obvious style problems and is ready for submission.\n"
 	}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
update-checkpatchpl-to-version-012.patch
page-owner-tracking-leak-detector.patch
