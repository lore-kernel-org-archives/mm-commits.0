From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 062/131] khugepaged: do not stop collapse if less
 than half PTEs are referenced
Date: Wed, 03 Jun 2020 16:00:09 -0700
Message-ID: <20200603230009.Z_axHLHCe%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXAL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:00:11 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: do not stop collapse if less than half PTEs are referenced

__collapse_huge_page_swapin() checks the number of referenced PTE to
decide if the memory range is hot enough to justify swapin.

We have few problems with the approach:

 - It is way too late: we can do the check much earlier and safe time.
   khugepaged_scan_pmd() already knows if we have any pages to swap in
   and number of referenced page.

 - It stops collapse altogether if there's not enough referenced pages,
   not only swappingin.

Fix it by making the right check early. We also can avoid additional
page table scanning if khugepaged_scan_pmd() haven't found any swap
entries.

Link: http://lkml.kernel.org/r/20200416160026.16538-3-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 0db501f7a34c ("mm, thp: convert from optimistic swapin collapsing to conservative")
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/mm/khugepaged.c~khugepaged-do-not-stop-collapse-if-less-than-half-ptes-are-referenced
+++ a/mm/khugepaged.c
@@ -899,11 +899,6 @@ static bool __collapse_huge_page_swapin(
 		.pgoff = linear_page_index(vma, address),
 	};
 
-	/* we only decide to swapin, if there is enough young ptes */
-	if (referenced < HPAGE_PMD_NR/2) {
-		trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
-		return false;
-	}
 	vmf.pte = pte_offset_map(pmd, address);
 	for (; vmf.address < address + HPAGE_PMD_NR*PAGE_SIZE;
 			vmf.pte++, vmf.address += PAGE_SIZE) {
@@ -943,7 +938,7 @@ static bool __collapse_huge_page_swapin(
 static void collapse_huge_page(struct mm_struct *mm,
 				   unsigned long address,
 				   struct page **hpage,
-				   int node, int referenced)
+				   int node, int referenced, int unmapped)
 {
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
@@ -1000,7 +995,8 @@ static void collapse_huge_page(struct mm
 	 * If it fails, we release mmap_sem and jump out_nolock.
 	 * Continuing to collapse causes inconsistency.
 	 */
-	if (!__collapse_huge_page_swapin(mm, vma, address, pmd, referenced)) {
+	if (unmapped && !__collapse_huge_page_swapin(mm, vma, address,
+						     pmd, referenced)) {
 		mem_cgroup_cancel_charge(new_page, memcg, true);
 		up_read(&mm->mmap_sem);
 		goto out_nolock;
@@ -1233,22 +1229,21 @@ static int khugepaged_scan_pmd(struct mm
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced++;
 	}
-	if (writable) {
-		if (referenced) {
-			result = SCAN_SUCCEED;
-			ret = 1;
-		} else {
-			result = SCAN_LACK_REFERENCED_PAGE;
-		}
-	} else {
+	if (!writable) {
 		result = SCAN_PAGE_RO;
+	} else if (!referenced || (unmapped && referenced < HPAGE_PMD_NR/2)) {
+		result = SCAN_LACK_REFERENCED_PAGE;
+	} else {
+		result = SCAN_SUCCEED;
+		ret = 1;
 	}
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (ret) {
 		node = khugepaged_find_target_node();
 		/* collapse_huge_page will return with the mmap_sem released */
-		collapse_huge_page(mm, address, hpage, node, referenced);
+		collapse_huge_page(mm, address, hpage, node,
+				referenced, unmapped);
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, page, writable, referenced,
_
