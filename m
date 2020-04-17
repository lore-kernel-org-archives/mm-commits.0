From: akpm@linux-foundation.org
Subject: +
 khugepaged-do-not-stop-collapse-if-less-than-half-ptes-are-referenced.patch
 added to -mm tree
Date: Thu, 16 Apr 2020 21:43:33 -0700
Message-ID: <20200417044333.BO-9tHqFi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQEnf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 00:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: khugepaged: do not stop collapse if less than half PTEs are referenced
has been added to the -mm tree.  Its filename is
     khugepaged-do-not-stop-collapse-if-less-than-half-ptes-are-referenced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-do-not-stop-collapse-if-less-than-half-ptes-are-referenced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-do-not-stop-collapse-if-less-than-half-ptes-are-referenced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
+				pmd, referenced)) {
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

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

khugepaged-add-self-test.patch
khugepaged-do-not-stop-collapse-if-less-than-half-ptes-are-referenced.patch
khugepaged-drain-all-lru-caches-before-scanning-pages.patch
khugepaged-drain-lru-add-pagevec-after-swapin.patch
khugepaged-allow-to-collapse-a-page-shared-across-fork.patch
khugepaged-allow-to-collapse-pte-mapped-compound-pages.patch
thp-change-cow-semantics-for-anon-thp.patch
khugepaged-introduce-max_ptes_shared-tunable.patch
