From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:20:18 -0700
Message-ID: <20200604172018.l4_Fuwtw3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730053AbgFDRUV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, bsingharora@gmail.com, cai@lca.pw, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: convert anon and file-thp to new mem_cgroup_charge() API
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: convert anon and file-thp to new mem_cgroup_charge() API

With the page->mapping requirement gone from memcg, we can charge anon and
file-thp pages in one single step, right after they're allocated.

This removes two out of three API calls - especially the tricky commit
step that needed to happen at just the right time between when the page is
"set up" and when it's "published" - somewhat vague and fluid concepts
that varied by page type.  All we need is a freshly allocated page and a
memcg context to charge.

v2: prevent double charges on pre-allocated hugepages in khugepaged

[hannes@cmpxchg.org: Fix crash - *hpage could be ERR_PTR instead of NULL]
  Link: http://lkml.kernel.org/r/20200512215813.GA487759@cmpxchg.org
Link: http://lkml.kernel.org/r/20200508183105.225460-13-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    4 +---
 kernel/events/uprobes.c |   11 +++--------
 mm/filemap.c            |    2 +-
 mm/huge_memory.c        |    9 +++------
 mm/khugepaged.c         |   35 ++++++++++-------------------------
 mm/memory.c             |   36 ++++++++++--------------------------
 mm/migrate.c            |    5 +----
 mm/swapfile.c           |    6 +-----
 mm/userfaultfd.c        |    5 +----
 9 files changed, 31 insertions(+), 82 deletions(-)

