From: akpm@linux-foundation.org
Subject: + memcg-slab-simplify-synchronization-scheme.patch added to -mm
 tree
Date: Wed, 23 Apr 2014 14:23:38 -0700
Message-ID: <53582f5a.POFIRA6fKUqOQlEZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbaDWVXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 17:23:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, glommer@gmail.com, vdavydov@parallels.com

Subject: + memcg-slab-simplify-synchronization-scheme.patch added to -mm tree
To: vdavydov@parallels.com,glommer@gmail.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 14:23:38 -0700


The patch titled
     Subject: memcg, slab: simplify synchronization scheme
has been added to the -mm tree.  Its filename is
     memcg-slab-simplify-synchronization-scheme.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-slab-simplify-synchronization-scheme.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-slab-simplify-synchronization-scheme.patch

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
Subject: memcg, slab: simplify synchronization scheme

At present, we have the following mutexes protecting data related to per
memcg kmem caches:

 - slab_mutex.  This one is held during the whole kmem cache creation
   and destruction paths.  We also take it when updating per root cache
   memcg_caches arrays (see memcg_update_all_caches).  As a result, taking
   it guarantees there will be no changes to any kmem cache (including per
   memcg).  Why do we need something else then?  The point is it is
   private to slab implementation and has some internal dependencies with
   other mutexes (get_online_cpus).  So we just don't want to rely upon it
   and prefer to introduce additional mutexes instead.

 - activate_kmem_mutex.  Initially it was added to synchronize
   initializing kmem limit (memcg_activate_kmem).  However, since we can
   grow per root cache memcg_caches arrays only on kmem limit
   initialization (see memcg_update_all_caches), we also employ it to
   protect against memcg_caches arrays relocation (e.g.  see
   __kmem_cache_destroy_memcg_children).

 - We have a convention not to take slab_mutex in memcontrol.c, but we
   want to walk over per memcg memcg_slab_caches lists there (e.g.  for
   destroying all memcg caches on offline).  So we have per memcg
   slab_caches_mutex's protecting those lists.

The mutexes are taken in the following order:

   activate_kmem_mutex -> slab_mutex -> memcg::slab_caches_mutex

Such a syncrhonization scheme has a number of flaws, for instance:

 - We can't call kmem_cache_{destroy,shrink} while walking over a
   memcg::memcg_slab_caches list due to locking order.  As a result, in
   mem_cgroup_destroy_all_caches we schedule the
   memcg_cache_params::destroy work shrinking and destroying the cache.

 - We don't have a mutex to synchronize per memcg caches destruction
   between memcg offline (mem_cgroup_destroy_all_caches) and root cache
   destruction (__kmem_cache_destroy_memcg_children).  Currently we just
   don't bother about it.

This patch simplifies it by substituting per memcg slab_caches_mutex's
with the global memcg_slab_mutex.  It will be held whenever a new per
memcg cache is created or destroyed, so it protects per root cache
memcg_caches arrays and per memcg memcg_slab_caches lists.  The locking
order is following:

   activate_kmem_mutex -> memcg_slab_mutex -> slab_mutex

This allows us to call kmem_cache_{create,shrink,destroy} under the
memcg_slab_mutex.  As a result, we don't need memcg_cache_params::destroy
work any more - we can simply destroy caches while iterating over a per
memcg slab caches list.

Also using the global mutex simplifies synchronization between concurrent
per memcg caches creation/destruction, e.g.  mem_cgroup_destroy_all_caches
vs __kmem_cache_destroy_memcg_children.

The downside of this is that we substitute per-memcg slab_caches_mutex's
with a hummer-like global mutex, but since we already take either the
slab_mutex or the cgroup_mutex along with a memcg::slab_caches_mutex, it
shouldn't hurt concurrency a lot.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 --
 include/linux/slab.h       |    6 -
 mm/memcontrol.c            |  150 +++++++++++++----------------------
 mm/slab_common.c           |   23 +----
 4 files changed, 69 insertions(+), 120 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-slab-simplify-synchronization-scheme include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-slab-simplify-synchronization-scheme
+++ a/include/linux/memcontrol.h
@@ -497,8 +497,6 @@ char *memcg_create_cache_name(struct mem
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache);
 void memcg_free_cache_params(struct kmem_cache *s);
-void memcg_register_cache(struct kmem_cache *s);
-void memcg_unregister_cache(struct kmem_cache *s);
 
 int memcg_update_cache_size(struct kmem_cache *s, int num_groups);
 void memcg_update_array_size(int num_groups);
@@ -640,14 +638,6 @@ static inline void memcg_free_cache_para
 {
 }
 
-static inline void memcg_register_cache(struct kmem_cache *s)
-{
-}
-
-static inline void memcg_unregister_cache(struct kmem_cache *s)
-{
-}
-
 static inline struct kmem_cache *
 memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
