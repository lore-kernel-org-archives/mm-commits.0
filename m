From: akpm@linux-foundation.org
Subject: + mm-memcontrol-use-page-lists-for-uncharge-batching.patch added
 to -mm tree
Date: Mon, 07 Jul 2014 13:08:24 -0700
Message-ID: <53bafe38.mH424zYuv+BrwqYC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36057 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaGGUIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 16:08:25 -0400
Received: by mail-qc0-f202.google.com with SMTP id x13so685381qcv.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 13:08:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use page lists for uncharge batching
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-page-lists-for-uncharge-batching.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-page-lists-for-uncharge-batching.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-page-lists-for-uncharge-batching.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use page lists for uncharge batching

Pages are now uncharged at release time, and all sources of batched
uncharges operate on lists of pages.  Directly use those lists, and
get rid of the per-task batching state.

This also batches statistics accounting, in addition to the res
counter charges, to reduce IRQ-disabling and re-enabling.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 --
 include/linux/sched.h      |    6 -
 kernel/fork.c              |    4 
 mm/memcontrol.c            |  209 +++++++++++++++++------------------
 mm/swap.c                  |    6 -
 mm/vmscan.c                |   12 --
 6 files changed, 115 insertions(+), 134 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-use-page-lists-for-uncharge-batching include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-use-page-lists-for-uncharge-batching
+++ a/include/linux/memcontrol.h
@@ -59,12 +59,8 @@ int mem_cgroup_try_charge(struct page *p
 void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
 			      bool lrucare);
 void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg);
-
 void mem_cgroup_uncharge(struct page *page);
