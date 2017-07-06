From: akpm@linux-foundation.org
Subject: [patch 105/108] mm: memcontrol: account slab stats per
 lruvec
Date: Thu, 06 Jul 2017 15:40:55 -0700
Message-ID: <20170706224055.7_SJVA7jt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37464 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752825AbdGFWk7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, mm-commits@vger.kernel.org, riel@redhat.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: account slab stats per lruvec

Josef's redesign of the balancing between slab caches and the page cache
requires slab cache statistics at the lruvec level.

Link: http://lkml.kernel.org/r/20170530181724.27197-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   12 ++++--------
 mm/slab.h |   18 +-----------------
 mm/slub.c |    4 ++--
 3 files changed, 7 insertions(+), 27 deletions(-)

diff -puN mm/slab.c~mm-memcontrol-account-slab-stats-per-lruvec mm/slab.c
--- a/mm/slab.c~mm-memcontrol-account-slab-stats-per-lruvec
+++ a/mm/slab.c
@@ -1425,11 +1425,9 @@ static struct page *kmem_getpages(struct
 
 	nr_pages = (1 << cachep->gfporder);
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
-		add_node_page_state(page_pgdat(page),
-			NR_SLAB_RECLAIMABLE, nr_pages);
+		mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, nr_pages);
 	else
-		add_node_page_state(page_pgdat(page),
-			NR_SLAB_UNRECLAIMABLE, nr_pages);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, nr_pages);
 
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
@@ -1459,11 +1457,9 @@ static void kmem_freepages(struct kmem_c
 	kmemcheck_free_shadow(page, order);
 
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
-		sub_node_page_state(page_pgdat(page),
-				NR_SLAB_RECLAIMABLE, nr_freed);
+		mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, -nr_freed);
 	else
-		sub_node_page_state(page_pgdat(page),
-				NR_SLAB_UNRECLAIMABLE, nr_freed);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE, -nr_freed);
 
 	BUG_ON(!PageSlab(page));
 	__ClearPageSlabPfmemalloc(page);
diff -puN mm/slab.h~mm-memcontrol-account-slab-stats-per-lruvec mm/slab.h
--- a/mm/slab.h~mm-memcontrol-account-slab-stats-per-lruvec
+++ a/mm/slab.h
@@ -274,22 +274,11 @@ static __always_inline int memcg_charge_
 					     gfp_t gfp, int order,
 					     struct kmem_cache *s)
 {
-	int ret;
-
 	if (!memcg_kmem_enabled())
 		return 0;
 	if (is_root_cache(s))
 		return 0;
-
-	ret = memcg_kmem_charge_memcg(page, gfp, order, s->memcg_params.memcg);
-	if (ret)
-		return ret;
-
-	mod_memcg_page_state(page,
-			     (s->flags & SLAB_RECLAIM_ACCOUNT) ?
-			     NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-			     1 << order);
-	return 0;
+	return memcg_kmem_charge_memcg(page, gfp, order, s->memcg_params.memcg);
 }
 
 static __always_inline void memcg_uncharge_slab(struct page *page, int order,
@@ -297,11 +286,6 @@ static __always_inline void memcg_unchar
 {
 	if (!memcg_kmem_enabled())
 		return;
-
-	mod_memcg_page_state(page,
-			     (s->flags & SLAB_RECLAIM_ACCOUNT) ?
-			     NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-			     -(1 << order));
 	memcg_kmem_uncharge(page, order);
 }
 
diff -puN mm/slub.c~mm-memcontrol-account-slab-stats-per-lruvec mm/slub.c
--- a/mm/slub.c~mm-memcontrol-account-slab-stats-per-lruvec
+++ a/mm/slub.c
@@ -1615,7 +1615,7 @@ out:
 	if (!page)
 		return NULL;
 
-	mod_node_page_state(page_pgdat(page),
+	mod_lruvec_page_state(page,
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		1 << oo_order(oo));
@@ -1655,7 +1655,7 @@ static void __free_slab(struct kmem_cach
 
 	kmemcheck_free_shadow(page, compound_order(page));
 
-	mod_node_page_state(page_pgdat(page),
+	mod_lruvec_page_state(page,
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
_
