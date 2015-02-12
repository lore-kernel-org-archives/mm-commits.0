From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:36:35 -0800
Message-ID: <54dd00c3.8HctYz6S1H5OmzGo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbbBLTgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: reduce number of alloc_pages* functions' parameters
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: reduce number of alloc_pages* functions' parameters

Introduce struct alloc_context to accumulate the numerous parameters
passed between the alloc_pages* family of functions and
get_page_from_freelist().  This excludes gfp_flags and alloc_info, which
mutate too much along the way, and allocation order, which is conceptually
different.

The result is shorter function signatures, as well as overal code size and
stack usage reductions.

bloat-o-meter:

add/remove: 0/0 grow/shrink: 1/2 up/down: 127/-310 (-183)
function                                     old     new   delta
get_page_from_freelist                      2525    2652    +127
__alloc_pages_direct_compact                 329     283     -46
__alloc_pages_nodemask                      2564    2300    -264

checkstack.pl:

function                            old    new
__alloc_pages_nodemask              248    200
get_page_from_freelist              168    184
__alloc_pages_direct_compact         40     24

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  229 +++++++++++++++++++++-------------------------
 1 file changed, 108 insertions(+), 121 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters
+++ a/mm/page_alloc.c
@@ -232,6 +232,27 @@ EXPORT_SYMBOL(nr_node_ids);
 EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
+/*
+ * Structure for holding the mostly immutable allocation parameters passed
+ * between alloc_pages* family of functions.
+ *
+ * nodemask, migratetype and high_zoneidx are initialized only once in
+ * __alloc_pages_nodemask() and then never change.
+ *
+ * zonelist, preferred_zone and classzone_idx are set first in
+ * __alloc_pages_nodemask() for the fast path, and might be later changed
+ * in __alloc_pages_slowpath(). All other functions pass the whole strucure
+ * by a const pointer.
+ */
+struct alloc_context {
+	struct zonelist *zonelist;
+	nodemask_t *nodemask;
+	struct zone *preferred_zone;
+	int classzone_idx;
+	int migratetype;
+	enum zone_type high_zoneidx;
+};
+
 int page_group_by_mobility_disabled __read_mostly;
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
@@ -2037,10 +2058,10 @@ static void reset_alloc_batches(struct z
  * a page.
  */
 static struct page *
-get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
-		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
-		struct zone *preferred_zone, int classzone_idx, int migratetype)
+get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
+						const struct alloc_context *ac)
 {
+	struct zonelist *zonelist = ac->zonelist;
 	struct zoneref *z;
 	struct page *page = NULL;
 	struct zone *zone;
@@ -2059,8 +2080,8 @@ zonelist_scan:
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
 	 */
-	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-						high_zoneidx, nodemask) {
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->high_zoneidx,
+								ac->nodemask) {
 		unsigned long mark;
 
 		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
@@ -2077,7 +2098,7 @@ zonelist_scan:
 		 * time the page has in memory before being reclaimed.
 		 */
 		if (alloc_flags & ALLOC_FAIR) {
-			if (!zone_local(preferred_zone, zone))
+			if (!zone_local(ac->preferred_zone, zone))
 				break;
 			if (test_bit(ZONE_FAIR_DEPLETED, &zone->flags)) {
 				nr_fair_skipped++;
@@ -2115,7 +2136,7 @@ zonelist_scan:
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 		if (!zone_watermark_ok(zone, order, mark,
-				       classzone_idx, alloc_flags)) {
+				       ac->classzone_idx, alloc_flags)) {
 			int ret;
 
 			/* Checked here to keep the fast path fast */
@@ -2136,7 +2157,7 @@ zonelist_scan:
 			}
 
 			if (zone_reclaim_mode == 0 ||
-			    !zone_allows_reclaim(preferred_zone, zone))
+			    !zone_allows_reclaim(ac->preferred_zone, zone))
 				goto this_zone_full;
 
 			/*
@@ -2158,7 +2179,7 @@ zonelist_scan:
 			default:
 				/* did we reclaim enough */
 				if (zone_watermark_ok(zone, order, mark,
-						classzone_idx, alloc_flags))
+						ac->classzone_idx, alloc_flags))
 					goto try_this_zone;
 
 				/*
@@ -2179,8 +2200,8 @@ zonelist_scan:
 		}
 
 try_this_zone:
-		page = buffered_rmqueue(preferred_zone, zone, order,
-						gfp_mask, migratetype);
+		page = buffered_rmqueue(ac->preferred_zone, zone, order,
+						gfp_mask, ac->migratetype);
 		if (page) {
 			if (prep_new_page(page, order, gfp_mask, alloc_flags))
 				goto try_this_zone;
@@ -2203,7 +2224,7 @@ this_zone_full:
 		alloc_flags &= ~ALLOC_FAIR;
 		if (nr_fair_skipped) {
 			zonelist_rescan = true;
-			reset_alloc_batches(preferred_zone);
+			reset_alloc_batches(ac->preferred_zone);
 		}
 		if (nr_online_nodes > 1)
 			zonelist_rescan = true;
@@ -2325,9 +2346,7 @@ should_alloc_retry(gfp_t gfp_mask, unsig
 
 static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
-	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone,
-	int classzone_idx, int migratetype, unsigned long *did_some_progress)
+	const struct alloc_context *ac, unsigned long *did_some_progress)
 {
 	struct page *page;
 
@@ -2340,7 +2359,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	 * Acquire the per-zone oom lock for each zone.  If that
 	 * fails, somebody else is making progress for us.
 	 */
-	if (!oom_zonelist_trylock(zonelist, gfp_mask)) {
+	if (!oom_zonelist_trylock(ac->zonelist, gfp_mask)) {
 		*did_some_progress = 1;
 		schedule_timeout_uninterruptible(1);
 		return NULL;
@@ -2359,10 +2378,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	 * here, this is only to catch a parallel oom killing, we must fail if
 	 * we're still under heavy pressure.
 	 */
-	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
-		order, zonelist, high_zoneidx,
-		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
-		preferred_zone, classzone_idx, migratetype);
+	page = get_page_from_freelist(gfp_mask | __GFP_HARDWALL, order,
+					ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
 	if (page)
 		goto out;
 
@@ -2374,7 +2391,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			goto out;
 		/* The OOM killer does not needlessly kill tasks for lowmem */
-		if (high_zoneidx < ZONE_NORMAL)
+		if (ac->high_zoneidx < ZONE_NORMAL)
 			goto out;
 		/* The OOM killer does not compensate for light reclaim */
 		if (!(gfp_mask & __GFP_FS))
@@ -2390,10 +2407,10 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 			goto out;
 	}
 	/* Exhausted what can be done so it's blamo time */
-	out_of_memory(zonelist, gfp_mask, order, nodemask, false);
+	out_of_memory(ac->zonelist, gfp_mask, order, ac->nodemask, false);
 	*did_some_progress = 1;
 out:
-	oom_zonelist_unlock(zonelist, gfp_mask);
+	oom_zonelist_unlock(ac->zonelist, gfp_mask);
 	return page;
 }
 
@@ -2401,10 +2418,9 @@ out:
 /* Try memory compaction for high-order allocations before reclaim */
 static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
-	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int classzone_idx, int migratetype, enum migrate_mode mode,
-	int *contended_compaction, bool *deferred_compaction)
+		int alloc_flags, const struct alloc_context *ac,
+		enum migrate_mode mode, int *contended_compaction,
+		bool *deferred_compaction)
 {
 	unsigned long compact_result;
 	struct page *page;
@@ -2413,10 +2429,10 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		return NULL;
 
 	current->flags |= PF_MEMALLOC;
-	compact_result = try_to_compact_pages(zonelist, order, gfp_mask,
-						nodemask, mode,
+	compact_result = try_to_compact_pages(ac->zonelist, order, gfp_mask,
+						ac->nodemask, mode,
 						contended_compaction,
-						alloc_flags, classzone_idx);
+						alloc_flags, ac->classzone_idx);
 	current->flags &= ~PF_MEMALLOC;
 
 	switch (compact_result) {
@@ -2435,10 +2451,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	 */
 	count_vm_event(COMPACTSTALL);
 
-	page = get_page_from_freelist(gfp_mask, nodemask,
-			order, zonelist, high_zoneidx,
-			alloc_flags & ~ALLOC_NO_WATERMARKS,
-			preferred_zone, classzone_idx, migratetype);
+	page = get_page_from_freelist(gfp_mask, order,
+					alloc_flags & ~ALLOC_NO_WATERMARKS, ac);
 
 	if (page) {
 		struct zone *zone = page_zone(page);
@@ -2462,10 +2476,9 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 #else
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
-	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int classzone_idx, int migratetype, enum migrate_mode mode,
-	int *contended_compaction, bool *deferred_compaction)
+		int alloc_flags, const struct alloc_context *ac,
+		enum migrate_mode mode, int *contended_compaction,
+		bool *deferred_compaction)
 {
 	return NULL;
 }
@@ -2473,8 +2486,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 /* Perform direct synchronous page reclaim */
 static int
-__perform_reclaim(gfp_t gfp_mask, unsigned int order, struct zonelist *zonelist,
-		  nodemask_t *nodemask)
+__perform_reclaim(gfp_t gfp_mask, unsigned int order,
+					const struct alloc_context *ac)
 {
 	struct reclaim_state reclaim_state;
 	int progress;
@@ -2488,7 +2501,8 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 	reclaim_state.reclaimed_slab = 0;
 	current->reclaim_state = &reclaim_state;
 
-	progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
+	progress = try_to_free_pages(ac->zonelist, order, gfp_mask,
+								ac->nodemask);
 
 	current->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
@@ -2502,28 +2516,23 @@ __perform_reclaim(gfp_t gfp_mask, unsign
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
-	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int classzone_idx, int migratetype, unsigned long *did_some_progress)
+		int alloc_flags, const struct alloc_context *ac,
+		unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	bool drained = false;
 
-	*did_some_progress = __perform_reclaim(gfp_mask, order, zonelist,
-					       nodemask);
+	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
 	if (unlikely(!(*did_some_progress)))
 		return NULL;
 
 	/* After successful reclaim, reconsider all zones for allocation */
 	if (IS_ENABLED(CONFIG_NUMA))
-		zlc_clear_zones_full(zonelist);
+		zlc_clear_zones_full(ac->zonelist);
 
 retry:
-	page = get_page_from_freelist(gfp_mask, nodemask, order,
-					zonelist, high_zoneidx,
-					alloc_flags & ~ALLOC_NO_WATERMARKS,
-					preferred_zone, classzone_idx,
-					migratetype);
+	page = get_page_from_freelist(gfp_mask, order,
+					alloc_flags & ~ALLOC_NO_WATERMARKS, ac);
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
@@ -2544,36 +2553,30 @@ retry:
  */
 static inline struct page *
 __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
-	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone,
-	int classzone_idx, int migratetype)
+				const struct alloc_context *ac)
 {
 	struct page *page;
 
 	do {
-		page = get_page_from_freelist(gfp_mask, nodemask, order,
-			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
-			preferred_zone, classzone_idx, migratetype);
+		page = get_page_from_freelist(gfp_mask, order,
+						ALLOC_NO_WATERMARKS, ac);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
-			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
+			wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC,
+									HZ/50);
 	} while (!page && (gfp_mask & __GFP_NOFAIL));
 
 	return page;
 }
 
