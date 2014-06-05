From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:51 -0700
Message-ID: <5390ca93.t/BjM6CNwrOtTE1V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaFETww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, rientjes@google.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, dan.carpenter@oracle.com, mgorman@suse.de

Subject: [merged] mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch removed from -mm tree
To: mgorman@suse.de,dan.carpenter@oracle.com,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,rientjes@google.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:51 -0700


The patch titled
     Subject: mm: page_alloc: calculate classzone_idx once from the zonelist ref
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: calculate classzone_idx once from the zonelist ref

There is no need to calculate zone_idx(preferred_zone) multiple times
or use the pgdat to figure it out.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   59 ++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref
+++ a/mm/page_alloc.c
@@ -1916,11 +1916,10 @@ static bool zone_allows_reclaim(struct z
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
-		struct zone *preferred_zone, int migratetype)
+		struct zone *preferred_zone, int classzone_idx, int migratetype)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
-	int classzone_idx;
 	struct zone *zone;
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
@@ -1928,7 +1927,6 @@ get_page_from_freelist(gfp_t gfp_mask, n
 	bool consider_zone_dirty = (alloc_flags & ALLOC_WMARK_LOW) &&
 				(gfp_mask & __GFP_WRITE);
 
-	classzone_idx = zone_idx(preferred_zone);
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -2186,7 +2184,7 @@ static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int migratetype)
+	int classzone_idx, int migratetype)
 {
 	struct page *page;
 
@@ -2204,7 +2202,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
 		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
-		preferred_zone, migratetype);
+		preferred_zone, classzone_idx, migratetype);
 	if (page)
 		goto out;
 
@@ -2239,7 +2237,7 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, enum migrate_mode mode,
+	int classzone_idx, int migratetype, enum migrate_mode mode,
 	bool *contended_compaction, bool *deferred_compaction,
 	unsigned long *did_some_progress)
 {
@@ -2267,7 +2265,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		page = get_page_from_freelist(gfp_mask, nodemask,
 				order, zonelist, high_zoneidx,
 				alloc_flags & ~ALLOC_NO_WATERMARKS,
-				preferred_zone, migratetype);
+				preferred_zone, classzone_idx, migratetype);
 		if (page) {
 			preferred_zone->compact_blockskip_flush = false;
 			compaction_defer_reset(preferred_zone, order, true);
@@ -2299,7 +2297,8 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, enum migrate_mode mode, bool *contended_compaction,
+	int classzone_idx, int migratetype,
+	enum migrate_mode mode, bool *contended_compaction,
 	bool *deferred_compaction, unsigned long *did_some_progress)
 {
 	return NULL;
@@ -2339,7 +2338,7 @@ static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress)
+	int classzone_idx, int migratetype, unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	bool drained = false;
@@ -2357,7 +2356,8 @@ retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags & ~ALLOC_NO_WATERMARKS,
-					preferred_zone, migratetype);
+					preferred_zone, classzone_idx,
+					migratetype);
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
@@ -2380,14 +2380,14 @@ static inline struct page *
 __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int migratetype)
+	int classzone_idx, int migratetype)
 {
 	struct page *page;
 
 	do {
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
-			preferred_zone, migratetype);
+			preferred_zone, classzone_idx, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
 			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
@@ -2488,7 +2488,7 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int migratetype)
+	int classzone_idx, int migratetype)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -2537,15 +2537,18 @@ restart:
 	 * Find the true preferred zone if the allocation is unconstrained by
 	 * cpusets.
 	 */
-	if (!(alloc_flags & ALLOC_CPUSET) && !nodemask)
-		first_zones_zonelist(zonelist, high_zoneidx, NULL,
-					&preferred_zone);
+	if (!(alloc_flags & ALLOC_CPUSET) && !nodemask) {
+		struct zoneref *preferred_zoneref;
+		preferred_zoneref = first_zones_zonelist(zonelist, high_zoneidx,
+				NULL, &preferred_zone);
+		classzone_idx = zonelist_zone_idx(preferred_zoneref);
+	}
 
 rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
-			preferred_zone, migratetype);
+			preferred_zone, classzone_idx, migratetype);
 	if (page)
 		goto got_pg;
 
@@ -2560,7 +2563,7 @@ rebalance:
 
 		page = __alloc_pages_high_priority(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
-				preferred_zone, migratetype);
+				preferred_zone, classzone_idx, migratetype);
 		if (page) {
 			goto got_pg;
 		}
@@ -2591,7 +2594,8 @@ rebalance:
 	 */
 	page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
 					high_zoneidx, nodemask, alloc_flags,
-					preferred_zone, migratetype,
+					preferred_zone,
+					classzone_idx, migratetype,
 					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
@@ -2621,7 +2625,8 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress);
+					classzone_idx, migratetype,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -2640,7 +2645,7 @@ rebalance:
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
-					migratetype);
+					classzone_idx, migratetype);
 			if (page)
 				goto got_pg;
 
@@ -2681,7 +2686,8 @@ rebalance:
 		 */
 		page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
 					high_zoneidx, nodemask, alloc_flags,
-					preferred_zone, migratetype,
+					preferred_zone,
+					classzone_idx, migratetype,
 					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
@@ -2708,10 +2714,12 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	struct zone *preferred_zone;
+	struct zoneref *preferred_zoneref;
 	struct page *page = NULL;
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
+	int classzone_idx;
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2734,11 +2742,12 @@ retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/* The preferred zone is used for statistics later */
-	first_zones_zonelist(zonelist, high_zoneidx,
+	preferred_zoneref = first_zones_zonelist(zonelist, high_zoneidx,
 				nodemask ? : &cpuset_current_mems_allowed,
 				&preferred_zone);
 	if (!preferred_zone)
 		goto out;
+	classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
 #ifdef CONFIG_CMA
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
@@ -2748,7 +2757,7 @@ retry:
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
-			preferred_zone, migratetype);
+			preferred_zone, classzone_idx, migratetype);
 	if (unlikely(!page)) {
 		/*
 		 * The first pass makes sure allocations are spread
@@ -2774,7 +2783,7 @@ retry:
 		gfp_mask = memalloc_noio_flags(gfp_mask);
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
-				preferred_zone, migratetype);
+				preferred_zone, classzone_idx, migratetype);
 	}
 
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

