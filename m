From: akpm@osdl.org
Subject: + replace-highest_possible_node_id-with-nr_node_ids.patch added to -mm tree
Date: Wed, 24 Jan 2007 00:39:57 -0800
Message-ID: <200701240839.l0O8dvx4012904@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965391AbXAXIka (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 03:40:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     Replace highest_possible_node_id() with nr_node_ids
has been added to the -mm tree.  Its filename is
     replace-highest_possible_node_id-with-nr_node_ids.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Replace highest_possible_node_id() with nr_node_ids
From: Christoph Lameter <clameter@sgi.com>

highest_possible_node_id() currently used to calculate the last possible
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

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
@@ -3204,6 +3224,7 @@ static int __init init_per_zone_pages_mi
 		min_free_kbytes = 65536;
 	setup_per_zone_pages_min();
 	setup_per_zone_lowmem_reserve();
+	setup_nr_node_ids();
 	return 0;
 }
 module_init(init_per_zone_pages_min)
@@ -3405,18 +3426,4 @@ EXPORT_SYMBOL(pfn_to_page);
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
@@ -116,7 +116,7 @@ fail:
 static int
 svc_pool_map_init_percpu(struct svc_pool_map *m)
 {
-	unsigned int maxpools = highest_possible_processor_id()+1;
+	unsigned int maxpools = nr_node_ids;
 	unsigned int pidx = 0;
 	unsigned int cpu;
 	int err;
@@ -144,7 +144,7 @@ svc_pool_map_init_percpu(struct svc_pool
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

mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch
slab-cache_grow-cleanup.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
