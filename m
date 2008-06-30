From: akpm@linux-foundation.org
Subject: + checkpatch-macros-fix-statement-counting-block-end-detection.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:19:34 -0700
Message-ID: <200806302219.m5UMJYaq028564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933646AbYF3WTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: macros: fix statement counting block end detection
has been added to the -mm tree.  Its filename is
     checkpatch-macros-fix-statement-counting-block-end-detection.patch

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
Subject: checkpatch: macros: fix statement counting block end detection
From: Andy Whitcroft <apw@shadowen.org>

We are incorrectly counting the lines in a block while accumulating
the trailing lines in a macro statement, leading to false positives.
Fix end of block handling and general counting for negative context lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-macros-fix-statement-counting-block-end-detection scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-macros-fix-statement-counting-block-end-detection
+++ a/scripts/checkpatch.pl
@@ -470,7 +470,9 @@ sub ctx_statement_block {
 		}
 		$off++;
 	}
+	# We are truly at the end, so shuffle to the next line.
 	if ($off == $len) {
+		$loff = $len + 1;
 		$line++;
 		$remain--;
 	}
@@ -1793,30 +1795,26 @@ sub process {
 				$lines[$ln - 1] =~ /^(?:-|..*\\$)/)
 			{
 				$ctx .= $rawlines[$ln - 1] . "\n";
+				$cnt-- if ($lines[$ln - 1] !~ /^-/);
 				$ln++;
-				$cnt--;
 			}
 			$ctx .= $rawlines[$ln - 1];
 
 			($dstat, $dcond, $ln, $cnt, $off) =
 				ctx_statement_block($linenr, $ln - $linenr + 1, 0);
 			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
-			#print "LINE<$lines[$ln]> len<" . length($lines[$ln]) . "\n";
+			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
 			# Extract the remainder of the define (if any) and
 			# rip off surrounding spaces, and trailing \'s.
 			$rest = '';
-			if (defined $lines[$ln - 1] &&
-			    $off > length($lines[$ln - 1]))
-			{
-				$ln++;
-				$cnt--;
-				$off = 0;
-			}
-			while ($cnt > 0) {
-				$rest .= substr($lines[$ln - 1], $off) . "\n";
+			while ($off != 0 || ($cnt > 0 && $rest =~ /(?:^|\\)\s*$/)) {
+				#print "ADDING $off <" . substr($lines[$ln - 1], $off) . ">\n";
+				if ($off != 0 || $lines[$ln - 1] !~ /^-/) {
+					$rest .= substr($lines[$ln - 1], $off) . "\n";
+					$cnt--;
+				}
 				$ln++;
-				$cnt--;
 				$off = 0;
 			}
 			$rest =~ s/\\\n.//g;
@@ -1847,6 +1845,7 @@ sub process {
 				DEFINE_PER_CPU|
 				__typeof__\(
 			}x;
+			#print "REST<$rest>\n";
 			if ($rest ne '') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
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

