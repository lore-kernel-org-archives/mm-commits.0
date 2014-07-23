From: akpm@linux-foundation.org
Subject: [withdrawn]
 memcg-keep-all-children-of-each-root-cache-on-a-list.patch removed from -mm tree
Date: Wed, 23 Jul 2014 12:14:47 -0700
Message-ID: <53d009a7.38taOyWaUVIDpOt0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:36891 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaGWTOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 15:14:48 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so472435iec.3
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 12:14:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: keep all children of each root cache on a list
has been removed from the -mm tree.  Its filename was
     memcg-keep-all-children-of-each-root-cache-on-a-list.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: keep all children of each root cache on a list

Sometimes we need to iterate over all child caches of a particular root
cache, e.g.  when we are destroying it.  Currently each root cache keeps
pointers to its children in its memcg_cache_params->memcg_caches_array so
that we can enumerate all active kmemcg ids dereferencing appropriate
array slots to get a memcg.

However, I'm going to make memcg clear the slots on offline to avoid
uncontrollable memcg_caches arrays growth.  Hence to iterate over all
memcg caches of a particular root cache we have to link all memcg caches
to per root cache lists.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 -
 include/linux/slab.h       |    3 ++
 mm/memcontrol.c            |   27 ++++++++++-------------
 mm/slab.c                  |   40 ++++++++++++++++++++---------------
 mm/slab_common.c           |   31 ++++++++++++++-------------
 mm/slub.c                  |   39 ++++++++++++++++++++--------------
 6 files changed, 79 insertions(+), 63 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-keep-all-children-of-each-root-cache-on-a-list include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-keep-all-children-of-each-root-cache-on-a-list
+++ a/include/linux/memcontrol.h
@@ -451,7 +451,7 @@ __memcg_kmem_get_cache(struct kmem_cache
 int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
 void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);
 
