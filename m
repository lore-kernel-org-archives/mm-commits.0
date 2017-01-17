From: akpm@linux-foundation.org
Subject: + revert-mm-bail-out-in-shrink_inactive_list.patch added to -mm
 tree
Date: Tue, 17 Jan 2017 13:18:04 -0800
Message-ID: <587e8a0c.D/MV34NH9/N5OK+1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdAQVSK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 16:18:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: bail out in shrink_inactive_list()"
has been added to the -mm tree.  Its filename is
     revert-mm-bail-out-in-shrink_inactive_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-mm-bail-out-in-shrink_inactive_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-bail-out-in-shrink_inactive_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
-
 	while (unlikely(too_many_isolated(pgdat, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch

