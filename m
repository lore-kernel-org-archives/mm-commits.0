From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-compaction-works-against-zones-not-lruvecs.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:32 -0800
Message-ID: <20130225204832.A2B7631C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58865 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3BYUse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:34 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so346059vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, satoru.moriya@hds.com, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: compaction works against zones, not lruvecs
has been removed from the -mm tree.  Its filename was
     mm-vmscan-compaction-works-against-zones-not-lruvecs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: compaction works against zones, not lruvecs

The restart logic for when reclaim operates back to back with compaction
is currently applied on the lruvec level.  But this does not make sense,
because the container of interest for compaction is a zone as a whole, not
the zone pages that are part of a certain memory cgroup.

Negative impact is bounded.  For one, the code checks that the lruvec has
enough reclaim candidates, so it does not risk getting stuck on a
condition that can not be fulfilled.  And the unfairness of hammering on
one particular memory cgroup to make progress in a zone will be amortized
by the round robin manner in which reclaim goes through the memory
cgroups.  Still, this can lead to unnecessary allocation latencies when
the code elects to restart on a hard to reclaim or small group when there
are other, more reclaimable groups in the zone.

Move this logic to the zone level and restart reclaim for all memory
cgroups in a zone when compaction requires more free pages from it.

[akpm@linux-foundation.org: no need for min_t]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Cc: Simon Jeons <simon.jeons@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  179 +++++++++++++++++++++++++-------------------------
 1 file changed, 91 insertions(+), 88 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-compaction-works-against-zones-not-lruvecs mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-compaction-works-against-zones-not-lruvecs
+++ a/mm/vmscan.c
@@ -1822,6 +1822,58 @@ out:
 	}
 }
 
+/*
+ * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
+ */
+static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
+{
+	unsigned long nr[NR_LRU_LISTS];
+	unsigned long nr_to_scan;
+	enum lru_list lru;
+	unsigned long nr_reclaimed = 0;
+	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
+	struct blk_plug plug;
+
+	get_scan_count(lruvec, sc, nr);
+
+	blk_start_plug(&plug);
+	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
+					nr[LRU_INACTIVE_FILE]) {
+		for_each_evictable_lru(lru) {
+			if (nr[lru]) {
+				nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
+				nr[lru] -= nr_to_scan;
+
+				nr_reclaimed += shrink_list(lru, nr_to_scan,
+							    lruvec, sc);
+			}
+		}
+		/*
+		 * On large memory systems, scan >> priority can become
+		 * really large. This is fine for the starting priority;
+		 * we want to put equal scanning pressure on each zone.
+		 * However, if the VM has a harder time of freeing pages,
+		 * with multiple processes reclaiming pages, the total
+		 * freeing target can get unreasonably large.
+		 */
+		if (nr_reclaimed >= nr_to_reclaim &&
+		    sc->priority < DEF_PRIORITY)
+			break;
+	}
+	blk_finish_plug(&plug);
+	sc->nr_reclaimed += nr_reclaimed;
+
+	/*
+	 * Even if we did not try to evict anon pages at all, we want to
+	 * rebalance the anon lru active/inactive ratio.
+	 */
+	if (inactive_anon_is_low(lruvec))
+		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
+				   sc, LRU_ACTIVE_ANON);
+
+	throttle_vm_writeout(sc->gfp_mask);
+}
+
 /* Use reclaim/compaction for costly allocs or under memory pressure */
 static bool in_reclaim_compaction(struct scan_control *sc)
 {
@@ -1840,7 +1892,7 @@ static bool in_reclaim_compaction(struct
  * calls try_to_compact_zone() that it will have enough free pages to succeed.
  * It will give up earlier than that if there is difficulty reclaiming pages.
  */
-static inline bool should_continue_reclaim(struct lruvec *lruvec,
+static inline bool should_continue_reclaim(struct zone *zone,
 					unsigned long nr_reclaimed,
 					unsigned long nr_scanned,
 					struct scan_control *sc)
@@ -1880,15 +1932,15 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
+	inactive_lru_pages = zone_page_state(zone, NR_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
-		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
+		inactive_lru_pages += zone_page_state(zone, NR_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
 
 	/* If compaction would go ahead or the allocation would succeed, stop */
-	switch (compaction_suitable(lruvec_zone(lruvec), sc->order)) {
+	switch (compaction_suitable(zone, sc->order)) {
 	case COMPACT_PARTIAL:
 	case COMPACT_CONTINUE:
 		return false;
@@ -1897,98 +1949,49 @@ static inline bool should_continue_recla
 	}
 }
 
-/*
- * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
- */
-static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
+static void shrink_zone(struct zone *zone, struct scan_control *sc)
 {
-	unsigned long nr[NR_LRU_LISTS];
-	unsigned long nr_to_scan;
-	enum lru_list lru;
 	unsigned long nr_reclaimed, nr_scanned;
-	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
-	struct blk_plug plug;
-
-restart:
-	nr_reclaimed = 0;
-	nr_scanned = sc->nr_scanned;
-	get_scan_count(lruvec, sc, nr);
-
-	blk_start_plug(&plug);
-	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
-					nr[LRU_INACTIVE_FILE]) {
-		for_each_evictable_lru(lru) {
-			if (nr[lru]) {
-				nr_to_scan = min_t(unsigned long,
-						   nr[lru], SWAP_CLUSTER_MAX);
-				nr[lru] -= nr_to_scan;
-
-				nr_reclaimed += shrink_list(lru, nr_to_scan,
-							    lruvec, sc);
-			}
-		}
-		/*
-		 * On large memory systems, scan >> priority can become
-		 * really large. This is fine for the starting priority;
-		 * we want to put equal scanning pressure on each zone.
-		 * However, if the VM has a harder time of freeing pages,
-		 * with multiple processes reclaiming pages, the total
-		 * freeing target can get unreasonably large.
-		 */
-		if (nr_reclaimed >= nr_to_reclaim &&
-		    sc->priority < DEF_PRIORITY)
-			break;
-	}
-	blk_finish_plug(&plug);
-	sc->nr_reclaimed += nr_reclaimed;
 
-	/*
-	 * Even if we did not try to evict anon pages at all, we want to
-	 * rebalance the anon lru active/inactive ratio.
-	 */
-	if (inactive_anon_is_low(lruvec))
-		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
-				   sc, LRU_ACTIVE_ANON);
-
-	/* reclaim/compaction might need reclaim to continue */
-	if (should_continue_reclaim(lruvec, nr_reclaimed,
-				    sc->nr_scanned - nr_scanned, sc))
-		goto restart;
+	do {
+		struct mem_cgroup *root = sc->target_mem_cgroup;
+		struct mem_cgroup_reclaim_cookie reclaim = {
+			.zone = zone,
+			.priority = sc->priority,
+		};
+		struct mem_cgroup *memcg;
 
-	throttle_vm_writeout(sc->gfp_mask);
-}
+		nr_reclaimed = sc->nr_reclaimed;
+		nr_scanned = sc->nr_scanned;
 
-static void shrink_zone(struct zone *zone, struct scan_control *sc)
-{
-	struct mem_cgroup *root = sc->target_mem_cgroup;
-	struct mem_cgroup_reclaim_cookie reclaim = {
-		.zone = zone,
-		.priority = sc->priority,
-	};
-	struct mem_cgroup *memcg;
+		memcg = mem_cgroup_iter(root, NULL, &reclaim);
+		do {
+			struct lruvec *lruvec;
 
-	memcg = mem_cgroup_iter(root, NULL, &reclaim);
-	do {
-		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
-		shrink_lruvec(lruvec, sc);
+			shrink_lruvec(lruvec, sc);
 
-		/*
-		 * Limit reclaim has historically picked one memcg and
-		 * scanned it with decreasing priority levels until
-		 * nr_to_reclaim had been reclaimed.  This priority
-		 * cycle is thus over after a single memcg.
-		 *
-		 * Direct reclaim and kswapd, on the other hand, have
-		 * to scan all memory cgroups to fulfill the overall
-		 * scan target for the zone.
-		 */
-		if (!global_reclaim(sc)) {
-			mem_cgroup_iter_break(root, memcg);
-			break;
-		}
-		memcg = mem_cgroup_iter(root, memcg, &reclaim);
-	} while (memcg);
+			/*
+			 * Limit reclaim has historically picked one
+			 * memcg and scanned it with decreasing
+			 * priority levels until nr_to_reclaim had
+			 * been reclaimed.  This priority cycle is
+			 * thus over after a single memcg.
+			 *
+			 * Direct reclaim and kswapd, on the other
+			 * hand, have to scan all memory cgroups to
+			 * fulfill the overall scan target for the
+			 * zone.
+			 */
+			if (!global_reclaim(sc)) {
+				mem_cgroup_iter_break(root, memcg);
+				break;
+			}
+			memcg = mem_cgroup_iter(root, memcg, &reclaim);
+		} while (memcg);
+	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
+					 sc->nr_scanned - nr_scanned, sc));
 }
 
 /* Returns true if compaction should go ahead for a high-order request */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

