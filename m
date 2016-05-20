From: akpm@linux-foundation.org
Subject: [patch 005/162] mm, compaction: change COMPACT_ constants into
 enum
Date: Fri, 20 May 2016 16:56:38 -0700
Message-ID: <573fa436.IxpeNfC8/UrZUNo1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETX4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com

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
Cc: Mel Gorman <mgorman@techsingularity.net>
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
@@ -1229,7 +1229,7 @@ static inline bool is_via_compact_memory
 	return order == -1;
 }
 
-static int __compact_finished(struct zone *zone, struct compact_control *cc,
+static enum compact_result __compact_finished(struct zone *zone, struct compact_control *cc,
 			    const int migratetype)
 {
 	unsigned int order;
@@ -1292,8 +1292,9 @@ static int __compact_finished(struct zon
 	return COMPACT_NO_SUITABLE_PAGE;
 }
 
-static int compact_finished(struct zone *zone, struct compact_control *cc,
-			    const int migratetype)
+static enum compact_result compact_finished(struct zone *zone,
+			struct compact_control *cc,
+			const int migratetype)
 {
 	int ret;
 
@@ -1312,7 +1313,7 @@ static int compact_finished(struct zone
  *   COMPACT_PARTIAL  - If the allocation would succeed without compaction
  *   COMPACT_CONTINUE - If compaction should run now
  */
-static unsigned long __compaction_suitable(struct zone *zone, int order,
+static enum compact_result __compaction_suitable(struct zone *zone, int order,
 					unsigned int alloc_flags,
 					int classzone_idx)
 {
@@ -1358,11 +1359,11 @@ static unsigned long __compaction_suitab
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
@@ -1372,9 +1373,9 @@ unsigned long compaction_suitable(struct
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
@@ -1530,11 +1531,11 @@ out:
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
@@ -1572,7 +1573,7 @@ int sysctl_extfrag_threshold = 500;
  *
  * This is the main entry point for direct page compaction.
  */
-unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
+enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, int *contended)
 {
@@ -1580,7 +1581,7 @@ unsigned long try_to_compact_pages(gfp_t
 	int may_perform_io = gfp_mask & __GFP_IO;
 	struct zoneref *z;
 	struct zone *zone;
-	int rc = COMPACT_DEFERRED;
+	enum compact_result rc = COMPACT_DEFERRED;
 	int all_zones_contended = COMPACT_CONTENDED_LOCK; /* init for &= op */
 
 	*contended = COMPACT_CONTENDED_NONE;
@@ -1594,7 +1595,7 @@ unsigned long try_to_compact_pages(gfp_t
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
@@ -3188,7 +3188,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		enum migrate_mode mode, int *contended_compaction,
 		bool *deferred_compaction)
 {
-	unsigned long compact_result;
+	enum compact_result compact_result;
 	struct page *page;
 
 	if (!order)
_
