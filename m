From: akpm@linux-foundation.org
Subject: [withdrawn] memcg-zap-memcg_unregister_cache.patch removed from
 -mm tree
Date: Mon, 10 Nov 2014 14:15:47 -0800
Message-ID: <54613913.QG6a0RdLw3IEPfEV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaKJWPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:15:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap memcg_{un}register_cache
has been removed from the -mm tree.  Its filename was
     memcg-zap-memcg_unregister_cache.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: zap memcg_{un}register_cache

No need in these helpers any more.  We can do the stuff in
memcg_create_kmem_cache and kmem_cache_destroy.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 
 include/linux/slab.h       |    3 
 mm/memcontrol.c            |  115 ++++-------------------------------
 mm/slab_common.c           |   60 ++++++++++++++----
 4 files changed, 64 insertions(+), 116 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-zap-memcg_unregister_cache include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-zap-memcg_unregister_cache
+++ a/include/linux/memcontrol.h
@@ -403,8 +403,6 @@ void memcg_update_array_size(int num_gro
 struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
-int __memcg_cleanup_cache_params(struct kmem_cache *s);
-
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
  * @gfp: the gfp allocation flags.
diff -puN include/linux/slab.h~memcg-zap-memcg_unregister_cache include/linux/slab.h
--- a/include/linux/slab.h~memcg-zap-memcg_unregister_cache
+++ a/include/linux/slab.h
@@ -116,8 +116,7 @@ struct kmem_cache *kmem_cache_create(con
 			unsigned long,
 			void (*)(void *));
 #ifdef CONFIG_MEMCG_KMEM
-struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *,
-					   struct kmem_cache *);
+void memcg_create_kmem_cache(struct mem_cgroup *, struct kmem_cache *);
 #endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