-
-/* Batched uncharging */
-void mem_cgroup_uncharge_start(void);
-void mem_cgroup_uncharge_end(void);
+void mem_cgroup_uncharge_list(struct list_head *page_list);
 
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 			bool lrucare);
@@ -233,11 +229,7 @@ static inline void mem_cgroup_uncharge(s
 {
 }
 
-static inline void mem_cgroup_uncharge_start(void)
-{
-}
-
-static inline void mem_cgroup_uncharge_end(void)
+static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
 {
 }
 
diff -puN include/linux/sched.h~mm-memcontrol-use-page-lists-for-uncharge-batching include/linux/sched.h
--- a/include/linux/sched.h~mm-memcontrol-use-page-lists-for-uncharge-batching
+++ a/include/linux/sched.h
@@ -1634,12 +1634,6 @@ struct task_struct {
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
 #ifdef CONFIG_MEMCG /* memcg uses this to do batch job */
-	struct memcg_batch_info {
-		int do_batch;	/* incremented when batch uncharge started */
-		struct mem_cgroup *memcg; /* target memcg of uncharge */
-		unsigned long nr_pages;	/* uncharged usage */
-		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
-	} memcg_batch;
 	unsigned int memcg_kmem_skip_account;
 	struct memcg_oom_info {
 		struct mem_cgroup *memcg;
diff -puN kernel/fork.c~mm-memcontrol-use-page-lists-for-uncharge-batching kernel/fork.c
--- a/kernel/fork.c~mm-memcontrol-use-page-lists-for-uncharge-batching
+++ a/kernel/fork.c
@@ -1307,10 +1307,6 @@ static struct task_struct *copy_process(
 #ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
-#ifdef CONFIG_MEMCG
-	p->memcg_batch.do_batch = 0;
-	p->memcg_batch.memcg = NULL;
-#endif
 #ifdef CONFIG_BCACHE
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
diff -puN mm/memcontrol.c~mm-memcontrol-use-page-lists-for-uncharge-batching mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-use-page-lists-for-uncharge-batching
+++ a/mm/memcontrol.c
@@ -3608,53 +3608,6 @@ out:
 	return ret;
 }
 
-/*
- * Batch_start/batch_end is called in unmap_page_range/invlidate/trucate.
- * In that cases, pages are freed continuously and we can expect pages
- * are in the same memcg. All these calls itself limits the number of
- * pages freed at once, then uncharge_start/end() is called properly.
- * This may be called prural(2) times in a context,
- */
-
-void mem_cgroup_uncharge_start(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	current->memcg_batch.do_batch++;
-	/* We can do nest. */
-	if (current->memcg_batch.do_batch == 1) {
-		current->memcg_batch.memcg = NULL;
-		current->memcg_batch.nr_pages = 0;
-		current->memcg_batch.memsw_nr_pages = 0;
-	}
-	local_irq_restore(flags);
-}
-
-void mem_cgroup_uncharge_end(void)
-{
-	struct memcg_batch_info *batch = &current->memcg_batch;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	VM_BUG_ON(!batch->do_batch);
-	if (--batch->do_batch) /* If stacked, do nothing */
-		goto out;
-	/*
-	 * This "batch->memcg" is valid without any css_get/put etc...
-	 * bacause we hide charges behind us.
-	 */
-	if (batch->nr_pages)
-		res_counter_uncharge(&batch->memcg->res,
-				     batch->nr_pages * PAGE_SIZE);
-	if (batch->memsw_nr_pages)
-		res_counter_uncharge(&batch->memcg->memsw,
-				     batch->memsw_nr_pages * PAGE_SIZE);
-	memcg_oom_recover(batch->memcg);
-out:
-	local_irq_restore(flags);
-}
-
 #ifdef CONFIG_MEMCG_SWAP
 static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
 					 bool charge)
@@ -6552,6 +6505,98 @@ void mem_cgroup_cancel_charge(struct pag
 	cancel_charge(memcg, nr_pages);
 }
 
+static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
+			   unsigned long nr_mem, unsigned long nr_memsw,
+			   unsigned long nr_anon, unsigned long nr_file,
+			   unsigned long nr_huge, struct page *dummy_page)
+{
+	unsigned long flags;
+
+	if (nr_mem)
+		res_counter_uncharge(&memcg->res, nr_mem * PAGE_SIZE);
+	if (nr_memsw)
+		res_counter_uncharge(&memcg->memsw, nr_memsw * PAGE_SIZE);
+
+	memcg_oom_recover(memcg);
+
+	local_irq_save(flags);
+	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS], nr_anon);
+	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_CACHE], nr_file);
+	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE], nr_huge);
+	__this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGOUT], pgpgout);
+	__this_cpu_add(memcg->stat->nr_page_events, nr_anon + nr_file);
+	memcg_check_events(memcg, dummy_page);
+	local_irq_restore(flags);
+}
+
+static void uncharge_list(struct list_head *page_list)
+{
+	struct mem_cgroup *memcg = NULL;
+	unsigned long nr_memsw = 0;
+	unsigned long nr_anon = 0;
+	unsigned long nr_file = 0;
+	unsigned long nr_huge = 0;
+	unsigned long pgpgout = 0;
+	unsigned long nr_mem = 0;
+	struct list_head *next;
+	struct page *page;
+
+	next = page_list->next;
+	do {
+		unsigned int nr_pages = 1;
+		struct page_cgroup *pc;
+
+		page = list_entry(next, struct page, lru);
+		next = page->lru.next;
+
+		VM_BUG_ON_PAGE(PageLRU(page), page);
+		VM_BUG_ON_PAGE(page_count(page), page);
+
+		pc = lookup_page_cgroup(page);
+		if (!PageCgroupUsed(pc))
+			continue;
+
+		/*
+		 * Nobody should be changing or seriously looking at
+		 * pc->mem_cgroup and pc->flags at this point, we have
+		 * fully exclusive access to the page.
+		 */
+
+		if (memcg != pc->mem_cgroup) {
+			if (memcg) {
+				uncharge_batch(memcg, pgpgout, nr_mem, nr_memsw,
+					       nr_anon, nr_file, nr_huge, page);
+				pgpgout = nr_mem = nr_memsw = 0;
+				nr_anon = nr_file = nr_huge = 0;
+			}
+			memcg = pc->mem_cgroup;
+		}
+
+		if (PageTransHuge(page)) {
+			nr_pages <<= compound_order(page);
+			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+			nr_huge += nr_pages;
+		}
+
+		if (PageAnon(page))
+			nr_anon += nr_pages;
+		else
+			nr_file += nr_pages;
+
+		if (pc->flags & PCG_MEM)
+			nr_mem += nr_pages;
+		if (pc->flags & PCG_MEMSW)
+			nr_memsw += nr_pages;
+		pc->flags = 0;
+
+		pgpgout++;
+	} while (next != page_list);
+
+	if (memcg)
+		uncharge_batch(memcg, pgpgout, nr_mem, nr_memsw,
+			       nr_anon, nr_file, nr_huge, page);
+}
+
 /**
  * mem_cgroup_uncharge - uncharge a page
  * @page: page to uncharge
@@ -6561,67 +6606,27 @@ void mem_cgroup_cancel_charge(struct pag
  */
 void mem_cgroup_uncharge(struct page *page)
 {
-	struct memcg_batch_info *batch;
-	unsigned int nr_pages = 1;
-	struct mem_cgroup *memcg;
-	struct page_cgroup *pc;
-	unsigned long pc_flags;
-	unsigned long flags;
-
-	VM_BUG_ON_PAGE(PageLRU(page), page);
-	VM_BUG_ON_PAGE(page_count(page), page);
-
 	if (mem_cgroup_disabled())
 		return;
 
-	pc = lookup_page_cgroup(page);
+	INIT_LIST_HEAD(&page->lru);
+	uncharge_list(&page->lru);
+}
 