-static void wake_all_kswapds(unsigned int order,
-			     struct zonelist *zonelist,
-			     enum zone_type high_zoneidx,
-			     struct zone *preferred_zone,
-			     nodemask_t *nodemask)
+static void wake_all_kswapds(unsigned int order, const struct alloc_context *ac)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
-	for_each_zone_zonelist_nodemask(zone, z, zonelist,
-						high_zoneidx, nodemask)
-		wakeup_kswapd(zone, order, zone_idx(preferred_zone));
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+						ac->high_zoneidx, ac->nodemask)
+		wakeup_kswapd(zone, order, zone_idx(ac->preferred_zone));
 }
 
 static inline int
@@ -2632,9 +2635,7 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_ma
 
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
-	struct zonelist *zonelist, enum zone_type high_zoneidx,
-	nodemask_t *nodemask, struct zone *preferred_zone,
-	int classzone_idx, int migratetype)
+						struct alloc_context *ac)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -2670,8 +2671,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 retry:
 	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapds(order, zonelist, high_zoneidx,
-				preferred_zone, nodemask);
+		wake_all_kswapds(order, ac);
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -2684,17 +2684,16 @@ retry:
 	 * Find the true preferred zone if the allocation is unconstrained by
 	 * cpusets.
 	 */
-	if (!(alloc_flags & ALLOC_CPUSET) && !nodemask) {
+	if (!(alloc_flags & ALLOC_CPUSET) && !ac->nodemask) {
 		struct zoneref *preferred_zoneref;
-		preferred_zoneref = first_zones_zonelist(zonelist, high_zoneidx,
-				NULL, &preferred_zone);
-		classzone_idx = zonelist_zone_idx(preferred_zoneref);
+		preferred_zoneref = first_zones_zonelist(ac->zonelist,
+				ac->high_zoneidx, NULL, &ac->preferred_zone);
+		ac->classzone_idx = zonelist_zone_idx(preferred_zoneref);
 	}
 
 	/* This is the last chance, in general, before the goto nopage. */
-	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
-			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
-			preferred_zone, classzone_idx, migratetype);
+	page = get_page_from_freelist(gfp_mask, order,
+				alloc_flags & ~ALLOC_NO_WATERMARKS, ac);
 	if (page)
 		goto got_pg;
 
@@ -2705,11 +2704,10 @@ retry:
 		 * the allocation is high priority and these type of
 		 * allocations are system rather than user orientated
 		 */
-		zonelist = node_zonelist(numa_node_id(), gfp_mask);
+		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
+
+		page = __alloc_pages_high_priority(gfp_mask, order, ac);
 
-		page = __alloc_pages_high_priority(gfp_mask, order,
-				zonelist, high_zoneidx, nodemask,
-				preferred_zone, classzone_idx, migratetype);
 		if (page) {
 			goto got_pg;
 		}
