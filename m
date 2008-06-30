From: akpm@linux-foundation.org
Subject: + checkpatch-condition-loop-indent-checks.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:19:46 -0700
Message-ID: <200806302219.m5UMJk2v028582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933709AbYF3WTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:19:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: condition/loop indent checks
has been added to the -mm tree.  Its filename is
     checkpatch-condition-loop-indent-checks.patch

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

mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
checkpatch-version-020.patch
checkpatch-return-is-not-a-function-parentheses-for-casts-are-ok-too.patch
checkpatch-types-some-types-may-also-be-identifiers.patch
checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall.patch
checkpatch-possible-types-__asm__-is-never-a-type.patch
checkpatch-comment-detection-ignore-macro-continuation-when-detecting-associated-comments.patch
checkpatch-types-unary-goto-introduces-unary-context.patch
checkpatch-macros-fix-statement-counting-block-end-detection.patch
checkpatch-trailing-statement-indent-fix-end-of-statement-location.patch
checkpatch-allow-printk-strings-to-exceed-80-characters-to-maintain-their-searchability.patch
checkpatch-switch-report-trailing-statements-on-case-and-default.patch
checkpatch-check-spacing-for-square-brackets.patch
checkpatch-toughen-trailing-if-statement-checks-and-extend-them-to-while-and-for.patch
checkpatch-condition-loop-indent-checks.patch
checkpatch-usb_free_urb-can-take-null.patch
checkpatch-correct-spelling-in-kfree-checks.patch
checkpatch-allow-for-type-modifiers-on-multiple-declarations.patch
checkpatch-improve-type-matcher-debug.patch
checkpatch-possible-modifiers-are-not-being-correctly-matched.patch
checkpatch-macro-complexity-checks-are-meaningless-in-linker-scripts.patch
checkpatch-handle-return-types-of-pointers-to-functions.patch
checkpatch-possible-types-known-modifiers-cannot-be-types.patch
checkpatch-possible-modifiers-handle-multiple-modifiers-and-trailing.patch
x86-implement-pte_special.patch
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

