From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch removed
 from -mm tree
Date: Thu, 04 Jun 2020 10:19:54 -0700
Message-ID: <20200604171954.uHdEZL3wf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFDRT5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: drop @compound parameter from memcg charging API
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: drop @compound parameter from memcg charging API

The memcg charging API carries a boolean @compound parameter that tells
whether the page we're dealing with is a hugepage. 
mem_cgroup_commit_charge() has another boolean @lrucare that indicates
whether the page needs LRU locking or not while charging.  The majority of
callsites know those parameters at compile time, which results in a lot of
naked "false, false" argument lists.  This makes for cryptic code and is a
breeding ground for subtle mistakes.

Thankfully, the huge page state can be inferred from the page itself and
doesn't need to be passed along.  This is safe because charging completes
before the page is published and somebody may split it.

Simplify the callsites by removing @compound, and let memcg infer the
state by using hpage_nr_pages() unconditionally.  That function does
PageTransHuge() to identify huge pages, which also helpfully asserts that
nobody passes in tail pages by accident.

The following patches will introduce a new charging API, best not to carry
over unnecessary weight.

Link: http://lkml.kernel.org/r/20200508183105.225460-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   22 +++++++-------------
 kernel/events/uprobes.c    |    6 ++---
 mm/filemap.c               |    6 ++---
 mm/huge_memory.c           |    8 +++----
 mm/khugepaged.c            |   20 +++++++++---------
 mm/memcontrol.c            |   38 +++++++++++++----------------------
 mm/memory.c                |   32 +++++++++++++----------------
 mm/migrate.c               |    6 ++---
 mm/shmem.c                 |   22 ++++++++------------
 mm/swapfile.c              |    9 +++-----
 mm/userfaultfd.c           |    6 ++---
 11 files changed, 77 insertions(+), 98 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/include/linux/memcontrol.h
@@ -359,15 +359,12 @@ enum mem_cgroup_protection mem_cgroup_pr
 						struct mem_cgroup *memcg);
 
 int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp,
-			  bool compound);
+			  gfp_t gfp_mask, struct mem_cgroup **memcgp);
 int mem_cgroup_try_charge_delay(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp,
-			  bool compound);
+			  gfp_t gfp_mask, struct mem_cgroup **memcgp);
 void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
-			      bool lrucare, bool compound);
-void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg,
-		bool compound);
+			      bool lrucare);
+void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg);
 void mem_cgroup_uncharge(struct page *page);
 void mem_cgroup_uncharge_list(struct list_head *page_list);
 
@@ -849,8 +846,7 @@ static inline enum mem_cgroup_protection
 
 static inline int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask,
-					struct mem_cgroup **memcgp,
-					bool compound)
+					struct mem_cgroup **memcgp)
 {
 	*memcgp = NULL;
 	return 0;
@@ -859,8 +855,7 @@ static inline int mem_cgroup_try_charge(
 static inline int mem_cgroup_try_charge_delay(struct page *page,
 					      struct mm_struct *mm,
 					      gfp_t gfp_mask,
-					      struct mem_cgroup **memcgp,
-					      bool compound)
+					      struct mem_cgroup **memcgp)
 {
 	*memcgp = NULL;
 	return 0;
@@ -868,13 +863,12 @@ static inline int mem_cgroup_try_charge_
 
 static inline void mem_cgroup_commit_charge(struct page *page,
 					    struct mem_cgroup *memcg,
-					    bool lrucare, bool compound)
+					    bool lrucare)
 {
 }
 
 static inline void mem_cgroup_cancel_charge(struct page *page,
-					    struct mem_cgroup *memcg,
-					    bool compound)
+					    struct mem_cgroup *memcg)
 {
 }
 
--- a/kernel/events/uprobes.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/kernel/events/uprobes.c
@@ -169,7 +169,7 @@ static int __replace_page(struct vm_area
 
 	if (new_page) {
 		err = mem_cgroup_try_charge(new_page, vma->vm_mm, GFP_KERNEL,
-					    &memcg, false);
+					    &memcg);
 		if (err)
 			return err;
 	}
