From: akpm@linux-foundation.org
Subject: - use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:47 -0700
Message-ID: <200705080001.l4801lKp008793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967310AbXEHABu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use ZVC counters to establish exact size of dirtyable pages
has been removed from the -mm tree.  Its filename was
     use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use ZVC counters to establish exact size of dirtyable pages
From: Christoph Lameter <clameter@sgi.com>

We can use the global ZVC counters to establish the exact size of the LRU
and the free pages.  This allows a more accurate determination of the dirty
ratio.

This patch will fix the broken ratio calculations if large amounts of
memory are allocated to huge pags or other consumers that do not put the
pages on to the LRU.

Notes:
- I did not add NR_SLAB_RECLAIMABLE to the calculation of the
  dirtyable pages. Those may be reclaimable but they are at this
  point not dirtyable. If NR_SLAB_RECLAIMABLE would be considered
  then a huge number of reclaimable pages would stop writeback
  from occurring.

- This patch used to be in mm as the last one in a series of patches.
  It was removed when Linus updated the treatment of highmem because
  there was a conflict. I updated the patch to follow Linus' approach.
  This patch is neede to fulfill the claims made in the beginning of the
  patchset that is now in Linus' tree.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   50 +++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff -puN mm/page-writeback.c~use-zvc-counters-to-establish-exact-size-of-dirtyable-pages mm/page-writeback.c
--- a/mm/page-writeback.c~use-zvc-counters-to-establish-exact-size-of-dirtyable-pages
+++ a/mm/page-writeback.c
@@ -119,6 +119,44 @@ static void background_writeout(unsigned
  * We make sure that the background writeout level is below the adjusted
  * clamping level.
  */
+
+static unsigned long highmem_dirtyable_memory(unsigned long total)
+{
+#ifdef CONFIG_HIGHMEM
+	int node;
+	unsigned long x = 0;
+
+	for_each_online_node(node) {
+		struct zone *z =
+			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+
+		x += zone_page_state(z, NR_FREE_PAGES)
+			+ zone_page_state(z, NR_INACTIVE)
+			+ zone_page_state(z, NR_ACTIVE);
+	}
+	/*
+	 * Make sure that the number of highmem pages is never larger
+	 * than the number of the total dirtyable memory. This can only
+	 * occur in very strange VM situations but we want to make sure
+	 * that this does not occur.
+	 */
+	return min(x, total);
+#else
+	return 0;
+#endif
+}
+
+static unsigned long determine_dirtyable_memory(void)
+{
+	unsigned long x;
+
+	x = global_page_state(NR_FREE_PAGES)
+		+ global_page_state(NR_INACTIVE)
+		+ global_page_state(NR_ACTIVE);
+	x -= highmem_dirtyable_memory(x);
+	return x + 1;	/* Ensure that we never return 0 */
+}
+
 static void
 get_dirty_limits(long *pbackground, long *pdirty,
 					struct address_space *mapping)
@@ -128,20 +166,12 @@ get_dirty_limits(long *pbackground, long
 	int unmapped_ratio;
 	long background;
 	long dirty;
-	unsigned long available_memory = vm_total_pages;
+	unsigned long available_memory = determine_dirtyable_memory();
 	struct task_struct *tsk;
 
-#ifdef CONFIG_HIGHMEM
-	/*
-	 * We always exclude high memory from our count.
-	 */
-	available_memory -= totalhigh_pages;
-#endif
-
-
 	unmapped_ratio = 100 - ((global_page_state(NR_FILE_MAPPED) +
 				global_page_state(NR_ANON_PAGES)) * 100) /
-					vm_total_pages;
+					available_memory;
 
 	dirty_ratio = vm_dirty_ratio;
 	if (dirty_ratio > unmapped_ratio / 2)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
