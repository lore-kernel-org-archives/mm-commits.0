From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 066/155] mm: kmem: switch to nr_pages in
 (__)memcg_kmem_charge_memcg()
Date: Wed, 01 Apr 2020 21:06:49 -0700
Message-ID: <20200402040649.Jfp9N8TiA%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgDBEGv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:51 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: switch to nr_pages in (__)memcg_kmem_charge_memcg()

These functions are charging the given number of kernel pages to the given
memory cgroup.  The number doesn't have to be a power of two.  Let's make
them to take the unsigned int nr_pages as an argument instead of the page
order.

It makes them look consistent with the corresponding uncharge functions
and functions like: mem_cgroup_charge_skmem(memcg, nr_pages).

Link: http://lkml.kernel.org/r/20200109202659.752357-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 ++++++-----
 mm/memcontrol.c            |    8 ++++----
 mm/slab.h                  |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg
+++ a/include/linux/memcontrol.h
@@ -1369,7 +1369,8 @@ void memcg_kmem_put_cache(struct kmem_ca
 #ifdef CONFIG_MEMCG_KMEM
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
-int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order);
+int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
+			      unsigned int nr_pages);
 void __memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
 				 unsigned int nr_pages);
 
@@ -1408,18 +1409,18 @@ static inline void memcg_kmem_uncharge_p
 }
 
 static inline int memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
-					  int order)
+					  unsigned int nr_pages)
 {
 	if (memcg_kmem_enabled())
-		return __memcg_kmem_charge_memcg(memcg, gfp, order);
+		return __memcg_kmem_charge_memcg(memcg, gfp, nr_pages);
 	return 0;
 }
 
 static inline void memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
-					     int order)
+					     unsigned int nr_pages)
 {
 	if (memcg_kmem_enabled())
-		__memcg_kmem_uncharge_memcg(memcg, 1 << order);
+		__memcg_kmem_uncharge_memcg(memcg, nr_pages);
 }
 
 /*
--- a/mm/memcontrol.c~mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg
+++ a/mm/memcontrol.c
@@ -2884,13 +2884,13 @@ void memcg_kmem_put_cache(struct kmem_ca
  * __memcg_kmem_charge_memcg: charge a kmem page
  * @memcg: memory cgroup to charge
  * @gfp: reclaim mode
- * @order: allocation order
+ * @nr_pages: number of pages to charge
  *
  * Returns 0 on success, an error code on failure.
  */
-int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order)
+int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
+			      unsigned int nr_pages)
 {
-	unsigned int nr_pages = 1 << order;
 	struct page_counter *counter;
 	int ret;
 
@@ -2934,7 +2934,7 @@ int __memcg_kmem_charge_page(struct page
 
 	memcg = get_mem_cgroup_from_current();
 	if (!mem_cgroup_is_root(memcg)) {
-		ret = __memcg_kmem_charge_memcg(memcg, gfp, order);
+		ret = __memcg_kmem_charge_memcg(memcg, gfp, 1 << order);
 		if (!ret) {
 			page->mem_cgroup = memcg;
 			__SetPageKmemcg(page);
--- a/mm/slab.h~mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg
+++ a/mm/slab.h
@@ -365,7 +365,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	}
 
-	ret = memcg_kmem_charge_memcg(memcg, gfp, order);
+	ret = memcg_kmem_charge_memcg(memcg, gfp, 1 << order);
 	if (ret)
 		goto out;
 
_
