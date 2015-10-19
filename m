From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab.patch added
 to -mm tree
Date: Mon, 19 Oct 2015 14:10:15 -0700
Message-ID: <56255c37.nk74dy1HwvjG2d70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbJSVKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 17:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: count slab shrinking results after each shrink_slab()
has been added to the -mm tree.  Its filename is
     mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab.patch

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

mm-vmscan-count-slab-shrinking-results-after-each-shrink_slab.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

