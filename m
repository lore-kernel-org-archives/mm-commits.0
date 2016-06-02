From: akpm@linux-foundation.org
Subject: + mm-hugetlb-simplify-hugetlb-unmap.patch added to -mm tree
Date: Thu, 02 Jun 2016 13:13:00 -0700
Message-ID: <5750934c.UNChkDgzS/LU88vl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbcFBUNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 16:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, minchan.kim@gmail.com, mpe@ellerman.id.au, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: simplify hugetlb unmap
has been added to the -mm tree.  Its filename is
     mm-hugetlb-simplify-hugetlb-unmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-simplify-hugetlb-unmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-simplify-hugetlb-unmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/hugetlb: simplify hugetlb unmap

For hugetlb like THP (and unlike regular page), we do tlb flush after
dropping ptl.  Because of the above, we don't need to track force_flush
like we do now.  Instead we can simply call tlb_remove_page() which will
do the flush if needed.

No functionality change in this patch.

Link: http://lkml.kernel.org/r/1464860389-29019-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   54 +++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-simplify-hugetlb-unmap mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-simplify-hugetlb-unmap
+++ a/mm/hugetlb.c
@@ -3176,7 +3176,6 @@ void __unmap_hugepage_range(struct mmu_g
 			    unsigned long start, unsigned long end,
 			    struct page *ref_page)
 {
-	int force_flush = 0;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
 	pte_t *ptep;
@@ -3195,19 +3194,22 @@ void __unmap_hugepage_range(struct mmu_g
 	tlb_start_vma(tlb, vma);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	address = start;
-again:
 	for (; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, &address, ptep))
-			goto unlock;
+		if (huge_pmd_unshare(mm, &address, ptep)) {
+			spin_unlock(ptl);
+			continue;
+		}
 
 		pte = huge_ptep_get(ptep);
-		if (huge_pte_none(pte))
-			goto unlock;
+		if (huge_pte_none(pte)) {
+			spin_unlock(ptl);
+			continue;
+		}
 
 		/*
 		 * Migrating hugepage or HWPoisoned hugepage is already
@@ -3215,7 +3217,8 @@ again:
 		 */
 		if (unlikely(!pte_present(pte))) {
 			huge_pte_clear(mm, address, ptep);
-			goto unlock;
+			spin_unlock(ptl);
+			continue;
 		}
 
 		page = pte_page(pte);
@@ -3225,9 +3228,10 @@ again:
 		 * are about to unmap is the actual page of interest.
 		 */
 		if (ref_page) {
-			if (page != ref_page)
-				goto unlock;
-
+			if (page != ref_page) {
+				spin_unlock(ptl);
+				continue;
+			}
 			/*
 			 * Mark the VMA as having unmapped its page so that
 			 * future faults in this VMA will fail rather than
@@ -3243,30 +3247,14 @@ again:
 
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page, true);
-		force_flush = !__tlb_remove_page(tlb, page);
-		if (force_flush) {
-			address += sz;
-			spin_unlock(ptl);
-			break;
-		}
-		/* Bail out after unmapping reference page if supplied */
-		if (ref_page) {
-			spin_unlock(ptl);
-			break;
-		}
-unlock:
+
 		spin_unlock(ptl);
-	}
-	/*
-	 * mmu_gather ran out of room to batch pages, we break out of
-	 * the PTE lock to avoid doing the potential expensive TLB invalidate
-	 * and page-free while holding it.
-	 */
-	if (force_flush) {
-		force_flush = 0;
-		tlb_flush_mmu(tlb);
-		if (address < end && !ref_page)
-			goto again;
+		tlb_remove_page(tlb, page);
+		/*
+		 * Bail out after unmapping reference page if supplied
+		 */
+		if (ref_page)
+			break;
 	}
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	tlb_end_vma(tlb, vma);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-debug-add-vm_warn-which-maps-to-warn.patch
powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch
mm-hugetlb-simplify-hugetlb-unmap.patch
mm-change-the-interface-for-__tlb_remove_page.patch
mm-mmu_gather-track-page-size-with-mmu-gather-and-force-flush-if-page-size-change.patch
powerpc-mm-radix-implement-tlb-mmu-gather-flush-efficiently.patch
a.patch

