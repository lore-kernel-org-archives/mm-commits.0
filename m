From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
 added to -mm tree
Date: Thu, 05 Jan 2017 15:46:32 -0800
Message-ID: <586edad8.Rnh8MlrQl4mL1Eu6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162122AbdAEXpO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:45:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: extract shrink_page_list reclaim counters into a struct
has been added to the -mm tree.  Its filename is
     mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch

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
@@ -902,6 +902,14 @@ static void page_check_dirty_writeback(s
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
@@ -909,22 +917,18 @@ static unsigned long shrink_page_list(st
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
 
@@ -1266,11 +1270,13 @@ keep:
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
 
@@ -1282,7 +1288,7 @@ unsigned long reclaim_clean_pages_from_l
 		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 	};
-	unsigned long ret, dummy1, dummy2, dummy3, dummy4, dummy5;
+	unsigned long ret;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
 
@@ -1295,8 +1301,7 @@ unsigned long reclaim_clean_pages_from_l
 	}
 
 	ret = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
-			TTU_UNMAP|TTU_IGNORE_ACCESS,
-			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
+			TTU_UNMAP|TTU_IGNORE_ACCESS, NULL, true);
 	list_splice(&clean_pages, page_list);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -ret);
 	return ret;
@@ -1696,11 +1701,7 @@ shrink_inactive_list(unsigned long nr_to
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
@@ -1745,9 +1746,7 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 
 	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, TTU_UNMAP,
-				&nr_dirty, &nr_unqueued_dirty, &nr_congested,
-				&nr_writeback, &nr_immediate,
-				false);
+				&stat, false);
 
 	spin_lock_irq(&pgdat->lru_lock);
 
@@ -1781,7 +1780,7 @@ shrink_inactive_list(unsigned long nr_to
 	 * of pages under pages flagged for immediate reclaim and stall if any
 	 * are encountered in the nr_immediate check below.
 	 */
-	if (nr_writeback && nr_writeback == nr_taken)
+	if (stat.nr_writeback && stat.nr_writeback == nr_taken)
 		set_bit(PGDAT_WRITEBACK, &pgdat->flags);
 
 	/*
@@ -1793,7 +1792,7 @@ shrink_inactive_list(unsigned long nr_to
 		 * Tag a zone as congested if all the dirty pages scanned were
 		 * backed by a congested BDI and wait_iff_congested will stall.
 		 */
-		if (nr_dirty && nr_dirty == nr_congested)
+		if (stat.nr_dirty && stat.nr_dirty == stat.nr_congested)
 			set_bit(PGDAT_CONGESTED, &pgdat->flags);
 
 		/*
@@ -1802,7 +1801,7 @@ shrink_inactive_list(unsigned long nr_to
 		 * the pgdat PGDAT_DIRTY and kswapd will start writing pages from
 		 * reclaim context.
 		 */
-		if (nr_unqueued_dirty == nr_taken)
+		if (stat.nr_unqueued_dirty == nr_taken)
 			set_bit(PGDAT_DIRTY, &pgdat->flags);
 
 		/*
@@ -1811,7 +1810,7 @@ shrink_inactive_list(unsigned long nr_to
 		 * that pages are cycling through the LRU faster than
 		 * they are written so also forcibly stall.
 		 */
-		if (nr_immediate && current_may_throttle())
+		if (stat.nr_immediate && current_may_throttle())
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch
bpf-do-not-use-kmalloc_shift_max.patch
mm-fix-remote-numa-hits-statistics.patch
mm-get-rid-of-__gfp_other_node.patch
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

