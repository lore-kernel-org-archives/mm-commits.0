From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 101/131] mm: memcontrol: delete unused lrucare
 handling
Date: Wed, 03 Jun 2020 16:02:24 -0700
Message-ID: <20200603230224.RT1ISwZiZ%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgFCXIh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:37 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, bsingharora@gmail.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: delete unused lrucare handling

Swapin faults were the last event to charge pages after they had already
been put on the LRU list.  Now that we charge directly on swapin, the
lrucare portion of the charge code is unused.

Link: http://lkml.kernel.org/r/20200508183105.225460-19-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +--
 kernel/events/uprobes.c    |    3 -
 mm/filemap.c               |    2 -
 mm/huge_memory.c           |    2 -
 mm/khugepaged.c            |    4 +-
 mm/memcontrol.c            |   57 ++---------------------------------
 mm/memory.c                |    8 ++--
 mm/migrate.c               |    2 -
 mm/shmem.c                 |    2 -
 mm/swap_state.c            |    2 -
 mm/userfaultfd.c           |    2 -
 11 files changed, 19 insertions(+), 70 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-delete-unused-lrucare-handling
+++ a/include/linux/memcontrol.h
@@ -355,8 +355,7 @@ static inline unsigned long mem_cgroup_p
 enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 						struct mem_cgroup *memcg);
 
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
-		      bool lrucare);
+int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
 
 void mem_cgroup_uncharge(struct page *page);
 void mem_cgroup_uncharge_list(struct list_head *page_list);
@@ -839,7 +838,7 @@ static inline enum mem_cgroup_protection
 }
 
 static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
-				    gfp_t gfp_mask, bool lrucare)
+				    gfp_t gfp_mask)
 {
 	return 0;
 }
--- a/kernel/events/uprobes.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/kernel/events/uprobes.c
@@ -167,8 +167,7 @@ static int __replace_page(struct vm_area
 				addr + PAGE_SIZE);
 
 	if (new_page) {
-		err = mem_cgroup_charge(new_page, vma->vm_mm, GFP_KERNEL,
-					false);
+		err = mem_cgroup_charge(new_page, vma->vm_mm, GFP_KERNEL);
 		if (err)
 			return err;
 	}
--- a/mm/filemap.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/filemap.c
@@ -845,7 +845,7 @@ static int __add_to_page_cache_locked(st
 	page->index = offset;
 
 	if (!huge) {
-		error = mem_cgroup_charge(page, current->mm, gfp_mask, false);
+		error = mem_cgroup_charge(page, current->mm, gfp_mask);
 		if (error)
 			goto error;
 	}
--- a/mm/huge_memory.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/huge_memory.c
@@ -593,7 +593,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
-	if (mem_cgroup_charge(page, vma->vm_mm, gfp, false)) {
+	if (mem_cgroup_charge(page, vma->vm_mm, gfp)) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
 		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
--- a/mm/khugepaged.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/khugepaged.c
@@ -1059,7 +1059,7 @@ static void collapse_huge_page(struct mm
 		goto out_nolock;
 	}
 
-	if (unlikely(mem_cgroup_charge(new_page, mm, gfp, false))) {
+	if (unlikely(mem_cgroup_charge(new_page, mm, gfp))) {
 		result = SCAN_CGROUP_CHARGE_FAIL;
 		goto out_nolock;
 	}
@@ -1632,7 +1632,7 @@ static void collapse_file(struct mm_stru
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_charge(new_page, mm, gfp, false))) {
+	if (unlikely(mem_cgroup_charge(new_page, mm, gfp))) {
 		result = SCAN_CGROUP_CHARGE_FAIL;
 		goto out;
 	}
--- a/mm/memcontrol.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/memcontrol.c
@@ -2655,51 +2655,9 @@ static void cancel_charge(struct mem_cgr
 }
 #endif
 
-static void lock_page_lru(struct page *page, int *isolated)
+static void commit_charge(struct page *page, struct mem_cgroup *memcg)
 {
-	pg_data_t *pgdat = page_pgdat(page);
-
-	spin_lock_irq(&pgdat->lru_lock);
-	if (PageLRU(page)) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		ClearPageLRU(page);
-		del_page_from_lru_list(page, lruvec, page_lru(page));
-		*isolated = 1;
-	} else
-		*isolated = 0;
-}
-
-static void unlock_page_lru(struct page *page, int isolated)
-{
-	pg_data_t *pgdat = page_pgdat(page);
-
-	if (isolated) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		VM_BUG_ON_PAGE(PageLRU(page), page);
-		SetPageLRU(page);
-		add_page_to_lru_list(page, lruvec, page_lru(page));
-	}
-	spin_unlock_irq(&pgdat->lru_lock);
-}
-
-static void commit_charge(struct page *page, struct mem_cgroup *memcg,
-			  bool lrucare)
-{
-	int isolated;
-
 	VM_BUG_ON_PAGE(page->mem_cgroup, page);
-
-	/*
-	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
-	 * may already be on some other mem_cgroup's LRU.  Take care of it.
-	 */
-	if (lrucare)
-		lock_page_lru(page, &isolated);
-
 	/*
 	 * Nobody should be changing or seriously looking at
 	 * page->mem_cgroup at this point:
@@ -2715,9 +2673,6 @@ static void commit_charge(struct page *p
 	 *   have the page locked
 	 */
 	page->mem_cgroup = memcg;
-
-	if (lrucare)
-		unlock_page_lru(page, isolated);
 }
 
 #ifdef CONFIG_MEMCG_KMEM
@@ -6503,22 +6458,18 @@ out:
  * @page: page to charge
  * @mm: mm context of the victim
  * @gfp_mask: reclaim mode
- * @lrucare: page might be on the LRU already
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
  * pages according to @gfp_mask if necessary.
  *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask,
-		      bool lrucare)
+int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
 	unsigned int nr_pages = hpage_nr_pages(page);
 	struct mem_cgroup *memcg = NULL;
 	int ret = 0;
 
