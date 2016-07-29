From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-add-classzone-information-to-tracepoints.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:55:26 -0700
Message-ID: <579ba69e.eFvh7mhCAcPQOvLN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbcG2Sz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: add classzone information to tracepoints
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-classzone-information-to-tracepoints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: add classzone information to tracepoints

This is convenient when tracking down why the skip count is high because
it'll show what classzone kswapd woke up at and what zones are being
isolated.

Link: http://lkml.kernel.org/r/1467970510-21195-29-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   51 +++++++++++++++++++-------------
 mm/vmscan.c                   |   14 +++++---
 2 files changed, 40 insertions(+), 25 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-add-classzone-information-to-tracepoints include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-add-classzone-information-to-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -55,21 +55,23 @@ TRACE_EVENT(mm_vmscan_kswapd_sleep,
 
 TRACE_EVENT(mm_vmscan_kswapd_wake,
 
-	TP_PROTO(int nid, int order),
+	TP_PROTO(int nid, int zid, int order),
 
-	TP_ARGS(nid, order),
+	TP_ARGS(nid, zid, order),
 
 	TP_STRUCT__entry(
 		__field(	int,	nid	)
+		__field(	int,	zid	)
 		__field(	int,	order	)
 	),
 
 	TP_fast_assign(
 		__entry->nid	= nid;
+		__entry->zid    = zid;
 		__entry->order	= order;
 	),
 
-	TP_printk("nid=%d order=%d", __entry->nid, __entry->order)
+	TP_printk("nid=%d zid=%d order=%d", __entry->nid, __entry->zid, __entry->order)
 );
 
 TRACE_EVENT(mm_vmscan_wakeup_kswapd,
@@ -98,47 +100,50 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
+	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags, int classzone_idx),
 
-	TP_ARGS(order, may_writepage, gfp_flags),
+	TP_ARGS(order, may_writepage, gfp_flags, classzone_idx),
 
 	TP_STRUCT__entry(
 		__field(	int,	order		)
 		__field(	int,	may_writepage	)
 		__field(	gfp_t,	gfp_flags	)
+		__field(	int,	classzone_idx	)
 	),
 
 	TP_fast_assign(
 		__entry->order		= order;
 		__entry->may_writepage	= may_writepage;
 		__entry->gfp_flags	= gfp_flags;
+		__entry->classzone_idx	= classzone_idx;
 	),
 
-	TP_printk("order=%d may_writepage=%d gfp_flags=%s",
+	TP_printk("order=%d may_writepage=%d gfp_flags=%s classzone_idx=%d",
 		__entry->order,
 		__entry->may_writepage,
-		show_gfp_flags(__entry->gfp_flags))
+		show_gfp_flags(__entry->gfp_flags),
+		__entry->classzone_idx)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
 
-	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
+	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags, int classzone_idx),
 
-	TP_ARGS(order, may_writepage, gfp_flags)
+	TP_ARGS(order, may_writepage, gfp_flags, classzone_idx)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
+	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags, int classzone_idx),
 
-	TP_ARGS(order, may_writepage, gfp_flags)
+	TP_ARGS(order, may_writepage, gfp_flags, classzone_idx)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
 
-	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
+	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags, int classzone_idx),
 
-	TP_ARGS(order, may_writepage, gfp_flags)
+	TP_ARGS(order, may_writepage, gfp_flags, classzone_idx)
 );
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -266,16 +271,18 @@ TRACE_EVENT(mm_shrink_slab_end,
 
 DECLARE_EVENT_CLASS(mm_vmscan_lru_isolate_template,
 
-	TP_PROTO(int order,
+	TP_PROTO(int classzone_idx,
+		int order,
 		unsigned long nr_requested,
 		unsigned long nr_scanned,
 		unsigned long nr_taken,
 		isolate_mode_t isolate_mode,
 		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, isolate_mode, file),
+	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_taken, isolate_mode, file),
 
 	TP_STRUCT__entry(
+		__field(int, classzone_idx)
 		__field(int, order)
 		__field(unsigned long, nr_requested)
 		__field(unsigned long, nr_scanned)
@@ -285,6 +292,7 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 	),
 
 	TP_fast_assign(
+		__entry->classzone_idx = classzone_idx;
 		__entry->order = order;
 		__entry->nr_requested = nr_requested;
 		__entry->nr_scanned = nr_scanned;
@@ -293,8 +301,9 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 		__entry->file = file;
 	),
 
-	TP_printk("isolate_mode=%d order=%d nr_requested=%lu nr_scanned=%lu nr_taken=%lu file=%d",
+	TP_printk("isolate_mode=%d classzone=%d order=%d nr_requested=%lu nr_scanned=%lu nr_taken=%lu file=%d",
 		__entry->isolate_mode,
+		__entry->classzone_idx,
 		__entry->order,
 		__entry->nr_requested,
 		__entry->nr_scanned,
@@ -304,27 +313,29 @@ DECLARE_EVENT_CLASS(mm_vmscan_lru_isolat
 
 DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_lru_isolate,
 
-	TP_PROTO(int order,
+	TP_PROTO(int classzone_idx,
+		int order,
 		unsigned long nr_requested,
 		unsigned long nr_scanned,
 		unsigned long nr_taken,
 		isolate_mode_t isolate_mode,
 		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, isolate_mode, file)
+	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_taken, isolate_mode, file)
 
 );
 
 DEFINE_EVENT(mm_vmscan_lru_isolate_template, mm_vmscan_memcg_isolate,
 
-	TP_PROTO(int order,
+	TP_PROTO(int classzone_idx,
+		int order,
 		unsigned long nr_requested,
 		unsigned long nr_scanned,
 		unsigned long nr_taken,
 		isolate_mode_t isolate_mode,
 		int file),
 
-	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, isolate_mode, file)
+	TP_ARGS(classzone_idx, order, nr_requested, nr_scanned, nr_taken, isolate_mode, file)
 
 );
 
diff -puN mm/vmscan.c~mm-vmscan-add-classzone-information-to-tracepoints mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-add-classzone-information-to-tracepoints
+++ a/mm/vmscan.c
@@ -1439,7 +1439,7 @@ static unsigned long isolate_lru_pages(u
 	if (!list_empty(&pages_skipped))
 		list_splice(&pages_skipped, src);
 	*nr_scanned = scan;
-	trace_mm_vmscan_lru_isolate(sc->order, nr_to_scan, scan,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan, scan,
 				    nr_taken, mode, is_file_lru(lru));
 	for (scan = 0; scan < MAX_NR_ZONES; scan++) {
 		nr_pages = nr_zone_taken[scan];
@@ -2889,7 +2889,8 @@ unsigned long try_to_free_pages(struct z
 
 	trace_mm_vmscan_direct_reclaim_begin(order,
 				sc.may_writepage,
-				gfp_mask);
+				gfp_mask,
+				sc.reclaim_idx);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -2920,7 +2921,8 @@ unsigned long mem_cgroup_shrink_node(str
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
 						      sc.may_writepage,
-						      sc.gfp_mask);
+						      sc.gfp_mask,
+						      sc.reclaim_idx);
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -2968,7 +2970,8 @@ unsigned long try_to_free_mem_cgroup_pag
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,
-					    sc.gfp_mask);
+					    sc.gfp_mask,
+					    sc.reclaim_idx);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -3386,7 +3389,8 @@ kswapd_try_sleep:
 		 * but kcompactd is woken to compact for the original
 		 * request (alloc_order).
 		 */
-		trace_mm_vmscan_kswapd_wake(pgdat->node_id, alloc_order);
+		trace_mm_vmscan_kswapd_wake(pgdat->node_id, classzone_idx,
+						alloc_order);
 		reclaim_order = balance_pgdat(pgdat, alloc_order, classzone_idx);
 		if (reclaim_order < alloc_order)
 			goto kswapd_try_sleep;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