-	/* Every final put_page() ends up here */
-	if (!PageCgroupUsed(pc))
+/**
+ * mem_cgroup_uncharge_list - uncharge a list of page
+ * @page_list: list of pages to uncharge
+ *
+ * Uncharge a list of pages previously charged with
+ * mem_cgroup_try_charge() and mem_cgroup_commit_charge().
+ */
+void mem_cgroup_uncharge_list(struct list_head *page_list)
+{
+	if (mem_cgroup_disabled())
 		return;
 
-	if (PageTransHuge(page)) {
-		nr_pages <<= compound_order(page);
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-	}
-	/*
-	 * Nobody should be changing or seriously looking at
-	 * pc->mem_cgroup and pc->flags at this point, we have fully
-	 * exclusive access to the page.
-	 */
-	memcg = pc->mem_cgroup;
-	pc_flags = pc->flags;
-	pc->flags = 0;
-
-	local_irq_save(flags);
-
-	if (nr_pages > 1)
-		goto direct;
-	if (unlikely(test_thread_flag(TIF_MEMDIE)))
-		goto direct;
-	batch = &current->memcg_batch;
-	if (!batch->do_batch)
-		goto direct;
-	if (batch->memcg && batch->memcg != memcg)
-		goto direct;
-	if (!batch->memcg)
-		batch->memcg = memcg;
-	if (pc_flags & PCG_MEM)
-		batch->nr_pages++;
-	if (pc_flags & PCG_MEMSW)
-		batch->memsw_nr_pages++;
-	goto out;
-direct:
-	if (pc_flags & PCG_MEM)
-		res_counter_uncharge(&memcg->res, nr_pages * PAGE_SIZE);
-	if (pc_flags & PCG_MEMSW)
-		res_counter_uncharge(&memcg->memsw, nr_pages * PAGE_SIZE);
-	memcg_oom_recover(memcg);
-out:
-	mem_cgroup_charge_statistics(memcg, page, -nr_pages);
-	memcg_check_events(memcg, page);
-
-	local_irq_restore(flags);
+	if (!list_empty(page_list))
+		uncharge_list(page_list);
 }
 
 /**
diff -puN mm/swap.c~mm-memcontrol-use-page-lists-for-uncharge-batching mm/swap.c
--- a/mm/swap.c~mm-memcontrol-use-page-lists-for-uncharge-batching
+++ a/mm/swap.c
@@ -916,8 +916,6 @@ void release_pages(struct page **pages,
 	struct lruvec *lruvec;
 	unsigned long uninitialized_var(flags);
 
-	mem_cgroup_uncharge_start();
-
 	for (i = 0; i < nr; i++) {
 		struct page *page = pages[i];
 
@@ -949,7 +947,6 @@ void release_pages(struct page **pages,
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
-		mem_cgroup_uncharge(page);
 
 		/* Clear Active bit in case of parallel mark_page_accessed */
 		__ClearPageActive(page);
@@ -959,8 +956,7 @@ void release_pages(struct page **pages,
 	if (zone)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-	mem_cgroup_uncharge_end();
-
+	mem_cgroup_uncharge_list(&pages_to_free);
 	free_hot_cold_page_list(&pages_to_free, cold);
 }
 EXPORT_SYMBOL(release_pages);
diff -puN mm/vmscan.c~mm-memcontrol-use-page-lists-for-uncharge-batching mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-use-page-lists-for-uncharge-batching
+++ a/mm/vmscan.c
@@ -816,7 +816,6 @@ static unsigned long shrink_page_list(st
 
 	cond_resched();
 
-	mem_cgroup_uncharge_start();
 	while (!list_empty(page_list)) {
 		struct address_space *mapping;
 		struct page *page;
@@ -1097,7 +1096,6 @@ static unsigned long shrink_page_list(st
 		 */
 		__clear_page_locked(page);
 free_it:
-		mem_cgroup_uncharge(page);
 		nr_reclaimed++;
 
 		/*
@@ -1127,8 +1125,8 @@ keep:
 		list_add(&page->lru, &ret_pages);
 		VM_BUG_ON_PAGE(PageLRU(page) || PageUnevictable(page), page);
 	}
-	mem_cgroup_uncharge_end();
 
+	mem_cgroup_uncharge_list(&free_pages);
 	free_hot_cold_page_list(&free_pages, true);
 
 	list_splice(&ret_pages, page_list);
@@ -1431,10 +1429,9 @@ putback_inactive_pages(struct lruvec *lr
 			__ClearPageActive(page);
 			del_page_from_lru_list(page, lruvec, lru);
 
-			mem_cgroup_uncharge(page);
-
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&zone->lru_lock);
+				mem_cgroup_uncharge(page);
 				(*get_compound_page_dtor(page))(page);
 				spin_lock_irq(&zone->lru_lock);
 			} else
@@ -1542,6 +1539,7 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_unlock_irq(&zone->lru_lock);
 
+	mem_cgroup_uncharge_list(&page_list);
 	free_hot_cold_page_list(&page_list, true);
 
 	/*
@@ -1654,10 +1652,9 @@ static void move_active_pages_to_lru(str
 			__ClearPageActive(page);
 			del_page_from_lru_list(page, lruvec, lru);
 
-			mem_cgroup_uncharge(page);
-
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&zone->lru_lock);
+				mem_cgroup_uncharge(page);
 				(*get_compound_page_dtor(page))(page);
 				spin_lock_irq(&zone->lru_lock);
 			} else
@@ -1765,6 +1762,7 @@ static void shrink_active_list(unsigned
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
+	mem_cgroup_uncharge_list(&l_hold);
 	free_hot_cold_page_list(&l_hold, true);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

