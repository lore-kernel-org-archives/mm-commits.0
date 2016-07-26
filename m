From: akpm@linux-foundation.org
Subject: [patch 069/126] mm: memcontrol: cleanup kmem charge functions
Date: Tue, 26 Jul 2016 15:24:21 -0700
Message-ID: <5797e315.7gr5VZdYkpmAZvVp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353AbcGZWYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: cleanup kmem charge functions

 - Handle memcg_kmem_enabled check out to the caller. This reduces the
   number of function definitions making the code easier to follow. At
   the same time it doesn't result in code bloat, because all of these
   functions are used only in one or two places.
 - Move __GFP_ACCOUNT check to the caller as well so that one wouldn't
   have to dive deep into memcg implementation to see which allocations
   are charged and which are not.
 - Refresh comments.

Link: http://lkml.kernel.org/r/52882a28b542c1979fd9a033b4dc8637fc347399.1464079537.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  103 ++---------------------------------
 mm/memcontrol.c            |   75 ++++++++++++++++++-------
 mm/page_alloc.c            |    9 ++-
 mm/slab.h                  |   16 ++++-
 4 files changed, 80 insertions(+), 123 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-cleanup-kmem-charge-functions include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-cleanup-kmem-charge-functions
+++ a/include/linux/memcontrol.h
@@ -749,6 +749,13 @@ static inline bool mem_cgroup_under_sock
 }
 #endif
 
+struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep);
+void memcg_kmem_put_cache(struct kmem_cache *cachep);
+int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
+			    struct mem_cgroup *memcg);
+int memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
+void memcg_kmem_uncharge(struct page *page, int order);
+
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 extern struct static_key_false memcg_kmem_enabled_key;
 
@@ -770,22 +777,6 @@ static inline bool memcg_kmem_enabled(vo
 }
 
 /*
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
  * helper for accessing a memcg's index. It will be used as an index in the
  * child cache array in kmem_cache, and also to derive its name. This function
  * will return -1 when this is not a kmem-limited memcg.
@@ -795,67 +786,6 @@ static inline int memcg_cache_id(struct
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
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
 /**
  * memcg_kmem_update_page_stat - update kmem page state statistics
  * @page: the page
@@ -878,15 +808,6 @@ static inline bool memcg_kmem_enabled(vo
 	return false;
 }
 
-static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
-{
-	return 0;
-}
-
-static inline void memcg_kmem_uncharge(struct page *page, int order)
-{
-}
-
 static inline int memcg_cache_id(struct mem_cgroup *memcg)
 {
 	return -1;
@@ -900,16 +821,6 @@ static inline void memcg_put_cache_ids(v
 {
 }
 
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
 static inline void memcg_kmem_update_page_stat(struct page *page,
 				enum mem_cgroup_stat_index idx, int val)
 {
diff -puN mm/memcontrol.c~mm-memcontrol-cleanup-kmem-charge-functions mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-cleanup-kmem-charge-functions
+++ a/mm/memcontrol.c
@@ -2273,20 +2273,30 @@ static void memcg_schedule_kmem_cache_cr
 	current->memcg_kmem_skip_account = 0;
 }
 
-/*
+static inline bool memcg_kmem_bypass(void)
+{
+	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
+		return true;
+	return false;
+}
+
+/**
+ * memcg_kmem_get_cache: select the correct per-memcg cache for allocation
+ * @cachep: the original global kmem cache
+ *
  * Return the kmem_cache we're supposed to use for a slab allocation.
  * We try to use the current memcg's version of the cache.
  *
- * If the cache does not exist yet, if we are the first user of it,
- * we either create it immediately, if possible, or create it asynchronously
- * in a workqueue.
- * In the latter case, we will let the current allocation go through with
- * the original cache.
+ * If the cache does not exist yet, if we are the first user of it, we
+ * create it asynchronously in a workqueue and let the current allocation
+ * go through with the original cache.
  *
- * Can't be called in interrupt context or from kernel threads.
- * This function needs to be called with rcu_read_lock() held.
+ * This function takes a reference to the cache it returns to assure it
+ * won't get destroyed while we are working with it. Once the caller is
+ * done with it, memcg_kmem_put_cache() must be called to release the
+ * reference.
  */
-struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
+struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep)
 {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *memcg_cachep;
@@ -2294,10 +2304,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 
 	VM_BUG_ON(!is_root_cache(cachep));
 
-	if (cachep->flags & SLAB_ACCOUNT)
-		gfp |= __GFP_ACCOUNT;
-
-	if (!(gfp & __GFP_ACCOUNT))
+	if (memcg_kmem_bypass())
 		return cachep;
 
 	if (current->memcg_kmem_skip_account)
@@ -2330,14 +2337,27 @@ out:
 	return cachep;
 }
 
-void __memcg_kmem_put_cache(struct kmem_cache *cachep)
+/**
+ * memcg_kmem_put_cache: drop reference taken by memcg_kmem_get_cache
+ * @cachep: the cache returned by memcg_kmem_get_cache
+ */
+void memcg_kmem_put_cache(struct kmem_cache *cachep)
 {
 	if (!is_root_cache(cachep))
 		css_put(&cachep->memcg_params.memcg->css);
 }
 
