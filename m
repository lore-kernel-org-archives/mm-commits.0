From: akpm@linux-foundation.org
Subject: + mm-vmscan-clean-up-struct-scan_control-v2.patch added to -mm
 tree
Date: Thu, 17 Jul 2014 14:45:40 -0700
Message-ID: <53c84404.2/LefRiDQIPWWxpA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:48424 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaGQVpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 17:45:41 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so812300pab.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 14:45:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: clean up struct scan_control
has been added to the -mm tree.  Its filename is
     mm-vmscan-clean-up-struct-scan_control-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-clean-up-struct-scan_control-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-clean-up-struct-scan_control-v2.patch

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
Subject: mm: vmscan: clean up struct scan_control

Reorder the members by input and output, then turn the individual integers
for may_writepage, may_unmap, may_swap, compaction_ready, hibernation_mode
into bit fields to save stack space:

+72/-296 -224
kswapd                                       104     176     +72
try_to_free_pages                             80      56     -24
try_to_free_mem_cgroup_pages                  80      56     -24
shrink_all_memory                             88      64     -24
reclaim_clean_pages_from_list                168     144     -24
mem_cgroup_shrink_node_zone                  104      80     -24
__zone_reclaim                               176     152     -24
balance_pgdat                                152       -    -152

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   99 +++++++++++++++++++++++---------------------------
 1 file changed, 46 insertions(+), 53 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-clean-up-struct-scan_control-v2 mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-clean-up-struct-scan_control-v2
+++ a/mm/vmscan.c
@@ -59,35 +59,20 @@
 #include <trace/events/vmscan.h>
 
 struct scan_control {
-	/* Incremented by the number of inactive pages that were scanned */
-	unsigned long nr_scanned;
-
-	/* Number of pages freed so far during a call to shrink_zones() */
-	unsigned long nr_reclaimed;
-
-	/* One of the zones is ready for compaction */
-	int compaction_ready;
-
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
@@ -95,11 +80,27 @@ struct scan_control {
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
+	unsigned int may_writepage:1;
+
+	/* Can mapped pages be reclaimed? */
+	unsigned int may_unmap:1;
+
+	/* Can pages be swapped as part of reclaim? */
+	unsigned int may_swap:1;
+
+	unsigned int hibernation_mode:1;
+
+	/* One of the zones is ready for compaction */
+	unsigned int compaction_ready:1;
+
+	/* Incremented by the number of inactive pages that were scanned */
+	unsigned long nr_scanned;
+
+	/* Number of pages freed so far during a call to shrink_zones() */
+	unsigned long nr_reclaimed;
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -2672,15 +2673,14 @@ unsigned long try_to_free_pages(struct z
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
+		.order = order,
+		.nodemask = nodemask,
+		.priority = DEF_PRIORITY,
 		.may_writepage = !laptop_mode,
-		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.order = order,
-		.priority = DEF_PRIORITY,
-		.target_mem_cgroup = NULL,
-		.nodemask = nodemask,
 	};
 
 	/*
@@ -2710,14 +2710,11 @@ unsigned long mem_cgroup_shrink_node_zon
 						unsigned long *nr_scanned)
 {
 	struct scan_control sc = {
-		.nr_scanned = 0,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
+		.target_mem_cgroup = memcg,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.order = 0,
-		.priority = 0,
-		.target_mem_cgroup = memcg,
 	};
 	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 	int swappiness = mem_cgroup_swappiness(memcg);
@@ -2752,16 +2749,14 @@ unsigned long try_to_free_mem_cgroup_pag
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
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
+		.target_mem_cgroup = memcg,
+		.priority = DEF_PRIORITY,
+		.may_writepage = !laptop_mode,
+		.may_unmap = 1,
+		.may_swap = !noswap,
 	};
 
 	/*
@@ -3019,12 +3014,11 @@ static unsigned long balance_pgdat(pg_da
 	unsigned long nr_soft_scanned;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
+		.order = order,
 		.priority = DEF_PRIORITY,
+		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.may_writepage = !laptop_mode,
-		.order = order,
-		.target_mem_cgroup = NULL,
 	};
 	count_vm_event(PAGEOUTRUN);
 
@@ -3405,14 +3399,13 @@ unsigned long shrink_all_memory(unsigned
 {
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
+		.nr_to_reclaim = nr_to_reclaim,
 		.gfp_mask = GFP_HIGHUSER_MOVABLE,
-		.may_swap = 1,
-		.may_unmap = 1,
+		.priority = DEF_PRIORITY,
 		.may_writepage = 1,
-		.nr_to_reclaim = nr_to_reclaim,
+		.may_unmap = 1,
+		.may_swap = 1,
 		.hibernation_mode = 1,
-		.order = 0,
-		.priority = DEF_PRIORITY,
 	};
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
@@ -3592,13 +3585,13 @@ static int __zone_reclaim(struct zone *z
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
+		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
+		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
+		.may_swap = 1,
 	};
 	struct shrink_control shrink = {
 		.gfp_mask = sc.gfp_mask,
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
mm-vmscan-clean-up-struct-scan_control.patch
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