--- a/include/linux/mm.h~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/include/linux/mm.h
@@ -501,7 +501,6 @@ struct vm_fault {
 	pte_t orig_pte;			/* Value of PTE at the time of fault */
 
 	struct page *cow_page;		/* Page handler may use for COW fault */
-	struct mem_cgroup *memcg;	/* Cgroup cow_page belongs to */
 	struct page *page;		/* ->fault handlers should return a
 					 * page here, unless VM_FAULT_NOPAGE
 					 * is set (which is also implied by
@@ -946,8 +945,7 @@ static inline pte_t maybe_mkwrite(pte_t
 	return pte;
 }
 
-vm_fault_t alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
-		struct page *page);
+vm_fault_t alloc_set_pte(struct vm_fault *vmf, struct page *page);
 vm_fault_t finish_fault(struct vm_fault *vmf);
 vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf);
 #endif
--- a/kernel/events/uprobes.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/kernel/events/uprobes.c
@@ -162,14 +162,13 @@ static int __replace_page(struct vm_area
 	};
 	int err;
 	struct mmu_notifier_range range;
-	struct mem_cgroup *memcg;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm, addr,
 				addr + PAGE_SIZE);
 
 	if (new_page) {
-		err = mem_cgroup_try_charge(new_page, vma->vm_mm, GFP_KERNEL,
-					    &memcg);
+		err = mem_cgroup_charge(new_page, vma->vm_mm, GFP_KERNEL,
+					false);
 		if (err)
 			return err;
 	}
@@ -179,16 +178,12 @@ static int __replace_page(struct vm_area
 
 	mmu_notifier_invalidate_range_start(&range);
 	err = -EAGAIN;
-	if (!page_vma_mapped_walk(&pvmw)) {
-		if (new_page)
-			mem_cgroup_cancel_charge(new_page, memcg);
+	if (!page_vma_mapped_walk(&pvmw))
 		goto unlock;
-	}
 	VM_BUG_ON_PAGE(addr != pvmw.address, old_page);
 
 	if (new_page) {
 		get_page(new_page);
-		mem_cgroup_commit_charge(new_page, memcg, false);
 		page_add_new_anon_rmap(new_page, vma, addr, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 	} else
--- a/mm/filemap.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/mm/filemap.c
@@ -2633,7 +2633,7 @@ void filemap_map_pages(struct vm_fault *
 		if (vmf->pte)
 			vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;
-		if (alloc_set_pte(vmf, NULL, page))
+		if (alloc_set_pte(vmf, page))
 			goto unlock;
 		unlock_page(page);
 		goto next;
--- a/mm/huge_memory.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/mm/huge_memory.c
@@ -587,19 +587,19 @@ static vm_fault_t __do_huge_pmd_anonymou
 			struct page *page, gfp_t gfp)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct mem_cgroup *memcg;
 	pgtable_t pgtable;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	vm_fault_t ret = 0;
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
-	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, gfp, &memcg)) {
+	if (mem_cgroup_charge(page, vma->vm_mm, gfp, false)) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
 		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
 		return VM_FAULT_FALLBACK;
 	}
+	cgroup_throttle_swaprate(page, gfp);
 
 	pgtable = pte_alloc_one(vma->vm_mm);
 	if (unlikely(!pgtable)) {
@@ -630,7 +630,6 @@ static vm_fault_t __do_huge_pmd_anonymou
 			vm_fault_t ret2;
 
 			spin_unlock(vmf->ptl);
-			mem_cgroup_cancel_charge(page, memcg);
 			put_page(page);
 			pte_free(vma->vm_mm, pgtable);
 			ret2 = handle_userfault(vmf, VM_UFFD_MISSING);
@@ -640,7 +639,6 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		mem_cgroup_commit_charge(page, memcg, false);
 		page_add_new_anon_rmap(page, vma, haddr, true);
 		lru_cache_add_active_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
@@ -649,7 +647,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
-		count_memcg_events(memcg, THP_FAULT_ALLOC, 1);
+		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
 	}
 
 	return 0;
@@ -658,7 +656,6 @@ unlock_release:
 release:
 	if (pgtable)
 		pte_free(vma->vm_mm, pgtable);
-	mem_cgroup_cancel_charge(page, memcg);
 	put_page(page);
 	return ret;
 
--- a/mm/khugepaged.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/mm/khugepaged.c
@@ -1037,7 +1037,6 @@ static void collapse_huge_page(struct mm
 	struct page *new_page;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int isolated = 0, result = 0;
-	struct mem_cgroup *memcg;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 	gfp_t gfp;
@@ -1060,15 +1059,15 @@ static void collapse_huge_page(struct mm
 		goto out_nolock;
 	}
 
-	if (unlikely(mem_cgroup_try_charge(new_page, mm, gfp, &memcg))) {
+	if (unlikely(mem_cgroup_charge(new_page, mm, gfp, false))) {
 		result = SCAN_CGROUP_CHARGE_FAIL;
 		goto out_nolock;
 	}
+	count_memcg_page_event(new_page, THP_COLLAPSE_ALLOC);
 
 	down_read(&mm->mmap_sem);
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result) {
-		mem_cgroup_cancel_charge(new_page, memcg);
 		up_read(&mm->mmap_sem);
 		goto out_nolock;
 	}
@@ -1076,7 +1075,6 @@ static void collapse_huge_page(struct mm
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd) {
 		result = SCAN_PMD_NULL;
-		mem_cgroup_cancel_charge(new_page, memcg);
 		up_read(&mm->mmap_sem);
 		goto out_nolock;
 	}
@@ -1088,7 +1086,6 @@ static void collapse_huge_page(struct mm
 	 */
 	if (unmapped && !__collapse_huge_page_swapin(mm, vma, address,
 						     pmd, referenced)) {
-		mem_cgroup_cancel_charge(new_page, memcg);
 		up_read(&mm->mmap_sem);
 		goto out_nolock;
 	}
@@ -1175,9 +1172,7 @@ static void collapse_huge_page(struct mm
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	mem_cgroup_commit_charge(new_page, memcg, false);
 	page_add_new_anon_rmap(new_page, vma, address, true);
-	count_memcg_events(memcg, THP_COLLAPSE_ALLOC, 1);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
@@ -1191,10 +1186,11 @@ static void collapse_huge_page(struct mm
 out_up_write:
 	up_write(&mm->mmap_sem);
 out_nolock:
+	if (!IS_ERR_OR_NULL(*hpage))
+		mem_cgroup_uncharge(*hpage);
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
 out:
-	mem_cgroup_cancel_charge(new_page, memcg);
 	goto out_up_write;
 }
 
@@ -1618,7 +1614,6 @@ static void collapse_file(struct mm_stru
 	struct address_space *mapping = file->f_mapping;
 	gfp_t gfp;
 	struct page *new_page;
-	struct mem_cgroup *memcg;
 	pgoff_t index, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1637,10 +1632,11 @@ static void collapse_file(struct mm_stru
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_try_charge(new_page, mm, gfp, &memcg))) {
+	if (unlikely(mem_cgroup_charge(new_page, mm, gfp, false))) {
 		result = SCAN_CGROUP_CHARGE_FAIL;
 		goto out;
 	}
+	count_memcg_page_event(new_page, THP_COLLAPSE_ALLOC);
 
 	/* This will be less messy when we use multi-index entries */
 	do {
@@ -1650,7 +1646,6 @@ static void collapse_file(struct mm_stru
 			break;
 		xas_unlock_irq(&xas);
 		if (!xas_nomem(&xas, GFP_KERNEL)) {
-			mem_cgroup_cancel_charge(new_page, memcg);
 			result = SCAN_FAIL;
 			goto out;
 		}
@@ -1844,18 +1839,9 @@ out_unlock:
 	}
 
 	if (nr_none) {
-		struct lruvec *lruvec;
-		/*
-		 * XXX: We have started try_charge and pinned the
-		 * memcg, but the page isn't committed yet so we
-		 * cannot use mod_lruvec_page_state(). This hackery
-		 * will be cleaned up when remove the page->mapping
-		 * dependency from memcg and fully charge above.
-		 */
-		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(new_page));
-		__mod_lruvec_state(lruvec, NR_FILE_PAGES, nr_none);
+		__mod_lruvec_page_state(new_page, NR_FILE_PAGES, nr_none);
 		if (is_shmem)
-			__mod_lruvec_state(lruvec, NR_SHMEM, nr_none);
+			__mod_lruvec_page_state(new_page, NR_SHMEM, nr_none);
 	}
 
 xa_locked:
@@ -1893,7 +1879,6 @@ xa_unlocked:
 
 		SetPageUptodate(new_page);
 		page_ref_add(new_page, HPAGE_PMD_NR - 1);
-		mem_cgroup_commit_charge(new_page, memcg, false);
 
 		if (is_shmem) {
 			set_page_dirty(new_page);
@@ -1901,7 +1886,6 @@ xa_unlocked:
 		} else {
 			lru_cache_add_file(new_page);
 		}
-		count_memcg_events(memcg, THP_COLLAPSE_ALLOC, 1);
 
 		/*
 		 * Remove pte page tables, so we can re-fault the page as huge.
@@ -1948,13 +1932,14 @@ xa_unlocked:
 		VM_BUG_ON(nr_none);
 		xas_unlock_irq(&xas);
 
-		mem_cgroup_cancel_charge(new_page, memcg);
 		new_page->mapping = NULL;
 	}
 
 	unlock_page(new_page);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
+	if (!IS_ERR_OR_NULL(*hpage))
+		mem_cgroup_uncharge(*hpage);
 	/* TODO: tracepoints */
 }
 
--- a/mm/memory.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/mm/memory.c
@@ -2645,7 +2645,6 @@ static vm_fault_t wp_page_copy(struct vm
 	struct page *new_page = NULL;
 	pte_t entry;
 	int page_copied = 0;
-	struct mem_cgroup *memcg;
 	struct mmu_notifier_range range;
 
 	if (unlikely(anon_vma_prepare(vma)))
@@ -2676,8 +2675,9 @@ static vm_fault_t wp_page_copy(struct vm
 		}
 	}
 
-	if (mem_cgroup_try_charge_delay(new_page, mm, GFP_KERNEL, &memcg))
+	if (mem_cgroup_charge(new_page, mm, GFP_KERNEL, false))
 		goto oom_free_new;
+	cgroup_throttle_swaprate(new_page, GFP_KERNEL);
 
 	__SetPageUptodate(new_page);
 
@@ -2710,7 +2710,6 @@ static vm_fault_t wp_page_copy(struct vm
 		 * thread doing COW.
 		 */
 		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
-		mem_cgroup_commit_charge(new_page, memcg, false);
 		page_add_new_anon_rmap(new_page, vma, vmf->address, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		/*
@@ -2749,8 +2748,6 @@ static vm_fault_t wp_page_copy(struct vm
 		/* Free the old page.. */
 		new_page = old_page;
 		page_copied = 1;
-	} else {
-		mem_cgroup_cancel_charge(new_page, memcg);
 	}
 
 	if (new_page)
@@ -3088,7 +3085,6 @@ vm_fault_t do_swap_page(struct vm_fault
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL, *swapcache;
-	struct mem_cgroup *memcg;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
@@ -3193,10 +3189,11 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_page;
 	}
 
-	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, GFP_KERNEL, &memcg)) {
+	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, true)) {
 		ret = VM_FAULT_OOM;
 		goto out_page;
 	}
+	cgroup_throttle_swaprate(page, GFP_KERNEL);
 
 	/*
 	 * Back out if somebody else already faulted in this pte.
@@ -3243,11 +3240,9 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
-		mem_cgroup_commit_charge(page, memcg, false);
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	} else {
-		mem_cgroup_commit_charge(page, memcg, true);
 		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
 		activate_page(page);
 	}
@@ -3284,7 +3279,6 @@ unlock:
 out:
 	return ret;
 out_nomap:
-	mem_cgroup_cancel_charge(page, memcg);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
 	unlock_page(page);
@@ -3305,7 +3299,6 @@ out_release:
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct mem_cgroup *memcg;
 	struct page *page;
 	vm_fault_t ret = 0;
 	pte_t entry;
@@ -3358,8 +3351,9 @@ static vm_fault_t do_anonymous_page(stru
 	if (!page)
 		goto oom;
 
-	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, GFP_KERNEL, &memcg))
+	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, false))
 		goto oom_free_page;
+	cgroup_throttle_swaprate(page, GFP_KERNEL);
 
 	/*
 	 * The memory barrier inside __SetPageUptodate makes sure that
@@ -3384,13 +3378,11 @@ static vm_fault_t do_anonymous_page(stru
 	/* Deliver the page fault to userland, check inside PT lock */
 	if (userfaultfd_missing(vma)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		mem_cgroup_cancel_charge(page, memcg);
 		put_page(page);
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-	mem_cgroup_commit_charge(page, memcg, false);
 	page_add_new_anon_rmap(page, vma, vmf->address, false);
 	lru_cache_add_active_or_unevictable(page, vma);
 setpte:
@@ -3402,7 +3394,6 @@ unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
 release:
-	mem_cgroup_cancel_charge(page, memcg);
 	put_page(page);
 	goto unlock;
 oom_free_page:
@@ -3607,7 +3598,6 @@ static vm_fault_t do_set_pmd(struct vm_f
  * mapping. If needed, the fucntion allocates page table or use pre-allocated.
  *
  * @vmf: fault environment
- * @memcg: memcg to charge page (only for private mappings)
  * @page: page to map
  *
  * Caller must take care of unlocking vmf->ptl, if vmf->pte is non-NULL on
@@ -3618,8 +3608,7 @@ static vm_fault_t do_set_pmd(struct vm_f
  *
  * Return: %0 on success, %VM_FAULT_ code in case of error.
  */
-vm_fault_t alloc_set_pte(struct vm_fault *vmf, struct mem_cgroup *memcg,
-		struct page *page)
+vm_fault_t alloc_set_pte(struct vm_fault *vmf, struct page *page)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
@@ -3627,9 +3616,6 @@ vm_fault_t alloc_set_pte(struct vm_fault
 	vm_fault_t ret;
 
 	if (pmd_none(*vmf->pmd) && PageTransCompound(page)) {
-		/* THP on COW? */
-		VM_BUG_ON_PAGE(memcg, page);
-
 		ret = do_set_pmd(vmf, page);
 		if (ret != VM_FAULT_FALLBACK)
 			return ret;
@@ -3652,7 +3638,6 @@ vm_fault_t alloc_set_pte(struct vm_fault
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-		mem_cgroup_commit_charge(page, memcg, false);
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	} else {
@@ -3702,7 +3687,7 @@ vm_fault_t finish_fault(struct vm_fault
 	if (!(vmf->vma->vm_flags & VM_SHARED))
 		ret = check_stable_address_space(vmf->vma->vm_mm);
 	if (!ret)
-		ret = alloc_set_pte(vmf, vmf->memcg, page);
+		ret = alloc_set_pte(vmf, page);
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
@@ -3862,11 +3847,11 @@ static vm_fault_t do_cow_fault(struct vm
 	if (!vmf->cow_page)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_try_charge_delay(vmf->cow_page, vma->vm_mm,
-					GFP_KERNEL, &vmf->memcg)) {
+	if (mem_cgroup_charge(vmf->cow_page, vma->vm_mm, GFP_KERNEL, false)) {
 		put_page(vmf->cow_page);
 		return VM_FAULT_OOM;
 	}
+	cgroup_throttle_swaprate(vmf->cow_page, GFP_KERNEL);
 
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
@@ -3884,7 +3869,6 @@ static vm_fault_t do_cow_fault(struct vm
 		goto uncharge_out;
 	return ret;
 uncharge_out:
-	mem_cgroup_cancel_charge(vmf->cow_page, vmf->memcg);
 	put_page(vmf->cow_page);
 	return ret;
 }
--- a/mm/migrate.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/mm/migrate.c
@@ -2740,7 +2740,6 @@ static void migrate_vma_insert_page(stru
 {
 	struct vm_area_struct *vma = migrate->vma;
 	struct mm_struct *mm = vma->vm_mm;
-	struct mem_cgroup *memcg;
 	bool flush = false;
 	spinlock_t *ptl;
 	pte_t entry;
@@ -2787,7 +2786,7 @@ static void migrate_vma_insert_page(stru
 
 	if (unlikely(anon_vma_prepare(vma)))
 		goto abort;
-	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL, &memcg))
+	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, false))
 		goto abort;
 
 	/*
@@ -2832,7 +2831,6 @@ static void migrate_vma_insert_page(stru
 		goto unlock_abort;
 
 	inc_mm_counter(mm, MM_ANONPAGES);
-	mem_cgroup_commit_charge(page, memcg, false);
 	page_add_new_anon_rmap(page, vma, addr, false);
 	if (!is_zone_device_page(page))
 		lru_cache_add_active_or_unevictable(page, vma);
@@ -2855,7 +2853,6 @@ static void migrate_vma_insert_page(stru
 
 unlock_abort:
 	pte_unmap_unlock(ptep, ptl);
-	mem_cgroup_cancel_charge(page, memcg);
 abort:
 	*src &= ~MIGRATE_PFN_MIGRATE;
 }
--- a/mm/swapfile.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/mm/swapfile.c
@@ -1892,7 +1892,6 @@ static int unuse_pte(struct vm_area_stru
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
 	struct page *swapcache;
-	struct mem_cgroup *memcg;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int ret = 1;
@@ -1902,14 +1901,13 @@ static int unuse_pte(struct vm_area_stru
 	if (unlikely(!page))
 		return -ENOMEM;
 
-	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL, &memcg)) {
+	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, true)) {
 		ret = -ENOMEM;
 		goto out_nolock;
 	}
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte_same_as_swp(*pte, swp_entry_to_pte(entry)))) {
-		mem_cgroup_cancel_charge(page, memcg);
 		ret = 0;
 		goto out;
 	}
@@ -1920,10 +1918,8 @@ static int unuse_pte(struct vm_area_stru
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	if (page == swapcache) {
-		mem_cgroup_commit_charge(page, memcg, true);
 		page_add_anon_rmap(page, vma, addr, false);
 	} else { /* ksm created a completely new copy */
-		mem_cgroup_commit_charge(page, memcg, false);
 		page_add_new_anon_rmap(page, vma, addr, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
--- a/mm/userfaultfd.c~mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api
+++ a/mm/userfaultfd.c
@@ -56,7 +56,6 @@ static int mcopy_atomic_pte(struct mm_st
 			    struct page **pagep,
 			    bool wp_copy)
 {
-	struct mem_cgroup *memcg;
 	pte_t _dst_pte, *dst_pte;
 	spinlock_t *ptl;
 	void *page_kaddr;
@@ -97,7 +96,7 @@ static int mcopy_atomic_pte(struct mm_st
 	__SetPageUptodate(page);
 
 	ret = -ENOMEM;
-	if (mem_cgroup_try_charge(page, dst_mm, GFP_KERNEL, &memcg))
+	if (mem_cgroup_charge(page, dst_mm, GFP_KERNEL, false))
 		goto out_release;
 
 	_dst_pte = pte_mkdirty(mk_pte(page, dst_vma->vm_page_prot));
@@ -123,7 +122,6 @@ static int mcopy_atomic_pte(struct mm_st
 		goto out_release_uncharge_unlock;
 
 	inc_mm_counter(dst_mm, MM_ANONPAGES);
-	mem_cgroup_commit_charge(page, memcg, false);
 	page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
 	lru_cache_add_active_or_unevictable(page, dst_vma);
 
@@ -138,7 +136,6 @@ out:
 	return ret;
 out_release_uncharge_unlock:
 	pte_unmap_unlock(dst_pte, ptl);
-	mem_cgroup_cancel_charge(page, memcg);
 out_release:
 	put_page(page);
 	goto out;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
