From: akpm@linux-foundation.org
Subject: [patch 094/142] mm, vmscan: extract shrink_page_list reclaim
 counters into a struct
Date: Wed, 22 Feb 2017 15:44:27 -0800
Message-ID: <58ae225b.G+fqu02tQZocVEfA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49050 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933134AbdBVXo2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:44:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: extract shrink_page_list reclaim counters into a struct

shrink_page_list returns quite some counters back to its caller.  Extract
the existing 5 into struct reclaim_stat because this makes the code easier
to follow and also allows further counters to be returned.

While we are at it, make all of them unsigned rather than unsigned long as
we do not really need full 64b for them (we never scan more than
SWAP_CLUSTER_MAX pages at once).  This should reduce some stack space.

This patch shouldn't introduce any functional change.

Link: http://lkml.kernel.org/r/20170104101942.4860-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   61 ++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct
+++ a/mm/vmscan.c
@@ -912,6 +912,14 @@ static void page_check_dirty_writeback(s
 		mapping->a_ops->is_dirty_writeback(page, dirty, writeback);
 }
 
+struct reclaim_stat {
+	unsigned nr_dirty;
+	unsigned nr_unqueued_dirty;
+	unsigned nr_congested;
+	unsigned nr_writeback;
+	unsigned nr_immediate;
+};
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -919,22 +927,18 @@ static unsigned long shrink_page_list(st
 				      struct pglist_data *pgdat,
 				      struct scan_control *sc,
 				      enum ttu_flags ttu_flags,
-				      unsigned long *ret_nr_dirty,
-				      unsigned long *ret_nr_unqueued_dirty,
-				      unsigned long *ret_nr_congested,
-				      unsigned long *ret_nr_writeback,
-				      unsigned long *ret_nr_immediate,
+				      struct reclaim_stat *stat,
 				      bool force_reclaim)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
 	int pgactivate = 0;
-	unsigned long nr_unqueued_dirty = 0;
-	unsigned long nr_dirty = 0;
-	unsigned long nr_congested = 0;
-	unsigned long nr_reclaimed = 0;
-	unsigned long nr_writeback = 0;
-	unsigned long nr_immediate = 0;
+	unsigned nr_unqueued_dirty = 0;
+	unsigned nr_dirty = 0;
+	unsigned nr_congested = 0;
+	unsigned nr_reclaimed = 0;
+	unsigned nr_writeback = 0;
+	unsigned nr_immediate = 0;
 
 	cond_resched();
 
@@ -1276,11 +1280,13 @@ keep:
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
 
-	*ret_nr_dirty += nr_dirty;
-	*ret_nr_congested += nr_congested;
-	*ret_nr_unqueued_dirty += nr_unqueued_dirty;
-	*ret_nr_writeback += nr_writeback;
-	*ret_nr_immediate += nr_immediate;
+	if (stat) {
+		stat->nr_dirty = nr_dirty;
+		stat->nr_congested = nr_congested;
+		stat->nr_unqueued_dirty = nr_unqueued_dirty;
+		stat->nr_writeback = nr_writeback;
+		stat->nr_immediate = nr_immediate;
+	}
 	return nr_reclaimed;
 }
 
@@ -1292,7 +1298,7 @@ unsigned long reclaim_clean_pages_from_l
 		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 	};
-	unsigned long ret, dummy1, dummy2, dummy3, dummy4, dummy5;
+	unsigned long ret;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
 
@@ -1305,8 +1311,7 @@ unsigned long reclaim_clean_pages_from_l
 	}
 
 	ret = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
-			TTU_UNMAP|TTU_IGNORE_ACCESS,
-			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
+			TTU_UNMAP|TTU_IGNORE_ACCESS, NULL, true);
 	list_splice(&clean_pages, page_list);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -ret);
 	return ret;
@@ -1705,11 +1710,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_taken;
-	unsigned long nr_dirty = 0;
-	unsigned long nr_congested = 0;
-	unsigned long nr_unqueued_dirty = 0;
-	unsigned long nr_writeback = 0;
-	unsigned long nr_immediate = 0;
+	struct reclaim_stat stat = {};
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -1754,9 +1755,7 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 
 	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, TTU_UNMAP,
-				&nr_dirty, &nr_unqueued_dirty, &nr_congested,
-				&nr_writeback, &nr_immediate,
-				false);
+				&stat, false);
 
 	spin_lock_irq(&pgdat->lru_lock);
 
@@ -1790,7 +1789,7 @@ shrink_inactive_list(unsigned long nr_to
 	 * of pages under pages flagged for immediate reclaim and stall if any
 	 * are encountered in the nr_immediate check below.
 	 */
-	if (nr_writeback && nr_writeback == nr_taken)
+	if (stat.nr_writeback && stat.nr_writeback == nr_taken)
 		set_bit(PGDAT_WRITEBACK, &pgdat->flags);
 
 	/*
@@ -1802,7 +1801,7 @@ shrink_inactive_list(unsigned long nr_to
 		 * Tag a zone as congested if all the dirty pages scanned were
 		 * backed by a congested BDI and wait_iff_congested will stall.
 		 */
-		if (nr_dirty && nr_dirty == nr_congested)
+		if (stat.nr_dirty && stat.nr_dirty == stat.nr_congested)
 			set_bit(PGDAT_CONGESTED, &pgdat->flags);
 
 		/*
@@ -1811,7 +1810,7 @@ shrink_inactive_list(unsigned long nr_to
 		 * the pgdat PGDAT_DIRTY and kswapd will start writing pages from
 		 * reclaim context.
 		 */
-		if (nr_unqueued_dirty == nr_taken)
+		if (stat.nr_unqueued_dirty == nr_taken)
 			set_bit(PGDAT_DIRTY, &pgdat->flags);
 
 		/*
@@ -1820,7 +1819,7 @@ shrink_inactive_list(unsigned long nr_to
 		 * that pages are cycling through the LRU faster than
 		 * they are written so also forcibly stall.
 		 */
-		if (nr_immediate && current_may_throttle())
+		if (stat.nr_immediate && current_may_throttle())
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
_