diff -puN mm/memcontrol.c~memcg-zap-memcg_unregister_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-memcg_unregister_cache
+++ a/mm/memcontrol.c
@@ -2484,12 +2484,6 @@ static void commit_charge(struct page *p
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-/*
- * The memcg_slab_mutex is held whenever a per memcg kmem cache is created or
- * destroyed. It protects memcg_caches arrays.
- */
-static DEFINE_MUTEX(memcg_slab_mutex);
-
 static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
 			     unsigned long nr_pages)
 {
@@ -2574,10 +2568,7 @@ static int memcg_alloc_cache_id(void)
 	else if (size > MEMCG_CACHES_MAX_SIZE)
 		size = MEMCG_CACHES_MAX_SIZE;
 
-	mutex_lock(&memcg_slab_mutex);
 	err = memcg_update_all_caches(size);
-	mutex_unlock(&memcg_slab_mutex);
-
 	if (err) {
 		ida_simple_remove(&kmem_limited_groups, id);
 		return err;
@@ -2600,62 +2591,6 @@ void memcg_update_array_size(int num)
 	memcg_limited_groups_array_size = num;
 }
 
-static void memcg_register_cache(struct mem_cgroup *memcg,
-				 struct kmem_cache *root_cache)
-{
-	struct kmem_cache *cachep;
-	int id;
-
-	lockdep_assert_held(&memcg_slab_mutex);
-
-	id = memcg_cache_id(memcg);
-
-	/*
-	 * Since per-memcg caches are created asynchronously on first
-	 * allocation (see memcg_kmem_get_cache()), several threads can try to
-	 * create the same cache, but only one of them may succeed.
-	 */
-	if (cache_from_memcg_idx(root_cache, id))
-		return;
-
-	cachep = memcg_create_kmem_cache(memcg, root_cache);
-	/*
-	 * If we could not create a memcg cache, do not complain, because
-	 * that's not critical at all as we can always proceed with the root
-	 * cache.
-	 */
-	if (!cachep)
-		return;
-
-	/*
-	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
-	 * barrier here to ensure nobody will see the kmem_cache partially
-	 * initialized.
-	 */
-	smp_wmb();
-
-	BUG_ON(root_cache->memcg_params->memcg_caches[id]);
-	root_cache->memcg_params->memcg_caches[id] = cachep;
-}
-
-static void memcg_unregister_cache(struct kmem_cache *cachep)
-{
-	struct kmem_cache *root_cache;
-	int id;
-
-	lockdep_assert_held(&memcg_slab_mutex);
-
-	BUG_ON(is_root_cache(cachep));
-
-	root_cache = cachep->memcg_params->root_cache;
-	id = cachep->memcg_params->id;
-
-	BUG_ON(root_cache->memcg_params->memcg_caches[id] != cachep);
-	root_cache->memcg_params->memcg_caches[id] = NULL;
-
-	kmem_cache_destroy(cachep);
-}
-
 /*
  * During the creation a new cache, we need to disable our accounting mechanism
  * altogether. This is true even if we are not creating, but rather just
@@ -2687,42 +2622,20 @@ static inline void memcg_resume_kmem_acc
 	current->memcg_kmem_skip_account--;
 }
 
-int __memcg_cleanup_cache_params(struct kmem_cache *s)
-{
-	struct kmem_cache *c;
-	int i, failed = 0;
-
-	mutex_lock(&memcg_slab_mutex);
-	for_each_memcg_cache_index(i) {
-		c = cache_from_memcg_idx(s, i);
-		if (!c)
-			continue;
-
-		memcg_unregister_cache(c);
-
-		if (cache_from_memcg_idx(s, i))
-			failed++;
-	}
-	mutex_unlock(&memcg_slab_mutex);
-	return failed;
-}
-
-struct memcg_register_cache_work {
+struct memcg_cache_create_work {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *cachep;
 	struct work_struct work;
 };
 
-static void memcg_register_cache_func(struct work_struct *w)
+static void memcg_cache_create_work_fn(struct work_struct *w)
 {
-	struct memcg_register_cache_work *cw =
-		container_of(w, struct memcg_register_cache_work, work);
+	struct memcg_cache_create_work *cw = container_of(w,
+			struct memcg_cache_create_work, work);
 	struct mem_cgroup *memcg = cw->memcg;
 	struct kmem_cache *cachep = cw->cachep;
 
-	mutex_lock(&memcg_slab_mutex);
-	memcg_register_cache(memcg, cachep);
-	mutex_unlock(&memcg_slab_mutex);
+	memcg_create_kmem_cache(memcg, cachep);
 
 	css_put(&memcg->css);
 	kfree(cw);
@@ -2731,10 +2644,10 @@ static void memcg_register_cache_func(st
 /*
  * Enqueue the creation of a per-memcg kmem_cache.
  */
-static void __memcg_schedule_register_cache(struct mem_cgroup *memcg,
-					    struct kmem_cache *cachep)
+static void __memcg_schedule_cache_create(struct mem_cgroup *memcg,
+					  struct kmem_cache *cachep)
 {
-	struct memcg_register_cache_work *cw;
+	struct memcg_cache_create_work *cw;
 
 	cw = kmalloc(sizeof(*cw), GFP_NOWAIT);
 	if (cw == NULL) {
@@ -2745,17 +2658,17 @@ static void __memcg_schedule_register_ca
 	cw->memcg = memcg;
 	cw->cachep = cachep;
 
-	INIT_WORK(&cw->work, memcg_register_cache_func);
+	INIT_WORK(&cw->work, memcg_cache_create_work_fn);
 	schedule_work(&cw->work);
 }
 
-static void memcg_schedule_register_cache(struct mem_cgroup *memcg,
-					  struct kmem_cache *cachep)
+static void memcg_schedule_cache_create(struct mem_cgroup *memcg,
+					struct kmem_cache *cachep)
 {
 	/*
 	 * We need to stop accounting when we kmalloc, because if the
 	 * corresponding kmalloc cache is not yet created, the first allocation
-	 * in __memcg_schedule_register_cache will recurse.
+	 * in __memcg_schedule_cache_create will recurse.
 	 *
 	 * However, it is better to enclose the whole function. Depending on
 	 * the debugging options enabled, INIT_WORK(), for instance, can
@@ -2764,7 +2677,7 @@ static void memcg_schedule_register_cach
 	 * the safest choice is to do it like this, wrapping the whole function.
 	 */
 	memcg_stop_kmem_account();
-	__memcg_schedule_register_cache(memcg, cachep);
+	__memcg_schedule_cache_create(memcg, cachep);
 	memcg_resume_kmem_account();
 }
 
@@ -2822,7 +2735,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 	 * could happen with the slab_mutex held. So it's better to
 	 * defer everything.
 	 */
-	memcg_schedule_register_cache(memcg, cachep);
+	memcg_schedule_cache_create(memcg, cachep);
 	return cachep;
 out:
 	rcu_read_unlock();
diff -puN mm/slab_common.c~memcg-zap-memcg_unregister_cache mm/slab_common.c
--- a/mm/slab_common.c~memcg-zap-memcg_unregister_cache
+++ a/mm/slab_common.c
@@ -435,10 +435,11 @@ EXPORT_SYMBOL(kmem_cache_create);
  * requests going from @memcg to @root_cache. The new cache inherits properties
  * from its parent.
  */
-struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-					   struct kmem_cache *root_cache)
+void memcg_create_kmem_cache(struct mem_cgroup *memcg,
+			     struct kmem_cache *root_cache)
 {
-	struct kmem_cache *s = NULL;
+	int id = memcg_cache_id(memcg);
+	struct kmem_cache *s;
 	char *cache_name;
 
 	get_online_cpus();
@@ -446,8 +447,15 @@ struct kmem_cache *memcg_create_kmem_cac
 
 	mutex_lock(&slab_mutex);
 
-	cache_name = kasprintf(GFP_KERNEL, "%s(%d)", root_cache->name,
-			       memcg_cache_id(memcg));
+	/*
+	 * Since per-memcg caches are created asynchronously on first
+	 * allocation (see memcg_kmem_get_cache()), several threads can try to
+	 * create the same cache, but only one of them may succeed.
+	 */
+	if (cache_from_memcg_idx(root_cache, id))
+		goto out_unlock;
+
+	cache_name = kasprintf(GFP_KERNEL, "%s(%d)", root_cache->name, id);
 	if (!cache_name)
 		goto out_unlock;
 
@@ -457,31 +465,52 @@ struct kmem_cache *memcg_create_kmem_cac
 				 memcg, root_cache);
 	if (IS_ERR(s)) {
 		kfree(cache_name);
-		s = NULL;
+		goto out_unlock;
 	}
 
+	/*
+	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
+	 * barrier here to ensure nobody will see the kmem_cache partially
+	 * initialized.
+	 */
+	smp_wmb();
+
+	BUG_ON(root_cache->memcg_params->memcg_caches[id]);
+	root_cache->memcg_params->memcg_caches[id] = s;
+
 out_unlock:
 	mutex_unlock(&slab_mutex);
 
 	put_online_mems();
 	put_online_cpus();
-
-	return s;
 }
 
 static int memcg_cleanup_cache_params(struct kmem_cache *s)
 {
-	int rc;
+	int i;
+	int ret = 0;
 
 	if (!s->memcg_params ||
 	    !s->memcg_params->is_root_cache)
 		return 0;
 
 	mutex_unlock(&slab_mutex);
-	rc = __memcg_cleanup_cache_params(s);
+	for_each_memcg_cache_index(i) {
+		struct kmem_cache *c;
+
+		c = cache_from_memcg_idx(s, i);
+		if (!c)
+			continue;
+
+		kmem_cache_destroy(s);
+
+		/* failed to destroy? */
+		if (cache_from_memcg_idx(s, i))
+			ret = -EBUSY;
+	}
 	mutex_lock(&slab_mutex);
 
-	return rc;
+	return ret;
 }
 #else
 static int memcg_cleanup_cache_params(struct kmem_cache *s)
@@ -517,6 +546,15 @@ void kmem_cache_destroy(struct kmem_cach
 		goto out_unlock;
 	}
 
+#ifdef CONFIG_MEMCG_KMEM
+	if (!is_root_cache(s)) {
+		int id = s->memcg_params->id;
+		struct kmem_cache *root_cache = s->memcg_params->root_cache;
+
+		BUG_ON(root_cache->memcg_params->memcg_caches[id] != s);
+		root_cache->memcg_params->memcg_caches[id] = NULL;
+	}
+#endif
 	list_del(&s->list);
 
 	mutex_unlock(&slab_mutex);
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

