From: akpm@linux-foundation.org
Subject: + mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
 added to -mm tree
Date: Thu, 20 Mar 2014 15:09:11 -0700
Message-ID: <532b6707.N6K1V5g+MwdxMuDI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278AbaCTWJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 18:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, riel@redhat.com, mgorman@suse.de, hannes@cmpxchg.org

Subject: + mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch added to -mm tree
To: hannes@cmpxchg.org,mgorman@suse.de,riel@redhat.com,stable@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 15:09:11 -0700


The patch titled
     Subject: mm: page_alloc: spill to remote nodes before waking kswapd
has been added to the -mm tree.  Its filename is
     mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: spill to remote nodes before waking kswapd

On NUMA systems, a node may start thrashing cache or even swap anonymous
pages while there are still free pages on remote nodes.

This is a result of 81c0a2bb515f ("mm: page_alloc: fair zone allocator
policy") and fff4068cba48 ("mm: page_alloc: revert NUMA aspect of fair
allocation policy").  Before those changes, the allocator would first try
all allowed zones, including those on remote nodes, before waking any
kswapds.  But now, the allocator fastpath doubles as the fairness pass,
which in turn can only consider the local node to prevent remote spilling
based on exhausted fairness batches alone.  Remote nodes are only
considered in the slowpath, after the kswapds are woken up.  But if remote
nodes still have free memory, kswapd should not be woken to rebalance the
local node or it may thrash cash or swap prematurely.

Fix this by adding one more unfair pass over the zonelist that is allowed
to spill to remote nodes after the local fairness pass fails but before
entering the slowpath and waking the kswapds.

This also gets rid of the GFP_THISNODE exemption from the fairness
protocol because the unfair pass is no longer tied to kswapd, which
GFP_THISNODE is not allowed to wake up.

However, because remote spills can be more frequent now - we prefer them
over local kswapd reclaim - the allocation batches on remote nodes could
underflow more heavily.  When resetting the batches, use
atomic_long_read() directly instead of zone_page_state() to calculate the
delta as the latter filters negative counter values.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@kernel.org>		[3.12+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 
 mm/page_alloc.c |   89 +++++++++++++++++++++++-----------------------
 2 files changed, 46 insertions(+), 44 deletions(-)

diff -puN mm/internal.h~mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd mm/internal.h
--- a/mm/internal.h~mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd
+++ a/mm/internal.h
@@ -370,5 +370,6 @@ unsigned long reclaim_clean_pages_from_l
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
 #define ALLOC_CMA		0x80 /* allow allocations from CMA areas */
+#define ALLOC_FAIR		0x100 /* fair zone allocation */
 
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/page_alloc.c~mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd
+++ a/mm/page_alloc.c
@@ -1239,15 +1239,6 @@ void drain_zone_pages(struct zone *zone,
 	}
 	local_irq_restore(flags);
 }
-static bool gfp_thisnode_allocation(gfp_t gfp_mask)
-{
-	return (gfp_mask & GFP_THISNODE) == GFP_THISNODE;
-}
-#else
-static bool gfp_thisnode_allocation(gfp_t gfp_mask)
-{
-	return false;
-}
 #endif
 
 /*
@@ -1584,12 +1575,7 @@ again:
 					  get_pageblock_migratetype(page));
 	}
 
-	/*
-	 * NOTE: GFP_THISNODE allocations do not partake in the kswapd
-	 * aging protocol, so they can't be fair.
-	 */
-	if (!gfp_thisnode_allocation(gfp_flags))
-		__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
@@ -1955,23 +1941,12 @@ zonelist_scan:
 		 * zone size to ensure fair page aging.  The zone a
 		 * page was allocated in should have no effect on the
 		 * time the page has in memory before being reclaimed.
-		 *
-		 * Try to stay in local zones in the fastpath.  If
-		 * that fails, the slowpath is entered, which will do
-		 * another pass starting with the local zones, but
-		 * ultimately fall back to remote zones that do not
-		 * partake in the fairness round-robin cycle of this
-		 * zonelist.
-		 *
-		 * NOTE: GFP_THISNODE allocations do not partake in
-		 * the kswapd aging protocol, so they can't be fair.
 		 */
-		if ((alloc_flags & ALLOC_WMARK_LOW) &&
-		    !gfp_thisnode_allocation(gfp_mask)) {
-			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
-				continue;
+		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
 				continue;
+			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
+				continue;
 		}
 		/*
 		 * When allocating a page cache page for writing, we
@@ -2409,32 +2384,40 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 	return page;
 }
 
-static void prepare_slowpath(gfp_t gfp_mask, unsigned int order,
-			     struct zonelist *zonelist,
-			     enum zone_type high_zoneidx,
-			     struct zone *preferred_zone)
+static void reset_alloc_batches(struct zonelist *zonelist,
+				enum zone_type high_zoneidx,
+				struct zone *preferred_zone)
 {
 	struct zoneref *z;
 	struct zone *zone;
 
 	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
-		if (!(gfp_mask & __GFP_NO_KSWAPD))
-			wakeup_kswapd(zone, order, zone_idx(preferred_zone));
 		/*
 		 * Only reset the batches of zones that were actually
-		 * considered in the fast path, we don't want to
-		 * thrash fairness information for zones that are not
+		 * considered in the fairness pass, we don't want to
+		 * trash fairness information for zones that are not
 		 * actually part of this zonelist's round-robin cycle.
 		 */
 		if (!zone_local(preferred_zone, zone))
 			continue;
 		mod_zone_page_state(zone, NR_ALLOC_BATCH,
-				    high_wmark_pages(zone) -
-				    low_wmark_pages(zone) -
-				    zone_page_state(zone, NR_ALLOC_BATCH));
+			high_wmark_pages(zone) - low_wmark_pages(zone) -
+			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
 	}
 }
 
+static void wake_all_kswapds(unsigned int order,
+			     struct zonelist *zonelist,
+			     enum zone_type high_zoneidx,
+			     struct zone *preferred_zone)
+{
+	struct zoneref *z;
+	struct zone *zone;
+
+	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
+		wakeup_kswapd(zone, order, zone_idx(preferred_zone));
+}
+
 static inline int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
@@ -2523,12 +2506,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 * allowed per node queues are empty and that nodes are
 	 * over allocated.
 	 */
-	if (gfp_thisnode_allocation(gfp_mask))
+	if (IS_ENABLED(CONFIG_NUMA) &&
+	    (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
 restart:
-	prepare_slowpath(gfp_mask, order, zonelist,
-			 high_zoneidx, preferred_zone);
+	if (!(gfp_mask & __GFP_NO_KSWAPD))
+		wake_all_kswapds(order, zonelist, high_zoneidx, preferred_zone);
 
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
@@ -2708,7 +2692,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	struct page *page = NULL;
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
-	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET;
+	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
 	struct mem_cgroup *memcg = NULL;
 
 	gfp_mask &= gfp_allowed_mask;
@@ -2749,12 +2733,29 @@ retry_cpuset:
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
+retry:
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
 			preferred_zone, migratetype);
 	if (unlikely(!page)) {
 		/*
+		 * The first pass makes sure allocations are spread
+		 * fairly within the local node.  However, the local
+		 * node might have free pages left after the fairness
+		 * batches are exhausted, and remote zones haven't
+		 * even been considered yet.  Try once more without
+		 * fairness, and include remote zones now, before
+		 * entering the slowpath and waking kswapd: prefer
+		 * spilling to a remote zone over swapping locally.
+		 */
+		if (alloc_flags & ALLOC_FAIR) {
+			reset_alloc_batches(zonelist, high_zoneidx,
+					    preferred_zone);
+			alloc_flags &= ~ALLOC_FAIR;
+			goto retry;
+		}
+		/*
 		 * Runtime PM, block IO and its error handling path
 		 * can deadlock because I/O on the device might not
 		 * complete.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-vmstat-fix-up-zone-state-accounting.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
lib-radix_tree-tree-node-interface-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch

