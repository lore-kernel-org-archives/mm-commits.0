From: akpm@linux-foundation.org
Subject: + mm-vmscan-move-swappiness-out-of-scan_control.patch added to
 -mm tree
Date: Fri, 20 Jun 2014 15:24:53 -0700
Message-ID: <53a4b4b5.Wxbdb8dEqyRctNch%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965046AbaFTWYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:24:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org


The patch titled
     Subject: mm: vmscan: move swappiness out of scan_control
has been added to the -mm tree.  Its filename is
     mm-vmscan-move-swappiness-out-of-scan_control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-move-swappiness-out-of-scan_control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-move-swappiness-out-of-scan_control.patch

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
Subject: mm: vmscan: move swappiness out of scan_control

Swappiness is determined for each scanned memcg individually in
shrink_zone() and is not a parameter that applies throughout the reclaim
scan.  Move it out of struct scan_control to prevent accidental use of a
stale value.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-move-swappiness-out-of-scan_control mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-move-swappiness-out-of-scan_control
+++ a/mm/vmscan.c
@@ -89,9 +89,6 @@ struct scan_control {
 	/* Scan (total_size >> priority) pages at once */
 	int priority;
 
-	/* anon vs. file LRUs scanning "ratio" */
-	int swappiness;
-
 	/*
 	 * The memory cgroup that hit its limit and as a result is the
 	 * primary target of this reclaim invocation.
@@ -1874,8 +1871,8 @@ enum scan_balance {
  * nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
  * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
  */
-static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
-			   unsigned long *nr)
+static void get_scan_count(struct lruvec *lruvec, int swappiness,
+			   struct scan_control *sc, unsigned long *nr)
 {
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 	u64 fraction[2];
@@ -1918,7 +1915,7 @@ static void get_scan_count(struct lruvec
 	 * using the memory controller's swap limit feature would be
 	 * too expensive.
 	 */
-	if (!global_reclaim(sc) && !sc->swappiness) {
+	if (!global_reclaim(sc) && !swappiness) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -1928,7 +1925,7 @@ static void get_scan_count(struct lruvec
 	 * system is close to OOM, scan both anon and file equally
 	 * (unless the swappiness setting disagrees with swapping).
 	 */
-	if (!sc->priority && sc->swappiness) {
+	if (!sc->priority && swappiness) {
 		scan_balance = SCAN_EQUAL;
 		goto out;
 	}
@@ -1971,7 +1968,7 @@ static void get_scan_count(struct lruvec
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = sc->swappiness;
+	anon_prio = swappiness;
 	file_prio = 200 - anon_prio;
 
 	/*
@@ -2061,7 +2058,8 @@ out:
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
+static void shrink_lruvec(struct lruvec *lruvec, int swappiness,
+			  struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long targets[NR_LRU_LISTS];
@@ -2072,7 +2070,7 @@ static void shrink_lruvec(struct lruvec
 	struct blk_plug plug;
 	bool scan_adjusted;
 
-	get_scan_count(lruvec, sc, nr);
+	get_scan_count(lruvec, swappiness, sc, nr);
 
 	/* Record the original scan target for proportional adjustments later */
 	memcpy(targets, nr, sizeof(nr));
@@ -2269,11 +2267,12 @@ static unsigned long shrink_zone(struct
 		memcg = mem_cgroup_iter(root, NULL, &reclaim);
 		do {
 			struct lruvec *lruvec;
+			int swappiness;
 
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+			swappiness = mem_cgroup_swappiness(memcg);
 
-			sc->swappiness = mem_cgroup_swappiness(memcg);
-			shrink_lruvec(lruvec, sc);
+			shrink_lruvec(lruvec, swappiness, sc);
 
 			/*
 			 * Direct reclaim and kswapd have to scan all memory
@@ -2720,10 +2719,10 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_swap = !noswap,
 		.order = 0,
 		.priority = 0,
-		.swappiness = mem_cgroup_swappiness(memcg),
 		.target_mem_cgroup = memcg,
 	};
 	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+	int swappiness = mem_cgroup_swappiness(memcg);
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -2739,7 +2738,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_lruvec(lruvec, &sc);
+	shrink_lruvec(lruvec, swappiness, &sc);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
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
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

