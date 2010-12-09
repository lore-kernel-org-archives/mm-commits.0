From: akpm@linux-foundation.org
Subject: + mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch added to -mm tree
Date: Thu, 09 Dec 2010 14:24:36 -0800
Message-ID: <201012092224.oB9MOarn010617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab0LIWZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 17:25:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: vmscan: rename lumpy_mode to reclaim_mode fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmscan: rename lumpy_mode to reclaim_mode fix
From: Mel Gorman <mel@csn.ul.ie>

As suggested by Johannes, rename reclaim_mode to reclaim_mode_t.  This is
a fix to the mmotm patch
broken-out/mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix
+++ a/mm/vmscan.c
@@ -63,12 +63,12 @@
  * RECLAIM_MODE_COMPACTION: For high-order allocations, reclaim a number of
  *			order-0 pages and then compact the zone
  */
-typedef unsigned __bitwise__ reclaim_mode;
-#define RECLAIM_MODE_SINGLE		((__force reclaim_mode)0x01u)
-#define RECLAIM_MODE_ASYNC		((__force reclaim_mode)0x02u)
-#define RECLAIM_MODE_SYNC		((__force reclaim_mode)0x04u)
-#define RECLAIM_MODE_LUMPYRECLAIM	((__force reclaim_mode)0x08u)
-#define RECLAIM_MODE_COMPACTION		((__force reclaim_mode)0x10u)
+typedef unsigned __bitwise__ reclaim_mode_t;
+#define RECLAIM_MODE_SINGLE		((__force reclaim_mode_t)0x01u)
+#define RECLAIM_MODE_ASYNC		((__force reclaim_mode_t)0x02u)
+#define RECLAIM_MODE_SYNC		((__force reclaim_mode_t)0x04u)
+#define RECLAIM_MODE_LUMPYRECLAIM	((__force reclaim_mode_t)0x08u)
+#define RECLAIM_MODE_COMPACTION		((__force reclaim_mode_t)0x10u)
 
 struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
@@ -101,7 +101,7 @@ struct scan_control {
 	 * Intend to reclaim enough continuous memory rather than reclaim
 	 * enough amount of memory. i.e, mode for high order allocation.
 	 */
-	reclaim_mode reclaim_mode;
+	reclaim_mode_t reclaim_mode;
 
 	/* Which cgroup do we reclaim from */
 	struct mem_cgroup *mem_cgroup;
@@ -287,7 +287,7 @@ unsigned long shrink_slab(unsigned long 
 static void set_reclaim_mode(int priority, struct scan_control *sc,
 				   bool sync)
 {
-	reclaim_mode syncmode = sync ? RECLAIM_MODE_SYNC : RECLAIM_MODE_ASYNC;
+	reclaim_mode_t syncmode = sync ? RECLAIM_MODE_SYNC : RECLAIM_MODE_ASYNC;
 
 	/*
 	 * Initially assume we are entering either lumpy reclaim or
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-compactionc-avoid-double-mem_cgroup_del_lru.patch
mm-vmscan-tracepoint-account-for-scanned-pages-similarly-for-both-ftrace-and-vmstat.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
writeback-enabling-gate-for-light-dirtied-bdi.patch
writeback-enabling-gate-for-light-dirtied-bdi-fix.patch
writeback-safety-margin-for-bdi-stat-error.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
vmscan-make-kswapd-use-a-correct-order.patch
add-debugging-aid-for-memory-initialisation-problems.patch