@@ -181,7 +181,7 @@ static int __replace_page(struct vm_area
 	err = -EAGAIN;
 	if (!page_vma_mapped_walk(&pvmw)) {
 		if (new_page)
-			mem_cgroup_cancel_charge(new_page, memcg, false);
+			mem_cgroup_cancel_charge(new_page, memcg);
 		goto unlock;
 	}
 	VM_BUG_ON_PAGE(addr != pvmw.address, old_page);
@@ -189,7 +189,7 @@ static int __replace_page(struct vm_area
 	if (new_page) {
 		get_page(new_page);
 		page_add_new_anon_rmap(new_page, vma, addr, false);
-		mem_cgroup_commit_charge(new_page, memcg, false, false);
+		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 	} else
 		/* no new page, just dec_mm_counter for old_page */
--- a/mm/filemap.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/filemap.c
@@ -842,7 +842,7 @@ static int __add_to_page_cache_locked(st
 
 	if (!huge) {
 		error = mem_cgroup_try_charge(page, current->mm,
-					      gfp_mask, &memcg, false);
+					      gfp_mask, &memcg);
 		if (error)
 			return error;
 	}
@@ -878,14 +878,14 @@ unlock:
 		goto error;
 
 	if (!huge)
-		mem_cgroup_commit_charge(page, memcg, false, false);
+		mem_cgroup_commit_charge(page, memcg, false);
 	trace_mm_filemap_add_to_page_cache(page);
 	return 0;
 error:
 	page->mapping = NULL;
 	/* Leave page->index set: truncation relies upon it */
 	if (!huge)
-		mem_cgroup_cancel_charge(page, memcg, false);
+		mem_cgroup_cancel_charge(page, memcg);
 	put_page(page);
 	return xas_error(&xas);
 }
--- a/mm/huge_memory.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/huge_memory.c
@@ -594,7 +594,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
-	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, gfp, &memcg, true)) {
+	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, gfp, &memcg)) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
 		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
@@ -630,7 +630,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 			vm_fault_t ret2;
 
 			spin_unlock(vmf->ptl);
-			mem_cgroup_cancel_charge(page, memcg, true);
+			mem_cgroup_cancel_charge(page, memcg);
 			put_page(page);
 			pte_free(vma->vm_mm, pgtable);
 			ret2 = handle_userfault(vmf, VM_UFFD_MISSING);
@@ -641,7 +641,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		page_add_new_anon_rmap(page, vma, haddr, true);
-		mem_cgroup_commit_charge(page, memcg, false, true);
+		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
@@ -658,7 +658,7 @@ unlock_release:
 release:
 	if (pgtable)
 		pte_free(vma->vm_mm, pgtable);
-	mem_cgroup_cancel_charge(page, memcg, true);
+	mem_cgroup_cancel_charge(page, memcg);
 	put_page(page);
 	return ret;
 
--- a/mm/khugepaged.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/khugepaged.c
@@ -1060,7 +1060,7 @@ static void collapse_huge_page(struct mm
 		goto out_nolock;
 	}
 
-	if (unlikely(mem_cgroup_try_charge(new_page, mm, gfp, &memcg, true))) {
+	if (unlikely(mem_cgroup_try_charge(new_page, mm, gfp, &memcg))) {
 		result = SCAN_CGROUP_CHARGE_FAIL;
 		goto out_nolock;
 	}
@@ -1068,7 +1068,7 @@ static void collapse_huge_page(struct mm
 	down_read(&mm->mmap_sem);
 	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result) {
-		mem_cgroup_cancel_charge(new_page, memcg, true);
+		mem_cgroup_cancel_charge(new_page, memcg);
 		up_read(&mm->mmap_sem);
 		goto out_nolock;
 	}
@@ -1076,7 +1076,7 @@ static void collapse_huge_page(struct mm
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd) {
 		result = SCAN_PMD_NULL;
-		mem_cgroup_cancel_charge(new_page, memcg, true);
+		mem_cgroup_cancel_charge(new_page, memcg);
 		up_read(&mm->mmap_sem);
 		goto out_nolock;
 	}
@@ -1088,7 +1088,7 @@ static void collapse_huge_page(struct mm
 	 */
 	if (unmapped && !__collapse_huge_page_swapin(mm, vma, address,
 						     pmd, referenced)) {
-		mem_cgroup_cancel_charge(new_page, memcg, true);
+		mem_cgroup_cancel_charge(new_page, memcg);
 		up_read(&mm->mmap_sem);
 		goto out_nolock;
 	}
@@ -1176,7 +1176,7 @@ static void collapse_huge_page(struct mm
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address, true);
-	mem_cgroup_commit_charge(new_page, memcg, false, true);
+	mem_cgroup_commit_charge(new_page, memcg, false);
 	count_memcg_events(memcg, THP_COLLAPSE_ALLOC, 1);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
@@ -1194,7 +1194,7 @@ out_nolock:
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
 out:
-	mem_cgroup_cancel_charge(new_page, memcg, true);
+	mem_cgroup_cancel_charge(new_page, memcg);
 	goto out_up_write;
 }
 
@@ -1637,7 +1637,7 @@ static void collapse_file(struct mm_stru
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_try_charge(new_page, mm, gfp, &memcg, true))) {
+	if (unlikely(mem_cgroup_try_charge(new_page, mm, gfp, &memcg))) {
 		result = SCAN_CGROUP_CHARGE_FAIL;
 		goto out;
 	}
@@ -1650,7 +1650,7 @@ static void collapse_file(struct mm_stru
 			break;
 		xas_unlock_irq(&xas);
 		if (!xas_nomem(&xas, GFP_KERNEL)) {
-			mem_cgroup_cancel_charge(new_page, memcg, true);
+			mem_cgroup_cancel_charge(new_page, memcg);
 			result = SCAN_FAIL;
 			goto out;
 		}
@@ -1887,7 +1887,7 @@ xa_unlocked:
 
 		SetPageUptodate(new_page);
 		page_ref_add(new_page, HPAGE_PMD_NR - 1);
-		mem_cgroup_commit_charge(new_page, memcg, false, true);
+		mem_cgroup_commit_charge(new_page, memcg, false);
 
 		if (is_shmem) {
 			set_page_dirty(new_page);
@@ -1942,7 +1942,7 @@ xa_unlocked:
 		VM_BUG_ON(nr_none);
 		xas_unlock_irq(&xas);
 
-		mem_cgroup_cancel_charge(new_page, memcg, true);
+		mem_cgroup_cancel_charge(new_page, memcg);
 		new_page->mapping = NULL;
 	}
 
--- a/mm/memcontrol.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/memcontrol.c
@@ -834,7 +834,7 @@ static unsigned long memcg_events_local(
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 struct page *page,
-					 bool compound, int nr_pages)
+					 int nr_pages)
 {
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
@@ -848,7 +848,7 @@ static void mem_cgroup_charge_statistics
 			__mod_memcg_state(memcg, NR_SHMEM, nr_pages);
 	}
 
-	if (compound) {
+	if (abs(nr_pages) > 1) {
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		__mod_memcg_state(memcg, MEMCG_RSS_HUGE, nr_pages);
 	}
@@ -5501,9 +5501,9 @@ static int mem_cgroup_move_account(struc
 	ret = 0;
 
 	local_irq_disable();
-	mem_cgroup_charge_statistics(to, page, compound, nr_pages);
+	mem_cgroup_charge_statistics(to, page, nr_pages);
 	memcg_check_events(to, page);
-	mem_cgroup_charge_statistics(from, page, compound, -nr_pages);
+	mem_cgroup_charge_statistics(from, page, -nr_pages);
 	memcg_check_events(from, page);
 	local_irq_enable();
 out_unlock:
@@ -6494,7 +6494,6 @@ out:
  * @mm: mm context of the victim
  * @gfp_mask: reclaim mode
  * @memcgp: charged memcg return
- * @compound: charge the page as compound or small page
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
  * pages according to @gfp_mask if necessary.
@@ -6507,11 +6506,10 @@ out:
  * with mem_cgroup_cancel_charge() in case page instantiation fails.
  */
 int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp,
-			  bool compound)
+			  gfp_t gfp_mask, struct mem_cgroup **memcgp)
 {
+	unsigned int nr_pages = hpage_nr_pages(page);
 	struct mem_cgroup *memcg = NULL;
-	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
 	int ret = 0;
 
 	if (mem_cgroup_disabled())
@@ -6553,13 +6551,12 @@ out:
 }
 
 int mem_cgroup_try_charge_delay(struct page *page, struct mm_struct *mm,
-			  gfp_t gfp_mask, struct mem_cgroup **memcgp,
-			  bool compound)
+			  gfp_t gfp_mask, struct mem_cgroup **memcgp)
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
-	ret = mem_cgroup_try_charge(page, mm, gfp_mask, memcgp, compound);
+	ret = mem_cgroup_try_charge(page, mm, gfp_mask, memcgp);
 	memcg = *memcgp;
 	mem_cgroup_throttle_swaprate(memcg, page_to_nid(page), gfp_mask);
 	return ret;
