From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch added to -mm tree
Date: Tue, 29 Sep 2015 14:10:03 -0700
Message-ID: <560afe2b.q66PxpgCtobfkcWB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbbI2VKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:10:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand

High-order watermark checking exists for two reasons -- kswapd high-order
awareness and protection for high-order atomic requests.  Historically the
kernel depended on MIGRATE_RESERVE to preserve min_free_kbytes as
high-order free pages for as long as possible.  This patch introduces
MIGRATE_HIGHATOMIC that reserves pageblocks for high-order atomic
allocations on demand and avoids using those blocks for order-0
allocations.  This is more flexible and reliable than MIGRATE_RESERVE was.

A MIGRATE_HIGHORDER pageblock is created when an atomic high-order
allocation request steals a pageblock but limits the total number to 1% of
the zone.  Callers that speculatively abuse atomic allocations for
long-lived high-order allocations to access the reserve will quickly fail.
 Note that SLUB is currently not such an abuser as it reclaims at least
once.  It is possible that the pageblock stolen has few suitable
high-order pages and will need to steal again in the near future but there
would need to be strong justification to search all pageblocks for an
ideal candidate.

The pageblocks are unreserved if an allocation fails after a direct
reclaim attempt.

The watermark checks account for the reserved pageblocks when the
allocation request is not a high-order atomic allocation.

The reserved pageblocks can not be used for order-0 allocations.  This may
allow temporary wastage until a failed reclaim reassigns the pageblock. 
This is deliberate as the intent of the reservation is to satisfy a
limited number of atomic high-order short-lived requests if the system
requires them.

The stutter benchmark was used to evaluate this but while it was running
there was a systemtap script that randomly allocated between 1 high-order
page and 12.5% of memory's worth of order-3 pages using GFP_ATOMIC.  This
is much larger than the potential reserve and it does not attempt to be
realistic.  It is intended to stress random high-order allocations from an
unknown source, show that there is a reduction in failures without
introducing an anomaly where atomic allocations are more reliable than
regular allocations.  The amount of memory reserved varied throughout the
workload as reserves were created and reclaimed under memory pressure. 
The allocation failures once the workload warmed up were as follows;

4.2-rc5-vanilla		70%
4.2-rc5-atomic-reserve	56%

The failure rate was also measured while building multiple kernels.  The
failure rate was 14% but is 6% with this patch applied.

Overall, this is a small reduction but the reserves are small relative to
the number of allocation requests.  In early versions of the patch, the
failure rate reduced by a much larger amount but that required much larger
reserves and perversely made atomic allocations seem more reliable than
regular allocations.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +
 mm/page_alloc.c        |  125 ++++++++++++++++++++++++++++++++++++---
 mm/vmstat.c            |    1 
 3 files changed, 122 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand
+++ a/include/linux/mmzone.h
@@ -39,6 +39,8 @@ enum {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
 	MIGRATE_RECLAIMABLE,
+	MIGRATE_PCPTYPES,	/* the number of types on the pcp lists */
+	MIGRATE_HIGHATOMIC = MIGRATE_PCPTYPES,
 #ifdef CONFIG_CMA
 	/*
 	 * MIGRATE_CMA migration type is designed to mimic the way
@@ -61,8 +63,6 @@ enum {
 	MIGRATE_TYPES
 };
 
-#define MIGRATE_PCPTYPES (MIGRATE_RECLAIMABLE+1)
-
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
 #else
@@ -334,6 +334,8 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long watermark[NR_WMARK];
 
+	unsigned long nr_reserved_highatomic;
+
 	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
 	 * or/and it will be released eventually, so to avoid totally wasting several
diff -puN mm/page_alloc.c~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand
+++ a/mm/page_alloc.c
@@ -1615,6 +1615,88 @@ int find_suitable_fallback(struct free_a
 	return -1;
 }
 
+/*
+ * Reserve a pageblock for exclusive use of high-order atomic allocations if
+ * there are no empty page blocks that contain a page with a suitable order
+ */
+static void reserve_highatomic_pageblock(struct page *page, struct zone *zone,
+				unsigned int alloc_order)
+{
+	int mt;
+	unsigned long max_managed, flags;
+
+	/*
+	 * Limit the number reserved to 1 pageblock or roughly 1% of a zone.
+	 * Check is race-prone but harmless.
+	 */
+	max_managed = (zone->managed_pages / 100) + pageblock_nr_pages;
+	if (zone->nr_reserved_highatomic >= max_managed)
+		return;
+
+	/* Yoink! */
+	spin_lock_irqsave(&zone->lock, flags);
+
+	mt = get_pageblock_migratetype(page);
+	if (mt != MIGRATE_HIGHATOMIC &&
+			!is_migrate_isolate(mt) && !is_migrate_cma(mt)) {
+		zone->nr_reserved_highatomic += pageblock_nr_pages;
+		set_pageblock_migratetype(page, MIGRATE_HIGHATOMIC);
+		move_freepages_block(zone, page, MIGRATE_HIGHATOMIC);
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
+/*
+ * Used when an allocation is about to fail under memory pressure. This
+ * potentially hurts the reliability of high-order allocations when under
+ * intense memory pressure but failed atomic allocations should be easier
+ * to recover from than an OOM.
+ */
+static void unreserve_highatomic_pageblock(const struct alloc_context *ac)
+{
+	struct zonelist *zonelist = ac->zonelist;
+	unsigned long flags;
+	struct zoneref *z;
+	struct zone *zone;
+	struct page *page;
+	int order;
+
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->high_zoneidx,
+								ac->nodemask) {
+		/* Preserve at least one pageblock */
+		if (zone->nr_reserved_highatomic <= pageblock_nr_pages)
+			continue;
+
+		spin_lock_irqsave(&zone->lock, flags);
+		for (order = 0; order < MAX_ORDER; order++) {
+			struct free_area *area = &(zone->free_area[order]);
+
+			if (list_empty(&area->free_list[MIGRATE_HIGHATOMIC]))
+				continue;
+
+			page = list_entry(area->free_list[MIGRATE_HIGHATOMIC].next,
+						struct page, lru);
+
+			zone->nr_reserved_highatomic -= pageblock_nr_pages;
+
+			/*
+			 * Convert to ac->migratetype and avoid the normal
+			 * pageblock stealing heuristics. Minimally, the caller
+			 * is doing the work and needs the pages. More
+			 * importantly, if the block was always converted to
+			 * MIGRATE_UNMOVABLE or another type then the number
+			 * of pageblocks that cannot be completely freed
+			 * may increase.
+			 */
+			set_pageblock_migratetype(page, ac->migratetype);
+			move_freepages_block(zone, page, ac->migratetype);
+			spin_unlock_irqrestore(&zone->lock, flags);
+			return;
+		}
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static inline struct page *
 __rmqueue_fallback(struct zone *zone, unsigned int order, int start_migratetype)
@@ -1670,7 +1752,7 @@ __rmqueue_fallback(struct zone *zone, un
  * Call me with the zone->lock already held.
  */
 static struct page *__rmqueue(struct zone *zone, unsigned int order,
-						int migratetype)
+				int migratetype, gfp_t gfp_flags)
 {
 	struct page *page;
 
@@ -1700,7 +1782,7 @@ static int rmqueue_bulk(struct zone *zon
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
-		struct page *page = __rmqueue(zone, order, migratetype);
+		struct page *page = __rmqueue(zone, order, migratetype, 0);
 		if (unlikely(page == NULL))
 			break;
 
@@ -2072,7 +2154,7 @@ int split_free_page(struct page *page)
 static inline
 struct page *buffered_rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			gfp_t gfp_flags, int migratetype)
+			gfp_t gfp_flags, int alloc_flags, int migratetype)
 {
 	unsigned long flags;
 	struct page *page;
@@ -2115,7 +2197,15 @@ struct page *buffered_rmqueue(struct zon
 			WARN_ON_ONCE(order > 1);
 		}
 		spin_lock_irqsave(&zone->lock, flags);
-		page = __rmqueue(zone, order, migratetype);
+
+		page = NULL;
+		if (unlikely(order) && (alloc_flags & ALLOC_HARDER)) {
+			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+			if (page)
+				trace_mm_page_alloc_zone_locked(page, order, migratetype);
+		}
+
+		page = __rmqueue(zone, order, migratetype, gfp_flags);
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
@@ -2225,15 +2315,24 @@ static bool __zone_watermark_ok(struct z
 			unsigned long mark, int classzone_idx, int alloc_flags,
 			long free_pages)
 {
-	/* free_pages may go negative - that's OK */
 	long min = mark;
 	int o;
 	long free_cma = 0;
 
+	/* free_pages may go negative - that's OK */
 	free_pages -= (1 << order) - 1;
+
 	if (alloc_flags & ALLOC_HIGH)
 		min -= min / 2;
-	if (alloc_flags & ALLOC_HARDER)
+
+	/*
+	 * If the caller does not have rights to ALLOC_HARDER then subtract
+	 * the high-atomic reserves. This will over-estimate the size of the
+	 * atomic reserve but it avoids a search.
+	 */
+	if (likely(!(alloc_flags & ALLOC_HARDER)))
+		free_pages -= z->nr_reserved_highatomic;
+	else
 		min -= min / 4;
 
 #ifdef CONFIG_CMA
@@ -2418,10 +2517,18 @@ zonelist_scan:
 
 try_this_zone:
 		page = buffered_rmqueue(ac->preferred_zone, zone, order,
-						gfp_mask, ac->migratetype);
+				gfp_mask, alloc_flags, ac->migratetype);
 		if (page) {
 			if (prep_new_page(page, order, gfp_mask, alloc_flags))
 				goto try_this_zone;
+
+			/*
+			 * If this is a high-order atomic allocation then check
+			 * if the pageblock should be reserved for the future
+			 */
+			if (unlikely(order && (alloc_flags & ALLOC_HARDER)))
+				reserve_highatomic_pageblock(page, zone, order);
+
 			return page;
 		}
 	}
@@ -2694,9 +2801,11 @@ retry:
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
-	 * pages are pinned on the per-cpu lists. Drain them and try again
+	 * pages are pinned on the per-cpu lists or in high alloc reserves.
+	 * Shrink them them and try again
 	 */
 	if (!page && !drained) {
+		unreserve_highatomic_pageblock(ac);
 		drain_all_pages(NULL);
 		drained = true;
 		goto retry;
diff -puN mm/vmstat.c~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand
+++ a/mm/vmstat.c
@@ -901,6 +901,7 @@ static char * const migratetype_names[MI
 	"Unmovable",
 	"Reclaimable",
 	"Movable",
+	"HighAtomic",
 #ifdef CONFIG_CMA
 	"CMA",
 #endif
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

