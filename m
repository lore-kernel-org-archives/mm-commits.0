From: akpm@linux-foundation.org
Subject: + memcg-unify-slab-and-other-kmem-pages-charging.patch added to
 -mm tree
Date: Thu, 08 Oct 2015 15:30:25 -0700
Message-ID: <5616ee81.8Z5AlGezM2flmwF3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbbJHWa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 18:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: unify slab and other kmem pages charging
has been added to the -mm tree.  Its filename is
     memcg-unify-slab-and-other-kmem-pages-charging.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-unify-slab-and-other-kmem-pages-charging.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-unify-slab-and-other-kmem-pages-charging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: memcg: unify slab and other kmem pages charging

We have memcg_kmem_charge and memcg_kmem_uncharge methods for charging and
uncharging kmem pages to memcg, but currently they are not used for
charging slab pages (i.e.  they are only used for charging pages allocated
with alloc_kmem_pages).  The only reason why the slab subsystem uses
special helpers, memcg_charge_slab and memcg_uncharge_slab, is that it
needs to charge to the memcg of kmem cache while memcg_charge_kmem charges
to the memcg that the current task belongs to.

To remove this diversity, this patch adds an extra argument to
__memcg_kmem_charge that can be a pointer to a memcg or NULL.  If it is
not NULL, the function tries to charge to the memcg it points to,
otherwise it charge to the current context.  Next, it makes the slab
subsystem use this function to charge slab pages.

Since memcg_charge_kmem and memcg_uncharge_kmem helpers are now used only
in __memcg_kmem_charge and __memcg_kmem_uncharge, they are inlined.  Since
__memcg_kmem_charge stores a pointer to the memcg in the page struct, we
don't need memcg_uncharge_slab anymore and can use free_kmem_pages. 
Besides, one can now detect which memcg a slab page belongs to by reading
/proc/kpagecgroup.

Note, this patch switches slab to charge-after-alloc design.  Since this
design is already used for all other memcg charges, it should not make any
difference.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 +---
 mm/memcontrol.c            |   73 ++++++++++++++++-------------------
 mm/slab.c                  |   12 ++---
 mm/slab.h                  |   24 +++--------
 mm/slub.c                  |   12 ++---
 5 files changed, 55 insertions(+), 75 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-unify-slab-and-other-kmem-pages-charging include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-unify-slab-and-other-kmem-pages-charging
+++ a/include/linux/memcontrol.h
@@ -750,7 +750,8 @@ static inline bool memcg_kmem_is_active(
  * conditions, but because they are pretty simple, they are expected to be
  * fast.
  */
-int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order,
+			struct mem_cgroup *memcg);
 void __memcg_kmem_uncharge(struct page *page, int order);
 
 /*
@@ -768,10 +769,6 @@ void __memcg_kmem_put_cache(struct kmem_
 
 struct mem_cgroup *__mem_cgroup_from_kmem(void *ptr);
 
-int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
-		      unsigned long nr_pages);
-void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned long nr_pages);
-
 static inline bool __memcg_kmem_bypass(gfp_t gfp)
 {
 	if (!memcg_kmem_enabled())
@@ -796,7 +793,7 @@ static __always_inline int memcg_kmem_ch
 {
 	if (__memcg_kmem_bypass(gfp))
 		return 0;
-	return __memcg_kmem_charge(page, gfp, order);
+	return __memcg_kmem_charge(page, gfp, order, NULL);
 }
 
 /**
diff -puN mm/memcontrol.c~memcg-unify-slab-and-other-kmem-pages-charging mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-unify-slab-and-other-kmem-pages-charging
+++ a/mm/memcontrol.c
@@ -2215,34 +2215,6 @@ static void commit_charge(struct page *p
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp,
-		      unsigned long nr_pages)
-{
-	struct page_counter *counter;
-	int ret = 0;
-
-	ret = page_counter_try_charge(&memcg->kmem, nr_pages, &counter);
-	if (ret < 0)
-		return ret;
-
-	ret = try_charge(memcg, gfp, nr_pages);
-	if (ret)
-		page_counter_uncharge(&memcg->kmem, nr_pages);
-
-	return ret;
-}
-
-void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned long nr_pages)
-{
-	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_swap_account)
-		page_counter_uncharge(&memcg->memsw, nr_pages);
-
-	page_counter_uncharge(&memcg->kmem, nr_pages);
-
-	css_put_many(&memcg->css, nr_pages);
-}
-
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
@@ -2404,36 +2376,59 @@ void __memcg_kmem_put_cache(struct kmem_
 		css_put(&cachep->memcg_params.memcg->css);
 }
 
-int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+/*
+ * If @memcg != NULL, charge to @memcg, otherwise charge to the memcg the
+ * current task belongs to.
+ */
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order,
+			struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg;
-	int ret;
-
-	memcg = get_mem_cgroup_from_mm(current->mm);
+	struct page_counter *counter;
+	unsigned int nr_pages = 1 << order;
+	bool put = false;
+	int ret = 0;
 
-	if (!memcg_kmem_is_active(memcg)) {
-		css_put(&memcg->css);
-		return 0;
+	if (!memcg) {
+		memcg = get_mem_cgroup_from_mm(current->mm);
+		put = true;
 	}
+	if (!memcg_kmem_is_active(memcg))
+		goto out;
 
-	ret = memcg_charge_kmem(memcg, gfp, 1 << order);
+	ret = page_counter_try_charge(&memcg->kmem, nr_pages, &counter);
+	if (ret)
+		goto out;
+
+	ret = try_charge(memcg, gfp, nr_pages);
+	if (ret) {
+		page_counter_uncharge(&memcg->kmem, nr_pages);
+		goto out;
+	}
 
-	css_put(&memcg->css);
 	page->mem_cgroup = memcg;
+out:
+	if (put)
+		css_put(&memcg->css);
 	return ret;
 }
 
 void __memcg_kmem_uncharge(struct page *page, int order)
 {
 	struct mem_cgroup *memcg = page->mem_cgroup;
+	unsigned int nr_pages = 1 << order;
 
 	if (!memcg)
 		return;
 
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 
-	memcg_uncharge_kmem(memcg, 1 << order);
+	page_counter_uncharge(&memcg->kmem, nr_pages);
+	page_counter_uncharge(&memcg->memory, nr_pages);
+	if (do_swap_account)
+		page_counter_uncharge(&memcg->memsw, nr_pages);
+
 	page->mem_cgroup = NULL;
+	css_put_many(&memcg->css, nr_pages);
 }
 
 struct mem_cgroup *__mem_cgroup_from_kmem(void *ptr)
diff -puN mm/slab.c~memcg-unify-slab-and-other-kmem-pages-charging mm/slab.c
--- a/mm/slab.c~memcg-unify-slab-and-other-kmem-pages-charging
+++ a/mm/slab.c
@@ -1592,16 +1592,17 @@ static struct page *kmem_getpages(struct
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		flags |= __GFP_RECLAIMABLE;
 
-	if (memcg_charge_slab(cachep, flags, cachep->gfporder))
-		return NULL;
-
 	page = __alloc_pages_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
 	if (!page) {
-		memcg_uncharge_slab(cachep, cachep->gfporder);
 		slab_out_of_memory(cachep, flags, nodeid);
 		return NULL;
 	}
 
+	if (memcg_charge_slab(page, flags, cachep->gfporder, cachep)) {
+		__free_pages(page, cachep->gfporder);
+		return NULL;
+	}
+
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (page_is_pfmemalloc(page))
 		pfmemalloc_active = true;
@@ -1653,8 +1654,7 @@ static void kmem_freepages(struct kmem_c
 
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += nr_freed;
-	__free_pages(page, cachep->gfporder);
-	memcg_uncharge_slab(cachep, cachep->gfporder);
+	__free_kmem_pages(page, cachep->gfporder);
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
diff -puN mm/slab.h~memcg-unify-slab-and-other-kmem-pages-charging mm/slab.h
--- a/mm/slab.h~memcg-unify-slab-and-other-kmem-pages-charging
+++ a/mm/slab.h
@@ -236,23 +236,16 @@ static inline struct kmem_cache *memcg_r
 	return s->memcg_params.root_cache;
 }
 
-static __always_inline int memcg_charge_slab(struct kmem_cache *s,
-					     gfp_t gfp, int order)
+static __always_inline int memcg_charge_slab(struct page *page,
+					     gfp_t gfp, int order,
+					     struct kmem_cache *s)
 {
 	if (!memcg_kmem_enabled())
 		return 0;
 	if (is_root_cache(s))
 		return 0;
-	return memcg_charge_kmem(s->memcg_params.memcg, gfp, 1 << order);
-}
-
-static __always_inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
-{
-	if (!memcg_kmem_enabled())
-		return;
-	if (is_root_cache(s))
-		return;
-	memcg_uncharge_kmem(s->memcg_params.memcg, 1 << order);
+	return __memcg_kmem_charge(page, gfp, order,
+				   s->memcg_params.memcg);
 }
 
 extern void slab_init_memcg_params(struct kmem_cache *);
@@ -289,15 +282,12 @@ static inline struct kmem_cache *memcg_r
 	return s;
 }
 
-static inline int memcg_charge_slab(struct kmem_cache *s, gfp_t gfp, int order)
+static inline int memcg_charge_slab(struct page *page, gfp_t gfp, int order,
+				    struct kmem_cache *s)
 {
 	return 0;
 }
 
-static inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
-{
-}
-
 static inline void slab_init_memcg_params(struct kmem_cache *s)
 {
 }
diff -puN mm/slub.c~memcg-unify-slab-and-other-kmem-pages-charging mm/slub.c
--- a/mm/slub.c~memcg-unify-slab-and-other-kmem-pages-charging
+++ a/mm/slub.c
@@ -1370,16 +1370,15 @@ static inline struct page *alloc_slab_pa
 
 	flags |= __GFP_NOTRACK;
 
-	if (memcg_charge_slab(s, flags, order))
-		return NULL;
-
 	if (node == NUMA_NO_NODE)
 		page = alloc_pages(flags, order);
 	else
 		page = __alloc_pages_node(node, flags, order);
 
-	if (!page)
-		memcg_uncharge_slab(s, order);
+	if (page && memcg_charge_slab(page, flags, order, s)) {
+		__free_pages(page, order);
+		page = NULL;
+	}
 
 	return page;
 }
@@ -1518,8 +1517,7 @@ static void __free_slab(struct kmem_cach
 	page_mapcount_reset(page);
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	__free_pages(page, order);
-	memcg_uncharge_slab(s, order);
+	__free_kmem_pages(page, order);
 }
 
 #define need_reserve_slab_rcu						\
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

slab_common-rename-cache-create-destroy-helpers.patch
slab_common-clear-pointers-to-per-memcg-caches-on-destroy.patch
slab_common-do-not-warn-that-cache-is-busy-on-destroy-more-than-once.patch
memcg-simplify-charging-kmem-pages.patch
memcg-unify-slab-and-other-kmem-pages-charging.patch
memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch

