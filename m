From: akpm@linux-foundation.org
Subject: [merged] vmscan-kswapd-carefully-call-compaction.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:43 -0700
Message-ID: <20120322201743.80364A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46778 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab2CVURo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:44 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so402092vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: kswapd carefully call compaction
has been removed from the -mm tree.  Its filename was
     vmscan-kswapd-carefully-call-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: vmscan: kswapd carefully call compaction

With CONFIG_COMPACTION enabled, kswapd does not try to free contiguous
free pages, even when it is woken for a higher order request.

This could be bad for eg.  jumbo frame network allocations, which are done
from interrupt context and cannot compact memory themselves.  Higher than
before allocation failure rates in the network receive path have been
observed in kernels with compaction enabled.

Teach kswapd to defragment the memory zones in a node, but only if
required and compaction is not deferred in a zone.

[akpm@linux-foundation.org: reduce scope of zones_need_compaction]
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    6 +++
 mm/compaction.c            |   53 +++++++++++++++++++++++------------
 mm/vmscan.c                |   10 ++++++
 3 files changed, 51 insertions(+), 18 deletions(-)

diff -puN include/linux/compaction.h~vmscan-kswapd-carefully-call-compaction include/linux/compaction.h
--- a/include/linux/compaction.h~vmscan-kswapd-carefully-call-compaction
+++ a/include/linux/compaction.h
@@ -23,6 +23,7 @@ extern int fragmentation_index(struct zo
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			bool sync);
+extern int compact_pgdat(pg_data_t *pgdat, int order);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 
 /* Do not skip compaction more than 64 times */
@@ -62,6 +63,11 @@ static inline unsigned long try_to_compa
 	return COMPACT_CONTINUE;
 }
 
+static inline int compact_pgdat(pg_data_t *pgdat, int order)
+{
+	return COMPACT_CONTINUE;
+}
+
 static inline unsigned long compaction_suitable(struct zone *zone, int order)
 {
 	return COMPACT_SKIPPED;
diff -puN mm/compaction.c~vmscan-kswapd-carefully-call-compaction mm/compaction.c
--- a/mm/compaction.c~vmscan-kswapd-carefully-call-compaction
+++ a/mm/compaction.c
@@ -675,44 +675,61 @@ unsigned long try_to_compact_pages(struc
 
 
 /* Compact all zones within a node */
-static int compact_node(int nid)
+static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 {
 	int zoneid;
-	pg_data_t *pgdat;
 	struct zone *zone;
 
-	if (nid < 0 || nid >= nr_node_ids || !node_online(nid))
-		return -EINVAL;
-	pgdat = NODE_DATA(nid);
-
 	/* Flush pending updates to the LRU lists */
 	lru_add_drain_all();
 
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
-		struct compact_control cc = {
-			.nr_freepages = 0,
-			.nr_migratepages = 0,
-			.order = -1,
-			.sync = true,
-		};
 
 		zone = &pgdat->node_zones[zoneid];
 		if (!populated_zone(zone))
 			continue;
 
-		cc.zone = zone;
-		INIT_LIST_HEAD(&cc.freepages);
-		INIT_LIST_HEAD(&cc.migratepages);
+		cc->nr_freepages = 0;
+		cc->nr_migratepages = 0;
+		cc->zone = zone;
+		INIT_LIST_HEAD(&cc->freepages);
+		INIT_LIST_HEAD(&cc->migratepages);
 
-		compact_zone(zone, &cc);
+		if (cc->order < 0 || !compaction_deferred(zone))
+			compact_zone(zone, cc);
 
-		VM_BUG_ON(!list_empty(&cc.freepages));
-		VM_BUG_ON(!list_empty(&cc.migratepages));
+		VM_BUG_ON(!list_empty(&cc->freepages));
+		VM_BUG_ON(!list_empty(&cc->migratepages));
 	}
 
 	return 0;
 }
 
+int compact_pgdat(pg_data_t *pgdat, int order)
+{
+	struct compact_control cc = {
+		.order = order,
+		.sync = false,
+	};
+
+	return __compact_pgdat(pgdat, &cc);
+}
+
+static int compact_node(int nid)
+{
+	pg_data_t *pgdat;
+	struct compact_control cc = {
+		.order = -1,
+		.sync = true,
+	};
+
+	if (nid < 0 || nid >= nr_node_ids || !node_online(nid))
+		return -EINVAL;
+	pgdat = NODE_DATA(nid);
+
+	return __compact_pgdat(pgdat, &cc);
+}
+
 /* Compact all nodes in the system */
 static int compact_nodes(void)
 {
diff -puN mm/vmscan.c~vmscan-kswapd-carefully-call-compaction mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kswapd-carefully-call-compaction
+++ a/mm/vmscan.c
@@ -2919,6 +2919,8 @@ out:
 	 * and it is potentially going to sleep here.
 	 */
 	if (order) {
+		int zones_need_compaction = 1;
+
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 
@@ -2939,9 +2941,17 @@ out:
 				goto loop_again;
 			}
 
+			/* Check if the memory needs to be defragmented. */
+			if (zone_watermark_ok(zone, order,
+				    low_wmark_pages(zone), *classzone_idx, 0))
+				zones_need_compaction = 0;
+
 			/* If balanced, clear the congested flag */
 			zone_clear_flag(zone, ZONE_CONGESTED);
 		}
+
+		if (zones_need_compaction)
+			compact_pgdat(pgdat, order);
 	}
 
 	/*
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-add-extra-free-kbytes-tunable.patch
mm-add-extra-free-kbytes-tunable-update.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

