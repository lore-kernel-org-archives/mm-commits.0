From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch added to -mm
 tree
Date: Mon, 24 Feb 2020 16:48:10 -0800
Message-ID: <20200225004810._A1L8hkXs%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBYAsM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 19:48:12 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: memcg/slab: cache page number in memcg_(un)charge_slab()
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
