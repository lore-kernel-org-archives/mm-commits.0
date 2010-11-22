From: akpm@linux-foundation.org
Subject: + mm-compaction-add-trace-events-for-memory-compaction-activity.patch added to -mm tree
Date: Mon, 22 Nov 2010 12:06:23 -0800
Message-ID: <201011222006.oAMK6NID006889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757379Ab0KVUHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 15:07:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, apw@shadowen.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: compaction: add trace events for memory compaction activity
has been added to the -mm tree.  Its filename is
     mm-compaction-add-trace-events-for-memory-compaction-activity.patch

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
Subject: mm: compaction: add trace events for memory compaction activity
From: Mel Gorman <mel@csn.ul.ie>

In preparation for a patches promoting the use of memory compaction over
lumpy reclaim, this patch adds trace points for memory compaction
activity.  Using them, we can monitor the scanning activity of the
migration and free page scanners as well as the number and success rates
of pages passed to page migration.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |   74 ++++++++++++++++++++++++++++
 mm/compaction.c                   |   14 ++++-
 2 files changed, 87 insertions(+), 1 deletion(-)

diff -puN /dev/null include/trace/events/compaction.h
--- /dev/null
+++ a/include/trace/events/compaction.h
@@ -0,0 +1,74 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM compaction
+
+#if !defined(_TRACE_COMPACTION_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_COMPACTION_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+#include "gfpflags.h"
+
+DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
+
+	TP_PROTO(unsigned long nr_scanned,
+		unsigned long nr_taken),
+
+	TP_ARGS(nr_scanned, nr_taken),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_taken)
+	),
+
+	TP_fast_assign(
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_taken = nr_taken;
+	),
+
+	TP_printk("nr_scanned=%lu nr_taken=%lu",
+		__entry->nr_scanned,
+		__entry->nr_taken)
+);
+
+DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_migratepages,
+
+	TP_PROTO(unsigned long nr_scanned,
+		unsigned long nr_taken),
+
+	TP_ARGS(nr_scanned, nr_taken)
+);
+
+DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_freepages,
+	TP_PROTO(unsigned long nr_scanned,
+		unsigned long nr_taken),
+
+	TP_ARGS(nr_scanned, nr_taken)
+);
+
+TRACE_EVENT(mm_compaction_migratepages,
+
+	TP_PROTO(unsigned long nr_migrated,
+		unsigned long nr_failed),
+
+	TP_ARGS(nr_migrated, nr_failed),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, nr_migrated)
+		__field(unsigned long, nr_failed)
+	),
+
+	TP_fast_assign(
+		__entry->nr_migrated = nr_migrated;
+		__entry->nr_failed = nr_failed;
+	),
+
+	TP_printk("nr_migrated=%lu nr_failed=%lu",
+		__entry->nr_migrated,
+		__entry->nr_failed)
+);
+
+
+#endif /* _TRACE_COMPACTION_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN mm/compaction.c~mm-compaction-add-trace-events-for-memory-compaction-activity mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-trace-events-for-memory-compaction-activity
+++ a/mm/compaction.c
@@ -16,6 +16,9 @@
 #include <linux/sysfs.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/compaction.h>
+
 /*
  * compact_control is used to track pages being migrated and the free pages
  * they are being migrated to during memory compaction. The free_pfn starts
@@ -60,7 +63,7 @@ static unsigned long isolate_freepages_b
 				struct list_head *freelist)
 {
 	unsigned long zone_end_pfn, end_pfn;
-	int total_isolated = 0;
+	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor;
 
 	/* Get the last PFN we should scan for free pages at */
@@ -81,6 +84,7 @@ static unsigned long isolate_freepages_b
 
 		if (!pfn_valid_within(blockpfn))
 			continue;
+		nr_scanned++;
 
 		if (!PageBuddy(page))
 			continue;
@@ -100,6 +104,7 @@ static unsigned long isolate_freepages_b
 		}
 	}
 
+	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
 	return total_isolated;
 }
 
@@ -234,6 +239,7 @@ static unsigned long isolate_migratepage
 					struct compact_control *cc)
 {
 	unsigned long low_pfn, end_pfn;
+	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 
 	/* Do not scan outside zone boundaries */
@@ -266,6 +272,7 @@ static unsigned long isolate_migratepage
 		struct page *page;
 		if (!pfn_valid_within(low_pfn))
 			continue;
+		nr_scanned++;
 
 		/* Get the page and skip if free */
 		page = pfn_to_page(low_pfn);
@@ -281,6 +288,7 @@ static unsigned long isolate_migratepage
 		list_add(&page->lru, migratelist);
 		mem_cgroup_del_lru(page);
 		cc->nr_migratepages++;
+		nr_isolated++;
 
 		/* Avoid isolating too much */
 		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
@@ -292,6 +300,8 @@ static unsigned long isolate_migratepage
 	spin_unlock_irq(&zone->lru_lock);
 	cc->migrate_pfn = low_pfn;
 
+	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
+
 	return cc->nr_migratepages;
 }
 
@@ -402,6 +412,8 @@ static int compact_zone(struct zone *zon
 		count_vm_events(COMPACTPAGES, nr_migrate - nr_remaining);
 		if (nr_remaining)
 			count_vm_events(COMPACTPAGEFAILED, nr_remaining);
+		trace_mm_compaction_migratepages(nr_migrate - nr_remaining,
+						nr_remaining);
 
 		/* Release LRU pages not migrated */
 		if (!list_empty(&cc->migratepages)) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-remove-call-to-find_vma-in-pagewalk-for-non-hugetlbfs.patch
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
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
add-debugging-aid-for-memory-initialisation-problems.patch

