From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 067/155] mm: memcg/slab: cache page number in
 memcg_(un)charge_slab()
Date: Wed, 01 Apr 2020 21:06:53 -0700
Message-ID: <20200402040653.w5qnPx2l1%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgDBEGy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:54 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: cache page number in memcg_(un)charge_slab()

There are many places in memcg_charge_slab() and memcg_uncharge_slab()
which are calculating the number of pages to charge, css references to
grab etc depending on the order of the slab page.

Let's simplify the code by calculating it once and caching in the local
variable.

Link: http://lkml.kernel.org/r/20200109202659.752357-6-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/slab.h~mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab
+++ a/mm/slab.h
@@ -348,6 +348,7 @@ static __always_inline int memcg_charge_
 					     gfp_t gfp, int order,
 					     struct kmem_cache *s)
 {
+	unsigned int nr_pages = 1 << order;
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	int ret;
@@ -360,21 +361,21 @@ static __always_inline int memcg_charge_
 
 	if (unlikely(!memcg || mem_cgroup_is_root(memcg))) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    (1 << order));
-		percpu_ref_get_many(&s->memcg_params.refcnt, 1 << order);
+				    nr_pages);
+		percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
 		return 0;
 	}
 
-	ret = memcg_kmem_charge_memcg(memcg, gfp, 1 << order);
+	ret = memcg_kmem_charge_memcg(memcg, gfp, nr_pages);
 	if (ret)
 		goto out;
 
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-	mod_lruvec_state(lruvec, cache_vmstat_idx(s), 1 << order);
+	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages);
 
 	/* transer try_charge() page references to kmem_cache */
-	percpu_ref_get_many(&s->memcg_params.refcnt, 1 << order);
-	css_put_many(&memcg->css, 1 << order);
+	percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
+	css_put_many(&memcg->css, nr_pages);
 out:
 	css_put(&memcg->css);
 	return ret;
@@ -387,6 +388,7 @@ out:
 static __always_inline void memcg_uncharge_slab(struct page *page, int order,
 						struct kmem_cache *s)
 {
+	unsigned int nr_pages = 1 << order;
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 
@@ -394,15 +396,15 @@ static __always_inline void memcg_unchar
 	memcg = READ_ONCE(s->memcg_params.memcg);
 	if (likely(!mem_cgroup_is_root(memcg))) {
 		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-		mod_lruvec_state(lruvec, cache_vmstat_idx(s), -(1 << order));
-		memcg_kmem_uncharge_memcg(memcg, order);
+		mod_lruvec_state(lruvec, cache_vmstat_idx(s), -nr_pages);
+		memcg_kmem_uncharge_memcg(memcg, nr_pages);
 	} else {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -(1 << order));
+				    -nr_pages);
 	}
 	rcu_read_unlock();
 
-	percpu_ref_put_many(&s->memcg_params.refcnt, 1 << order);
+	percpu_ref_put_many(&s->memcg_params.refcnt, nr_pages);
 }
 
 extern void slab_init_memcg_params(struct kmem_cache *);
_
