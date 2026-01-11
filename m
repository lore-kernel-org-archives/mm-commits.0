Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1861A294
	for <mm-commits@vger.kernel.org>; Sun, 11 Jan 2026 01:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768096692; cv=none; b=gGKfI2qL51mKEZLLva04C7eVEQJ4tjx3FNcKnZWVHVPmZQmFUeLo7b8E+LTgSeXEaB8DnuQteBQ0wMQbPK3YRMzhfsUO8/+UTXin6TU/iGeKpVZu3osaRZ7dh20luSSVIRTFHOSZ7naNdlP5WswHm+JBzgg2Z79dMmCD5ThCWhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768096692; c=relaxed/simple;
	bh=YoqJnaL78mLpWrFr+0601Vu+Otf7FwKt97AhdXnvnnY=;
	h=Date:To:From:Subject:Message-Id; b=ajzQxuzYff5LD+XTKL+XotNQK8mXz7TYBDTPiVBtX8kNmJ8Qm/5ZP/yAWYTytwCZVFXGcsXtxtv9VwfiPbkDVm6tTA7KaETw3P/y8aKtrHbm8NcpauZS6T3Yl2L8ZWj/71ADvqGdMg+nBse8lWB1ZuA5ovzN3fZ4uWcKlnDbJio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zIXO7lk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIXO7lk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCD0C4CEF1;
	Sun, 11 Jan 2026 01:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768096691;
	bh=YoqJnaL78mLpWrFr+0601Vu+Otf7FwKt97AhdXnvnnY=;
	h=Date:To:From:Subject:From;
	b=zIXO7lk+TiJwdW43bRrMoPYNsSo8eMRbYfPwpgbYZDKAP7dfiEoiKbsM1iLNmfXCH
	 csX+Kt8AjRJTQVxKu3KGBfJWDN8kCn7rOPM7sjZ1+JWQBzgh0dsloCVFCtVS0UK5Ik
	 mMwlEOMpHDjS7dQ8Q2DsWeV2e2O+lWBAt+mINPkk=
Date: Sat, 10 Jan 2026 17:58:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,claudiu.beznea.uj@bp.renesas.com,broonie@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch added to mm-new branch
Message-Id: <20260111015811.7BCD0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: allocate frozen pages for gigantic allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

