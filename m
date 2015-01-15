From: akpm@linux-foundation.org
Subject: +
 mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch added to -mm tree
Date: Thu, 15 Jan 2015 15:52:02 -0800
Message-ID: <54b852a2.0yWH3w+N2N5RCO4y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbAOXwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 18:52:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: more trace to understand when/why compaction start/finish
has been added to the -mm tree.  Its filename is
     mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch

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
Subject: mm/compaction: more trace to understand when/why compaction start/finish

It is not well analyzed that when/why compaction start/finish or not. 
With these new tracepoints, we can know much more about start/finish
reason of compaction.  I can find following bug with these tracepoint.

http://www.spinics.net/lists/linux-mm/msg81582.html

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |    3 +
 include/trace/events/compaction.h |   74 ++++++++++++++++++++++++++++
 mm/compaction.c                   |   38 ++++++++++++--
 3 files changed, 111 insertions(+), 4 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish
+++ a/include/linux/compaction.h
@@ -12,6 +12,9 @@
 #define COMPACT_PARTIAL		3
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	4
+/* For more detailed tracepoint output */
+#define COMPACT_NO_SUITABLE_PAGE	5
+#define COMPACT_NOT_SUITABLE_ZONE	6
 /* When adding new state, please change compaction_status_string, too */
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
diff -puN include/trace/events/compaction.h~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish
+++ a/include/trace/events/compaction.h
@@ -164,6 +164,80 @@ TRACE_EVENT(mm_compaction_end,
 		compaction_status_string[__entry->status])
 );
 
+TRACE_EVENT(mm_compaction_try_to_compact_pages,
+
+	TP_PROTO(
+		int order,
+		gfp_t gfp_mask,
+		enum migrate_mode mode),
+
+	TP_ARGS(order, gfp_mask, mode),
+
+	TP_STRUCT__entry(
+		__field(int, order)
+		__field(gfp_t, gfp_mask)
+		__field(enum migrate_mode, mode)
+	),
+
+	TP_fast_assign(
+		__entry->order = order;
+		__entry->gfp_mask = gfp_mask;
+		__entry->mode = mode;
+	),
+
+	TP_printk("order=%d gfp_mask=0x%x mode=%d",
+		__entry->order,
+		__entry->gfp_mask,
+		(int)__entry->mode)
+);
+
+DECLARE_EVENT_CLASS(mm_compaction_suitable_template,
+
+	TP_PROTO(struct zone *zone,
+		int order,
+		int ret),
+
+	TP_ARGS(zone, order, ret),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(char *, name)
+		__field(int, order)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->nid = zone_to_nid(zone);
+		__entry->name = (char *)zone->name;
+		__entry->order = order;
+		__entry->ret = ret;
+	),
+
+	TP_printk("node=%d zone=%-8s order=%d ret=%s",
+		__entry->nid,
+		__entry->name,
+		__entry->order,
+		compaction_status_string[__entry->ret])
+);
+
+DEFINE_EVENT(mm_compaction_suitable_template, mm_compaction_finished,
+
+	TP_PROTO(struct zone *zone,
+		int order,
+		int ret),
+
+	TP_ARGS(zone, order, ret)
+);
+
+DEFINE_EVENT(mm_compaction_suitable_template, mm_compaction_suitable,
+
+	TP_PROTO(struct zone *zone,
+		int order,
+		int ret),
+
+	TP_ARGS(zone, order, ret)
+);
+
 #endif /* _TRACE_COMPACTION_H */
 
 /* This part must be outside protection */
diff -puN mm/compaction.c~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish mm/compaction.c
--- a/mm/compaction.c~mm-compaction-more-trace-to-understand-when-why-compaction-start-finish
+++ a/mm/compaction.c
@@ -25,6 +25,8 @@ char *compaction_status_string[] = {
 	"continue",
 	"partial",
 	"complete",
+	"no_suitable_page",
+	"not_suitable_zone",
 };
 
 static inline void count_compact_event(enum vm_event_item item)
@@ -1048,7 +1050,7 @@ static isolate_migrate_t isolate_migrate
 	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
 
-static int compact_finished(struct zone *zone, struct compact_control *cc,
+static int __compact_finished(struct zone *zone, struct compact_control *cc,
 			    const int migratetype)
 {
 	unsigned int order;
@@ -1103,7 +1105,20 @@ static int compact_finished(struct zone
 			return COMPACT_PARTIAL;
 	}
 
-	return COMPACT_CONTINUE;
+	return COMPACT_NO_SUITABLE_PAGE;
+}
+
+static int compact_finished(struct zone *zone, struct compact_control *cc,
+			    const int migratetype)
+{
+	int ret;
+
+	ret = __compact_finished(zone, cc, migratetype);
+	trace_mm_compaction_finished(zone, cc->order, ret);
+	if (ret == COMPACT_NO_SUITABLE_PAGE)
+		ret = COMPACT_CONTINUE;
+
+	return ret;
 }
 
 /*
@@ -1113,7 +1128,7 @@ static int compact_finished(struct zone
  *   COMPACT_PARTIAL  - If the allocation would succeed without compaction
  *   COMPACT_CONTINUE - If compaction should run now
  */
-unsigned long compaction_suitable(struct zone *zone, int order,
+static unsigned long __compaction_suitable(struct zone *zone, int order,
 					int alloc_flags, int classzone_idx)
 {
 	int fragindex;
@@ -1157,11 +1172,24 @@ unsigned long compaction_suitable(struct
 	 */
 	fragindex = fragmentation_index(zone, order);
 	if (fragindex >= 0 && fragindex <= sysctl_extfrag_threshold)
-		return COMPACT_SKIPPED;
+		return COMPACT_NOT_SUITABLE_ZONE;
 
 	return COMPACT_CONTINUE;
 }
 
+unsigned long compaction_suitable(struct zone *zone, int order,
+					int alloc_flags, int classzone_idx)
+{
+	unsigned long ret;
+
+	ret = __compaction_suitable(zone, order, alloc_flags, classzone_idx);
+	trace_mm_compaction_suitable(zone, order, ret);
+	if (ret == COMPACT_NOT_SUITABLE_ZONE)
+		ret = COMPACT_SKIPPED;
+
+	return ret;
+}
+
 static int compact_zone(struct zone *zone, struct compact_control *cc)
 {
 	int ret;
@@ -1375,6 +1403,8 @@ unsigned long try_to_compact_pages(gfp_t
 	if (!order || !may_enter_fs || !may_perform_io)
 		return COMPACT_SKIPPED;
 
+	trace_mm_compaction_try_to_compact_pages(order, gfp_mask, mode);
+
 	/* Compact each zone in the list */
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
 								ac->nodemask) {
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

