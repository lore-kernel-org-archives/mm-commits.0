From: akpm@linux-foundation.org
Subject: + mm-memcontrol-account-slab-stats-per-lruvec.patch added to -mm
 tree
Date: Tue, 30 May 2017 13:53:54 -0700
Message-ID: <592ddbe2.ASATvQmPmPjMS5gH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdE3Uxz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 16:53:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, josef@toxicpanda.com, mhocko@suse.com, riel@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: account slab stats per lruvec
has been added to the -mm tree.  Its filename is
     mm-memcontrol-account-slab-stats-per-lruvec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-account-slab-stats-per-lruvec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-account-slab-stats-per-lruvec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: account slab stats per lruvec

Josef's redesign of the balancing between slab caches and the page cache
requires slab cache statistics at the lruvec level.

Link: http://lkml.kernel.org/r/20170530181724.27197-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-delete-unused-pgdat_reclaimable_pages.patch
mm-vmstat-move-slab-statistics-from-zone-to-node-counters.patch
mm-memcontrol-use-the-node-native-slab-memory-counters.patch
mm-memcontrol-use-generic-mod_memcg_page_state-for-kmem-pages.patch
mm-memcontrol-per-lruvec-stats-infrastructure.patch
mm-memcontrol-account-slab-stats-per-lruvec.patch