-int __memcg_cleanup_cache_params(struct kmem_cache *s);
+void __memcg_cleanup_cache_params(struct kmem_cache *s);
 
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
diff -puN include/linux/slab.h~memcg-keep-all-children-of-each-root-cache-on-a-list include/linux/slab.h
--- a/include/linux/slab.h~memcg-keep-all-children-of-each-root-cache-on-a-list
+++ a/include/linux/slab.h
@@ -527,6 +527,7 @@ static __always_inline void *kmalloc_nod
  * @memcg: pointer to the memcg this cache belongs to
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
+ * @siblings: list_head for the list of all child caches of the root_cache
  * @nr_pages: number of pages that belongs to this cache.
  */
 struct memcg_cache_params {
@@ -534,6 +535,7 @@ struct memcg_cache_params {
 	union {
 		struct {
 			struct rcu_head rcu_head;
+			struct list_head children;
 			struct kmem_cache *memcg_caches[0];
 		};
 		struct {
@@ -541,6 +543,7 @@ struct memcg_cache_params {
 			struct mem_cgroup *memcg;
 			struct list_head list;
 			struct kmem_cache *root_cache;
+			struct list_head siblings;
 			atomic_t nr_pages;
 		};
 	};
diff -puN mm/memcontrol.c~memcg-keep-all-children-of-each-root-cache-on-a-list mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-keep-all-children-of-each-root-cache-on-a-list
+++ a/mm/memcontrol.c
@@ -2928,6 +2928,10 @@ int memcg_update_cache_size(struct kmem_
 			return -ENOMEM;
 
 		new_params->is_root_cache = true;
+		INIT_LIST_HEAD(&new_params->children);
+		if (cur_params)
+			list_replace(&cur_params->children,
+				     &new_params->children);
 
 		/*
 		 * There is the chance it will be bigger than
@@ -2984,8 +2988,10 @@ int memcg_alloc_cache_params(struct mem_
 		s->memcg_params->memcg = memcg;
 		s->memcg_params->root_cache = root_cache;
 		css_get(&memcg->css);
-	} else
+	} else {
 		s->memcg_params->is_root_cache = true;
+		INIT_LIST_HEAD(&s->memcg_params->children);
+	}
 
 	return 0;
 }
@@ -3104,24 +3110,15 @@ static inline void memcg_resume_kmem_acc
 	current->memcg_kmem_skip_account--;
 }
 
-int __memcg_cleanup_cache_params(struct kmem_cache *s)
+void __memcg_cleanup_cache_params(struct kmem_cache *s)
 {
-	struct kmem_cache *c;
-	int i, failed = 0;
+	struct memcg_cache_params *params, *tmp;
 
 	mutex_lock(&memcg_slab_mutex);
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
+	list_for_each_entry_safe(params, tmp,
+			&s->memcg_params->children, siblings)
+		memcg_unregister_cache(params->cachep);
 	mutex_unlock(&memcg_slab_mutex);
-	return failed;
 }
 
 static void memcg_unregister_all_caches(struct mem_cgroup *memcg)
diff -puN mm/slab.c~memcg-keep-all-children-of-each-root-cache-on-a-list mm/slab.c
--- a/mm/slab.c~memcg-keep-all-children-of-each-root-cache-on-a-list
+++ a/mm/slab.c
@@ -3781,29 +3781,35 @@ static int __do_tune_cpucache(struct kme
 	return alloc_kmem_cache_node(cachep, gfp);
 }
 
+static void memcg_do_tune_cpucache(struct kmem_cache *cachep, int limit,
+				   int batchcount, int shared, gfp_t gfp)
+{
+#ifdef CONFIG_MEMCG_KMEM
+	struct memcg_cache_params *params;
+
+	if (!cachep->memcg_params ||
+	    !cachep->memcg_params->is_root_cache)
+		return;
+
+	lockdep_assert_held(&slab_mutex);
+	list_for_each_entry(params,
+			&cachep->memcg_params->children, siblings) {
+		/* return value determined by the parent cache only */
+		__do_tune_cpucache(params->cachep, limit,
+				   batchcount, shared, gfp);
+	}
+#endif
+}
+
 static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
 				int batchcount, int shared, gfp_t gfp)
 {
 	int ret;
-	struct kmem_cache *c = NULL;
-	int i = 0;
 
 	ret = __do_tune_cpucache(cachep, limit, batchcount, shared, gfp);
-
-	if (slab_state < FULL)
-		return ret;
-
-	if ((ret < 0) || !is_root_cache(cachep))
-		return ret;
-
-	VM_BUG_ON(!mutex_is_locked(&slab_mutex));
-	for_each_memcg_cache_index(i) {
-		c = cache_from_memcg_idx(cachep, i);
-		if (c)
-			/* return value determined by the parent cache only */
-			__do_tune_cpucache(c, limit, batchcount, shared, gfp);
-	}
-
+	if (!ret)
+		memcg_do_tune_cpucache(cachep, limit,
+				       batchcount, shared, gfp);
 	return ret;
 }
 
diff -puN mm/slab_common.c~memcg-keep-all-children-of-each-root-cache-on-a-list mm/slab_common.c
--- a/mm/slab_common.c~memcg-keep-all-children-of-each-root-cache-on-a-list
+++ a/mm/slab_common.c
@@ -287,7 +287,10 @@ struct kmem_cache *memcg_create_kmem_cac
 				 root_cache->size, root_cache->align,
 				 root_cache->flags, root_cache->ctor,
 				 memcg, root_cache);
-	if (IS_ERR(s))
+	if (!IS_ERR(s))
+		list_add(&s->memcg_params->siblings,
+			 &root_cache->memcg_params->children);
+	else
 		s = NULL;
 
 	mutex_unlock(&slab_mutex);
@@ -300,17 +303,15 @@ struct kmem_cache *memcg_create_kmem_cac
 
 static int memcg_cleanup_cache_params(struct kmem_cache *s)
 {
-	int rc;
-
 	if (!s->memcg_params ||
 	    !s->memcg_params->is_root_cache)
 		return 0;
 
 	mutex_unlock(&slab_mutex);
-	rc = __memcg_cleanup_cache_params(s);
+	__memcg_cleanup_cache_params(s);
 	mutex_lock(&slab_mutex);
 
-	return rc;
+	return !list_empty(&s->memcg_params->children);
 }
 #else
 static int memcg_cleanup_cache_params(struct kmem_cache *s)
@@ -347,6 +348,10 @@ void kmem_cache_destroy(struct kmem_cach
 	}
 
 	list_del(&s->list);
+#ifdef CONFIG_MEMCG_KMEM
+	if (!is_root_cache(s))
+		list_del(&s->memcg_params->siblings);
+#endif
 
 	mutex_unlock(&slab_mutex);
 	if (s->flags & SLAB_DESTROY_BY_RCU)
@@ -685,20 +690,17 @@ void slab_stop(struct seq_file *m, void
 static void
 memcg_accumulate_slabinfo(struct kmem_cache *s, struct slabinfo *info)
 {
-	struct kmem_cache *c;
+#ifdef CONFIG_MEMCG_KMEM
+	struct memcg_cache_params *params;
 	struct slabinfo sinfo;
-	int i;
 
-	if (!is_root_cache(s))
+	if (!s->memcg_params ||
+	    !s->memcg_params->is_root_cache)
 		return;
 
-	for_each_memcg_cache_index(i) {
-		c = cache_from_memcg_idx(s, i);
-		if (!c)
-			continue;
-
+	list_for_each_entry(params, &s->memcg_params->children, siblings) {
 		memset(&sinfo, 0, sizeof(sinfo));
-		get_slabinfo(c, &sinfo);
+		get_slabinfo(params->cachep, &sinfo);
 
 		info->active_slabs += sinfo.active_slabs;
 		info->num_slabs += sinfo.num_slabs;
@@ -706,6 +708,7 @@ memcg_accumulate_slabinfo(struct kmem_ca
 		info->active_objs += sinfo.active_objs;
 		info->num_objs += sinfo.num_objs;
 	}
+#endif
 }
 
 int cache_show(struct kmem_cache *s, struct seq_file *m)
diff -puN mm/slub.c~memcg-keep-all-children-of-each-root-cache-on-a-list mm/slub.c
--- a/mm/slub.c~memcg-keep-all-children-of-each-root-cache-on-a-list
+++ a/mm/slub.c
@@ -3688,6 +3688,23 @@ static struct kmem_cache *find_mergeable
 	return NULL;
 }
 
+static void memcg_slab_merge(struct kmem_cache *s, size_t size)
+{
+#ifdef CONFIG_MEMCG_KMEM
+	struct kmem_cache *c;
+	struct memcg_cache_params *params;
+
+	if (!s->memcg_params)
+		return;
+
+	list_for_each_entry(params, &s->memcg_params->children, siblings) {
+		c = params->cachep;
+		c->object_size = s->object_size;
+		c->inuse = max_t(int, c->inuse, ALIGN(size, sizeof(void *)));
+	}
+#endif
+}
+
 struct kmem_cache *
 __kmem_cache_alias(const char *name, size_t size, size_t align,
 		   unsigned long flags, void (*ctor)(void *))
@@ -3696,9 +3713,6 @@ __kmem_cache_alias(const char *name, siz
 
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
-		int i;
-		struct kmem_cache *c;
-
 		s->refcount++;
 
 		/*
@@ -3708,14 +3722,7 @@ __kmem_cache_alias(const char *name, siz
 		s->object_size = max(s->object_size, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 
-		for_each_memcg_cache_index(i) {
-			c = cache_from_memcg_idx(s, i);
-			if (!c)
-				continue;
-			c->object_size = s->object_size;
-			c->inuse = max_t(int, c->inuse,
-					 ALIGN(size, sizeof(void *)));
-		}
+		memcg_slab_merge(s, size);
 
 		if (sysfs_slab_alias(s, name)) {
 			s->refcount--;
@@ -4966,7 +4973,7 @@ static ssize_t slab_attr_store(struct ko
 	err = attribute->store(s, buf, len);
 #ifdef CONFIG_MEMCG_KMEM
 	if (slab_state >= FULL && err >= 0 && is_root_cache(s)) {
-		int i;
+		struct memcg_cache_params *params;
 
 		mutex_lock(&slab_mutex);
 		if (s->max_attr_size < len)
@@ -4989,10 +4996,10 @@ static ssize_t slab_attr_store(struct ko
 		 * directly either failed or succeeded, in which case we loop
 		 * through the descendants with best-effort propagation.
 		 */
-		for_each_memcg_cache_index(i) {
-			struct kmem_cache *c = cache_from_memcg_idx(s, i);
-			if (c)
-				attribute->store(c, buf, len);
+		if (s->memcg_params) {
+			list_for_each_entry(params,
+					&s->memcg_params->children, siblings)
+				attribute->store(params->cachep, buf, len);
 		}
 		mutex_unlock(&slab_mutex);
 	}
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
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
fork-make-mm_init_owner-static.patch
linux-next.patch

