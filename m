From: akpm@linux-foundation.org
Subject: + slab-charge-slab-pages-to-the-current-memory-cgroup.patch added to -mm tree
Date: Tue, 04 Nov 2014 15:22:30 -0800
Message-ID: <54595fb6.EI3dMktqTuXBW672%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaKDXW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 18:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: charge slab pages to the current memory cgroup
has been added to the -mm tree.  Its filename is
     slab-charge-slab-pages-to-the-current-memory-cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-charge-slab-pages-to-the-current-memory-cgroup.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/slab-charge-slab-pages-to-the-current-memory-cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: charge slab pages to the current memory cgroup

Currently, new slabs are charged to the memory cgroup that owns the cache
(kmem_cache->memcg_params->memcg), but I'm going to decouple kmem caches
from memory cgroups so I make them charged to the current cgroup.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 -----
 mm/memcontrol.c            |   14 --------------
 mm/slab.c                  |   22 +++++++++++++++-------
 mm/slab.h                  |   28 ----------------------------
 mm/slub.c                  |   18 ++++++++----------
 5 files changed, 23 insertions(+), 64 deletions(-)

diff -puN include/linux/memcontrol.h~slab-charge-slab-pages-to-the-current-memory-cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~slab-charge-slab-pages-to-the-current-memory-cgroup
+++ a/include/linux/memcontrol.h
@@ -403,9 +403,6 @@ void memcg_update_array_size(int num_gro
 struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
-int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
-void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);
-
 int __memcg_cleanup_cache_params(struct kmem_cache *s);
 
 /**
@@ -477,8 +474,6 @@ memcg_kmem_commit_charge(struct page *pa
  * memcg_kmem_get_cache: selects the correct per-memcg cache for allocation
  * @cachep: the original global kmem cache
  * @gfp: allocation flags.
- *
- * All memory allocated from a per-memcg cache is charged to the owner memcg.
  */
 static __always_inline struct kmem_cache *
 memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
diff -puN mm/memcontrol.c~slab-charge-slab-pages-to-the-current-memory-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~slab-charge-slab-pages-to-the-current-memory-cgroup
+++ a/mm/memcontrol.c
@@ -2778,20 +2778,6 @@ static void memcg_schedule_register_cach
 	memcg_resume_kmem_account();
 }
 
-int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order)
-{
-	unsigned int nr_pages = 1 << order;
-
-	return memcg_charge_kmem(cachep->memcg_params->memcg, gfp, nr_pages);
-}
-
-void __memcg_uncharge_slab(struct kmem_cache *cachep, int order)
-{
-	unsigned int nr_pages = 1 << order;
-
-	memcg_uncharge_kmem(cachep->memcg_params->memcg, nr_pages);
-}
-
 /*
  * Return the kmem_cache we're supposed to use for a slab allocation.
  * We try to use the current memcg's version of the cache.
diff -puN mm/slab.c~slab-charge-slab-pages-to-the-current-memory-cgroup mm/slab.c
--- a/mm/slab.c~slab-charge-slab-pages-to-the-current-memory-cgroup
+++ a/mm/slab.c
@@ -1559,6 +1559,19 @@ slab_out_of_memory(struct kmem_cache *ca
 #endif
 }
 
+static inline struct page *alloc_slab_page(gfp_t flags, int nodeid, int order)
+{
+	struct mem_cgroup *memcg = NULL;
+	struct page *page;
+
+	flags |= __GFP_NOTRACK;
+	if (!memcg_kmem_newpage_charge(flags, &memcg, order))
+		return NULL;
+	page = alloc_pages_exact_node(nodeid, flags, order);
+	memcg_kmem_commit_charge(page, memcg, order);
+	return page;
+}
+
 /*
  * Interface to system's page allocator. No need to hold the
  * kmem_cache_node ->list_lock.
@@ -1577,12 +1590,8 @@ static struct page *kmem_getpages(struct
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
-	if (memcg_charge_slab(cachep, flags, cachep->gfporder))
-		return NULL;
-
-	page = alloc_pages_exact_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
+	page = alloc_slab_page(flags, nodeid, cachep->gfporder);
 	if (!page) {
-		memcg_uncharge_slab(cachep, cachep->gfporder);
 		slab_out_of_memory(cachep, flags, nodeid);
 		return NULL;
 	}
@@ -1638,8 +1647,7 @@ static void kmem_freepages(struct kmem_c
 
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += nr_freed;
-	__free_pages(page, cachep->gfporder);
-	memcg_uncharge_slab(cachep, cachep->gfporder);
+	__free_kmem_pages(page, cachep->gfporder);
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
diff -puN mm/slab.h~slab-charge-slab-pages-to-the-current-memory-cgroup mm/slab.h
--- a/mm/slab.h~slab-charge-slab-pages-to-the-current-memory-cgroup
+++ a/mm/slab.h
@@ -227,25 +227,6 @@ static inline struct kmem_cache *memcg_r
 		return s;
 	return s->memcg_params->root_cache;
 }
-
-static __always_inline int memcg_charge_slab(struct kmem_cache *s,
-					     gfp_t gfp, int order)
-{
-	if (!memcg_kmem_enabled())
-		return 0;
-	if (is_root_cache(s))
-		return 0;
-	return __memcg_charge_slab(s, gfp, order);
-}
-
-static __always_inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
-{
-	if (!memcg_kmem_enabled())
-		return;
-	if (is_root_cache(s))
-		return;
-	__memcg_uncharge_slab(s, order);
-}
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
 {
@@ -273,15 +254,6 @@ static inline struct kmem_cache *memcg_r
 {
 	return s;
 }
-
-static inline int memcg_charge_slab(struct kmem_cache *s, gfp_t gfp, int order)
-{
-	return 0;
-}
-
-static inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
-{
-}
 #endif
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
diff -puN mm/slub.c~slab-charge-slab-pages-to-the-current-memory-cgroup mm/slub.c
--- a/mm/slub.c~slab-charge-slab-pages-to-the-current-memory-cgroup
+++ a/mm/slub.c
@@ -1276,15 +1276,16 @@ static inline void slab_free_hook(struct
 /*
  * Slab allocation and freeing
  */
-static inline struct page *alloc_slab_page(struct kmem_cache *s,
-		gfp_t flags, int node, struct kmem_cache_order_objects oo)
+static inline struct page *alloc_slab_page(gfp_t flags, int node,
+					   struct kmem_cache_order_objects oo)
 {
+	struct mem_cgroup *memcg = NULL;
 	struct page *page;
 	int order = oo_order(oo);
 
 	flags |= __GFP_NOTRACK;
 
-	if (memcg_charge_slab(s, flags, order))
+	if (!memcg_kmem_newpage_charge(flags, &memcg, order))
 		return NULL;
 
 	if (node == NUMA_NO_NODE)
@@ -1292,9 +1293,7 @@ static inline struct page *alloc_slab_pa
 	else
 		page = alloc_pages_exact_node(node, flags, order);
 
-	if (!page)
-		memcg_uncharge_slab(s, order);
-
+	memcg_kmem_commit_charge(page, memcg, order);
 	return page;
 }
 
@@ -1317,7 +1316,7 @@ static struct page *allocate_slab(struct
 	 */
 	alloc_gfp = (flags | __GFP_NOWARN | __GFP_NORETRY) & ~__GFP_NOFAIL;
 
-	page = alloc_slab_page(s, alloc_gfp, node, oo);
+	page = alloc_slab_page(alloc_gfp, node, oo);
 	if (unlikely(!page)) {
 		oo = s->min;
 		alloc_gfp = flags;
@@ -1325,7 +1324,7 @@ static struct page *allocate_slab(struct
 		 * Allocation may have failed due to fragmentation.
 		 * Try a lower order alloc if possible
 		 */
-		page = alloc_slab_page(s, alloc_gfp, node, oo);
+		page = alloc_slab_page(alloc_gfp, node, oo);
 
 		if (page)
 			stat(s, ORDER_FALLBACK);
@@ -1438,8 +1437,7 @@ static void __free_slab(struct kmem_cach
 	page_mapcount_reset(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	__free_pages(page, order);
-	memcg_uncharge_slab(s, order);
+	__free_kmem_pages(page, order);
 }
 
 #define need_reserve_slab_rcu						\
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
memcg-do-not-destroy-kmem-caches-on-css-offline.patch
slab-charge-slab-pages-to-the-current-memory-cgroup.patch
memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg.patch
memcg-zap-memcg_unregister_cache.patch
memcg-free-kmem-cache-id-on-css-offline.patch
memcg-introduce-memcg_kmem_should_charge-helper.patch
slab-introduce-slab_free-helper.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

