From: akpm@linux-foundation.org
Subject: [merged] thp-change-cow-semantics-for-anon-thp.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:19:06 -0700
Message-ID: <20200604171906.v3z9iIQ68%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFDRTI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, william.kucharski@oracle.com, yang.shi@linux.alibaba.com, ziy@nvidia.com


The patch titled
     Subject: thp: change CoW semantics for anon-THP
has been removed from the -mm tree.  Its filename was
     thp-change-cow-semantics-for-anon-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: change CoW semantics for anon-THP

Currently we have different copy-on-write semantics for anon- and
file-THP.  For anon-THP we try to allocate huge page on the write fault,
but on file-THP we split PMD and allocate 4k page.

Arguably, file-THP semantics is more desirable: we don't necessary want to
unshare full PMD range from the parent on the first access.  This is the
primary reason THP is unusable for some workloads, like Redis.

The original THP refcounting didn't allow to have PTE-mapped compound
pages, so we had no options, but to allocate huge page on CoW (with
fallback to 512 4k pages).

The current refcounting doesn't have such limitations and we can cut a lot
of complex code out of fault path.

khugepaged is now able to recover THP from such ranges if the
configuration allows.

Link: http://lkml.kernel.org/r/20200416160026.16538-8-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  250 ++++-----------------------------------------
 1 file changed, 25 insertions(+), 225 deletions(-)

--- a/mm/huge_memory.c~thp-change-cow-semantics-for-anon-thp
+++ a/mm/huge_memory.c
@@ -1255,263 +1255,63 @@ unlock:
 	spin_unlock(vmf->ptl);
 }
 
-static vm_fault_t do_huge_pmd_wp_page_fallback(struct vm_fault *vmf,
-			pmd_t orig_pmd, struct page *page)
-{
-	struct vm_area_struct *vma = vmf->vma;
-	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
-	struct mem_cgroup *memcg;
-	pgtable_t pgtable;
-	pmd_t _pmd;
-	int i;
-	vm_fault_t ret = 0;
-	struct page **pages;
-	struct mmu_notifier_range range;
-
-	pages = kmalloc_array(HPAGE_PMD_NR, sizeof(struct page *),
-			      GFP_KERNEL);
-	if (unlikely(!pages)) {
-		ret |= VM_FAULT_OOM;
-		goto out;
-	}
-
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		pages[i] = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE, vma,
-					       vmf->address, page_to_nid(page));
-		if (unlikely(!pages[i] ||
-			     mem_cgroup_try_charge_delay(pages[i], vma->vm_mm,
-				     GFP_KERNEL, &memcg, false))) {
-			if (pages[i])
-				put_page(pages[i]);
-			while (--i >= 0) {
-				memcg = (void *)page_private(pages[i]);
-				set_page_private(pages[i], 0);
-				mem_cgroup_cancel_charge(pages[i], memcg,
-						false);
-				put_page(pages[i]);
-			}
-			kfree(pages);
-			ret |= VM_FAULT_OOM;
-			goto out;
-		}
-		set_page_private(pages[i], (unsigned long)memcg);
-	}
-
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		copy_user_highpage(pages[i], page + i,
-				   haddr + PAGE_SIZE * i, vma);
-		__SetPageUptodate(pages[i]);
-		cond_resched();
-	}
-
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				haddr, haddr + HPAGE_PMD_SIZE);
-	mmu_notifier_invalidate_range_start(&range);
-
-	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd)))
-		goto out_free_pages;
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-
-	/*
-	 * Leave pmd empty until pte is filled note we must notify here as
-	 * concurrent CPU thread might write to new page before the call to
-	 * mmu_notifier_invalidate_range_end() happens which can lead to a
-	 * device seeing memory write in different order than CPU.
-	 *
-	 * See Documentation/vm/mmu_notifier.rst
-	 */
-	pmdp_huge_clear_flush_notify(vma, haddr, vmf->pmd);
-
-	pgtable = pgtable_trans_huge_withdraw(vma->vm_mm, vmf->pmd);
-	pmd_populate(vma->vm_mm, &_pmd, pgtable);
-
-	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
-		pte_t entry;
-		entry = mk_pte(pages[i], vma->vm_page_prot);
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-		memcg = (void *)page_private(pages[i]);
-		set_page_private(pages[i], 0);
-		page_add_new_anon_rmap(pages[i], vmf->vma, haddr, false);
-		mem_cgroup_commit_charge(pages[i], memcg, false, false);
-		lru_cache_add_active_or_unevictable(pages[i], vma);
-		vmf->pte = pte_offset_map(&_pmd, haddr);
-		VM_BUG_ON(!pte_none(*vmf->pte));
-		set_pte_at(vma->vm_mm, haddr, vmf->pte, entry);
-		pte_unmap(vmf->pte);
-	}
-	kfree(pages);
-
-	smp_wmb(); /* make pte visible before pmd */
-	pmd_populate(vma->vm_mm, vmf->pmd, pgtable);
-	page_remove_rmap(page, true);
-	spin_unlock(vmf->ptl);
-
-	/*
-	 * No need to double call mmu_notifier->invalidate_range() callback as
-	 * the above pmdp_huge_clear_flush_notify() did already call it.
-	 */
-	mmu_notifier_invalidate_range_only_end(&range);
-
-	ret |= VM_FAULT_WRITE;
-	put_page(page);
-
-out:
-	return ret;
-
-out_free_pages:
-	spin_unlock(vmf->ptl);
-	mmu_notifier_invalidate_range_end(&range);
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		memcg = (void *)page_private(pages[i]);
-		set_page_private(pages[i], 0);
-		mem_cgroup_cancel_charge(pages[i], memcg, false);
-		put_page(pages[i]);
-	}
-	kfree(pages);
-	goto out;
-}
-
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct page *page = NULL, *new_page;
-	struct mem_cgroup *memcg;
+	struct page *page;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
-	struct mmu_notifier_range range;
-	gfp_t huge_gfp;			/* for allocation and charge */
-	vm_fault_t ret = 0;
 
 	vmf->ptl = pmd_lockptr(vma->vm_mm, vmf->pmd);
 	VM_BUG_ON_VMA(!vma->anon_vma, vma);
