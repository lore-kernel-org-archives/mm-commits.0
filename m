From: akpm@linux-foundation.org
Subject: + mm-vmscan-add-classzone-information-to-tracepoints.patch added
 to -mm tree
Date: Fri, 08 Jul 2016 13:34:09 -0700
Message-ID: <57800e41.bPa8T535RnH36pM9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbcGHUeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:34:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: add classzone information to tracepoints
has been added to the -mm tree.  Its filename is
     mm-vmscan-add-classzone-information-to-tracepoints.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-add-classzone-information-to-tracepoints.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-add-classzone-information-to-tracepoints.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -2888,7 +2888,8 @@ unsigned long try_to_free_pages(struct z
 
 	trace_mm_vmscan_direct_reclaim_begin(order,
 				sc.may_writepage,
-				gfp_mask);
+				gfp_mask,
+				sc.reclaim_idx);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -2919,7 +2920,8 @@ unsigned long mem_cgroup_shrink_node(str
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
 						      sc.may_writepage,
-						      sc.gfp_mask);
+						      sc.gfp_mask,
+						      sc.reclaim_idx);
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -2967,7 +2969,8 @@ unsigned long try_to_free_mem_cgroup_pag
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,
-					    sc.gfp_mask);
+					    sc.gfp_mask,
+					    sc.reclaim_idx);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -3384,7 +3387,8 @@ kswapd_try_sleep:
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

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
mm-meminit-remove-early_page_nid_uninitialised.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-mmzone-clarify-the-usage-of-zone-padding.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch

