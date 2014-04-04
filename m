From: akpm@linux-foundation.org
Subject: [merged] mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:06 -0700
Message-ID: <533f08b6.4FYr8tygMlfJH79z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaDDTcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:06 -0700


The patch titled
     Subject: mm, thp: drop do_huge_pmd_wp_zero_page_fallback()
has been removed from the -mm tree.  Its filename was
     mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, thp: drop do_huge_pmd_wp_zero_page_fallback()

I've realized that there's no need for
do_huge_pmd_wp_zero_page_fallback().  We can just split zero page with
split_huge_page_pmd() and return VM_FAULT_FALLBACK.  handle_pte_fault()
will handle write-protection fault for us.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   79 +--------------------------------------------
 1 file changed, 2 insertions(+), 77 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-drop-do_huge_pmd_wp_zero_page_fallback mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-drop-do_huge_pmd_wp_zero_page_fallback
+++ a/mm/huge_memory.c
@@ -941,81 +941,6 @@ unlock:
 	spin_unlock(ptl);
 }
 
-static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long address,
-		pmd_t *pmd, pmd_t orig_pmd, unsigned long haddr)
-{
-	spinlock_t *ptl;
-	pgtable_t pgtable;
-	pmd_t _pmd;
-	struct page *page;
-	int i, ret = 0;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
-
-	page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
-	if (!page) {
-		ret |= VM_FAULT_OOM;
-		goto out;
-	}
-
-	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
-		put_page(page);
-		ret |= VM_FAULT_OOM;
-		goto out;
-	}
-
-	clear_user_highpage(page, address);
-	__SetPageUptodate(page);
-
-	mmun_start = haddr;
-	mmun_end   = haddr + HPAGE_PMD_SIZE;
-	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
-
-	ptl = pmd_lock(mm, pmd);
-	if (unlikely(!pmd_same(*pmd, orig_pmd)))
-		goto out_free_page;
-
-	pmdp_clear_flush(vma, haddr, pmd);
-	/* leave pmd empty until pte is filled */
-
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
-	pmd_populate(mm, &_pmd, pgtable);
-
-	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
-		pte_t *pte, entry;
-		if (haddr == (address & PAGE_MASK)) {
-			entry = mk_pte(page, vma->vm_page_prot);
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-			page_add_new_anon_rmap(page, vma, haddr);
-		} else {
-			entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
-			entry = pte_mkspecial(entry);
-		}
-		pte = pte_offset_map(&_pmd, haddr);
-		VM_BUG_ON(!pte_none(*pte));
-		set_pte_at(mm, haddr, pte, entry);
-		pte_unmap(pte);
-	}
-	smp_wmb(); /* make pte visible before pmd */
-	pmd_populate(mm, pmd, pgtable);
-	spin_unlock(ptl);
-	put_huge_zero_page();
-	inc_mm_counter(mm, MM_ANONPAGES);
-
-	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-
-	ret |= VM_FAULT_WRITE;
-out:
-	return ret;
-out_free_page:
-	spin_unlock(ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-	mem_cgroup_uncharge_page(page);
-	put_page(page);
-	goto out;
-}
-
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
@@ -1161,8 +1086,8 @@ alloc:
 
 	if (unlikely(!new_page)) {
 		if (!page) {
-			ret = do_huge_pmd_wp_zero_page_fallback(mm, vma,
-					address, pmd, orig_pmd, haddr);
+			split_huge_page_pmd(vma, address, pmd);
+			ret |= VM_FAULT_FALLBACK;
 		} else {
 			ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 					pmd, orig_pmd, page, haddr);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-introduce-vm_ops-map_pages.patch
mm-introduce-vm_ops-map_pages-fix.patch
mm-implement-map_pages-for-page-cache.patch
mm-implement-map_pages-for-page-cache-fix.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

