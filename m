From: akpm@linux-foundation.org
Subject: [merged] memcg-simplify-charging-kmem-pages.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:16:02 -0800
Message-ID: <563d0a82.Y96J5Ss2AJmx0cHX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966228AbbKFUQD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify charging kmem pages
has been removed from the -mm tree.  Its filename was
     memcg-simplify-charging-kmem-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: memcg: simplify charging kmem pages

Charging kmem pages proceeds in two steps.  First, we try to charge the
allocation size to the memcg the current task belongs to, then we allocate
a page and "commit" the charge storing the pointer to the memcg in the
page struct.

Such a design looks overcomplicated, because there is not much sense in
trying charging the allocation before actually allocating a page: we won't
be able to consume much memory over the limit even if we charge after
doing the actual allocation, besides we already charge user pages post
factum, so being pedantic with kmem pages just looks pointless.

So this patch simplifies the design by merging the "charge" and the
"commit" steps into the same function, which takes the allocated page.

Also, rename the charge and uncharge methods to memcg_kmem_charge and
memcg_kmem_uncharge and make the charge method return error code instead
of bool to conform to mem_cgroup_try_charge.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   69 +++++++++--------------------------
 mm/memcontrol.c            |   39 ++-----------------
 mm/page_alloc.c            |   18 ++++-----
 3 files changed, 32 insertions(+), 94 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-simplify-charging-kmem-pages include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-simplify-charging-kmem-pages
+++ a/include/linux/memcontrol.h
@@ -752,11 +752,8 @@ static inline bool memcg_kmem_is_active(
  * conditions, but because they are pretty simple, they are expected to be
  * fast.
  */
-bool __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg,
-					int order);
-void __memcg_kmem_commit_charge(struct page *page,
-				       struct mem_cgroup *memcg, int order);
-void __memcg_kmem_uncharge_pages(struct page *page, int order);
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
+void __memcg_kmem_uncharge(struct page *page, int order);
 
 /*
  * helper for acessing a memcg's index. It will be used as an index in the
@@ -789,52 +786,30 @@ static inline bool __memcg_kmem_bypass(g
 }
 
 /**
- * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
- * @gfp: the gfp allocation flags.
- * @memcg: a pointer to the memcg this was charged against.
- * @order: allocation order.
+ * memcg_kmem_charge: charge a kmem page
+ * @page: page to charge
+ * @gfp: reclaim mode
+ * @order: allocation order
  *
- * returns true if the memcg where the current task belongs can hold this
- * allocation.
- *
- * We return true automatically if this allocation is not to be accounted to
- * any memcg.
+ * Returns 0 on success, an error code on failure.
  */
-static inline bool
-memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
+static __always_inline int memcg_kmem_charge(struct page *page,
+					     gfp_t gfp, int order)
 {
 	if (__memcg_kmem_bypass(gfp))
-		return true;
-	return __memcg_kmem_newpage_charge(gfp, memcg, order);
+		return 0;
+	return __memcg_kmem_charge(page, gfp, order);
 }
 
 /**
- * memcg_kmem_uncharge_pages: uncharge pages from memcg
- * @page: pointer to struct page being freed
- * @order: allocation order.
+ * memcg_kmem_uncharge: uncharge a kmem page
+ * @page: page to uncharge
+ * @order: allocation order
  */
