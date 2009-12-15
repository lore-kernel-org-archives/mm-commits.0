From: akpm@linux-foundation.org
Subject: [folded] vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:00:08 -0800
Message-ID: <200912150100.nBF108II025816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757449AbZLOBAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:00:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1
has been removed from the -mm tree.  Its filename was
     vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1.patch

This patch was dropped because it was folded into vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1
From: Mel Gorman <mel@csn.ul.ie>

When checking if kswapd is sleeping prematurely, all populated zones are
checked instead of the zones the instance of kswapd is responsible for. 
The counters for kswapd going to sleep prematurely are also named poorly. 
This patch makes kswapd only check its own zones and renames the relevant
counters.

This is a fix to the patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
and is based on top of mmotm-2009-11-13-19-59.  It would be preferable if
Kosaki Motohiro signed off on it as he had comments on the patch but the
discussion petered out without a solid conclusion.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 mm/vmscan.c            |   20 +++++++++++++-------
 mm/vmstat.c            |    4 ++--
 3 files changed, 16 insertions(+), 10 deletions(-)

diff -puN include/linux/vmstat.h~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1 include/linux/vmstat.h
--- a/include/linux/vmstat.h~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1
+++ a/include/linux/vmstat.h
@@ -40,7 +40,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		KSWAPD_PREMATURE_FAST, KSWAPD_PREMATURE_SLOW,
+		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
 #ifdef CONFIG_HUGETLB_PAGE
diff -puN mm/vmscan.c~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1 mm/vmscan.c
--- a/mm/vmscan.c~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1
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
@@ -2221,7 +2227,7 @@ static int kswapd(void *p)
 				long remaining = 0;
 
 				/* Try to sleep for a short interval */
-				if (!sleeping_prematurely(order, remaining)) {
+				if (!sleeping_prematurely(pgdat, order, remaining)) {
 					remaining = schedule_timeout(HZ/10);
 					finish_wait(&pgdat->kswapd_wait, &wait);
 					prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
@@ -2232,13 +2238,13 @@ static int kswapd(void *p)
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
 
diff -puN mm/vmstat.c~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1 mm/vmstat.c
--- a/mm/vmstat.c~vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1
+++ a/mm/vmstat.c
@@ -683,8 +683,8 @@ static const char * const vmstat_text[] 
 	"slabs_scanned",
 	"kswapd_steal",
 	"kswapd_inodesteal",
-	"kswapd_slept_prematurely_fast",
-	"kswapd_slept_prematurely_slow",
+	"kswapd_low_wmark_hit_quickly",
+	"kswapd_high_wmark_hit_quickly",
 	"kswapd_skip_congestion_wait",
 	"pageoutrun",
 	"allocstall",
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
ksm-fix-mlockfreed-to-munlocked.patch
hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch
hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2.patch
hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