@@ -2738,11 +2736,9 @@ retry:
 	 * Try direct compaction. The first pass is asynchronous. Subsequent
 	 * attempts after direct reclaim are synchronous
 	 */
-	page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
-					high_zoneidx, nodemask, alloc_flags,
-					preferred_zone,
-					classzone_idx, migratetype,
-					migration_mode, &contended_compaction,
+	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
+					migration_mode,
+					&contended_compaction,
 					&deferred_compaction);
 	if (page)
 		goto got_pg;
@@ -2788,12 +2784,8 @@ retry:
 		migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/* Try direct reclaim and then allocating */
-	page = __alloc_pages_direct_reclaim(gfp_mask, order,
-					zonelist, high_zoneidx,
-					nodemask,
-					alloc_flags, preferred_zone,
-					classzone_idx, migratetype,
-					&did_some_progress);
+	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
+							&did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -2807,17 +2799,15 @@ retry:
 		 * start OOM killing tasks.
 		 */
 		if (!did_some_progress) {
-			page = __alloc_pages_may_oom(gfp_mask, order, zonelist,
-						high_zoneidx, nodemask,
-						preferred_zone, classzone_idx,
-						migratetype,&did_some_progress);
+			page = __alloc_pages_may_oom(gfp_mask, order, ac,
+							&did_some_progress);
 			if (page)
 				goto got_pg;
 			if (!did_some_progress)
 				goto nopage;
 		}
 		/* Wait for some write requests to complete then retry */
-		wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
+		wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC, HZ/50);
 		goto retry;
 	} else {
 		/*
@@ -2825,11 +2815,9 @@ retry:
 		 * direct reclaim and reclaim/compaction depends on compaction
 		 * being called after reclaim so call directly if necessary
 		 */
-		page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
-					high_zoneidx, nodemask, alloc_flags,
-					preferred_zone,
-					classzone_idx, migratetype,
-					migration_mode, &contended_compaction,
+		page = __alloc_pages_direct_compact(gfp_mask, order,
+					alloc_flags, ac, migration_mode,
+					&contended_compaction,
 					&deferred_compaction);
 		if (page)
 			goto got_pg;
@@ -2848,15 +2836,16 @@ struct page *
 __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
-	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
-	struct zone *preferred_zone;
 	struct zoneref *preferred_zoneref;
 	struct page *page = NULL;
-	int migratetype = gfpflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
-	int classzone_idx;
 	gfp_t alloc_mask; /* The gfp_t that was actually used for allocation */
+	struct alloc_context ac = {
+		.high_zoneidx = gfp_zone(gfp_mask),
+		.nodemask = nodemask,
+		.migratetype = gfpflags_to_migratetype(gfp_mask),
+	};
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2875,25 +2864,25 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
-	if (IS_ENABLED(CONFIG_CMA) && migratetype == MIGRATE_MOVABLE)
+	if (IS_ENABLED(CONFIG_CMA) && ac.migratetype == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
+	/* We set it here, as __alloc_pages_slowpath might have changed it */
+	ac.zonelist = zonelist;
 	/* The preferred zone is used for statistics later */
-	preferred_zoneref = first_zones_zonelist(zonelist, high_zoneidx,
-				nodemask ? : &cpuset_current_mems_allowed,
-				&preferred_zone);
-	if (!preferred_zone)
+	preferred_zoneref = first_zones_zonelist(ac.zonelist, ac.high_zoneidx,
+				ac.nodemask ? : &cpuset_current_mems_allowed,
+				&ac.preferred_zone);
+	if (!ac.preferred_zone)
 		goto out;
-	classzone_idx = zonelist_zone_idx(preferred_zoneref);
+	ac.classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
 	/* First allocation attempt */
 	alloc_mask = gfp_mask|__GFP_HARDWALL;
-	page = get_page_from_freelist(alloc_mask, nodemask, order, zonelist,
-			high_zoneidx, alloc_flags, preferred_zone,
-			classzone_idx, migratetype);
+	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
 	if (unlikely(!page)) {
 		/*
 		 * Runtime PM, block IO and its error handling path
@@ -2902,15 +2891,13 @@ retry_cpuset:
 		 */
 		alloc_mask = memalloc_noio_flags(gfp_mask);
 
-		page = __alloc_pages_slowpath(alloc_mask, order,
-				zonelist, high_zoneidx, nodemask,
-				preferred_zone, classzone_idx, migratetype);
+		page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 	}
 
 	if (kmemcheck_enabled && page)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
 
-	trace_mm_page_alloc(page, order, alloc_mask, migratetype);
+	trace_mm_page_alloc(page, order, alloc_mask, ac.migratetype);
 
 out:
 	/*
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
mm-fix-negative-nr_isolated-counts.patch
zram-fix-umount-reset_store-mount-race-condition.patch

