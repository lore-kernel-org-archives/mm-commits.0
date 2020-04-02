From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 068/155] mm: kmem: rename
 (__)memcg_kmem_(un)charge_memcg() to __memcg_kmem_(un)charge()
Date: Wed, 01 Apr 2020 21:06:56 -0700
Message-ID: <20200402040656.xLChSA2Iq%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEG7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:59 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: rename (__)memcg_kmem_(un)charge_memcg() to __memcg_kmem_(un)charge()

Drop the _memcg suffix from (__)memcg_kmem_(un)charge functions.  It's
shorter and more obvious.

These are the most basic functions which are just (un)charging the given
cgroup with the given amount of pages.

Also fix up the corresponding comments.

Link: http://lkml.kernel.org/r/20200109202659.752357-7-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   19 +++++++---------
 mm/memcontrol.c            |   40 +++++++++++++++++------------------
 mm/slab.h                  |    4 +--
 3 files changed, 31 insertions(+), 32 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge
+++ a/include/linux/memcontrol.h
@@ -1367,12 +1367,11 @@ struct kmem_cache *memcg_kmem_get_cache(
 void memcg_kmem_put_cache(struct kmem_cache *cachep);
 
 #ifdef CONFIG_MEMCG_KMEM
+int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
+			unsigned int nr_pages);
+void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
-int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
-			      unsigned int nr_pages);
-void __memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
-				 unsigned int nr_pages);
 
 extern struct static_key_false memcg_kmem_enabled_key;
 extern struct workqueue_struct *memcg_kmem_cache_wq;
@@ -1408,19 +1407,19 @@ static inline void memcg_kmem_uncharge_p
 		__memcg_kmem_uncharge_page(page, order);
 }
 
-static inline int memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
-					  unsigned int nr_pages)
+static inline int memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
+				    unsigned int nr_pages)
 {
 	if (memcg_kmem_enabled())
-		return __memcg_kmem_charge_memcg(memcg, gfp, nr_pages);
+		return __memcg_kmem_charge(memcg, gfp, nr_pages);
 	return 0;
 }
 
-static inline void memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
-					     unsigned int nr_pages)
+static inline void memcg_kmem_uncharge(struct mem_cgroup *memcg,
+				       unsigned int nr_pages)
 {
 	if (memcg_kmem_enabled())
-		__memcg_kmem_uncharge_memcg(memcg, nr_pages);
+		__memcg_kmem_uncharge(memcg, nr_pages);
 }
 
 /*
--- a/mm/memcontrol.c~mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge
+++ a/mm/memcontrol.c
@@ -2881,15 +2881,15 @@ void memcg_kmem_put_cache(struct kmem_ca
 }
 
 /**
- * __memcg_kmem_charge_memcg: charge a kmem page
+ * __memcg_kmem_charge: charge a number of kernel pages to a memcg
  * @memcg: memory cgroup to charge
  * @gfp: reclaim mode
  * @nr_pages: number of pages to charge
  *
  * Returns 0 on success, an error code on failure.
  */
-int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
-			      unsigned int nr_pages)
+int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
+			unsigned int nr_pages)
 {
 	struct page_counter *counter;
 	int ret;
@@ -2917,6 +2917,21 @@ int __memcg_kmem_charge_memcg(struct mem
 }
 
 /**
+ * __memcg_kmem_uncharge: uncharge a number of kernel pages from a memcg
+ * @memcg: memcg to uncharge
+ * @nr_pages: number of pages to uncharge
+ */
+void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		page_counter_uncharge(&memcg->kmem, nr_pages);
+
+	page_counter_uncharge(&memcg->memory, nr_pages);
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, nr_pages);
+}
+
+/**
  * __memcg_kmem_charge_page: charge a kmem page to the current memory cgroup
  * @page: page to charge
  * @gfp: reclaim mode
@@ -2934,7 +2949,7 @@ int __memcg_kmem_charge_page(struct page
 
 	memcg = get_mem_cgroup_from_current();
 	if (!mem_cgroup_is_root(memcg)) {
-		ret = __memcg_kmem_charge_memcg(memcg, gfp, 1 << order);
+		ret = __memcg_kmem_charge(memcg, gfp, 1 << order);
 		if (!ret) {
 			page->mem_cgroup = memcg;
 			__SetPageKmemcg(page);
@@ -2945,21 +2960,6 @@ int __memcg_kmem_charge_page(struct page
 }
 
 /**
- * __memcg_kmem_uncharge_memcg: uncharge a kmem page
- * @memcg: memcg to uncharge
- * @nr_pages: number of pages to uncharge
- */
-void __memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
-				 unsigned int nr_pages)
-{
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		page_counter_uncharge(&memcg->kmem, nr_pages);
-
-	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, nr_pages);
-}
-/**
  * __memcg_kmem_uncharge_page: uncharge a kmem page
  * @page: page to uncharge
  * @order: allocation order
@@ -2973,7 +2973,7 @@ void __memcg_kmem_uncharge_page(struct p
 		return;
 
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
-	__memcg_kmem_uncharge_memcg(memcg, nr_pages);
+	__memcg_kmem_uncharge(memcg, nr_pages);
 	page->mem_cgroup = NULL;
 
 	/* slab pages do not have PageKmemcg flag set */
--- a/mm/slab.h~mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge
+++ a/mm/slab.h
@@ -366,7 +366,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	}
 
-	ret = memcg_kmem_charge_memcg(memcg, gfp, nr_pages);
+	ret = memcg_kmem_charge(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 
@@ -397,7 +397,7 @@ static __always_inline void memcg_unchar
 	if (likely(!mem_cgroup_is_root(memcg))) {
 		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
 		mod_lruvec_state(lruvec, cache_vmstat_idx(s), -nr_pages);
-		memcg_kmem_uncharge_memcg(memcg, nr_pages);
+		memcg_kmem_uncharge(memcg, nr_pages);
 	} else {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 				    -nr_pages);
_
