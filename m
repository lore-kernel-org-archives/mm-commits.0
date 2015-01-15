From: akpm@linux-foundation.org
Subject: +
 mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch added to -mm tree
Date: Thu, 15 Jan 2015 15:52:03 -0800
Message-ID: <54b852a3.zd/zygCFrJ1rQNWH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbbAOXwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 18:52:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: add tracepoint to observe behaviour of compaction defer
has been added to the -mm tree.  Its filename is
     mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch

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
Subject: mm/compaction: add tracepoint to observe behaviour of compaction defer

compaction deferring logic is heavy hammer that block the way to the
compaction.  It doesn't consider overall system state, so it could prevent
user from doing compaction falsely.  In other words, even if system has
enough range of memory to compact, compaction would be skipped due to
compaction deferring logic.  This patch add new tracepoint to understand
work of deferring logic.  This will also help to check compaction success
and fail.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |   65 +------------------------
 include/trace/events/compaction.h |   54 +++++++++++++++++++++
 mm/compaction.c                   |   72 ++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 60 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer
+++ a/include/linux/compaction.h
@@ -45,66 +45,11 @@ extern void reset_isolation_suitable(pg_
 extern unsigned long compaction_suitable(struct zone *zone, int order,
 					int alloc_flags, int classzone_idx);
 
-/* Do not skip compaction more than 64 times */
-#define COMPACT_MAX_DEFER_SHIFT 6
-
-/*
- * Compaction is deferred when compaction fails to result in a page
- * allocation success. 1 << compact_defer_limit compactions are skipped up
- * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
- */
-static inline void defer_compaction(struct zone *zone, int order)
-{
-	zone->compact_considered = 0;
-	zone->compact_defer_shift++;
-
-	if (order < zone->compact_order_failed)
-		zone->compact_order_failed = order;
-
-	if (zone->compact_defer_shift > COMPACT_MAX_DEFER_SHIFT)
-		zone->compact_defer_shift = COMPACT_MAX_DEFER_SHIFT;
-}
-
-/* Returns true if compaction should be skipped this time */
-static inline bool compaction_deferred(struct zone *zone, int order)
-{
-	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
-
-	if (order < zone->compact_order_failed)
-		return false;
-
-	/* Avoid possible overflow */
-	if (++zone->compact_considered > defer_limit)
-		zone->compact_considered = defer_limit;
-
-	return zone->compact_considered < defer_limit;
-}
-
-/*
- * Update defer tracking counters after successful compaction of given order,
- * which means an allocation either succeeded (alloc_success == true) or is
- * expected to succeed.
- */
-static inline void compaction_defer_reset(struct zone *zone, int order,
-		bool alloc_success)
-{
-	if (alloc_success) {
-		zone->compact_considered = 0;
-		zone->compact_defer_shift = 0;
-	}
-	if (order >= zone->compact_order_failed)
-		zone->compact_order_failed = order + 1;
-}
-
-/* Returns true if restarting compaction after many failures */
-static inline bool compaction_restarting(struct zone *zone, int order)
-{
-	if (order < zone->compact_order_failed)
-		return false;
-
-	return zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT &&
-		zone->compact_considered >= 1UL << zone->compact_defer_shift;
-}
+extern void defer_compaction(struct zone *zone, int order);
+extern bool compaction_deferred(struct zone *zone, int order);
+extern void compaction_defer_reset(struct zone *zone, int order,
+				bool alloc_success);
+extern bool compaction_restarting(struct zone *zone, int order);
 
 #else
 static inline unsigned long try_to_compact_pages(gfp_t gfp_mask,
diff -puN include/trace/events/compaction.h~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer
+++ a/include/trace/events/compaction.h
@@ -238,6 +238,60 @@ DEFINE_EVENT(mm_compaction_suitable_temp
 	TP_ARGS(zone, order, ret)
 );
 
+DECLARE_EVENT_CLASS(mm_compaction_defer_template,
+
+	TP_PROTO(struct zone *zone, int order),
+
+	TP_ARGS(zone, order),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(char *, name)
+		__field(int, order)
+		__field(unsigned int, considered)
+		__field(unsigned int, defer_shift)
+		__field(int, order_failed)
+	),
+
+	TP_fast_assign(
+		__entry->nid = zone_to_nid(zone);
+		__entry->name = (char *)zone->name;
+		__entry->order = order;
+		__entry->considered = zone->compact_considered;
+		__entry->defer_shift = zone->compact_defer_shift;
+		__entry->order_failed = zone->compact_order_failed;
+	),
+
+	TP_printk("node=%d zone=%-8s order=%d order_failed=%d consider=%u limit=%lu",
+		__entry->nid,
+		__entry->name,
+		__entry->order,
+		__entry->order_failed,
+		__entry->considered,
+		1UL << __entry->defer_shift)
+);
+
+DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_deferred,
+
+	TP_PROTO(struct zone *zone, int order),
+
+	TP_ARGS(zone, order)
+);
+
+DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_defer_compaction,
+
+	TP_PROTO(struct zone *zone, int order),
+
+	TP_ARGS(zone, order)
+);
+
+DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_defer_reset,
+
+	TP_PROTO(struct zone *zone, int order),
+
+	TP_ARGS(zone, order)
+);
+
 #endif /* _TRACE_COMPACTION_H */
 
 /* This part must be outside protection */