+
 	if (is_huge_zero_pmd(orig_pmd))
-		goto alloc;
+		goto fallback;
+
 	spin_lock(vmf->ptl);
-	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd)))
-		goto out_unlock;
+
+	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
+		spin_unlock(vmf->ptl);
+		return 0;
+	}
 
 	page = pmd_page(orig_pmd);
 	VM_BUG_ON_PAGE(!PageCompound(page) || !PageHead(page), page);
-	/*
-	 * We can only reuse the page if nobody else maps the huge page or it's
-	 * part.
-	 */
+
+	/* Lock page for reuse_swap_page() */
 	if (!trylock_page(page)) {
 		get_page(page);
 		spin_unlock(vmf->ptl);
 		lock_page(page);
 		spin_lock(vmf->ptl);
 		if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
+			spin_unlock(vmf->ptl);
 			unlock_page(page);
 			put_page(page);
-			goto out_unlock;
+			return 0;
 		}
 		put_page(page);
 	}
+
+	/*
+	 * We can only reuse the page if nobody else maps the huge page or it's
+	 * part.
+	 */
 	if (reuse_swap_page(page, NULL)) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry,  1))
+		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
 			update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
-		ret |= VM_FAULT_WRITE;
 		unlock_page(page);
-		goto out_unlock;
-	}
-	unlock_page(page);
-	get_page(page);
-	spin_unlock(vmf->ptl);
-alloc:
-	if (__transparent_hugepage_enabled(vma) &&
-	    !transparent_hugepage_debug_cow()) {
-		huge_gfp = alloc_hugepage_direct_gfpmask(vma);
-		new_page = alloc_hugepage_vma(huge_gfp, vma, haddr, HPAGE_PMD_ORDER);
-	} else
-		new_page = NULL;
-
-	if (likely(new_page)) {
-		prep_transhuge_page(new_page);
-	} else {
-		if (!page) {
-			split_huge_pmd(vma, vmf->pmd, vmf->address);
-			ret |= VM_FAULT_FALLBACK;
-		} else {
-			ret = do_huge_pmd_wp_page_fallback(vmf, orig_pmd, page);
-			if (ret & VM_FAULT_OOM) {
-				split_huge_pmd(vma, vmf->pmd, vmf->address);
-				ret |= VM_FAULT_FALLBACK;
-			}
-			put_page(page);
-		}
-		count_vm_event(THP_FAULT_FALLBACK);
-		goto out;
-	}
-
-	if (unlikely(mem_cgroup_try_charge_delay(new_page, vma->vm_mm,
-					huge_gfp, &memcg, true))) {
-		put_page(new_page);
-		split_huge_pmd(vma, vmf->pmd, vmf->address);
-		if (page)
-			put_page(page);
-		ret |= VM_FAULT_FALLBACK;
-		count_vm_event(THP_FAULT_FALLBACK);
-		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
-		goto out;
-	}
-
-	count_vm_event(THP_FAULT_ALLOC);
-	count_memcg_events(memcg, THP_FAULT_ALLOC, 1);
-
-	if (!page)
-		clear_huge_page(new_page, vmf->address, HPAGE_PMD_NR);
-	else
-		copy_user_huge_page(new_page, page, vmf->address,
-				    vma, HPAGE_PMD_NR);
-	__SetPageUptodate(new_page);
-
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				haddr, haddr + HPAGE_PMD_SIZE);
-	mmu_notifier_invalidate_range_start(&range);
-
-	spin_lock(vmf->ptl);
-	if (page)
-		put_page(page);
-	if (unlikely(!pmd_same(*vmf->pmd, orig_pmd))) {
 		spin_unlock(vmf->ptl);
-		mem_cgroup_cancel_charge(new_page, memcg, true);
-		put_page(new_page);
-		goto out_mn;
-	} else {
-		pmd_t entry;
-		entry = mk_huge_pmd(new_page, vma->vm_page_prot);
-		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		pmdp_huge_clear_flush_notify(vma, haddr, vmf->pmd);
-		page_add_new_anon_rmap(new_page, vma, haddr, true);
-		mem_cgroup_commit_charge(new_page, memcg, false, true);
-		lru_cache_add_active_or_unevictable(new_page, vma);
-		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
-		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
-		if (!page) {
-			add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		} else {
-			VM_BUG_ON_PAGE(!PageHead(page), page);
-			page_remove_rmap(page, true);
-			put_page(page);
-		}
-		ret |= VM_FAULT_WRITE;
+		return VM_FAULT_WRITE;
 	}
+
+	unlock_page(page);
 	spin_unlock(vmf->ptl);
-out_mn:
-	/*
-	 * No need to double call mmu_notifier->invalidate_range() callback as
-	 * the above pmdp_huge_clear_flush_notify() did already call it.
-	 */
-	mmu_notifier_invalidate_range_only_end(&range);
-out:
-	return ret;
-out_unlock:
-	spin_unlock(vmf->ptl);
-	return ret;
+fallback:
+	__split_huge_pmd(vma, vmf->pmd, vmf->address, false, NULL);
+	return VM_FAULT_FALLBACK;
 }
 
 /*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are