-int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
-			      struct mem_cgroup *memcg)
+/**
+ * memcg_kmem_charge: charge a kmem page
+ * @page: page to charge
+ * @gfp: reclaim mode
+ * @order: allocation order
+ * @memcg: memory cgroup to charge
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
+			    struct mem_cgroup *memcg)
 {
 	unsigned int nr_pages = 1 << order;
 	struct page_counter *counter;
@@ -2358,19 +2378,34 @@ int __memcg_kmem_charge_memcg(struct pag
 	return 0;
 }
 
-int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+/**
+ * memcg_kmem_charge: charge a kmem page to the current memory cgroup
+ * @page: page to charge
+ * @gfp: reclaim mode
+ * @order: allocation order
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
 {
 	struct mem_cgroup *memcg;
 	int ret = 0;
 
+	if (memcg_kmem_bypass())
+		return 0;
+
 	memcg = get_mem_cgroup_from_mm(current->mm);
 	if (!mem_cgroup_is_root(memcg))
-		ret = __memcg_kmem_charge_memcg(page, gfp, order, memcg);
+		ret = memcg_kmem_charge_memcg(page, gfp, order, memcg);
 	css_put(&memcg->css);
 	return ret;
 }
-
-void __memcg_kmem_uncharge(struct page *page, int order)
+/**
+ * memcg_kmem_uncharge: uncharge a kmem page
+ * @page: page to uncharge
+ * @order: allocation order
+ */
+void memcg_kmem_uncharge(struct page *page, int order)
 {
 	struct mem_cgroup *memcg = page->mem_cgroup;
 	unsigned int nr_pages = 1 << order;
diff -puN mm/page_alloc.c~mm-memcontrol-cleanup-kmem-charge-functions mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memcontrol-cleanup-kmem-charge-functions
+++ a/mm/page_alloc.c
@@ -4009,7 +4009,8 @@ struct page *alloc_kmem_pages(gfp_t gfp_
 	struct page *page;
 
 	page = alloc_pages(gfp_mask, order);
-	if (page && memcg_kmem_charge(page, gfp_mask, order) != 0) {
+	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) &&
+	    page && memcg_kmem_charge(page, gfp_mask, order) != 0) {
 		__free_pages(page, order);
 		page = NULL;
 	}
@@ -4021,7 +4022,8 @@ struct page *alloc_kmem_pages_node(int n
 	struct page *page;
 
 	page = alloc_pages_node(nid, gfp_mask, order);
-	if (page && memcg_kmem_charge(page, gfp_mask, order) != 0) {
+	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) &&
+	    page && memcg_kmem_charge(page, gfp_mask, order) != 0) {
 		__free_pages(page, order);
 		page = NULL;
 	}
@@ -4034,7 +4036,8 @@ struct page *alloc_kmem_pages_node(int n
  */
 void __free_kmem_pages(struct page *page, unsigned int order)
 {
-	memcg_kmem_uncharge(page, order);
+	if (memcg_kmem_enabled())
+		memcg_kmem_uncharge(page, order);
 	__free_pages(page, order);
 }
 
diff -puN mm/slab.h~mm-memcontrol-cleanup-kmem-charge-functions mm/slab.h
--- a/mm/slab.h~mm-memcontrol-cleanup-kmem-charge-functions
+++ a/mm/slab.h
@@ -254,8 +254,7 @@ static __always_inline int memcg_charge_
 	if (is_root_cache(s))
 		return 0;
 
-	ret = __memcg_kmem_charge_memcg(page, gfp, order,
-					s->memcg_params.memcg);
+	ret = memcg_kmem_charge_memcg(page, gfp, order, s->memcg_params.memcg);
 	if (ret)
 		return ret;
 
@@ -269,6 +268,9 @@ static __always_inline int memcg_charge_
 static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 						struct kmem_cache *s)
 {
+	if (!memcg_kmem_enabled())
+		return;
+
 	memcg_kmem_update_page_stat(page,
 			(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 			MEMCG_SLAB_RECLAIMABLE : MEMCG_SLAB_UNRECLAIMABLE,
@@ -391,7 +393,11 @@ static inline struct kmem_cache *slab_pr
 	if (should_failslab(s, flags))
 		return NULL;
 
-	return memcg_kmem_get_cache(s, flags);
+	if (memcg_kmem_enabled() &&
+	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
+		return memcg_kmem_get_cache(s);
+
+	return s;
 }
 
 static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
@@ -408,7 +414,9 @@ static inline void slab_post_alloc_hook(
 					 s->flags, flags);
 		kasan_slab_alloc(s, object, flags);
 	}
-	memcg_kmem_put_cache(s);
+
+	if (memcg_kmem_enabled())
+		memcg_kmem_put_cache(s);
 }
 
 #ifndef CONFIG_SLOB
_
