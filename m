From: akpm@linux-foundation.org
Subject: - slab-cache-alloc-cleanups.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:45:57 -0800
Message-ID: <200702112245.l1BMjv18015455@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbXBKWqc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, apw@shadowen.org, christoph@lameter.com, hch@lst.de, manfred@colorfullife.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: cache alloc cleanups
has been removed from the -mm tree.  Its filename was
     slab-cache-alloc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: cache alloc cleanups
From: Pekka Enberg <penberg@cs.helsinki.fi>

Clean up __cache_alloc and __cache_alloc_node functions a bit.  We no
longer need to do NUMA_BUILD tricks and the UMA allocation path is much
simpler.  No functional changes in this patch.

Note: saves few kernel text bytes on x86 NUMA build due to using gotos in
__cache_alloc_node() and moving __GFP_THISNODE check in to
fallback_alloc().

Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Christoph Lameter <christoph@lameter.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  200 ++++++++++++++++++++++++++++------------------------
 1 file changed, 110 insertions(+), 90 deletions(-)

diff -puN mm/slab.c~slab-cache-alloc-cleanups mm/slab.c
--- a/mm/slab.c~slab-cache-alloc-cleanups
+++ a/mm/slab.c
@@ -3189,35 +3189,6 @@ static inline void *____cache_alloc(stru
 	return objp;
 }
 
-static __always_inline void *__cache_alloc(struct kmem_cache *cachep,
-						gfp_t flags, void *caller)
-{
-	unsigned long save_flags;
-	void *objp = NULL;
-
-	cache_alloc_debugcheck_before(cachep, flags);
-
-	local_irq_save(save_flags);
-
-	if (unlikely(NUMA_BUILD &&
-			current->flags & (PF_SPREAD_SLAB | PF_MEMPOLICY)))
-		objp = alternate_node_alloc(cachep, flags);
-
-	if (!objp)
-		objp = ____cache_alloc(cachep, flags);
-	/*
-	 * We may just have run out of memory on the local node.
-	 * ____cache_alloc_node() knows how to locate memory on other nodes
-	 */
- 	if (NUMA_BUILD && !objp)
- 		objp = ____cache_alloc_node(cachep, flags, numa_node_id());
-	local_irq_restore(save_flags);
-	objp = cache_alloc_debugcheck_after(cachep, flags, objp,
-					    caller);
-	prefetchw(objp);
-	return objp;
-}
-
 #ifdef CONFIG_NUMA
 /*
  * Try allocating on another node if PF_SPREAD_SLAB|PF_MEMPOLICY.
@@ -3249,14 +3220,20 @@ static void *alternate_node_alloc(struct
  * allocator to do its reclaim / fallback magic. We then insert the
  * slab into the proper nodelist and then allocate from it.
  */
-void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
+static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 {
-	struct zonelist *zonelist = &NODE_DATA(slab_node(current->mempolicy))
-					->node_zonelists[gfp_zone(flags)];
+	struct zonelist *zonelist;
+	gfp_t local_flags;
 	struct zone **z;
 	void *obj = NULL;
 	int nid;
-	gfp_t local_flags = (flags & GFP_LEVEL_MASK);
+
+	if (flags & __GFP_THISNODE)
+		return NULL;
+
+	zonelist = &NODE_DATA(slab_node(current->mempolicy))
+			->node_zonelists[gfp_zone(flags)];
+	local_flags = (flags & GFP_LEVEL_MASK);
 
 retry:
 	/*
@@ -3366,16 +3343,110 @@ must_grow:
 	if (x)
 		goto retry;
 
-	if (!(flags & __GFP_THISNODE))
-		/* Unable to grow the cache. Fall back to other nodes. */
-		return fallback_alloc(cachep, flags);
-
-	return NULL;
+	return fallback_alloc(cachep, flags);
 
 done:
 	return obj;
 }
