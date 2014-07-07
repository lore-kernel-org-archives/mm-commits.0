From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-memcontrol-rewrite-uncharge-api-fix-6.patch
 removed from -mm tree
Date: Mon, 07 Jul 2014 13:03:06 -0700
Message-ID: <53bafcfa.ZG92a/MeZtuiwK5y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57871 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaGGUDH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 16:03:07 -0400
Received: by mail-qa0-f74.google.com with SMTP id w8so683906qac.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 13:03:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: rewrite uncharge API fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-uncharge-api-fix-6.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: rewrite uncharge API fix

Hugh reports:

======================================================
[ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
3.16.0-rc2-mm1 #3 Not tainted
------------------------------------------------------
cc1/2771 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&(&rtpz->lock)->rlock){+.+.-.}, at: [<ffffffff811518b5>] memcg_check_events+0x17e/0x206
dd
and this task is already holding:
 (&(&zone->lru_lock)->rlock){..-.-.}, at: [<ffffffff8110da3f>] release_pages+0xe7/0x239
which would create a new lock dependency:
 (&(&zone->lru_lock)->rlock){..-.-.} -> (&(&rtpz->lock)->rlock){+.+.-.}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&(&zone->lru_lock)->rlock){..-.-.}
... which became SOFTIRQ-irq-safe at:
  [<ffffffff810c201e>] __lock_acquire+0x59f/0x17e8
  [<ffffffff810c38a6>] lock_acquire+0x61/0x78
  [<ffffffff815bdfbd>] _raw_spin_lock_irqsave+0x3f/0x51
  [<ffffffff8110dc0e>] pagevec_lru_move_fn+0x7d/0xf6
  [<ffffffff8110dca4>] pagevec_move_tail+0x1d/0x2c
  [<ffffffff8110e298>] rotate_reclaimable_page+0xb2/0xd4
  [<ffffffff811018bf>] end_page_writeback+0x1c/0x45
  [<ffffffff81134400>] end_swap_bio_write+0x5c/0x69
  [<ffffffff8123473e>] bio_endio+0x50/0x6e
  [<ffffffff81238dee>] blk_update_request+0x163/0x255
  [<ffffffff81238ef7>] blk_update_bidi_request+0x17/0x65
  [<ffffffff81239242>] blk_end_bidi_request+0x1a/0x56
  [<ffffffff81239289>] blk_end_request+0xb/0xd
  [<ffffffff813a075a>] scsi_io_completion+0x16d/0x553
  [<ffffffff81399c0f>] scsi_finish_command+0xb6/0xbf
  [<ffffffff813a0564>] scsi_softirq_done+0xe9/0xf0
  [<ffffffff8123e8e5>] blk_done_softirq+0x79/0x8b
  [<ffffffff81088675>] __do_softirq+0xfc/0x21f
  [<ffffffff8108898f>] irq_exit+0x3d/0x92
  [<ffffffff81032379>] do_IRQ+0xcc/0xe5
  [<ffffffff815bf5ac>] ret_from_intr+0x0/0x13
  [<ffffffff81443ac0>] cpuidle_enter+0x12/0x14
  [<ffffffff810bb4e4>] cpu_startup_entry+0x187/0x243
  [<ffffffff815a90ab>] rest_init+0x12f/0x133
  [<ffffffff81970e7c>] start_kernel+0x396/0x3a3
  [<ffffffff81970489>] x86_64_start_reservations+0x2a/0x2c
  [<ffffffff81970552>] x86_64_start_kernel+0xc7/0xca

to a SOFTIRQ-irq-unsafe lock:
 (&(&rtpz->lock)->rlock){+.+.-.}
... which became SOFTIRQ-irq-unsafe at:
...  [<ffffffff810c2095>] __lock_acquire+0x616/0x17e8
  [<ffffffff810c38a6>] lock_acquire+0x61/0x78
  [<ffffffff815bde9f>] _raw_spin_lock+0x34/0x41
  [<ffffffff811518b5>] memcg_check_events+0x17e/0x206
  [<ffffffff811535bb>] commit_charge+0x260/0x26f
  [<ffffffff81157004>] mem_cgroup_commit_charge+0xb1/0xdb
  [<ffffffff81115b51>] shmem_getpage_gfp+0x400/0x6c2
  [<ffffffff81115ecc>] shmem_write_begin+0x33/0x35
  [<ffffffff81102a24>] generic_perform_write+0xb7/0x1a4
  [<ffffffff8110391e>] __generic_file_write_iter+0x25b/0x29b
  [<ffffffff81103999>] generic_file_write_iter+0x3b/0xa5
  [<ffffffff8115a115>] new_sync_write+0x7b/0x9f
  [<ffffffff8115a56c>] vfs_write+0xb5/0x169
  [<ffffffff8115ae1f>] SyS_write+0x45/0x8c
  [<ffffffff815bead2>] system_call_fastpath+0x16/0x1b

The soft limit tree lock needs to be IRQ-safe as it's acquired while
holding the IRQ-safe zone->lru_lock.

But more importantly, with uncharge happening in release_pages() now,
this path is executed from interrupt context.

Make the soft limit tree lock, uncharge batching, and charge
statistics IRQ-safe.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  113 +++++++++++++++++++++++++++-------------------
 1 file changed, 67 insertions(+), 46 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-6 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-6
+++ a/mm/memcontrol.c
@@ -754,9 +754,11 @@ static void __mem_cgroup_remove_exceeded
 static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
 				       struct mem_cgroup_tree_per_zone *mctz)
 {
-	spin_lock(&mctz->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&mctz->lock, flags);
 	__mem_cgroup_remove_exceeded(mz, mctz);
-	spin_unlock(&mctz->lock);
+	spin_unlock_irqrestore(&mctz->lock, flags);
 }
 
 
@@ -779,7 +781,9 @@ static void mem_cgroup_update_tree(struc
 		 * mem is over its softlimit.
 		 */
 		if (excess || mz->on_tree) {
-			spin_lock(&mctz->lock);
+			unsigned long flags;
+
+			spin_lock_irqsave(&mctz->lock, flags);
 			/* if on-tree, remove it */
 			if (mz->on_tree)
 				__mem_cgroup_remove_exceeded(mz, mctz);
@@ -788,7 +792,7 @@ static void mem_cgroup_update_tree(struc
 			 * If excess is 0, no tree ops.
 			 */
 			__mem_cgroup_insert_exceeded(mz, mctz, excess);
-			spin_unlock(&mctz->lock);
+			spin_unlock_irqrestore(&mctz->lock, flags);
 		}
 	}
 }
@@ -839,9 +843,9 @@ mem_cgroup_largest_soft_limit_node(struc
 {
 	struct mem_cgroup_per_zone *mz;
 
-	spin_lock(&mctz->lock);
+	spin_lock_irq(&mctz->lock);
 	mz = __mem_cgroup_largest_soft_limit_node(mctz);
-	spin_unlock(&mctz->lock);
+	spin_unlock_irq(&mctz->lock);
 	return mz;
 }
 
@@ -904,8 +908,9 @@ static void mem_cgroup_charge_statistics
 					 struct page *page,
 					 int nr_pages)
 {
-	preempt_disable();
+	unsigned long flags;
 
+	local_irq_save(flags);
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
 	 * counted as CACHE even if it's on ANON LRU.
@@ -930,7 +935,7 @@ static void mem_cgroup_charge_statistics
 	}
 
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
@@ -1009,7 +1014,9 @@ static bool mem_cgroup_event_ratelimit(s
  */
 static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
@@ -1022,7 +1029,7 @@ static void memcg_check_events(struct me
 		do_numainfo = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_NUMAINFO);
 #endif
-		preempt_enable();
+		local_irq_restore(flags);
 
 		mem_cgroup_threshold(memcg);
 		if (unlikely(do_softlimit))
@@ -1032,7 +1039,7 @@ static void memcg_check_events(struct me
 			atomic_inc(&memcg->numainfo_events);
 #endif
 	} else
-		preempt_enable();
+		local_irq_restore(flags);
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
@@ -3620,6 +3627,9 @@ out:
 
 void mem_cgroup_uncharge_start(void)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	current->memcg_batch.do_batch++;
 	/* We can do nest. */
 	if (current->memcg_batch.do_batch == 1) {
@@ -3627,21 +3637,18 @@ void mem_cgroup_uncharge_start(void)
 		current->memcg_batch.nr_pages = 0;
 		current->memcg_batch.memsw_nr_pages = 0;
 	}
+	local_irq_restore(flags);
 }
 
 void mem_cgroup_uncharge_end(void)
 {
 	struct memcg_batch_info *batch = &current->memcg_batch;
+	unsigned long flags;
 
-	if (!batch->do_batch)
-		return;
-
-	batch->do_batch--;
-	if (batch->do_batch) /* If stacked, do nothing. */
-		return;
-
-	if (!batch->memcg)
-		return;
+	local_irq_save(flags);
+	VM_BUG_ON(!batch->do_batch);
+	if (--batch->do_batch) /* If stacked, do nothing */
+		goto out;
 	/*
 	 * This "batch->memcg" is valid without any css_get/put etc...
 	 * bacause we hide charges behind us.
@@ -3653,8 +3660,8 @@ void mem_cgroup_uncharge_end(void)
 		res_counter_uncharge(&batch->memcg->memsw,
 				     batch->memsw_nr_pages * PAGE_SIZE);
 	memcg_oom_recover(batch->memcg);
-	/* forget this pointer (for sanity check) */
-	batch->memcg = NULL;
+out:
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_MEMCG_SWAP
@@ -6554,6 +6561,36 @@ void mem_cgroup_cancel_charge(struct pag
 	cancel_charge(memcg, nr_pages);
 }
 
+static bool uncharge_batched(struct mem_cgroup *memcg,
+			     unsigned long pc_flags,
+			     unsigned int nr_pages)
+{
+	struct memcg_batch_info *batch = &current->memcg_batch;
+	bool uncharged = false;
+	unsigned long flags;
+
+	if (nr_pages > 1)
+		return false;
+	if (test_thread_flag(TIF_MEMDIE))
+		return false;
+
+	local_irq_save(flags);
+	if (!batch->do_batch)
+		goto out;
+	if (batch->memcg && batch->memcg != memcg)
+		goto out;
+	if (!batch->memcg)
+		batch->memcg = memcg;
+	if (pc_flags & PCG_MEM)
+		batch->nr_pages++;
+	if (pc_flags & PCG_MEMSW)
+		batch->memsw_nr_pages++;
+	uncharged = true;
+out:
+	local_irq_restore(flags);
+	return uncharged;
+}
+
 /**
  * mem_cgroup_uncharge - uncharge a page
  * @page: page to uncharge
@@ -6563,11 +6600,10 @@ void mem_cgroup_cancel_charge(struct pag
  */
 void mem_cgroup_uncharge(struct page *page)
 {
-	struct memcg_batch_info *batch;
 	unsigned int nr_pages = 1;
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
-	unsigned long flags;
+	unsigned long pc_flags;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
@@ -6591,35 +6627,20 @@ void mem_cgroup_uncharge(struct page *pa
 	 * exclusive access to the page.
 	 */
 	memcg = pc->mem_cgroup;
-	flags = pc->flags;
+	pc_flags = pc->flags;
 	pc->flags = 0;
 
 	mem_cgroup_charge_statistics(memcg, page, -nr_pages);
 	memcg_check_events(memcg, page);
 
-	batch = &current->memcg_batch;
-	if (!batch->memcg)
-		batch->memcg = memcg;
-	else if (batch->memcg != memcg)
-		goto uncharge;
-	if (nr_pages > 1)
-		goto uncharge;
-	if (!batch->do_batch)
-		goto uncharge;
-	if (test_thread_flag(TIF_MEMDIE))
-		goto uncharge;
-	if (flags & PCG_MEM)
-		batch->nr_pages++;
-	if (flags & PCG_MEMSW)
-		batch->memsw_nr_pages++;
-	return;
-uncharge:
-	if (flags & PCG_MEM)
+	if (uncharge_batched(memcg, pc_flags, nr_pages))
+		return;
+
+	if (pc_flags & PCG_MEM)
 		res_counter_uncharge(&memcg->res, nr_pages * PAGE_SIZE);
-	if (flags & PCG_MEMSW)
+	if (pc_flags & PCG_MEMSW)
 		res_counter_uncharge(&memcg->memsw, nr_pages * PAGE_SIZE);
-	if (batch->memcg != memcg)
-		memcg_oom_recover(memcg);
+	memcg_oom_recover(memcg);
 }
 
 /**
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

