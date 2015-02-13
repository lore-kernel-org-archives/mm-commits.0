From: akpm@linux-foundation.org
Subject: [merged] slab-embed-memcg_cache_params-to-kmem_cache.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:20:11 -0800
Message-ID: <54de5c7b.tUhWtMVJSWFY41If%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbBMUUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, dan.carpenter@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: embed memcg_cache_params to kmem_cache
has been removed from the -mm tree.  Its filename was
     slab-embed-memcg_cache_params-to-kmem_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: embed memcg_cache_params to kmem_cache

Currently, kmem_cache stores a pointer to struct memcg_cache_params
instead of embedding it.  The rationale is to save memory when kmem
accounting is disabled.  However, the memcg_cache_params has shrivelled
drastically since it was first introduced:

* Initially:

struct memcg_cache_params {
	bool is_root_cache;
	union {
		struct kmem_cache *memcg_caches[0];
		struct {
			struct mem_cgroup *memcg;
			struct list_head list;
			struct kmem_cache *root_cache;
			bool dead;
			atomic_t nr_pages;
			struct work_struct destroy;
		};
	};
};

* Now:

struct memcg_cache_params {
	bool is_root_cache;
	union {
		struct {
			struct rcu_head rcu_head;
			struct kmem_cache *memcg_caches[0];
		};
		struct {
			struct mem_cgroup *memcg;
			struct kmem_cache *root_cache;
		};
	};
};

So the memory saving does not seem to be a clear win anymore.

OTOH, keeping a pointer to memcg_cache_params struct instead of embedding
it results in touching one more cache line on kmem alloc/free hot paths. 
Besides, it makes linking kmem caches in a list chained by a field of
struct memcg_cache_params really painful due to a level of indirection,
while I want to make them linked in the following patch.  That said, let
us embed it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h     |   17 ++--
 include/linux/slab_def.h |    2 
 include/linux/slub_def.h |    2 
 mm/memcontrol.c          |   11 +--
 mm/slab.h                |   48 ++++++-------
 mm/slab_common.c         |  129 ++++++++++++++++++++-----------------
 mm/slub.c                |    5 -
 7 files changed, 111 insertions(+), 103 deletions(-)

diff -puN include/linux/slab.h~slab-embed-memcg_cache_params-to-kmem_cache include/linux/slab.h
--- a/include/linux/slab.h~slab-embed-memcg_cache_params-to-kmem_cache
+++ a/include/linux/slab.h
@@ -473,14 +473,14 @@ static __always_inline void *kmalloc_nod
 #ifndef ARCH_SLAB_MINALIGN
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
+
+struct memcg_cache_array {
+	struct rcu_head rcu;
+	struct kmem_cache *entries[0];
+};
+
 /*
  * This is the main placeholder for memcg-related information in kmem caches.
- * struct kmem_cache will hold a pointer to it, so the memory cost while
- * disabled is 1 pointer. The runtime cost while enabled, gets bigger than it
- * would otherwise be if that would be bundled in kmem_cache: we'll need an
- * extra pointer chase. But the trade off clearly lays in favor of not
- * penalizing non-users.
- *
  * Both the root cache and the child caches will have it. For the root cache,
  * this will hold a dynamically allocated array large enough to hold
  * information about the currently limited memcgs in the system. To allow the
@@ -495,10 +495,7 @@ static __always_inline void *kmalloc_nod
 struct memcg_cache_params {
 	bool is_root_cache;
 	union {
-		struct {
-			struct rcu_head rcu_head;
-			struct kmem_cache *memcg_caches[0];
-		};
+		struct memcg_cache_array __rcu *memcg_caches;
 		struct {
 			struct mem_cgroup *memcg;
 			struct kmem_cache *root_cache;
diff -puN include/linux/slab_def.h~slab-embed-memcg_cache_params-to-kmem_cache include/linux/slab_def.h
--- a/include/linux/slab_def.h~slab-embed-memcg_cache_params-to-kmem_cache
+++ a/include/linux/slab_def.h
@@ -70,7 +70,7 @@ struct kmem_cache {
 	int obj_offset;
 #endif /* CONFIG_DEBUG_SLAB */
 #ifdef CONFIG_MEMCG_KMEM
-	struct memcg_cache_params *memcg_params;
+	struct memcg_cache_params memcg_params;
 #endif
 
 	struct kmem_cache_node *node[MAX_NUMNODES];
diff -puN include/linux/slub_def.h~slab-embed-memcg_cache_params-to-kmem_cache include/linux/slub_def.h
--- a/include/linux/slub_def.h~slab-embed-memcg_cache_params-to-kmem_cache
+++ a/include/linux/slub_def.h
@@ -85,7 +85,7 @@ struct kmem_cache {
 	struct kobject kobj;	/* For sysfs */
 #endif
 #ifdef CONFIG_MEMCG_KMEM
-	struct memcg_cache_params *memcg_params;
+	struct memcg_cache_params memcg_params;
 	int max_attr_size; /* for propagation, maximum size of a stored attr */
 #ifdef CONFIG_SYSFS
 	struct kset *memcg_kset;
diff -puN mm/memcontrol.c~slab-embed-memcg_cache_params-to-kmem_cache mm/memcontrol.c
--- a/mm/memcontrol.c~slab-embed-memcg_cache_params-to-kmem_cache
+++ a/mm/memcontrol.c
@@ -332,7 +332,7 @@ struct mem_cgroup {
 	struct cg_proto tcp_mem;
 #endif
 #if defined(CONFIG_MEMCG_KMEM)
-        /* Index in the kmem_cache->memcg_params->memcg_caches array */
+        /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
 #endif
 
@@ -531,7 +531,7 @@ static void disarm_sock_keys(struct mem_
 
 #ifdef CONFIG_MEMCG_KMEM
 /*
- * This will be the memcg's index in each cache's ->memcg_params->memcg_caches.
+ * This will be the memcg's index in each cache's ->memcg_params.memcg_caches.
  * The main reason for not using cgroup id for this:
  *  this works better in sparse environments, where we have a lot of memcgs,
  *  but only a few kmem-limited. Or also, if we have, for instance, 200
@@ -2667,8 +2667,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 	struct mem_cgroup *memcg;
 	struct kmem_cache *memcg_cachep;
 
-	VM_BUG_ON(!cachep->memcg_params);
-	VM_BUG_ON(!cachep->memcg_params->is_root_cache);
+	VM_BUG_ON(!is_root_cache(cachep));
 
 	if (current->memcg_kmem_skip_account)
 		return cachep;
@@ -2702,7 +2701,7 @@ out:
 void __memcg_kmem_put_cache(struct kmem_cache *cachep)
 {
 	if (!is_root_cache(cachep))
-		css_put(&cachep->memcg_params->memcg->css);
+		css_put(&cachep->memcg_params.memcg->css);
 }
 
 /*
@@ -2778,7 +2777,7 @@ struct mem_cgroup *__mem_cgroup_from_kme
 	if (PageSlab(page)) {
 		cachep = page->slab_cache;
 		if (!is_root_cache(cachep))
-			memcg = cachep->memcg_params->memcg;
+			memcg = cachep->memcg_params.memcg;
 	} else
 		/* page allocated by alloc_kmem_pages */
 		memcg = page->mem_cgroup;
diff -puN mm/slab.h~slab-embed-memcg_cache_params-to-kmem_cache mm/slab.h
--- a/mm/slab.h~slab-embed-memcg_cache_params-to-kmem_cache
+++ a/mm/slab.h
@@ -86,8 +86,6 @@ extern struct kmem_cache *create_kmalloc
 extern void create_boot_cache(struct kmem_cache *, const char *name,
 			size_t size, unsigned long flags);
 
-struct mem_cgroup;
-
 int slab_unmergeable(struct kmem_cache *s);
 struct kmem_cache *find_mergeable(size_t size, size_t align,
 		unsigned long flags, const char *name, void (*ctor)(void *));
@@ -167,14 +165,13 @@ ssize_t slabinfo_write(struct file *file
 #ifdef CONFIG_MEMCG_KMEM
 static inline bool is_root_cache(struct kmem_cache *s)
 {
-	return !s->memcg_params || s->memcg_params->is_root_cache;
+	return s->memcg_params.is_root_cache;
 }
 
 static inline bool slab_equal_or_root(struct kmem_cache *s,
-					struct kmem_cache *p)
+				      struct kmem_cache *p)
 {
-	return (p == s) ||
-		(s->memcg_params && (p == s->memcg_params->root_cache));
+	return p == s || p == s->memcg_params.root_cache;
 }
 
 /*
@@ -185,37 +182,30 @@ static inline bool slab_equal_or_root(st
 static inline const char *cache_name(struct kmem_cache *s)
 {
 	if (!is_root_cache(s))
-		return s->memcg_params->root_cache->name;
+		s = s->memcg_params.root_cache;
 	return s->name;
 }
 
 /*
  * Note, we protect with RCU only the memcg_caches array, not per-memcg caches.
- * That said the caller must assure the memcg's cache won't go away. Since once
- * created a memcg's cache is destroyed only along with the root cache, it is
- * true if we are going to allocate from the cache or hold a reference to the
- * root cache by other means. Otherwise, we should hold either the slab_mutex
- * or the memcg's slab_caches_mutex while calling this function and accessing
- * the returned value.
+ * That said the caller must assure the memcg's cache won't go away by either
+ * taking a css reference to the owner cgroup, or holding the slab_mutex.
  */
 static inline struct kmem_cache *
 cache_from_memcg_idx(struct kmem_cache *s, int idx)
 {
 	struct kmem_cache *cachep;
-	struct memcg_cache_params *params;
-
-	if (!s->memcg_params)
-		return NULL;
+	struct memcg_cache_array *arr;
 
 	rcu_read_lock();
-	params = rcu_dereference(s->memcg_params);
+	arr = rcu_dereference(s->memcg_params.memcg_caches);
 
 	/*
 	 * Make sure we will access the up-to-date value. The code updating
 	 * memcg_caches issues a write barrier to match this (see
-	 * memcg_register_cache()).
+	 * memcg_create_kmem_cache()).
 	 */
-	cachep = lockless_dereference(params->memcg_caches[idx]);
+	cachep = lockless_dereference(arr->entries[idx]);
 	rcu_read_unlock();
 
 	return cachep;
@@ -225,7 +215,7 @@ static inline struct kmem_cache *memcg_r
 {
 	if (is_root_cache(s))
 		return s;
-	return s->memcg_params->root_cache;
+	return s->memcg_params.root_cache;
 }
 
 static __always_inline int memcg_charge_slab(struct kmem_cache *s,
@@ -235,7 +225,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	if (is_root_cache(s))
 		return 0;
-	return memcg_charge_kmem(s->memcg_params->memcg, gfp, 1 << order);
+	return memcg_charge_kmem(s->memcg_params.memcg, gfp, 1 << order);
 }
 
 static __always_inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
@@ -244,9 +234,13 @@ static __always_inline void memcg_unchar
 		return;
 	if (is_root_cache(s))
 		return;
-	memcg_uncharge_kmem(s->memcg_params->memcg, 1 << order);
+	memcg_uncharge_kmem(s->memcg_params.memcg, 1 << order);
 }
-#else
+
+extern void slab_init_memcg_params(struct kmem_cache *);
+
+#else /* !CONFIG_MEMCG_KMEM */
+
 static inline bool is_root_cache(struct kmem_cache *s)
 {
 	return true;
@@ -282,7 +276,11 @@ static inline int memcg_charge_slab(stru
 static inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
 {
 }
-#endif
+
+static inline void slab_init_memcg_params(struct kmem_cache *s)
+{
+}
+#endif /* CONFIG_MEMCG_KMEM */
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
diff -puN mm/slab_common.c~slab-embed-memcg_cache_params-to-kmem_cache mm/slab_common.c
--- a/mm/slab_common.c~slab-embed-memcg_cache_params-to-kmem_cache
+++ a/mm/slab_common.c
@@ -106,62 +106,66 @@ static inline int kmem_cache_sanity_chec
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
-static int memcg_alloc_cache_params(struct mem_cgroup *memcg,
-		struct kmem_cache *s, struct kmem_cache *root_cache)
+void slab_init_memcg_params(struct kmem_cache *s)
 {
-	size_t size;
+	s->memcg_params.is_root_cache = true;
+	RCU_INIT_POINTER(s->memcg_params.memcg_caches, NULL);
+}
+
+static int init_memcg_params(struct kmem_cache *s,
+		struct mem_cgroup *memcg, struct kmem_cache *root_cache)
+{
+	struct memcg_cache_array *arr;
 
-	if (!memcg_kmem_enabled())
+	if (memcg) {
+		s->memcg_params.is_root_cache = false;
+		s->memcg_params.memcg = memcg;
+		s->memcg_params.root_cache = root_cache;
 		return 0;
+	}
 
-	if (!memcg) {
-		size = offsetof(struct memcg_cache_params, memcg_caches);
-		size += memcg_nr_cache_ids * sizeof(void *);
-	} else
-		size = sizeof(struct memcg_cache_params);
+	slab_init_memcg_params(s);
 
-	s->memcg_params = kzalloc(size, GFP_KERNEL);
-	if (!s->memcg_params)
-		return -ENOMEM;
+	if (!memcg_nr_cache_ids)
+		return 0;
 
-	if (memcg) {
-		s->memcg_params->memcg = memcg;
-		s->memcg_params->root_cache = root_cache;
-	} else
-		s->memcg_params->is_root_cache = true;
+	arr = kzalloc(sizeof(struct memcg_cache_array) +
+		      memcg_nr_cache_ids * sizeof(void *),
+		      GFP_KERNEL);
+	if (!arr)
+		return -ENOMEM;
 
+	RCU_INIT_POINTER(s->memcg_params.memcg_caches, arr);
 	return 0;
 }
 
-static void memcg_free_cache_params(struct kmem_cache *s)
+static void destroy_memcg_params(struct kmem_cache *s)
 {
-	kfree(s->memcg_params);
+	if (is_root_cache(s))
+		kfree(rcu_access_pointer(s->memcg_params.memcg_caches));
 }
 
-static int memcg_update_cache_params(struct kmem_cache *s, int num_memcgs)
+static int update_memcg_params(struct kmem_cache *s, int new_array_size)
 {
-	int size;
-	struct memcg_cache_params *new_params, *cur_params;
-
-	BUG_ON(!is_root_cache(s));
+	struct memcg_cache_array *old, *new;
 
-	size = offsetof(struct memcg_cache_params, memcg_caches);
-	size += num_memcgs * sizeof(void *);
+	if (!is_root_cache(s))
+		return 0;
 
-	new_params = kzalloc(size, GFP_KERNEL);
-	if (!new_params)
+	new = kzalloc(sizeof(struct memcg_cache_array) +
+		      new_array_size * sizeof(void *), GFP_KERNEL);
+	if (!new)
 		return -ENOMEM;
 
-	cur_params = s->memcg_params;
-	memcpy(new_params->memcg_caches, cur_params->memcg_caches,
-	       memcg_nr_cache_ids * sizeof(void *));
-
-	new_params->is_root_cache = true;
-
-	rcu_assign_pointer(s->memcg_params, new_params);
-	if (cur_params)
-		kfree_rcu(cur_params, rcu_head);
-
+	old = rcu_dereference_protected(s->memcg_params.memcg_caches,
+					lockdep_is_held(&slab_mutex));
+	if (old)
+		memcpy(new->entries, old->entries,
+		       memcg_nr_cache_ids * sizeof(void *));
+
+	rcu_assign_pointer(s->memcg_params.memcg_caches, new);
+	if (old)
+		kfree_rcu(old, rcu);
 	return 0;
 }
 
@@ -172,10 +176,7 @@ int memcg_update_all_caches(int num_memc
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
-		if (!is_root_cache(s))
-			continue;
-
-		ret = memcg_update_cache_params(s, num_memcgs);
+		ret = update_memcg_params(s, num_memcgs);
 		/*
 		 * Instead of freeing the memory, we'll just leave the caches
 		 * up to this point in an updated state.
@@ -187,13 +188,13 @@ int memcg_update_all_caches(int num_memc
 	return ret;
 }
 #else
-static inline int memcg_alloc_cache_params(struct mem_cgroup *memcg,
-		struct kmem_cache *s, struct kmem_cache *root_cache)
+static inline int init_memcg_params(struct kmem_cache *s,
+		struct mem_cgroup *memcg, struct kmem_cache *root_cache)
 {
 	return 0;
 }
 
-static inline void memcg_free_cache_params(struct kmem_cache *s)
+static inline void destroy_memcg_params(struct kmem_cache *s)
 {
 }
 #endif /* CONFIG_MEMCG_KMEM */
@@ -311,7 +312,7 @@ do_kmem_cache_create(char *name, size_t
 	s->align = align;
 	s->ctor = ctor;
 
-	err = memcg_alloc_cache_params(memcg, s, root_cache);
+	err = init_memcg_params(s, memcg, root_cache);
 	if (err)
 		goto out_free_cache;
 
@@ -327,7 +328,7 @@ out:
 	return s;
 
 out_free_cache:
-	memcg_free_cache_params(s);
+	destroy_memcg_params(s);
 	kmem_cache_free(kmem_cache, s);
 	goto out;
 }
@@ -439,11 +440,15 @@ static int do_kmem_cache_shutdown(struct
 
 #ifdef CONFIG_MEMCG_KMEM
 	if (!is_root_cache(s)) {
-		struct kmem_cache *root_cache = s->memcg_params->root_cache;
-		int memcg_id = memcg_cache_id(s->memcg_params->memcg);
+		int idx;
+		struct memcg_cache_array *arr;
 
-		BUG_ON(root_cache->memcg_params->memcg_caches[memcg_id] != s);
-		root_cache->memcg_params->memcg_caches[memcg_id] = NULL;
+		idx = memcg_cache_id(s->memcg_params.memcg);
+		arr = rcu_dereference_protected(s->memcg_params.root_cache->
+						memcg_params.memcg_caches,
+						lockdep_is_held(&slab_mutex));
+		BUG_ON(arr->entries[idx] != s);
+		arr->entries[idx] = NULL;
 	}
 #endif
 	list_move(&s->list, release);
@@ -481,27 +486,32 @@ void memcg_create_kmem_cache(struct mem_
 			     struct kmem_cache *root_cache)
 {
 	static char memcg_name_buf[NAME_MAX + 1]; /* protected by slab_mutex */
-	int memcg_id = memcg_cache_id(memcg);
+	struct memcg_cache_array *arr;
 	struct kmem_cache *s = NULL;
 	char *cache_name;
+	int idx;
 
 	get_online_cpus();
 	get_online_mems();
 
 	mutex_lock(&slab_mutex);
 
+	idx = memcg_cache_id(memcg);
+	arr = rcu_dereference_protected(root_cache->memcg_params.memcg_caches,
+					lockdep_is_held(&slab_mutex));
+
 	/*
 	 * Since per-memcg caches are created asynchronously on first
 	 * allocation (see memcg_kmem_get_cache()), several threads can try to
 	 * create the same cache, but only one of them may succeed.
 	 */
-	if (cache_from_memcg_idx(root_cache, memcg_id))
+	if (arr->entries[idx])
 		goto out_unlock;
 
 	cgroup_name(mem_cgroup_css(memcg)->cgroup,
 		    memcg_name_buf, sizeof(memcg_name_buf));
 	cache_name = kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
-			       memcg_cache_id(memcg), memcg_name_buf);
+			       idx, memcg_name_buf);
 	if (!cache_name)
 		goto out_unlock;
 
@@ -525,7 +535,7 @@ void memcg_create_kmem_cache(struct mem_
 	 * initialized.
 	 */
 	smp_wmb();
-	root_cache->memcg_params->memcg_caches[memcg_id] = s;
+	arr->entries[idx] = s;
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
@@ -545,7 +555,7 @@ void memcg_destroy_kmem_caches(struct me
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry_safe(s, s2, &slab_caches, list) {
-		if (is_root_cache(s) || s->memcg_params->memcg != memcg)
+		if (is_root_cache(s) || s->memcg_params.memcg != memcg)
 			continue;
 		/*
 		 * The cgroup is about to be freed and therefore has no charges
@@ -564,7 +574,7 @@ void memcg_destroy_kmem_caches(struct me
 
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
-	memcg_free_cache_params(s);
+	destroy_memcg_params(s);
 	kfree(s->name);
 	kmem_cache_free(kmem_cache, s);
 }
@@ -640,6 +650,9 @@ void __init create_boot_cache(struct kme
 	s->name = name;
 	s->size = s->object_size = size;
 	s->align = calculate_alignment(flags, ARCH_KMALLOC_MINALIGN, size);
+
+	slab_init_memcg_params(s);
+
 	err = __kmem_cache_create(s, flags);
 
 	if (err)
@@ -980,7 +993,7 @@ int memcg_slab_show(struct seq_file *m,
 
 	if (p == slab_caches.next)
 		print_slabinfo_header(m);
-	if (!is_root_cache(s) && s->memcg_params->memcg == memcg)
+	if (!is_root_cache(s) && s->memcg_params.memcg == memcg)
 		cache_show(s, m);
 	return 0;
 }
diff -puN mm/slub.c~slab-embed-memcg_cache_params-to-kmem_cache mm/slub.c
--- a/mm/slub.c~slab-embed-memcg_cache_params-to-kmem_cache
+++ a/mm/slub.c
@@ -3577,6 +3577,7 @@ static struct kmem_cache * __init bootst
 			p->slab_cache = s;
 #endif
 	}
+	slab_init_memcg_params(s);
 	list_add(&s->list, &slab_caches);
 	return s;
 }
@@ -4964,7 +4965,7 @@ static void memcg_propagate_slab_attrs(s
 	if (is_root_cache(s))
 		return;
 
-	root_cache = s->memcg_params->root_cache;
+	root_cache = s->memcg_params.root_cache;
 
 	/*
 	 * This mean this cache had no attribute written. Therefore, no point
@@ -5044,7 +5045,7 @@ static inline struct kset *cache_kset(st
 {
 #ifdef CONFIG_MEMCG_KMEM
 	if (!is_root_cache(s))
-		return s->memcg_params->root_cache->memcg_kset;
+		return s->memcg_params.root_cache->memcg_kset;
 #endif
 	return slab_kset;
 }
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

