From: akpm@linux-foundation.org
Subject: [merged] mm-slab-separate-cache_grow-to-two-parts.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:03:32 -0700
Message-ID: <573f7ba4.d+y73g576q3NCsS3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: separate cache_grow() to two parts
has been removed from the -mm tree.  Its filename was
     mm-slab-separate-cache_grow-to-two-parts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: separate cache_grow() to two parts

This is a preparation step to implement lockless allocation path when
there is no free objects in kmem_cache.  What we'd like to do here is to
refill cpu cache without holding a node lock.  To accomplish this purpose,
refill should be done after new slab allocation but before attaching the
slab to the management list.  So, this patch separates cache_grow() to two
parts, allocation and attaching to the list in order to add some code
inbetween them in the following patch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   74 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 22 deletions(-)

diff -puN mm/slab.c~mm-slab-separate-cache_grow-to-two-parts mm/slab.c
--- a/mm/slab.c~mm-slab-separate-cache_grow-to-two-parts
+++ a/mm/slab.c
@@ -213,6 +213,11 @@ static void slabs_destroy(struct kmem_ca
 static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp);
 static void cache_reap(struct work_struct *unused);
 
+static inline void fixup_objfreelist_debug(struct kmem_cache *cachep,
+						void **list);
+static inline void fixup_slab_list(struct kmem_cache *cachep,
+				struct kmem_cache_node *n, struct page *page,
+				void **list);
 static int slab_early_init = 1;
 
 #define INDEX_NODE kmalloc_index(sizeof(struct kmem_cache_node))
@@ -1810,7 +1815,7 @@ static size_t calculate_slab_order(struc
 
 			/*
 			 * Needed to avoid possible looping condition
-			 * in cache_grow()
+			 * in cache_grow_begin()
 			 */
 			if (OFF_SLAB(freelist_cache))
 				continue;
@@ -2556,7 +2561,8 @@ static void slab_map_pages(struct kmem_c
  * Grow (by 1) the number of slabs within a cache.  This is called by
  * kmem_cache_alloc() when there are no active objs left in a cache.
  */
-static int cache_grow(struct kmem_cache *cachep, gfp_t flags, int nodeid)
+static struct page *cache_grow_begin(struct kmem_cache *cachep,
+				gfp_t flags, int nodeid)
 {
 	void *freelist;
 	size_t offset;
@@ -2622,21 +2628,40 @@ static int cache_grow(struct kmem_cache
 
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
-	check_irq_off();
-	spin_lock(&n->list_lock);
 
-	/* Make slab active. */
-	list_add_tail(&page->lru, &(n->slabs_free));
-	STATS_INC_GROWN(cachep);
-	n->free_objects += cachep->num;
-	spin_unlock(&n->list_lock);
-	return page_node;
+	return page;
+
 opps1:
 	kmem_freepages(cachep, page);
 failed:
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
-	return -1;
+	return NULL;
+}
+
+static void cache_grow_end(struct kmem_cache *cachep, struct page *page)
+{
+	struct kmem_cache_node *n;
+	void *list = NULL;
+
+	check_irq_off();
+
+	if (!page)
+		return;
+
+	INIT_LIST_HEAD(&page->lru);
+	n = get_node(cachep, page_to_nid(page));
+
+	spin_lock(&n->list_lock);
+	if (!page->active)
+		list_add_tail(&page->lru, &(n->slabs_free));
+	else
+		fixup_slab_list(cachep, n, page, &list);
+	STATS_INC_GROWN(cachep);
+	n->free_objects += cachep->num - page->active;
+	spin_unlock(&n->list_lock);
+
+	fixup_objfreelist_debug(cachep, &list);
 }
 
 #if DEBUG
@@ -2847,6 +2872,7 @@ static void *cache_alloc_refill(struct k
 	struct array_cache *ac;
 	int node;
 	void *list = NULL;
+	struct page *page;
 
 	check_irq_off();
 	node = numa_mem_id();
@@ -2874,7 +2900,6 @@ retry:
 	}
 
 	while (batchcount > 0) {
-		struct page *page;
 		/* Get slab alloc is to come from. */
 		page = get_first_slab(n, false);
 		if (!page)
@@ -2907,8 +2932,6 @@ alloc_done:
 	fixup_objfreelist_debug(cachep, &list);
 
 	if (unlikely(!ac->avail)) {
-		int x;
-
 		/* Check if we can use obj in pfmemalloc slab */
 		if (sk_memalloc_socks()) {
 			void *obj = cache_alloc_pfmemalloc(cachep, n, flags);
@@ -2917,14 +2940,18 @@ alloc_done:
 				return obj;
 		}
 
-		x = cache_grow(cachep, gfp_exact_node(flags), node);
+		page = cache_grow_begin(cachep, gfp_exact_node(flags), node);
+		cache_grow_end(cachep, page);
 
-		/* cache_grow can reenable interrupts, then ac could change. */
+		/*
+		 * cache_grow_begin() can reenable interrupts,
+		 * then ac could change.
+		 */
 		ac = cpu_cache_get(cachep);
 		node = numa_mem_id();
 
 		/* no objects in sight? abort */
-		if (x < 0 && ac->avail == 0)
+		if (!page && ac->avail == 0)
 			return NULL;
 
 		if (!ac->avail)		/* objects refilled by interrupt? */
@@ -3057,6 +3084,7 @@ static void *fallback_alloc(struct kmem_
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(flags);
 	void *obj = NULL;
+	struct page *page;
 	int nid;
 	unsigned int cpuset_mems_cookie;
 
@@ -3092,8 +3120,10 @@ retry:
 		 * We may trigger various forms of reclaim on the allowed
 		 * set and go into memory reserves if necessary.
 		 */
-		nid = cache_grow(cache, flags, numa_mem_id());
-		if (nid >= 0) {
+		page = cache_grow_begin(cache, flags, numa_mem_id());
+		cache_grow_end(cache, page);
+		if (page) {
+			nid = page_to_nid(page);
 			obj = ____cache_alloc_node(cache,
 				gfp_exact_node(flags), nid);
 
@@ -3121,7 +3151,6 @@ static void *____cache_alloc_node(struct
 	struct kmem_cache_node *n;
 	void *obj;
 	void *list = NULL;
-	int x;
 
 	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
 	n = get_node(cachep, nodeid);
@@ -3153,8 +3182,9 @@ retry:
 
 must_grow:
 	spin_unlock(&n->list_lock);
-	x = cache_grow(cachep, gfp_exact_node(flags), nodeid);
-	if (x >= 0)
+	page = cache_grow_begin(cachep, gfp_exact_node(flags), nodeid);
+	cache_grow_end(cachep, page);
+	if (page)
 		goto retry;
 
 	return fallback_alloc(cachep, flags);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


