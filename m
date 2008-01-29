From: akpm@linux-foundation.org
Subject: - slab-fix-bootstrap-on-memoryless-node.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:02 -0800
Message-ID: <200801290148.m0T1m30p027322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbYA2Bs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, mel@csn.ul.ie, olaf@aepfle.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     slab: fix bootstrap on memoryless node
has been removed from the -mm tree.  Its filename was
     slab-fix-bootstrap-on-memoryless-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slab: fix bootstrap on memoryless node
From: Pekka Enberg <penberg@cs.helsinki.fi>

If the node we're booting on doesn't have memory, bootstrapping kmalloc()
caches resorts to fallback_alloc() which requires ->nodelists set for all
nodes.  Fix that by calling set_up_list3s() for CACHE_CACHE in
kmem_cache_init().

As kmem_getpages() is called with GFP_THISNODE set, this used to work before
because of breakage in 2.6.22 and before with GFP_THISNODE returning pages from
the wrong node if a node had no memory. So it may have worked accidentally and
in an unsafe manner because the pages would have been associated with the wrong
node which could trigger bug ons and locking troubles.

Tested-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: Olaf Hering <olaf@aepfle.de>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN mm/slab.c~slab-fix-bootstrap-on-memoryless-node mm/slab.c
--- a/mm/slab.c~slab-fix-bootstrap-on-memoryless-node
+++ a/mm/slab.c
@@ -304,11 +304,11 @@ struct kmem_list3 {
 /*
  * Need this for bootstrapping a per node allocator.
  */
-#define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
+#define NUM_INIT_LISTS (3 * MAX_NUMNODES)
 struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
-#define	SIZE_AC 1
-#define	SIZE_L3 (1 + MAX_NUMNODES)
+#define	SIZE_AC MAX_NUMNODES
+#define	SIZE_L3 (2 * MAX_NUMNODES)
 
 static int drain_freelist(struct kmem_cache *cache,
 			struct kmem_list3 *l3, int tofree);
@@ -1410,6 +1410,22 @@ static void init_list(struct kmem_cache 
 }
 
 /*
+ * For setting up all the kmem_list3s for cache whose buffer_size is same as
+ * size of kmem_list3.
+ */
+static void __init set_up_list3s(struct kmem_cache *cachep, int index)
+{
+	int node;
+
+	for_each_online_node(node) {
+		cachep->nodelists[node] = &initkmem_list3[index + node];
+		cachep->nodelists[node]->next_reap = jiffies +
+		    REAPTIMEOUT_LIST3 +
+		    ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
+	}
+}
+
+/*
  * Initialisation.  Called after the page allocator have been initialised and
  * before smp_init().
  */
@@ -1432,6 +1448,7 @@ void __init kmem_cache_init(void)
 		if (i < MAX_NUMNODES)
 			cache_cache.nodelists[i] = NULL;
 	}
+	set_up_list3s(&cache_cache, CACHE_CACHE);
 
 	/*
 	 * Fragmentation resistance on low memory - only use bigger
@@ -1587,10 +1604,9 @@ void __init kmem_cache_init(void)
 	{
 		int nid;
 
-		/* Replace the static kmem_list3 structures for the boot cpu */
-		init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], node);
-
 		for_each_online_node(nid) {
+			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], nid);
+
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);
 
@@ -1960,22 +1976,6 @@ static void slab_destroy(struct kmem_cac
 	}
 }
 
-/*
- * For setting up all the kmem_list3s for cache whose buffer_size is same as
- * size of kmem_list3.
- */
-static void __init set_up_list3s(struct kmem_cache *cachep, int index)
-{
-	int node;
-
-	for_each_online_node(node) {
-		cachep->nodelists[node] = &initkmem_list3[index + node];
-		cachep->nodelists[node]->next_reap = jiffies +
-		    REAPTIMEOUT_LIST3 +
-		    ((unsigned long)cachep) % REAPTIMEOUT_LIST3;
-	}
-}
-
 static void __kmem_cache_destroy(struct kmem_cache *cachep)
 {
 	int i;
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
git-net.patch
git-unionfs.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-restructure-slab-alloc.patch
slab-leaks3-default-y.patch
