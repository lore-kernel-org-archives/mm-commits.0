From: akpm@linux-foundation.org
Subject: + slab-fix-bootstrap-on-memoryless-node.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:06:28 -0800
Message-ID: <200801270506.m0R56QPr030627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40086 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbYA0FHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:07:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, mel@csn.ul.ie, olaf@aepfle.de, stable@kernel.org


The patch titled
     slab: fix bootstrap on memoryless node
has been added to the -mm tree.  Its filename is
     slab-fix-bootstrap-on-memoryless-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

slab-partially-revert-list3-changes.patch
slab-fix-bootstrap-on-memoryless-node.patch
fix-slab-kmem_list3-for-booting-on-machines-with-memoryless-nodes-full-revert-of-04231b3002ac53f8a64a7bd142fde3fa4b6808c6.patch
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
