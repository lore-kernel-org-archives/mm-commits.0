From: akpm@linux-foundation.org
Subject: + update-checkpatchpl-to-version-015.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:38 -0800
Message-ID: <200802230734.m1N7YQ3M018289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507AbYBWIEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, ak@suse.de, jschopp@austin.ibm.com, mingo@elte.hu, rdunlap@xenotime.net


The patch titled
     update checkpatch.pl to version 0.15
has been added to the -mm tree.  Its filename is
     update-checkpatchpl-to-version-015.patch

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
Subject: update checkpatch.pl to version 0.15
From: Andy Whitcroft <apw@shadowen.org>

This version brings a number of minor fixes updating the type detector and
the unary tracker.  It also brings a few small fixes for false positives.
It also reverts the --file warning.  Of note:

 - limit CVS checks to added lines
 - improved type detections
 - fixes to the unary tracker

Andy Whitcroft (13):
      Version: 0.15
      EXPORT_SYMBOL checks need to accept array variables
      export checks must match DECLARE_foo and LIST_HEAD
      possible types: cleanup debugging missing line
      values: track values through preprocessor conditional paths
      typeof is actually a type
      possible types: detect definitions which cross lines
      values: include line numbers on value debug information
      values: ensure we find correctly record pending brackets
      values: simplify the brace history stack
      CVS keyword checks should only apply to added lines
      loosen spacing for comments
      allow braces for single statement blocks with multiline conditionals

Harvey Harrison (1):
      checkpatch: remove fastcall

Ingo Molnar (1):
      checkpatch.pl: revert wrong --file message

Uwe Kleine-Koenig (1):
      fix typo "goot" -> "good"

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Joel Schopp <jschopp@austin.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  323 +++++++++++++++++++++++++---------------
 1 file changed, 206 insertions(+), 117 deletions(-)

diff -puN scripts/checkpatch.pl~update-checkpatchpl-to-version-015 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~update-checkpatchpl-to-version-015
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.14';
+my $V = '0.15';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -105,8 +105,7 @@ our $Sparse	= qr{
 			__iomem|
 			__must_check|
 			__init_refok|
-			__kprobes|
-			fastcall
+			__kprobes
 		}x;
 our $Attribute	= qr{
 			const|
@@ -158,7 +157,10 @@ sub build_types {
 			\b
 			(?:const\s+)?
 			(?:unsigned\s+)?
-			$all
+			(?:
+				$all|
+				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)
+			)
 			(?:\s+$Sparse|\s+const)*
 			\b
 		  }x;
@@ -362,6 +364,7 @@ sub ctx_statement_block {
 
 	my $type = '';
 	my $level = 0;
+	my $p;
 	my $c;
 	my $len = 0;
 
@@ -386,6 +389,7 @@ sub ctx_statement_block {
 				last;
 			}
 		}
+		$p = $c;
 		$c = substr($blk, $off, 1);
 		$remainder = substr($blk, $off);
 
@@ -397,8 +401,9 @@ sub ctx_statement_block {
 		}
 
 		# An else is really a conditional as long as its not else if
