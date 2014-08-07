From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-move-swappiness-out-of-scan_control.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:51 -0700
Message-ID: <53e3dbe3.nFZOMjuO4RNrRxAM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:64227 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHGUEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:52 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so610892ykq.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: move swappiness out of scan_control
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-swappiness-out-of-scan_control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
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
@@ -1868,8 +1865,8 @@ enum scan_balance {
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
@@ -1912,7 +1909,7 @@ static void get_scan_count(struct lruvec
 	 * using the memory controller's swap limit feature would be
 	 * too expensive.
 	 */
-	if (!global_reclaim(sc) && !sc->swappiness) {
+	if (!global_reclaim(sc) && !swappiness) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -1922,7 +1919,7 @@ static void get_scan_count(struct lruvec
 	 * system is close to OOM, scan both anon and file equally
 	 * (unless the swappiness setting disagrees with swapping).
 	 */
-	if (!sc->priority && sc->swappiness) {
+	if (!sc->priority && swappiness) {
 		scan_balance = SCAN_EQUAL;
 		goto out;
 	}
@@ -1965,7 +1962,7 @@ static void get_scan_count(struct lruvec
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = sc->swappiness;
+	anon_prio = swappiness;
 	file_prio = 200 - anon_prio;
 
 	/*
@@ -2055,7 +2052,8 @@ out:
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
+static void shrink_lruvec(struct lruvec *lruvec, int swappiness,
+			  struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long targets[NR_LRU_LISTS];
@@ -2066,7 +2064,7 @@ static void shrink_lruvec(struct lruvec
 	struct blk_plug plug;
 	bool scan_adjusted;
 
-	get_scan_count(lruvec, sc, nr);
+	get_scan_count(lruvec, swappiness, sc, nr);
 
 	/* Record the original scan target for proportional adjustments later */
 	memcpy(targets, nr, sizeof(nr));
@@ -2263,11 +2261,12 @@ static bool shrink_zone(struct zone *zon
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
@@ -2714,10 +2713,10 @@ unsigned long mem_cgroup_shrink_node_zon
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
@@ -2733,7 +2732,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_lruvec(lruvec, &sc);
+	shrink_lruvec(lruvec, swappiness, &sc);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

