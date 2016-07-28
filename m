From: akpm@linux-foundation.org
Subject: [patch 063/101] mm: bail out in shrink_inactive_list()
Date: Thu, 28 Jul 2016 15:47:40 -0700
Message-ID: <579a8b8c.ueWP9JYcmq2s8qju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcG1Wrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, hannes@cmpxchg.org, mgorman@techsingularity.net

From: Minchan Kim <minchan@kernel.org>
Subject: mm: bail out in shrink_inactive_list()

With node-lru, if there are enough reclaimable pages in highmem
but nothing in lowmem, VM can try to shrink inactive list although
the requested zone is lowmem.

The problem is that if the inactive list is full of highmem pages then a
direct reclaimer searching for a lowmem page waste CPU scanning uselessly.
It just burns out CPU.  Even, many direct reclaimers are stalled by
too_many_isolated if lots of parallel reclaimer are going on although
there are no reclaimable memory in inactive list.

I tried the experiment 4 times in 32bit 2G 8 CPU KVM machine to get
elapsed time.

	hackbench 500 process 2

= Old =

1st: 289s 2nd: 310s 3rd: 112s 4th: 272s

= Now =

1st: 31s  2nd: 132s 3rd: 162s 4th: 50s.

[akpm@linux-foundation.org: fixes per Mel]
Link: http://lkml.kernel.org/r/1469433119-1543-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN mm/vmscan.c~mm-bail-out-in-shrin_inactive_list mm/vmscan.c
--- a/mm/vmscan.c~mm-bail-out-in-shrin_inactive_list
+++ a/mm/vmscan.c
@@ -1652,6 +1652,30 @@ static int current_may_throttle(void)
 		bdi_write_congested(current->backing_dev_info);
 }
 
+static bool inactive_reclaimable_pages(struct lruvec *lruvec,
+				struct scan_control *sc, enum lru_list lru)
+{
+	int zid;
+	struct zone *zone;
+	int file = is_file_lru(lru);
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	if (!global_reclaim(sc))
+		return true;
+
+	for (zid = sc->reclaim_idx; zid >= 0; zid--) {
+		zone = &pgdat->node_zones[zid];
+		if (!populated_zone(zone))
+			continue;
+
+		if (zone_page_state_snapshot(zone, NR_ZONE_LRU_BASE +
+				LRU_FILE * file) >= SWAP_CLUSTER_MAX)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * shrink_inactive_list() is a helper for shrink_node().  It returns the number
  * of reclaimed pages
@@ -1674,6 +1698,9 @@ shrink_inactive_list(unsigned long nr_to
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
+	if (!inactive_reclaimable_pages(lruvec, sc, lru))
+		return 0;
+
 	while (unlikely(too_many_isolated(pgdat, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
_
