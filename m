From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-vmscan-clean-up-struct-scan_control.patch
 removed from -mm tree
Date: Thu, 17 Jul 2014 14:45:47 -0700
Message-ID: <53c8440b.XvtImvKbjz7hbWpz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:64798 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaGQVps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 17:45:48 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so814966pde.3
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 14:45:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: clean up struct scan_control
has been removed from the -mm tree.  Its filename was
     mm-vmscan-clean-up-struct-scan_control.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: clean up struct scan_control

Reorder the members by input and output, then turn the individual integers
for may_writepage, may_unmap, may_swap, compaction_ready, hibernation_mode
into flags that fit into a single integer.

Stack delta: +72/-296 -224                   old     new   delta
kswapd                                       104     176     +72
try_to_free_pages                             80      56     -24
try_to_free_mem_cgroup_pages                  80      56     -24
shrink_all_memory                             88      64     -24
reclaim_clean_pages_from_list                168     144     -24
mem_cgroup_shrink_node_zone                  104      80     -24
__zone_reclaim                               176     152     -24
balance_pgdat                                152       -    -152

   text    data     bss     dec     hex filename
  38151    5641      16   43808    ab20 mm/vmscan.o.old
  38047    5641      16   43704    aab8 mm/vmscan.o

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  158 ++++++++++++++++++++++++--------------------------
 1 file changed, 78 insertions(+), 80 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-clean-up-struct-scan_control mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clean-up-struct-scan_control
+++ a/mm/vmscan.c
@@ -58,36 +58,28 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
 
-struct scan_control {
-	/* Incremented by the number of inactive pages that were scanned */
-	unsigned long nr_scanned;
-
-	/* Number of pages freed so far during a call to shrink_zones() */
-	unsigned long nr_reclaimed;
-
-	/* One of the zones is ready for compaction */
-	int compaction_ready;
+/* Scan control flags */
+#define MAY_WRITEPAGE		0x1
+#define MAY_UNMAP		0x2
+#define MAY_SWAP		0x4
+#define MAY_SKIP_CONGESTION	0x8
+#define COMPACTION_READY	0x10
 
+struct scan_control {
 	/* How many pages shrink_list() should reclaim */
 	unsigned long nr_to_reclaim;
 
-	unsigned long hibernation_mode;
-
 	/* This context's GFP mask */
 	gfp_t gfp_mask;
 
-	int may_writepage;
-
-	/* Can mapped pages be reclaimed? */
-	int may_unmap;
-
-	/* Can pages be swapped as part of reclaim? */
-	int may_swap;
-
+	/* Allocation order */
 	int order;
 
-	/* Scan (total_size >> priority) pages at once */
-	int priority;
+	/*
+	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
+	 * are scanned.
+	 */
+	nodemask_t	*nodemask;
 
 	/*
 	 * The memory cgroup that hit its limit and as a result is the
@@ -95,11 +87,17 @@ struct scan_control {
 	 */
 	struct mem_cgroup *target_mem_cgroup;
 
-	/*
-	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
-	 * are scanned.
-	 */
-	nodemask_t	*nodemask;
+	/* Scan (total_size >> priority) pages at once */
+	int priority;
+
+	/* Scan control flags; see above */
+	unsigned int flags;
+
+	/* Incremented by the number of inactive pages that were scanned */
+	unsigned long nr_scanned;
+
+	/* Number of pages freed so far during a call to shrink_zones() */
+	unsigned long nr_reclaimed;
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -839,7 +837,7 @@ static unsigned long shrink_page_list(st
 		if (unlikely(!page_evictable(page)))
 			goto cull_mlocked;
 
-		if (!sc->may_unmap && page_mapped(page))
+		if (!(sc->flags & MAY_UNMAP) && page_mapped(page))
 			goto keep_locked;
 
 		/* Double the slab pressure for mapped and swapcache pages */
@@ -1013,7 +1011,7 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 			if (!may_enter_fs)
 				goto keep_locked;
-			if (!sc->may_writepage)
+			if (!(sc->flags & MAY_WRITEPAGE))
 				goto keep_locked;
 
 			/* Page is dirty, try to write it out here */
@@ -1146,7 +1144,7 @@ unsigned long reclaim_clean_pages_from_l
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.priority = DEF_PRIORITY,
-		.may_unmap = 1,
+		.flags = MAY_UNMAP,
 	};
 	unsigned long ret, dummy1, dummy2, dummy3, dummy4, dummy5;
 	struct page *page, *next;
@@ -1490,9 +1488,9 @@ shrink_inactive_list(unsigned long nr_to
 
 	lru_add_drain();
 
-	if (!sc->may_unmap)
+	if (!(sc->flags & MAY_UNMAP))
 		isolate_mode |= ISOLATE_UNMAPPED;
-	if (!sc->may_writepage)
+	if (!(sc->flags & MAY_WRITEPAGE))
 		isolate_mode |= ISOLATE_CLEAN;
 
 	spin_lock_irq(&zone->lru_lock);
@@ -1595,7 +1593,7 @@ shrink_inactive_list(unsigned long nr_to
 	 * is congested. Allow kswapd to continue until it starts encountering
 	 * unqueued dirty pages or cycling through the LRU too quickly.
 	 */
-	if (!sc->hibernation_mode && !current_is_kswapd() &&
+	if (!(sc->flags & MAY_SKIP_CONGESTION) && !current_is_kswapd() &&
 	    current_may_throttle())
 		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
 
@@ -1686,9 +1684,9 @@ static void shrink_active_list(unsigned
 
 	lru_add_drain();
 
-	if (!sc->may_unmap)
+	if (!(sc->flags & MAY_UNMAP))
 		isolate_mode |= ISOLATE_UNMAPPED;
-	if (!sc->may_writepage)
+	if (!(sc->flags & MAY_WRITEPAGE))
 		isolate_mode |= ISOLATE_CLEAN;
 
 	spin_lock_irq(&zone->lru_lock);
@@ -1901,7 +1899,7 @@ static void get_scan_count(struct lruvec
 		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
+	if (!(sc->flags & MAY_SWAP) || (get_nr_swap_pages() <= 0)) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2410,7 +2408,7 @@ static bool shrink_zones(struct zonelist
 			    sc->order > PAGE_ALLOC_COSTLY_ORDER &&
 			    zonelist_zone_idx(z) <= requested_highidx &&
 			    compaction_ready(zone, sc->order)) {
-				sc->compaction_ready = true;
+				sc->flags |= COMPACTION_READY;
 				continue;
 			}
 
@@ -2500,7 +2498,7 @@ static unsigned long do_try_to_free_page
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			break;
 
-		if (sc->compaction_ready)
+		if (sc->flags & COMPACTION_READY)
 			break;
 
 		/*
@@ -2508,7 +2506,7 @@ static unsigned long do_try_to_free_page
 		 * writepage even in laptop mode.
 		 */
 		if (sc->priority < DEF_PRIORITY - 2)
-			sc->may_writepage = 1;
+			sc->flags |= MAY_WRITEPAGE;
 
 		/*
 		 * Try to write back as many pages as we just scanned.  This
@@ -2521,7 +2519,7 @@ static unsigned long do_try_to_free_page
 		if (total_scanned > writeback_threshold) {
 			wakeup_flusher_threads(laptop_mode ? 0 : total_scanned,
 						WB_REASON_TRY_TO_FREE_PAGES);
-			sc->may_writepage = 1;
+			sc->flags |= MAY_WRITEPAGE;
 		}
 	} while (--sc->priority >= 0);
 
@@ -2531,7 +2529,7 @@ static unsigned long do_try_to_free_page
 		return sc->nr_reclaimed;
 
 	/* Aborted reclaim to try compaction? don't OOM, then */
-	if (sc->compaction_ready)
+	if (sc->flags & COMPACTION_READY)
 		return 1;
 
 	/* Any of the zones still reclaimable?  Don't OOM. */
@@ -2672,17 +2670,17 @@ unsigned long try_to_free_pages(struct z
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
-		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
-		.may_writepage = !laptop_mode,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.may_unmap = 1,
-		.may_swap = 1,
+		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
 		.order = order,
-		.priority = DEF_PRIORITY,
-		.target_mem_cgroup = NULL,
 		.nodemask = nodemask,
+		.priority = DEF_PRIORITY,
+		.flags = MAY_UNMAP | MAY_SWAP,
 	};
 
+	if (!laptop_mode)
+		sc.flags |= MAY_WRITEPAGE;
+
 	/*
 	 * Do not enter reclaim if fatal signal was delivered while throttled.
 	 * 1 is returned so that the page allocator does not OOM kill at this
@@ -2692,7 +2690,7 @@ unsigned long try_to_free_pages(struct z
 		return 1;
 
 	trace_mm_vmscan_direct_reclaim_begin(order,
-				sc.may_writepage,
+				sc.flags & MAY_WRITEPAGE,
 				gfp_mask);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -2710,23 +2708,22 @@ unsigned long mem_cgroup_shrink_node_zon
 						unsigned long *nr_scanned)
 {
 	struct scan_control sc = {
-		.nr_scanned = 0,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.may_writepage = !laptop_mode,
-		.may_unmap = 1,
-		.may_swap = !noswap,
-		.order = 0,
-		.priority = 0,
+		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
+		            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
 		.target_mem_cgroup = memcg,
+		.flags = MAY_UNMAP,
 	};
 	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 	int swappiness = mem_cgroup_swappiness(memcg);
 
-	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
+	if (!laptop_mode)
+		sc.flags |= MAY_WRITEPAGE;
+	if (!noswap)
+		sc.flags |= MAY_SWAP;
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
-						      sc.may_writepage,
+						      sc.flags & MAY_WRITEPAGE,
 						      sc.gfp_mask);
 
 	/*
@@ -2752,18 +2749,19 @@ unsigned long try_to_free_mem_cgroup_pag
 	unsigned long nr_reclaimed;
 	int nid;
 	struct scan_control sc = {
-		.may_writepage = !laptop_mode,
-		.may_unmap = 1,
-		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.order = 0,
-		.priority = DEF_PRIORITY,
-		.target_mem_cgroup = memcg,
-		.nodemask = NULL, /* we don't care the placement */
 		.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+		            (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+		.target_mem_cgroup = memcg,
+		.priority = DEF_PRIORITY,
+		.flags = MAY_UNMAP,
 	};
 
+	if (!laptop_mode)
+		sc.flags |= MAY_WRITEPAGE;
+	if (!noswap)
+		sc.flags |= MAY_SWAP;
+
 	/*
 	 * Unlike direct reclaim via alloc_pages(), memcg's reclaim doesn't
 	 * take care of from where we get pages. So the node where we start the
@@ -2774,7 +2772,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	zonelist = NODE_DATA(nid)->node_zonelists;
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
-					    sc.may_writepage,
+					    sc.flags & MAY_WRITEPAGE,
 					    sc.gfp_mask);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -3019,15 +3017,15 @@ static unsigned long balance_pgdat(pg_da
 	unsigned long nr_soft_scanned;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.priority = DEF_PRIORITY,
-		.may_unmap = 1,
-		.may_swap = 1,
-		.may_writepage = !laptop_mode,
 		.order = order,
-		.target_mem_cgroup = NULL,
+		.priority = DEF_PRIORITY,
+		.flags = MAY_UNMAP | MAY_SWAP,
 	};
 	count_vm_event(PAGEOUTRUN);
 
+	if (!laptop_mode)
+		sc.flags |= MAY_WRITEPAGE;
+
 	do {
 		unsigned long lru_pages = 0;
 		unsigned long nr_attempted = 0;
@@ -3108,7 +3106,7 @@ static unsigned long balance_pgdat(pg_da
 		 * even in laptop mode.
 		 */
 		if (sc.priority < DEF_PRIORITY - 2)
-			sc.may_writepage = 1;
+			sc.flags |= MAY_WRITEPAGE;
 
 		/*
 		 * Now scan the zone in the dma->highmem direction, stopping
@@ -3405,14 +3403,11 @@ unsigned long shrink_all_memory(unsigned
 {
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
-		.gfp_mask = GFP_HIGHUSER_MOVABLE,
-		.may_swap = 1,
-		.may_unmap = 1,
-		.may_writepage = 1,
 		.nr_to_reclaim = nr_to_reclaim,
-		.hibernation_mode = 1,
-		.order = 0,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE,
 		.priority = DEF_PRIORITY,
+		.flags = MAY_WRITEPAGE | MAY_UNMAP | MAY_SWAP |
+		         MAY_SKIP_CONGESTION,
 	};
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
@@ -3592,19 +3587,22 @@ static int __zone_reclaim(struct zone *z
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
-		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
-		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
-		.may_swap = 1,
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
 		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
 		.order = order,
 		.priority = ZONE_RECLAIM_PRIORITY,
+		.flags = MAY_SWAP,
 	};
 	struct shrink_control shrink = {
 		.gfp_mask = sc.gfp_mask,
 	};
 	unsigned long nr_slab_pages0, nr_slab_pages1;
 
+	if (zone_reclaim_mode & RECLAIM_WRITE)
+		sc.flags |= MAY_WRITEPAGE;
+	if (zone_reclaim_mode & RECLAIM_SWAP)
+		sc.flags |= MAY_UNMAP;
+
 	cond_resched();
 	/*
 	 * We need to be able to allocate from the reserves for RECLAIM_SWAP
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch
shmem-fix-splicing-from-a-hole-while-its-punched.patch
mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
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
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-vmscan-clean-up-struct-scan_control-checkpatch-fixes.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

