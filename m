From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-fair-zone-allocator-policy.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:42:59 -0700
Message-ID: <52321943.ctvAoSq6iFVUfpfW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3ILTnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, paul.bollee@gmail.com, mgorman@suse.de, khilman@linaro.org, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-page_alloc-fair-zone-allocator-policy.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,khilman@linaro.org,mgorman@suse.de,paul.bollee@gmail.com,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:59 -0700


The patch titled
     Subject: mm: page_alloc: fair zone allocator policy
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fair-zone-allocator-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fair zone allocator policy

Each zone that holds userspace pages of one workload must be aged at a
speed proportional to the zone size.  Otherwise, the time an individual
page gets to stay in memory depends on the zone it happened to be
allocated in.  Asymmetry in the zone aging creates rather unpredictable
aging behavior and results in the wrong pages being reclaimed, activated
etc.

But exactly this happens right now because of the way the page allocator
and kswapd interact.  The page allocator uses per-node lists of all zones
in the system, ordered by preference, when allocating a new page.  When
the first iteration does not yield any results, kswapd is woken up and the
allocator retries.  Due to the way kswapd reclaims zones below the high
watermark while a zone can be allocated from when it is above the low
watermark, the allocator may keep kswapd running while kswapd reclaim
ensures that the page allocator can keep allocating from the first zone in
the zonelist for extended periods of time.  Meanwhile the other zones
rarely see new allocations and thus get aged much slower in comparison.

The result is that the occasional page placed in lower zones gets
relatively more time in memory, even gets promoted to the active list
after its peers have long been evicted.  Meanwhile, the bulk of the
working set may be thrashing on the preferred zone even though there may
be significant amounts of memory available in the lower zones.

Even the most basic test -- repeatedly reading a file slightly bigger than
memory -- shows how broken the zone aging is.  In this scenario, no single
page should be able stay in memory long enough to get referenced twice and
activated, but activation happens in spades:

  $ grep active_file /proc/zoneinfo
      nr_inactive_file 0
      nr_active_file 0
      nr_inactive_file 0
      nr_active_file 8
      nr_inactive_file 1582
      nr_active_file 11994
  $ cat data data data data >/dev/null
  $ grep active_file /proc/zoneinfo
      nr_inactive_file 0
      nr_active_file 70
      nr_inactive_file 258753
      nr_active_file 443214
      nr_inactive_file 149793
      nr_active_file 12021

Fix this with a very simple round robin allocator.  Each zone is allowed a
batch of allocations that is proportional to the zone's size, after which
it is treated as full.  The batch counters are reset when all zones have
been tried and the allocator enters the slowpath and kicks off kswapd
reclaim.  Allocation and reclaim is now fairly spread out to all
available/allowable zones:

  $ grep active_file /proc/zoneinfo
      nr_inactive_file 0
      nr_active_file 0
      nr_inactive_file 174
      nr_active_file 4865
      nr_inactive_file 53
      nr_active_file 860
  $ cat data data data data >/dev/null
  $ grep active_file /proc/zoneinfo
      nr_inactive_file 0
      nr_active_file 0
      nr_inactive_file 666622
      nr_active_file 4988
      nr_inactive_file 190969
      nr_active_file 937

When zone_reclaim_mode is enabled, allocations will now spread out to all
zones on the local node, not just the first preferred zone (which on a 4G
node might be a tiny Normal zone).

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Bolle <paul.bollee@gmail.com>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Tested-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 
 mm/page_alloc.c        |   72 +++++++++++++++++++++++++++++++++------
 mm/vmstat.c            |    1 
 3 files changed, 64 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-fair-zone-allocator-policy
+++ a/include/linux/mmzone.h
@@ -105,6 +105,7 @@ struct zone_padding {
 enum zone_stat_item {
 	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
+	NR_ALLOC_BATCH,
 	NR_LRU_BASE,
 	NR_INACTIVE_ANON = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
 	NR_ACTIVE_ANON,		/*  "     "     "   "       "         */
diff -puN mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy
+++ a/mm/page_alloc.c
@@ -1551,6 +1551,7 @@ again:
 					  get_pageblock_migratetype(page));
 	}
 
+	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
@@ -1817,6 +1818,11 @@ static void zlc_clear_zones_full(struct
 	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 }
 
