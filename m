From: akpm@linux-foundation.org
Subject: [merged] slb-charge-slabs-to-kmemcg-explicitly.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:43:20 -0700
Message-ID: <5390c858.HvpdaXzRw/fNiCUl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, gthelen@google.com, glommer@gmail.com, cl@linux-foundation.org, vdavydov@parallels.com

Subject: [merged] slb-charge-slabs-to-kmemcg-explicitly.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux-foundation.org,glommer@gmail.com,gthelen@google.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:20 -0700


The patch titled
     Subject: sl[au]b: charge slabs to kmemcg explicitly
has been removed from the -mm tree.  Its filename was
     slb-charge-slabs-to-kmemcg-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: sl[au]b: charge slabs to kmemcg explicitly

We have only a few places where we actually want to charge kmem so instead
of intruding into the general page allocation path with __GFP_KMEMCG it's
better to explictly charge kmem there.  All kmem charges will be easier to
follow that way.

This is a step towards removing __GFP_KMEMCG.  It removes __GFP_KMEMCG
from memcg caches' allocflags.  Instead it makes slab allocation path call
memcg_charge_kmem directly getting memcg to charge from the cache's memcg
params.

This also eliminates any possibility of misaccounting an allocation going
from one memcg's cache to another memcg, because now we always charge
slabs against the memcg the cache belongs to.  That's why this patch
removes the big comment to memcg_kmem_get_cache.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++++-----------
 mm/memcontrol.c            |    4 ++--
 mm/slab.c                  |    7 ++++++-
 mm/slab.h                  |   29 +++++++++++++++++++++++++++++
 mm/slab_common.c           |    6 +-----
 mm/slub.c                  |   24 +++++++++++++++++-------
 6 files changed, 59 insertions(+), 26 deletions(-)

diff -puN include/linux/memcontrol.h~slb-charge-slabs-to-kmemcg-explicitly include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~slb-charge-slabs-to-kmemcg-explicitly
+++ a/include/linux/memcontrol.h
@@ -506,6 +506,9 @@ void memcg_update_array_size(int num_gro
 struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
+int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size);
+void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size);
+
 void mem_cgroup_destroy_cache(struct kmem_cache *cachep);
 int __kmem_cache_destroy_memcg_children(struct kmem_cache *s);
 
