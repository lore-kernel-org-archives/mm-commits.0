From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-pass-memcg-to-get_scan_count.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:29:53 -0800
Message-ID: <56a169f1.CWSswTcKo+B0R1Y9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUX3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: pass memcg to get_scan_count()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-pass-memcg-to-get_scan_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: vmscan: pass memcg to get_scan_count()

memcg will come in handy in get_scan_count().  It can already be used for
getting swappiness immediately in get_scan_count() instead of passing it
around.  The following patches will add more memcg-related values, which
will be used there.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-pass-memcg-to-get_scan_count mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-pass-memcg-to-get_scan_count
+++ a/mm/vmscan.c
@@ -1966,10 +1966,11 @@ enum scan_balance {
  * nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
  * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
  */
-static void get_scan_count(struct lruvec *lruvec, int swappiness,
+static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 			   struct scan_control *sc, unsigned long *nr,
 			   unsigned long *lru_pages)
 {
+	int swappiness = mem_cgroup_swappiness(memcg);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 	u64 fraction[2];
 	u64 denominator = 0;	/* gcc */
@@ -2193,9 +2194,10 @@ static inline void init_tlb_ubc(void)
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_lruvec(struct lruvec *lruvec, int swappiness,
-			  struct scan_control *sc, unsigned long *lru_pages)
+static void shrink_zone_memcg(struct zone *zone, struct mem_cgroup *memcg,
+			      struct scan_control *sc, unsigned long *lru_pages)
 {
+	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long targets[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
@@ -2205,7 +2207,7 @@ static void shrink_lruvec(struct lruvec
 	struct blk_plug plug;
 	bool scan_adjusted;
 
-	get_scan_count(lruvec, swappiness, sc, nr, lru_pages);
+	get_scan_count(lruvec, memcg, sc, nr, lru_pages);
 
 	/* Record the original scan target for proportional adjustments later */
 	memcpy(targets, nr, sizeof(nr));
@@ -2409,8 +2411,6 @@ static bool shrink_zone(struct zone *zon
 			unsigned long lru_pages;
 			unsigned long reclaimed;
 			unsigned long scanned;
-			struct lruvec *lruvec;
-			int swappiness;
 
 			if (mem_cgroup_low(root, memcg)) {
 				if (!sc->may_thrash)
@@ -2418,12 +2418,10 @@ static bool shrink_zone(struct zone *zon
 				mem_cgroup_events(memcg, MEMCG_LOW, 1);
 			}
 
-			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
-			swappiness = mem_cgroup_swappiness(memcg);
 			reclaimed = sc->nr_reclaimed;
 			scanned = sc->nr_scanned;
 
-			shrink_lruvec(lruvec, swappiness, sc, &lru_pages);
+			shrink_zone_memcg(zone, memcg, sc, &lru_pages);
 			zone_lru_pages += lru_pages;
 
 			if (memcg && is_classzone)
@@ -2893,8 +2891,6 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_unmap = 1,
 		.may_swap = !noswap,
 	};
-	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
-	int swappiness = mem_cgroup_swappiness(memcg);
 	unsigned long lru_pages;
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
@@ -2911,7 +2907,7 @@ unsigned long mem_cgroup_shrink_node_zon
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_lruvec(lruvec, swappiness, &sc, &lru_pages);
+	shrink_zone_memcg(zone, memcg, &sc, &lru_pages);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


