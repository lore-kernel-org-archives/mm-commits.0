From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
 added to -mm tree
Date: Wed, 14 May 2014 15:07:14 -0700
Message-ID: <5373e912.vKDySW7HjN8oDxn6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaENWHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 18:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: + mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch added to -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 15:07:14 -0700


The patch titled
     Subject: mm: page_alloc: calculate classzone_idx once from the zonelist ref
has been added to the -mm tree.  Its filename is
     mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: calculate classzone_idx once from the zonelist ref

There is no need to calculate zone_idx(preferred_zone) multiple times
or use the pgdat to figure it out.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   60 ++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

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
@@ -2537,15 +2537,19 @@ restart:
 	 * Find the true preferred zone if the allocation is unconstrained by
 	 * cpusets.
 	 */
-	if (!(alloc_flags & ALLOC_CPUSET) && !nodemask)
-		first_zones_zonelist(zonelist, high_zoneidx, NULL,
-					&preferred_zone);
+	if (!(alloc_flags & ALLOC_CPUSET) && !nodemask) {
+		struct zoneref *preferred_zoneref;
+		preferred_zoneref = first_zones_zonelist(zonelist, high_zoneidx,
+				nodemask ? : &cpuset_current_mems_allowed,
+				&preferred_zone);
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
 
@@ -2560,7 +2564,7 @@ rebalance:
 
 		page = __alloc_pages_high_priority(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
-				preferred_zone, migratetype);
+				preferred_zone, classzone_idx, migratetype);
 		if (page) {
 			goto got_pg;
 		}
@@ -2591,7 +2595,8 @@ rebalance:
 	 */
 	page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
 					high_zoneidx, nodemask, alloc_flags,
-					preferred_zone, migratetype,
+					preferred_zone,
+					classzone_idx, migratetype,
 					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
@@ -2621,7 +2626,8 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress);
+					classzone_idx, migratetype,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -2640,7 +2646,7 @@ rebalance:
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
-					migratetype);
+					classzone_idx, migratetype);
 			if (page)
 				goto got_pg;
 
@@ -2681,7 +2687,8 @@ rebalance:
 		 */
 		page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
 					high_zoneidx, nodemask, alloc_flags,
-					preferred_zone, migratetype,
+					preferred_zone,
+					classzone_idx, migratetype,
 					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
@@ -2708,10 +2715,12 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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
 
@@ -2734,11 +2743,12 @@ retry_cpuset:
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
@@ -2748,7 +2758,7 @@ retry:
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
-			preferred_zone, migratetype);
+			preferred_zone, classzone_idx, migratetype);
 	if (unlikely(!page)) {
 		/*
 		 * The first pass makes sure allocations are spread
@@ -2774,7 +2784,7 @@ retry:
 		gfp_mask = memalloc_noio_flags(gfp_mask);
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
-				preferred_zone, migratetype);
+				preferred_zone, classzone_idx, migratetype);
 	}
 
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
_

Patches currently in -mm which might be from mgorman@suse.de are

x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-fix.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-x86-pgtable-drop-unneeded-preprocessor-ifdef.patch
mm-x86-pgtable-require-x86_64-for-soft-dirty-tracker.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch
mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu.patch
cpu-hotplug-stop-machine-plug-race-window-that-leads-to-ipi-to-offline-cpu-v3.patch
linux-next.patch