@@ -6570,7 +6567,6 @@ int mem_cgroup_try_charge_delay(struct p
  * @page: page to charge
  * @memcg: memcg to charge the page to
  * @lrucare: page might be on LRU already
- * @compound: charge the page as compound or small page
  *
  * Finalize a charge transaction started by mem_cgroup_try_charge(),
  * after page->mapping has been set up.  This must happen atomically
@@ -6583,9 +6579,9 @@ int mem_cgroup_try_charge_delay(struct p
  * Use mem_cgroup_cancel_charge() to cancel the transaction instead.
  */
 void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
-			      bool lrucare, bool compound)
+			      bool lrucare)
 {
-	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
+	unsigned int nr_pages = hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!page->mapping, page);
 	VM_BUG_ON_PAGE(PageLRU(page) && !lrucare, page);
@@ -6603,7 +6599,7 @@ void mem_cgroup_commit_charge(struct pag
 	commit_charge(page, memcg, lrucare);
 
 	local_irq_disable();
-	mem_cgroup_charge_statistics(memcg, page, compound, nr_pages);
+	mem_cgroup_charge_statistics(memcg, page, nr_pages);
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
@@ -6622,14 +6618,12 @@ void mem_cgroup_commit_charge(struct pag
  * mem_cgroup_cancel_charge - cancel a page charge
  * @page: page to charge
  * @memcg: memcg to charge the page to
- * @compound: charge the page as compound or small page
  *
  * Cancel a charge transaction started by mem_cgroup_try_charge().
  */
-void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg,
-		bool compound)
+void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg)
 {
-	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
+	unsigned int nr_pages = hpage_nr_pages(page);
 
 	if (mem_cgroup_disabled())
 		return;
@@ -6844,8 +6838,7 @@ void mem_cgroup_migrate(struct page *old
 	commit_charge(newpage, memcg, false);
 
 	local_irq_save(flags);
-	mem_cgroup_charge_statistics(memcg, newpage, PageTransHuge(newpage),
-			nr_pages);
+	mem_cgroup_charge_statistics(memcg, newpage, nr_pages);
 	memcg_check_events(memcg, newpage);
 	local_irq_restore(flags);
 }
@@ -7075,8 +7068,7 @@ void mem_cgroup_swapout(struct page *pag
 	 * only synchronisation we have for updating the per-CPU variables.
 	 */
 	VM_BUG_ON(!irqs_disabled());
-	mem_cgroup_charge_statistics(memcg, page, PageTransHuge(page),
-				     -nr_entries);
+	mem_cgroup_charge_statistics(memcg, page, -nr_entries);
 	memcg_check_events(memcg, page);
 
 	if (!mem_cgroup_is_root(memcg))
--- a/mm/memory.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/memory.c
@@ -2676,7 +2676,7 @@ static vm_fault_t wp_page_copy(struct vm
 		}
 	}
 
-	if (mem_cgroup_try_charge_delay(new_page, mm, GFP_KERNEL, &memcg, false))
+	if (mem_cgroup_try_charge_delay(new_page, mm, GFP_KERNEL, &memcg))
 		goto oom_free_new;
 
 	__SetPageUptodate(new_page);
@@ -2711,7 +2711,7 @@ static vm_fault_t wp_page_copy(struct vm
 		 */
 		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
 		page_add_new_anon_rmap(new_page, vma, vmf->address, false);
-		mem_cgroup_commit_charge(new_page, memcg, false, false);
+		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
 		/*
 		 * We call the notify macro here because, when using secondary
@@ -2750,7 +2750,7 @@ static vm_fault_t wp_page_copy(struct vm
 		new_page = old_page;
 		page_copied = 1;
 	} else {
-		mem_cgroup_cancel_charge(new_page, memcg, false);
+		mem_cgroup_cancel_charge(new_page, memcg);
 	}
 
 	if (new_page)
@@ -3193,8 +3193,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_page;
 	}
 
-	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, GFP_KERNEL,
-					&memcg, false)) {
+	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, GFP_KERNEL, &memcg)) {
 		ret = VM_FAULT_OOM;
 		goto out_page;
 	}
@@ -3245,11 +3244,11 @@ vm_fault_t do_swap_page(struct vm_fault
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
-		mem_cgroup_commit_charge(page, memcg, false, false);
+		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	} else {
 		do_page_add_anon_rmap(page, vma, vmf->address, exclusive);
-		mem_cgroup_commit_charge(page, memcg, true, false);
+		mem_cgroup_commit_charge(page, memcg, true);
 		activate_page(page);
 	}
 
@@ -3285,7 +3284,7 @@ unlock:
 out:
 	return ret;
 out_nomap:
-	mem_cgroup_cancel_charge(page, memcg, false);
+	mem_cgroup_cancel_charge(page, memcg);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 out_page:
 	unlock_page(page);
@@ -3359,8 +3358,7 @@ static vm_fault_t do_anonymous_page(stru
 	if (!page)
 		goto oom;
 
-	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, GFP_KERNEL, &memcg,
-					false))
+	if (mem_cgroup_try_charge_delay(page, vma->vm_mm, GFP_KERNEL, &memcg))
 		goto oom_free_page;
 
 	/*
@@ -3386,14 +3384,14 @@ static vm_fault_t do_anonymous_page(stru
 	/* Deliver the page fault to userland, check inside PT lock */
 	if (userfaultfd_missing(vma)) {
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		mem_cgroup_cancel_charge(page, memcg, false);
+		mem_cgroup_cancel_charge(page, memcg);
 		put_page(page);
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, vmf->address, false);
-	mem_cgroup_commit_charge(page, memcg, false, false);
+	mem_cgroup_commit_charge(page, memcg, false);
 	lru_cache_add_active_or_unevictable(page, vma);
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
@@ -3404,7 +3402,7 @@ unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
 release:
-	mem_cgroup_cancel_charge(page, memcg, false);
+	mem_cgroup_cancel_charge(page, memcg);
 	put_page(page);
 	goto unlock;
 oom_free_page:
@@ -3655,7 +3653,7 @@ vm_fault_t alloc_set_pte(struct vm_fault
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
-		mem_cgroup_commit_charge(page, memcg, false, false);
+		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
@@ -3864,8 +3862,8 @@ static vm_fault_t do_cow_fault(struct vm
 	if (!vmf->cow_page)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_try_charge_delay(vmf->cow_page, vma->vm_mm, GFP_KERNEL,
-				&vmf->memcg, false)) {
+	if (mem_cgroup_try_charge_delay(vmf->cow_page, vma->vm_mm,
+					GFP_KERNEL, &vmf->memcg)) {
 		put_page(vmf->cow_page);
 		return VM_FAULT_OOM;
 	}
@@ -3886,7 +3884,7 @@ static vm_fault_t do_cow_fault(struct vm
 		goto uncharge_out;
 	return ret;
 uncharge_out:
-	mem_cgroup_cancel_charge(vmf->cow_page, vmf->memcg, false);
+	mem_cgroup_cancel_charge(vmf->cow_page, vmf->memcg);
 	put_page(vmf->cow_page);
 	return ret;
 }
--- a/mm/migrate.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/migrate.c
@@ -2780,7 +2780,7 @@ static void migrate_vma_insert_page(stru
 
 	if (unlikely(anon_vma_prepare(vma)))
 		goto abort;
-	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL, &memcg, false))
+	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL, &memcg))
 		goto abort;
 
 	/*
@@ -2826,7 +2826,7 @@ static void migrate_vma_insert_page(stru
 
 	inc_mm_counter(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, addr, false);
-	mem_cgroup_commit_charge(page, memcg, false, false);
+	mem_cgroup_commit_charge(page, memcg, false);
 	if (!is_zone_device_page(page))
 		lru_cache_add_active_or_unevictable(page, vma);
 	get_page(page);
@@ -2848,7 +2848,7 @@ static void migrate_vma_insert_page(stru
 
 unlock_abort:
 	pte_unmap_unlock(ptep, ptl);
-	mem_cgroup_cancel_charge(page, memcg, false);
+	mem_cgroup_cancel_charge(page, memcg);
 abort:
 	*src &= ~MIGRATE_PFN_MIGRATE;
 }
--- a/mm/shmem.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/shmem.c
@@ -1664,8 +1664,7 @@ static int shmem_swapin_page(struct inod
 			goto failed;
 	}
 
-	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg,
-					    false);
+	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg);
 	if (!error) {
 		error = shmem_add_to_page_cache(page, mapping, index,
 						swp_to_radix_entry(swap), gfp);
@@ -1680,14 +1679,14 @@ static int shmem_swapin_page(struct inod
 		 * the rest.
 		 */
 		if (error) {
-			mem_cgroup_cancel_charge(page, memcg, false);
+			mem_cgroup_cancel_charge(page, memcg);
 			delete_from_swap_cache(page);
 		}
 	}
 	if (error)
 		goto failed;
 
-	mem_cgroup_commit_charge(page, memcg, true, false);
+	mem_cgroup_commit_charge(page, memcg, true);
 
 	spin_lock_irq(&info->lock);
 	info->swapped--;
@@ -1859,8 +1858,7 @@ alloc_nohuge:
 	if (sgp == SGP_WRITE)
 		__SetPageReferenced(page);
 
-	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg,
-					    PageTransHuge(page));
+	error = mem_cgroup_try_charge_delay(page, charge_mm, gfp, &memcg);
 	if (error) {
 		if (PageTransHuge(page)) {
 			count_vm_event(THP_FILE_FALLBACK);
@@ -1871,12 +1869,10 @@ alloc_nohuge:
 	error = shmem_add_to_page_cache(page, mapping, hindex,
 					NULL, gfp & GFP_RECLAIM_MASK);
 	if (error) {
-		mem_cgroup_cancel_charge(page, memcg,
-					 PageTransHuge(page));
+		mem_cgroup_cancel_charge(page, memcg);
 		goto unacct;
 	}
-	mem_cgroup_commit_charge(page, memcg, false,
-				 PageTransHuge(page));
+	mem_cgroup_commit_charge(page, memcg, false);
 	lru_cache_add_anon(page);
 
 	spin_lock_irq(&info->lock);
@@ -2364,7 +2360,7 @@ static int shmem_mfill_atomic_pte(struct
 	if (unlikely(offset >= max_off))
 		goto out_release;
 
-	ret = mem_cgroup_try_charge_delay(page, dst_mm, gfp, &memcg, false);
+	ret = mem_cgroup_try_charge_delay(page, dst_mm, gfp, &memcg);
 	if (ret)
 		goto out_release;
 
@@ -2373,7 +2369,7 @@ static int shmem_mfill_atomic_pte(struct
 	if (ret)
 		goto out_release_uncharge;
 
-	mem_cgroup_commit_charge(page, memcg, false, false);
+	mem_cgroup_commit_charge(page, memcg, false);
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
 	if (dst_vma->vm_flags & VM_WRITE)
@@ -2424,7 +2420,7 @@ out_release_uncharge_unlock:
 	ClearPageDirty(page);
 	delete_from_page_cache(page);
 out_release_uncharge:
-	mem_cgroup_cancel_charge(page, memcg, false);
+	mem_cgroup_cancel_charge(page, memcg);
 out_release:
 	unlock_page(page);
 	put_page(page);
--- a/mm/swapfile.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/swapfile.c
@@ -1902,15 +1902,14 @@ static int unuse_pte(struct vm_area_stru
 	if (unlikely(!page))
 		return -ENOMEM;
 
-	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL,
-				&memcg, false)) {
+	if (mem_cgroup_try_charge(page, vma->vm_mm, GFP_KERNEL, &memcg)) {
 		ret = -ENOMEM;
 		goto out_nolock;
 	}
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte_same_as_swp(*pte, swp_entry_to_pte(entry)))) {
-		mem_cgroup_cancel_charge(page, memcg, false);
+		mem_cgroup_cancel_charge(page, memcg);
 		ret = 0;
 		goto out;
 	}
@@ -1922,10 +1921,10 @@ static int unuse_pte(struct vm_area_stru
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	if (page == swapcache) {
 		page_add_anon_rmap(page, vma, addr, false);
-		mem_cgroup_commit_charge(page, memcg, true, false);
+		mem_cgroup_commit_charge(page, memcg, true);
 	} else { /* ksm created a completely new copy */
 		page_add_new_anon_rmap(page, vma, addr, false);
-		mem_cgroup_commit_charge(page, memcg, false, false);
+		mem_cgroup_commit_charge(page, memcg, false);
 		lru_cache_add_active_or_unevictable(page, vma);
 	}
 	swap_free(entry);
--- a/mm/userfaultfd.c~mm-memcontrol-drop-compound-parameter-from-memcg-charging-api
+++ a/mm/userfaultfd.c
@@ -97,7 +97,7 @@ static int mcopy_atomic_pte(struct mm_st
 	__SetPageUptodate(page);
 
 	ret = -ENOMEM;
-	if (mem_cgroup_try_charge(page, dst_mm, GFP_KERNEL, &memcg, false))
+	if (mem_cgroup_try_charge(page, dst_mm, GFP_KERNEL, &memcg))
 		goto out_release;
 
 	_dst_pte = pte_mkdirty(mk_pte(page, dst_vma->vm_page_prot));
@@ -124,7 +124,7 @@ static int mcopy_atomic_pte(struct mm_st
 
 	inc_mm_counter(dst_mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
-	mem_cgroup_commit_charge(page, memcg, false, false);
+	mem_cgroup_commit_charge(page, memcg, false);
 	lru_cache_add_active_or_unevictable(page, dst_vma);
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
@@ -138,7 +138,7 @@ out:
 	return ret;
 out_release_uncharge_unlock:
 	pte_unmap_unlock(dst_pte, ptl);
-	mem_cgroup_cancel_charge(page, memcg, false);
+	mem_cgroup_cancel_charge(page, memcg);
 out_release:
 	put_page(page);
 	goto out;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
