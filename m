From: akpm@linux-foundation.org
Subject: [merged] revert-mm-bail-out-in-shrink_inactive_list.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:17:00 -0800
Message-ID: <58af514c.y0c7feF52V8g3h65%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdBWVRm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpchxg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: bail out in shrink_inactive_list()"
has been removed from the -mm tree.  Its filename was
     revert-mm-bail-out-in-shrink_inactive_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: Revert "mm: bail out in shrink_inactive_list()"

This reverts commit 91dcade47a3d0e7.

inactive_reclaimable_pages shouldn't be needed anymore since that
get_scan_count is aware of the eligble zones ("mm, vmscan: consider
eligible zones in get_scan_count").

Link: http://lkml.kernel.org/r/20170117103702.28542-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpchxg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

diff -puN mm/vmscan.c~revert-mm-bail-out-in-shrink_inactive_list mm/vmscan.c
--- a/mm/vmscan.c~revert-mm-bail-out-in-shrink_inactive_list
+++ a/mm/vmscan.c
@@ -1701,30 +1701,6 @@ static int current_may_throttle(void)
 		bdi_write_congested(current->backing_dev_info);
 }
 
-static bool inactive_reclaimable_pages(struct lruvec *lruvec,
-				struct scan_control *sc, enum lru_list lru)
-{
-	int zid;
-	struct zone *zone;
-	int file = is_file_lru(lru);
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-	if (!global_reclaim(sc))
-		return true;
-
-	for (zid = sc->reclaim_idx; zid >= 0; zid--) {
-		zone = &pgdat->node_zones[zid];
-		if (!managed_zone(zone))
-			continue;
-
-		if (zone_page_state_snapshot(zone, NR_ZONE_LRU_BASE +
-				LRU_FILE * file) >= SWAP_CLUSTER_MAX)
-			return true;
-	}
-
-	return false;
-}
-
 /*
  * shrink_inactive_list() is a helper for shrink_node().  It returns the number
  * of reclaimed pages
@@ -1743,9 +1719,6 @@ shrink_inactive_list(unsigned long nr_to
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
-	if (!inactive_reclaimable_pages(lruvec, sc, lru))
-		return 0;