-	VM_BUG_ON_PAGE(PageLRU(page) && !lrucare, page);
-
 	if (mem_cgroup_disabled())
 		goto out;
 
@@ -6552,7 +6503,7 @@ int mem_cgroup_charge(struct page *page,
 	if (ret)
 		goto out_put;
 
-	commit_charge(page, memcg, lrucare);
+	commit_charge(page, memcg);
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(memcg, page, nr_pages);
@@ -6753,7 +6704,7 @@ void mem_cgroup_migrate(struct page *old
 		page_counter_charge(&memcg->memsw, nr_pages);
 	css_get_many(&memcg->css, nr_pages);
 
-	commit_charge(newpage, memcg, false);
+	commit_charge(newpage, memcg);
 
 	local_irq_save(flags);
 	mem_cgroup_charge_statistics(memcg, newpage, nr_pages);
--- a/mm/memory.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/memory.c
@@ -2675,7 +2675,7 @@ static vm_fault_t wp_page_copy(struct vm
 		}
 	}
 
-	if (mem_cgroup_charge(new_page, mm, GFP_KERNEL, false))
+	if (mem_cgroup_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 	cgroup_throttle_swaprate(new_page, GFP_KERNEL);
 
@@ -3134,7 +3134,7 @@ vm_fault_t do_swap_page(struct vm_fault
 				/* Tell memcg to use swap ownership records */
 				SetPageSwapCache(page);
 				err = mem_cgroup_charge(page, vma->vm_mm,
-							GFP_KERNEL, false);
+							GFP_KERNEL);
 				ClearPageSwapCache(page);
 				if (err)
 					goto out_page;
@@ -3358,7 +3358,7 @@ static vm_fault_t do_anonymous_page(stru
 	if (!page)
 		goto oom;
 
-	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, false))
+	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL))
 		goto oom_free_page;
 	cgroup_throttle_swaprate(page, GFP_KERNEL);
 
@@ -3854,7 +3854,7 @@ static vm_fault_t do_cow_fault(struct vm
 	if (!vmf->cow_page)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_charge(vmf->cow_page, vma->vm_mm, GFP_KERNEL, false)) {
+	if (mem_cgroup_charge(vmf->cow_page, vma->vm_mm, GFP_KERNEL)) {
 		put_page(vmf->cow_page);
 		return VM_FAULT_OOM;
 	}
--- a/mm/migrate.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/migrate.c
@@ -2786,7 +2786,7 @@ static void migrate_vma_insert_page(stru
 
 	if (unlikely(anon_vma_prepare(vma)))
 		goto abort;
-	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, false))
+	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL))
 		goto abort;
 
 	/*
--- a/mm/shmem.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/shmem.c
@@ -624,7 +624,7 @@ static int shmem_add_to_page_cache(struc
 	page->index = index;
 
 	if (!PageSwapCache(page)) {
-		error = mem_cgroup_charge(page, charge_mm, gfp, false);
+		error = mem_cgroup_charge(page, charge_mm, gfp);
 		if (error) {
 			if (PageTransHuge(page)) {
 				count_vm_event(THP_FILE_FALLBACK);
--- a/mm/swap_state.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/swap_state.c
@@ -435,7 +435,7 @@ struct page *__read_swap_cache_async(swp
 		goto fail_unlock;
 	}
 
-	if (mem_cgroup_charge(page, NULL, gfp_mask, false)) {
+	if (mem_cgroup_charge(page, NULL, gfp_mask)) {
 		delete_from_swap_cache(page);
 		goto fail_unlock;
 	}
--- a/mm/userfaultfd.c~mm-memcontrol-delete-unused-lrucare-handling
+++ a/mm/userfaultfd.c
@@ -96,7 +96,7 @@ static int mcopy_atomic_pte(struct mm_st
 	__SetPageUptodate(page);
 
 	ret = -ENOMEM;
-	if (mem_cgroup_charge(page, dst_mm, GFP_KERNEL, false))
+	if (mem_cgroup_charge(page, dst_mm, GFP_KERNEL))
 		goto out_release;
 
 	_dst_pte = pte_mkdirty(mk_pte(page, dst_vma->vm_page_prot));
_