+static bool zone_local(struct zone *local_zone, struct zone *zone)
+{
+	return node_distance(local_zone->node, zone->node) == LOCAL_DISTANCE;
+}
+
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
 	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
@@ -1854,6 +1860,11 @@ static void zlc_clear_zones_full(struct
 {
 }
 
+static bool zone_local(struct zone *local_zone, struct zone *zone)
+{
+	return true;
+}
+
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
 	return true;
@@ -1901,6 +1912,26 @@ zonelist_scan:
 		if (alloc_flags & ALLOC_NO_WATERMARKS)
 			goto try_this_zone;
 		/*
+		 * Distribute pages in proportion to the individual
+		 * zone size to ensure fair page aging.  The zone a
+		 * page was allocated in should have no effect on the
+		 * time the page has in memory before being reclaimed.
+		 *
+		 * When zone_reclaim_mode is enabled, try to stay in
+		 * local zones in the fastpath.  If that fails, the
+		 * slowpath is entered, which will do another pass
+		 * starting with the local zones, but ultimately fall
+		 * back to remote zones that do not partake in the
+		 * fairness round-robin cycle of this zonelist.
+		 */
+		if (alloc_flags & ALLOC_WMARK_LOW) {
+			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
+				continue;
+			if (zone_reclaim_mode &&
+			    !zone_local(preferred_zone, zone))
+				continue;
+		}
+		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a zone that is within its dirty
 		 * limit, such that no single zone holds more than its
@@ -2346,16 +2377,30 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 	return page;
 }
 
-static inline
-void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
-						enum zone_type high_zoneidx,
-						enum zone_type classzone_idx)
+static void prepare_slowpath(gfp_t gfp_mask, unsigned int order,
+			     struct zonelist *zonelist,
+			     enum zone_type high_zoneidx,
+			     struct zone *preferred_zone)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
-		wakeup_kswapd(zone, order, classzone_idx);
+	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+		if (!(gfp_mask & __GFP_NO_KSWAPD))
+			wakeup_kswapd(zone, order, zone_idx(preferred_zone));
+		/*
+		 * Only reset the batches of zones that were actually
+		 * considered in the fast path, we don't want to
+		 * thrash fairness information for zones that are not
+		 * actually part of this zonelist's round-robin cycle.
+		 */
+		if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
+			continue;
+		mod_zone_page_state(zone, NR_ALLOC_BATCH,
+				    high_wmark_pages(zone) -
+				    low_wmark_pages(zone) -
+				    zone_page_state(zone, NR_ALLOC_BATCH));
+	}
 }
 
 static inline int
@@ -2451,9 +2496,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	if (!(gfp_mask & __GFP_NO_KSWAPD))
-		wake_all_kswapd(order, zonelist, high_zoneidx,
-						zone_idx(preferred_zone));
+	prepare_slowpath(gfp_mask, order, zonelist,
+			 high_zoneidx, preferred_zone);
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -4753,8 +4797,11 @@ static void __paginginit free_area_init_
 		spin_lock_init(&zone->lru_lock);
 		zone_seqlock_init(zone);
 		zone->zone_pgdat = pgdat;
-
 		zone_pcp_init(zone);
+
+		/* For bootup, initialized properly in watermark setup */
+		mod_zone_page_state(zone, NR_ALLOC_BATCH, zone->managed_pages);
+
 		lruvec_init(&zone->lruvec);
 		if (!size)
 			continue;
@@ -5525,6 +5572,11 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
+		__mod_zone_page_state(zone, NR_ALLOC_BATCH,
+				      high_wmark_pages(zone) -
+				      low_wmark_pages(zone) -
+				      zone_page_state(zone, NR_ALLOC_BATCH));
+
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
diff -puN mm/vmstat.c~mm-page_alloc-fair-zone-allocator-policy mm/vmstat.c
--- a/mm/vmstat.c~mm-page_alloc-fair-zone-allocator-policy
+++ a/mm/vmstat.c
@@ -703,6 +703,7 @@ static void walk_zones_in_node(struct se
 const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_free_pages",
+	"nr_alloc_batch",
 	"nr_inactive_anon",
 	"nr_active_anon",
 	"nr_inactive_file",
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

