From: akpm@osdl.org
Subject: - slab-better-fallback-allocation-behavior.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:28 -0800
Message-ID: <200612072258.kB7MwS73029409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50749 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163647AbWLGW6b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: better fallback allocation behavior
has been removed from the -mm tree.  Its filename was
     slab-better-fallback-allocation-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: better fallback allocation behavior
From: Christoph Lameter <clameter@sgi.com>

Currently we simply attempt to allocate from all allowed nodes using
GFP_THISNODE.  However, GFP_THISNODE does not do reclaim (it wont do any at
all if the recent GFP_THISNODE patch is accepted).  If we truly run out of
memory in the whole system then fallback_alloc may return NULL although
memory may still be available if we would perform more thorough reclaim.

This patch changes fallback_alloc() so that we first only inspect all the
per node queues for available slabs.  If we find any then we allocate from
those.  This avoids slab fragmentation by first getting rid of all partial
allocated slabs on every node before allocating new memory.

If we cannot satisfy the allocation from any per node queue then we extend
a slab.  We now call into the page allocator without specifying
GFP_THISNODE.  The page allocator will then implement its own fallback (in
the given cpuset context), perform necessary reclaim (again considering not
a single node but the whole set of allowed nodes) and then return pages for
a new slab.

We identify from which node the pages were allocated and then insert the
pages into the corresponding per node structure.  In order to do so we need
to modify cache_grow() to take a parameter that specifies the new slab. 
kmem_getpages() can no longer set the GFP_THISNODE flag since we need to be
able to use kmem_getpage to allocate from an arbitrary node.  GFP_THISNODE
needs to be specified when calling cache_grow().

One key advantage is that the decision from which node to allocate new
memory is removed from slab fallback processing.  The patch allows to go
back to use of the page allocators fallback/reclaim logic.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |   79 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff -puN mm/slab.c~slab-better-fallback-allocation-behavior mm/slab.c
--- a/mm/slab.c~slab-better-fallback-allocation-behavior
+++ a/mm/slab.c
@@ -1605,12 +1605,7 @@ static void *kmem_getpages(struct kmem_c
 	flags |= __GFP_COMP;
 #endif
 
-	/*
-	 * Under NUMA we want memory on the indicated node. We will handle
-	 * the needed fallback ourselves since we want to serve from our
-	 * per node object lists first for other nodes.
-	 */
-	flags |= cachep->gfpflags | GFP_THISNODE;
+	flags |= cachep->gfpflags;
 
 	page = alloc_pages_node(nodeid, flags, cachep->gfporder);
 	if (!page)
@@ -2567,7 +2562,7 @@ static struct slab *alloc_slabmgmt(struc
 	if (OFF_SLAB(cachep)) {
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
-					      local_flags, nodeid);
+					      local_flags & ~GFP_THISNODE, nodeid);
 		if (!slabp)
 			return NULL;
 	} else {
@@ -2708,10 +2703,10 @@ static void slab_map_pages(struct kmem_c
  * Grow (by 1) the number of slabs within a cache.  This is called by
  * kmem_cache_alloc() when there are no active objs left in a cache.
  */
-static int cache_grow(struct kmem_cache *cachep, gfp_t flags, int nodeid)
+static int cache_grow(struct kmem_cache *cachep,
+		gfp_t flags, int nodeid, void *objp)
 {
 	struct slab *slabp;
-	void *objp;
 	size_t offset;
 	gfp_t local_flags;
 	unsigned long ctor_flags;
@@ -2763,12 +2758,14 @@ static int cache_grow(struct kmem_cache 
 	 * Get mem for the objs.  Attempt to allocate a physical page from
 	 * 'nodeid'.
 	 */
-	objp = kmem_getpages(cachep, flags, nodeid);
+	if (!objp)
+		objp = kmem_getpages(cachep, flags, nodeid);
 	if (!objp)
 		goto failed;
 
 	/* Get slab management. */
-	slabp = alloc_slabmgmt(cachep, objp, offset, local_flags, nodeid);
+	slabp = alloc_slabmgmt(cachep, objp, offset,
+			local_flags & ~GFP_THISNODE, nodeid);
 	if (!slabp)
 		goto opps1;
 
@@ -3006,7 +3003,7 @@ alloc_done:
 
 	if (unlikely(!ac->avail)) {
 		int x;
-		x = cache_grow(cachep, flags, node);
+		x = cache_grow(cachep, flags | GFP_THISNODE, node, NULL);
 
 		/* cache_grow can reenable interrupts, then ac could change. */
 		ac = cpu_cache_get(cachep);
@@ -3166,9 +3163,11 @@ static void *alternate_node_alloc(struct
 
 /*
  * Fallback function if there was no memory available and no objects on a
- * certain node and we are allowed to fall back. We mimick the behavior of
- * the page allocator. We fall back according to a zonelist determined by
- * the policy layer while obeying cpuset constraints.
+ * certain node and fall back is permitted. First we scan all the
+ * available nodelists for available objects. If that fails then we
+ * perform an allocation without specifying a node. This allows the page
+ * allocator to do its reclaim / fallback magic. We then insert the
+ * slab into the proper nodelist and then allocate from it.
  */
 void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 {
@@ -3176,15 +3175,51 @@ void *fallback_alloc(struct kmem_cache *
 					->node_zonelists[gfp_zone(flags)];
 	struct zone **z;
 	void *obj = NULL;
+	int nid;
 
+retry:
+	/*
+	 * Look through allowed nodes for objects available
+	 * from existing per node queues.
+	 */
 	for (z = zonelist->zones; *z && !obj; z++) {
-		int nid = zone_to_nid(*z);
+		nid = zone_to_nid(*z);
+
+		if (cpuset_zone_allowed(*z, flags) &&
+			cache->nodelists[nid] &&
+			cache->nodelists[nid]->free_objects)
+				obj = ____cache_alloc_node(cache,
+					flags | GFP_THISNODE, nid);
+	}
 
-		if (zone_idx(*z) <= ZONE_NORMAL &&
-				cpuset_zone_allowed(*z, flags) &&
-				cache->nodelists[nid])
-			obj = ____cache_alloc_node(cache,
-					flags | __GFP_THISNODE, nid);
+	if (!obj) {
+		/*
+		 * This allocation will be performed within the constraints
+		 * of the current cpuset / memory policy requirements.
+		 * We may trigger various forms of reclaim on the allowed
+		 * set and go into memory reserves if necessary.
+		 */
+		obj = kmem_getpages(cache, flags, -1);
+		if (obj) {
+			/*
+			 * Insert into the appropriate per node queues
+			 */
+			nid = page_to_nid(virt_to_page(obj));
+			if (cache_grow(cache, flags, nid, obj)) {
+				obj = ____cache_alloc_node(cache,
+					flags | GFP_THISNODE, nid);
+				if (!obj)
+					/*
+					 * Another processor may allocate the
+					 * objects in the slab since we are
+					 * not holding any locks.
+					 */
+					goto retry;
+			} else {
+				kmem_freepages(cache, obj);
+				obj = NULL;
+			}
+		}
 	}
 	return obj;
 }
@@ -3241,7 +3276,7 @@ retry:
 
 must_grow:
 	spin_unlock(&l3->list_lock);
-	x = cache_grow(cachep, flags, nodeid);
+	x = cache_grow(cachep, flags | GFP_THISNODE, nodeid, NULL);
 	if (x)
 		goto retry;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
ia64-resolve-name-clash-by-renaming-is_available_memory.patch
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
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

