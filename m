Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F43191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486703; cv=none; b=JUS9wmzSS/Ns1coRO/08yJokB1eO6BEV4m9pJnCLZrwFIMhAzO0ANaopHjAtASyizIHBtoUvA652H8+6HRZPDTJhFp2Z5Y1nhmDthFnMpc2QlzSDj0Bu6TiIgQB9mBD7Nqv36VkWppzZfsLi0wppmZsf3Br6S6dPHure4gr5CDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486703; c=relaxed/simple;
	bh=fRNai5lxwWaI40OhMQ2dzR2X0mSLENHwFXGk6iOWUUs=;
	h=Date:To:From:Subject:Message-Id; b=CENnloFPS/aVfaBpttXbkzJez3455EM4eTz1+1LMY1/kZl3F4lmNIRyr9AediTq1gfQBkno4zu3TnJ5o+Jrqa1IpHQ5Jtq+1WRGAr8yhdDaaPxpSs4z0cG2yEukgqi4Vm4vuNKCZbt3dYrq8vtfWPniaAw0hCSrYz849sDaAIu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jSEnI97e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jSEnI97e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96987C116C6;
	Tue, 27 Jan 2026 04:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486702;
	bh=fRNai5lxwWaI40OhMQ2dzR2X0mSLENHwFXGk6iOWUUs=;
	h=Date:To:From:Subject:From;
	b=jSEnI97eCVlU6lzLrjj+//yj7Vax+gWQcVHlfQ3pMlugc855Ly3dEA80+UcKCV5gg
	 +xAj1sWxDZAqNKcD5tekAKlsCPcJGt7hkjUbONdIYg9cxdomVrDiYnUF2jjBx1IDx4
	 nqo0Cdd6G5V+pey0+nTvOo3AKRRDgtG8l4bIrseA=
Date: Mon, 26 Jan 2026 20:05:02 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,claudiu.beznea.uj@bp.renesas.com,broonie@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch removed from -mm tree
Message-Id: <20260127040502.96987C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: allocate frozen pages for gigantic allocation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: allocate frozen pages for gigantic allocation
Date: Fri, 9 Jan 2026 17:31:36 +0800

alloc_gigantic_folio() allocates a folio with refcount increated and then
freeze it, convert to allocate a frozen folio to remove the atomic
operation about folio refcount, and saving atomic operation during
__update_and_free_hugetlb_folio() too.

Besides, rename hugetlb_cma_{alloc,free}_folio(), alloc_gigantic_folio()
and alloc_buddy_hugetlb_folio() with frozen which make them more
self-explanatory.

Link: https://lkml.kernel.org/r/20260109093136.1491549-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c     |   75 ++++++++++++---------------------------------
 mm/hugetlb_cma.c |    9 +----
 mm/hugetlb_cma.h |   10 +++---
 3 files changed, 28 insertions(+), 66 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation
+++ a/mm/hugetlb.c
@@ -121,16 +121,6 @@ static void hugetlb_unshare_pmds(struct
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
-static void hugetlb_free_folio(struct folio *folio)
-{
-	if (folio_test_hugetlb_cma(folio)) {
-		hugetlb_cma_free_folio(folio);
-		return;
-	}
-
-	folio_put(folio);
-}
-
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
@@ -1417,52 +1407,25 @@ err:
 	return NULL;
 }
 
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#ifdef CONFIG_CONTIG_ALLOC
-static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
+#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
+static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	bool retried = false;
-
-retry:
-	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
-	if (!folio) {
-		struct page *page;
-
-		if (hugetlb_cma_exclusive_alloc())
-			return NULL;
-
-		page = alloc_contig_frozen_pages(1 << order, gfp_mask, nid, nodemask);
-		if (!page)
-			return NULL;
 
-		set_page_refcounted(page);
-		folio = page_folio(page);
-	}
-
-	if (folio_ref_freeze(folio, 1))
+	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
+	if (folio)
 		return folio;
 
-	pr_warn("HugeTLB: unexpected refcount on PFN %lu\n", folio_pfn(folio));
-	hugetlb_free_folio(folio);
-	if (!retried) {
-		retried = true;
-		goto retry;
-	}
-	return NULL;
-}
+	if (hugetlb_cma_exclusive_alloc())
+		return NULL;
 
-#else /* !CONFIG_CONTIG_ALLOC */
-static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
-					  nodemask_t *nodemask)
-{
-	return NULL;
+	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
+							  nid, nodemask);
+	return folio;
 }
-#endif /* CONFIG_CONTIG_ALLOC */
-
-#else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
-static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+#else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
+static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
 					  nodemask_t *nodemask)
 {
 	return NULL;
@@ -1592,9 +1555,11 @@ static void __update_and_free_hugetlb_fo
 	if (unlikely(folio_test_hwpoison(folio)))
 		folio_clear_hugetlb_hwpoison(folio);
 
-	folio_ref_unfreeze(folio, 1);
-
-	hugetlb_free_folio(folio);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+	if (folio_test_hugetlb_cma(folio))
+		hugetlb_cma_free_frozen_folio(folio);
+	else
+		free_frozen_pages(&folio->page, folio_order(folio));
 }
 
 /*
@@ -1874,7 +1839,7 @@ struct address_space *hugetlb_folio_mapp
 	return NULL;
 }
 
-static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
+static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
 {
 	struct folio *folio;
@@ -1930,10 +1895,10 @@ static struct folio *only_alloc_fresh_hu
 		nid = numa_mem_id();
 
 	if (order_is_gigantic(order))
-		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
+		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
 	else
-		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
-						  node_alloc_noretry);
+		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
+						 node_alloc_noretry);
 	if (folio)
 		init_new_hugetlb_folio(folio);
 	return folio;
--- a/mm/hugetlb_cma.c~mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation
+++ a/mm/hugetlb_cma.c
@@ -18,16 +18,14 @@ static unsigned long hugetlb_cma_size_in
 static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
-void hugetlb_cma_free_folio(struct folio *folio)
+void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
-	folio_ref_dec(folio);
-
 	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
 					 &folio->page, folio_nr_pages(folio)));
 }
 
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
-				      int nid, nodemask_t *nodemask)
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	int node;
 	struct folio *folio;
@@ -50,7 +48,6 @@ struct folio *hugetlb_cma_alloc_folio(in
 	if (!page)
 		return NULL;
 
-	set_page_refcounted(page);
 	folio = page_folio(page);
 	folio_set_hugetlb_cma(folio);
 	return folio;
--- a/mm/hugetlb_cma.h~mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation
+++ a/mm/hugetlb_cma.h
@@ -3,8 +3,8 @@
 #define _LINUX_HUGETLB_CMA_H
 
 #ifdef CONFIG_CMA
-void hugetlb_cma_free_folio(struct folio *folio);
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
+void hugetlb_cma_free_frozen_folio(struct folio *folio);
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 						    bool node_exact);
@@ -13,12 +13,12 @@ unsigned long hugetlb_cma_total_size(voi
 void hugetlb_cma_validate_params(void);
 bool hugetlb_early_cma(struct hstate *h);
 #else
-static inline void hugetlb_cma_free_folio(struct folio *folio)
+static inline void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 }
 
-static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nodemask)
+static inline struct folio *hugetlb_cma_alloc_frozen_folio(int order,
+		gfp_t gfp_mask,	int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page_isolation-introduce-page_is_unmovable.patch
mm-page_alloc-optimize-pfn_range_valid_contig.patch
mm-hugetlb-optimize-replace_free_hugepage_folios.patch
mm-hugetlb_cma-optimize-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-mark-hugetlb_cma_only-as-__ro_after_init.patch

