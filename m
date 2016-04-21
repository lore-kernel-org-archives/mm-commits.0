From: akpm@linux-foundation.org
Subject: + mm-compaction-change-compact_-constants-into-enum.patch added
 to -mm tree
Date: Thu, 21 Apr 2016 15:49:58 -0700
Message-ID: <57195916.7A04QagBpK2rJXWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbcDUWuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:50:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: change COMPACT_ constants into enum
has been added to the -mm tree.  Its filename is
     mm-compaction-change-compact_-constants-into-enum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-change-compact_-constants-into-enum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-change-compact_-constants-into-enum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, compaction: change COMPACT_ constants into enum

Compaction code is doing weird dances between COMPACT_FOO -> int ->
unsigned long

But there doesn't seem to be any reason for that.  All functions which
return/use one of those constants are not expecting any other value so it
really makes sense to define an enum for them and make it clear that no
other values are expected.

This is a pure cleanup and shouldn't introduce any functional changes.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   45 +++++++++++++++++++++--------------
 mm/compaction.c            |   27 ++++++++++-----------
 mm/page_alloc.c            |    2 -
 3 files changed, 42 insertions(+), 32 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-change-compact_-constants-into-enum include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-change-compact_-constants-into-enum
+++ a/include/linux/compaction.h
@@ -2,21 +2,29 @@
 #define _LINUX_COMPACTION_H
 
 /* Return values for compact_zone() and try_to_compact_pages() */
-/* compaction didn't start as it was deferred due to past failures */
-#define COMPACT_DEFERRED	0
-/* compaction didn't start as it was not possible or direct reclaim was more suitable */
-#define COMPACT_SKIPPED		1
-/* compaction should continue to another pageblock */
-#define COMPACT_CONTINUE	2
-/* direct compaction partially compacted a zone and there are suitable pages */
-#define COMPACT_PARTIAL		3
-/* The full zone was compacted */
-#define COMPACT_COMPLETE	4
-/* For more detailed tracepoint output */
-#define COMPACT_NO_SUITABLE_PAGE	5
-#define COMPACT_NOT_SUITABLE_ZONE	6
-#define COMPACT_CONTENDED		7
 /* When adding new states, please adjust include/trace/events/compaction.h */
+enum compact_result {
+	/* compaction didn't start as it was deferred due to past failures */
+	COMPACT_DEFERRED,
+	/*
+	 * compaction didn't start as it was not possible or direct reclaim
+	 * was more suitable
+	 */
+	COMPACT_SKIPPED,
+	/* compaction should continue to another pageblock */
+	COMPACT_CONTINUE,
+	/*
+	 * direct compaction partially compacted a zone and there are suitable
+	 * pages
+	 */
+	COMPACT_PARTIAL,
+	/* The full zone was compacted */
+	COMPACT_COMPLETE,
+	/* For more detailed tracepoint output */
+	COMPACT_NO_SUITABLE_PAGE,
+	COMPACT_NOT_SUITABLE_ZONE,
+	COMPACT_CONTENDED,
+};
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
 /* No contention detected */