-		if ($level == 0 && $remainder =~ /(\s+else)(?:\s|{)/ &&
-					$remainder !~ /\s+else\s+if\b/) {
+		if ($level == 0 && (!defined($p) || $p =~ /(?:\s|\})/) &&
+				$remainder =~ /(else)(?:\s|{)/ &&
+				$remainder !~ /else\s+if\b/) {
 			$coff = $off + length($1);
 		}
 
@@ -445,21 +450,73 @@ sub ctx_statement_block {
 			$line, $remain + 1, $off - $loff + 1, $level);
 }
 
+sub statement_lines {
+	my ($stmt) = @_;
+
+	# Strip the diff line prefixes and rip blank lines at start and end.
+	$stmt =~ s/(^|\n)./$1/g;
+	$stmt =~ s/^\s*//;
+	$stmt =~ s/\s*$//;
+
+	my @stmt_lines = ($stmt =~ /\n/g);
+
+	return $#stmt_lines + 2;
+}
+
+sub statement_rawlines {
+	my ($stmt) = @_;
+
+	my @stmt_lines = ($stmt =~ /\n/g);
+
+	return $#stmt_lines + 2;
+}
+
+sub statement_block_size {
+	my ($stmt) = @_;
+
+	$stmt =~ s/(^|\n)./$1/g;
+	$stmt =~ s/^\s*{//;
+	$stmt =~ s/}\s*$//;
+	$stmt =~ s/^\s*//;
+	$stmt =~ s/\s*$//;
+
+	my @stmt_lines = ($stmt =~ /\n/g);
+	my @stmt_statements = ($stmt =~ /;/g);
+
+	my $stmt_lines = $#stmt_lines + 2;
+	my $stmt_statements = $#stmt_statements + 1;
+
+	if ($stmt_lines > $stmt_statements) {
+		return $stmt_lines;
+	} else {
+		return $stmt_statements;
+	}
+}
+
 sub ctx_statement_full {
 	my ($linenr, $remain, $off) = @_;
 	my ($statement, $condition, $level);
 
 	my (@chunks);
 
+	# Grab the first conditional/block pair.
 	($statement, $condition, $linenr, $remain, $off, $level) =
 				ctx_statement_block($linenr, $remain, $off);
 	#print "F: c<$condition> s<$statement>\n";
+	push(@chunks, [ $condition, $statement ]);
+	if (!($remain > 0 && $condition =~ /^\s*(?:\n[+-])?\s*(?:if|else|do)\b/s)) {
+		return ($level, $linenr, @chunks);
+	}
+
+	# Pull in the following conditional/block pairs and see if they
+	# could continue the statement.
 	for (;;) {
-		push(@chunks, [ $condition, $statement ]);
-		last if (!($remain > 0 && $condition =~ /^.\s*(?:if|else|do)/));
 		($statement, $condition, $linenr, $remain, $off, $level) =
 				ctx_statement_block($linenr, $remain, $off);
-		#print "C: c<$condition> s<$statement>\n";
+		#print "C: c<$condition> s<$statement> remain<$remain>\n";
+		last if (!($remain > 0 && $condition =~ /^\s*(?:\n[+-])?\s*(?:else|do)\b/s));
+		#print "C: push\n";
+		push(@chunks, [ $condition, $statement ]);
 	}
 
 	return ($level, $linenr, @chunks);
@@ -593,13 +650,13 @@ sub cat_vet {
 }
 
 my $av_preprocessor = 0;
-my $av_paren = 0;
+my $av_pending;
 my @av_paren_type;
 
 sub annotate_reset {
 	$av_preprocessor = 0;
-	$av_paren = 0;
-	@av_paren_type = ();
+	$av_pending = '_';
+	@av_paren_type = ('E');
 }
 
 sub annotate_values {
@@ -611,12 +668,13 @@ sub annotate_values {
 	print "$stream\n" if ($dbg_values > 1);
 
 	while (length($cur)) {
-		print " <$type> " if ($dbg_values > 1);
+		print " <" . join('', @av_paren_type) .
+					"> <$type> " if ($dbg_values > 1);
 		if ($cur =~ /^(\s+)/o) {
 			print "WS($1)\n" if ($dbg_values > 1);
 			if ($1 =~ /\n/ && $av_preprocessor) {
+				$type = pop(@av_paren_type);
 				$av_preprocessor = 0;
-				$type = 'N';
 			}
 
 		} elsif ($cur =~ /^($Type)/) {
@@ -626,11 +684,33 @@ sub annotate_values {
 		} elsif ($cur =~ /^(#\s*define\s*$Ident)(\(?)/o) {
 			print "DEFINE($1)\n" if ($dbg_values > 1);
 			$av_preprocessor = 1;
-			$av_paren_type[$av_paren] = 'N';
+			$av_pending = 'N';
 
-		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if|else|elif|endif))/o) {
-			print "PRE($1)\n" if ($dbg_values > 1);
+		} elsif ($cur =~ /^(#\s*(?:ifdef|ifndef|if))/o) {
+			print "PRE_START($1)\n" if ($dbg_values > 1);
 			$av_preprocessor = 1;
+
+			push(@av_paren_type, $type);
+			push(@av_paren_type, $type);
+			$type = 'N';
+
+		} elsif ($cur =~ /^(#\s*(?:else|elif))/o) {
+			print "PRE_RESTART($1)\n" if ($dbg_values > 1);
+			$av_preprocessor = 1;
+
+			push(@av_paren_type, $av_paren_type[$#av_paren_type]);
+
+			$type = 'N';
+
+		} elsif ($cur =~ /^(#\s*(?:endif))/o) {
+			print "PRE_END($1)\n" if ($dbg_values > 1);
+
+			$av_preprocessor = 1;
+
+			# Assume all arms of the conditional end as this
+			# one does, and continue as if the #endif was not here.
+			pop(@av_paren_type);
+			push(@av_paren_type, $type);
 			$type = 'N';
 
 		} elsif ($cur =~ /^(\\\n)/o) {
@@ -639,13 +719,13 @@ sub annotate_values {
 		} elsif ($cur =~ /^(sizeof)\s*(\()?/o) {
 			print "SIZEOF($1)\n" if ($dbg_values > 1);
 			if (defined $2) {
-				$av_paren_type[$av_paren] = 'V';
+				$av_pending = 'V';
 			}
 			$type = 'N';
 
 		} elsif ($cur =~ /^(if|while|typeof|__typeof__|for)\b/o) {
 			print "COND($1)\n" if ($dbg_values > 1);
-			$av_paren_type[$av_paren] = 'N';
+			$av_pending = 'N';
 			$type = 'N';
 
 		} elsif ($cur =~/^(return|case|else)/o) {
@@ -654,14 +734,14 @@ sub annotate_values {
 
 		} elsif ($cur =~ /^(\()/o) {
 			print "PAREN('$1')\n" if ($dbg_values > 1);
-			$av_paren++;
+			push(@av_paren_type, $av_pending);
+			$av_pending = '_';
 			$type = 'N';
 
 		} elsif ($cur =~ /^(\))/o) {
-			$av_paren-- if ($av_paren > 0);
-			if (defined $av_paren_type[$av_paren]) {
-				$type = $av_paren_type[$av_paren];
-				undef $av_paren_type[$av_paren];
+			my $new_type = pop(@av_paren_type);
+			if ($new_type ne '_') {
+				$type = $new_type;
 				print "PAREN('$1') -> $type\n"
 							if ($dbg_values > 1);
 			} else {
@@ -670,7 +750,7 @@ sub annotate_values {
 
 		} elsif ($cur =~ /^($Ident)\(/o) {
 			print "FUNC($1)\n" if ($dbg_values > 1);
-			$av_paren_type[$av_paren] = 'V';
+			$av_pending = 'V';
 
 		} elsif ($cur =~ /^($Ident|$Constant)/o) {
 			print "IDENT($1)\n" if ($dbg_values > 1);
@@ -680,11 +760,11 @@ sub annotate_values {
 			print "ASSIGN($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
-		} elsif ($cur =~/^(;)/) {
+		} elsif ($cur =~/^(;|{|})/) {
 			print "END($1)\n" if ($dbg_values > 1);
 			$type = 'E';
 
-		} elsif ($cur =~ /^(;|{|}|\?|:|\[)/o) {
+		} elsif ($cur =~ /^(;|\?|:|\[)/o) {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -988,7 +1068,7 @@ sub process {
 		}
 
 # check for RCS/CVS revision markers
-		if ($rawline =~ /\$(Revision|Log|Id)(?:\$|)/) {
+		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
 			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
 		}
 
@@ -999,41 +1079,44 @@ sub process {
 
 # Check for potential 'bare' types
 		if ($realcnt) {
+			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
+			$s =~ s/\n./ /g;
+			$s =~ s/{.*$//;
+
 			# Ignore goto labels.
-			if ($line =~ /$Ident:\*$/) {
+			if ($s =~ /$Ident:\*$/) {
 
 			# Ignore functions being called
-			} elsif ($line =~ /^.\s*$Ident\s*\(/) {
+			} elsif ($s =~ /^.\s*$Ident\s*\(/) {
 
 			# definitions in global scope can only start with types
-			} elsif ($line =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/) {
-				possible($1, $line);
+			} elsif ($s =~ /^.(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?($Ident)\b/) {
+				possible($1, $s);
 
 			# declarations always start with types
-			} elsif ($prev_values eq 'E' && $line =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=|,)/) {
-				possible($1);
+			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:const\s+)?($Ident)\b(:?\s+$Sparse)?\s*\**\s*$Ident\s*(?:;|=|,)/) {
+				possible($1, $s);
 			}
 
 			# any (foo ... *) is a pointer cast, and foo is a type
-			while ($line =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/g) {
-				possible($1, $line);
+			while ($s =~ /\(($Ident)(?:\s+$Sparse)*\s*\*+\s*\)/g) {
+				possible($1, $s);
 			}
 
 			# Check for any sort of function declaration.
 			# int foo(something bar, other baz);
 			# void (*store_gdt)(x86_descr_ptr *);
-			if ($prev_values eq 'E' && $line =~ /^(.(?:typedef\s*)?(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {
+			if ($prev_values eq 'E' && $s =~ /^(.(?:typedef\s*)?(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*(?:\b$Ident|\(\*\s*$Ident\))\s*)\(/) {
 				my ($name_len) = length($1);
-				my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, $name_len);
-				my $ctx = join("\n", @ctx);
 
-				$ctx =~ s/\n.//;
+				my $ctx = $s;
 				substr($ctx, 0, $name_len + 1) = '';
 				$ctx =~ s/\)[^\)]*$//;
+
 				for my $arg (split(/\s*,\s*/, $ctx)) {
 					if ($arg =~ /^(?:const\s+)?($Ident)(?:\s+$Sparse)*\s*\**\s*(:?\b$Ident)?$/ || $arg =~ /^($Ident)$/) {
 
-						possible($1, $line);
+						possible($1, $s);
 					}
 				}
 			}
@@ -1100,8 +1183,8 @@ sub process {
 		$curr_values = $prev_values . $curr_values;
 		if ($dbg_values) {
 			my $outline = $opline; $outline =~ s/\t/ /g;
-			warn "--> .$outline\n";
-			warn "--> $curr_values\n";
+			print "$linenr > .$outline\n";
+			print "$linenr > $curr_values\n";
 		}
 		$prev_values = substr($curr_values, -1);
 
@@ -1148,7 +1231,9 @@ sub process {
 			if (($prevline !~ /^}/) &&
 			   ($prevline !~ /^\+}/) &&
 			   ($prevline !~ /^ }/) &&
-			   ($prevline !~ /\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=)/)) {
+			   ($prevline !~ /^.DECLARE_$Ident\(\Q$name\E\)/) &&
+			   ($prevline !~ /^.LIST_HEAD\(\Q$name\E\)/) &&
+			   ($prevline !~ /\b\Q$name\E(?:\s+$Attribute)?\s*(?:;|=|\[)/)) {
 				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
 			}
 		}
@@ -1266,7 +1351,7 @@ sub process {
 				=>|->|<<|>>|<|>|=|!|~|
 				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
 			}x;
-			my @elements = split(/($;+|$ops|;)/, $opline);
+			my @elements = split(/($ops|;)/, $opline);
 			my $off = 0;
 
 			my $blank = copy_spacing($opline);
@@ -1277,6 +1362,7 @@ sub process {
 				my $a = '';
 				$a = 'V' if ($elements[$n] ne '');
 				$a = 'W' if ($elements[$n] =~ /\s$/);
+				$a = 'C' if ($elements[$n] =~ /$;$/);
 				$a = 'B' if ($elements[$n] =~ /(\[|\()$/);
 				$a = 'O' if ($elements[$n] eq '');
 				$a = 'E' if ($elements[$n] eq '' && $n == 0);
@@ -1287,6 +1373,7 @@ sub process {
 				if (defined $elements[$n + 2]) {
 					$c = 'V' if ($elements[$n + 2] ne '');
 					$c = 'W' if ($elements[$n + 2] =~ /^\s/);
+					$c = 'C' if ($elements[$n + 2] =~ /^$;/);
 					$c = 'B' if ($elements[$n + 2] =~ /^(\)|\]|;)/);
 					$c = 'O' if ($elements[$n + 2] eq '');
 					$c = 'E' if ($elements[$n + 2] =~ /\s*\\$/);
@@ -1330,13 +1417,13 @@ sub process {
 				if ($op_type ne 'V' &&
 				    $ca =~ /\s$/ && $cc =~ /^\s*,/) {
 
-				# Ignore comments
-				} elsif ($op =~ /^$;+$/) {
+#				# Ignore comments
+#				} elsif ($op =~ /^$;+$/) {
 
 				# ; should have either the end of line or a space or \ after it
 				} elsif ($op eq ';') {
-					if ($ctx !~ /.x[WEB]/ && $cc !~ /^\\/ &&
-					    $cc !~ /^;/) {
+					if ($ctx !~ /.x[WEBC]/ &&
+					    $cc !~ /^\\/ && $cc !~ /^;/) {
 						ERROR("need space after that '$op' $at\n" . $hereptr);
 					}
 
@@ -1351,7 +1438,7 @@ sub process {
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
-					if ($ctx !~ /.xW|.xE/ && $cc !~ /^}/) {
+					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
 						ERROR("need space after that '$op' $at\n" . $hereptr);
 					}
 
@@ -1364,7 +1451,7 @@ sub process {
 				# unary operator, or a cast
 				} elsif ($op eq '!' || $op eq '~' ||
 				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {
-					if ($ctx !~ /[WEB]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
+					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("need space before that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /.xW/) {
@@ -1373,7 +1460,7 @@ sub process {
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
-					if ($ctx !~ /[WOB]x[^W]/ && $ctx !~ /[^W]x[WOBE]/) {
+					if ($ctx !~ /[WOBC]x[^W]/ && $ctx !~ /[^W]x[WOBEC]/) {
 						ERROR("need space one side of that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /WxB/ || ($ctx =~ /Wx./ && $cc =~ /^;/)) {
@@ -1387,13 +1474,13 @@ sub process {
 					 $op eq '*' or $op eq '/' or
 					 $op eq '%')
 				{
-					if ($ctx !~ /VxV|WxW|VxE|WxE|VxO/) {
+					if ($ctx !~ /VxV|WxW|VxE|WxE|VxO|Cx.|.xC/) {
 						ERROR("need consistent spacing around '$op' $at\n" .
 							$hereptr);
 					}
 
 				# All the others need spaces both sides.
-				} elsif ($ctx !~ /[EW]x[WE]/) {
+				} elsif ($ctx !~ /[EWC]x[CWE]/) {
 					# Ignore email addresses <foo@bar>
 					if (!($op eq '<' && $cb =~ /$;\S+\@\S+>/) &&
 					    !($op eq '>' && $cb =~ /<\S+\@\S+$;/)) {
@@ -1551,7 +1638,7 @@ sub process {
 
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
-# in a known goot container
+# in a known good container
 		if ($prevline =~ /\#define.*\\/ &&
 		   $prevline !~/(?:do\s+{|\(\{|\{)/ &&
 		   $line !~ /(?:do\s+{|\(\{|\{)/ &&
@@ -1599,84 +1686,95 @@ sub process {
 # check for redundant bracing round if etc
 		if ($line =~ /(^.*)\bif\b/ && $1 !~ /else\s*$/) {
 			my ($level, $endln, @chunks) =
-				ctx_statement_full($linenr, $realcnt, 0);
+				ctx_statement_full($linenr, $realcnt, 1);
 			#print "chunks<$#chunks> linenr<$linenr> endln<$endln> level<$level>\n";
-			if ($#chunks > 1 && $level == 0) {
+			#print "APW: <<$chunks[1][0]>><<$chunks[1][1]>>\n";
+			if ($#chunks > 0 && $level == 0) {
 				my $allowed = 0;
 				my $seen = 0;
+				my $herectx = $here . "\n";;
+				my $ln = $linenr - 1;
 				for my $chunk (@chunks) {
 					my ($cond, $block) = @{$chunk};
 
+					$herectx .= "$rawlines[$ln]\n[...]\n";
+					$ln += statement_rawlines($block) - 1;
+
 					substr($block, 0, length($cond)) = '';
 
 					$seen++ if ($block =~ /^\s*{/);
 
-					$block =~ s/(^|\n)./$1/g;
-					$block =~ s/^\s*{//;
-					$block =~ s/}\s*$//;
-					$block =~ s/^\s*//;
-					$block =~ s/\s*$//;
-
-					my @lines = ($block =~ /\n/g);
-					my @statements = ($block =~ /;/g);
-
-					#print "cond<$cond> block<$block> lines<" . scalar(@lines) . "> statements<" . scalar(@statements) . "> seen<$seen> allowed<$allowed>\n";
-					if (scalar(@lines) != 0) {
+					#print "cond<$cond> block<$block> allowed<$allowed>\n";
+					if (statement_lines($cond) > 1) {
+						#print "APW: ALLOWED: cond<$cond>\n";
 						$allowed = 1;
 					}
 					if ($block =~/\b(?:if|for|while)\b/) {
+						#print "APW: ALLOWED: block<$block>\n";
 						$allowed = 1;
 					}
-					if (scalar(@statements) > 1) {
+					if (statement_block_size($block) > 1) {
+						#print "APW: ALLOWED: lines block<$block>\n";
 						$allowed = 1;
 					}
 				}
 				if ($seen && !$allowed) {
-					WARN("braces {} are not necessary for any arm of this statement\n" . $herecurr);
-					$suppress_ifbraces = $endln;
+					WARN("braces {} are not necessary for any arm of this statement\n" . $herectx);
 				}
+				# Either way we have looked over this whole
+				# statement and said what needs to be said.
+				$suppress_ifbraces = $endln;
 			}
 		}
 		if ($linenr > $suppress_ifbraces &&
 					$line =~ /\b(if|while|for|else)\b/) {
-			# Locate the end of the opening statement.
-			my @control = ctx_statement($linenr, $realcnt, 0);
-			my $nr = $linenr + (scalar(@control) - 1);
-			my $cnt = $realcnt - (scalar(@control) - 1);
-
-			my $off = $realcnt - $cnt;
-			#print "$off: line<$line>end<" . $lines[$nr - 1] . ">\n";
-
-			# If this is is a braced statement group check it
-			if ($lines[$nr - 1] =~ /{\s*$/) {
-				my ($lvl, @block) = ctx_block_level($nr, $cnt);
-
-				my $stmt = join("\n", @block);
-				# Drop the diff line leader.
-				$stmt =~ s/\n./\n/g;
-				# Drop the code outside the block.
-				$stmt =~ s/(^[^{]*){\s*//;
-				my $before = $1;
-				$stmt =~ s/\s*}([^}]*$)//;
-				my $after = $1;
-
-				#print "block<" . join(' ', @block) . "><" . scalar(@block) . ">\n";
-				#print "before<$before> stmt<$stmt> after<$after>\n\n";
-
-				# Count the newlines, if there is only one
-				# then the block should not have {}'s.
-				my @lines = ($stmt =~ /\n/g);
-				my @statements = ($stmt =~ /;/g);
-				#print "lines<" . scalar(@lines) . ">\n";
-				#print "statements<" . scalar(@statements) . ">\n";
-				if ($lvl == 0 && scalar(@lines) == 0 &&
-				    scalar(@statements) < 2 &&
-				    $stmt !~ /{/ && $stmt !~ /\bif\b/ &&
-				    $before !~ /}/ && $after !~ /{/) {
-				    	my $herectx = "$here\n" . join("\n", @control, @block[1 .. $#block]) . "\n";
-				    	shift(@block);
-					WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
+			my ($level, $endln, @chunks) =
+				ctx_statement_full($linenr, $realcnt, $-[0]);
+
+			my $allowed = 0;
+
+			# Check the pre-context.
+			if (substr($line, 0, $-[0]) =~ /(\}\s*)$/) {
+				#print "APW: ALLOWED: pre<$1>\n";
+				$allowed = 1;
+			}
+			# Check the condition.
+			my ($cond, $block) = @{$chunks[0]};
+			if (defined $cond) {
+				substr($block, 0, length($cond)) = '';
+			}
+			if (statement_lines($cond) > 1) {
+				#print "APW: ALLOWED: cond<$cond>\n";
+				$allowed = 1;
+			}
+			if ($block =~/\b(?:if|for|while)\b/) {
+				#print "APW: ALLOWED: block<$block>\n";
+				$allowed = 1;
+			}
+			if (statement_block_size($block) > 1) {
+				#print "APW: ALLOWED: lines block<$block>\n";
+				$allowed = 1;
+			}
+			# Check the post-context.
+			if (defined $chunks[1]) {
+				my ($cond, $block) = @{$chunks[1]};
+				if (defined $cond) {
+					substr($block, 0, length($cond)) = '';
 				}
+				if ($block =~ /^\s*\{/) {
+					#print "APW: ALLOWED: chunk-1 block<$block>\n";
+					$allowed = 1;
+				}
+			}
+			if ($level == 0 && $block =~ /^\s*\{/ && !$allowed) {
+				my $herectx = $here . "\n";;
+				my $end = $linenr + statement_rawlines($block) - 1;
+
+				for (my $ln = $linenr - 1; $ln < $end; $ln++) {
+					$herectx .= $rawlines[$ln] . "\n";;
+				}
+
+				WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
 			}
 		}
 
@@ -1828,15 +1926,6 @@ sub process {
 		print "are false positives report them to the maintainer, see\n";
 		print "CHECKPATCH in MAINTAINERS.\n";
 	}
-	print <<EOL if ($file == 1 && $quiet == 0);
-
-WARNING: Using --file mode. Please do not send patches to linux-kernel
-that change whole existing files if you did not significantly change most
-of the the file for other reasons anyways or just wrote the file newly
-from scratch. Pure code style patches have a significant cost in a
-quickly changing code base like Linux because they cause rejects
-with other changes.
-EOL
 
 	return $clean;
 }
_

Patches currently in -mm which might be from apw@shadowen.org are

hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy.patch
register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch
kthread-synchronization-issues.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
update-checkpatchpl-to-version-015.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
page-owner-tracking-leak-detector.patch
