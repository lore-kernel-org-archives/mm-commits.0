From: akpm@osdl.org
Subject: + slab-cache_grow-cleanup.patch added to -mm tree
Date: Fri, 12 Jan 2007 01:35:17 -0800
Message-ID: <200701120935.l0C9ZHNo016592@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47346 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161051AbXALJfb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 04:35:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, hugh@veritas.com


The patch titled
     slab: cache_grow cleanup
has been added to the -mm tree.  Its filename is
     slab-cache_grow-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab: cache_grow cleanup
From: Pekka Enberg <penberg@cs.helsinki.fi>

The current implementation of cache_grow() has to either (1) use
pre-allocated memory for the slab or (2) allocate the memory itself which
makes the error paths messy.  Move __GFP_NO_GROW and __GFP_WAIT processing
to kmem_getpages() and introduce a new __cache_grow() variant that expects
the memory for a new slab to always be handed over in the 'objp' parameter.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |  109 +++++++++++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 52 deletions(-)

diff -puN mm/slab.c~slab-cache_grow-cleanup mm/slab.c
--- a/mm/slab.c~slab-cache_grow-cleanup
+++ a/mm/slab.c
@@ -1597,6 +1597,14 @@ static int __init cpucache_init(void)
 }
 __initcall(cpucache_init);
 
+static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
+{
+	if (flags & GFP_DMA)
+		BUG_ON(!(cachep->gfpflags & GFP_DMA));
+	else
+		BUG_ON(cachep->gfpflags & GFP_DMA);
+}
+
 /*
  * Interface to system's page allocator. No need to hold the cache-lock.
  *
@@ -1608,8 +1616,22 @@ static void *kmem_getpages(struct kmem_c
 {
 	struct page *page;
 	int nr_pages;
+	void *ret;
 	int i;
 
+	if (flags & __GFP_NO_GROW)
+		return NULL;
+
+	/*
+	 * The test for missing atomic flag is performed here, rather than
+	 * the more obvious place, simply to reduce the critical path length
+	 * in kmem_cache_alloc(). If a caller is seriously mis-behaving they
+	 * will eventually be caught here (where it matters).
+	 */
+	kmem_flagcheck(cachep, flags);
+	if (flags & __GFP_WAIT)
+		local_irq_enable();
+
 #ifndef CONFIG_MMU
 	/*
 	 * Nommu uses slab's for process anonymous memory allocations, and thus
@@ -1621,8 +1643,10 @@ static void *kmem_getpages(struct kmem_c
 	flags |= cachep->gfpflags;
 
 	page = alloc_pages_node(nodeid, flags, cachep->gfporder);
-	if (!page)
-		return NULL;
+	if (!page) {
+		ret = NULL;
+		goto out;
+	}
 
 	nr_pages = (1 << cachep->gfporder);
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
@@ -1633,7 +1657,12 @@ static void *kmem_getpages(struct kmem_c
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 	for (i = 0; i < nr_pages; i++)
 		__SetPageSlab(page + i);
-	return page_address(page);
+
+	ret = page_address(page);
+  out:
+	if (flags & __GFP_WAIT)
+		local_irq_disable();
+	return ret;
 }
 
 /*
@@ -2641,14 +2670,6 @@ static void cache_init_objs(struct kmem_
 	slabp->free = 0;
 }
 
-static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
-{
-	if (flags & GFP_DMA)
-		BUG_ON(!(cachep->gfpflags & GFP_DMA));
-	else
-		BUG_ON(cachep->gfpflags & GFP_DMA);
-}
-
 static void *slab_get_obj(struct kmem_cache *cachep, struct slab *slabp,
 				int nodeid)
 {
@@ -2714,7 +2735,7 @@ static void slab_map_pages(struct kmem_c
  * Grow (by 1) the number of slabs within a cache.  This is called by
  * kmem_cache_alloc() when there are no active objs left in a cache.
  */
