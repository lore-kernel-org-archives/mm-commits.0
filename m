From: akpm@linux-foundation.org
Subject: + mm-slab-separate-cache_grow-to-two-parts.patch added to -mm
 tree
Date: Fri, 22 Apr 2016 15:02:09 -0700
Message-ID: <571a9f61.gN6DJmC49gEPRDYF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbcDVWCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 18:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: separate cache_grow() to two parts
has been added to the -mm tree.  Its filename is
     mm-slab-separate-cache_grow-to-two-parts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-separate-cache_grow-to-two-parts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-separate-cache_grow-to-two-parts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1804,7 +1809,7 @@ static size_t calculate_slab_order(struc
 
 			/*
 			 * Needed to avoid possible looping condition
-			 * in cache_grow()
+			 * in cache_grow_begin()
 			 */
 			if (OFF_SLAB(freelist_cache))
 				continue;
@@ -2550,7 +2555,8 @@ static void slab_map_pages(struct kmem_c
  * Grow (by 1) the number of slabs within a cache.  This is called by
  * kmem_cache_alloc() when there are no active objs left in a cache.
  */
-static int cache_grow(struct kmem_cache *cachep, gfp_t flags, int nodeid)
+static struct page *cache_grow_begin(struct kmem_cache *cachep,
+				gfp_t flags, int nodeid)
 {
 	void *freelist;
 	size_t offset;
@@ -2616,21 +2622,40 @@ static int cache_grow(struct kmem_cache
 
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
@@ -2841,6 +2866,7 @@ static void *cache_alloc_refill(struct k
 	struct array_cache *ac;
 	int node;
 	void *list = NULL;
+	struct page *page;
 
 	check_irq_off();
 	node = numa_mem_id();
@@ -2868,7 +2894,6 @@ retry:
 	}
 
 	while (batchcount > 0) {
-		struct page *page;
 		/* Get slab alloc is to come from. */
 		page = get_first_slab(n, false);
 		if (!page)
@@ -2901,8 +2926,6 @@ alloc_done:
 	fixup_objfreelist_debug(cachep, &list);
 
 	if (unlikely(!ac->avail)) {
-		int x;
-
 		/* Check if we can use obj in pfmemalloc slab */
 		if (sk_memalloc_socks()) {
 			void *obj = cache_alloc_pfmemalloc(cachep, n, flags);
@@ -2911,14 +2934,18 @@ alloc_done:
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
@@ -3051,6 +3078,7 @@ static void *fallback_alloc(struct kmem_
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(flags);
 	void *obj = NULL;
+	struct page *page;
 	int nid;
 	unsigned int cpuset_mems_cookie;
 
@@ -3086,8 +3114,10 @@ retry:
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
 
@@ -3115,7 +3145,6 @@ static void *____cache_alloc_node(struct
 	struct kmem_cache_node *n;
 	void *obj;
 	void *list = NULL;
-	int x;
 
 	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
 	n = get_node(cachep, nodeid);
@@ -3147,8 +3176,9 @@ retry:
 
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

mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
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

