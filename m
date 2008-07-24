From: akpm@linux-foundation.org
Subject: - checkpatch-add-checks-for-question-mark-and-colon-spacing.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:48 -0700
Message-ID: <200807242326.m6ONQmwX011016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885AbYGXX06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add checks for question mark and colon spacing
has been removed from the -mm tree.  Its filename was
     checkpatch-add-checks-for-question-mark-and-colon-spacing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add checks for question mark and colon spacing
From: Andy Whitcroft <apw@shadowen.org>

Add checks for the question mark colon operator spacing, and also check
the other uses of colon.  Colon means a number of things:

 - it introduces the else part of the ?: operator,
 - it terminates a goto label,
 - it terminates the case value,
 - it separates the identifier from the bit size on bit fields, and
 - it is used to introduce option types in asm().

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   81 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 9 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-checks-for-question-mark-and-colon-spacing scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-checks-for-question-mark-and-colon-spacing
+++ a/scripts/checkpatch.pl
@@ -689,17 +689,20 @@ sub cat_vet {
 my $av_preprocessor = 0;
 my $av_pending;
 my @av_paren_type;
+my $av_pend_colon;
 
 sub annotate_reset {
 	$av_preprocessor = 0;
 	$av_pending = '_';
 	@av_paren_type = ('E');
+	$av_pend_colon = 'O';
 }
 
 sub annotate_values {
 	my ($stream, $type) = @_;
 
 	my $res;
+	my $var = '_' x length($stream);
 	my $cur = $stream;
 
 	print "$stream\n" if ($dbg_values > 1);
@@ -784,7 +787,12 @@ sub annotate_values {
 			$av_pending = 'N';
 			$type = 'N';
 
-		} elsif ($cur =~/^(return|case|else|goto)/o) {
+		} elsif ($cur =~/^(case)/o) {
+			print "CASE($1)\n" if ($dbg_values > 1);
+			$av_pend_colon = 'C';
+			$type = 'N';
+
+		} elsif ($cur =~/^(return|else|goto)/o) {
 			print "KEYWORD($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -809,6 +817,15 @@ sub annotate_values {
 			$type = 'V';
 			$av_pending = 'V';
 
+		} elsif ($cur =~ /^($Ident\s*):/) {
+			if ($type eq 'E') {
+				$av_pend_colon = 'L';
+			} elsif ($type eq 'T') {
+				$av_pend_colon = 'B';
+			}
+			print "IDENT_COLON($1,$type>$av_pend_colon)\n" if ($dbg_values > 1);
+			$type = 'V';
+
 		} elsif ($cur =~ /^($Ident|$Constant)/o) {
 			print "IDENT($1)\n" if ($dbg_values > 1);
 			$type = 'V';
@@ -820,8 +837,24 @@ sub annotate_values {
 		} elsif ($cur =~/^(;|{|})/) {
 			print "END($1)\n" if ($dbg_values > 1);
 			$type = 'E';
+			$av_pend_colon = 'O';
 
-		} elsif ($cur =~ /^(;|\?|:|\[)/o) {
+		} elsif ($cur =~ /^(\?)/o) {
+			print "QUESTION($1)\n" if ($dbg_values > 1);
+			$type = 'N';
+
+		} elsif ($cur =~ /^(:)/o) {
+			print "COLON($1,$av_pend_colon)\n" if ($dbg_values > 1);
+
+			substr($var, length($res), 1, $av_pend_colon);
+			if ($av_pend_colon eq 'C' || $av_pend_colon eq 'L') {
+				$type = 'E';
+			} else {
+				$type = 'N';
+			}
+			$av_pend_colon = 'O';
+
+		} elsif ($cur =~ /^(;|\[)/o) {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -840,7 +873,7 @@ sub annotate_values {
 		}
 	}
 
-	return $res;
+	return ($res, $var);
 }
 
 sub possible {
@@ -1294,12 +1327,14 @@ sub process {
 
 		# Track the 'values' across context and added lines.
 		my $opline = $line; $opline =~ s/^./ /;
-		my $curr_values = annotate_values($opline . "\n", $prev_values);
+		my ($curr_values, $curr_vars) =
+				annotate_values($opline . "\n", $prev_values);
 		$curr_values = $prev_values . $curr_values;
 		if ($dbg_values) {
 			my $outline = $opline; $outline =~ s/\t/ /g;
 			print "$linenr > .$outline\n";
 			print "$linenr > $curr_values\n";
+			print "$linenr >  $curr_vars\n";
 		}
 		$prev_values = substr($curr_values, -1);
 
@@ -1490,7 +1525,8 @@ sub process {
 				<<=|>>=|<=|>=|==|!=|
 				\+=|-=|\*=|\/=|%=|\^=|\|=|&=|
 				=>|->|<<|>>|<|>|=|!|~|
-				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%
+				&&|\|\||,|\^|\+\+|--|&|\||\+|-|\*|\/|%|
+				\?|:
 			}x;
 			my @elements = split(/($ops|;)/, $opline);
 			my $off = 0;
@@ -1554,6 +1590,9 @@ sub process {
 				#	print "UNARY: <$op_left$op_type $is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
 				#}
 
+				# Get the full operator variant.
+				my $opv = $op . substr($curr_vars, $off, 1);
+
 				# Ignore operators passed as parameters.
 				if ($op_type ne 'V' &&
 				    $ca =~ /\s$/ && $cc =~ /^\s*,/) {
@@ -1571,8 +1610,10 @@ sub process {
 				# // is a comment
 				} elsif ($op eq '//') {
 
-				# -> should have no spaces
-				} elsif ($op eq '->') {
+				# No spaces for:
+				#   ->
+				#   :   when part of a bitfield
+				} elsif ($op eq '->' || $opv eq ':B') {
 					if ($ctx =~ /Wx.|.xW/) {
 						ERROR("spaces prohibited around that '$op' $at\n" . $hereptr);
 					}
@@ -1628,11 +1669,33 @@ sub process {
 							$hereptr);
 					}
 
+				# A colon needs no spaces before when it is
+				# terminating a case value or a label.
+				} elsif ($opv eq ':C' || $opv eq ':L') {
+					if ($ctx =~ /Wx./) {
+						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
+					}
+
 				# All the others need spaces both sides.
 				} elsif ($ctx !~ /[EWC]x[CWE]/) {
+					my $ok = 0;
+
 					# Ignore email addresses <foo@bar>
-					if (!($op eq '<' && $cb =~ /$;\S+\@\S+>/) &&
-					    !($op eq '>' && $cb =~ /<\S+\@\S+$;/)) {
+					if (($op eq '<' &&
+					     $cc =~ /^\S+\@\S+>/) ||
+					    ($op eq '>' &&
+					     $ca =~ /<\S+\@\S+$/))
+					{
+					    	$ok = 1;
+					}
+
+					# Ignore ?:
+					if (($opv eq ':O' && $ca =~ /\?$/) ||
+					    ($op eq '?' && $cc =~ /^:/)) {
+					    	$ok = 1;
+					}
+
+					if ($ok == 0) {
 						ERROR("spaces required around that '$op' $at\n" . $hereptr);
 					}
 				}
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