-static int cache_grow(struct kmem_cache *cachep,
+static int __cache_grow(struct kmem_cache *cachep,
 		gfp_t flags, int nodeid, void *objp)
 {
 	struct slab *slabp;
@@ -2754,39 +2775,17 @@ static int cache_grow(struct kmem_cache 
 
 	offset *= cachep->colour_off;
 
-	if (local_flags & __GFP_WAIT)
-		local_irq_enable();
-
-	/*
-	 * The test for missing atomic flag is performed here, rather than
-	 * the more obvious place, simply to reduce the critical path length
-	 * in kmem_cache_alloc(). If a caller is seriously mis-behaving they
-	 * will eventually be caught here (where it matters).
-	 */
-	kmem_flagcheck(cachep, flags);
-
-	/*
-	 * Get mem for the objs.  Attempt to allocate a physical page from
-	 * 'nodeid'.
-	 */
-	if (!objp)
-		objp = kmem_getpages(cachep, flags, nodeid);
-	if (!objp)
-		goto failed;
-
 	/* Get slab management. */
 	slabp = alloc_slabmgmt(cachep, objp, offset,
 			local_flags & ~GFP_THISNODE, nodeid);
 	if (!slabp)
-		goto opps1;
+		return 0;
 
 	slabp->nodeid = nodeid;
 	slab_map_pages(cachep, slabp, objp);
 
 	cache_init_objs(cachep, slabp, ctor_flags);
 
-	if (local_flags & __GFP_WAIT)
-		local_irq_disable();
 	check_irq_off();
 	spin_lock(&l3->list_lock);
 
@@ -2796,12 +2795,25 @@ static int cache_grow(struct kmem_cache 
 	l3->free_objects += cachep->num;
 	spin_unlock(&l3->list_lock);
 	return 1;
-opps1:
-	kmem_freepages(cachep, objp);
-failed:
-	if (local_flags & __GFP_WAIT)
-		local_irq_disable();
-	return 0;
+}
+
+static int cache_grow(struct kmem_cache *cachep, gfp_t flags, int nodeid)
+{
+	void *objp;
+	int ret;
+
+	/*
+	 * Get mem for the objs.  Attempt to allocate a physical page from
+	 * 'nodeid'.
+	 */
+	objp = kmem_getpages(cachep, flags, nodeid);
+	if (!objp)
+		return 0;
+
+	ret = __cache_grow(cachep, flags, nodeid, objp);
+	if (!ret)
+		kmem_freepages(cachep, objp);
+	return ret;
 }
 
 #if DEBUG
@@ -3006,7 +3018,7 @@ alloc_done:
 
 	if (unlikely(!ac->avail)) {
 		int x;
-		x = cache_grow(cachep, flags | GFP_THISNODE, node, NULL);
+		x = cache_grow(cachep, flags | GFP_THISNODE, node);
 
 		/* cache_grow can reenable interrupts, then ac could change. */
 		ac = cpu_cache_get(cachep);
@@ -3223,7 +3235,6 @@ static void *alternate_node_alloc(struct
 static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 {
 	struct zonelist *zonelist;
-	gfp_t local_flags;
 	struct zone **z;
 	void *obj = NULL;
 	int nid;
@@ -3233,7 +3244,6 @@ static void *fallback_alloc(struct kmem_
 
 	zonelist = &NODE_DATA(slab_node(current->mempolicy))
 			->node_zonelists[gfp_zone(flags)];
-	local_flags = (flags & GFP_LEVEL_MASK);
 
 retry:
 	/*
@@ -3257,18 +3267,13 @@ retry:
 		 * We may trigger various forms of reclaim on the allowed
 		 * set and go into memory reserves if necessary.
 		 */
-		if (local_flags & __GFP_WAIT)
-			local_irq_enable();
-		kmem_flagcheck(cache, flags);
 		obj = kmem_getpages(cache, flags, -1);
-		if (local_flags & __GFP_WAIT)
-			local_irq_disable();
 		if (obj) {
 			/*
 			 * Insert into the appropriate per node queues
 			 */
 			nid = page_to_nid(virt_to_page(obj));
-			if (cache_grow(cache, flags, nid, obj)) {
+			if (__cache_grow(cache, flags, nid, obj)) {
 				obj = ____cache_alloc_node(cache,
 					flags | GFP_THISNODE, nid);
 				if (!obj)
@@ -3279,7 +3284,7 @@ retry:
 					 */
 					goto retry;
 			} else {
-				/* cache_grow already freed obj */
+				kmem_freepages(cache, obj);
 				obj = NULL;
 			}
 		}
@@ -3339,7 +3344,7 @@ retry:
 
 must_grow:
 	spin_unlock(&l3->list_lock);
-	x = cache_grow(cachep, flags | GFP_THISNODE, nodeid, NULL);
+	x = cache_grow(cachep, flags | GFP_THISNODE, nodeid);
 	if (x)
 		goto retry;
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-remove-broken-pageslab-check-from-kfree_debugcheck.patch
slab-cache-alloc-cleanups.patch
slab-cache_grow-cleanup.patch
slab-use-cpu_lock_.patch
slab-leaks3-default-y.patch
