From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch removed from -mm tree
Date: Thu, 06 Mar 2014 12:37:57 -0800
Message-ID: <5318dca5.AwhU/92X21JgbpdE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaCFUh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@kernel.org, riel@redhat.com, mgorman@suse.de, jstancek@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch removed from -mm tree
To: hannes@cmpxchg.org,jstancek@redhat.com,mgorman@suse.de,riel@redhat.com,stable@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:57 -0800


The patch titled
     Subject: mm: page_alloc: exempt GFP_THISNODE allocations from zone fairness
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: exempt GFP_THISNODE allocations from zone fairness

Jan Stancek reports manual page migration encountering allocation failures
after some pages when there is still plenty of memory free, and bisected
the problem down to 81c0a2bb515f ("mm: page_alloc: fair zone allocator
policy").

The problem is that GFP_THISNODE obeys the zone fairness allocation
batches on one hand, but doesn't reset them and wake kswapd on the other
hand.  After a few of those allocations, the batches are exhausted and the
allocations fail.

Fixing this means either having GFP_THISNODE wake up kswapd, or
GFP_THISNODE not participating in zone fairness at all.  The latter seems
safer as an acute bugfix, we can clean up later.

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@kernel.org>		[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2
+++ a/mm/page_alloc.c
@@ -1238,6 +1238,15 @@ void drain_zone_pages(struct zone *zone,
 	}
 	local_irq_restore(flags);
 }
+static bool gfp_thisnode_allocation(gfp_t gfp_mask)
+{
+	return (gfp_mask & GFP_THISNODE) == GFP_THISNODE;
+}
+#else
+static bool gfp_thisnode_allocation(gfp_t gfp_mask)
+{
+	return false;
+}
 #endif
 
 /*
@@ -1574,7 +1583,13 @@ again:
 					  get_pageblock_migratetype(page));
 	}
 
-	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+	/*
+	 * NOTE: GFP_THISNODE allocations do not partake in the kswapd
+	 * aging protocol, so they can't be fair.
+	 */
+	if (!gfp_thisnode_allocation(gfp_flags))
+		__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
@@ -1946,8 +1961,12 @@ zonelist_scan:
 		 * ultimately fall back to remote zones that do not
 		 * partake in the fairness round-robin cycle of this
 		 * zonelist.
+		 *
+		 * NOTE: GFP_THISNODE allocations do not partake in
+		 * the kswapd aging protocol, so they can't be fair.
 		 */
-		if (alloc_flags & ALLOC_WMARK_LOW) {
+		if ((alloc_flags & ALLOC_WMARK_LOW) &&
+		    !gfp_thisnode_allocation(gfp_mask)) {
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
 			if (!zone_local(preferred_zone, zone))
@@ -2503,8 +2522,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 * allowed per node queues are empty and that nodes are
 	 * over allocated.
 	 */
-	if (IS_ENABLED(CONFIG_NUMA) &&
-			(gfp_mask & GFP_THISNODE) == GFP_THISNODE)
+	if (gfp_thisnode_allocation(gfp_mask))
 		goto nopage;
 
 restart:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
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
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
mm-fix-gfp_thisnode-callers-and-clarify.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

