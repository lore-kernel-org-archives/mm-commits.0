From: akpm@linux-foundation.org
Subject: - checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:51 -0700
Message-ID: <200807242326.m6ONQp0l011019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883AbYGXX07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: variants -- move the main unary/binary operators to use variants
has been removed from the -mm tree.  Its filename was
     checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: variants -- move the main unary/binary operators to use variants
From: Andy Whitcroft <apw@shadowen.org>

Now that we have a variants system, move to using that to carry the
unary/binary designation for +, -, &, and *.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants
+++ a/scripts/checkpatch.pl
@@ -858,6 +858,19 @@ sub annotate_values {
 			print "CLOSE($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
+		} elsif ($cur =~ /^(-(?![->])|\+(?!\+)|\*|\&(?!\&))/o) {
+			my $variant;
+
+			print "OPV($1)\n" if ($dbg_values > 1);
+			if ($type eq 'V') {
+				$variant = 'B';
+			} else {
+				$variant = 'U';
+			}
+
+			substr($var, length($res), 1, $variant);
+			$type = 'N';
+
 		} elsif ($cur =~ /^($Operators)/o) {
 			print "OP($1)\n" if ($dbg_values > 1);
 			if ($1 ne '++' && $1 ne '--') {
@@ -1573,22 +1586,8 @@ sub process {
 				my $ptr = substr($blank, 0, $off) . "^";
 				my $hereptr = "$hereline$ptr\n";
 
-				# Classify operators into binary, unary, or
-				# definitions (* only) where they have more
-				# than one mode.
+				# Pull out the value of this operator.
 				my $op_type = substr($curr_values, $off + 1, 1);
-				my $op_left = substr($curr_values, $off, 1);
-				my $is_unary;
-				if ($op_type eq 'T') {
-					$is_unary = 2;
-				} elsif ($op_left eq 'V') {
-					$is_unary = 0;
-				} else {
-					$is_unary = 1;
-				}
-				#if ($op eq '-' || $op eq '&' || $op eq '*') {
-				#	print "UNARY: <$op_left$op_type $is_unary $a:$op:$c> <$ca:$op:$cc> <$unary_ctx>\n";
-				#}
 
 				# Get the full operator variant.
 				my $opv = $op . substr($curr_vars, $off, 1);
@@ -1625,18 +1624,19 @@ sub process {
 					}
 
 				# '*' as part of a type definition -- reported already.
-				} elsif ($op eq '*' && $is_unary == 2) {
+				} elsif ($opv eq '*_') {
 					#warn "'*' is part of type\n";
 
 				# unary operators should have a space before and
 				# none after.  May be left adjacent to another
 				# unary operator, or a cast
 				} elsif ($op eq '!' || $op eq '~' ||
-				         ($is_unary && ($op eq '*' || $op eq '-' || $op eq '&'))) {
+					 $opv eq '*U' || $opv eq '-U' ||
+					 $opv eq '&U') {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
-					if ($op  eq '*' && $cc =~/\s*const\b/) {
+					if ($op eq '*' && $cc =~/\s*const\b/) {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
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

