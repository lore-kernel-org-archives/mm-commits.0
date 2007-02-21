From: akpm@linux-foundation.org
Subject: - slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:20 -0800
Message-ID: <200702211045.l1LAjKRK006350@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46816 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468AbXBUKp0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: reduce size of alien cache to cover only possible nodes
has been removed from the -mm tree.  Its filename was
     slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: reduce size of alien cache to cover only possible nodes
From: Christoph Lameter <clameter@sgi.com>

The alien cache is a per cpu per node array allocated for every slab on the
system.  Currently we size this array for all nodes that the kernel does
support.  For IA64 this is 1024 nodes.  So we allocate an array with 1024
objects even if we only boot a system with 4 nodes.

This patch uses "nr_node_ids" to determine the number of possible nodes
supported by a hardware configuration and only allocates an alien cache
sized for possible nodes.

The initialization of nr_node_ids occurred too late relative to the bootstrap
of the slab allocator and so I moved the setup_nr_node_ids() into
free_area_init_nodes().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 mm/slab.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes mm/page_alloc.c
--- a/mm/page_alloc.c~slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes
+++ a/mm/page_alloc.c
@@ -2964,6 +2964,7 @@ void __init free_area_init_nodes(unsigne
 						early_node_map[i].end_pfn);
 
 	/* Initialise every node */
+	setup_nr_node_ids();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid, pgdat, NULL,
@@ -3189,7 +3190,6 @@ static int __init init_per_zone_pages_mi
 		min_free_kbytes = 65536;
 	setup_per_zone_pages_min();
 	setup_per_zone_lowmem_reserve();
-	setup_nr_node_ids();
 	return 0;
 }
 module_init(init_per_zone_pages_min)
diff -puN mm/slab.c~slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes mm/slab.c
--- a/mm/slab.c~slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes
+++ a/mm/slab.c
@@ -1042,7 +1042,7 @@ static void *alternate_node_alloc(struct
 static struct array_cache **alloc_alien_cache(int node, int limit)
 {
 	struct array_cache **ac_ptr;
-	int memsize = sizeof(void *) * MAX_NUMNODES;
+	int memsize = sizeof(void *) * nr_node_ids;
 	int i;
 
 	if (limit > 1)
_

Patches currently in -mm which might be from clameter@sgi.com are

use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
add-nr_mlock-zvc.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure-fix.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
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
