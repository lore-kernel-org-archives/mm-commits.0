From: akpm@linux-foundation.org
Subject: [folded-merged] thp-implement-splitting-pmd-for-huge-zero-page-v6.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:36:44 -0800
Message-ID: <20121212213645.08C3B82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:62305 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2LLVgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:36:46 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so130057yhr.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:36:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-implement-splitting-pmd-for-huge-zero-page-v6
has been removed from the -mm tree.  Its filename was
     thp-implement-splitting-pmd-for-huge-zero-page-v6.patch

This patch was dropped because it was folded into thp-implement-splitting-pmd-for-huge-zero-page.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp-implement-splitting-pmd-for-huge-zero-page-v6

We can't split huge zero page itself (and it's bug if we try), but we
can split the pmd which points to it.

On splitting the pmd we create a table with all ptes set to normal zero
page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~thp-implement-splitting-pmd-for-huge-zero-page-v6 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-implement-splitting-pmd-for-huge-zero-page-v6
+++ a/mm/huge_memory.c
@@ -2643,6 +2643,7 @@ static int khugepaged(void *none)
 static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		unsigned long haddr, pmd_t *pmd)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
 	pmd_t _pmd;
 	int i;
@@ -2650,8 +2651,8 @@ static void __split_huge_zero_page_pmd(s
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = get_pmd_huge_pte(vma->vm_mm);
-	pmd_populate(vma->vm_mm, &_pmd, pgtable);
+	pgtable = pgtable_trans_huge_withdraw(mm);
+	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
 		pte_t *pte, entry;
@@ -2659,11 +2660,11 @@ static void __split_huge_zero_page_pmd(s
 		entry = pte_mkspecial(entry);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
-		set_pte_at(vma->vm_mm, haddr, pte, entry);
+		set_pte_at(mm, haddr, pte, entry);
 		pte_unmap(pte);
 	}
 	smp_wmb(); /* make pte visible before pmd */
-	pmd_populate(vma->vm_mm, pmd, pgtable);
+	pmd_populate(mm, pmd, pgtable);
 }
 
 void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
@@ -2678,7 +2679,7 @@ void __split_huge_page_pmd(struct vm_are
 	BUG_ON(vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE);
 
 	mmun_start = haddr;
-	mmun_end   = address + HPAGE_PMD_SIZE;
+	mmun_end   = haddr + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-huge-zero-page-basic-preparation.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-change_huge_pmd-make-sure-we-dont-try-to-make-a-page-writable.patch
thp-change-split_huge_page_pmd-interface.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-setup-huge-zero-page-on-non-write-page-fault-fix.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-implement-refcounting-for-huge-zero-page-fix.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
asm-generic-mm-pgtable-consolidate-zero-page-helpers.patch

