From: akpm@linux-foundation.org
Subject: + vmscan-kswapd-carefully-call-compaction.patch added to -mm tree
Date: Fri, 27 Jan 2012 15:38:11 -0800
Message-ID: <20120127233812.13A5CA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:50748 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2A0XiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 18:38:13 -0500
Received: by yenr8 with SMTP id r8so216449yen.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 15:38:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: vmscan: kswapd carefully call compaction
has been added to the -mm tree.  Its filename is
     vmscan-kswapd-carefully-call-compaction.patch

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
Subject: vmscan: kswapd carefully call compaction

With CONFIG_COMPACTION enabled, kswapd does not try to free contiguous
free pages, even when it is woken for a higher order request.

This could be bad for eg.  jumbo frame network allocations, which are done
from interrupt context and cannot compact memory themselves.  Higher than
before allocation failure rates in the network receive path have been
observed in kernels with compaction enabled.

Teach kswapd to defragment the memory zones in a node, but only if
required and compaction is not deferred in a zone.

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
 mm/vmscan.c                |    9 +++++
 3 files changed, 50 insertions(+), 18 deletions(-)

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
@@ -653,44 +653,61 @@ unsigned long try_to_compact_pages(struc
 
 
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
@@ -2672,6 +2672,7 @@ static unsigned long balance_pgdat(pg_da
 	int priority;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
+	int zones_need_compaction = 1;
 	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_soft_reclaimed;
@@ -2939,9 +2940,17 @@ out:
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
Subject: Subject: vmscan: kswapd carefully call compaction

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

