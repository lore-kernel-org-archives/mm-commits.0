From: akpm@linux-foundation.org
Subject: +
 slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2.patch added
 to -mm tree
Date: Mon, 10 Nov 2014 14:13:22 -0800
Message-ID: <54613882.jF9jzS0h9fd2A5af%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKJWNV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:13:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: shuffle code around to avoid a predeclaration
has been added to the -mm tree.  Its filename is
     slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: mm/slab: shuffle code around to avoid a predeclaration

Instead of providing a predeclaration for the slab_free() helper, move
the helper and its dependencies before any of their users.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  200 +++++++++++++++++++++++++---------------------------
 1 file changed, 99 insertions(+), 101 deletions(-)

diff -puN mm/slab.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2 mm/slab.c
--- a/mm/slab.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2
+++ a/mm/slab.c
@@ -2961,7 +2961,105 @@ out:
 	return objp;
 }
 
-static __always_inline void slab_free(struct kmem_cache *cachep, void *objp);
+static void cache_flusharray(struct kmem_cache *cachep, struct array_cache *ac)
+{
+	int batchcount;
+	struct kmem_cache_node *n;
+	int node = numa_mem_id();
+	LIST_HEAD(list);
+
+	batchcount = ac->batchcount;
+#if DEBUG
+	BUG_ON(!batchcount || batchcount > ac->avail);
+#endif
+	check_irq_off();
+	n = get_node(cachep, node);
+	spin_lock(&n->list_lock);
+	if (n->shared) {
+		struct array_cache *shared_array = n->shared;
+		int max = shared_array->limit - shared_array->avail;
+		if (max) {
+			if (batchcount > max)
+				batchcount = max;
+			memcpy(&(shared_array->entry[shared_array->avail]),
+			       ac->entry, sizeof(void *) * batchcount);
+			shared_array->avail += batchcount;
+			goto free_done;
+		}
+	}
+
+	free_block(cachep, ac->entry, batchcount, node, &list);
+free_done:
+#if STATS
+	{
+		int i = 0;
+		struct list_head *p;
+
+		p = n->slabs_free.next;
+		while (p != &(n->slabs_free)) {
+			struct page *page;
+
+			page = list_entry(p, struct page, lru);
+			BUG_ON(page->active);
+
+			i++;
+			p = p->next;
+		}
+		STATS_SET_FREEABLE(cachep, i);
+	}
+#endif
+	spin_unlock(&n->list_lock);
+	slabs_destroy(cachep, &list);
+	ac->avail -= batchcount;
+	memmove(ac->entry, &(ac->entry[batchcount]), sizeof(void *)*ac->avail);
+}
+
+/*
+ * Release an obj back to its cache. If the obj has a constructed state, it must
+ * be in this state _before_ it is released.  Called with disabled ints.
+ */
+static inline void __cache_free(struct kmem_cache *cachep, void *objp,
+				unsigned long caller)
+{
+	struct array_cache *ac = cpu_cache_get(cachep);
+
+	check_irq_off();
+	kmemleak_free_recursive(objp, cachep->flags);
+	objp = cache_free_debugcheck(cachep, objp, caller);
+
+	kmemcheck_slab_free(cachep, objp, cachep->object_size);
+
+	/*
+	 * Skip calling cache_free_alien() when the platform is not numa.
+	 * This will avoid cache misses that happen while accessing slabp (which
+	 * is per page memory  reference) to get nodeid. Instead use a global
+	 * variable to skip the call, which is mostly likely to be present in
+	 * the cache.
+	 */
+	if (nr_online_nodes > 1 && cache_free_alien(cachep, objp))
+		return;
+
+	if (ac->avail < ac->limit) {
+		STATS_INC_FREEHIT(cachep);
+	} else {
+		STATS_INC_FREEMISS(cachep);
+		cache_flusharray(cachep, ac);
+	}
+
+	ac_put_obj(cachep, ac, objp);
+}
+
+static __always_inline void slab_free(struct kmem_cache *cachep, void *objp)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	debug_check_no_locks_freed(objp, cachep->object_size);
+	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
+		debug_check_no_obj_freed(objp, cachep->object_size);
+	__cache_free(cachep, objp, _RET_IP_);
+	local_irq_restore(flags);
+}
 
 #ifdef CONFIG_NUMA
 /*
@@ -3307,94 +3405,6 @@ static void free_block(struct kmem_cache
 	}
 }
 
-static void cache_flusharray(struct kmem_cache *cachep, struct array_cache *ac)
-{
-	int batchcount;
-	struct kmem_cache_node *n;
-	int node = numa_mem_id();
-	LIST_HEAD(list);
-
-	batchcount = ac->batchcount;
-#if DEBUG
-	BUG_ON(!batchcount || batchcount > ac->avail);
-#endif
-	check_irq_off();
-	n = get_node(cachep, node);
-	spin_lock(&n->list_lock);
-	if (n->shared) {
-		struct array_cache *shared_array = n->shared;
-		int max = shared_array->limit - shared_array->avail;
-		if (max) {
-			if (batchcount > max)
-				batchcount = max;
-			memcpy(&(shared_array->entry[shared_array->avail]),
-			       ac->entry, sizeof(void *) * batchcount);
-			shared_array->avail += batchcount;
-			goto free_done;
-		}
-	}
-
-	free_block(cachep, ac->entry, batchcount, node, &list);
-free_done:
-#if STATS
-	{
-		int i = 0;
-		struct list_head *p;
-
-		p = n->slabs_free.next;
-		while (p != &(n->slabs_free)) {
-			struct page *page;
-
-			page = list_entry(p, struct page, lru);
-			BUG_ON(page->active);
-
-			i++;
-			p = p->next;
-		}
-		STATS_SET_FREEABLE(cachep, i);
-	}
-#endif
-	spin_unlock(&n->list_lock);
-	slabs_destroy(cachep, &list);
-	ac->avail -= batchcount;
-	memmove(ac->entry, &(ac->entry[batchcount]), sizeof(void *)*ac->avail);
-}
-
-/*
- * Release an obj back to its cache. If the obj has a constructed state, it must
- * be in this state _before_ it is released.  Called with disabled ints.
- */
-static inline void __cache_free(struct kmem_cache *cachep, void *objp,
-				unsigned long caller)
-{
-	struct array_cache *ac = cpu_cache_get(cachep);
-
-	check_irq_off();
-	kmemleak_free_recursive(objp, cachep->flags);
-	objp = cache_free_debugcheck(cachep, objp, caller);
-
-	kmemcheck_slab_free(cachep, objp, cachep->object_size);
-
-	/*
-	 * Skip calling cache_free_alien() when the platform is not numa.
-	 * This will avoid cache misses that happen while accessing slabp (which
-	 * is per page memory  reference) to get nodeid. Instead use a global
-	 * variable to skip the call, which is mostly likely to be present in
-	 * the cache.
-	 */
-	if (nr_online_nodes > 1 && cache_free_alien(cachep, objp))
-		return;
-
-	if (ac->avail < ac->limit) {
-		STATS_INC_FREEHIT(cachep);
-	} else {
-		STATS_INC_FREEMISS(cachep);
-		cache_flusharray(cachep, ac);
-	}
-
-	ac_put_obj(cachep, ac, objp);
-}
-
 /**
  * kmem_cache_alloc - Allocate an object
  * @cachep: The cache to allocate from.
@@ -3531,18 +3541,6 @@ void *__kmalloc_track_caller(size_t size
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
-static __always_inline void slab_free(struct kmem_cache *cachep, void *objp)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	debug_check_no_locks_freed(objp, cachep->object_size);
-	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(objp, cachep->object_size);
-	__cache_free(cachep, objp, _RET_IP_);
-	local_irq_restore(flags);
-}
