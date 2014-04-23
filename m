From: akpm@linux-foundation.org
Subject: +
 memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch added to -mm tree
Date: Wed, 23 Apr 2014 14:23:37 -0700
Message-ID: <53582f59.QtuoTCk1Hgi8pYWD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbaDWVXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 17:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: + memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch added to -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 14:23:37 -0700


The patch titled
     Subject: memcg, slab: merge memcg_{bind,release}_pages to memcg_{un}charge_slab
has been added to the -mm tree.  Its filename is
     memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch

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
Subject: memcg, slab: merge memcg_{bind,release}_pages to memcg_{un}charge_slab

Currently we have two pairs of kmemcg-related functions that are called on
slab alloc/free.  The first is memcg_{bind,release}_pages that count the
total number of pages allocated on a kmem cache.  The second is
memcg_{un}charge_slab that {un}charge slab pages to kmemcg resource
counter.  Let's just merge them to keep the code clean.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   22 ++++++++++++++++++++--
 mm/slab.c                  |    2 --
 mm/slab.h                  |   25 ++-----------------------
 mm/slub.c                  |    2 --
 5 files changed, 24 insertions(+), 31 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab
+++ a/include/linux/memcontrol.h
@@ -506,8 +506,8 @@ void memcg_update_array_size(int num_gro
 struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
-int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size);
-void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size);
+int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
+void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);
 
 int __kmem_cache_destroy_memcg_children(struct kmem_cache *s);
 
diff -puN mm/memcontrol.c~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab
+++ a/mm/memcontrol.c
@@ -2952,7 +2952,7 @@ static int mem_cgroup_slabinfo_read(stru
 }
 #endif
 
-int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
+static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
 {
 	struct res_counter *fail_res;
 	int ret = 0;
@@ -2990,7 +2990,7 @@ int memcg_charge_kmem(struct mem_cgroup
 	return ret;
 }
 
-void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size)
+static void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size)
 {
 	res_counter_uncharge(&memcg->res, size);
 	if (do_swap_account)
@@ -3388,6 +3388,24 @@ static void memcg_create_cache_enqueue(s
 	__memcg_create_cache_enqueue(memcg, cachep);
 	memcg_resume_kmem_account();
 }
+
+int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order)
+{
+	int res;
+
+	res = memcg_charge_kmem(cachep->memcg_params->memcg, gfp,
+				PAGE_SIZE << order);
+	if (!res)
+		atomic_add(1 << order, &cachep->memcg_params->nr_pages);
+	return res;
+}
+
+void __memcg_uncharge_slab(struct kmem_cache *cachep, int order)
+{
+	memcg_uncharge_kmem(cachep->memcg_params->memcg, PAGE_SIZE << order);
+	atomic_sub(1 << order, &cachep->memcg_params->nr_pages);
+}
+
 /*
  * Return the kmem_cache we're supposed to use for a slab allocation.
  * We try to use the current memcg's version of the cache.
diff -puN mm/slab.c~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab mm/slab.c
--- a/mm/slab.c~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab
+++ a/mm/slab.c
@@ -1706,7 +1706,6 @@ static struct page *kmem_getpages(struct
 	__SetPageSlab(page);
 	if (page->pfmemalloc)
 		SetPageSlabPfmemalloc(page);
-	memcg_bind_pages(cachep, cachep->gfporder);
 
 	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
 		kmemcheck_alloc_shadow(page, cachep->gfporder, flags, nodeid);
@@ -1742,7 +1741,6 @@ static void kmem_freepages(struct kmem_c
 	page_mapcount_reset(page);
 	page->mapping = NULL;
 
-	memcg_release_pages(cachep, cachep->gfporder);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += nr_freed;
 	__free_pages(page, cachep->gfporder);
diff -puN mm/slab.h~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab mm/slab.h
--- a/mm/slab.h~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab
+++ a/mm/slab.h
@@ -120,18 +120,6 @@ static inline bool is_root_cache(struct
 	return !s->memcg_params || s->memcg_params->is_root_cache;
 }
 
-static inline void memcg_bind_pages(struct kmem_cache *s, int order)
-{
-	if (!is_root_cache(s))
-		atomic_add(1 << order, &s->memcg_params->nr_pages);
-}
-
-static inline void memcg_release_pages(struct kmem_cache *s, int order)
-{
-	if (!is_root_cache(s))
-		atomic_sub(1 << order, &s->memcg_params->nr_pages);
-}
-
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 					struct kmem_cache *p)
 {
@@ -197,8 +185,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	if (is_root_cache(s))
 		return 0;
-	return memcg_charge_kmem(s->memcg_params->memcg, gfp,
-				 PAGE_SIZE << order);
+	return __memcg_charge_slab(s, gfp, order);
 }
 
 static __always_inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
@@ -207,7 +194,7 @@ static __always_inline void memcg_unchar
 		return;
 	if (is_root_cache(s))
 		return;
-	memcg_uncharge_kmem(s->memcg_params->memcg, PAGE_SIZE << order);
+	__memcg_uncharge_slab(s, order);
 }
 #else
 static inline bool is_root_cache(struct kmem_cache *s)
@@ -215,14 +202,6 @@ static inline bool is_root_cache(struct
 	return true;
 }
 
-static inline void memcg_bind_pages(struct kmem_cache *s, int order)
-{
-}
-
-static inline void memcg_release_pages(struct kmem_cache *s, int order)
-{
-}
-
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 				      struct kmem_cache *p)
 {
diff -puN mm/slub.c~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab mm/slub.c
--- a/mm/slub.c~memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab
+++ a/mm/slub.c
@@ -1427,7 +1427,6 @@ static struct page *new_slab(struct kmem
 
 	order = compound_order(page);
 	inc_slabs_node(s, page_to_nid(page), page->objects);
-	memcg_bind_pages(s, order);
 	page->slab_cache = s;
 	__SetPageSlab(page);
 	if (page->pfmemalloc)
@@ -1478,7 +1477,6 @@ static void __free_slab(struct kmem_cach
 	__ClearPageSlabPfmemalloc(page);
 	__ClearPageSlab(page);
 
-	memcg_release_pages(s, order);
 	page_mapcount_reset(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slub-fix-memcg_propagate_slab_attrs.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-get-rid-of-__gfp_kmemcg-fix.patch
slab-document-kmalloc_order.patch
memcg-un-export-__memcg_kmem_get_cache.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch

