From: akpm@linux-foundation.org
Subject: + memcg-add-pointer-to-owner-cache-to-memcg_cache_params.patch
 added to -mm tree
Date: Mon, 21 Jul 2014 14:37:39 -0700
Message-ID: <53cd8823.Zny4UatXIRu1sqLE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:53371 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaGUVhk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 17:37:40 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so361177qgd.5
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 14:37:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add pointer to owner cache to memcg_cache_params
has been added to the -mm tree.  Its filename is
     memcg-add-pointer-to-owner-cache-to-memcg_cache_params.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-add-pointer-to-owner-cache-to-memcg_cache_params.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-pointer-to-owner-cache-to-memcg_cache_params.patch

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
Subject: memcg: add pointer to owner cache to memcg_cache_params

We don't keep a pointer to the owner kmem cache in the memcg_cache_params
struct, because we can always get the cache by reading the slot
corresponding to the owner memcg in the root cache's memcg_caches array
(see memcg_params_to_cache).

However, this means that offline css's, which can be zombieing around for
quite a long time, will occupy slots in memcg_caches arrays, making them
grow larger and larger, which doesn't sound good.  Therefore I'm going to
make memcg release the slots on offline, which will render
memcg_params_to_cache invalid.  So I'm removing it and adding a back
pointer to memcg_cache_params instead.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 ++
 mm/memcontrol.c      |   20 ++++----------------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff -puN include/linux/slab.h~memcg-add-pointer-to-owner-cache-to-memcg_cache_params include/linux/slab.h
--- a/include/linux/slab.h~memcg-add-pointer-to-owner-cache-to-memcg_cache_params
+++ a/include/linux/slab.h
@@ -523,6 +523,7 @@ static __always_inline void *kmalloc_nod
  *
  * Child caches will hold extra metadata needed for its operation. Fields are:
  *
+ * @cachep: cache which this struct is for
  * @memcg: pointer to the memcg this cache belongs to
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
@@ -536,6 +537,7 @@ struct memcg_cache_params {
 			struct kmem_cache *memcg_caches[0];
 		};
 		struct {
+			struct kmem_cache *cachep;
 			struct mem_cgroup *memcg;
 			struct list_head list;
 			struct kmem_cache *root_cache;
diff -puN mm/memcontrol.c~memcg-add-pointer-to-owner-cache-to-memcg_cache_params mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-pointer-to-owner-cache-to-memcg_cache_params
+++ a/mm/memcontrol.c
@@ -2804,19 +2804,6 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
-/*
- * This is a bit cumbersome, but it is rarely used and avoids a backpointer
- * in the memcg_cache_params struct.
- */
-static struct kmem_cache *memcg_params_to_cache(struct memcg_cache_params *p)
-{
-	struct kmem_cache *cachep;
-
-	VM_BUG_ON(p->is_root_cache);
-	cachep = p->root_cache;
-	return cache_from_memcg_idx(cachep, memcg_cache_id(p->memcg));
-}
-
 #ifdef CONFIG_SLABINFO
 static int mem_cgroup_slabinfo_read(struct seq_file *m, void *v)
 {
@@ -2830,7 +2817,7 @@ static int mem_cgroup_slabinfo_read(stru
 
 	mutex_lock(&memcg_slab_mutex);
 	list_for_each_entry(params, &memcg->memcg_slab_caches, list)
-		cache_show(memcg_params_to_cache(params), m);
+		cache_show(params->cachep, m);
 	mutex_unlock(&memcg_slab_mutex);
 
 	return 0;
@@ -2993,6 +2980,7 @@ int memcg_alloc_cache_params(struct mem_
 		return -ENOMEM;
 
 	if (memcg) {
+		s->memcg_params->cachep = s;
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
 		css_get(&memcg->css);
@@ -3138,7 +3126,6 @@ int __memcg_cleanup_cache_params(struct
 
 static void memcg_unregister_all_caches(struct mem_cgroup *memcg)
 {
-	struct kmem_cache *cachep;
 	struct memcg_cache_params *params, *tmp;
 
 	if (!memcg_kmem_is_active(memcg))
@@ -3146,7 +3133,8 @@ static void memcg_unregister_all_caches(
 
 	mutex_lock(&memcg_slab_mutex);
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
-		cachep = memcg_params_to_cache(params);
+		struct kmem_cache *cachep = params->cachep;
+
 		kmem_cache_shrink(cachep);
 		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
 			memcg_unregister_cache(cachep);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
slab-use-mem_cgroup_id-for-per-memcg-cache-naming.patch
memcg-make-memcg_cache_id-static.patch
memcg-add-pointer-to-owner-cache-to-memcg_cache_params.patch
memcg-keep-all-children-of-each-root-cache-on-a-list.patch
memcg-release-memcg_cache_id-on-css-offline.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
fork-make-mm_init_owner-static.patch
linux-next.patch