-static inline void
-memcg_kmem_uncharge_pages(struct page *page, int order)
+static __always_inline void memcg_kmem_uncharge(struct page *page, int order)
 {
 	if (memcg_kmem_enabled())
-		__memcg_kmem_uncharge_pages(page, order);
-}
-
-/**
- * memcg_kmem_commit_charge: embeds correct memcg in a page
- * @page: pointer to struct page recently allocated
- * @memcg: the memcg structure we charged against
- * @order: allocation order.
- *
- * Needs to be called after memcg_kmem_newpage_charge, regardless of success or
- * failure of the allocation. if @page is NULL, this function will revert the
- * charges. Otherwise, it will commit @page to @memcg.
- */
-static inline void
-memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg, int order)
-{
-	if (memcg_kmem_enabled() && memcg)
-		__memcg_kmem_commit_charge(page, memcg, order);
+		__memcg_kmem_uncharge(page, order);
 }
 
 /**
@@ -878,18 +853,12 @@ static inline bool memcg_kmem_is_active(
 	return false;
 }
 
-static inline bool
-memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
-{
-	return true;
-}
-
-static inline void memcg_kmem_uncharge_pages(struct page *page, int order)
+static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
 {
+	return 0;
 }
 
-static inline void
-memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg, int order)
+static inline void memcg_kmem_uncharge(struct page *page, int order)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-simplify-charging-kmem-pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-charging-kmem-pages
+++ a/mm/memcontrol.c
@@ -2404,57 +2404,26 @@ void __memcg_kmem_put_cache(struct kmem_
 		css_put(&cachep->memcg_params.memcg->css);
 }
 
-/*
- * We need to verify if the allocation against current->mm->owner's memcg is
- * possible for the given order. But the page is not allocated yet, so we'll
- * need a further commit step to do the final arrangements.
- *
- * It is possible for the task to switch cgroups in this mean time, so at
- * commit time, we can't rely on task conversion any longer.  We'll then use
- * the handle argument to return to the caller which cgroup we should commit
- * against. We could also return the memcg directly and avoid the pointer
- * passing, but a boolean return value gives better semantics considering
- * the compiled-out case as well.
- *
- * Returning true means the allocation is possible.
- */
-bool
-__memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
-	*_memcg = NULL;
-
 	memcg = get_mem_cgroup_from_mm(current->mm);
 
 	if (!memcg_kmem_is_active(memcg)) {
 		css_put(&memcg->css);
-		return true;
+		return 0;
 	}
 
 	ret = memcg_charge_kmem(memcg, gfp, 1 << order);
-	if (!ret)
-		*_memcg = memcg;
 
 	css_put(&memcg->css);
-	return (ret == 0);
-}
-
-void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
-			      int order)
-{
-	VM_BUG_ON(mem_cgroup_is_root(memcg));
-
-	/* The page allocation failed. Revert */
-	if (!page) {
-		memcg_uncharge_kmem(memcg, 1 << order);
-		return;
-	}
 	page->mem_cgroup = memcg;
+	return ret;
 }
 
-void __memcg_kmem_uncharge_pages(struct page *page, int order)
+void __memcg_kmem_uncharge(struct page *page, int order)
 {
 	struct mem_cgroup *memcg = page->mem_cgroup;
 
diff -puN mm/page_alloc.c~memcg-simplify-charging-kmem-pages mm/page_alloc.c
--- a/mm/page_alloc.c~memcg-simplify-charging-kmem-pages
+++ a/mm/page_alloc.c
@@ -3428,24 +3428,24 @@ EXPORT_SYMBOL(__free_page_frag);
 struct page *alloc_kmem_pages(gfp_t gfp_mask, unsigned int order)
 {
 	struct page *page;
-	struct mem_cgroup *memcg = NULL;
 
-	if (!memcg_kmem_newpage_charge(gfp_mask, &memcg, order))
-		return NULL;
 	page = alloc_pages(gfp_mask, order);
-	memcg_kmem_commit_charge(page, memcg, order);
+	if (page && memcg_kmem_charge(page, gfp_mask, order) != 0) {
+		__free_pages(page, order);
+		page = NULL;
+	}
 	return page;
 }
 
 struct page *alloc_kmem_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
 {
 	struct page *page;
-	struct mem_cgroup *memcg = NULL;
 
-	if (!memcg_kmem_newpage_charge(gfp_mask, &memcg, order))
-		return NULL;
 	page = alloc_pages_node(nid, gfp_mask, order);
-	memcg_kmem_commit_charge(page, memcg, order);
+	if (page && memcg_kmem_charge(page, gfp_mask, order) != 0) {
+		__free_pages(page, order);
+		page = NULL;
+	}
 	return page;
 }
 
@@ -3455,7 +3455,7 @@ struct page *alloc_kmem_pages_node(int n
  */
 void __free_kmem_pages(struct page *page, unsigned int order)
 {
-	memcg_kmem_uncharge_pages(page, order);
+	memcg_kmem_uncharge(page, order);
 	__free_pages(page, order);
 }
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


