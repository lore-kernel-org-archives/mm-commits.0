From: akpm@linux-foundation.org
Subject: - allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:37 -0700
Message-ID: <200808130852.m7D8qbBk008224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbYHMJGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, gerald.schaefer@de.ibm.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     allocate structures for reservation tracking in hugetlbfs outside of spinlocks v2
has been removed from the -mm tree.  Its filename was
     allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: allocate structures for reservation tracking in hugetlbfs outside of spinlocks v2
From: Andy Whitcroft <apw@shadowen.org>

[Andrew this should replace the previous version which did not check
the returns from the region prepare for errors.  This has been tested by
us and Gerald and it looks good.

Bah, while reviewing the locking based on your previous email I spotted
that we need to check the return from the vma_needs_reservation call for
allocation errors.  Here is an updated patch to correct this.  This passes
testing here.]

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Tested-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2
+++ a/mm/hugetlb.c
@@ -1949,7 +1949,10 @@ retry:
 	 * the spinlock.
 	 */
 	if (write_access && !(vma->vm_flags & VM_SHARED))
-		vma_needs_reservation(h, vma, address);
+		if (vma_needs_reservation(h, vma, address) < 0) {
+			ret = VM_FAULT_OOM;
+			goto backout_unlocked;
+		}
 
 	spin_lock(&mm->page_table_lock);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
@@ -1976,6 +1979,7 @@ out:
 
 backout:
 	spin_unlock(&mm->page_table_lock);
+backout_unlocked:
 	unlock_page(page);
 	put_page(page);
 	goto out;
@@ -2004,8 +2008,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	entry = huge_ptep_get(ptep);
 	if (huge_pte_none(entry)) {
 		ret = hugetlb_no_page(mm, vma, address, ptep, write_access);
-		mutex_unlock(&hugetlb_instantiation_mutex);
-		return ret;
+		goto out_unlock;
 	}
 
 	ret = 0;
@@ -2019,7 +2022,10 @@ int hugetlb_fault(struct mm_struct *mm, 
 	 * consumed.
 	 */
 	if (write_access && !pte_write(entry)) {
-		vma_needs_reservation(h, vma, address);
+		if (vma_needs_reservation(h, vma, address) < 0) {
+			ret = VM_FAULT_OOM;
+			goto out_unlock;
+		}
 
 		if (!(vma->vm_flags & VM_SHARED))
 			pagecache_page = hugetlbfs_pagecache_page(h,
@@ -2039,6 +2045,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 		put_page(pagecache_page);
 	}
 
+out_unlock:
 	mutex_unlock(&hugetlb_instantiation_mutex);
 
 	return ret;
_

Patches currently in -mm which might be from apw@shadowen.org are

checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch
checkpatch-values-double-ampersand-may-be-unary.patch
checkpatch-conditional-indent-labels-have-different-indent-rules.patch
checkpatch-switch-indent-allow-plain-return.patch
checkpatch-add-tests-for-the-attribute-matcher.patch
checkpatch-____cacheline_aligned-et-al-are-modifiers.patch
checkpatch-complex-macros-fix-up-extension-handling.patch
checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch
checkpatch-include-asm-checks-should-be-anchored.patch
checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch
checkpatch-report-any-absolute-references-to-kernel-source-files.patch
checkpatch-report-the-real-first-line-of-all-suspect-indents.patch
checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch
checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch
checkpatch-report-the-correct-lines-for-single-statement-blocks.patch
checkpatch-perform-indent-checks-on-perl.patch
checkpatch-version-022.patch
page-owner-tracking-leak-detector.patch

