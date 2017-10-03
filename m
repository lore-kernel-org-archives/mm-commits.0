From: akpm@linux-foundation.org
Subject: + mm-use-sc-priority-for-slab-shrink-targets-fix.patch added to
 -mm tree
Date: Tue, 03 Oct 2017 15:12:04 -0700
Message-ID: <59d40b34.9LFFt3pBCODR6C6r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdJCWMF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 18:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aryabinin@virtuozzo.com, david@fromorbit.com, jbacik@fb.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use sc->priority for slab shrink targets fix
has been added to the -mm tree.  Its filename is
     mm-use-sc-priority-for-slab-shrink-targets-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-sc-priority-for-slab-shrink-targets-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-sc-priority-for-slab-shrink-targets-fix.patch

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
Subject: mm: use sc->priority for slab shrink targets fix

The slab shrinker code was the only user of the lru_pages counter in
get_scan_count() and shrink_node_memcg().  Now that it's switched its
pressure notion to sc->priority, the counter is dead code.  Remove it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN mm/vmscan.c~mm-use-sc-priority-for-slab-shrink-targets-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-use-sc-priority-for-slab-shrink-targets-fix
+++ a/mm/vmscan.c
@@ -2163,8 +2163,7 @@ enum scan_balance {
  * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
  */
 static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
-			   struct scan_control *sc, unsigned long *nr,
-			   unsigned long *lru_pages)
+			   struct scan_control *sc, unsigned long *nr)
 {
 	int swappiness = mem_cgroup_swappiness(memcg);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
@@ -2315,7 +2314,6 @@ static void get_scan_count(struct lruvec
 	fraction[1] = fp;
 	denominator = ap + fp + 1;
 out:
-	*lru_pages = 0;
 	for_each_evictable_lru(lru) {
 		int file = is_file_lru(lru);
 		unsigned long size;
@@ -2345,17 +2343,14 @@ out:
 		case SCAN_FILE:
 		case SCAN_ANON:
 			/* Scan one type exclusively */
-			if ((scan_balance == SCAN_FILE) != file) {
-				size = 0;
+			if ((scan_balance == SCAN_FILE) != file)
 				scan = 0;
-			}
 			break;
 		default:
 			/* Look ma, no brain */
 			BUG();
 		}
 
-		*lru_pages += size;
 		nr[lru] = scan;
 	}
 }
@@ -2364,7 +2359,7 @@ out:
  * This is a basic per-node page freer.  Used by both kswapd and direct reclaim.
  */
 static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memcg,
-			      struct scan_control *sc, unsigned long *lru_pages)
+			      struct scan_control *sc)
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, memcg);
 	unsigned long nr[NR_LRU_LISTS];
@@ -2376,7 +2371,7 @@ static void shrink_node_memcg(struct pgl
 	struct blk_plug plug;
 	bool scan_adjusted;
 
-	get_scan_count(lruvec, memcg, sc, nr, lru_pages);
+	get_scan_count(lruvec, memcg, sc, nr);
 
 	/* Record the original scan target for proportional adjustments later */
 	memcpy(targets, nr, sizeof(nr));
@@ -2575,7 +2570,6 @@ static bool shrink_node(pg_data_t *pgdat
 			.pgdat = pgdat,
 			.priority = sc->priority,
 		};
-		unsigned long node_lru_pages = 0;
 		struct mem_cgroup *memcg;
 
 		nr_reclaimed = sc->nr_reclaimed;
@@ -2583,7 +2577,6 @@ static bool shrink_node(pg_data_t *pgdat
 
 		memcg = mem_cgroup_iter(root, NULL, &reclaim);
 		do {
-			unsigned long lru_pages;
 			unsigned long reclaimed;
 			unsigned long scanned;
 
@@ -2598,8 +2591,7 @@ static bool shrink_node(pg_data_t *pgdat
 			reclaimed = sc->nr_reclaimed;
 			scanned = sc->nr_scanned;
 
-			shrink_node_memcg(pgdat, memcg, sc, &lru_pages);
-			node_lru_pages += lru_pages;
+			shrink_node_memcg(pgdat, memcg, sc);
 
 			if (memcg)
 				shrink_slab(sc->gfp_mask, pgdat->node_id,
@@ -3070,7 +3062,6 @@ unsigned long mem_cgroup_shrink_node(str
 		.reclaim_idx = MAX_NR_ZONES - 1,
 		.may_swap = !noswap,
 	};
-	unsigned long lru_pages;
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -3087,7 +3078,7 @@ unsigned long mem_cgroup_shrink_node(str
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_node_memcg(pgdat, memcg, &sc, &lru_pages);
+	shrink_node_memcg(pgdat, memcg, &sc);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-use-vmalloc-fallback-for-large-kmem-memcg-arrays.patch
mm-use-sc-priority-for-slab-shrink-targets-fix.patch

