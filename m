Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9F2C433E2
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A840161987
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhCSRLu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230449AbhCSRLh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 13:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 497B661963;
        Fri, 19 Mar 2021 17:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616173897;
        bh=a6y6VvNUnzjPuYM008sRDe331LraUf/jYQyIiSZFEK8=;
        h=Date:From:To:Subject:From;
        b=AEAAGlON5D8jStZLW4N3qSO0L7FBMtNKdSFYi2H1Xf7v1ezS5SoVxFq6Ne0dEuFdT
         VhtB0WTn1MCgRD+32XFoyNCHmcXyUOT2JL3g/EYgLTB5pfIypCKDaERMtIeExHYD8t
         Clh2q+7lVh2qP0qoreiItOGwtRk3tyVY9ycdBWgA=
Date:   Fri, 19 Mar 2021 10:11:36 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch added to -mm
 tree
Message-ID: <20210319171136.YFZYY1nOW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use obj_cgroup APIs to charge kmem pages
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: use obj_cgroup APIs to charge kmem pages

Since Roman's series "The new cgroup slab memory controller" applied.  All
slab objects are charged via the new APIs of obj_cgroup.  The new APIs
introduce a struct obj_cgroup to charge slab objects.  It prevents
long-living objects from pinning the original memory cgroup in the memory.
But there are still some corner objects (e.g.  allocations larger than
order-1 page on SLUB) which are not charged via the new APIs.  Those
objects (include the pages which are allocated from buddy allocator
directly) are charged as kmem pages which still hold a reference to the
memory cgroup.

We want to reuse the obj_cgroup APIs to charge the kmem pages.  If we do
that, we should store an object cgroup pointer to page->memcg_data for the
kmem pages.

Finally, page->memcg_data will have 3 different meanings.

  1) For the slab pages, page->memcg_data points to an object cgroups
     vector.

  2) For the kmem pages (exclude the slab pages), page->memcg_data
     points to an object cgroup.

  3) For the user pages (e.g. the LRU pages), page->memcg_data points
     to a memory cgroup.

We do not change the behavior of page_memcg() and page_memcg_rcu().  They
are also suitable for LRU pages and kmem pages.  Why?

Because memory allocations pinning memcgs for a long time - it exists at a
larger scale and is causing recurring problems in the real world: page
cache doesn't get reclaimed for a long time, or is used by the second,
third, fourth, ...  instance of the same job that was restarted into a new
cgroup every time.  Unreclaimable dying cgroups pile up, waste memory, and
make page reclaim very inefficient.

We can convert LRU pages and most other raw memcg pins to the objcg
direction to fix this problem, and then the page->memcg will always point
to an object cgroup pointer.  At that time, LRU pages and kmem pages will
be treated the same.  The implementation of page_memcg() will remove the
kmem page check.

This patch aims to charge the kmem pages by using the new APIs of
obj_cgroup.  Finally, the page->memcg_data of the kmem page points to an
object cgroup.  We can use the __page_objcg() to get the object cgroup
associated with a kmem page.  Or we can use page_memcg() to get the memory
cgroup associated with a kmem page, but caller must ensure that the
returned memcg won't be released (e.g.  acquire the rcu_read_lock or
css_set_lock).

Link: https://lkml.kernel.org/r/20210319163821.20704-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  116 +++++++++++++++++++++++++++--------
 mm/memcontrol.c            |  110 +++++++++++++++------------------
 2 files changed, 145 insertions(+), 81 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages
