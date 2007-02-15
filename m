From: akpm@linux-foundation.org
Subject: + use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch added to -mm tree
Date: Wed, 14 Feb 2007 20:42:36 -0800
Message-ID: <200702150442.l1F4gan4019977@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXBOEmj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 23:42:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Use ZVC counters to establish exact size of dirtyable pages
has been added to the -mm tree.  Its filename is
     use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 mm/page-writeback.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff -puN mm/page-writeback.c~use-zvc-counters-to-establish-exact-size-of-dirtyable-pages mm/page-writeback.c
--- a/mm/page-writeback.c~use-zvc-counters-to-establish-exact-size-of-dirtyable-pages
+++ a/mm/page-writeback.c
@@ -119,6 +119,38 @@ static void background_writeout(unsigned
  * We make sure that the background writeout level is below the adjusted
  * clamping level.
  */
+
+static unsigned long highmem_dirtyable_memory(void)
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
+	return x;
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
+		+ global_page_state(NR_ACTIVE)
+		- highmem_dirtyable_memory();
+	return x;
+}
+
 static void
 get_dirty_limits(long *pbackground, long *pdirty,
 					struct address_space *mapping)
@@ -128,17 +160,9 @@ get_dirty_limits(long *pbackground, long
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
 					vm_total_pages;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