diff -puN mm/compaction.c~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer
+++ a/mm/compaction.c
@@ -123,6 +123,77 @@ static struct page *pageblock_pfn_to_pag
 }
 
 #ifdef CONFIG_COMPACTION
+
+/* Do not skip compaction more than 64 times */
+#define COMPACT_MAX_DEFER_SHIFT 6
+
+/*
+ * Compaction is deferred when compaction fails to result in a page
+ * allocation success. 1 << compact_defer_limit compactions are skipped up
+ * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
+ */
+void defer_compaction(struct zone *zone, int order)
+{
+	zone->compact_considered = 0;
+	zone->compact_defer_shift++;
+
+	if (order < zone->compact_order_failed)
+		zone->compact_order_failed = order;
+
+	if (zone->compact_defer_shift > COMPACT_MAX_DEFER_SHIFT)
+		zone->compact_defer_shift = COMPACT_MAX_DEFER_SHIFT;
+
+	trace_mm_compaction_defer_compaction(zone, order);
+}
+
+/* Returns true if compaction should be skipped this time */
+bool compaction_deferred(struct zone *zone, int order)
+{
+	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
+
+	if (order < zone->compact_order_failed)
+		return false;
+
+	/* Avoid possible overflow */
+	if (++zone->compact_considered > defer_limit)
+		zone->compact_considered = defer_limit;
+
+	if (zone->compact_considered >= defer_limit)
+		return false;
+
+	trace_mm_compaction_deferred(zone, order);
+
+	return true;
+}
+
+/*
+ * Update defer tracking counters after successful compaction of given order,
+ * which means an allocation either succeeded (alloc_success == true) or is
+ * expected to succeed.
+ */
+void compaction_defer_reset(struct zone *zone, int order,
+		bool alloc_success)
+{
+	if (alloc_success) {
+		zone->compact_considered = 0;
+		zone->compact_defer_shift = 0;
+	}
+	if (order >= zone->compact_order_failed)
+		zone->compact_order_failed = order + 1;
+
+	trace_mm_compaction_defer_reset(zone, order);
+}
+
+/* Returns true if restarting compaction after many failures */
+bool compaction_restarting(struct zone *zone, int order)
+{
+	if (order < zone->compact_order_failed)
+		return false;
+
+	return zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT &&
+		zone->compact_considered >= 1UL << zone->compact_defer_shift;
+}
+
 /* Returns true if the pageblock should be scanned for pages to isolate. */
 static inline bool isolation_suitable(struct compact_control *cc,
 					struct page *page)
@@ -1434,6 +1505,7 @@ unsigned long try_to_compact_pages(gfp_t
 			 * succeeds in this zone.
 			 */
 			compaction_defer_reset(zone, order, false);
+
 			/*
 			 * It is possible that async compaction aborted due to
 			 * need_resched() and the watermarks were ok thanks to
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

