From: akpm@linux-foundation.org
Subject: + thp-implement-splitting-pmd-for-huge-zero-page-v6.patch added to -mm tree
Date: Thu, 15 Nov 2012 12:49:37 -0800
Message-ID: <20121115204938.98EB320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:58875 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2KOVu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 16:50:29 -0500
Received: by mail-ea0-f202.google.com with SMTP id f11so139694eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 13:50:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: thp-implement-splitting-pmd-for-huge-zero-page-v6
has been added to the -mm tree.  Its filename is
     thp-implement-splitting-pmd-for-huge-zero-page-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~thp-implement-splitting-pmd-for-huge-zero-page-v6 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-implement-splitting-pmd-for-huge-zero-page-v6
+++ a/mm/huge_memory.c
@@ -2625,6 +2625,7 @@ static int khugepaged(void *none)
 static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		unsigned long haddr, pmd_t *pmd)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
 	pmd_t _pmd;
 	int i;
@@ -2632,8 +2633,8 @@ static void __split_huge_zero_page_pmd(s
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = get_pmd_huge_pte(vma->vm_mm);
-	pmd_populate(vma->vm_mm, &_pmd, pgtable);
+	pgtable = pgtable_trans_huge_withdraw(mm);
+	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
 		pte_t *pte, entry;
@@ -2641,18 +2642,17 @@ static void __split_huge_zero_page_pmd(s
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
 		pmd_t *pmd)
 {
 	struct page *page;
-	struct mm_struct *mm = vma->vm_mm;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long mmun_start;	/* For mmu_notifiers */
@@ -2661,7 +2661,7 @@ void __split_huge_page_pmd(struct vm_are
 	BUG_ON(vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE);
 
 	mmun_start = haddr;
-	mmun_end   = address + HPAGE_PMD_SIZE;
+	mmun_end   = haddr + HPAGE_PMD_SIZE;
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

linux-next.patch
mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch
thp-huge-zero-page-basic-preparation.patch
thp-huge-zero-page-basic-preparation-v6.patch
thp-zap_huge_pmd-zap-huge-zero-pmd.patch
thp-copy_huge_pmd-copy-huge-zero-page.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch
thp-do_huge_pmd_wp_page-handle-huge-zero-page-v6.patch
thp-change_huge_pmd-keep-huge-zero-page-write-protected.patch
thp-change-split_huge_page_pmd-interface.patch
thp-change-split_huge_page_pmd-interface-v6.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
thp-implement-splitting-pmd-for-huge-zero-page-v6.patch
thp-setup-huge-zero-page-on-non-write-page-fault.patch
thp-lazy-huge-zero-page-allocation.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events.patch
thp-vmstat-implement-hzp_alloc-and-hzp_alloc_failed-events-v6.patch
thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch

