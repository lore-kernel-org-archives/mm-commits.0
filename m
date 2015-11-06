From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-unify-slab-and-other-kmem-pages-charging-fix.patch removed from -mm
 tree
Date: Thu, 05 Nov 2015 18:27:05 -0800
Message-ID: <563c0ff9.C/TL2N7PU/9Hijgb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-unify-slab-and-other-kmem-pages-charging-fix
has been removed from the -mm tree.  Its filename was
     memcg-unify-slab-and-other-kmem-pages-charging-fix.patch

This patch was dropped because it was folded into memcg-unify-slab-and-other-kmem-pages-charging.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: memcg-unify-slab-and-other-kmem-pages-charging-fix

I think it'd be better to have an outer function than a magic parameter
for the memcg lookup.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++---
 mm/memcontrol.c            |   36 +++++++++++++++++------------------
 mm/slab.h                  |    4 +--
 3 files changed, 24 insertions(+), 23 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-unify-slab-and-other-kmem-pages-charging-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-unify-slab-and-other-kmem-pages-charging-fix
+++ a/include/linux/memcontrol.h
@@ -752,8 +752,9 @@ static inline bool memcg_kmem_is_active(
  * conditions, but because they are pretty simple, they are expected to be
  * fast.
  */
-int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order,
-			struct mem_cgroup *memcg);
+int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
+			      struct mem_cgroup *memcg);
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge(struct page *page, int order);
 
 /*
@@ -795,7 +796,7 @@ static __always_inline int memcg_kmem_ch
 {
 	if (__memcg_kmem_bypass(gfp))
 		return 0;
-	return __memcg_kmem_charge(page, gfp, order, NULL);
+	return __memcg_kmem_charge(page, gfp, order);
 }
 
 /**
diff -puN mm/memcontrol.c~memcg-unify-slab-and-other-kmem-pages-charging-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-unify-slab-and-other-kmem-pages-charging-fix
+++ a/mm/memcontrol.c
@@ -2376,39 +2376,39 @@ void __memcg_kmem_put_cache(struct kmem_
 		css_put(&cachep->memcg_params.memcg->css);
 }
 
-/*
- * If @memcg != NULL, charge to @memcg, otherwise charge to the memcg the
- * current task belongs to.
- */
-int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order,
-			struct mem_cgroup *memcg)
+int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
+			      struct mem_cgroup *memcg)
 {
-	struct page_counter *counter;
 	unsigned int nr_pages = 1 << order;
-	bool put = false;
+	struct page_counter *counter;
 	int ret = 0;
 
-	if (!memcg) {
-		memcg = get_mem_cgroup_from_mm(current->mm);
-		put = true;
-	}
 	if (!memcg_kmem_is_active(memcg))
-		goto out;
+		return 0;
 
 	ret = page_counter_try_charge(&memcg->kmem, nr_pages, &counter);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret) {
 		page_counter_uncharge(&memcg->kmem, nr_pages);
-		goto out;
+		return ret;
 	}
 
 	page->mem_cgroup = memcg;
-out:
-	if (put)
-		css_put(&memcg->css);
+
+	return 0;
+}
+
+int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_mm(current->mm);
+	ret = __memcg_kmem_charge_memcg(page, gfp, order, memcg);
+	css_put(&memcg->css);
 	return ret;
 }
 
diff -puN mm/slab.h~memcg-unify-slab-and-other-kmem-pages-charging-fix mm/slab.h
--- a/mm/slab.h~memcg-unify-slab-and-other-kmem-pages-charging-fix
+++ a/mm/slab.h
@@ -244,8 +244,8 @@ static __always_inline int memcg_charge_
 		return 0;
 	if (is_root_cache(s))
 		return 0;
-	return __memcg_kmem_charge(page, gfp, order,
-				   s->memcg_params.memcg);
+	return __memcg_kmem_charge_memcg(page, gfp, order,
+					 s->memcg_params.memcg);
 }
 
 extern void slab_init_memcg_params(struct kmem_cache *);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-unify-slab-and-other-kmem-pages-charging.patch
mm-memcontrol-eliminate-root-memorycurrent.patch
mm-memcontrol-eliminate-root-memorycurrent-fix-2.patch
mm-page_counter-let-page_counter_try_charge-return-bool.patch

