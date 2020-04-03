From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:37:30 -0700
Message-ID: <20200403203730.2yaLTCRv3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUhd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: kmem: rename memcg_kmem_(un)charge() into memcg_kmem_(un)charge_page()
has been removed from the -mm tree.  Its filename was
     mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: rename memcg_kmem_(un)charge() into memcg_kmem_(un)charge_page()

Rename (__)memcg_kmem_(un)charge() into (__)memcg_kmem_(un)charge_page()
to better reflect what they are actually doing:

1) call __memcg_kmem_(un)charge_memcg() to actually charge or uncharge
   the current memcg

2) set or clear the PageKmemcg flag

Link: http://lkml.kernel.org/r/20200109202659.752357-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c                  |    2 +-
 include/linux/memcontrol.h |   23 +++++++++++++----------
 kernel/fork.c              |    9 +++++----
 mm/memcontrol.c            |    8 ++++----
 mm/page_alloc.c            |    4 ++--
 5 files changed, 25 insertions(+), 21 deletions(-)

--- a/fs/pipe.c~mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page
+++ a/fs/pipe.c
@@ -146,7 +146,7 @@ static int anon_pipe_buf_steal(struct pi
 	struct page *page = buf->page;
 
 	if (page_count(page) == 1) {
-		memcg_kmem_uncharge(page, 0);
+		memcg_kmem_uncharge_page(page, 0);
 		__SetPageLocked(page);
 		return 0;
 	}
--- a/include/linux/memcontrol.h~mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page
+++ a/include/linux/memcontrol.h
@@ -1367,8 +1367,8 @@ struct kmem_cache *memcg_kmem_get_cache(
 void memcg_kmem_put_cache(struct kmem_cache *cachep);
 
 #ifdef CONFIG_MEMCG_KMEM
-int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
-void __memcg_kmem_uncharge(struct page *page, int order);
+int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
+void __memcg_kmem_uncharge_page(struct page *page, int order);
 int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
 				 unsigned int nr_pages);
@@ -1393,17 +1393,18 @@ static inline bool memcg_kmem_enabled(vo
 	return static_branch_unlikely(&memcg_kmem_enabled_key);
 }
 
-static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
+					 int order)
 {
 	if (memcg_kmem_enabled())
-		return __memcg_kmem_charge(page, gfp, order);
+		return __memcg_kmem_charge_page(page, gfp, order);
 	return 0;
 }
 
-static inline void memcg_kmem_uncharge(struct page *page, int order)
+static inline void memcg_kmem_uncharge_page(struct page *page, int order)
 {
 	if (memcg_kmem_enabled())
-		__memcg_kmem_uncharge(page, order);
+		__memcg_kmem_uncharge_page(page, order);
 }
 
 static inline int memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
@@ -1435,21 +1436,23 @@ struct mem_cgroup *mem_cgroup_from_obj(v
 
 #else
 
-static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
+					 int order)
 {
 	return 0;
 }
 
-static inline void memcg_kmem_uncharge(struct page *page, int order)
+static inline void memcg_kmem_uncharge_page(struct page *page, int order)
 {
 }
 
-static inline int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+static inline int __memcg_kmem_charge_page(struct page *page, gfp_t gfp,
+					   int order)
 {
 	return 0;
 }
 
-static inline void __memcg_kmem_uncharge(struct page *page, int order)
+static inline void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
 }
 
--- a/kernel/fork.c~mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page
+++ a/kernel/fork.c
@@ -281,7 +281,7 @@ static inline void free_thread_stack(str
 					     MEMCG_KERNEL_STACK_KB,
 					     -(int)(PAGE_SIZE / 1024));
 
-			memcg_kmem_uncharge(vm->pages[i], 0);
+			memcg_kmem_uncharge_page(vm->pages[i], 0);
 		}
 
 		for (i = 0; i < NR_CACHED_STACKS; i++) {
@@ -413,12 +413,13 @@ static int memcg_charge_kernel_stack(str
 
 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 			/*
-			 * If memcg_kmem_charge() fails, page->mem_cgroup
-			 * pointer is NULL, and both memcg_kmem_uncharge()
+			 * If memcg_kmem_charge_page() fails, page->mem_cgroup
+			 * pointer is NULL, and both memcg_kmem_uncharge_page()
 			 * and mod_memcg_page_state() in free_thread_stack()
 			 * will ignore this page. So it's safe.
 			 */
-			ret = memcg_kmem_charge(vm->pages[i], GFP_KERNEL, 0);
+			ret = memcg_kmem_charge_page(vm->pages[i], GFP_KERNEL,
+						     0);
 			if (ret)
 				return ret;
 
--- a/mm/memcontrol.c~mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page
+++ a/mm/memcontrol.c
@@ -2917,14 +2917,14 @@ int __memcg_kmem_charge_memcg(struct mem
 }
 
 /**
- * __memcg_kmem_charge: charge a kmem page to the current memory cgroup
+ * __memcg_kmem_charge_page: charge a kmem page to the current memory cgroup
  * @page: page to charge
  * @gfp: reclaim mode
  * @order: allocation order
  *
  * Returns 0 on success, an error code on failure.
  */
-int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 {
 	struct mem_cgroup *memcg;
 	int ret = 0;
@@ -2960,11 +2960,11 @@ void __memcg_kmem_uncharge_memcg(struct
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
 /**
- * __memcg_kmem_uncharge: uncharge a kmem page
+ * __memcg_kmem_uncharge_page: uncharge a kmem page
  * @page: page to uncharge
  * @order: allocation order
  */
-void __memcg_kmem_uncharge(struct page *page, int order)
+void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
 	struct mem_cgroup *memcg = page->mem_cgroup;
 	unsigned int nr_pages = 1 << order;
--- a/mm/page_alloc.c~mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page
+++ a/mm/page_alloc.c
@@ -1153,7 +1153,7 @@ static __always_inline bool free_pages_p
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
 	if (memcg_kmem_enabled() && PageKmemcg(page))
-		__memcg_kmem_uncharge(page, order);
+		__memcg_kmem_uncharge_page(page, order);
 	if (check_free)
 		bad += free_pages_check(page);
 	if (bad)
@@ -4753,7 +4753,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 
 out:
 	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) && page &&
-	    unlikely(__memcg_kmem_charge(page, gfp_mask, order) != 0)) {
+	    unlikely(__memcg_kmem_charge_page(page, gfp_mask, order) != 0)) {
 		__free_pages(page, order);
 		page = NULL;
 	}
_

Patches currently in -mm which might be from guro@fb.com are

mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations.patch
mmpage_alloccma-conditionally-prefer-cma-pageblocks-for-movable-allocations-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix-2.patch
