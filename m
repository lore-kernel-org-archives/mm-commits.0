From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch removed from -mm tree
Date: Wed, 02 Jul 2014 12:26:59 -0700
Message-ID: <53b45d03.yLwQ5VwQxL4FAPcP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43978 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaGBT1A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 15:27:00 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so2684342obc.5
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 12:27:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagemap: avoid unnecessary overhead when tracepoints are deactivated
has been removed from the -mm tree.  Its filename was
     mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: pagemap: avoid unnecessary overhead when tracepoints are deactivated

IO performance since 3.0 has been a mixed bag.  In many respects we are
better and in some we are worse and one of those places is sequential read
throughput.  This is visible in a number of benchmarks but I looked at
tiobench the closest.  This is using ext3 on a mid-range desktop and the
series applied.

                                      3.16.0-rc2                 3.0.0            3.16.0-rc2
                                         vanilla               vanilla         fairzone-v4r5
Min    SeqRead-MB/sec-1         120.92 (  0.00%)      133.65 ( 10.53%)      140.68 ( 16.34%)
Min    SeqRead-MB/sec-2         100.25 (  0.00%)      121.74 ( 21.44%)      118.13 ( 17.84%)
Min    SeqRead-MB/sec-4          96.27 (  0.00%)      113.48 ( 17.88%)      109.84 ( 14.10%)
Min    SeqRead-MB/sec-8          83.55 (  0.00%)       97.87 ( 17.14%)       89.62 (  7.27%)
Min    SeqRead-MB/sec-16         66.77 (  0.00%)       82.59 ( 23.69%)       70.49 (  5.57%)

Overall system CPU usage is reduced

          3.16.0-rc2       3.0.0  3.16.0-rc2
             vanilla     vanilla fairzone-v4
User          390.13      251.45      396.13
System        404.41      295.13      389.61
Elapsed      5412.45     5072.42     5163.49

This series does not fully restore throughput performance to 3.0 levels
but it brings it close for lower thread counts.  Higher thread counts are
known to be worse than 3.0 due to CFQ changes but there is no appetite for
changing the defaults there.



This patch (of 4):

The LRU insertion and activate tracepoints take PFN as a parameter forcing
the overhead to the caller.  Move the overhead to the tracepoint
fast-assign method to ensure the cost is only incurred when the tracepoint
is active.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/pagemap.h |   16 +++++++---------
 mm/swap.c                      |    4 ++--
 2 files changed, 9 insertions(+), 11 deletions(-)

diff -puN include/trace/events/pagemap.h~mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated include/trace/events/pagemap.h
--- a/include/trace/events/pagemap.h~mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated
+++ a/include/trace/events/pagemap.h
@@ -28,12 +28,10 @@ TRACE_EVENT(mm_lru_insertion,
 
 	TP_PROTO(
 		struct page *page,
-		unsigned long pfn,
-		int lru,
-		unsigned long flags
+		int lru
 	),
 
-	TP_ARGS(page, pfn, lru, flags),
+	TP_ARGS(page, lru),
 
 	TP_STRUCT__entry(
 		__field(struct page *,	page	)
@@ -44,9 +42,9 @@ TRACE_EVENT(mm_lru_insertion,
 
 	TP_fast_assign(
 		__entry->page	= page;
-		__entry->pfn	= pfn;
+		__entry->pfn	= page_to_pfn(page);
 		__entry->lru	= lru;
-		__entry->flags	= flags;
+		__entry->flags	= trace_pagemap_flags(page);
 	),
 
 	/* Flag format is based on page-types.c formatting for pagemap */
@@ -64,9 +62,9 @@ TRACE_EVENT(mm_lru_insertion,
 
 TRACE_EVENT(mm_lru_activate,
 
-	TP_PROTO(struct page *page, unsigned long pfn),
+	TP_PROTO(struct page *page),
 
-	TP_ARGS(page, pfn),
+	TP_ARGS(page),
 
 	TP_STRUCT__entry(
 		__field(struct page *,	page	)
@@ -75,7 +73,7 @@ TRACE_EVENT(mm_lru_activate,
 
 	TP_fast_assign(
 		__entry->page	= page;
-		__entry->pfn	= pfn;
+		__entry->pfn	= page_to_pfn(page);
 	),
 
 	/* Flag format is based on page-types.c formatting for pagemap */
diff -puN mm/swap.c~mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated mm/swap.c
--- a/mm/swap.c~mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated
+++ a/mm/swap.c
@@ -502,7 +502,7 @@ static void __activate_page(struct page
 		SetPageActive(page);
 		lru += LRU_ACTIVE;
 		add_page_to_lru_list(page, lruvec, lru);
-		trace_mm_lru_activate(page, page_to_pfn(page));
+		trace_mm_lru_activate(page);
 
 		__count_vm_event(PGACTIVATE);
 		update_page_reclaim_stat(lruvec, file, 1);
@@ -1036,7 +1036,7 @@ static void __pagevec_lru_add_fn(struct
 	SetPageLRU(page);
 	add_page_to_lru_list(page, lruvec, lru);
 	update_page_reclaim_stat(lruvec, file, active);
-	trace_mm_lru_insertion(page, page_to_pfn(page), lru, trace_pagemap_flags(page));
+	trace_mm_lru_insertion(page, lru);
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
shmem-fix-init_page_accessed-use-to-stop-pagelru-bug.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
mem-hotplug-improve-zone_movable_is_highmem-logic.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-vmscan-do-not-reclaim-from-lower-zones-if-they-are-balanced.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

