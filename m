From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-introduce-direct-compaction-priority.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:57:40 -0700
Message-ID: <579ba724.EPHBLE+i+f3dUPTF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbcG2S5l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:57:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: introduce direct compaction priority
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-direct-compaction-priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: introduce direct compaction priority

In the context of direct compaction, for some types of allocations we
would like the compaction to either succeed or definitely fail while
trying as hard as possible.  Current async/sync_light migration mode is
insufficient, as there are heuristics such as caching scanner positions,
marking pageblocks as unsuitable or deferring compaction for a zone.  At
least the final compaction attempt should be able to override these
heuristics.

To communicate how hard compaction should try, we replace migration mode
with a new enum compact_priority and change the relevant function
signatures.  In compact_zone_order() where struct compact_control is
constructed, the priority is mapped to suitable control flags.  This patch
itself has no functional change, as the current priority levels are mapped
back to the same migration modes as before.  Expanding them will be done
next.

Note that !CONFIG_COMPACTION variant of try_to_compact_pages() is removed,
as the only caller exists under CONFIG_COMPACTION.

Link: http://lkml.kernel.org/r/20160721073614.24395-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |   22 +++++++++++++---------
 include/trace/events/compaction.h |   12 ++++++------
 mm/compaction.c                   |   13 +++++++------
 mm/page_alloc.c                   |   28 ++++++++++++++--------------
 4 files changed, 40 insertions(+), 35 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-introduce-direct-compaction-priority include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-introduce-direct-compaction-priority
+++ a/include/linux/compaction.h
@@ -1,6 +1,18 @@
 #ifndef _LINUX_COMPACTION_H
 #define _LINUX_COMPACTION_H
 
+/*
+ * Determines how hard direct compaction should try to succeed.
+ * Lower value means higher priority, analogically to reclaim priority.
+ */
+enum compact_priority {
+	COMPACT_PRIO_SYNC_LIGHT,
+	MIN_COMPACT_PRIORITY = COMPACT_PRIO_SYNC_LIGHT,
+	DEF_COMPACT_PRIORITY = COMPACT_PRIO_SYNC_LIGHT,
+	COMPACT_PRIO_ASYNC,
+	INIT_COMPACT_PRIORITY = COMPACT_PRIO_ASYNC
+};
+
 /* Return values for compact_zone() and try_to_compact_pages() */
 /* When adding new states, please adjust include/trace/events/compaction.h */
 enum compact_result {
@@ -66,7 +78,7 @@ extern int fragmentation_index(struct zo
 extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 			unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum migrate_mode mode, int *contended);
+		enum compact_priority prio, int *contended);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern enum compact_result compaction_suitable(struct zone *zone, int order,
@@ -151,14 +163,6 @@ extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
 
 #else
-static inline enum compact_result try_to_compact_pages(gfp_t gfp_mask,
-			unsigned int order, int alloc_flags,
-			const struct alloc_context *ac,
-			enum migrate_mode mode, int *contended)
-{
-	return COMPACT_CONTINUE;
-}
-
 static inline void compact_pgdat(pg_data_t *pgdat, int order)
 {
 }
diff -puN include/trace/events/compaction.h~mm-compaction-introduce-direct-compaction-priority include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-introduce-direct-compaction-priority
+++ a/include/trace/events/compaction.h
@@ -226,26 +226,26 @@ TRACE_EVENT(mm_compaction_try_to_compact
 	TP_PROTO(
 		int order,
 		gfp_t gfp_mask,
-		enum migrate_mode mode),
+		int prio),
 
-	TP_ARGS(order, gfp_mask, mode),
+	TP_ARGS(order, gfp_mask, prio),
 
 	TP_STRUCT__entry(
 		__field(int, order)
 		__field(gfp_t, gfp_mask)
-		__field(enum migrate_mode, mode)
+		__field(int, prio)
 	),
 
 	TP_fast_assign(
 		__entry->order = order;
 		__entry->gfp_mask = gfp_mask;
-		__entry->mode = mode;
+		__entry->prio = prio;
 	),
 
-	TP_printk("order=%d gfp_mask=0x%x mode=%d",
+	TP_printk("order=%d gfp_mask=0x%x priority=%d",
 		__entry->order,
 		__entry->gfp_mask,
-		(int)__entry->mode)
+		__entry->prio)
 );
 
 DECLARE_EVENT_CLASS(mm_compaction_suitable_template,
diff -puN mm/compaction.c~mm-compaction-introduce-direct-compaction-priority mm/compaction.c
--- a/mm/compaction.c~mm-compaction-introduce-direct-compaction-priority
+++ a/mm/compaction.c
@@ -1626,7 +1626,7 @@ out:
 }
 
 static enum compact_result compact_zone_order(struct zone *zone, int order,
-		gfp_t gfp_mask, enum migrate_mode mode, int *contended,
+		gfp_t gfp_mask, enum compact_priority prio, int *contended,
 		unsigned int alloc_flags, int classzone_idx)
 {
 	enum compact_result ret;
@@ -1636,7 +1636,8 @@ static enum compact_result compact_zone_
 		.order = order,
 		.gfp_mask = gfp_mask,
 		.zone = zone,
-		.mode = mode,
+		.mode = (prio == COMPACT_PRIO_ASYNC) ?
+					MIGRATE_ASYNC :	MIGRATE_SYNC_LIGHT,
 		.alloc_flags = alloc_flags,
 		.classzone_idx = classzone_idx,
 		.direct_compaction = true,
@@ -1669,7 +1670,7 @@ int sysctl_extfrag_threshold = 500;
  */
 enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum migrate_mode mode, int *contended)
+		enum compact_priority prio, int *contended)
 {
 	int may_enter_fs = gfp_mask & __GFP_FS;
 	int may_perform_io = gfp_mask & __GFP_IO;
@@ -1684,7 +1685,7 @@ enum compact_result try_to_compact_pages
 	if (!may_enter_fs || !may_perform_io)
 		return COMPACT_SKIPPED;
 
-	trace_mm_compaction_try_to_compact_pages(order, gfp_mask, mode);
+	trace_mm_compaction_try_to_compact_pages(order, gfp_mask, prio);
 
 	/* Compact each zone in the list */
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
@@ -1697,7 +1698,7 @@ enum compact_result try_to_compact_pages
 			continue;
 		}
 
-		status = compact_zone_order(zone, order, gfp_mask, mode,
+		status = compact_zone_order(zone, order, gfp_mask, prio,
 				&zone_contended, alloc_flags,
 				ac_classzone_idx(ac));
 		rc = max(status, rc);
@@ -1731,7 +1732,7 @@ enum compact_result try_to_compact_pages
 			goto break_loop;
 		}
 
-		if (mode != MIGRATE_ASYNC && (status == COMPACT_COMPLETE ||
+		if (prio != COMPACT_PRIO_ASYNC && (status == COMPACT_COMPLETE ||
 					status == COMPACT_PARTIAL_SKIPPED)) {
 			/*
 			 * We think that allocation won't succeed in this zone
diff -puN mm/page_alloc.c~mm-compaction-introduce-direct-compaction-priority mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-introduce-direct-compaction-priority
+++ a/mm/page_alloc.c
@@ -3096,7 +3096,7 @@ out:
 static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum migrate_mode mode, enum compact_result *compact_result)
+		enum compact_priority prio, enum compact_result *compact_result)
 {
 	struct page *page;
 	int contended_compaction;
@@ -3106,7 +3106,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	current->flags |= PF_MEMALLOC;
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-						mode, &contended_compaction);
+						prio, &contended_compaction);
 	current->flags &= ~PF_MEMALLOC;
 
 	if (*compact_result <= COMPACT_INACTIVE)
@@ -3160,7 +3160,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 static inline bool
 should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
-		     enum compact_result compact_result, enum migrate_mode *migrate_mode,
+		     enum compact_result compact_result,
+		     enum compact_priority *compact_priority,
 		     int compaction_retries)
 {
 	int max_retries = MAX_COMPACT_RETRIES;
@@ -3171,11 +3172,11 @@ should_compact_retry(struct alloc_contex
 	/*
 	 * compaction considers all the zone as desperately out of memory
 	 * so it doesn't really make much sense to retry except when the
-	 * failure could be caused by weak migration mode.
+	 * failure could be caused by insufficient priority
 	 */
 	if (compaction_failed(compact_result)) {
-		if (*migrate_mode == MIGRATE_ASYNC) {
-			*migrate_mode = MIGRATE_SYNC_LIGHT;
+		if (*compact_priority > MIN_COMPACT_PRIORITY) {
+			(*compact_priority)--;
 			return true;
 		}
 		return false;
@@ -3209,7 +3210,7 @@ should_compact_retry(struct alloc_contex
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum migrate_mode mode, enum compact_result *compact_result)
+		enum compact_priority prio, enum compact_result *compact_result)
 {
 	*compact_result = COMPACT_SKIPPED;
 	return NULL;
@@ -3218,7 +3219,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 static inline bool
 should_compact_retry(struct alloc_context *ac, unsigned int order, int alloc_flags,
 		     enum compact_result compact_result,
-		     enum migrate_mode *migrate_mode,
+		     enum compact_priority *compact_priority,
 		     int compaction_retries)
 {
 	struct zone *zone;
@@ -3473,7 +3474,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
-	enum migrate_mode migration_mode = MIGRATE_SYNC_LIGHT;
+	enum compact_priority compact_priority = DEF_COMPACT_PRIORITY;
 	enum compact_result compact_result;
 	int compaction_retries = 0;
 	int no_progress_loops = 0;
@@ -3525,7 +3526,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		!gfp_pfmemalloc_allowed(gfp_mask)) {
 		page = __alloc_pages_direct_compact(gfp_mask, order,
 						alloc_flags, ac,
-						MIGRATE_ASYNC,
+						INIT_COMPACT_PRIORITY,
 						&compact_result);
 		if (page)
 			goto got_pg;
@@ -3558,7 +3559,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 			 * sync compaction could be very expensive, so keep
 			 * using async compaction.
 			 */
-			migration_mode = MIGRATE_ASYNC;
+			compact_priority = INIT_COMPACT_PRIORITY;
 		}
 	}
 
@@ -3624,8 +3625,7 @@ retry:
 
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
-					migration_mode,
-					&compact_result);
+					compact_priority, &compact_result);
 	if (page)
 		goto got_pg;
 
@@ -3665,7 +3665,7 @@ retry:
 	 */
 	if (did_some_progress > 0 &&
 			should_compact_retry(ac, order, alloc_flags,
-				compact_result, &migration_mode,
+				compact_result, &compact_priority,
 				compaction_retries))
 		goto retry;
 
_

Patches currently in -mm which might be from vbabka@suse.cz are


