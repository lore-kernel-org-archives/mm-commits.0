From: akpm@linux-foundation.org
Subject: - replace-highest_possible_node_id-with-nr_node_ids.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:16 -0800
Message-ID: <200702211045.l1LAjGiC006344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbXBUKph (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, frederik.deweerdt@gmail.com, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Replace highest_possible_node_id() with nr_node_ids
has been removed from the -mm tree.  Its filename was
     replace-highest_possible_node_id-with-nr_node_ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Replace highest_possible_node_id() with nr_node_ids
From: Christoph Lameter <clameter@sgi.com>

highest_possible_node_id() is currently used to calculate the last possible
node idso that the network subsystem can figure out how to size per node
arrays.

I think having the ability to determine the maximum amount of nodes in a
system at runtime is useful but then we should name this entry
correspondingly, it should return the number of node_ids, and the the value
needs to be setup only once on bootup.  The node_possible_map does not
change after bootup.

This patch introduces nr_node_ids and replaces the use of
highest_possible_node_id().  nr_node_ids is calculated on bootup when the
page allocators pagesets are initialized.

[deweerdt@free.fr: fix oops]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    4 ++--
 mm/page_alloc.c          |   35 +++++++++++++++++++++--------------
 net/sunrpc/svc.c         |    4 ++--
 3 files changed, 25 insertions(+), 18 deletions(-)

diff -puN include/linux/nodemask.h~replace-highest_possible_node_id-with-nr_node_ids include/linux/nodemask.h
--- a/include/linux/nodemask.h~replace-highest_possible_node_id-with-nr_node_ids
+++ a/include/linux/nodemask.h
@@ -352,7 +352,7 @@ extern nodemask_t node_possible_map;
 #define node_possible(node)	node_isset((node), node_possible_map)
 #define first_online_node	first_node(node_online_map)
 #define next_online_node(nid)	next_node((nid), node_online_map)
-int highest_possible_node_id(void);
+extern int nr_node_ids;
 #else
 #define num_online_nodes()	1
 #define num_possible_nodes()	1
@@ -360,7 +360,7 @@ int highest_possible_node_id(void);
 #define node_possible(node)	((node) == 0)
 #define first_online_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
-#define highest_possible_node_id()	0
+#define nr_node_ids		1
 #endif
 
 #define any_online_node(mask)			\
diff -puN mm/page_alloc.c~replace-highest_possible_node_id-with-nr_node_ids mm/page_alloc.c
--- a/mm/page_alloc.c~replace-highest_possible_node_id-with-nr_node_ids
+++ a/mm/page_alloc.c
@@ -664,6 +664,26 @@ static int rmqueue_bulk(struct zone *zon
 	return i;
 }
 
+#if MAX_NUMNODES > 1
+int nr_node_ids __read_mostly;
+EXPORT_SYMBOL(nr_node_ids);
+
+/*
+ * Figure out the number of possible node ids.
+ */
+static void __init setup_nr_node_ids(void)
+{
+	unsigned int node;
+	unsigned int highest = 0;
+
+	for_each_node_mask(node, node_possible_map)
+		highest = node;
+	nr_node_ids = highest + 1;
+}
+#else
+static void __init setup_nr_node_ids(void) {}
+#endif
+
 #ifdef CONFIG_NUMA
 /*
  * Called from the slab reaper to drain pagesets on a particular node that
@@ -3169,6 +3189,7 @@ static int __init init_per_zone_pages_mi
 		min_free_kbytes = 65536;
 	setup_per_zone_pages_min();
 	setup_per_zone_lowmem_reserve();
+	setup_nr_node_ids();
 	return 0;
 }
 module_init(init_per_zone_pages_min)
@@ -3370,18 +3391,4 @@ EXPORT_SYMBOL(pfn_to_page);
 EXPORT_SYMBOL(page_to_pfn);
 #endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
 
-#if MAX_NUMNODES > 1
-/*
- * Find the highest possible node id.
- */
-int highest_possible_node_id(void)
-{
-	unsigned int node;
-	unsigned int highest = 0;
 
-	for_each_node_mask(node, node_possible_map)
-		highest = node;
-	return highest;
-}
-EXPORT_SYMBOL(highest_possible_node_id);
-#endif
diff -puN net/sunrpc/svc.c~replace-highest_possible_node_id-with-nr_node_ids net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~replace-highest_possible_node_id-with-nr_node_ids
+++ a/net/sunrpc/svc.c
@@ -115,7 +115,7 @@ fail:
 static int
 svc_pool_map_init_percpu(struct svc_pool_map *m)
 {
-	unsigned int maxpools = highest_possible_processor_id()+1;
+	unsigned int maxpools = highest_possible_processor_id() + 1;
 	unsigned int pidx = 0;
 	unsigned int cpu;
 	int err;
@@ -143,7 +143,7 @@ svc_pool_map_init_percpu(struct svc_pool
 static int
 svc_pool_map_init_pernode(struct svc_pool_map *m)
 {
-	unsigned int maxpools = highest_possible_node_id()+1;
+	unsigned int maxpools = nr_node_ids;
 	unsigned int pidx = 0;
 	unsigned int node;
 	int err;
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
