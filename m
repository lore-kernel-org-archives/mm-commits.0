From: akpm@linux-foundation.org
Subject: +
 mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch added to -mm tree
Date: Thu, 10 Jul 2014 15:55:20 -0700
Message-ID: <53bf19d8.jTUhbxzAlAox1PvH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:47859 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaGJWzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 18:55:21 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so72579oah.0
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 15:55:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagemap: avoid unnecessary overhead when tracepoints are deactivated
has been added to the -mm tree.  Its filename is
     mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: pagemap: avoid unnecessary overhead when tracepoints are deactivated

This was formerly the series "Improve sequential read throughput" which
noted some major differences in performance of tiobench since 3.0.  While
there are a number of factors, two that dominated were the introduction of
the fair zone allocation policy and changes to CFQ.

The behaviour of fair zone allocation policy makes more sense than
tiobench as a benchmark and CFQ defaults were not changed due to
insufficient benchmarking.

This series is what's left.  It's one functional fix to the fair zone
allocation policy when used on NUMA machines and a reduction of overhead
in general.  tiobench was used for the comparison despite its flaws as an
IO benchmark as in this case we are primarily interested in the overhead
of page allocator and page reclaim activity.

On UMA, it makes little difference to overhead

          3.16.0-rc3   3.16.0-rc3
             vanilla lowercost-v5
User          383.61      386.77
System        403.83      401.74
Elapsed      5411.50     5413.11

On a 4-socket NUMA machine it's a bit more noticable

          3.16.0-rc3   3.16.0-rc3
             vanilla lowercost-v5
User          746.94      802.00
System      65336.22    40852.33
Elapsed     27553.52    27368.46




This patch (of 6):

The LRU insertion and activate tracepoints take PFN as a parameter forcing
the overhead to the caller.  Move the overhead to the tracepoint
fast-assign method to ensure the cost is only incurred when the tracepoint
is active.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -1024,7 +1024,7 @@ static void __pagevec_lru_add_fn(struct
 	SetPageLRU(page);
 	add_page_to_lru_list(page, lruvec, lru);
 	update_page_reclaim_stat(lruvec, file, active);
-	trace_mm_lru_insertion(page, page_to_pfn(page), lru, trace_pagemap_flags(page));
+	trace_mm_lru_insertion(page, lru);
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

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
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
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

