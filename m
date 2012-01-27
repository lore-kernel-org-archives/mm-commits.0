From: akpm@linux-foundation.org
Subject: + vmscan-only-defer-compaction-for-failed-order-and-higher.patch added to -mm tree
Date: Fri, 27 Jan 2012 15:38:16 -0800
Message-ID: <20120127233816.27058A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:60143 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2A0XiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 18:38:17 -0500
Received: by ggnk1 with SMTP id k1so227626ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 15:38:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: vmscan: only defer compaction for failed order and higher
has been added to the -mm tree.  Its filename is
     vmscan-only-defer-compaction-for-failed-order-and-higher.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: vmscan: only defer compaction for failed order and higher

Currently a failed order-9 (transparent hugepage) compaction can lead to
memory compaction being temporarily disabled for a memory zone.  Even if
we only need compaction for an order 2 allocation, eg.  for jumbo frames
networking.

The fix is relatively straightforward: keep track of the highest order at
which compaction is succeeding, and only defer compaction for orders at
which compaction is failing.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   14 ++++++++++----
 include/linux/mmzone.h     |    1 +
 mm/compaction.c            |   12 +++++++++++-
 mm/page_alloc.c            |    6 ++++--
 mm/vmscan.c                |    2 +-
 5 files changed, 27 insertions(+), 8 deletions(-)

diff -puN include/linux/compaction.h~vmscan-only-defer-compaction-for-failed-order-and-higher include/linux/compaction.h
--- a/include/linux/compaction.h~vmscan-only-defer-compaction-for-failed-order-and-higher
+++ a/include/linux/compaction.h
@@ -34,20 +34,26 @@ extern unsigned long compaction_suitable
  * allocation success. 1 << compact_defer_limit compactions are skipped up
  * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
  */
-static inline void defer_compaction(struct zone *zone)
+static inline void defer_compaction(struct zone *zone, int order)
 {
 	zone->compact_considered = 0;
 	zone->compact_defer_shift++;
 
+	if (order < zone->compact_order_failed)
+		zone->compact_order_failed = order;
+
 	if (zone->compact_defer_shift > COMPACT_MAX_DEFER_SHIFT)
 		zone->compact_defer_shift = COMPACT_MAX_DEFER_SHIFT;
 }
 
 /* Returns true if compaction should be skipped this time */
-static inline bool compaction_deferred(struct zone *zone)
+static inline bool compaction_deferred(struct zone *zone, int order)
 {
 	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
 
+	if (order < zone->compact_order_failed)
+		return false;
+
 	/* Avoid possible overflow */
 	if (++zone->compact_considered > defer_limit)
 		zone->compact_considered = defer_limit;
@@ -73,11 +79,11 @@ static inline unsigned long compaction_s
 	return COMPACT_SKIPPED;
 }
 
-static inline void defer_compaction(struct zone *zone)
+static inline void defer_compaction(struct zone *zone, int order)
 {
 }
 
-static inline bool compaction_deferred(struct zone *zone)
+static inline bool compaction_deferred(struct zone *zone, int order)
 {
 	return 1;
 }
diff -puN include/linux/mmzone.h~vmscan-only-defer-compaction-for-failed-order-and-higher include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-only-defer-compaction-for-failed-order-and-higher
+++ a/include/linux/mmzone.h
@@ -365,6 +365,7 @@ struct zone {
 	 */
 	unsigned int		compact_considered;
 	unsigned int		compact_defer_shift;
+	int			compact_order_failed;
 #endif
 
 	ZONE_PADDING(_pad1_)
diff -puN mm/compaction.c~vmscan-only-defer-compaction-for-failed-order-and-higher mm/compaction.c
--- a/mm/compaction.c~vmscan-only-defer-compaction-for-failed-order-and-higher
+++ a/mm/compaction.c
@@ -673,9 +673,19 @@ static int __compact_pgdat(pg_data_t *pg
 		INIT_LIST_HEAD(&cc->freepages);
 		INIT_LIST_HEAD(&cc->migratepages);
 
-		if (cc->order < 0 || !compaction_deferred(zone))
+		if (cc->order < 0 || !compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
 
+		if (cc->order > 0) {
+			int ok = zone_watermark_ok(zone, cc->order,
+						low_wmark_pages(zone), 0, 0);
+			if (ok && cc->order > zone->compact_order_failed)
+				zone->compact_order_failed = cc->order + 1;
+			/* Currently async compaction is never deferred. */
+			else if (!ok && cc->sync)
+				defer_compaction(zone, cc->order);
+		}
+
 		VM_BUG_ON(!list_empty(&cc->freepages));
 		VM_BUG_ON(!list_empty(&cc->migratepages));
 	}
diff -puN mm/page_alloc.c~vmscan-only-defer-compaction-for-failed-order-and-higher mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-only-defer-compaction-for-failed-order-and-higher
+++ a/mm/page_alloc.c
@@ -1990,7 +1990,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	if (!order)
 		return NULL;
 
-	if (compaction_deferred(preferred_zone)) {
+	if (compaction_deferred(preferred_zone, order)) {
 		*deferred_compaction = true;
 		return NULL;
 	}
@@ -2012,6 +2012,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		if (page) {
 			preferred_zone->compact_considered = 0;
 			preferred_zone->compact_defer_shift = 0;
+			if (order >= preferred_zone->compact_order_failed)
+				preferred_zone->compact_order_failed = order + 1;
 			count_vm_event(COMPACTSUCCESS);
 			return page;
 		}
@@ -2028,7 +2030,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		 * defer if the failure was a sync compaction failure.
 		 */
 		if (sync_migration)
-			defer_compaction(preferred_zone);
+			defer_compaction(preferred_zone, order);
 
 		cond_resched();
 	}
diff -puN mm/vmscan.c~vmscan-only-defer-compaction-for-failed-order-and-higher mm/vmscan.c
--- a/mm/vmscan.c~vmscan-only-defer-compaction-for-failed-order-and-higher
+++ a/mm/vmscan.c
@@ -2198,7 +2198,7 @@ static inline bool compaction_ready(stru
 	 * If compaction is deferred, reclaim up to a point where
 	 * compaction will have a chance of success when re-enabled
 	 */
-	if (compaction_deferred(zone))
+	if (compaction_deferred(zone, sc->order))
 		return watermark_ok;
 
 	/* If compaction is not ready to start, keep reclaiming */
_
Subject: Subject: vmscan: only defer compaction for failed order and higher

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-add-extra-free-kbytes-tunable.patch
mm-add-extra-free-kbytes-tunable-update.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch

