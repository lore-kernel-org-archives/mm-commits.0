From: akpm@linux-foundation.org
Subject: +
 mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
 added to -mm tree
Date: Thu, 15 Jan 2015 15:52:00 -0800
Message-ID: <54b852a0.B0qCROh7TcsSDhQw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbAOXwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 18:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: enhance tracepoint output for compaction begin/end
has been added to the -mm tree.  Its filename is
     mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch

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
Subject: mm/compaction: enhance tracepoint output for compaction begin/end

We now have tracepoint for begin event of compaction and it prints start
position of both scanners, but, tracepoint for end event of compaction
doesn't print finish position of both scanners.  It'd be also useful to
know finish position of both scanners so this patch add it.  It will help
to find odd behavior or problem on compaction internal logic.

And mode is added to both begin/end tracepoint output, since according to
mode, compaction behavior is quite different.

And lastly, status format is changed to string rather than status number
for readability.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |    2 +
 include/trace/events/compaction.h |   49 ++++++++++++++++++++--------
 mm/compaction.c                   |   14 ++++++--
 3 files changed, 49 insertions(+), 16 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end
+++ a/include/linux/compaction.h
@@ -12,6 +12,7 @@
 #define COMPACT_PARTIAL		3
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	4
+/* When adding new state, please change compaction_status_string, too */
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
 /* No contention detected */
@@ -24,6 +25,7 @@
 struct alloc_context; /* in mm/internal.h */
 
 #ifdef CONFIG_COMPACTION
+extern char *compaction_status_string[];
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
diff -puN include/trace/events/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end
+++ a/include/trace/events/compaction.h
@@ -85,46 +85,67 @@ TRACE_EVENT(mm_compaction_migratepages,
 );
 
 TRACE_EVENT(mm_compaction_begin,
-	TP_PROTO(unsigned long zone_start, unsigned long migrate_start,
-		unsigned long free_start, unsigned long zone_end),
+	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
+		unsigned long free_pfn, unsigned long zone_end, bool sync),
 
-	TP_ARGS(zone_start, migrate_start, free_start, zone_end),
+	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, zone_start)
-		__field(unsigned long, migrate_start)
-		__field(unsigned long, free_start)
+		__field(unsigned long, migrate_pfn)
+		__field(unsigned long, free_pfn)
 		__field(unsigned long, zone_end)
+		__field(bool, sync)
 	),
 
 	TP_fast_assign(
 		__entry->zone_start = zone_start;
-		__entry->migrate_start = migrate_start;
-		__entry->free_start = free_start;
+		__entry->migrate_pfn = migrate_pfn;
+		__entry->free_pfn = free_pfn;
 		__entry->zone_end = zone_end;
+		__entry->sync = sync;
 	),
 
-	TP_printk("zone_start=0x%lx migrate_start=0x%lx free_start=0x%lx zone_end=0x%lx",
+	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s",
 		__entry->zone_start,
-		__entry->migrate_start,
-		__entry->free_start,
-		__entry->zone_end)
+		__entry->migrate_pfn,
+		__entry->free_pfn,
+		__entry->zone_end,
+		__entry->sync ? "sync" : "async")
 );
 
 TRACE_EVENT(mm_compaction_end,
-	TP_PROTO(int status),
+	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
+		unsigned long free_pfn, unsigned long zone_end, bool sync,
+		int status),
 
-	TP_ARGS(status),
+	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync, status),
 
 	TP_STRUCT__entry(
+		__field(unsigned long, zone_start)
+		__field(unsigned long, migrate_pfn)
+		__field(unsigned long, free_pfn)
+		__field(unsigned long, zone_end)
+		__field(bool, sync)
 		__field(int, status)
 	),
 
 	TP_fast_assign(
+		__entry->zone_start = zone_start;
+		__entry->migrate_pfn = migrate_pfn;
+		__entry->free_pfn = free_pfn;
+		__entry->zone_end = zone_end;
+		__entry->sync = sync;
 		__entry->status = status;
 	),
 
-	TP_printk("status=%d", __entry->status)
+	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s status=%s",
+		__entry->zone_start,
+		__entry->migrate_pfn,
+		__entry->free_pfn,
+		__entry->zone_end,
+		__entry->sync ? "sync" : "async",
+		compaction_status_string[__entry->status])
 );
 
 #endif /* _TRACE_COMPACTION_H */
diff -puN mm/compaction.c~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end mm/compaction.c
--- a/mm/compaction.c~mm-compaction-enhance-tracepoint-output-for-compaction-begin-end
+++ a/mm/compaction.c
@@ -19,6 +19,14 @@
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
+char *compaction_status_string[] = {
+	"deferred",
+	"skipped",
+	"continue",
+	"partial",
+	"complete",
+};
+
 static inline void count_compact_event(enum vm_event_item item)
 {
 	count_vm_event(item);
@@ -1197,7 +1205,8 @@ static int compact_zone(struct zone *zon
 		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
 	}
 
-	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
+	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn,
+				cc->free_pfn, end_pfn, sync);
 
 	migrate_prep_local();
 
@@ -1299,7 +1308,8 @@ out:
 			zone->compact_cached_free_pfn = free_pfn;
 	}
 
-	trace_mm_compaction_end(ret);
+	trace_mm_compaction_end(start_pfn, cc->migrate_pfn,
+				cc->free_pfn, end_pfn, sync, ret);
 
 	return ret;
 }
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