-#endif
+
+/**
+ * kmem_cache_alloc_node - Allocate an object on the specified node
+ * @cachep: The cache to allocate from.
+ * @flags: See kmalloc().
+ * @nodeid: node number of the target node.
+ * @caller: return address of caller, used for debug information
+ *
+ * Identical to kmem_cache_alloc but it will allocate memory on the given
+ * node, which can improve the performance for cpu bound structures.
+ *
+ * Fallback to other node is possible if __GFP_THISNODE is not set.
+ */
+static __always_inline void *
+__cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
+		   void *caller)
+{
+	unsigned long save_flags;
+	void *ptr;
+
+	cache_alloc_debugcheck_before(cachep, flags);
+	local_irq_save(save_flags);
+
+	if (unlikely(nodeid == -1))
+		nodeid = numa_node_id();
+
+	if (unlikely(!cachep->nodelists[nodeid])) {
+		/* Node not bootstrapped yet */
+		ptr = fallback_alloc(cachep, flags);
+		goto out;
+	}
+
+	if (nodeid == numa_node_id()) {
+		/*
+		 * Use the locally cached objects if possible.
+		 * However ____cache_alloc does not allow fallback
+		 * to other nodes. It may fail while we still have
+		 * objects on other nodes available.
+		 */
+		ptr = ____cache_alloc(cachep, flags);
+		if (ptr)
+			goto out;
+	}
+	/* ___cache_alloc_node can fall back to other nodes */
+	ptr = ____cache_alloc_node(cachep, flags, nodeid);
+  out:
+	local_irq_restore(save_flags);
+	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
+
+	return ptr;
+}
+
+static __always_inline void *
+__do_cache_alloc(struct kmem_cache *cache, gfp_t flags)
+{
+	void *objp;
+
+	if (unlikely(current->flags & (PF_SPREAD_SLAB | PF_MEMPOLICY))) {
+		objp = alternate_node_alloc(cache, flags);
+		if (objp)
+			goto out;
+	}
+	objp = ____cache_alloc(cache, flags);
+
+	/*
+	 * We may just have run out of memory on the local node.
+	 * ____cache_alloc_node() knows how to locate memory on other nodes
+	 */
+ 	if (!objp)
+ 		objp = ____cache_alloc_node(cache, flags, numa_node_id());
+
+  out:
+	return objp;
+}
+#else
+
+static __always_inline void *
+__do_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
+{
+	return ____cache_alloc(cachep, flags);
+}
+
+#endif /* CONFIG_NUMA */
+
+static __always_inline void *
+__cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
+{
+	unsigned long save_flags;
+	void *objp;
+
+	cache_alloc_debugcheck_before(cachep, flags);
+	local_irq_save(save_flags);
+	objp = __do_cache_alloc(cachep, flags);
+	local_irq_restore(save_flags);
+	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
+	prefetchw(objp);
+
+	return objp;
+}
 
 /*
  * Caller needs to acquire correct kmem_list's list_lock
@@ -3574,57 +3645,6 @@ out:
 }
 
 #ifdef CONFIG_NUMA
-/**
- * kmem_cache_alloc_node - Allocate an object on the specified node
- * @cachep: The cache to allocate from.
- * @flags: See kmalloc().
- * @nodeid: node number of the target node.
- * @caller: return address of caller, used for debug information
- *
- * Identical to kmem_cache_alloc but it will allocate memory on the given
- * node, which can improve the performance for cpu bound structures.
- *
- * Fallback to other node is possible if __GFP_THISNODE is not set.
- */
-static __always_inline void *
-__cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
-		int nodeid, void *caller)
-{
-	unsigned long save_flags;
-	void *ptr = NULL;
-
-	cache_alloc_debugcheck_before(cachep, flags);
-	local_irq_save(save_flags);
-
-	if (unlikely(nodeid == -1))
-		nodeid = numa_node_id();
-
-	if (likely(cachep->nodelists[nodeid])) {
-		if (nodeid == numa_node_id()) {
-			/*
-			 * Use the locally cached objects if possible.
-			 * However ____cache_alloc does not allow fallback
-			 * to other nodes. It may fail while we still have
-			 * objects on other nodes available.
-			 */
-			ptr = ____cache_alloc(cachep, flags);
-		}
-		if (!ptr) {
-			/* ___cache_alloc_node can fall back to other nodes */
-			ptr = ____cache_alloc_node(cachep, flags, nodeid);
-		}
-	} else {
-		/* Node not bootstrapped yet */
-		if (!(flags & __GFP_THISNODE))
-			ptr = fallback_alloc(cachep, flags);
-	}
-
-	local_irq_restore(save_flags);
-	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
-
-	return ptr;
-}
-
 void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 {
 	return __cache_alloc_node(cachep, flags, nodeid,
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
slab-use-cpu_lock_.patch
slab-leaks3-default-y.patch
