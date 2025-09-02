Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2D62EA72B
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756857180; cv=none; b=l81RRG/c3KEtn9DlVlnTrEeWx9ULbQg4Z4CXLN1g1+F1JmtO/oIZyO1dSvWHzIjVvXqgJbM85FBlcd/SLk5e7HB7s6nlCjXMsOMQMxZi0eARm2xjtIQsrvp0xFf9dm5aBnXbvo5kaVkquJWFD5XbdLdFcc6dXyjKyT2yLEDLUVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756857180; c=relaxed/simple;
	bh=/LJryq4GpITAWLs7qrEsOs9TYJMAXZcOAvbA55d3y4M=;
	h=Date:To:From:Subject:Message-Id; b=BLHEe8SI5NA/OHufh1BKOqUqtvvXgc60qBcQVeHVxd+GKZefqeF4AgS1odeK1QnWUBKR9fXi90Z4Qab32JbIIgMVObSt1ramXYyUljQFO4Mo6E76fkUzLFlI2rzaGKawdpNtuA2s3fAQhN9EgkcMQHDWPQirw32d84t+eSDaQL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VjmpHdQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VjmpHdQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DECC4CEED;
	Tue,  2 Sep 2025 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756857180;
	bh=/LJryq4GpITAWLs7qrEsOs9TYJMAXZcOAvbA55d3y4M=;
	h=Date:To:From:Subject:From;
	b=VjmpHdQxHBp7xIDo5HEBn05foHoWZr+orAQuGFM9RQBmpmk+MbQUPBYOw7Vka8H+i
	 LHfOpmxIoO3fdOBaWxHXog0R6+w7f35onL0wB2bgjwQ9qXR2xETkwLf9vlC7mZjzmG
	 JR2rYIC3IS/+THeAm/T7TnkXKrJGn19MVjbl5nF4=
Date: Tue, 02 Sep 2025 16:52:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch added to mm-new branch
Message-Id: <20250902235300.80DECC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb: allocate frozen pages in alloc_gigantic_folio()
Date: Tue, 2 Sep 2025 20:48:20 +0800

The alloc_gigantic_folio() will allocate a folio by alloc_contig_range()
with refcount increated and then freeze it, convert to allocate a frozen
folio directly to remove the atomic operation about folio refcount, also
saving atomic operation during __update_and_free_hugetlb_folio too.

Rename some functions to make them more self-explanatory,

  folio_alloc_gigantic		-> folio_alloc_frozen_gigantic
  cma_alloc/free_folio		-> cma_alloc/free_frozen_folio
  hugetlb_cma_alloc/free_folio	-> hugetlb_cma_alloc/free_frozen_folio

Link: https://lkml.kernel.org/r/20250902124820.3081488-10-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    8 +++---
 include/linux/gfp.h |   14 +++++------
 mm/cma.c            |   22 ++++++++++++------
 mm/hugetlb.c        |   50 ++++++++----------------------------------
 mm/hugetlb_cma.c    |   13 +++++-----
 mm/hugetlb_cma.h    |   10 ++++----
 6 files changed, 47 insertions(+), 70 deletions(-)

--- a/include/linux/cma.h~mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio
+++ a/include/linux/cma.h
@@ -57,16 +57,16 @@ extern bool cma_intersects(struct cma *c
 extern void cma_reserve_pages_on_error(struct cma *cma);
 
 #ifdef CONFIG_CMA
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
-bool cma_free_folio(struct cma *cma, const struct folio *folio);
+struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp);
+bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio);
 bool cma_validate_zones(struct cma *cma);
 #else
-static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+static inline struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	return NULL;
 }
 
-static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
+static inline bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
 {
 	return false;
 }
--- a/include/linux/gfp.h~mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio
+++ a/include/linux/gfp.h
@@ -447,26 +447,26 @@ struct page *alloc_contig_frozen_pages_n
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 
 #ifdef CONFIG_CONTIG_ALLOC
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
+static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
+		gfp_t gfp, int nid, nodemask_t *node)
 {
 	struct page *page;
 
 	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
-	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
+	page = alloc_contig_frozen_pages_noprof(1 << order, gfp, nid, node);
 
 	return page ? page_folio(page) : NULL;
 }
 #else
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
+static inline struct folio *folio_alloc_frozen_gigantic_noprof(int order,
+		gfp_t gfp, int nid, nodemask_t *node)
 {
 	return NULL;
 }
 #endif
-/* This should be paired with folio_put() rather than free_contig_range(). */
-#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
+/* This must be paired with free_frozen_pages() rather than free_contig_range(). */
+#define folio_alloc_frozen_gigantic(...) alloc_hooks(folio_alloc_frozen_gigantic_noprof(__VA_ARGS__))
 
 #endif /* __LINUX_GFP_H */