+++ a/include/linux/memcontrol.h
@@ -371,6 +371,62 @@ enum page_memcg_data_flags {
 
 #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
 
+static inline bool PageMemcgKmem(struct page *page);
+
+/*
+ * After the initialization objcg->memcg is always pointing at
+ * a valid memcg, but can be atomically swapped to the parent memcg.
+ *
+ * The caller must ensure that the returned memcg won't be released:
+ * e.g. acquire the rcu_read_lock or css_set_lock.
+ */
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+{
+	return READ_ONCE(objcg->memcg);
+}
+
+/*
+ * __page_memcg - get the memory cgroup associated with a non-kmem page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the page,
+ * or NULL. This function assumes that the page is known to have a
+ * proper memory cgroup pointer. It's not safe to call this function
+ * against some type of pages, e.g. slab pages or ex-slab pages or
+ * kmem pages.
+ */
+static inline struct mem_cgroup *__page_memcg(struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
+
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+}
+
+/*
+ * __page_objcg - get the object cgroup associated with a kmem page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroup associated with the page,
+ * or NULL. This function assumes that the page is known to have a
+ * proper object cgroup pointer. It's not safe to call this function
+ * against some type of pages, e.g. slab pages or ex-slab pages or
+ * LRU pages.
+ */
+static inline struct obj_cgroup *__page_objcg(struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+	VM_BUG_ON_PAGE(!(memcg_data & MEMCG_DATA_KMEM), page);
+
+	return (struct obj_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+}
+
 /*
  * page_memcg - get the memory cgroup associated with a page
  * @page: a pointer to the page struct
@@ -380,20 +436,23 @@ enum page_memcg_data_flags {
  * proper memory cgroup pointer. It's not safe to call this function
  * against some type of pages, e.g. slab pages or ex-slab pages.
  *
- * Any of the following ensures page and memcg binding stability:
+ * For a non-kmem page any of the following ensures page and memcg binding
+ * stability:
+ *
  * - the page lock
  * - LRU isolation
  * - lock_page_memcg()
  * - exclusive reference
+ *
+ * For a kmem page a caller should hold an rcu read lock to protect memcg
+ * associated with a kmem page from being released.
  */
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
-	unsigned long memcg_data = page->memcg_data;
-
-	VM_BUG_ON_PAGE(PageSlab(page), page);
-	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
-
-	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	if (PageMemcgKmem(page))
+		return obj_cgroup_memcg(__page_objcg(page));
+	else
+		return __page_memcg(page);
 }
 
 /*
@@ -407,11 +466,19 @@ static inline struct mem_cgroup *page_me
  */
 static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
 {
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+
 	VM_BUG_ON_PAGE(PageSlab(page), page);
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	return (struct mem_cgroup *)(READ_ONCE(page->memcg_data) &
-				     ~MEMCG_DATA_FLAGS_MASK);
+	if (memcg_data & MEMCG_DATA_KMEM) {
+		struct obj_cgroup *objcg;
+
+		objcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+		return obj_cgroup_memcg(objcg);
+	}
+
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -419,15 +486,21 @@ static inline struct mem_cgroup *page_me
  * @page: a pointer to the page struct
  *
  * Returns a pointer to the memory cgroup associated with the page,
- * or NULL. This function unlike page_memcg() can take any  page
+ * or NULL. This function unlike page_memcg() can take any page
  * as an argument. It has to be used in cases when it's not known if a page
- * has an associated memory cgroup pointer or an object cgroups vector.
+ * has an associated memory cgroup pointer or an object cgroups vector or
+ * an object cgroup.
+ *
+ * For a non-kmem page any of the following ensures page and memcg binding
+ * stability:
  *
- * Any of the following ensures page and memcg binding stability:
  * - the page lock
  * - LRU isolation
  * - lock_page_memcg()
  * - exclusive reference
+ *
+ * For a kmem page a caller should hold an rcu read lock to protect memcg
+ * associated with a kmem page from being released.
  */
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
 {
@@ -440,6 +513,13 @@ static inline struct mem_cgroup *page_me
 	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
 
+	if (memcg_data & MEMCG_DATA_KMEM) {
+		struct obj_cgroup *objcg;
+
+		objcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+		return obj_cgroup_memcg(objcg);
+	}
+
 	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
@@ -723,18 +803,6 @@ static inline void obj_cgroup_put(struct
 	percpu_ref_put(&objcg->refcnt);
 }
 
-/*
- * After the initialization objcg->memcg is always pointing at
- * a valid memcg, but can be atomically swapped to the parent memcg.
- *
- * The caller must ensure that the returned memcg won't be released:
- * e.g. acquire the rcu_read_lock or css_set_lock.
- */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
-{
-	return READ_ONCE(objcg->memcg);
-}
-
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 	if (memcg)
--- a/mm/memcontrol.c~mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages
+++ a/mm/memcontrol.c
@@ -865,18 +865,22 @@ void __mod_lruvec_page_state(struct page
 			     int val)
 {
 	struct page *head = compound_head(page); /* rmap on tail pages */
-	struct mem_cgroup *memcg = page_memcg(head);
+	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = page_pgdat(page);
 	struct lruvec *lruvec;
 
+	rcu_read_lock();
+	memcg = page_memcg(head);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
+		rcu_read_unlock();
 		__mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	__mod_lruvec_state(lruvec, idx, val);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(__mod_lruvec_page_state);
 
@@ -1051,20 +1055,6 @@ static __always_inline struct mem_cgroup
 		return current->active_memcg;
 }
 
-static __always_inline struct mem_cgroup *get_active_memcg(void)
-{
-	struct mem_cgroup *memcg;
-
-	rcu_read_lock();
-	memcg = active_memcg();
-	/* remote memcg must hold a ref. */
-	if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
-	rcu_read_unlock();
-
-	return memcg;
-}
-
 static __always_inline bool memcg_kmem_bypass(void)
 {
 	/* Allow remote memcg charging from any context. */
@@ -1079,20 +1069,6 @@ static __always_inline bool memcg_kmem_b
 }
 
 /**
- * If active memcg is set, do not fallback to current->mm->memcg.
- */
-static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
-{
-	if (memcg_kmem_bypass())
-		return NULL;
-
-	if (unlikely(active_memcg()))
-		return get_active_memcg();
-
-	return get_mem_cgroup_from_mm(current->mm);
-}
-
-/**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
@@ -3121,18 +3097,18 @@ static void __memcg_kmem_uncharge(struct
  */
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 	int ret = 0;
 
-	memcg = get_mem_cgroup_from_current();
-	if (memcg && !mem_cgroup_is_root(memcg)) {
-		ret = __memcg_kmem_charge(memcg, gfp, 1 << order);
+	objcg = get_obj_cgroup_from_current();
+	if (objcg) {
+		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
-			page->memcg_data = (unsigned long)memcg |
+			page->memcg_data = (unsigned long)objcg |
 				MEMCG_DATA_KMEM;
 			return 0;
 		}
-		css_put(&memcg->css);
+		obj_cgroup_put(objcg);
 	}
 	return ret;
 }
@@ -3144,16 +3120,16 @@ int __memcg_kmem_charge_page(struct page
  */
 void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	struct mem_cgroup *memcg = page_memcg(page);
+	struct obj_cgroup *objcg;
 	unsigned int nr_pages = 1 << order;
 
-	if (!memcg)
+	if (!PageMemcgKmem(page))
 		return;
 
-	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
-	__memcg_kmem_uncharge(memcg, nr_pages);
+	objcg = __page_objcg(page);
+	obj_cgroup_uncharge_pages(objcg, nr_pages);
 	page->memcg_data = 0;
-	css_put(&memcg->css);
+	obj_cgroup_put(objcg);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -6788,7 +6764,7 @@ void mem_cgroup_swapin_uncharge_swap(swp
 
 struct uncharge_gather {
 	struct mem_cgroup *memcg;
-	unsigned long nr_pages;
+	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
 	struct page *dummy_page;
@@ -6803,10 +6779,10 @@ static void uncharge_batch(const struct
 {
 	unsigned long flags;
 
-	if (!mem_cgroup_is_root(ug->memcg)) {
-		page_counter_uncharge(&ug->memcg->memory, ug->nr_pages);
+	if (ug->nr_memory) {
+		page_counter_uncharge(&ug->memcg->memory, ug->nr_memory);
 		if (do_memsw_account())
-			page_counter_uncharge(&ug->memcg->memsw, ug->nr_pages);
+			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
 			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
 		memcg_oom_recover(ug->memcg);
@@ -6814,7 +6790,7 @@ static void uncharge_batch(const struct
 
 	local_irq_save(flags);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
-	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_pages);
+	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_memory);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
 
@@ -6825,40 +6801,60 @@ static void uncharge_batch(const struct
 static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 {
 	unsigned long nr_pages;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
-	if (!page_memcg(page))
-		return;
-
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * page_memcg(page) at this point, we have fully
+	 * page memcg or objcg at this point, we have fully
 	 * exclusive access to the page.
 	 */
+	if (PageMemcgKmem(page)) {
+		objcg = __page_objcg(page);
+		/*
+		 * This get matches the put at the end of the function and
+		 * kmem pages do not hold memcg references anymore.
+		 */
+		memcg = get_mem_cgroup_from_objcg(objcg);
+	} else {
+		memcg = __page_memcg(page);
+	}
+
+	if (!memcg)
+		return;
 
-	if (ug->memcg != page_memcg(page)) {
+	if (ug->memcg != memcg) {
 		if (ug->memcg) {
 			uncharge_batch(ug);
 			uncharge_gather_clear(ug);
 		}
-		ug->memcg = page_memcg(page);
+		ug->memcg = memcg;
 		ug->dummy_page = page;
 
 		/* pairs with css_put in uncharge_batch */
-		css_get(&ug->memcg->css);
+		css_get(&memcg->css);
 	}
 
 	nr_pages = compound_nr(page);
-	ug->nr_pages += nr_pages;
 
-	if (PageMemcgKmem(page))
+	if (PageMemcgKmem(page)) {
+		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
-	else
+
+		page->memcg_data = 0;
+		obj_cgroup_put(objcg);
+	} else {
+		/* LRU pages aren't accounted at the root level */
+		if (!mem_cgroup_is_root(memcg))
+			ug->nr_memory += nr_pages;
 		ug->pgpgout++;
 
-	page->memcg_data = 0;
-	css_put(&ug->memcg->css);
+		page->memcg_data = 0;
+	}
+
+	css_put(&memcg->css);
 }
 
 /**
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-kernel-stack-account.patch
mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg.patch
mm-memcontrol-introduce-obj_cgroup_uncharge_pages.patch
mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch
mm-memcontrol-change-ug-dummy_page-only-if-memcg-changed.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch
mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages.patch
mm-memcontrol-move-pagememcgkmem-to-the-scope-of-config_memcg_kmem.patch

