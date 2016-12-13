From: akpm@linux-foundation.org
Subject: [patch 023/123] mm, slab: maintain total slab count instead of
 active count
Date: Mon, 12 Dec 2016 16:41:44 -0800
Message-ID: <584f43c8.vR8m0nvtPFjgH+CZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAlp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:41:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, aruna.ramakrishna@oracle.com, cl@linux.com, gthelen@google.com, iamjoonsoo.kim@lge.com, penberg@kernel.org

From: David Rientjes <rientjes@google.com>
Subject: mm, slab: maintain total slab count instead of active count

Rather than tracking the number of active slabs for each node, track the
total number of slabs.  This is a minor improvement that avoids active
slab tracking when a slab goes from free to partial or partial to free.

For slab debugging, this also removes an explicit free count since it can
easily be inferred by the difference in number of total objects and number
of active objects.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1612042020110.115755@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   70 +++++++++++++++++++++-------------------------------
 mm/slab.h |    4 +-
 2 files changed, 31 insertions(+), 43 deletions(-)

diff -puN mm/slab.c~mm-slab-maintain-total-slab-count-instead-of-active-count mm/slab.c
--- a/mm/slab.c~mm-slab-maintain-total-slab-count-instead-of-active-count
+++ a/mm/slab.c
@@ -227,7 +227,7 @@ static void kmem_cache_node_init(struct
 	INIT_LIST_HEAD(&parent->slabs_full);
 	INIT_LIST_HEAD(&parent->slabs_partial);
 	INIT_LIST_HEAD(&parent->slabs_free);
-	parent->active_slabs = 0;
+	parent->total_slabs = 0;
 	parent->free_slabs = 0;
 	parent->shared = NULL;
 	parent->alien = NULL;
@@ -1381,20 +1381,18 @@ slab_out_of_memory(struct kmem_cache *ca
 		cachep->name, cachep->size, cachep->gfporder);
 
 	for_each_kmem_cache_node(cachep, node, n) {
-		unsigned long active_objs = 0, free_objs = 0;
-		unsigned long active_slabs, num_slabs;
+		unsigned long total_slabs, free_slabs, free_objs;
 
 		spin_lock_irqsave(&n->list_lock, flags);
-		active_slabs = n->active_slabs;
-		num_slabs = active_slabs + n->free_slabs;
-
-		active_objs += (num_slabs * cachep->num) - n->free_objects;
-		free_objs += n->free_objects;
+		total_slabs = n->total_slabs;
+		free_slabs = n->free_slabs;
+		free_objs = n->free_objects;
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
-		pr_warn("  node %d: slabs: %ld/%ld, objs: %ld/%ld, free: %ld\n",
-			node, active_slabs, num_slabs, active_objs,
-			num_slabs * cachep->num, free_objs);
+		pr_warn("  node %d: slabs: %ld/%ld, objs: %ld/%ld\n",
+			node, total_slabs - free_slabs, total_slabs,
+			(total_slabs * cachep->num) - free_objs,
+			total_slabs * cachep->num);
 	}
 #endif
 }
