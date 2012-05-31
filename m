From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-kill-struct-mem_cgroup_zone.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:40 -0700
Message-ID: <20120531191740.587DAA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36697 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:42 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so85867lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: kill struct mem_cgroup_zone
has been removed from the -mm tree.  Its filename was
     mm-vmscan-kill-struct-mem_cgroup_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: kill struct mem_cgroup_zone

Kill struct mem_cgroup_zone and rename shrink_mem_cgroup_zone() to
shrink_lruvec(), it always shrinks one lruvec which it takes as an
argument.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-kill-struct-mem_cgroup_zone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-kill-struct-mem_cgroup_zone
+++ a/mm/vmscan.c
@@ -94,11 +94,6 @@ struct scan_control {
 	nodemask_t	*nodemask;
 };
 
-struct mem_cgroup_zone {
-	struct mem_cgroup *mem_cgroup;
-	struct zone *zone;
-};
-
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
 
 #ifdef ARCH_HAS_PREFETCH
@@ -1769,8 +1764,7 @@ static inline bool should_continue_recla
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_mem_cgroup_zone(struct mem_cgroup_zone *mz,
-				   struct scan_control *sc)
+static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
@@ -1778,9 +1772,6 @@ static void shrink_mem_cgroup_zone(struc
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
-	struct lruvec *lruvec;
-
-	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 
 restart:
 	nr_reclaimed = 0;
@@ -1842,12 +1833,10 @@ static void shrink_zone(struct zone *zon
 
 	memcg = mem_cgroup_iter(root, NULL, &reclaim);
 	do {
-		struct mem_cgroup_zone mz = {
-			.mem_cgroup = memcg,
-			.zone = zone,
-		};
+		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+
+		shrink_lruvec(lruvec, sc);
 
-		shrink_mem_cgroup_zone(&mz, sc);
 		/*
 		 * Limit reclaim has historically picked one memcg and
 		 * scanned it with decreasing priority levels until
@@ -2172,10 +2161,7 @@ unsigned long mem_cgroup_shrink_node_zon
 		.priority = 0,
 		.target_mem_cgroup = memcg,
 	};
-	struct mem_cgroup_zone mz = {
-		.mem_cgroup = memcg,
-		.zone = zone,
-	};
+	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -2191,7 +2177,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_mem_cgroup_zone(&mz, &sc);
+	shrink_lruvec(lruvec, &sc);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

