From: akpm@linux-foundation.org
Subject: + mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
 added to -mm tree
Date: Tue, 08 Dec 2015 15:06:46 -0800
Message-ID: <56676286.hDvD0zgDuWmKFizA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbLHXGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:06:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: move kmem accounting code to CONFIG_MEMCG
has been added to the -mm tree.  Its filename is
     mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: move kmem accounting code to CONFIG_MEMCG

The cgroup2 memory controller will account important in-kernel memory
consumers per default.  Move all necessary components to CONFIG_MEMCG.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h   |    4 
 include/linux/memcontrol.h |  317 +++++++++++++++++------------------
 include/linux/sched.h      |    2 
 include/linux/slab.h       |    2 
 include/linux/slab_def.h   |    3 
 include/linux/slub_def.h   |    2 
 mm/list_lru.c              |   12 -
 mm/memcontrol.c            |   54 ++---
 mm/slab.h                  |    6 
 mm/slab_common.c           |   10 -
 mm/slub.c                  |   10 -
 11 files changed, 206 insertions(+), 216 deletions(-)

diff -puN include/linux/list_lru.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg include/linux/list_lru.h
--- a/include/linux/list_lru.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/include/linux/list_lru.h
@@ -40,7 +40,7 @@ struct list_lru_node {
 	spinlock_t		lock;
 	/* global list, used for the root cgroup in cgroup aware lrus */
 	struct list_lru_one	lru;
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	/* for cgroup aware lrus points to per cgroup lists, otherwise NULL */
 	struct list_lru_memcg	*memcg_lrus;
 #endif
@@ -48,7 +48,7 @@ struct list_lru_node {
 
 struct list_lru {
 	struct list_lru_node	*node;
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	struct list_head	list;
 #endif
 };
diff -puN include/linux/memcontrol.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/include/linux/memcontrol.h
@@ -236,11 +236,10 @@ struct mem_cgroup {
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct cg_proto tcp_mem;
 #endif
-#if defined(CONFIG_MEMCG_KMEM)
+
         /* Index in the kmem_cache->memcg_params.memcg_caches array */
 	int kmemcg_id;
 	enum memcg_kmem_state kmem_state;
-#endif
 
 	int last_scanned_node;
 #if MAX_NUMNODES > 1
@@ -505,6 +504,117 @@ out:
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
 
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
+
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
@@ -680,6 +790,52 @@ static inline
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
+
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
+
 #endif /* CONFIG_MEMCG */
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -735,161 +891,4 @@ static inline bool mem_cgroup_under_sock
 }
 #endif
 
-#ifdef CONFIG_MEMCG_KMEM
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
-#else
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
-#endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN include/linux/sched.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg include/linux/sched.h
--- a/include/linux/sched.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/include/linux/sched.h
@@ -1465,8 +1465,6 @@ struct task_struct {
 	unsigned sched_migrated:1;
 #ifdef CONFIG_MEMCG
 	unsigned memcg_may_oom:1;
-#endif
-#ifdef CONFIG_MEMCG_KMEM
 	unsigned memcg_kmem_skip_account:1;
 #endif
 #ifdef CONFIG_COMPAT_BRK
diff -puN include/linux/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg include/linux/slab.h
--- a/include/linux/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/include/linux/slab.h
@@ -86,7 +86,7 @@
 #else
 # define SLAB_FAILSLAB		0x00000000UL
 #endif
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 # define SLAB_ACCOUNT		0x04000000UL	/* Account to memcg */
 #else
 # define SLAB_ACCOUNT		0x00000000UL
diff -puN include/linux/slab_def.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg include/linux/slab_def.h
--- a/include/linux/slab_def.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/include/linux/slab_def.h
@@ -69,7 +69,8 @@ struct kmem_cache {
 	 */
 	int obj_offset;
 #endif /* CONFIG_DEBUG_SLAB */
-#ifdef CONFIG_MEMCG_KMEM
+
+#ifdef CONFIG_MEMCG
 	struct memcg_cache_params memcg_params;
 #endif
 
diff -puN include/linux/slub_def.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/include/linux/slub_def.h
@@ -84,7 +84,7 @@ struct kmem_cache {
 #ifdef CONFIG_SYSFS
 	struct kobject kobj;	/* For sysfs */
 #endif
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	struct memcg_cache_params memcg_params;
 	int max_attr_size; /* for propagation, maximum size of a stored attr */
 #ifdef CONFIG_SYSFS
diff -puN mm/list_lru.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg mm/list_lru.c
--- a/mm/list_lru.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/mm/list_lru.c
@@ -12,7 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/memcontrol.h>
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 static LIST_HEAD(list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
 
@@ -37,9 +37,9 @@ static void list_lru_register(struct lis
 static void list_lru_unregister(struct list_lru *lru)
 {
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG */
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 static inline bool list_lru_memcg_aware(struct list_lru *lru)
 {
 	/*
@@ -104,7 +104,7 @@ list_lru_from_kmem(struct list_lru_node
 {
 	return &nlru->lru;
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG */
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item)
 {
@@ -292,7 +292,7 @@ static void init_one_lru(struct list_lru
 	l->nr_items = 0;
 }
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 static void __memcg_destroy_list_lru_node(struct list_lru_memcg *memcg_lrus,
 					  int begin, int end)
 {
@@ -529,7 +529,7 @@ static int memcg_init_list_lru(struct li
 static void memcg_destroy_list_lru(struct list_lru *lru)
 {
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG */
 
 int __list_lru_init(struct list_lru *lru, bool memcg_aware,
 		    struct lock_class_key *key)
diff -puN mm/memcontrol.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/mm/memcontrol.c
@@ -297,7 +297,6 @@ static inline struct mem_cgroup *mem_cgr
 	return mem_cgroup_from_css(css);
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 /*
  * This will be the memcg's index in each cache's ->memcg_params.memcg_caches.
  * The main reason for not using cgroup id for this:
@@ -349,8 +348,6 @@ void memcg_put_cache_ids(void)
 DEFINE_STATIC_KEY_FALSE(memcg_kmem_enabled_key);
 EXPORT_SYMBOL(memcg_kmem_enabled_key);
 
-#endif /* CONFIG_MEMCG_KMEM */
-
 static struct mem_cgroup_per_zone *
 mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
 {
@@ -2182,7 +2179,6 @@ static void commit_charge(struct page *p
 		unlock_page_lru(page, isolated);
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
@@ -2403,7 +2399,6 @@ void __memcg_kmem_uncharge(struct page *
 	page->mem_cgroup = NULL;
 	css_put_many(&memcg->css, nr_pages);
 }
-#endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
@@ -2839,7 +2834,6 @@ static u64 mem_cgroup_read_u64(struct cg
 	}
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	int err = 0;
@@ -2887,24 +2881,6 @@ out:
 	return err;
 }
 
-static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
-				   unsigned long limit)
-{
-	int ret;
-
-	mutex_lock(&memcg_limit_mutex);
-	/* Top-level cgroup doesn't propagate from root */
-	if (!memcg_kmem_online(memcg)) {
-		ret = memcg_online_kmem(memcg);
-		if (ret)
-			goto out;
-	}
-	ret = page_counter_limit(&memcg->kmem, limit);
-out:
-	mutex_unlock(&memcg_limit_mutex);
-	return ret;
-}
-
 static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 {
 	int ret = 0;
@@ -2978,14 +2954,30 @@ static void memcg_free_kmem(struct mem_c
 		WARN_ON(page_counter_read(&memcg->kmem));
 	}
 }
-#else
+
+#ifdef CONFIG_MEMCG_KMEM
 static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
 {
-	return -EINVAL;
+	int ret;
+
+	mutex_lock(&memcg_limit_mutex);
+	/* Top-level cgroup doesn't propagate from root */
+	if (!memcg_kmem_online(memcg)) {
+		ret = memcg_online_kmem(memcg);
+		if (ret)
+			goto out;
+	}
+	ret = page_counter_limit(&memcg->kmem, limit);
+out:
+	mutex_unlock(&memcg_limit_mutex);
+	return ret;
 }
-static void memcg_offline_kmem(struct mem_cgroup *memcg)
+#else
+static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
+				   unsigned long limit)
 {
+	return -EINVAL;
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
@@ -4160,9 +4152,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->event_list);
 	spin_lock_init(&memcg->event_list_lock);
-#ifdef CONFIG_MEMCG_KMEM
 	memcg->kmemcg_id = -1;
-#endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 #endif
@@ -4222,10 +4212,11 @@ mem_cgroup_css_online(struct cgroup_subs
 	}
 	mutex_unlock(&memcg_create_mutex);
 
-#ifdef CONFIG_MEMCG_KMEM
 	ret = memcg_propagate_kmem(memcg);
 	if (ret)
 		return ret;
+
+#ifdef CONFIG_MEMCG_KMEM
 	ret = tcp_init_cgroup(memcg);
 	if (ret)
 		return ret;
@@ -4279,8 +4270,9 @@ static void mem_cgroup_css_free(struct c
 		static_branch_dec(&memcg_sockets_enabled_key);
 #endif
 
-#ifdef CONFIG_MEMCG_KMEM
 	memcg_free_kmem(memcg);
+
+#ifdef CONFIG_MEMCG_KMEM
 	tcp_destroy_cgroup(memcg);
 #endif
 
diff -puN mm/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg mm/slab.h
--- a/mm/slab.h~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/mm/slab.h
@@ -173,7 +173,7 @@ ssize_t slabinfo_write(struct file *file
 void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
 int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 /*
  * Iterate over all memcg caches of the given root cache. The caller must hold
  * slab_mutex.
@@ -251,7 +251,7 @@ static __always_inline int memcg_charge_
 
 extern void slab_init_memcg_params(struct kmem_cache *);
 
-#else /* !CONFIG_MEMCG_KMEM */
+#else /* !CONFIG_MEMCG */
 
 #define for_each_memcg_cache(iter, root) \
 	for ((void)(iter), (void)(root); 0; )
@@ -292,7 +292,7 @@ static inline int memcg_charge_slab(stru
 static inline void slab_init_memcg_params(struct kmem_cache *s)
 {
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG */
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
diff -puN mm/slab_common.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg mm/slab_common.c
--- a/mm/slab_common.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/mm/slab_common.c
@@ -128,7 +128,7 @@ int __kmem_cache_alloc_bulk(struct kmem_
 	return i;
 }
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 void slab_init_memcg_params(struct kmem_cache *s)
 {
 	s->memcg_params.is_root_cache = true;
@@ -221,7 +221,7 @@ static inline int init_memcg_params(stru
 static inline void destroy_memcg_params(struct kmem_cache *s)
 {
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG */
 
 /*
  * Find a mergeable slab cache
@@ -477,7 +477,7 @@ static void release_caches(struct list_h
 	}
 }
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 /*
  * memcg_create_kmem_cache - Create a cache for a memory cgroup.
  * @memcg: The memory cgroup the new cache is for.
@@ -689,7 +689,7 @@ static inline int shutdown_memcg_caches(
 {
 	return 0;
 }
-#endif /* CONFIG_MEMCG_KMEM */
+#endif /* CONFIG_MEMCG */
 
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
@@ -1123,7 +1123,7 @@ static int slab_show(struct seq_file *m,
 	return 0;
 }
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 int memcg_slab_show(struct seq_file *m, void *p)
 {
 	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
diff -puN mm/slub.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg mm/slub.c
--- a/mm/slub.c~mm-memcontrol-move-kmem-accounting-code-to-config_memcg
+++ a/mm/slub.c
@@ -5207,7 +5207,7 @@ static ssize_t slab_attr_store(struct ko
 		return -EIO;
 
 	err = attribute->store(s, buf, len);
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	if (slab_state >= FULL && err >= 0 && is_root_cache(s)) {
 		struct kmem_cache *c;
 
@@ -5242,7 +5242,7 @@ static ssize_t slab_attr_store(struct ko
 
 static void memcg_propagate_slab_attrs(struct kmem_cache *s)
 {
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	int i;
 	char *buffer = NULL;
 	struct kmem_cache *root_cache;
@@ -5328,7 +5328,7 @@ static struct kset *slab_kset;
 
 static inline struct kset *cache_kset(struct kmem_cache *s)
 {
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	if (!is_root_cache(s))
 		return s->memcg_params.root_cache->memcg_kset;
 #endif
@@ -5405,7 +5405,7 @@ static int sysfs_slab_add(struct kmem_ca
 	if (err)
 		goto out_del_kobj;
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	if (is_root_cache(s)) {
 		s->memcg_kset = kset_create_and_add("cgroup", NULL, &s->kobj);
 		if (!s->memcg_kset) {
@@ -5438,7 +5438,7 @@ void sysfs_slab_remove(struct kmem_cache
 		 */
 		return;
 
-#ifdef CONFIG_MEMCG_KMEM
+#ifdef CONFIG_MEMCG
 	kset_unregister(s->memcg_kset);
 #endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