@@ -2307,6 +2305,7 @@ static int drain_freelist(struct kmem_ca
 		page = list_entry(p, struct page, lru);
 		list_del(&page->lru);
 		n->free_slabs--;
+		n->total_slabs--;
 		/*
 		 * Safe to drop the lock. The slab is no longer linked
 		 * to the cache.
@@ -2741,13 +2740,12 @@ static void cache_grow_end(struct kmem_c
 	n = get_node(cachep, page_to_nid(page));
 
 	spin_lock(&n->list_lock);
+	n->total_slabs++;
 	if (!page->active) {
 		list_add_tail(&page->lru, &(n->slabs_free));
 		n->free_slabs++;
-	} else {
+	} else
 		fixup_slab_list(cachep, n, page, &list);
-		n->active_slabs++;
-	}
 
 	STATS_INC_GROWN(cachep);
 	n->free_objects += cachep->num - page->active;
@@ -2874,7 +2872,7 @@ static inline void fixup_slab_list(struc
 
 /* Try to find non-pfmemalloc slab if needed */
 static noinline struct page *get_valid_first_slab(struct kmem_cache_node *n,
-			struct page *page, bool *page_is_free, bool pfmemalloc)
+					struct page *page, bool pfmemalloc)
 {
 	if (!page)
 		return NULL;
@@ -2893,10 +2891,9 @@ static noinline struct page *get_valid_f
 
 	/* Move pfmemalloc slab to the end of list to speed up next search */
 	list_del(&page->lru);
-	if (*page_is_free) {
-		WARN_ON(page->active);
+	if (!page->active) {
 		list_add_tail(&page->lru, &n->slabs_free);
-		*page_is_free = false;
+		n->free_slabs++;
 	} else
 		list_add_tail(&page->lru, &n->slabs_partial);
 
@@ -2908,7 +2905,7 @@ static noinline struct page *get_valid_f
 	n->free_touched = 1;
 	list_for_each_entry(page, &n->slabs_free, lru) {
 		if (!PageSlabPfmemalloc(page)) {
-			*page_is_free = true;
+			n->free_slabs--;
 			return page;
 		}
 	}
@@ -2919,26 +2916,19 @@ static noinline struct page *get_valid_f
 static struct page *get_first_slab(struct kmem_cache_node *n, bool pfmemalloc)
 {
 	struct page *page;
-	bool page_is_free = false;
 
 	assert_spin_locked(&n->list_lock);
-	page = list_first_entry_or_null(&n->slabs_partial,
-			struct page, lru);
+	page = list_first_entry_or_null(&n->slabs_partial, struct page, lru);
 	if (!page) {
 		n->free_touched = 1;
-		page = list_first_entry_or_null(&n->slabs_free,
-				struct page, lru);
+		page = list_first_entry_or_null(&n->slabs_free, struct page,
+						lru);
 		if (page)
-			page_is_free = true;
+			n->free_slabs--;
 	}
 
 	if (sk_memalloc_socks())
-		page = get_valid_first_slab(n, page, &page_is_free, pfmemalloc);
-
-	if (page && page_is_free) {
-		n->active_slabs++;
-		n->free_slabs--;
-	}
+		page = get_valid_first_slab(n, page, pfmemalloc);
 
 	return page;
 }
@@ -3441,7 +3431,6 @@ static void free_block(struct kmem_cache
 		if (page->active == 0) {
 			list_add(&page->lru, &n->slabs_free);
 			n->free_slabs++;
-			n->active_slabs--;
 		} else {
 			/* Unconditionally move a slab to the end of the
 			 * partial list on free - maximum time for the
@@ -3457,6 +3446,7 @@ static void free_block(struct kmem_cache
 		page = list_last_entry(&n->slabs_free, struct page, lru);
 		list_move(&page->lru, list);
 		n->free_slabs--;
+		n->total_slabs--;
 	}
 }
 
@@ -4109,8 +4099,8 @@ out:
 void get_slabinfo(struct kmem_cache *cachep, struct slabinfo *sinfo)
 {
 	unsigned long active_objs, num_objs, active_slabs;
-	unsigned long num_slabs = 0, free_objs = 0, shared_avail = 0;
-	unsigned long num_slabs_free = 0;
+	unsigned long total_slabs = 0, free_objs = 0, shared_avail = 0;
+	unsigned long free_slabs = 0;
 	int node;
 	struct kmem_cache_node *n;
 
@@ -4118,9 +4108,8 @@ void get_slabinfo(struct kmem_cache *cac
 		check_irq_on();
 		spin_lock_irq(&n->list_lock);
 
-		num_slabs += n->active_slabs + n->free_slabs;
-		num_slabs_free += n->free_slabs;
-
+		total_slabs += n->total_slabs;
+		free_slabs += n->free_slabs;
 		free_objs += n->free_objects;
 
 		if (n->shared)
@@ -4128,15 +4117,14 @@ void get_slabinfo(struct kmem_cache *cac
 
 		spin_unlock_irq(&n->list_lock);
 	}
-	num_objs = num_slabs * cachep->num;
-	active_slabs = num_slabs - num_slabs_free;
-
+	num_objs = total_slabs * cachep->num;
+	active_slabs = total_slabs - free_slabs;
 	active_objs = num_objs - free_objs;
 
 	sinfo->active_objs = active_objs;
 	sinfo->num_objs = num_objs;
 	sinfo->active_slabs = active_slabs;
-	sinfo->num_slabs = num_slabs;
+	sinfo->num_slabs = total_slabs;
 	sinfo->shared_avail = shared_avail;
 	sinfo->limit = cachep->limit;
 	sinfo->batchcount = cachep->batchcount;
diff -puN mm/slab.h~mm-slab-maintain-total-slab-count-instead-of-active-count mm/slab.h
--- a/mm/slab.h~mm-slab-maintain-total-slab-count-instead-of-active-count
+++ a/mm/slab.h
@@ -447,8 +447,8 @@ struct kmem_cache_node {
 	struct list_head slabs_partial;	/* partial list first, better asm code */
 	struct list_head slabs_full;
 	struct list_head slabs_free;
-	unsigned long active_slabs;	/* length of slabs_partial+slabs_full */
-	unsigned long free_slabs;	/* length of slabs_free */
+	unsigned long total_slabs;	/* length of all slab lists */
+	unsigned long free_slabs;	/* length of free slab list only */
 	unsigned long free_objects;
 	unsigned int free_limit;
 	unsigned int colour_next;	/* Per-node cache coloring */
_
