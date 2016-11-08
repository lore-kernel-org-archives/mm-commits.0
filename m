From: akpm@linux-foundation.org
Subject: + mm-slab-faster-active-and-free-stats.patch added to -mm tree
Date: Tue, 08 Nov 2016 15:18:22 -0800
Message-ID: <58225d3e.WWg9pisKMsTL8G37%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbcKHXSX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 18:18:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: faster active and free stats
has been added to the -mm tree.  Its filename is
     mm-slab-faster-active-and-free-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-faster-active-and-free-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-faster-active-and-free-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: mm, slab: faster active and free stats

Reading /proc/slabinfo or monitoring slabtop(1) can become very expensive
if there are many slab caches and if there are very lengthy per-node
partial and/or free lists.

Commit 07a63c41fa1f ("mm/slab: improve performance of gathering slabinfo
stats") addressed the per-node full lists which showed a significant
improvement when no objects were freed.  This patch has the same
motivation and optimizes the remainder of the usecases where there are
very lengthy partial and free lists.

This patch maintains per-node active_slabs (full and partial) and
free_slabs rather than iterating the lists at runtime when reading
/proc/slabinfo.

[rientjes@google.com: changelog]
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1611081505240.13403@chino.kir.corp.google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  117 ++++++++++++++++++++--------------------------------
 mm/slab.h |    3 -
 2 files changed, 49 insertions(+), 71 deletions(-)

diff -puN mm/slab.c~mm-slab-faster-active-and-free-stats mm/slab.c
--- a/mm/slab.c~mm-slab-faster-active-and-free-stats
+++ a/mm/slab.c
@@ -227,13 +227,14 @@ static void kmem_cache_node_init(struct
 	INIT_LIST_HEAD(&parent->slabs_full);
 	INIT_LIST_HEAD(&parent->slabs_partial);
 	INIT_LIST_HEAD(&parent->slabs_free);
+	parent->active_slabs = 0;
+	parent->free_slabs = 0;
 	parent->shared = NULL;
 	parent->alien = NULL;
 	parent->colour_next = 0;
 	spin_lock_init(&parent->list_lock);
 	parent->free_objects = 0;
 	parent->free_touched = 0;
-	parent->num_slabs = 0;
 }
 
 #define MAKE_LIST(cachep, listp, slab, nodeid)				\
@@ -1366,7 +1367,6 @@ slab_out_of_memory(struct kmem_cache *ca
 {
 #if DEBUG
 	struct kmem_cache_node *n;
-	struct page *page;
 	unsigned long flags;
 	int node;
 	static DEFINE_RATELIMIT_STATE(slab_oom_rs, DEFAULT_RATELIMIT_INTERVAL,
@@ -1381,32 +1381,20 @@ slab_out_of_memory(struct kmem_cache *ca
 		cachep->name, cachep->size, cachep->gfporder);
 
 	for_each_kmem_cache_node(cachep, node, n) {
-		unsigned long active_objs = 0, num_objs = 0, free_objects = 0;
-		unsigned long active_slabs = 0, num_slabs = 0;
-		unsigned long num_slabs_partial = 0, num_slabs_free = 0;
-		unsigned long num_slabs_full;
+		unsigned long active_objs = 0, free_objs = 0;
+		unsigned long active_slabs, num_slabs;
 
 		spin_lock_irqsave(&n->list_lock, flags);
-		num_slabs = n->num_slabs;
-		list_for_each_entry(page, &n->slabs_partial, lru) {
-			active_objs += page->active;
-			num_slabs_partial++;
-		}
-		list_for_each_entry(page, &n->slabs_free, lru)
-			num_slabs_free++;
+		active_slabs = n->active_slabs;
+		num_slabs = active_slabs + n->free_slabs;
 
-		free_objects += n->free_objects;
+		active_objs += (num_slabs * cachep->num) - n->free_objects;
+		free_objs += n->free_objects;
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
-		num_objs = num_slabs * cachep->num;
-		active_slabs = num_slabs - num_slabs_free;
-		num_slabs_full = num_slabs -
-			(num_slabs_partial + num_slabs_free);
-		active_objs += (num_slabs_full * cachep->num);
-
 		pr_warn("  node %d: slabs: %ld/%ld, objs: %ld/%ld, free: %ld\n",
-			node, active_slabs, num_slabs, active_objs, num_objs,
-			free_objects);
+			node, active_slabs, num_slabs, active_objs,
+			num_slabs * cachep->num, free_objs);
 	}
 #endif
 }
@@ -2318,7 +2306,7 @@ static int drain_freelist(struct kmem_ca
 
 		page = list_entry(p, struct page, lru);
 		list_del(&page->lru);
-		n->num_slabs--;
+		n->free_slabs--;
 		/*
 		 * Safe to drop the lock. The slab is no longer linked
 		 * to the cache.
@@ -2753,12 +2741,14 @@ static void cache_grow_end(struct kmem_c
 	n = get_node(cachep, page_to_nid(page));
 
 	spin_lock(&n->list_lock);
-	if (!page->active)
+	if (!page->active) {
 		list_add_tail(&page->lru, &(n->slabs_free));
-	else
+		n->free_slabs++;
+	} else {
 		fixup_slab_list(cachep, n, page, &list);
+		n->active_slabs++;
+	}
 
-	n->num_slabs++;
 	STATS_INC_GROWN(cachep);
 	n->free_objects += cachep->num - page->active;
 	spin_unlock(&n->list_lock);
@@ -2884,7 +2874,7 @@ static inline void fixup_slab_list(struc
 
 /* Try to find non-pfmemalloc slab if needed */
 static noinline struct page *get_valid_first_slab(struct kmem_cache_node *n,
-					struct page *page, bool pfmemalloc)
+			struct page *page, bool *page_is_free, bool pfmemalloc)
 {
 	if (!page)
 		return NULL;
@@ -2903,9 +2893,11 @@ static noinline struct page *get_valid_f
 
 	/* Move pfmemalloc slab to the end of list to speed up next search */
 	list_del(&page->lru);
-	if (!page->active)
+	if (*page_is_free) {
+		WARN_ON(page->active);
 		list_add_tail(&page->lru, &n->slabs_free);
-	else
+		*page_is_free = false;
+	} else
 		list_add_tail(&page->lru, &n->slabs_partial);
 
 	list_for_each_entry(page, &n->slabs_partial, lru) {
@@ -2913,9 +2905,12 @@ static noinline struct page *get_valid_f
 			return page;
 	}
 
+	n->free_touched = 1;
 	list_for_each_entry(page, &n->slabs_free, lru) {
-		if (!PageSlabPfmemalloc(page))
+		if (!PageSlabPfmemalloc(page)) {
+			*page_is_free = true;
 			return page;
+		}
 	}
 
 	return NULL;
@@ -2924,17 +2919,26 @@ static noinline struct page *get_valid_f
 static struct page *get_first_slab(struct kmem_cache_node *n, bool pfmemalloc)
 {
 	struct page *page;
+	bool page_is_free = false;
 
+	assert_spin_locked(&n->list_lock);
 	page = list_first_entry_or_null(&n->slabs_partial,
 			struct page, lru);
 	if (!page) {
 		n->free_touched = 1;
 		page = list_first_entry_or_null(&n->slabs_free,
 				struct page, lru);
+		if (page)
+			page_is_free = true;
 	}
 
 	if (sk_memalloc_socks())
-		return get_valid_first_slab(n, page, pfmemalloc);
+		page = get_valid_first_slab(n, page, &page_is_free, pfmemalloc);
+
+	if (page && page_is_free) {
+		n->active_slabs++;
+		n->free_slabs--;
+	}
 
 	return page;
 }
@@ -3434,9 +3438,11 @@ static void free_block(struct kmem_cache
 		STATS_DEC_ACTIVE(cachep);
 
 		/* fixup slab chains */
-		if (page->active == 0)
+		if (page->active == 0) {
 			list_add(&page->lru, &n->slabs_free);
-		else {
+			n->free_slabs++;
+			n->active_slabs--;
+		} else {
 			/* Unconditionally move a slab to the end of the
 			 * partial list on free - maximum time for the
 			 * other objects to be freed, too.
@@ -3450,7 +3456,7 @@ static void free_block(struct kmem_cache
 
 		page = list_last_entry(&n->slabs_free, struct page, lru);
 		list_move(&page->lru, list);
-		n->num_slabs--;
+		n->free_slabs--;
 	}
 }
 
@@ -4102,43 +4108,21 @@ out:
 #ifdef CONFIG_SLABINFO
 void get_slabinfo(struct kmem_cache *cachep, struct slabinfo *sinfo)
 {
-	struct page *page;
-	unsigned long active_objs;
-	unsigned long num_objs;
-	unsigned long active_slabs = 0;
-	unsigned long num_slabs, free_objects = 0, shared_avail = 0;
-	unsigned long num_slabs_partial = 0, num_slabs_free = 0;
-	unsigned long num_slabs_full = 0;
-	const char *name;
-	char *error = NULL;
+	unsigned long active_objs, num_objs, active_slabs;
+	unsigned long num_slabs = 0, free_objs = 0, shared_avail = 0;
+	unsigned long num_slabs_free = 0;
 	int node;
 	struct kmem_cache_node *n;
 
-	active_objs = 0;
-	num_slabs = 0;
 	for_each_kmem_cache_node(cachep, node, n) {
-
 		check_irq_on();
 		spin_lock_irq(&n->list_lock);
 
-		num_slabs += n->num_slabs;
+		num_slabs += n->active_slabs + n->free_slabs;
+		num_slabs_free += n->free_slabs;
 
-		list_for_each_entry(page, &n->slabs_partial, lru) {
-			if (page->active == cachep->num && !error)
-				error = "slabs_partial accounting error";
-			if (!page->active && !error)
-				error = "slabs_partial accounting error";
-			active_objs += page->active;
-			num_slabs_partial++;
-		}
+		free_objs += n->free_objects;
 
-		list_for_each_entry(page, &n->slabs_free, lru) {
-			if (page->active && !error)
-				error = "slabs_free accounting error";
-			num_slabs_free++;
-		}
-
-		free_objects += n->free_objects;
 		if (n->shared)
 			shared_avail += n->shared->avail;
 
@@ -4146,15 +4130,8 @@ void get_slabinfo(struct kmem_cache *cac
 	}
 	num_objs = num_slabs * cachep->num;
 	active_slabs = num_slabs - num_slabs_free;
-	num_slabs_full = num_slabs - (num_slabs_partial + num_slabs_free);
-	active_objs += (num_slabs_full * cachep->num);
-
-	if (num_objs - active_objs != free_objects && !error)
-		error = "free_objects accounting error";
 
-	name = cachep->name;
-	if (error)
-		pr_err("slab: cache %s error: %s\n", name, error);
+	active_objs = num_objs - free_objs;
 
 	sinfo->active_objs = active_objs;
 	sinfo->num_objs = num_objs;
diff -puN mm/slab.h~mm-slab-faster-active-and-free-stats mm/slab.h
--- a/mm/slab.h~mm-slab-faster-active-and-free-stats
+++ a/mm/slab.h
@@ -447,7 +447,8 @@ struct kmem_cache_node {
 	struct list_head slabs_partial;	/* partial list first, better asm code */
 	struct list_head slabs_full;
 	struct list_head slabs_free;
-	unsigned long num_slabs;
+	unsigned long active_slabs;	/* length of slabs_partial+slabs_full */
+	unsigned long free_slabs;	/* length of slabs_free */
 	unsigned long free_objects;
 	unsigned int free_limit;
 	unsigned int colour_next;	/* Per-node cache coloring */
_

Patches currently in -mm which might be from gthelen@google.com are

memcg-prevent-memcg-caches-to-be-both-off_slab-objfreelist_slab.patch
mm-slab-faster-active-and-free-stats.patch

