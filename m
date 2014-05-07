From: akpm@linux-foundation.org
Subject: + mm-compaction-embed-migration-mode-in-compact_control.patch
 added to -mm tree
Date: Wed, 07 May 2014 14:20:49 -0700
Message-ID: <536aa3b1.M9XJOKCTApz61/LZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaEGVUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:20:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, gthelen@google.com, rientjes@google.com

Subject: + mm-compaction-embed-migration-mode-in-compact_control.patch added to -mm tree
To: rientjes@google.com,gthelen@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:20:49 -0700


The patch titled
     Subject: mm, compaction: embed migration mode in compact_control
has been added to the -mm tree.  Its filename is
     mm-compaction-embed-migration-mode-in-compact_control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-embed-migration-mode-in-compact_control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-embed-migration-mode-in-compact_control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: embed migration mode in compact_control

We're going to want to manipulate the migration mode for compaction in the
page allocator, and currently compact_control's sync field is only a bool.

Currently, we only do MIGRATE_ASYNC or MIGRATE_SYNC_LIGHT compaction
depending on the value of this bool.  Convert the bool to enum
migrate_mode and pass the migration mode in directly.  Later, we'll want
to avoid MIGRATE_SYNC_LIGHT for thp allocations in the pagefault patch to
avoid unnecessary latency.

This also alters compaction triggered from sysfs, either for the entire
system or for a node, to force MIGRATE_SYNC.

Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 +--
 mm/compaction.c            |   36 +++++++++++++++++-----------------
 mm/internal.h              |    2 -
 mm/page_alloc.c            |   37 +++++++++++++++--------------------
 4 files changed, 38 insertions(+), 41 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-embed-migration-mode-in-compact_control include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-embed-migration-mode-in-compact_control
+++ a/include/linux/compaction.h
@@ -22,7 +22,7 @@ extern int sysctl_extfrag_handler(struct
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
-			bool sync, bool *contended);
+			enum migrate_mode mode, bool *contended);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
@@ -91,7 +91,7 @@ static inline bool compaction_restarting
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			bool sync, bool *contended)
+			enum migrate_mode mode, bool *contended)
 {
 	return COMPACT_CONTINUE;
 }
diff -puN mm/compaction.c~mm-compaction-embed-migration-mode-in-compact_control mm/compaction.c
--- a/mm/compaction.c~mm-compaction-embed-migration-mode-in-compact_control
+++ a/mm/compaction.c
@@ -161,7 +161,8 @@ static void update_pageblock_skip(struct
 			return;
 		if (pfn > zone->compact_cached_migrate_pfn[0])
 			zone->compact_cached_migrate_pfn[0] = pfn;
-		if (cc->sync && pfn > zone->compact_cached_migrate_pfn[1])
+		if (cc->mode != MIGRATE_ASYNC &&
+		    pfn > zone->compact_cached_migrate_pfn[1])
 			zone->compact_cached_migrate_pfn[1] = pfn;
 	} else {
 		if (cc->finished_update_free)
@@ -208,7 +209,7 @@ static bool compact_checklock_irqsave(sp
 		}
 
 		/* async aborts if taking too long or contended */
-		if (!cc->sync) {
+		if (cc->mode == MIGRATE_ASYNC) {
 			cc->contended = true;
 			return false;
 		}
@@ -470,7 +471,8 @@ isolate_migratepages_range(struct zone *
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 	bool set_unsuitable = true;
-	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
+	const isolate_mode_t mode = (cc->mode == MIGRATE_ASYNC ?
+					ISOLATE_ASYNC_MIGRATE : 0) |
 				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
 	/*
@@ -480,7 +482,7 @@ isolate_migratepages_range(struct zone *
 	 */
 	while (unlikely(too_many_isolated(zone))) {
 		/* async migration should just abort */
-		if (!cc->sync)
+		if (cc->mode == MIGRATE_ASYNC)
 			return 0;
 
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -545,7 +547,8 @@ isolate_migratepages_range(struct zone *
 			 * the minimum amount of work satisfies the allocation
 			 */
 			mt = get_pageblock_migratetype(page);
-			if (!cc->sync && !migrate_async_suitable(mt)) {
+			if (cc->mode == MIGRATE_ASYNC &&
+			    !migrate_async_suitable(mt)) {
 				set_unsuitable = false;
 				goto next_pageblock;
 			}
@@ -978,6 +981,7 @@ static int compact_zone(struct zone *zon
 	int ret;
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
+	const bool sync = cc->mode != MIGRATE_ASYNC;
 
 	ret = compaction_suitable(zone, cc->order);
 	switch (ret) {
@@ -1003,7 +1007,7 @@ static int compact_zone(struct zone *zon
 	 * information on where the scanners should start but check that it
 	 * is initialised by ensuring the values are within zone boundaries.
 	 */
-	cc->migrate_pfn = zone->compact_cached_migrate_pfn[cc->sync];
+	cc->migrate_pfn = zone->compact_cached_migrate_pfn[sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
 	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
 		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
@@ -1037,8 +1041,7 @@ static int compact_zone(struct zone *zon
 
 		nr_migrate = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
-				compaction_free, (unsigned long)cc,
-				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
+				compaction_free, (unsigned long)cc, cc->mode,
 				MR_COMPACTION);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
@@ -1071,9 +1074,8 @@ out:
 	return ret;
 }
 
-static unsigned long compact_zone_order(struct zone *zone,
-				 int order, gfp_t gfp_mask,
-				 bool sync, bool *contended)
+static unsigned long compact_zone_order(struct zone *zone, int order,
+		gfp_t gfp_mask, enum migrate_mode mode, bool *contended)
 {
 	unsigned long ret;
 	struct compact_control cc = {
@@ -1082,7 +1084,7 @@ static unsigned long compact_zone_order(
 		.order = order,
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
-		.sync = sync,
+		.mode = mode,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -1104,7 +1106,7 @@ int sysctl_extfrag_threshold = 500;
  * @order: The order of the current allocation
  * @gfp_mask: The GFP mask of the current allocation
  * @nodemask: The allowed nodes to allocate from
- * @sync: Whether migration is synchronous or not
+ * @mode: The migration mode for async, sync light, or sync migration
  * @contended: Return value that is true if compaction was aborted due to lock contention
  * @page: Optionally capture a free page of the requested order during compaction
  *
@@ -1112,7 +1114,7 @@ int sysctl_extfrag_threshold = 500;
  */
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			bool sync, bool *contended)
+			enum migrate_mode mode, bool *contended)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
@@ -1137,7 +1139,7 @@ unsigned long try_to_compact_pages(struc
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync,
+		status = compact_zone_order(zone, order, gfp_mask, mode,
 						contended);
 		rc = max(status, rc);
 
@@ -1187,7 +1189,7 @@ void compact_pgdat(pg_data_t *pgdat, int
 {
 	struct compact_control cc = {
 		.order = order,
-		.sync = false,
+		.mode = MIGRATE_ASYNC,
 	};
 
 	if (!order)
@@ -1200,7 +1202,7 @@ static void compact_node(int nid)
 {
 	struct compact_control cc = {
 		.order = -1,
-		.sync = true,
+		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 	};
 
diff -puN mm/internal.h~mm-compaction-embed-migration-mode-in-compact_control mm/internal.h
--- a/mm/internal.h~mm-compaction-embed-migration-mode-in-compact_control
+++ a/mm/internal.h
@@ -134,7 +134,7 @@ struct compact_control {
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
-	bool sync;			/* Synchronous migration */
+	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
 	bool finished_update_free;	/* True when the zone cached pfns are
 					 * no longer being updated
diff -puN mm/page_alloc.c~mm-compaction-embed-migration-mode-in-compact_control mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-embed-migration-mode-in-compact_control
+++ a/mm/page_alloc.c
@@ -2220,7 +2220,7 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, bool sync_migration,
+	int migratetype, enum migrate_mode mode,
 	bool *contended_compaction, bool *deferred_compaction,
 	unsigned long *did_some_progress)
 {
@@ -2234,7 +2234,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
-						nodemask, sync_migration,
+						nodemask, mode,
 						contended_compaction);
 	current->flags &= ~PF_MEMALLOC;
 
@@ -2267,7 +2267,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		 * As async compaction considers a subset of pageblocks, only
 		 * defer if the failure was a sync compaction failure.
 		 */
-		if (sync_migration)
+		if (mode != MIGRATE_ASYNC)
 			defer_compaction(preferred_zone, order);
 
 		cond_resched();
@@ -2280,9 +2280,8 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, bool sync_migration,
-	bool *contended_compaction, bool *deferred_compaction,
-	unsigned long *did_some_progress)
+	int migratetype, enum migrate_mode mode, bool *contended_compaction,
+	bool *deferred_compaction, unsigned long *did_some_progress)
 {
 	return NULL;
 }
@@ -2477,7 +2476,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	int alloc_flags;
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
-	bool sync_migration = false;
+	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	bool deferred_compaction = false;
 	bool contended_compaction = false;
 
@@ -2571,17 +2570,15 @@ rebalance:
 	 * Try direct compaction. The first pass is asynchronous. Subsequent
 	 * attempts after direct reclaim are synchronous
 	 */
-	page = __alloc_pages_direct_compact(gfp_mask, order,
-					zonelist, high_zoneidx,
-					nodemask,
-					alloc_flags, preferred_zone,
-					migratetype, sync_migration,
-					&contended_compaction,
+	page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
+					high_zoneidx, nodemask, alloc_flags,
+					preferred_zone, migratetype,
+					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
 	if (page)
 		goto got_pg;
-	sync_migration = true;
+	migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/*
 	 * If compaction is deferred for high-order allocations, it is because
@@ -2656,12 +2653,10 @@ rebalance:
 		 * direct reclaim and reclaim/compaction depends on compaction
 		 * being called after reclaim so call directly if necessary
 		 */
-		page = __alloc_pages_direct_compact(gfp_mask, order,
-					zonelist, high_zoneidx,
-					nodemask,
-					alloc_flags, preferred_zone,
-					migratetype, sync_migration,
-					&contended_compaction,
+		page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
+					high_zoneidx, nodemask, alloc_flags,
+					preferred_zone, migratetype,
+					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
 		if (page)
@@ -6260,7 +6255,7 @@ int alloc_contig_range(unsigned long sta
 		.nr_migratepages = 0,
 		.order = -1,
 		.zone = page_zone(pfn_to_page(start)),
-		.sync = true,
+		.sync = MIGRATE_SYNC_LIGHT,
 		.ignore_skip_hint = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
_

Patches currently in -mm which might be from rientjes@google.com are

mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

