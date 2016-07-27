From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-simplify-hugetlb-unmap.patch removed from -mm tree
Date: Wed, 27 Jul 2016 12:01:09 -0700
Message-ID: <579904f5.3gMs2pTVvVceW6+3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:01:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, kirill@shutemov.name, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: simplify hugetlb unmap
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-simplify-hugetlb-unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/hugetlb: simplify hugetlb unmap

For hugetlb like THP (and unlike regular page), we do tlb flush after
dropping ptl. Because of the above, we don't need to track force_flush
like we do now. Instead we can simply call tlb_remove_page() which
will do the flush if needed.

No functionality change in this patch.

Link: http://lkml.kernel.org/r/1465049193-22197-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   54 +++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-simplify-hugetlb-unmap mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-simplify-hugetlb-unmap
+++ a/mm/hugetlb.c
@@ -3177,7 +3177,6 @@ void __unmap_hugepage_range(struct mmu_g
 			    unsigned long start, unsigned long end,
 			    struct page *ref_page)
 {
-	int force_flush = 0;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
 	pte_t *ptep;
@@ -3196,19 +3195,22 @@ void __unmap_hugepage_range(struct mmu_g
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
@@ -3216,7 +3218,8 @@ again:
 		 */
 		if (unlikely(!pte_present(pte))) {
 			huge_pte_clear(mm, address, ptep);
-			goto unlock;
+			spin_unlock(ptl);
+			continue;
 		}
 
 		page = pte_page(pte);
@@ -3226,9 +3229,10 @@ again:
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
@@ -3244,30 +3248,14 @@ again:
 
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