diff -puN include/linux/slab.h~memcg-slab-simplify-synchronization-scheme include/linux/slab.h
--- a/include/linux/slab.h~memcg-slab-simplify-synchronization-scheme
+++ a/include/linux/slab.h
@@ -116,7 +116,8 @@ struct kmem_cache *kmem_cache_create(con
 			unsigned long,
 			void (*)(void *));
 #ifdef CONFIG_MEMCG_KMEM
-void kmem_cache_create_memcg(struct mem_cgroup *, struct kmem_cache *);
+struct kmem_cache *kmem_cache_create_memcg(struct mem_cgroup *,
+					   struct kmem_cache *);
 #endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
@@ -525,8 +526,6 @@ static __always_inline void *kmalloc_nod
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
  * @nr_pages: number of pages that belongs to this cache.
- * @destroy: worker to be called whenever we are ready, or believe we may be
- *           ready, to destroy this cache.
  */
 struct memcg_cache_params {
 	bool is_root_cache;
@@ -540,7 +539,6 @@ struct memcg_cache_params {
 			struct list_head list;
 			struct kmem_cache *root_cache;
 			atomic_t nr_pages;
-			struct work_struct destroy;
 		};
 	};
 };
diff -puN mm/memcontrol.c~memcg-slab-simplify-synchronization-scheme mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-slab-simplify-synchronization-scheme
+++ a/mm/memcontrol.c
@@ -357,10 +357,9 @@ struct mem_cgroup {
 	struct cg_proto tcp_mem;
 #endif
 #if defined(CONFIG_MEMCG_KMEM)
-	/* analogous to slab_common's slab_caches list. per-memcg */
+	/* analogous to slab_common's slab_caches list, but per-memcg;
+	 * protected by memcg_slab_mutex */
 	struct list_head memcg_slab_caches;
-	/* Not a spinlock, we can take a lot of time walking the list */
-	struct mutex slab_caches_mutex;
         /* Index in the kmem_cache->memcg_params->memcg_caches array */
 	int kmemcg_id;
 #endif
@@ -2911,6 +2910,12 @@ static void __mem_cgroup_commit_charge(s
 static DEFINE_MUTEX(set_limit_mutex);
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * The memcg_slab_mutex is held whenever a per memcg kmem cache is created or
+ * destroyed. It protects memcg_caches arrays and memcg_slab_caches lists.
+ */
+static DEFINE_MUTEX(memcg_slab_mutex);
+
 static DEFINE_MUTEX(activate_kmem_mutex);
 
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
@@ -2943,10 +2948,10 @@ static int mem_cgroup_slabinfo_read(stru
 
 	print_slabinfo_header(m);
 
-	mutex_lock(&memcg->slab_caches_mutex);
+	mutex_lock(&memcg_slab_mutex);
 	list_for_each_entry(params, &memcg->memcg_slab_caches, list)
 		cache_show(memcg_params_to_cache(params), m);
-	mutex_unlock(&memcg->slab_caches_mutex);
+	mutex_unlock(&memcg_slab_mutex);
 
 	return 0;
 }
@@ -3048,8 +3053,6 @@ void memcg_update_array_size(int num)
 		memcg_limited_groups_array_size = memcg_caches_array_size(num);
 }
 
-static void kmem_cache_destroy_work_func(struct work_struct *w);
-
 int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 {
 	struct memcg_cache_params *cur_params = s->memcg_params;
@@ -3146,8 +3149,6 @@ int memcg_alloc_cache_params(struct mem_
 	if (memcg) {
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
-		INIT_WORK(&s->memcg_params->destroy,
-				kmem_cache_destroy_work_func);
 		css_get(&memcg->css);
 	} else
 		s->memcg_params->is_root_cache = true;
@@ -3164,24 +3165,34 @@ void memcg_free_cache_params(struct kmem
 	kfree(s->memcg_params);
 }
 
-void memcg_register_cache(struct kmem_cache *s)
+static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
+				    struct kmem_cache *root_cache)
 {
-	struct kmem_cache *root;
-	struct mem_cgroup *memcg;
+	struct kmem_cache *cachep;
 	int id;
 
-	if (is_root_cache(s))
+	lockdep_assert_held(&memcg_slab_mutex);
+
+	id = memcg_cache_id(memcg);
+
+	/*
+	 * Since per-memcg caches are created asynchronously on first
+	 * allocation (see memcg_kmem_get_cache()), several threads can try to
+	 * create the same cache, but only one of them may succeed.
+	 */
+	if (cache_from_memcg_idx(root_cache, id))
 		return;
 
+	cachep = kmem_cache_create_memcg(memcg, root_cache);
 	/*
-	 * Holding the slab_mutex assures nobody will touch the memcg_caches
-	 * array while we are modifying it.
+	 * If we could not create a memcg cache, do not complain, because
+	 * that's not critical at all as we can always proceed with the root
+	 * cache.
 	 */
-	lockdep_assert_held(&slab_mutex);
+	if (!cachep)
+		return;
 
-	root = s->memcg_params->root_cache;
-	memcg = s->memcg_params->memcg;
-	id = memcg_cache_id(memcg);
+	list_add(&cachep->memcg_params->list, &memcg->memcg_slab_caches);
 
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
@@ -3190,49 +3201,30 @@ void memcg_register_cache(struct kmem_ca
 	 */
 	smp_wmb();
 
-	/*
-	 * Initialize the pointer to this cache in its parent's memcg_params
-	 * before adding it to the memcg_slab_caches list, otherwise we can
-	 * fail to convert memcg_params_to_cache() while traversing the list.
-	 */
-	VM_BUG_ON(root->memcg_params->memcg_caches[id]);
-	root->memcg_params->memcg_caches[id] = s;
-
-	mutex_lock(&memcg->slab_caches_mutex);
-	list_add(&s->memcg_params->list, &memcg->memcg_slab_caches);
-	mutex_unlock(&memcg->slab_caches_mutex);
+	BUG_ON(root_cache->memcg_params->memcg_caches[id]);
+	root_cache->memcg_params->memcg_caches[id] = cachep;
 }
 
-void memcg_unregister_cache(struct kmem_cache *s)
+static void memcg_kmem_destroy_cache(struct kmem_cache *cachep)
 {
-	struct kmem_cache *root;
+	struct kmem_cache *root_cache;
 	struct mem_cgroup *memcg;
 	int id;
 
-	if (is_root_cache(s))
-		return;
+	lockdep_assert_held(&memcg_slab_mutex);
 
-	/*
-	 * Holding the slab_mutex assures nobody will touch the memcg_caches
-	 * array while we are modifying it.
-	 */
-	lockdep_assert_held(&slab_mutex);
+	BUG_ON(is_root_cache(cachep));
 
-	root = s->memcg_params->root_cache;
-	memcg = s->memcg_params->memcg;
+	root_cache = cachep->memcg_params->root_cache;
+	memcg = cachep->memcg_params->memcg;
 	id = memcg_cache_id(memcg);
 
-	mutex_lock(&memcg->slab_caches_mutex);
-	list_del(&s->memcg_params->list);
-	mutex_unlock(&memcg->slab_caches_mutex);
+	BUG_ON(root_cache->memcg_params->memcg_caches[id] != cachep);
+	root_cache->memcg_params->memcg_caches[id] = NULL;
 
-	/*
-	 * Clear the pointer to this cache in its parent's memcg_params only
-	 * after removing it from the memcg_slab_caches list, otherwise we can
-	 * fail to convert memcg_params_to_cache() while traversing the list.
-	 */
-	VM_BUG_ON(root->memcg_params->memcg_caches[id] != s);
-	root->memcg_params->memcg_caches[id] = NULL;
+	list_del(&cachep->memcg_params->list);
+
+	kmem_cache_destroy(cachep);
 }
 
 /*
@@ -3266,70 +3258,42 @@ static inline void memcg_resume_kmem_acc
 	current->memcg_kmem_skip_account--;
 }
 
-static void kmem_cache_destroy_work_func(struct work_struct *w)
-{
-	struct kmem_cache *cachep;
-	struct memcg_cache_params *p;
-
-	p = container_of(w, struct memcg_cache_params, destroy);
-
-	cachep = memcg_params_to_cache(p);
-
-	kmem_cache_shrink(cachep);
-	if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
-		kmem_cache_destroy(cachep);
-}
-
 int __kmem_cache_destroy_memcg_children(struct kmem_cache *s)
 {
 	struct kmem_cache *c;
 	int i, failed = 0;
 
-	/*
-	 * If the cache is being destroyed, we trust that there is no one else
-	 * requesting objects from it. Even if there are, the sanity checks in
-	 * kmem_cache_destroy should caught this ill-case.
-	 *
-	 * Still, we don't want anyone else freeing memcg_caches under our
-	 * noses, which can happen if a new memcg comes to life. As usual,
-	 * we'll take the activate_kmem_mutex to protect ourselves against
-	 * this.
-	 */
-	mutex_lock(&activate_kmem_mutex);
+	mutex_lock(&memcg_slab_mutex);
 	for_each_memcg_cache_index(i) {
 		c = cache_from_memcg_idx(s, i);
 		if (!c)
 			continue;
 
-		/*
-		 * We will now manually delete the caches, so to avoid races
-		 * we need to cancel all pending destruction workers and
-		 * proceed with destruction ourselves.
-		 */
-		cancel_work_sync(&c->memcg_params->destroy);
-		kmem_cache_destroy(c);
+		memcg_kmem_destroy_cache(c);
 
 		if (cache_from_memcg_idx(s, i))
 			failed++;
 	}
-	mutex_unlock(&activate_kmem_mutex);
+	mutex_unlock(&memcg_slab_mutex);
 	return failed;
 }
 
 static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
 {
 	struct kmem_cache *cachep;
-	struct memcg_cache_params *params;
+	struct memcg_cache_params *params, *tmp;
 
 	if (!memcg_kmem_is_active(memcg))
 		return;
 
-	mutex_lock(&memcg->slab_caches_mutex);
-	list_for_each_entry(params, &memcg->memcg_slab_caches, list) {
+	mutex_lock(&memcg_slab_mutex);
+	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
-		schedule_work(&cachep->memcg_params->destroy);
+		kmem_cache_shrink(cachep);
+		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
+			memcg_kmem_destroy_cache(cachep);
 	}
-	mutex_unlock(&memcg->slab_caches_mutex);
+	mutex_unlock(&memcg_slab_mutex);
 }
 
 struct create_work {
@@ -3344,7 +3308,10 @@ static void memcg_create_cache_work_func
 	struct mem_cgroup *memcg = cw->memcg;
 	struct kmem_cache *cachep = cw->cachep;
 
-	kmem_cache_create_memcg(memcg, cachep);
+	mutex_lock(&memcg_slab_mutex);
+	memcg_kmem_create_cache(memcg, cachep);
+	mutex_unlock(&memcg_slab_mutex);
+
 	css_put(&memcg->css);
 	kfree(cw);
 }
@@ -5028,13 +4995,14 @@ static int __memcg_activate_kmem(struct
 	 * Make sure we have enough space for this cgroup in each root cache's
 	 * memcg_params.
 	 */
+	mutex_lock(&memcg_slab_mutex);
 	err = memcg_update_all_caches(memcg_id + 1);
+	mutex_unlock(&memcg_slab_mutex);
 	if (err)
 		goto out_rmid;
 
 	memcg->kmemcg_id = memcg_id;
 	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
-	mutex_init(&memcg->slab_caches_mutex);
 
 	/*
 	 * We couldn't have accounted to this cgroup, because it hasn't got the
diff -puN mm/slab_common.c~memcg-slab-simplify-synchronization-scheme mm/slab_common.c
--- a/mm/slab_common.c~memcg-slab-simplify-synchronization-scheme
+++ a/mm/slab_common.c
@@ -160,7 +160,6 @@ do_kmem_cache_create(char *name, size_t
 
 	s->refcount = 1;
 	list_add(&s->list, &slab_caches);
-	memcg_register_cache(s);
 out:
 	if (err)
 		return ERR_PTR(err);
@@ -270,9 +269,10 @@ EXPORT_SYMBOL(kmem_cache_create);
  * requests going from @memcg to @root_cache. The new cache inherits properties
  * from its parent.
  */
-void kmem_cache_create_memcg(struct mem_cgroup *memcg, struct kmem_cache *root_cache)
+struct kmem_cache *kmem_cache_create_memcg(struct mem_cgroup *memcg,
+					   struct kmem_cache *root_cache)
 {
-	struct kmem_cache *s;
+	struct kmem_cache *s = NULL;
 	char *cache_name;
 
 	get_online_cpus();
@@ -280,14 +280,6 @@ void kmem_cache_create_memcg(struct mem_
 
 	mutex_lock(&slab_mutex);
 
-	/*
-	 * Since per-memcg caches are created asynchronously on first
-	 * allocation (see memcg_kmem_get_cache()), several threads can try to
-	 * create the same cache, but only one of them may succeed.
-	 */
-	if (cache_from_memcg_idx(root_cache, memcg_cache_id(memcg)))
-		goto out_unlock;
-
 	cache_name = memcg_create_cache_name(memcg, root_cache);
 	if (!cache_name)
 		goto out_unlock;
@@ -296,14 +288,18 @@ void kmem_cache_create_memcg(struct mem_
 				 root_cache->size, root_cache->align,
 				 root_cache->flags, root_cache->ctor,
 				 memcg, root_cache);
-	if (IS_ERR(s))
+	if (IS_ERR(s)) {
 		kfree(cache_name);
+		s = NULL;
+	}
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
 
 	put_online_mems();
 	put_online_cpus();
+
+	return s;
 }
 
 static int kmem_cache_destroy_memcg_children(struct kmem_cache *s)
@@ -342,11 +338,8 @@ void kmem_cache_destroy(struct kmem_cach
 		goto out_unlock;
 
 	list_del(&s->list);
-	memcg_unregister_cache(s);
