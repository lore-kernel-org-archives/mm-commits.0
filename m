From: akpm@linux-foundation.org
Subject: - checkpatch-condition-loop-indent-checks.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:32 -0700
Message-ID: <200807242326.m6ONQWT1010987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755853AbYGXX0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: condition/loop indent checks
has been removed from the -mm tree.  Its filename was
     checkpatch-condition-loop-indent-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: condition/loop indent checks
From: Andy Whitcroft <apw@shadowen.org>

Check to see if the block/statement which a condition or loop introduces
is indented correctly.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   59 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-condition-loop-indent-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-condition-loop-indent-checks
+++ a/scripts/checkpatch.pl
@@ -1167,10 +1167,10 @@ sub process {
 		}
 
 # Check for potential 'bare' types
-		my ($stat, $cond);
+		my ($stat, $cond, $line_nr_next, $remain_next);
 		if ($realcnt && $line =~ /.\s*\S/) {
-			($stat, $cond) = ctx_statement_block($linenr,
-								$realcnt, 0);
+			($stat, $cond, $line_nr_next, $remain_next) =
+				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
 
@@ -1712,7 +1712,8 @@ sub process {
 			ERROR("space required before the open parenthesis '('\n" . $herecurr);
 		}
 
-# Check for illegal assignment in if conditional.
+# Check for illegal assignment in if conditional -- and check for trailing
+# statements after the conditional.
 		if ($line =~ /\b(?:if|while|for)\s*\(/ && $line !~ /^.\s*#/) {
 			my ($s, $c) = ($stat, $cond);
 
@@ -1732,6 +1733,56 @@ sub process {
 			}
 		}
 
+# Check relative indent for conditionals and blocks.
+		if ($line =~ /\b(?:(?:if|while|for)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
+			my ($s, $c) = ($stat, $cond);
+
+			substr($s, 0, length($c), '');
+
+			# Make sure we remove the line prefixes as we have
+			# none on the first line, and are going to readd them
+			# where necessary.
+			$s =~ s/\n./\n/gs;
+
+			# We want to check the first line inside the block
+			# starting at the end of the conditional, so remove:
+			#  1) any blank line termination
+			#  2) any opening brace { on end of the line
+			#  3) any do (...) {
+			my $continuation = 0;
+			my $check = 0;
+			$s =~ s/^.*\bdo\b//;
+			$s =~ s/^\s*{//;
+			if ($s =~ s/^\s*\\//) {
+				$continuation = 1;
+			}
+			if ($s =~ s/^\s*\n//) {
+				$check = 1;
+			}
+
+			# Also ignore a loop construct at the end of a
+			# preprocessor statement.
+			if (($prevline =~ /^.\s*#\s*define\s/ ||
+			    $prevline =~ /\\\s*$/) && $continuation == 0) {
+				$check = 0;
+			}
+
+			# Ignore the current line if its is a preprocessor
+			# line.
+			if ($s =~ /^\s*#\s*/) {
+				$check = 0;
+			}
+
+			my (undef, $sindent) = line_stats("+" . $s);
+
+			##print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s>\n";
+
+			if ($check && (($sindent % 8) != 0 ||
+			    ($sindent <= $indent && $s ne ''))) {
+				WARN("suspect code indent for conditional statements\n" . $herecurr);
+			}
+		}
+
 # Check for bitwise tests written as boolean
 		if ($line =~ /
 			(?:
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

