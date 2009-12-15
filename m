From: akpm@linux-foundation.org
Subject: [merged] vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:16 -0800
Message-ID: <200912152152.nBFLqG50015182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761202AbZLOVx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: stop kswapd waiting on congestion when the min watermark is not being met
has been removed from the -mm tree.  Its filename was
     vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: stop kswapd waiting on congestion when the min watermark is not being met
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If reclaim fails to make sufficient progress, the priority is raised. 
Once the priority is higher, kswapd starts waiting on congestion. 
However, if the zone is below the min watermark then kswapd needs to
continue working without delay as there is a danger of an increased rate
of GFP_ATOMIC allocation failure.

This patch changes the conditions under which kswapd waits on congestion
by only going to sleep if the min watermarks are being met.

[mel@csn.ul.ie: add stats to track how relevant the logic is]
[mel@csn.ul.ie: make kswapd only check its own zones and rename the relevant counters]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 ++-
 mm/vmscan.c            |   38 +++++++++++++++++++++++++++++---------
 mm/vmstat.c            |    5 +++--
 3 files changed, 34 insertions(+), 12 deletions(-)

diff -puN include/linux/vmstat.h~vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2 include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2
+++ a/include/linux/vmstat.h
@@ -40,7 +40,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		KSWAPD_PREMATURE_FAST, KSWAPD_PREMATURE_SLOW,
+		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
+		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
diff -puN mm/vmscan.c~vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2
+++ a/mm/vmscan.c
@@ -1905,19 +1905,25 @@ unsigned long try_to_free_mem_cgroup_pag
 #endif
 
 /* is kswapd sleeping prematurely? */
-static int sleeping_prematurely(int order, long remaining)
+static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
 {
-	struct zone *zone;
+	int i;
 
 	/* If a direct reclaimer woke kswapd within HZ/10, it's premature */
 	if (remaining)
 		return 1;
 
 	/* If after HZ/10, a zone is below the high mark, it's premature */
-	for_each_populated_zone(zone)
+	for (i = 0; i < pgdat->nr_zones; i++) {
+		struct zone *zone = pgdat->node_zones + i;
+
+		if (!populated_zone(zone))
+			continue;
+
 		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
 								0, 0))
 			return 1;
+	}
 
 	return 0;
 }
@@ -1979,6 +1985,7 @@ loop_again:
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 		unsigned long lru_pages = 0;
+		int has_under_min_watermark_zone = 0;
 
 		/* The swap token gets in the way of swapout... */
 		if (!priority)
@@ -2085,6 +2092,15 @@ loop_again:
 			if (total_scanned > SWAP_CLUSTER_MAX * 2 &&
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
+
+			/*
+			 * We are still under min water mark. it mean we have
+			 * GFP_ATOMIC allocation failure risk. Hurry up!
+			 */
+			if (!zone_watermark_ok(zone, order, min_wmark_pages(zone),
+					      end_zone, 0))
+				has_under_min_watermark_zone = 1;
+
 		}
 		if (all_zones_ok)
 			break;		/* kswapd: all done */
@@ -2092,8 +2108,12 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
-			congestion_wait(BLK_RW_ASYNC, HZ/10);
+		if (total_scanned && (priority < DEF_PRIORITY - 2)) {
+			if (has_under_min_watermark_zone)
+				count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
+			else
+				congestion_wait(BLK_RW_ASYNC, HZ/10);
+		}
 
 		/*
 		 * We do this so kswapd doesn't build up large priorities for
@@ -2207,7 +2227,7 @@ static int kswapd(void *p)
 				long remaining = 0;
 
 				/* Try to sleep for a short interval */
-				if (!sleeping_prematurely(order, remaining)) {
+				if (!sleeping_prematurely(pgdat, order, remaining)) {
 					remaining = schedule_timeout(HZ/10);
 					finish_wait(&pgdat->kswapd_wait, &wait);
 					prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
@@ -2218,13 +2238,13 @@ static int kswapd(void *p)
 				 * premature sleep. If not, then go fully
 				 * to sleep until explicitly woken up
 				 */
-				if (!sleeping_prematurely(order, remaining))
+				if (!sleeping_prematurely(pgdat, order, remaining))
 					schedule();
 				else {
 					if (remaining)
-						count_vm_event(KSWAPD_PREMATURE_FAST);
+						count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
 					else
-						count_vm_event(KSWAPD_PREMATURE_SLOW);
+						count_vm_event(KSWAPD_HIGH_WMARK_HIT_QUICKLY);
 				}
 			}
 
diff -puN mm/vmstat.c~vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2 mm/vmstat.c
--- a/mm/vmstat.c~vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2
+++ a/mm/vmstat.c
@@ -683,8 +683,9 @@ static const char * const vmstat_text[] 
 	"slabs_scanned",
 	"kswapd_steal",
 	"kswapd_inodesteal",
-	"kswapd_slept_prematurely_fast",
-	"kswapd_slept_prematurely_slow",
+	"kswapd_low_wmark_hit_quickly",
+	"kswapd_high_wmark_hit_quickly",
+	"kswapd_skip_congestion_wait",
 	"pageoutrun",
 	"allocstall",
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-introduce-coredump-parameter-structure.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

