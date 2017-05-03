From: akpm@linux-foundation.org
Subject: [patch 012/102] mm: don't avoid high-priority reclaim on
 unreclaimable nodes
Date: Wed, 03 May 2017 14:52:03 -0700
Message-ID: <20170503215203.qJmBLXNpN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdECVwF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: don't avoid high-priority reclaim on unreclaimable nodes

246e87a93934 ("memcg: fix get_scan_count() for small targets") sought to
avoid high reclaim priorities for kswapd by forcing it to scan a minimum
amount of pages when lru_pages >> priority yielded nothing.

b95a2f2d486d ("mm: vmscan: convert global reclaim to per-memcg LRU
lists"), due to switching global reclaim to a round-robin scheme over all
cgroups, had to restrict this forceful behavior to unreclaimable zones in
order to prevent massive overreclaim with many cgroups.

The latter patch effectively neutered the behavior completely for all but
extreme memory pressure.  But in those situations we might as well drop
the reclaimers to lower priority levels.  Remove the check.

Link: http://lkml.kernel.org/r/20170228214007.5621-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN mm/vmscan.c~mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes
+++ a/mm/vmscan.c
@@ -2130,22 +2130,13 @@ static void get_scan_count(struct lruvec
 	int pass;
 
 	/*
-	 * If the zone or memcg is small, nr[l] can be 0.  This
-	 * results in no scanning on this priority and a potential
-	 * priority drop.  Global direct reclaim can go to the next
-	 * zone and tends to have no problems. Global kswapd is for
-	 * zone balancing and it needs to scan a minimum amount. When
+	 * If the zone or memcg is small, nr[l] can be 0. When
 	 * reclaiming for a memcg, a priority drop can cause high
-	 * latencies, so it's better to scan a minimum amount there as
-	 * well.
+	 * latencies, so it's better to scan a minimum amount. When a
+	 * cgroup has already been deleted, scrape out the remaining
+	 * cache forcefully to get rid of the lingering state.
 	 */
-	if (current_is_kswapd()) {
-		if (!pgdat_reclaimable(pgdat))
-			force_scan = true;
-		if (!mem_cgroup_online(memcg))
-			force_scan = true;
-	}
-	if (!global_reclaim(sc))
+	if (!global_reclaim(sc) || !mem_cgroup_online(memcg))
 		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
_
