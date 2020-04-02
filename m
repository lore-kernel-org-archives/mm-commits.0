From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 063/155] mm: kmem: cleanup
 (__)memcg_kmem_charge_memcg() arguments
Date: Wed, 01 Apr 2020 21:06:39 -0700
Message-ID: <20200402040639.XHqaFv43M%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:43 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: cleanup (__)memcg_kmem_charge_memcg() arguments

Patch series "mm: memcg: kmem API cleanup", v2.

This patchset aims to clean up the kernel memory charging API.  It doesn't
bring any functional changes, just removes unused arguments, renames some
functions and fixes some comments.

Currently it's not obvious which functions are most basic
(memcg_kmem_(un)charge_memcg()) and which are based on them
(memcg_kmem_(un)charge()).  The patchset renames these functions and
removes unused arguments:

TL;DR:
was:
  memcg_kmem_charge_memcg(page, gfp, order, memcg)
  memcg_kmem_uncharge_memcg(memcg, nr_pages)
  memcg_kmem_charge(page, gfp, order)
  memcg_kmem_uncharge(page, order)

now:
  memcg_kmem_charge(memcg, gfp, nr_pages)
  memcg_kmem_uncharge(memcg, nr_pages)
  memcg_kmem_charge_page(page, gfp, order)
  memcg_kmem_uncharge_page(page, order)


This patch (of 6):

The first argument of memcg_kmem_charge_memcg() and
__memcg_kmem_charge_memcg() is the page pointer and it's not used.  Let's
drop it.

Memcg pointer is passed as the last argument.  Move it to the first place
for consistency with other memcg functions, e.g. 
__memcg_kmem_uncharge_memcg() or try_charge().

Link: http://lkml.kernel.org/r/20200109202659.752357-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ++++-----
 mm/memcontrol.c            |    8 +++-----
 mm/slab.h                  |    2 +-
 3 files changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments
+++ a/include/linux/memcontrol.h
@@ -1369,8 +1369,7 @@ void memcg_kmem_put_cache(struct kmem_ca
 #ifdef CONFIG_MEMCG_KMEM
 int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge(struct page *page, int order);
-int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
-			      struct mem_cgroup *memcg);
+int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
 				 unsigned int nr_pages);
 
@@ -1407,11 +1406,11 @@ static inline void memcg_kmem_uncharge(s
 		__memcg_kmem_uncharge(page, order);
 }
 
-static inline int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp,
-					  int order, struct mem_cgroup *memcg)
+static inline int memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
+					  int order)
 {
 	if (memcg_kmem_enabled())
-		return __memcg_kmem_charge_memcg(page, gfp, order, memcg);
+		return __memcg_kmem_charge_memcg(memcg, gfp, order);
 	return 0;
 }
 
--- a/mm/memcontrol.c~mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments
+++ a/mm/memcontrol.c
@@ -2882,15 +2882,13 @@ void memcg_kmem_put_cache(struct kmem_ca
 
 /**
  * __memcg_kmem_charge_memcg: charge a kmem page
- * @page: page to charge
+ * @memcg: memory cgroup to charge
  * @gfp: reclaim mode
  * @order: allocation order
- * @memcg: memory cgroup to charge
  *
  * Returns 0 on success, an error code on failure.
  */
-int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
-			    struct mem_cgroup *memcg)
+int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order)
 {
 	unsigned int nr_pages = 1 << order;
 	struct page_counter *counter;
@@ -2936,7 +2934,7 @@ int __memcg_kmem_charge(struct page *pag
 
 	memcg = get_mem_cgroup_from_current();
 	if (!mem_cgroup_is_root(memcg)) {
-		ret = __memcg_kmem_charge_memcg(page, gfp, order, memcg);
+		ret = __memcg_kmem_charge_memcg(memcg, gfp, order);
 		if (!ret) {
 			page->mem_cgroup = memcg;
 			__SetPageKmemcg(page);
--- a/mm/slab.h~mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments
+++ a/mm/slab.h
@@ -365,7 +365,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	}
 
-	ret = memcg_kmem_charge_memcg(page, gfp, order, memcg);
+	ret = memcg_kmem_charge_memcg(memcg, gfp, order);
 	if (ret)
 		goto out;
 
_