--- a/mm/cma.c~mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio
+++ a/mm/cma.c
@@ -933,20 +933,21 @@ struct page *cma_alloc(struct cma *cma,
 			   ACR_FLAGS_CMA);
 }
 
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+struct folio *cma_alloc_frozen_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	struct page *page;
 
 	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
-	page = __cma_alloc(cma, 1 << order, order, gfp, ACR_FLAGS_CMA);
+	page = __cma_alloc(cma, 1 << order, order, gfp,
+			   ACR_FLAGS_CMA | ACR_FLAGS_FROZEN);
 
 	return page ? page_folio(page) : NULL;
 }
 
 static bool __cma_release(struct cma *cma, const struct page *pages,
-			  unsigned long count)
+			  unsigned long count, bool frozen_page)
 {
 	unsigned long pfn, end;
 	int r;
@@ -969,7 +970,14 @@ static bool __cma_release(struct cma *cm
 	if (r == cma->nranges)
 		return false;
 
-	free_contig_range(pfn, count);
+	if (frozen_page) {
+		struct page *head_page = compound_head((struct page *)pages);
+
+		free_frozen_pages(head_page, compound_order(head_page));
+	} else {
+		free_contig_range(pfn, count);
+	}
+
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
@@ -990,15 +998,15 @@ static bool __cma_release(struct cma *cm
 bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
-	return __cma_release(cma, pages, count);
+	return __cma_release(cma, pages, count, false);
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_free_frozen_folio(struct cma *cma, const struct folio *folio)
 {
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
 
-	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, &folio->page, folio_nr_pages(folio), true);
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
--- a/mm/hugetlb.c~mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio
+++ a/mm/hugetlb.c
@@ -125,16 +125,6 @@ static void hugetlb_unshare_pmds(struct
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
@@ -1472,43 +1462,20 @@ static int hstate_next_node_to_free(stru
 		nr_nodes--)
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#ifdef CONFIG_CONTIG_ALLOC
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	bool retried = false;
-
-retry:
-	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
-	if (!folio) {
-		if (hugetlb_cma_exclusive_alloc())
-			return NULL;
-
-		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
-		if (!folio)
-			return NULL;
-	}
 
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
+	return folio_alloc_frozen_gigantic(order, gfp_mask, nid, nodemask);
 }
-#endif /* CONFIG_CONTIG_ALLOC */
 
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
@@ -1641,9 +1608,12 @@ static void __update_and_free_hugetlb_fo
 	if (unlikely(folio_test_hwpoison(folio)))
 		folio_clear_hugetlb_hwpoison(folio);
 
-	folio_ref_unfreeze(folio, 1);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 
-	hugetlb_free_folio(folio);
+	if (folio_test_hugetlb_cma(folio))
+		hugetlb_cma_free_frozen_folio(folio);
+	else
+		free_frozen_pages(&folio->page, folio_order(folio));
 }
 
 /*
--- a/mm/hugetlb_cma.c~mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio
+++ a/mm/hugetlb_cma.c
@@ -18,29 +18,28 @@ static unsigned long hugetlb_cma_size_in
 static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
-void hugetlb_cma_free_folio(struct folio *folio)
+void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	int nid = folio_nid(folio);
 
-	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+	WARN_ON_ONCE(!cma_free_frozen_folio(hugetlb_cma[nid], folio));
 }
 
-
-struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
-				      int nid, nodemask_t *nodemask)
+struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	int node;
 	struct folio *folio = NULL;
 
 	if (hugetlb_cma[nid])
-		folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
+		folio = cma_alloc_frozen_folio(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!folio && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
+			folio = cma_alloc_frozen_folio(hugetlb_cma[node], order, gfp_mask);
 			if (folio)
 				break;
 		}
--- a/mm/hugetlb_cma.h~mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio
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
@@ -14,12 +14,12 @@ unsigned long hugetlb_cma_total_size(voi
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
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb-convert-to-use-more-alloc_fresh_hugetlb_folio.patch
mm-hugetlb-convert-to-account_new_hugetlb_folio.patch
mm-hugetlb-directly-pass-order-when-allocate-a-hugetlb-folio.patch
mm-hugetlb-remove-struct-hstate-from-init_new_hugetlb_folio.patch
mm-hugeltb-check-numa_no_node-in-only_alloc_fresh_hugetlb_folio.patch
mm-page_alloc-add-alloc_contig_frozen_pages.patch
mm-cma-add-alloc-flags-for-__cma_alloc.patch
mm-cma-add-__cma_release.patch
mm-hugetlb-allocate-frozen-pages-in-alloc_gigantic_folio.patch

