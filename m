From: akpm@linux-foundation.org
Subject: [merged]
 memcg-slab-clean-up-memcg-cache-initialization-destruction.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:58:39 -0800
Message-ID: <52e2b7df.fqLL8imqkVh1RdaO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS6k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@gmail.com, cl@linux.com, bsingharora@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-slab-clean-up-memcg-cache-initialization-destruction.patch removed from -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,cl@linux.com,glommer@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:39 -0800


The patch titled
     Subject: memcg, slab: clean up memcg cache initialization/destruction
has been removed from the -mm tree.  Its filename was
     memcg-slab-clean-up-memcg-cache-initialization-destruction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg, slab: clean up memcg cache initialization/destruction

Currently, we have rather a messy function set relating to per-memcg kmem
cache initialization/destruction.

Per-memcg caches are created in memcg_create_kmem_cache().  This function
calls kmem_cache_create_memcg() to allocate and initialize a kmem cache
and then "registers" the new cache in the memcg_params::memcg_caches array
of the parent cache.

During its work-flow, kmem_cache_create_memcg() executes the following
memcg-related functions:

 - memcg_alloc_cache_params(), to initialize memcg_params of the newly
   created cache;
 - memcg_cache_list_add(), to add the new cache to the memcg_slab_caches
   list.

On the other hand, kmem_cache_destroy() called on a cache destruction only
calls memcg_release_cache(), which does all the work: it cleans the
reference to the cache in its parent's memcg_params::memcg_caches, removes
the cache from the memcg_slab_caches list, and frees memcg_params.

Such an inconsistency between destruction and initialization paths make
the code difficult to read, so let's clean this up a bit.

This patch moves all the code relating to registration of per-memcg caches
(adding to memcg list, setting the pointer to a cache from its parent) to
the newly created memcg_register_cache() and memcg_unregister_cache()
functions making the initialization and destruction paths look
symmetrical.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ++--
 mm/memcontrol.c            |   64 ++++++++++++++++-------------------
 mm/slab_common.c           |    5 +-
 3 files changed, 37 insertions(+), 41 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slab-clean-up-memcg-cache-initialization-destruction include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-clean-up-memcg-cache-initialization-destruction
+++ a/include/linux/memcontrol.h
@@ -500,8 +500,8 @@ int memcg_cache_id(struct mem_cgroup *me
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache);
 void memcg_free_cache_params(struct kmem_cache *s);
-void memcg_release_cache(struct kmem_cache *cachep);
-void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep);
+void memcg_register_cache(struct kmem_cache *s);
+void memcg_unregister_cache(struct kmem_cache *s);
 
 int memcg_update_cache_size(struct kmem_cache *s, int num_groups);
 void memcg_update_array_size(int num_groups);
@@ -651,12 +651,11 @@ static inline void memcg_free_cache_para
 {
 }
 
-static inline void memcg_release_cache(struct kmem_cache *cachep)
+static inline void memcg_register_cache(struct kmem_cache *s)
 {
 }
 
-static inline void memcg_cache_list_add(struct mem_cgroup *memcg,
-					struct kmem_cache *s)
+static inline void memcg_unregister_cache(struct kmem_cache *s)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-slab-clean-up-memcg-cache-initialization-destruction mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-clean-up-memcg-cache-initialization-destruction
+++ a/mm/memcontrol.c
@@ -3095,16 +3095,6 @@ static void memcg_uncharge_kmem(struct m
 		css_put(&memcg->css);
 }
 
-void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep)
-{
-	if (!memcg)
-		return;
-
-	mutex_lock(&memcg->slab_caches_mutex);
-	list_add(&cachep->memcg_params->list, &memcg->memcg_slab_caches);
-	mutex_unlock(&memcg->slab_caches_mutex);
-}
-
 /*
  * helper for acessing a memcg's index. It will be used as an index in the
  * child cache array in kmem_cache, and also to derive its name. This function
@@ -3265,21 +3255,41 @@ void memcg_free_cache_params(struct kmem
 	kfree(s->memcg_params);
 }
 
-void memcg_release_cache(struct kmem_cache *s)
+void memcg_register_cache(struct kmem_cache *s)
 {
 	struct kmem_cache *root;
 	struct mem_cgroup *memcg;
 	int id;
 
+	if (is_root_cache(s))
+		return;
+
+	root = s->memcg_params->root_cache;
+	memcg = s->memcg_params->memcg;
+	id = memcg_cache_id(memcg);
+
+	css_get(&memcg->css);
+
+	mutex_lock(&memcg->slab_caches_mutex);
+	list_add(&s->memcg_params->list, &memcg->memcg_slab_caches);
+	mutex_unlock(&memcg->slab_caches_mutex);
+
+	root->memcg_params->memcg_caches[id] = s;
 	/*
-	 * This happens, for instance, when a root cache goes away before we
-	 * add any memcg.
+	 * the readers won't lock, make sure everybody sees the updated value,
+	 * so they won't put stuff in the queue again for no reason
 	 */
-	if (!s->memcg_params)
-		return;
+	wmb();
+}
 
-	if (s->memcg_params->is_root_cache)
-		goto out;
+void memcg_unregister_cache(struct kmem_cache *s)
+{
+	struct kmem_cache *root;
+	struct mem_cgroup *memcg;
+	int id;
+
+	if (is_root_cache(s))
+		return;
 
 	memcg = s->memcg_params->memcg;
 	id  = memcg_cache_id(memcg);
@@ -3292,8 +3302,6 @@ void memcg_release_cache(struct kmem_cac
 	mutex_unlock(&memcg->slab_caches_mutex);
 
 	css_put(&memcg->css);
-out:
-	memcg_free_cache_params(s);
 }
 
 /*
@@ -3451,26 +3459,13 @@ static struct kmem_cache *memcg_create_k
 
 	mutex_lock(&memcg_cache_mutex);
 	new_cachep = cache_from_memcg_idx(cachep, idx);
-	if (new_cachep) {
-		css_put(&memcg->css);
+	if (new_cachep)
 		goto out;
-	}
 
 	new_cachep = kmem_cache_dup(memcg, cachep);
-	if (new_cachep == NULL) {
+	if (new_cachep == NULL)
 		new_cachep = cachep;
-		css_put(&memcg->css);
-		goto out;
-	}
-
-	atomic_set(&new_cachep->memcg_params->nr_pages , 0);
 
-	cachep->memcg_params->memcg_caches[idx] = new_cachep;
-	/*
-	 * the readers won't lock, make sure everybody sees the updated value,
-	 * so they won't put stuff in the queue again for no reason
-	 */
-	wmb();
 out:
 	mutex_unlock(&memcg_cache_mutex);
 	return new_cachep;
@@ -3550,6 +3545,7 @@ static void memcg_create_cache_work_func
 
 	cw = container_of(w, struct create_work, work);
 	memcg_create_kmem_cache(cw->memcg, cw->cachep);
+	css_put(&cw->memcg->css);
 	kfree(cw);
 }
 
diff -puN mm/slab_common.c~memcg-slab-clean-up-memcg-cache-initialization-destruction mm/slab_common.c
--- a/mm/slab_common.c~memcg-slab-clean-up-memcg-cache-initialization-destruction
+++ a/mm/slab_common.c
@@ -215,7 +215,7 @@ kmem_cache_create_memcg(struct mem_cgrou
 
 	s->refcount = 1;
 	list_add(&s->list, &slab_caches);
-	memcg_cache_list_add(memcg, s);
+	memcg_register_cache(s);
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
@@ -265,7 +265,8 @@ void kmem_cache_destroy(struct kmem_cach
 			if (s->flags & SLAB_DESTROY_BY_RCU)
 				rcu_barrier();
 
-			memcg_release_cache(s);
+			memcg_unregister_cache(s);
+			memcg_free_cache_params(s);
 			kfree(s->name);
 			kmem_cache_free(kmem_cache, s);
 		} else {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

