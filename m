From: akpm@linux-foundation.org
Subject: + mm-compaction-print-current-range-where-compaction-work.patch
 added to -mm tree
Date: Thu, 15 Jan 2015 15:52:01 -0800
Message-ID: <54b852a1.zLpez5B2wanZrqWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbAOXwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 18:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: print current range where compaction work
has been added to the -mm tree.  Its filename is
     mm-compaction-print-current-range-where-compaction-work.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-print-current-range-where-compaction-work.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-print-current-range-where-compaction-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: print current range where compaction work

It'd be useful to know current range where compaction work for detailed
analysis.  With it, we can know pageblock where we actually scan and
isolate, and, how much pages we try in that pageblock and can guess why it
doesn't become freepage with pageblock order roughly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   30 +++++++++++++++++++++-------
 mm/compaction.c                   |    9 +++++---
 2 files changed, 29 insertions(+), 10 deletions(-)

diff -puN include/trace/events/compaction.h~mm-compaction-print-current-range-where-compaction-work include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-print-current-range-where-compaction-work
+++ a/include/trace/events/compaction.h
@@ -11,39 +11,55 @@
 
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
 
-	TP_PROTO(unsigned long nr_scanned,
+	TP_PROTO(
+		unsigned long start_pfn,
+		unsigned long end_pfn,
+		unsigned long nr_scanned,
 		unsigned long nr_taken),
 
-	TP_ARGS(nr_scanned, nr_taken),
+	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken),
 
 	TP_STRUCT__entry(
+		__field(unsigned long, start_pfn)
+		__field(unsigned long, end_pfn)
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_taken)
 	),
 
 	TP_fast_assign(
+		__entry->start_pfn = start_pfn;
+		__entry->end_pfn = end_pfn;
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_taken = nr_taken;
 	),
 
-	TP_printk("nr_scanned=%lu nr_taken=%lu",
+	TP_printk("range=(0x%lx ~ 0x%lx) nr_scanned=%lu nr_taken=%lu",
+		__entry->start_pfn,
+		__entry->end_pfn,
 		__entry->nr_scanned,
 		__entry->nr_taken)
 );
 
 DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_migratepages,
 
-	TP_PROTO(unsigned long nr_scanned,
+	TP_PROTO(
+		unsigned long start_pfn,
+		unsigned long end_pfn,
+		unsigned long nr_scanned,
 		unsigned long nr_taken),
 
-	TP_ARGS(nr_scanned, nr_taken)
+	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken)
 );
 
 DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_freepages,
-	TP_PROTO(unsigned long nr_scanned,
+
+	TP_PROTO(
+		unsigned long start_pfn,
+		unsigned long end_pfn,
+		unsigned long nr_scanned,
 		unsigned long nr_taken),
 
-	TP_ARGS(nr_scanned, nr_taken)
+	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken)
 );
 
 TRACE_EVENT(mm_compaction_migratepages,
diff -puN mm/compaction.c~mm-compaction-print-current-range-where-compaction-work mm/compaction.c
--- a/mm/compaction.c~mm-compaction-print-current-range-where-compaction-work
+++ a/mm/compaction.c
@@ -429,11 +429,12 @@ isolate_fail:
 
 	}
 
+	trace_mm_compaction_isolate_freepages(*start_pfn, blockpfn,
+					nr_scanned, total_isolated);
+
 	/* Record how far we have got within the block */
 	*start_pfn = blockpfn;
 
-	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
-
 	/*
 	 * If strict isolation is requested by CMA then check that all the
 	 * pages requested were isolated. If there were any failures, 0 is
@@ -589,6 +590,7 @@ isolate_migratepages_block(struct compac
 	unsigned long flags = 0;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
+	unsigned long start_pfn = low_pfn;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -749,7 +751,8 @@ isolate_success:
 	if (low_pfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, nr_isolated, true);
 
-	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
+	trace_mm_compaction_isolate_migratepages(start_pfn, low_pfn,
+						nr_scanned, nr_isolated);
 
 	count_compact_events(COMPACTMIGRATE_SCANNED, nr_scanned);
 	if (nr_isolated)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmstatc-fix-cleanup-ifdefs.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

