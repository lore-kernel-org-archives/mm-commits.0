From: akpm@linux-foundation.org
Subject: + thp-prepare-for-dax-huge-pages.patch added to -mm tree
Date: Mon, 13 Jul 2015 14:31:59 -0700
Message-ID: <55a42e4f.+lPjbilVBq0p9OHi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbbGMVcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:32:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dhillf@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: Prepare for DAX huge pages
has been added to the -mm tree.  Its filename is
     thp-prepare-for-dax-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-prepare-for-dax-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-prepare-for-dax-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: thp: Prepare for DAX huge pages

Add a vma_is_dax() helper macro to test whether the VMA is DAX, and use it
in zap_huge_pmd() and __split_huge_page_pmd().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dax.h |    4 +++
 mm/huge_memory.c    |   45 +++++++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 18 deletions(-)

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
@@ -1418,7 +1418,6 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	int ret = 0;
 
 	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		struct page *page;
 		pgtable_t pgtable;
 		pmd_t orig_pmd;
 		/*
@@ -1430,13 +1429,22 @@ int zap_huge_pmd(struct mmu_gather *tlb,
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
@@ -1445,7 +1453,8 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			spin_unlock(ptl);
 			tlb_remove_page(tlb, page);
 		}
-		pte_free(tlb->mm, pgtable);
+		if (pgtable)
+			pte_free(tlb->mm, pgtable);
 		ret = 1;
 	}
 	return ret;
@@ -2916,7 +2925,7 @@ void __split_huge_page_pmd(struct vm_are
 		pmd_t *pmd)
 {
 	spinlock_t *ptl;
-	struct page *page;
+	struct page *page = NULL;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	unsigned long mmun_start;	/* For mmu_notifiers */
@@ -2929,25 +2938,25 @@ void __split_huge_page_pmd(struct vm_are
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

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch

