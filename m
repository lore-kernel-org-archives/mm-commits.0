From: akpm@linux-foundation.org
Subject: - hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:00:05 -0700
Message-ID: <200807232312.m6NNCgE2016921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754048AbYGWXNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, agl@us.ibm.com, hannes@saeurebad.de, hugh@veritas.com, mel@csn.ul.ie, mtk.manpages@googlemail.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     huge page MAP_NORESERVE review cleanups
has been removed from the -mm tree.  Its filename was
     hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch

This patch was dropped because it was folded into hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: huge page MAP_NORESERVE review cleanups
From: Andy Whitcroft <apw@shadowen.org>

Use the new encapsulated huge page offset helper.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups
+++ a/mm/hugetlb.c
@@ -738,8 +738,7 @@ static int vma_needs_reservation(struct 
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		unsigned long idx = ((addr - vma->vm_start) >> HPAGE_SHIFT) +
-				(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+		pgoff_t idx = vma_pagecache_offset(vma, addr);
 		return region_chg(&inode->i_mapping->private_list,
 							idx, idx + 1);
 
@@ -757,8 +756,7 @@ static void vma_commit_reservation(struc
 	struct inode *inode = mapping->host;
 
 	if (vma->vm_flags & VM_SHARED) {
-		unsigned long idx = ((addr - vma->vm_start) >> HPAGE_SHIFT) +
-				(vma->vm_pgoff >> (HPAGE_SHIFT - PAGE_SHIFT));
+		pgoff_t idx = vma_pagecache_offset(vma, addr);
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 	}
 }
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
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
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
huge-page-private-reservation-review-cleanups.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-fix-a-hugepage-reservation-check-for-map_shared.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch
memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages.patch
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
checkpatch-add-checks-for-question-mark-and-colon-spacing.patch
checkpatch-variants-move-the-main-unary-binary-operators-to-use-variants.patch
checkpatch-complex-macros-need-to-ignore-comments.patch
checkpatch-types-cannot-start-mid-word-for-pointer-tests.patch
checkpatch-version-021.patch

