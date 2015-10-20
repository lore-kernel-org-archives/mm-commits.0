From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab.patch removed from -mm tree
Date: Tue, 20 Oct 2015 15:33:16 -0700
Message-ID: <5626c12c.J6c0mbj6FKvItoij%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbJTWdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Oct 2015 18:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: count slab shrinking results after each shrink_slab()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: count slab shrinking results after each shrink_slab()

cb731d6c62bbc2f ("vmscan: per memory cgroup slab shrinkers") sought to
optimize accumulating slab reclaim results in sc->nr_reclaimed only once
per zone, but the memcg hierarchy walk itself uses sc->nr_reclaimed as an
exit condition.  This can lead to overreclaim.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab
+++ a/mm/vmscan.c
@@ -2410,11 +2410,18 @@ static bool shrink_zone(struct zone *zon
 			shrink_lruvec(lruvec, swappiness, sc, &lru_pages);
 			zone_lru_pages += lru_pages;
 
-			if (memcg && is_classzone)
+			if (memcg && is_classzone) {
 				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
 					    memcg, sc->nr_scanned - scanned,
 					    lru_pages);
 
+				if (reclaim_state) {
+					sc->nr_reclaimed +=
+						reclaim_state->reclaimed_slab;
+					reclaim_state->reclaimed_slab = 0;
+				}
+			}
+
 			/*
 			 * Direct reclaim and kswapd have to scan all memory
 			 * cgroups to fulfill the overall scan target for the
@@ -2436,14 +2443,16 @@ static bool shrink_zone(struct zone *zon
 		 * Shrink the slab caches in the same proportion that
 		 * the eligible LRU pages were scanned.
 		 */
-		if (global_reclaim(sc) && is_classzone)
+		if (global_reclaim(sc) && is_classzone) {
 			shrink_slab(sc->gfp_mask, zone_to_nid(zone), NULL,
 				    sc->nr_scanned - nr_scanned,
 				    zone_lru_pages);
 
-		if (reclaim_state) {
-			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-			reclaim_state->reclaimed_slab = 0;
+			if (reclaim_state) {
+				sc->nr_reclaimed +=
+					reclaim_state->reclaimed_slab;
+				reclaim_state->reclaimed_slab = 0;
+			}
 		}
 
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-unify-slab-and-other-kmem-pages-charging-fix.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

