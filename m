From: akpm@linux-foundation.org
Subject: [withdrawn]
 memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg.patch removed from -mm tree
Date: Mon, 10 Nov 2014 14:15:44 -0800
Message-ID: <54613910.WAzgUuD0X3D3NIgb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaKJWPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:15:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: decouple per memcg kmem cache from the owner memcg
has been removed from the -mm tree.  Its filename was
     memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: decouple per memcg kmem cache from the owner memcg

Basically, we substitute the reference to the owner memory cgroup in
memcg_cache_params with the index in the memcg_caches array.  This
decouples kmem cache from the memcg it was created for and will allow to
reuse it for another cgroup after css offline.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    7 +++----
 mm/memcontrol.c      |   18 +++++-------------
 mm/slab_common.c     |   12 +++++-------
 3 files changed, 13 insertions(+), 24 deletions(-)

diff -puN include/linux/slab.h~memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg include/linux/slab.h
--- a/include/linux/slab.h~memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg
+++ a/include/linux/slab.h
@@ -117,8 +117,7 @@ struct kmem_cache *kmem_cache_create(con
 			void (*)(void *));
 #ifdef CONFIG_MEMCG_KMEM
 struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *,
-					   struct kmem_cache *,
-					   const char *);
+					   struct kmem_cache *);
 #endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
@@ -490,7 +489,7 @@ static __always_inline void *kmalloc_nod
  *
  * Child caches will hold extra metadata needed for its operation. Fields are:
  *
- * @memcg: pointer to the memcg this cache belongs to
+ * @id: the index in the root_cache's memcg_caches array.
  * @root_cache: pointer to the global, root cache, this cache was derived from
  */
 struct memcg_cache_params {
@@ -501,7 +500,7 @@ struct memcg_cache_params {
 			struct kmem_cache *memcg_caches[0];
 		};
 		struct {
-			struct mem_cgroup *memcg;
+			int id;
 			struct kmem_cache *root_cache;
 		};
 	};
diff -puN mm/memcontrol.c~memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg
+++ a/mm/memcontrol.c
@@ -2603,8 +2603,6 @@ void memcg_update_array_size(int num)
 static void memcg_register_cache(struct mem_cgroup *memcg,
 				 struct kmem_cache *root_cache)
 {
-	static char memcg_name_buf[NAME_MAX + 1]; /* protected by
-						     memcg_slab_mutex */
 	struct kmem_cache *cachep;
 	int id;
 
@@ -2620,8 +2618,7 @@ static void memcg_register_cache(struct
 	if (cache_from_memcg_idx(root_cache, id))
 		return;
 
-	cgroup_name(memcg->css.cgroup, memcg_name_buf, NAME_MAX + 1);
-	cachep = memcg_create_kmem_cache(memcg, root_cache, memcg_name_buf);
+	cachep = memcg_create_kmem_cache(memcg, root_cache);
 	/*
 	 * If we could not create a memcg cache, do not complain, because
 	 * that's not critical at all as we can always proceed with the root
@@ -2630,8 +2627,6 @@ static void memcg_register_cache(struct
 	if (!cachep)
 		return;
 
-	css_get(&memcg->css);
-
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
 	 * barrier here to ensure nobody will see the kmem_cache partially
@@ -2646,7 +2641,6 @@ static void memcg_register_cache(struct
 static void memcg_unregister_cache(struct kmem_cache *cachep)
 {
 	struct kmem_cache *root_cache;
-	struct mem_cgroup *memcg;
 	int id;
 
 	lockdep_assert_held(&memcg_slab_mutex);
@@ -2654,16 +2648,12 @@ static void memcg_unregister_cache(struc
 	BUG_ON(is_root_cache(cachep));
 
 	root_cache = cachep->memcg_params->root_cache;
-	memcg = cachep->memcg_params->memcg;
-	id = memcg_cache_id(memcg);
+	id = cachep->memcg_params->id;
 
 	BUG_ON(root_cache->memcg_params->memcg_caches[id] != cachep);
 	root_cache->memcg_params->memcg_caches[id] = NULL;
 
 	kmem_cache_destroy(cachep);
-
-	/* drop the reference taken in memcg_register_cache */
-	css_put(&memcg->css);
 }
 
 /*
@@ -4198,7 +4188,6 @@ static int memcg_init_kmem(struct mem_cg
 {
 	int ret;
 
-	memcg->kmemcg_id = -1;
 	ret = memcg_propagate_kmem(memcg);
 	if (ret)
 		return ret;
@@ -4743,6 +4732,9 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->event_list);
 	spin_lock_init(&memcg->event_list_lock);
+#ifdef CONFIG_MEMCG_KMEM
+	memcg->kmemcg_id = -1;
+#endif
 
 	return &memcg->css;
 
diff -puN mm/slab_common.c~memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg mm/slab_common.c
--- a/mm/slab_common.c~memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg
+++ a/mm/slab_common.c
@@ -125,7 +125,7 @@ static int memcg_alloc_cache_params(stru
 		return -ENOMEM;
 
 	if (memcg) {
-		s->memcg_params->memcg = memcg;
+		s->memcg_params->id = memcg_cache_id(memcg);
 		s->memcg_params->root_cache = root_cache;
 	} else
 		s->memcg_params->is_root_cache = true;
@@ -430,15 +430,13 @@ EXPORT_SYMBOL(kmem_cache_create);
  * memcg_create_kmem_cache - Create a cache for a memory cgroup.
  * @memcg: The memory cgroup the new cache is for.
  * @root_cache: The parent of the new cache.
- * @memcg_name: The name of the memory cgroup (used for naming the new cache).
  *
  * This function attempts to create a kmem cache that will serve allocation
  * requests going from @memcg to @root_cache. The new cache inherits properties
  * from its parent.
  */
 struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-					   struct kmem_cache *root_cache,
-					   const char *memcg_name)
+					   struct kmem_cache *root_cache)
 {
 	struct kmem_cache *s = NULL;
 	char *cache_name;
@@ -448,8 +446,8 @@ struct kmem_cache *memcg_create_kmem_cac
 
 	mutex_lock(&slab_mutex);
 
-	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       memcg_cache_id(memcg), memcg_name);
+	cache_name = kasprintf(GFP_KERNEL, "%s(%d)", root_cache->name,
+			       memcg_cache_id(memcg));
 	if (!cache_name)
 		goto out_unlock;
 
@@ -916,7 +914,7 @@ int memcg_slab_show(struct seq_file *m,
 
 	if (p == slab_caches.next)
 		print_slabinfo_header(m);
-	if (!is_root_cache(s) && s->memcg_params->memcg == memcg)
+	if (!is_root_cache(s) && s->memcg_params->id == memcg_cache_id(memcg))
 		cache_show(s, m);
 	return 0;
 }
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
memcg-zap-memcg_unregister_cache.patch
memcg-free-kmem-cache-id-on-css-offline.patch
memcg-introduce-memcg_kmem_should_charge-helper.patch
slab-introduce-slab_free-helper.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes.patch
memcg-zap-kmem_account_flags.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

