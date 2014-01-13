From: akpm@linux-foundation.org
Subject: + mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch added
 to -mm tree
Date: Mon, 13 Jan 2014 15:15:30 -0800
Message-ID: <52d47392.vBCzlHVcXIJPUq84%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaAMXPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 18:15:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@gmail.com, dchinner@redhat.com, vdavydov@parallels.com

Subject: + mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch added to -mm tree
To: vdavydov@parallels.com,dchinner@redhat.com,glommer@gmail.com,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 15:15:30 -0800


The patch titled
     Subject: mm: vmscan: move call to shrink_slab() to shrink_zones()
has been added to the -mm tree.  Its filename is
     mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: vmscan: move call to shrink_slab() to shrink_zones()

This reduces the indentation level of do_try_to_free_pages() and removes
extra loop over all eligible zones counting the number of on-LRU pages.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Glauber Costa <glommer@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   56 ++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-move-call-to-shrink_slab-to-shrink_zones mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-move-call-to-shrink_slab-to-shrink_zones
+++ a/mm/vmscan.c
@@ -2291,13 +2291,16 @@ static inline bool compaction_ready(stru
  * the caller that it should consider retrying the allocation instead of
  * further reclaim.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc,
+			 struct shrink_control *shrink)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
+	unsigned long lru_pages = 0;
 	bool aborted_reclaim = false;
+	struct reclaim_state *reclaim_state = current->reclaim_state;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2307,6 +2310,8 @@ static bool shrink_zones(struct zonelist
 	if (buffer_heads_over_limit)
 		sc->gfp_mask |= __GFP_HIGHMEM;
 
+	nodes_clear(shrink->nodes_to_scan);
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -2318,6 +2323,10 @@ static bool shrink_zones(struct zonelist
 		if (global_reclaim(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
+
+			lru_pages += zone_reclaimable_pages(zone);
+			node_set(zone_to_nid(zone), shrink->nodes_to_scan);
+
 			if (sc->priority != DEF_PRIORITY &&
 			    !zone_reclaimable(zone))
 				continue;	/* Let kswapd poll it */
@@ -2354,6 +2363,20 @@ static bool shrink_zones(struct zonelist
 		shrink_zone(zone, sc);
 	}
 
+	/*
+	 * Don't shrink slabs when reclaiming memory from over limit cgroups
+	 * but do shrink slab at least once when aborting reclaim for
+	 * compaction to avoid unevenly scanning file/anon LRU pages over slab
+	 * pages.
+	 */
+	if (global_reclaim(sc)) {
+		shrink_slab(shrink, sc->nr_scanned, lru_pages);
+		if (reclaim_state) {
+			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
+			reclaim_state->reclaimed_slab = 0;
+		}
+	}
+
 	return aborted_reclaim;
 }
 
@@ -2398,9 +2421,6 @@ static unsigned long do_try_to_free_page
 					struct shrink_control *shrink)
 {
 	unsigned long total_scanned = 0;
-	struct reclaim_state *reclaim_state = current->reclaim_state;
-	struct zoneref *z;
-	struct zone *zone;
 	unsigned long writeback_threshold;
 	bool aborted_reclaim;
 
@@ -2413,34 +2433,8 @@ static unsigned long do_try_to_free_page
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(zonelist, sc);
+		aborted_reclaim = shrink_zones(zonelist, sc, shrink);
 
-		/*
-		 * Don't shrink slabs when reclaiming memory from over limit
-		 * cgroups but do shrink slab at least once when aborting
-		 * reclaim for compaction to avoid unevenly scanning file/anon
-		 * LRU pages over slab pages.
-		 */
-		if (global_reclaim(sc)) {
-			unsigned long lru_pages = 0;
-
-			nodes_clear(shrink->nodes_to_scan);
-			for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					gfp_zone(sc->gfp_mask), sc->nodemask) {
-				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-					continue;
-
-				lru_pages += zone_reclaimable_pages(zone);
-				node_set(zone_to_nid(zone),
-					 shrink->nodes_to_scan);
-			}
-
-			shrink_slab(shrink, sc->nr_scanned, lru_pages);
-			if (reclaim_state) {
-				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-				reclaim_state->reclaimed_slab = 0;
-			}
-		}
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			goto out;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

fs-superc-fix-warn-on-alloc_super-fail-path.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
linux-next.patch

