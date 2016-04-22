From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
 removed from -mm tree
Date: Fri, 22 Apr 2016 14:56:28 -0700
Message-ID: <571a9e0c.vVQFSeU6mEhWEI3L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbcDVV43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: make cache_grow() handle the page allocated on arbitrary node
has been removed from the -mm tree.  Its filename was
     mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: make cache_grow() handle the page allocated on arbitrary node

Currently, cache_grow() assumes that allocated page's nodeid would be same
with parameter nodeid which is used for allocation request.  If we discard
this assumption, we can handle fallback_alloc() case gracefully.  So, this
patch makes cache_grow() handle the page allocated on arbitrary node and
clean-up relevant code.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   60 ++++++++++++++++++----------------------------------
 1 file changed, 21 insertions(+), 39 deletions(-)

diff -puN mm/slab.c~mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node mm/slab.c
--- a/mm/slab.c~mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node
+++ a/mm/slab.c
@@ -2526,13 +2526,14 @@ static void slab_map_pages(struct kmem_c
  * Grow (by 1) the number of slabs within a cache.  This is called by
  * kmem_cache_alloc() when there are no active objs left in a cache.
  */
-static int cache_grow(struct kmem_cache *cachep,
-		gfp_t flags, int nodeid, struct page *page)
+static int cache_grow(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 {
 	void *freelist;
 	size_t offset;
 	gfp_t local_flags;
+	int page_node;
 	struct kmem_cache_node *n;
+	struct page *page;
 
 	/*
 	 * Be lazy and only check for valid flags here,  keeping it out of the
@@ -2560,12 +2561,12 @@ static int cache_grow(struct kmem_cache
 	 * Get mem for the objs.  Attempt to allocate a physical page from
 	 * 'nodeid'.
 	 */
-	if (!page)
-		page = kmem_getpages(cachep, local_flags, nodeid);
+	page = kmem_getpages(cachep, local_flags, nodeid);
 	if (!page)
 		goto failed;
 
-	n = get_node(cachep, nodeid);
+	page_node = page_to_nid(page);
+	n = get_node(cachep, page_node);
 
 	/* Get colour for the slab, and cal the next value. */
 	n->colour_next++;
@@ -2580,7 +2581,7 @@ static int cache_grow(struct kmem_cache
 
 	/* Get slab management. */
 	freelist = alloc_slabmgmt(cachep, page, offset,
-			local_flags & ~GFP_CONSTRAINT_MASK, nodeid);
+			local_flags & ~GFP_CONSTRAINT_MASK, page_node);
 	if (OFF_SLAB(cachep) && !freelist)
 		goto opps1;
 
@@ -2599,13 +2600,13 @@ static int cache_grow(struct kmem_cache
 	STATS_INC_GROWN(cachep);
 	n->free_objects += cachep->num;
 	spin_unlock(&n->list_lock);
-	return 1;
+	return page_node;
 opps1:
 	kmem_freepages(cachep, page);
 failed:
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
-	return 0;
+	return -1;
 }
 
 #if DEBUG
@@ -2886,14 +2887,14 @@ alloc_done:
 				return obj;
 		}
 
-		x = cache_grow(cachep, gfp_exact_node(flags), node, NULL);
+		x = cache_grow(cachep, gfp_exact_node(flags), node);
 
 		/* cache_grow can reenable interrupts, then ac could change. */
 		ac = cpu_cache_get(cachep);
 		node = numa_mem_id();
 
 		/* no objects in sight? abort */
-		if (!x && ac->avail == 0)
+		if (x < 0 && ac->avail == 0)
 			return NULL;
 
 		if (!ac->avail)		/* objects refilled by interrupt? */
@@ -3022,7 +3023,6 @@ static void *alternate_node_alloc(struct
 static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 {
 	struct zonelist *zonelist;
-	gfp_t local_flags;
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(flags);
@@ -3033,8 +3033,6 @@ static void *fallback_alloc(struct kmem_
 	if (flags & __GFP_THISNODE)
 		return NULL;
 
-	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
-
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist = node_zonelist(mempolicy_slab_node(), flags);
@@ -3064,33 +3062,17 @@ retry:
 		 * We may trigger various forms of reclaim on the allowed
 		 * set and go into memory reserves if necessary.
 		 */
-		struct page *page;
+		nid = cache_grow(cache, flags, numa_mem_id());
+		if (nid >= 0) {
+			obj = ____cache_alloc_node(cache,
+				gfp_exact_node(flags), nid);
 
-		if (gfpflags_allow_blocking(local_flags))
-			local_irq_enable();
-		kmem_flagcheck(cache, flags);
-		page = kmem_getpages(cache, local_flags, numa_mem_id());
-		if (gfpflags_allow_blocking(local_flags))
-			local_irq_disable();
-		if (page) {
 			/*
-			 * Insert into the appropriate per node queues
+			 * Another processor may allocate the objects in
+			 * the slab since we are not holding any locks.
 			 */
-			nid = page_to_nid(page);
-			if (cache_grow(cache, flags, nid, page)) {
-				obj = ____cache_alloc_node(cache,
-					gfp_exact_node(flags), nid);
-				if (!obj)
-					/*
-					 * Another processor may allocate the
-					 * objects in the slab since we are
-					 * not holding any locks.
-					 */
-					goto retry;
-			} else {
-				/* cache_grow already freed obj */
-				obj = NULL;
-			}
+			if (!obj)
+				goto retry;
 		}
 	}
 
@@ -3141,8 +3123,8 @@ retry:
 
 must_grow:
 	spin_unlock(&n->list_lock);
-	x = cache_grow(cachep, gfp_exact_node(flags), nodeid, NULL);
-	if (x)
+	x = cache_grow(cachep, gfp_exact_node(flags), nodeid);
+	if (x >= 0)
 		goto retry;
 
 	return fallback_alloc(cachep, flags);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch
mm-writeback-correct-dirty-page-calculation-for-highmem.patch
mm-page_alloc-correct-highmem-memory-statistics.patch
mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch
mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch

