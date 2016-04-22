From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch removed from -mm tree
Date: Fri, 22 Apr 2016 14:56:34 -0700
Message-ID: <571a9e12.rcn6UtqKA0gvk6of%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbcDVV4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: refill cpu cache through a new slab without holding a node lock
has been removed from the -mm tree.  Its filename was
     mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: refill cpu cache through a new slab without holding a node lock

Until now, cache growing makes a free slab on node's slab list and then we
can allocate free objects from it.  This necessarily requires to hold a
node lock which is very contended.  If we refill cpu cache before
attaching it to node's slab list, we can avoid holding a node lock as much
as possible because this newly allocated slab is only visible to the
current task.  This will reduce lock contention.

Below is the result of concurrent allocation/free in slab allocation
benchmark made by Christoph a long time ago.  I make the output simpler. 
The number shows cycle count during alloc/free respectively so less is
better.

* Before
Kmalloc N*alloc N*free(32): Average=355/750
Kmalloc N*alloc N*free(64): Average=452/812
Kmalloc N*alloc N*free(128): Average=559/1070
Kmalloc N*alloc N*free(256): Average=1176/980
Kmalloc N*alloc N*free(512): Average=1939/1189
Kmalloc N*alloc N*free(1024): Average=3521/1278
Kmalloc N*alloc N*free(2048): Average=7152/1838
Kmalloc N*alloc N*free(4096): Average=13438/2013

* After
Kmalloc N*alloc N*free(32): Average=248/966
Kmalloc N*alloc N*free(64): Average=261/949
Kmalloc N*alloc N*free(128): Average=314/1016
Kmalloc N*alloc N*free(256): Average=741/1061
Kmalloc N*alloc N*free(512): Average=1246/1152
Kmalloc N*alloc N*free(1024): Average=2437/1259
Kmalloc N*alloc N*free(2048): Average=4980/1800
Kmalloc N*alloc N*free(4096): Average=9000/2078

It shows that contention is reduced for all the object sizes and
performance increases by 30 ~ 40%.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   68 +++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

diff -puN mm/slab.c~mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock mm/slab.c
--- a/mm/slab.c~mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock
+++ a/mm/slab.c
@@ -2835,6 +2835,30 @@ static noinline void *cache_alloc_pfmema
 	return obj;
 }
 
+/*
+ * Slab list should be fixed up by fixup_slab_list() for existing slab
+ * or cache_grow_end() for new slab
+ */
+static __always_inline int alloc_block(struct kmem_cache *cachep,
+		struct array_cache *ac, struct page *page, int batchcount)
+{
+	/*
+	 * There must be at least one object available for
+	 * allocation.
+	 */
+	BUG_ON(page->active >= cachep->num);
+
+	while (page->active < cachep->num && batchcount--) {
+		STATS_INC_ALLOCED(cachep);
+		STATS_INC_ACTIVE(cachep);
+		STATS_SET_HIGH(cachep);
+
+		ac->entry[ac->avail++] = slab_get_obj(cachep, page);
+	}
+
+	return batchcount;
+}
+
 static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags)
 {
 	int batchcount;
@@ -2847,7 +2871,6 @@ static void *cache_alloc_refill(struct k
 	check_irq_off();
 	node = numa_mem_id();
 
-retry:
 	ac = cpu_cache_get(cachep);
 	batchcount = ac->batchcount;
 	if (!ac->touched && batchcount > BATCHREFILL_LIMIT) {
@@ -2877,21 +2900,7 @@ retry:
 
 		check_spinlock_acquired(cachep);
 
-		/*
-		 * The slab was either on partial or free list so
-		 * there must be at least one object available for
-		 * allocation.
-		 */
-		BUG_ON(page->active >= cachep->num);
-
-		while (page->active < cachep->num && batchcount--) {
-			STATS_INC_ALLOCED(cachep);
-			STATS_INC_ACTIVE(cachep);
-			STATS_SET_HIGH(cachep);
-
-			ac->entry[ac->avail++] = slab_get_obj(cachep, page);
-		}
-
+		batchcount = alloc_block(cachep, ac, page, batchcount);
 		fixup_slab_list(cachep, n, page, &list);
 	}
 
@@ -2911,21 +2920,18 @@ alloc_done:
 		}
 
 		page = cache_grow_begin(cachep, gfp_exact_node(flags), node);
-		cache_grow_end(cachep, page);
 
 		/*
 		 * cache_grow_begin() can reenable interrupts,
 		 * then ac could change.
 		 */
 		ac = cpu_cache_get(cachep);
-		node = numa_mem_id();
+		if (!ac->avail && page)
+			alloc_block(cachep, ac, page, batchcount);
+		cache_grow_end(cachep, page);
 
-		/* no objects in sight? abort */
-		if (!page && ac->avail == 0)
+		if (!ac->avail)
 			return NULL;
-
-		if (!ac->avail)		/* objects refilled by interrupt? */
-			goto retry;
 	}
 	ac->touched = 1;
 
@@ -3119,14 +3125,13 @@ static void *____cache_alloc_node(struct
 {
 	struct page *page;
 	struct kmem_cache_node *n;
-	void *obj;
+	void *obj = NULL;
 	void *list = NULL;
 
 	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
 	n = get_node(cachep, nodeid);
 	BUG_ON(!n);
 
-retry:
 	check_irq_off();
 	spin_lock(&n->list_lock);
 	page = get_first_slab(n, false);
@@ -3148,19 +3153,18 @@ retry:
 
 	spin_unlock(&n->list_lock);
 	fixup_objfreelist_debug(cachep, &list);
-	goto done;
+	return obj;
 
 must_grow:
 	spin_unlock(&n->list_lock);
 	page = cache_grow_begin(cachep, gfp_exact_node(flags), nodeid);
+	if (page) {
+		/* This slab isn't counted yet so don't update free_objects */
+		obj = slab_get_obj(cachep, page);
+	}
 	cache_grow_end(cachep, page);
-	if (page)
-		goto retry;
-
-	return fallback_alloc(cachep, flags);
 
-done:
-	return obj;
+	return obj ? obj : fallback_alloc(cachep, flags);
 }
 
 static __always_inline void *
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

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