@@ -583,17 +586,7 @@ memcg_kmem_commit_charge(struct page *pa
  * @cachep: the original global kmem cache
  * @gfp: allocation flags.
  *
- * This function assumes that the task allocating, which determines the memcg
- * in the page allocator, belongs to the same cgroup throughout the whole
- * process.  Misacounting can happen if the task calls memcg_kmem_get_cache()
- * while belonging to a cgroup, and later on changes. This is considered
- * acceptable, and should only happen upon task migration.
- *
- * Before the cache is created by the memcg core, there is also a possible
- * imbalance: the task belongs to a memcg, but the cache being allocated from
- * is the global cache, since the child cache is not yet guaranteed to be
- * ready. This case is also fine, since in this case the GFP_KMEMCG will not be
- * passed and the page allocator will not attempt any cgroup accounting.
+ * All memory allocated from a per-memcg cache is charged to the owner memcg.
  */
 static __always_inline struct kmem_cache *
 memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
diff -puN mm/memcontrol.c~slb-charge-slabs-to-kmemcg-explicitly mm/memcontrol.c
--- a/mm/memcontrol.c~slb-charge-slabs-to-kmemcg-explicitly
+++ a/mm/memcontrol.c
@@ -2953,7 +2953,7 @@ static int mem_cgroup_slabinfo_read(stru
 }
 #endif
 
-static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
+int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
 {
 	struct res_counter *fail_res;
 	int ret = 0;
@@ -2991,7 +2991,7 @@ static int memcg_charge_kmem(struct mem_
 	return ret;
 }
 
-static void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size)
+void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size)
 {
 	res_counter_uncharge(&memcg->res, size);
 	if (do_swap_account)
diff -puN mm/slab.c~slb-charge-slabs-to-kmemcg-explicitly mm/slab.c
--- a/mm/slab.c~slb-charge-slabs-to-kmemcg-explicitly
+++ a/mm/slab.c
@@ -1688,8 +1688,12 @@ static struct page *kmem_getpages(struct
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
+	if (memcg_charge_slab(cachep, flags, cachep->gfporder))
+		return NULL;
+
 	page = alloc_pages_exact_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
 	if (!page) {
+		memcg_uncharge_slab(cachep, cachep->gfporder);
 		slab_out_of_memory(cachep, flags, nodeid);
 		return NULL;
 	}
@@ -1747,7 +1751,8 @@ static void kmem_freepages(struct kmem_c
 	memcg_release_pages(cachep, cachep->gfporder);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += nr_freed;
-	__free_memcg_kmem_pages(page, cachep->gfporder);
+	__free_pages(page, cachep->gfporder);
+	memcg_uncharge_slab(cachep, cachep->gfporder);
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
diff -puN mm/slab.h~slb-charge-slabs-to-kmemcg-explicitly mm/slab.h
--- a/mm/slab.h~slb-charge-slabs-to-kmemcg-explicitly
+++ a/mm/slab.h
@@ -192,6 +192,26 @@ static inline struct kmem_cache *memcg_r
 		return s;
 	return s->memcg_params->root_cache;
 }
+
+static __always_inline int memcg_charge_slab(struct kmem_cache *s,
+					     gfp_t gfp, int order)
+{
+	if (!memcg_kmem_enabled())
+		return 0;
+	if (is_root_cache(s))
+		return 0;
+	return memcg_charge_kmem(s->memcg_params->memcg, gfp,
+				 PAGE_SIZE << order);
+}
+
+static __always_inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
+{
+	if (!memcg_kmem_enabled())
+		return;
+	if (is_root_cache(s))
+		return;
+	memcg_uncharge_kmem(s->memcg_params->memcg, PAGE_SIZE << order);
+}
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
 {
@@ -227,6 +247,15 @@ static inline struct kmem_cache *memcg_r
 {
 	return s;
 }
+
+static inline int memcg_charge_slab(struct kmem_cache *s, gfp_t gfp, int order)
+{
+	return 0;
+}
+
+static inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
+{
+}
 #endif
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
diff -puN mm/slab_common.c~slb-charge-slabs-to-kmemcg-explicitly mm/slab_common.c
--- a/mm/slab_common.c~slb-charge-slabs-to-kmemcg-explicitly
+++ a/mm/slab_common.c
@@ -290,12 +290,8 @@ void kmem_cache_create_memcg(struct mem_
 				 root_cache->size, root_cache->align,
 				 root_cache->flags, root_cache->ctor,
 				 memcg, root_cache);
-	if (IS_ERR(s)) {
+	if (IS_ERR(s))
 		kfree(cache_name);
-		goto out_unlock;
-	}
-
-	s->allocflags |= __GFP_KMEMCG;
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
diff -puN mm/slub.c~slb-charge-slabs-to-kmemcg-explicitly mm/slub.c
--- a/mm/slub.c~slb-charge-slabs-to-kmemcg-explicitly
+++ a/mm/slub.c
@@ -1312,17 +1312,26 @@ static inline void slab_free_hook(struct
 /*
  * Slab allocation and freeing
  */
-static inline struct page *alloc_slab_page(gfp_t flags, int node,
-					struct kmem_cache_order_objects oo)
+static inline struct page *alloc_slab_page(struct kmem_cache *s,
+		gfp_t flags, int node, struct kmem_cache_order_objects oo)
 {
+	struct page *page;
 	int order = oo_order(oo);
 
 	flags |= __GFP_NOTRACK;
 
+	if (memcg_charge_slab(s, flags, order))
+		return NULL;
+
 	if (node == NUMA_NO_NODE)
-		return alloc_pages(flags, order);
+		page = alloc_pages(flags, order);
 	else
-		return alloc_pages_exact_node(node, flags, order);
+		page = alloc_pages_exact_node(node, flags, order);
+
+	if (!page)
+		memcg_uncharge_slab(s, order);
+
+	return page;
 }
 
 static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
@@ -1344,7 +1353,7 @@ static struct page *allocate_slab(struct
 	 */
 	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
 
-	page = alloc_slab_page(alloc_gfp, node, oo);
+	page = alloc_slab_page(s, alloc_gfp, node, oo);
 	if (unlikely(!page)) {
 		oo = s->min;
 		alloc_gfp = flags;
@@ -1352,7 +1361,7 @@ static struct page *allocate_slab(struct
 		 * Allocation may have failed due to fragmentation.
 		 * Try a lower order alloc if possible
 		 */
-		page = alloc_slab_page(alloc_gfp, node, oo);
+		page = alloc_slab_page(s, alloc_gfp, node, oo);
 
 		if (page)
 			stat(s, ORDER_FALLBACK);
@@ -1468,7 +1477,8 @@ static void __free_slab(struct kmem_cach
 	page_mapcount_reset(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	__free_memcg_kmem_pages(page, order);
+	__free_pages(page, order);
+	memcg_uncharge_slab(s, order);
 }
 
 #define need_reserve_slab_rcu						\
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

