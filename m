From: akpm@linux-foundation.org
Subject: [merged] thp-prepare-for-dax-huge-pages.patch removed from -mm
 tree
Date: Wed, 09 Sep 2015 12:42:56 -0700
Message-ID: <55f08bc0.3VgRi822NV1hPMu0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbbIITm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dhillf@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: prepare for DAX huge pages
has been removed from the -mm tree.  Its filename was
     thp-prepare-for-dax-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: thp: prepare for DAX huge pages

Add a vma_is_dax() helper macro to test whether the VMA is DAX, and use it
in zap_huge_pmd() and __split_huge_page_pmd().

[akpm@linux-foundation.org: fix build]
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dax.h |    4 +++
 mm/huge_memory.c    |   48 +++++++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 19 deletions(-)

diff -puN include/linux/dax.h~thp-prepare-for-dax-huge-pages include/linux/dax.h
--- a/include/linux/dax.h~thp-prepare-for-dax-huge-pages
+++ a/include/linux/dax.h
@@ -18,4 +18,8 @@ int dax_pfn_mkwrite(struct vm_area_struc
 #define dax_mkwrite(vma, vmf, gb, iod)		dax_fault(vma, vmf, gb, iod)
 #define __dax_mkwrite(vma, vmf, gb, iod)	__dax_fault(vma, vmf, gb, iod)
 
+static inline bool vma_is_dax(struct vm_area_struct *vma)
+{
+	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
+}
 #endif
diff -puN mm/huge_memory.c~thp-prepare-for-dax-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~thp-prepare-for-dax-huge-pages
+++ a/mm/huge_memory.c
@@ -16,6 +16,7 @@
 #include <linux/swap.h>
 #include <linux/shrinker.h>
 #include <linux/mm_inline.h>
+#include <linux/dax.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
@@ -794,7 +795,7 @@ static inline gfp_t alloc_hugepage_gfpma
 }
 
 /* Caller must hold page table lock. */
-static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		struct page *zero_page)
 {
@@ -1421,7 +1422,6 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	int ret = 0;
 
 	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		struct page *page;
 		pgtable_t pgtable;
 		pmd_t orig_pmd;
 		/*
@@ -1433,13 +1433,22 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		orig_pmd = pmdp_huge_get_and_clear_full(tlb->mm, addr, pmd,
 							tlb->fullmm);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
+		if (vma_is_dax(vma)) {
+			if (is_huge_zero_pmd(orig_pmd)) {
+				pgtable = NULL;
+			} else {
+				spin_unlock(ptl);
+				return 1;
+			}
+		} else {
+			pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
+		}
 		if (is_huge_zero_pmd(orig_pmd)) {
 			atomic_long_dec(&tlb->mm->nr_ptes);
 			spin_unlock(ptl);
 			put_huge_zero_page();
 		} else {
-			page = pmd_page(orig_pmd);
+			struct page *page = pmd_page(orig_pmd);
 			page_remove_rmap(page);
 			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
@@ -1448,7 +1457,8 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			spin_unlock(ptl);
 			tlb_remove_page(tlb, page);
 		}
-		pte_free(tlb->mm, pgtable);
+		if (pgtable)
+			pte_free(tlb->mm, pgtable);
 		ret = 1;
 	}
 	return ret;
@@ -2914,7 +2924,7 @@ void __split_huge_page_pmd(struct vm_are
 		pmd_t *pmd)
 {
 	spinlock_t *ptl;
-	struct page *page;
+	struct page *page = NULL;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	unsigned long mmun_start;	/* For mmu_notifiers */
@@ -2927,25 +2937,25 @@ void __split_huge_page_pmd(struct vm_are
 again:
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	ptl = pmd_lock(mm, pmd);
-	if (unlikely(!pmd_trans_huge(*pmd))) {
-		spin_unlock(ptl);
-		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-		return;
-	}
-	if (is_huge_zero_pmd(*pmd)) {
+	if (unlikely(!pmd_trans_huge(*pmd)))
+		goto unlock;
+	if (vma_is_dax(vma)) {
+		pmdp_huge_clear_flush(vma, haddr, pmd);
+	} else if (is_huge_zero_pmd(*pmd)) {
 		__split_huge_zero_page_pmd(vma, haddr, pmd);
-		spin_unlock(ptl);
-		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-		return;
+	} else {
+		page = pmd_page(*pmd);
+		VM_BUG_ON_PAGE(!page_count(page), page);
+		get_page(page);
 	}
-	page = pmd_page(*pmd);
-	VM_BUG_ON_PAGE(!page_count(page), page);
-	get_page(page);
+ unlock:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
-	split_huge_page(page);
+	if (!page)
+		return;
 
+	split_huge_page(page);
 	put_page(page);
 
 	/*
_

Patches currently in -mm which might be from willy@linux.intel.com are


