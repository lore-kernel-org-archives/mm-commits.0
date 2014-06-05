From: akpm@linux-foundation.org
Subject: [merged]
 memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:13 -0700
Message-ID: <5390ca6d.hc31nEqIW24bPEbQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaFETwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com

Subject: [merged] memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch removed from -mm tree
To: vdavydov@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:13 -0700


The patch titled
     Subject: memcg: cleanup kmem cache creation/destruction functions naming
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: cleanup kmem cache creation/destruction functions naming

Current names are rather inconsistent. Let's try to improve them.

Brief change log:

** old name **                          ** new name **

kmem_cache_create_memcg                 memcg_create_kmem_cache
memcg_kmem_create_cache                 memcg_regsiter_cache
memcg_kmem_destroy_cache                memcg_unregister_cache

kmem_cache_destroy_memcg_children       memcg_cleanup_cache_params
mem_cgroup_destroy_all_caches           memcg_unregister_all_caches

create_work                             memcg_register_cache_work
memcg_create_cache_work_func            memcg_register_cache_func
memcg_create_cache_enqueue              memcg_schedule_register_cache

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 -
 include/linux/slab.h       |    2 -
 mm/memcontrol.c            |   60 ++++++++++++++++-------------------
 mm/slab_common.c           |   12 +++----
 4 files changed, 36 insertions(+), 40 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-cleanup-kmem-cache-creation-destruction-functions-naming include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-cleanup-kmem-cache-creation-destruction-functions-naming
+++ a/include/linux/memcontrol.h
@@ -505,7 +505,7 @@ __memcg_kmem_get_cache(struct kmem_cache
 int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
 void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);
 
-int __kmem_cache_destroy_memcg_children(struct kmem_cache *s);
+int __memcg_cleanup_cache_params(struct kmem_cache *s);
 
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
diff -puN include/linux/slab.h~memcg-cleanup-kmem-cache-creation-destruction-functions-naming include/linux/slab.h
--- a/include/linux/slab.h~memcg-cleanup-kmem-cache-creation-destruction-functions-naming
+++ a/include/linux/slab.h
@@ -116,7 +116,7 @@ struct kmem_cache *kmem_cache_create(con
 			unsigned long,
 			void (*)(void *));
 #ifdef CONFIG_MEMCG_KMEM
-struct kmem_cache *kmem_cache_create_memcg(struct mem_cgroup *,
+struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *,
 					   struct kmem_cache *,
 					   const char *);
 #endif
diff -puN mm/memcontrol.c~memcg-cleanup-kmem-cache-creation-destruction-functions-naming mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-kmem-cache-creation-destruction-functions-naming
+++ a/mm/memcontrol.c
@@ -3132,8 +3132,8 @@ void memcg_free_cache_params(struct kmem
 	kfree(s->memcg_params);
 }
 
-static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
-				    struct kmem_cache *root_cache)
+static void memcg_register_cache(struct mem_cgroup *memcg,
+				 struct kmem_cache *root_cache)
 {
 	static char memcg_name_buf[NAME_MAX + 1]; /* protected by
 						     memcg_slab_mutex */
@@ -3153,7 +3153,7 @@ static void memcg_kmem_create_cache(stru
 		return;
 
 	cgroup_name(memcg->css.cgroup, memcg_name_buf, NAME_MAX + 1);
-	cachep = kmem_cache_create_memcg(memcg, root_cache, memcg_name_buf);
+	cachep = memcg_create_kmem_cache(memcg, root_cache, memcg_name_buf);
 	/*
 	 * If we could not create a memcg cache, do not complain, because
 	 * that's not critical at all as we can always proceed with the root
@@ -3175,7 +3175,7 @@ static void memcg_kmem_create_cache(stru
 	root_cache->memcg_params->memcg_caches[id] = cachep;
 }
 
-static void memcg_kmem_destroy_cache(struct kmem_cache *cachep)
+static void memcg_unregister_cache(struct kmem_cache *cachep)
 {
 	struct kmem_cache *root_cache;
 	struct mem_cgroup *memcg;
@@ -3228,7 +3228,7 @@ static inline void memcg_resume_kmem_acc
 	current->memcg_kmem_skip_account--;
 }
 
-int __kmem_cache_destroy_memcg_children(struct kmem_cache *s)
+int __memcg_cleanup_cache_params(struct kmem_cache *s)
 {
 	struct kmem_cache *c;
 	int i, failed = 0;
@@ -3239,7 +3239,7 @@ int __kmem_cache_destroy_memcg_children(
 		if (!c)
 			continue;
 
-		memcg_kmem_destroy_cache(c);
+		memcg_unregister_cache(c);
 
 		if (cache_from_memcg_idx(s, i))
 			failed++;
@@ -3248,7 +3248,7 @@ int __kmem_cache_destroy_memcg_children(
 	return failed;
 }
 
-static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
+static void memcg_unregister_all_caches(struct mem_cgroup *memcg)
 {
 	struct kmem_cache *cachep;
 	struct memcg_cache_params *params, *tmp;
@@ -3261,25 +3261,26 @@ static void mem_cgroup_destroy_all_cache
 		cachep = memcg_params_to_cache(params);
 		kmem_cache_shrink(cachep);
 		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
-			memcg_kmem_destroy_cache(cachep);
+			memcg_unregister_cache(cachep);
 	}
 	mutex_unlock(&memcg_slab_mutex);
 }
 
-struct create_work {
+struct memcg_register_cache_work {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *cachep;
 	struct work_struct work;
 };
 
-static void memcg_create_cache_work_func(struct work_struct *w)
+static void memcg_register_cache_func(struct work_struct *w)
 {
-	struct create_work *cw = container_of(w, struct create_work, work);
+	struct memcg_register_cache_work *cw =
+		container_of(w, struct memcg_register_cache_work, work);
 	struct mem_cgroup *memcg = cw->memcg;
 	struct kmem_cache *cachep = cw->cachep;
 
 	mutex_lock(&memcg_slab_mutex);
-	memcg_kmem_create_cache(memcg, cachep);
+	memcg_register_cache(memcg, cachep);
 	mutex_unlock(&memcg_slab_mutex);
 
 	css_put(&memcg->css);
@@ -3289,12 +3290,12 @@ static void memcg_create_cache_work_func
 /*
  * Enqueue the creation of a per-memcg kmem_cache.
  */
-static void __memcg_create_cache_enqueue(struct mem_cgroup *memcg,
-					 struct kmem_cache *cachep)
+static void __memcg_schedule_register_cache(struct mem_cgroup *memcg,
+					    struct kmem_cache *cachep)
 {
-	struct create_work *cw;
+	struct memcg_register_cache_work *cw;
 
-	cw = kmalloc(sizeof(struct create_work), GFP_NOWAIT);
+	cw = kmalloc(sizeof(*cw), GFP_NOWAIT);
 	if (cw == NULL) {
 		css_put(&memcg->css);
 		return;
@@ -3303,17 +3304,17 @@ static void __memcg_create_cache_enqueue
 	cw->memcg = memcg;
 	cw->cachep = cachep;
 
-	INIT_WORK(&cw->work, memcg_create_cache_work_func);
+	INIT_WORK(&cw->work, memcg_register_cache_func);
 	schedule_work(&cw->work);
 }
 
-static void memcg_create_cache_enqueue(struct mem_cgroup *memcg,
-				       struct kmem_cache *cachep)
+static void memcg_schedule_register_cache(struct mem_cgroup *memcg,
+					  struct kmem_cache *cachep)
 {
 	/*
 	 * We need to stop accounting when we kmalloc, because if the
 	 * corresponding kmalloc cache is not yet created, the first allocation
-	 * in __memcg_create_cache_enqueue will recurse.
+	 * in __memcg_schedule_register_cache will recurse.
 	 *
 	 * However, it is better to enclose the whole function. Depending on
 	 * the debugging options enabled, INIT_WORK(), for instance, can
@@ -3322,7 +3323,7 @@ static void memcg_create_cache_enqueue(s
 	 * the safest choice is to do it like this, wrapping the whole function.
 	 */
 	memcg_stop_kmem_account();
-	__memcg_create_cache_enqueue(memcg, cachep);
+	__memcg_schedule_register_cache(memcg, cachep);
 	memcg_resume_kmem_account();
 }
 
@@ -3393,16 +3394,11 @@ struct kmem_cache *__memcg_kmem_get_cach
 	 *
 	 * However, there are some clashes that can arrive from locking.
 	 * For instance, because we acquire the slab_mutex while doing
-	 * kmem_cache_dup, this means no further allocation could happen
-	 * with the slab_mutex held.
-	 *
-	 * Also, because cache creation issue get_online_cpus(), this
-	 * creates a lock chain: memcg_slab_mutex -> cpu_hotplug_mutex,
-	 * that ends up reversed during cpu hotplug. (cpuset allocates
-	 * a bunch of GFP_KERNEL memory during cpuup). Due to all that,
-	 * better to defer everything.
+	 * memcg_create_kmem_cache, this means no further allocation
+	 * could happen with the slab_mutex held. So it's better to
+	 * defer everything.
 	 */
-	memcg_create_cache_enqueue(memcg, cachep);
+	memcg_schedule_register_cache(memcg, cachep);
 	return cachep;
 out:
 	rcu_read_unlock();
@@ -3526,7 +3522,7 @@ void __memcg_kmem_uncharge_pages(struct
 	memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
 }
 #else
-static inline void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
+static inline void memcg_unregister_all_caches(struct mem_cgroup *memcg)
 {
 }
 #endif /* CONFIG_MEMCG_KMEM */
@@ -6372,7 +6368,7 @@ static void mem_cgroup_css_offline(struc
 	css_for_each_descendant_post(iter, css)
 		mem_cgroup_reparent_charges(mem_cgroup_from_css(iter));
 
-	mem_cgroup_destroy_all_caches(memcg);
+	memcg_unregister_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }
 
diff -puN mm/slab_common.c~memcg-cleanup-kmem-cache-creation-destruction-functions-naming mm/slab_common.c
--- a/mm/slab_common.c~memcg-cleanup-kmem-cache-creation-destruction-functions-naming
+++ a/mm/slab_common.c
@@ -261,7 +261,7 @@ EXPORT_SYMBOL(kmem_cache_create);
 
 #ifdef CONFIG_MEMCG_KMEM
 /*
- * kmem_cache_create_memcg - Create a cache for a memory cgroup.
+ * memcg_create_kmem_cache - Create a cache for a memory cgroup.
  * @memcg: The memory cgroup the new cache is for.
  * @root_cache: The parent of the new cache.
  * @memcg_name: The name of the memory cgroup (used for naming the new cache).
@@ -270,7 +270,7 @@ EXPORT_SYMBOL(kmem_cache_create);
  * requests going from @memcg to @root_cache. The new cache inherits properties
  * from its parent.
  */
-struct kmem_cache *kmem_cache_create_memcg(struct mem_cgroup *memcg,
+struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 					   struct kmem_cache *root_cache,
 					   const char *memcg_name)
 {
@@ -305,7 +305,7 @@ out_unlock:
 	return s;
 }
 
-static int kmem_cache_destroy_memcg_children(struct kmem_cache *s)
+static int memcg_cleanup_cache_params(struct kmem_cache *s)
 {
 	int rc;
 
@@ -314,13 +314,13 @@ static int kmem_cache_destroy_memcg_chil
 		return 0;
 
 	mutex_unlock(&slab_mutex);
-	rc = __kmem_cache_destroy_memcg_children(s);
+	rc = __memcg_cleanup_cache_params(s);
 	mutex_lock(&slab_mutex);
 
 	return rc;
 }
 #else
-static int kmem_cache_destroy_memcg_children(struct kmem_cache *s)
+static int memcg_cleanup_cache_params(struct kmem_cache *s)
 {
 	return 0;
 }
@@ -343,7 +343,7 @@ void kmem_cache_destroy(struct kmem_cach
 	if (s->refcount)
 		goto out_unlock;
 
-	if (kmem_cache_destroy_memcg_children(s) != 0)
+	if (memcg_cleanup_cache_params(s) != 0)
 		goto out_unlock;
 
 	list_del(&s->list);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

