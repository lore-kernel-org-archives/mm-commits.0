From: akpm@linux-foundation.org
Subject: [merged] thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:23 -0800
Message-ID: <201101142251.p0EMpDdU005484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab1ANWvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: use compaction in kswapd for GFP_ATOMIC order > 0
has been removed from the -mm tree.  Its filename was
     thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: use compaction in kswapd for GFP_ATOMIC order > 0
From: Andrea Arcangeli <aarcange@redhat.com>

This takes advantage of memory compaction to properly generate pages of
order > 0 if regular page reclaim fails and priority level becomes more
severe and we don't reach the proper watermarks.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   11 ++++++++---
 mm/compaction.c            |   31 ++++++++++++++++++++++++++-----
 mm/vmscan.c                |   30 ++++++++++++++++++++----------
 3 files changed, 54 insertions(+), 18 deletions(-)

diff -puN include/linux/compaction.h~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0 include/linux/compaction.h
--- a/include/linux/compaction.h~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0
+++ a/include/linux/compaction.h
@@ -11,6 +11,9 @@
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	3
 
+#define COMPACT_MODE_DIRECT_RECLAIM	0
+#define COMPACT_MODE_KSWAPD		1
+
 #ifdef CONFIG_COMPACTION
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
@@ -25,7 +28,8 @@ extern unsigned long try_to_compact_page
 			bool sync);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 extern unsigned long compact_zone_order(struct zone *zone, int order,
-						gfp_t gfp_mask, bool sync);
+					gfp_t gfp_mask, bool sync,
+					int compact_mode);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -70,9 +74,10 @@ static inline unsigned long compaction_s
 }
 
 static inline unsigned long compact_zone_order(struct zone *zone, int order,
-						gfp_t gfp_mask, bool sync)
+					       gfp_t gfp_mask, bool sync,
+					       int compact_mode)
 {
-	return 0;
+	return COMPACT_CONTINUE;
 }
 
 static inline void defer_compaction(struct zone *zone)
diff -puN mm/compaction.c~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0 mm/compaction.c
--- a/mm/compaction.c~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0
+++ a/mm/compaction.c
@@ -42,6 +42,8 @@ struct compact_control {
 	unsigned int order;		/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
+
+	int compact_mode;
 };
 
 static unsigned long release_freepages(struct list_head *freelist)
@@ -382,10 +384,10 @@ static void update_nr_listpages(struct c
 }
 
 static int compact_finished(struct zone *zone,
-						struct compact_control *cc)
+			    struct compact_control *cc)
 {
 	unsigned int order;
-	unsigned long watermark = low_wmark_pages(zone) + (1 << cc->order);
+	unsigned long watermark;
 
 	if (fatal_signal_pending(current))
 		return COMPACT_PARTIAL;
@@ -395,12 +397,27 @@ static int compact_finished(struct zone 
 		return COMPACT_COMPLETE;
 
 	/* Compaction run is not finished if the watermark is not met */
+	if (cc->compact_mode != COMPACT_MODE_KSWAPD)
+		watermark = low_wmark_pages(zone);
+	else
+		watermark = high_wmark_pages(zone);
+	watermark += (1 << cc->order);
+
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
 		return COMPACT_CONTINUE;
 
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
+	/*
+	 * Generating only one page of the right order is not enough
+	 * for kswapd, we must continue until we're above the high
+	 * watermark as a pool for high order GFP_ATOMIC allocations
+	 * too.
+	 */
+	if (cc->compact_mode == COMPACT_MODE_KSWAPD)
+		return COMPACT_CONTINUE;
+
 	/* Direct compactor: Is a suitable page free? */
 	for (order = cc->order; order < MAX_ORDER; order++) {
 		/* Job done if page is free of the right migratetype */
@@ -514,8 +531,9 @@ static int compact_zone(struct zone *zon
 }
 
 unsigned long compact_zone_order(struct zone *zone,
-						int order, gfp_t gfp_mask,
-						bool sync)
+				 int order, gfp_t gfp_mask,
+				 bool sync,
+				 int compact_mode)
 {
 	struct compact_control cc = {
 		.nr_freepages = 0,
@@ -524,6 +542,7 @@ unsigned long compact_zone_order(struct 
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.sync = sync,
+		.compact_mode = compact_mode,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -569,7 +588,8 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync);
+		status = compact_zone_order(zone, order, gfp_mask, sync,
+					    COMPACT_MODE_DIRECT_RECLAIM);
 		rc = max(status, rc);
 
 		/* If a normal allocation would succeed, stop compacting */
@@ -600,6 +620,7 @@ static int compact_node(int nid)
 			.nr_freepages = 0,
 			.nr_migratepages = 0,
 			.order = -1,
+			.compact_mode = COMPACT_MODE_DIRECT_RECLAIM,
 		};
 
 		zone = &pgdat->node_zones[zoneid];
diff -puN mm/vmscan.c~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0 mm/vmscan.c
--- a/mm/vmscan.c~thp-use-compaction-in-kswapd-for-gfp_atomic-order-0
+++ a/mm/vmscan.c
@@ -41,6 +41,7 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
+#include <linux/compaction.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -2382,6 +2383,7 @@ loop_again:
 		 * cause too much scanning of the lower zones.
 		 */
 		for (i = 0; i <= end_zone; i++) {
+			int compaction;
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
 
@@ -2411,9 +2413,26 @@ loop_again:
 						lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
+
+			compaction = 0;
+			if (order &&
+			    zone_watermark_ok(zone, 0,
+					       high_wmark_pages(zone),
+					      end_zone, 0) &&
+			    !zone_watermark_ok(zone, order,
+					       high_wmark_pages(zone),
+					       end_zone, 0)) {
+				compact_zone_order(zone,
+						   order,
+						   sc.gfp_mask, false,
+						   COMPACT_MODE_KSWAPD);
+				compaction = 1;
+			}
+
 			if (zone->all_unreclaimable)
 				continue;
-			if (nr_slab == 0 && !zone_reclaimable(zone))
+			if (!compaction && nr_slab == 0 &&
+			    !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*
 			 * If we've done a decent amount of scanning and
@@ -2424,15 +2443,6 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 
-			/*
-			 * Compact the zone for higher orders to reduce
-			 * latencies for higher-order allocations that
-			 * would ordinarily call try_to_compact_pages()
-			 */
-			if (sc.order > PAGE_ALLOC_COSTLY_ORDER)
-				compact_zone_order(zone, sc.order, sc.gfp_mask,
-							false);
