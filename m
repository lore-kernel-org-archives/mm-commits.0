From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch removed
 from -mm tree
Date: Wed, 20 Jan 2016 14:39:44 -0800
Message-ID: <56a00cb0.pv5gzjE+Y11l8qWB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbcATWjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:39:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, arnd@arndb.de, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch

This patch was dropped because it was folded into mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2

The cgroup2 memory controller will account important in-kernel memory
consumers per default. Move all necessary components to CONFIG_MEMCG.

here is a drop-in replacement for what's in your tree to make slob work
with memcg again.  It guards all the kmem-specific stuff with CONFIG_MEMCG
&& !CONFIG_SLOB.  A little lame but I figure it's not worth introducing
another level of indirection and go through the trouble of finding a more
meaningful symbol (CONFIG_MEMCG_KMEM is taken, CONFIG_MEMCG_SLAB is
ambiguous with SLAB vs.  SLUB etc.).

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h   |    4 
 include/linux/memcontrol.h |  318 +++++++++++++++++------------------
 include/linux/sched.h      |    2 
 include/linux/slab.h       |    2 
 mm/list_lru.c              |   12 -
 mm/memcontrol.c            |   21 ++
 mm/slab.h                  |    6 
 mm/slab_common.c           |   10 -
 8 files changed, 200 insertions(+), 175 deletions(-)

diff -puN include/linux/list_lru.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2 include/linux/list_lru.h
--- a/include/linux/list_lru.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
+++ a/include/linux/list_lru.h
@@ -40,7 +40,7 @@ struct list_lru_node {
 	spinlock_t		lock;
 	/* global list, used for the root cgroup in cgroup aware lrus */
 	struct list_lru_one	lru;
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 	/* for cgroup aware lrus points to per cgroup lists, otherwise NULL */
 	struct list_lru_memcg	*memcg_lrus;
 #endif
@@ -48,7 +48,7 @@ struct list_lru_node {
 
 struct list_lru {
 	struct list_lru_node	*node;
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 	struct list_head	list;
 #endif
 };
diff -puN include/linux/memcontrol.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
+++ a/include/linux/memcontrol.h
@@ -236,10 +236,11 @@ struct mem_cgroup {
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct cg_proto tcp_mem;
 #endif
-
+#ifndef CONFIG_SLOB
         /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
 	enum memcg_kmem_state kmem_state;
+#endif
 
 	int last_scanned_node;
 #if MAX_NUMNODES > 1
@@ -504,117 +505,6 @@ out:
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
 
-extern struct static_key_false memcg_kmem_enabled_key;
-
-extern int memcg_nr_cache_ids;
-void memcg_get_cache_ids(void);
-void memcg_put_cache_ids(void);
-
-/*
- * Helper macro to loop through all memcg-specific caches. Callers must still
- * check if the cache is valid (it is either valid or NULL).
- * the slab_mutex must be held when looping through those caches
- */
-#define for_each_memcg_cache_index(_idx)	\
-	for ((_idx) = 0; (_idx) < memcg_nr_cache_ids; (_idx)++)
-
-static inline bool memcg_kmem_enabled(void)
-{
-	return static_branch_unlikely(&memcg_kmem_enabled_key);
-}
-
-static inline bool memcg_kmem_online(struct mem_cgroup *memcg)
-{
-	return memcg->kmem_state == KMEM_ONLINE;
-}
-
-/*
- * In general, we'll do everything in our power to not incur in any overhead
- * for non-memcg users for the kmem functions. Not even a function call, if we
- * can avoid it.
- *
- * Therefore, we'll inline all those functions so that in the best case, we'll
- * see that kmemcg is off for everybody and proceed quickly.  If it is on,
- * we'll still do most of the flag checking inline. We check a lot of
- * conditions, but because they are pretty simple, they are expected to be
- * fast.
- */
-int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
-			      struct mem_cgroup *memcg);
-int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
-void __memcg_kmem_uncharge(struct page *page, int order);
-
-/*
- * helper for acessing a memcg's index. It will be used as an index in the
- * child cache array in kmem_cache, and also to derive its name. This function
- * will return -1 when this is not a kmem-limited memcg.
- */
-static inline int memcg_cache_id(struct mem_cgroup *memcg)
-{
-	return memcg ? memcg->kmemcg_id : -1;
-}
-
-struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
-void __memcg_kmem_put_cache(struct kmem_cache *cachep);
-
-static inline bool __memcg_kmem_bypass(void)
-{
-	if (!memcg_kmem_enabled())
-		return true;
-	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
-		return true;
-	return false;
-}
-
-/**
- * memcg_kmem_charge: charge a kmem page
- * @page: page to charge
- * @gfp: reclaim mode
- * @order: allocation order
- *
- * Returns 0 on success, an error code on failure.
- */
-static __always_inline int memcg_kmem_charge(struct page *page,
-					     gfp_t gfp, int order)
-{
-	if (__memcg_kmem_bypass())
-		return 0;
-	if (!(gfp & __GFP_ACCOUNT))
-		return 0;
-	return __memcg_kmem_charge(page, gfp, order);
-}
-
-/**
- * memcg_kmem_uncharge: uncharge a kmem page
- * @page: page to uncharge
- * @order: allocation order
- */
-static __always_inline void memcg_kmem_uncharge(struct page *page, int order)
-{
-	if (memcg_kmem_enabled())
-		__memcg_kmem_uncharge(page, order);
-}
-
-/**
- * memcg_kmem_get_cache: selects the correct per-memcg cache for allocation
- * @cachep: the original global kmem cache
- *
- * All memory allocated from a per-memcg cache is charged to the owner memcg.
- */
-static __always_inline struct kmem_cache *
-memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
-{
-	if (__memcg_kmem_bypass())
-		return cachep;
-	return __memcg_kmem_get_cache(cachep, gfp);
-}
-
-static __always_inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
-{
-	if (memcg_kmem_enabled())
-		__memcg_kmem_put_cache(cachep);
-}
-
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
@@ -790,52 +680,6 @@ static inline
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
-
-#define for_each_memcg_cache_index(_idx)	\
-	for (; NULL; )
-
-static inline bool memcg_kmem_enabled(void)
-{
-	return false;
-}
-
-static inline bool memcg_kmem_online(struct mem_cgroup *memcg)
-{
-	return false;
-}
-
-static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
-{
-	return 0;
-}
-
-static inline void memcg_kmem_uncharge(struct page *page, int order)
-{
-}
-
-static inline int memcg_cache_id(struct mem_cgroup *memcg)
-{
-	return -1;
-}
-
-static inline void memcg_get_cache_ids(void)
-{
-}
-
-static inline void memcg_put_cache_ids(void)
-{
-}
-
-static inline struct kmem_cache *
-memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
-{
-	return cachep;
-}
-
-static inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
-{
-}
-
 #endif /* CONFIG_MEMCG */
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -891,4 +735,162 @@ static inline bool mem_cgroup_under_sock
 }
 #endif
 
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
+extern struct static_key_false memcg_kmem_enabled_key;
+
+extern int memcg_nr_cache_ids;
+void memcg_get_cache_ids(void);
+void memcg_put_cache_ids(void);
+
+/*
+ * Helper macro to loop through all memcg-specific caches. Callers must still
+ * check if the cache is valid (it is either valid or NULL).
+ * the slab_mutex must be held when looping through those caches
+ */
+#define for_each_memcg_cache_index(_idx)	\
+	for ((_idx) = 0; (_idx) < memcg_nr_cache_ids; (_idx)++)
+
+static inline bool memcg_kmem_enabled(void)
+{
+	return static_branch_unlikely(&memcg_kmem_enabled_key);
+}
+
+static inline bool memcg_kmem_online(struct mem_cgroup *memcg)
+{
+	return memcg->kmem_state == KMEM_ONLINE;
+}
+
+/*
+ * In general, we'll do everything in our power to not incur in any overhead
+ * for non-memcg users for the kmem functions. Not even a function call, if we
+ * can avoid it.
+ *
+ * Therefore, we'll inline all those functions so that in the best case, we'll
+ * see that kmemcg is off for everybody and proceed quickly.  If it is on,
+ * we'll still do most of the flag checking inline. We check a lot of
+ * conditions, but because they are pretty simple, they are expected to be
+ * fast.
+ */
+int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
+			      struct mem_cgroup *memcg);
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
+void __memcg_kmem_uncharge(struct page *page, int order);
+
+/*
+ * helper for acessing a memcg's index. It will be used as an index in the
+ * child cache array in kmem_cache, and also to derive its name. This function
+ * will return -1 when this is not a kmem-limited memcg.
+ */
+static inline int memcg_cache_id(struct mem_cgroup *memcg)
+{
+	return memcg ? memcg->kmemcg_id : -1;
+}
+
+struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
+void __memcg_kmem_put_cache(struct kmem_cache *cachep);
+
+static inline bool __memcg_kmem_bypass(void)
+{
+	if (!memcg_kmem_enabled())
+		return true;
+	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
+		return true;
+	return false;
+}
+
+/**
+ * memcg_kmem_charge: charge a kmem page
+ * @page: page to charge
+ * @gfp: reclaim mode
+ * @order: allocation order
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+static __always_inline int memcg_kmem_charge(struct page *page,
+					     gfp_t gfp, int order)
+{
+	if (__memcg_kmem_bypass())
+		return 0;
+	if (!(gfp & __GFP_ACCOUNT))
+		return 0;
+	return __memcg_kmem_charge(page, gfp, order);
+}
+
+/**
+ * memcg_kmem_uncharge: uncharge a kmem page
+ * @page: page to uncharge
+ * @order: allocation order
+ */
+static __always_inline void memcg_kmem_uncharge(struct page *page, int order)
+{
+	if (memcg_kmem_enabled())
+		__memcg_kmem_uncharge(page, order);
+}
+
+/**
+ * memcg_kmem_get_cache: selects the correct per-memcg cache for allocation
+ * @cachep: the original global kmem cache
+ *
+ * All memory allocated from a per-memcg cache is charged to the owner memcg.
+ */
+static __always_inline struct kmem_cache *
+memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
+{
+	if (__memcg_kmem_bypass())
+		return cachep;
+	return __memcg_kmem_get_cache(cachep, gfp);
+}
+
+static __always_inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
+{
+	if (memcg_kmem_enabled())
+		__memcg_kmem_put_cache(cachep);
+}
+#else
+#define for_each_memcg_cache_index(_idx)	\
+	for (; NULL; )
+
+static inline bool memcg_kmem_enabled(void)
+{
+	return false;
+}
+
+static inline bool memcg_kmem_online(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
+static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+{
+	return 0;
+}
+
+static inline void memcg_kmem_uncharge(struct page *page, int order)
+{
+}
+
+static inline int memcg_cache_id(struct mem_cgroup *memcg)
+{
+	return -1;
+}
+
+static inline void memcg_get_cache_ids(void)
+{
+}
+
+static inline void memcg_put_cache_ids(void)
+{
+}
+
+static inline struct kmem_cache *
+memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
+{
+	return cachep;
+}
+
+static inline void memcg_kmem_put_cache(struct kmem_cache *cachep)
+{
+}
+#endif /* CONFIG_MEMCG && !CONFIG_SLOB */
+
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN include/linux/sched.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2 include/linux/sched.h
--- a/include/linux/sched.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
+++ a/include/linux/sched.h
@@ -1477,8 +1477,10 @@ struct task_struct {
 	unsigned in_iowait:1;
 #ifdef CONFIG_MEMCG
 	unsigned memcg_may_oom:1;
+#ifndef CONFIG_SLOB
 	unsigned memcg_kmem_skip_account:1;
 #endif
+#endif
 #ifdef CONFIG_COMPAT_BRK
 	unsigned brk_randomized:1;
 #endif
diff -puN include/linux/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2 include/linux/slab.h
--- a/include/linux/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
+++ a/include/linux/slab.h
@@ -86,7 +86,7 @@
 #else
 # define SLAB_FAILSLAB		0x00000000UL
 #endif
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_KMEM
 # define SLAB_ACCOUNT		0x04000000UL	/* Account to memcg */
 #else
 # define SLAB_ACCOUNT		0x00000000UL
diff -puN mm/list_lru.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2 mm/list_lru.c
--- a/mm/list_lru.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
+++ a/mm/list_lru.c
@@ -12,7 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/memcontrol.h>
 
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 static LIST_HEAD(list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
 
@@ -37,9 +37,9 @@ static void list_lru_register(struct lis
 static void list_lru_unregister(struct list_lru *lru)
 {
 }
-#endif /* CONFIG_MEMCG */
+#endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 static inline bool list_lru_memcg_aware(struct list_lru *lru)
 {
 	/*
@@ -104,7 +104,7 @@ list_lru_from_kmem(struct list_lru_node
 {
 	return &nlru->lru;
 }
-#endif /* CONFIG_MEMCG */
+#endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item)
 {
@@ -292,7 +292,7 @@ static void init_one_lru(struct list_lru
 	l->nr_items = 0;
 }
 
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 static void __memcg_destroy_list_lru_node(struct list_lru_memcg *memcg_lrus,
 					  int begin, int end)
 {
@@ -529,7 +529,7 @@ static int memcg_init_list_lru(struct li
 static void memcg_destroy_list_lru(struct list_lru *lru)
 {
 }
-#endif /* CONFIG_MEMCG */
+#endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 int __list_lru_init(struct list_lru *lru, bool memcg_aware,
 		    struct lock_class_key *key)
diff -puN mm/memcontrol.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
+++ a/mm/memcontrol.c
@@ -297,6 +297,7 @@ static inline struct mem_cgroup *mem_cgr
 	return mem_cgroup_from_css(css);
 }
 
+#ifndef CONFIG_SLOB
 /*
  * This will be the memcg's index in each cache's ->memcg_params.memcg_caches.
  * The main reason for not using cgroup id for this:
@@ -348,6 +349,8 @@ void memcg_put_cache_ids(void)
 DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
+#endif /* !CONFIG_SLOB */
+
 static struct mem_cgroup_per_zone *
 mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
 {
@@ -2200,6 +2203,7 @@ static void commit_charge(struct page *p
 		unlock_page_lru(page, isolated);
 }
 
+#ifndef CONFIG_SLOB
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
@@ -2420,6 +2424,7 @@ void __memcg_kmem_uncharge(struct page *
 	page->mem_cgroup = NULL;
 	css_put_many(&memcg->css, nr_pages);
 }
+#endif /* !CONFIG_SLOB */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
@@ -2855,6 +2860,7 @@ static u64 mem_cgroup_read_u64(struct cg
 	}
 }
 
+#ifndef CONFIG_SLOB
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	int err = 0;
@@ -2975,6 +2981,18 @@ static void memcg_free_kmem(struct mem_c
 		WARN_ON(page_counter_read(&memcg->kmem));
 	}
 }
+#else
+static int memcg_propagate_kmem(struct mem_cgroup *memcg)
+{
+	return 0;
+}
+static void memcg_offline_kmem(struct mem_cgroup *memcg)
+{
+}
+static void memcg_free_kmem(struct mem_cgroup *memcg)
+{
+}
+#endif /* !CONFIG_SLOB */
 
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
@@ -3002,6 +3020,7 @@ static int memcg_update_kmem_limit(struc
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+
 /*
  * The user of this function is...
  * RES_LIMIT.
@@ -4174,7 +4193,9 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->event_list);
 	spin_lock_init(&memcg->event_list_lock);
+#ifndef CONFIG_SLOB
 	memcg->kmemcg_id = -1;
+#endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 #endif
diff -puN mm/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2 mm/slab.h
--- a/mm/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
+++ a/mm/slab.h
@@ -173,7 +173,7 @@ ssize_t slabinfo_write(struct file *file
 void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
 int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
 
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 /*
  * Iterate over all memcg caches of the given root cache. The caller must hold
  * slab_mutex.
@@ -251,7 +251,7 @@ static __always_inline int memcg_charge_
 
 extern void slab_init_memcg_params(struct kmem_cache *);
 
-#else /* !CONFIG_MEMCG */
+#else /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 #define for_each_memcg_cache(iter, root) \
 	for ((void)(iter), (void)(root); 0; )
@@ -292,7 +292,7 @@ static inline int memcg_charge_slab(stru
 static inline void slab_init_memcg_params(struct kmem_cache *s)
 {
 }
-#endif /* CONFIG_MEMCG */
+#endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
diff -puN mm/slab_common.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2 mm/slab_common.c
--- a/mm/slab_common.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2
+++ a/mm/slab_common.c
@@ -128,7 +128,7 @@ int __kmem_cache_alloc_bulk(struct kmem_
 	return i;
 }
 
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 void slab_init_memcg_params(struct kmem_cache *s)
 {
 	s->memcg_params.is_root_cache = true;
@@ -221,7 +221,7 @@ static inline int init_memcg_params(stru
 static inline void destroy_memcg_params(struct kmem_cache *s)
 {
 }
-#endif /* CONFIG_MEMCG */
+#endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 /*
  * Find a mergeable slab cache
@@ -477,7 +477,7 @@ static void release_caches(struct list_h
 	}
 }
 
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 /*
  * memcg_create_kmem_cache - Create a cache for a memory cgroup.
  * @memcg: The memory cgroup the new cache is for.
@@ -689,7 +689,7 @@ static inline int shutdown_memcg_caches(
 {
 	return 0;
 }
-#endif /* CONFIG_MEMCG */
+#endif /* CONFIG_MEMCG && !CONFIG_SLOB */
 
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
@@ -1123,7 +1123,7 @@ static int slab_show(struct seq_file *m,
 	return 0;
 }
 
-#ifdef CONFIG_MEMCG
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 int memcg_slab_show(struct seq_file *m, void *p)
 {
 	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