@@ -38,12 +46,13 @@ extern int sysctl_extfrag_handler(struct
 extern int sysctl_compact_unevictable_allowed;
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
-extern unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
+extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
+			unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, int *contended);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
-extern unsigned long compaction_suitable(struct zone *zone, int order,
+extern enum compact_result compaction_suitable(struct zone *zone, int order,
 		unsigned int alloc_flags, int classzone_idx);
 
 extern void defer_compaction(struct zone *zone, int order);
@@ -57,7 +66,7 @@ extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
 
 #else
-static inline unsigned long try_to_compact_pages(gfp_t gfp_mask,
+static inline enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 			unsigned int order, int alloc_flags,
 			const struct alloc_context *ac,
 			enum migrate_mode mode, int *contended)
@@ -73,7 +82,7 @@ static inline void reset_isolation_suita
 {
 }
 
-static inline unsigned long compaction_suitable(struct zone *zone, int order,
+static inline enum compact_result compaction_suitable(struct zone *zone, int order,
 					int alloc_flags, int classzone_idx)
 {
 	return COMPACT_SKIPPED;
diff -puN mm/compaction.c~mm-compaction-change-compact_-constants-into-enum mm/compaction.c
--- a/mm/compaction.c~mm-compaction-change-compact_-constants-into-enum
+++ a/mm/compaction.c
@@ -1276,7 +1276,7 @@ static inline bool is_via_compact_memory
 	return order == -1;
 }
 
-static int __compact_finished(struct zone *zone, struct compact_control *cc,
+static enum compact_result __compact_finished(struct zone *zone, struct compact_control *cc,
 			    const int migratetype)
 {
 	unsigned int order;
@@ -1339,8 +1339,9 @@ static int __compact_finished(struct zon
 	return COMPACT_NO_SUITABLE_PAGE;
 }
 
-static int compact_finished(struct zone *zone, struct compact_control *cc,
-			    const int migratetype)
+static enum compact_result compact_finished(struct zone *zone,
+			struct compact_control *cc,
+			const int migratetype)
 {
 	int ret;
 
@@ -1359,7 +1360,7 @@ static int compact_finished(struct zone
  *   COMPACT_PARTIAL  - If the allocation would succeed without compaction
  *   COMPACT_CONTINUE - If compaction should run now
  */
-static unsigned long __compaction_suitable(struct zone *zone, int order,
+static enum compact_result __compaction_suitable(struct zone *zone, int order,
 					unsigned int alloc_flags,
 					int classzone_idx)
 {
@@ -1405,11 +1406,11 @@ static unsigned long __compaction_suitab
 	return COMPACT_CONTINUE;
 }
 
-unsigned long compaction_suitable(struct zone *zone, int order,
+enum compact_result compaction_suitable(struct zone *zone, int order,
 					unsigned int alloc_flags,
 					int classzone_idx)
 {
-	unsigned long ret;
+	enum compact_result ret;
 
 	ret = __compaction_suitable(zone, order, alloc_flags, classzone_idx);
 	trace_mm_compaction_suitable(zone, order, ret);
@@ -1419,9 +1420,9 @@ unsigned long compaction_suitable(struct
 	return ret;
 }
 
-static int compact_zone(struct zone *zone, struct compact_control *cc)
+static enum compact_result compact_zone(struct zone *zone, struct compact_control *cc)
 {
-	int ret;
+	enum compact_result ret;
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
 	const int migratetype = gfpflags_to_migratetype(cc->gfp_mask);
@@ -1585,11 +1586,11 @@ out:
 	return ret;
 }
 
-static unsigned long compact_zone_order(struct zone *zone, int order,
+static enum compact_result compact_zone_order(struct zone *zone, int order,
 		gfp_t gfp_mask, enum migrate_mode mode, int *contended,
 		unsigned int alloc_flags, int classzone_idx)
 {
-	unsigned long ret;
+	enum compact_result ret;
 	struct compact_control cc = {
 		.nr_freepages = 0,
 		.nr_migratepages = 0,
@@ -1628,7 +1629,7 @@ int sysctl_extfrag_threshold = 500;
  *
  * This is the main entry point for direct page compaction.
  */
-unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
+enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, int *contended)
 {
@@ -1636,7 +1637,7 @@ unsigned long try_to_compact_pages(gfp_t
 	int may_perform_io = gfp_mask & __GFP_IO;
 	struct zoneref *z;
 	struct zone *zone;
-	int rc = COMPACT_DEFERRED;
+	enum compact_result rc = COMPACT_DEFERRED;
 	int all_zones_contended = COMPACT_CONTENDED_LOCK; /* init for &= op */
 
 	*contended = COMPACT_CONTENDED_NONE;
@@ -1650,7 +1651,7 @@ unsigned long try_to_compact_pages(gfp_t
 	/* Compact each zone in the list */
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
 								ac->nodemask) {
-		int status;
+		enum compact_result status;
 		int zone_contended;
 
 		if (compaction_deferred(zone, order))
diff -puN mm/page_alloc.c~mm-compaction-change-compact_-constants-into-enum mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-change-compact_-constants-into-enum
+++ a/mm/page_alloc.c
@@ -3226,7 +3226,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		enum migrate_mode mode, int *contended_compaction,
 		bool *deferred_compaction)
 {
-	unsigned long compact_result;
+	enum compact_result compact_result;
 	struct page *page;
 
 	if (!order)
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch
vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-use-compaction-feedback-for-thp-backoff-conditions.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch

