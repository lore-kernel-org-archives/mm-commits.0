Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245BE257825
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 18:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767118586; cv=none; b=awYOxXt2O9EJR1XLb7P9xAK4T2e8Tvu07BmjU4zAM1/gic4N+uaMQkkhE0A4AVxX9dpAj46QMJierLgiAYNthZFugfUYungVVpmyQnusOwGMHNCkfY6l6KE9OCXLIw3VLrdA2azGf8R09b/D4Dfvtt3EMkNgkmubB6lTULMN2fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767118586; c=relaxed/simple;
	bh=tctQprGuwOc/qNGjaRSZmbCjH4b1ymfWciCz9MePpU0=;
	h=Date:To:From:Subject:Message-Id; b=WHb8hfe6jLlZD+2JLYsf8fMcbxvSaYqAwo+FPCnAXiVbb1PeU8J5ALbY2pR6HS6r5qmqJ0pnhNhy1l4YXYmPq6BW6XKnwE4PFBs/nnwybKsH/HulNiMPmW41VkMm1zA7vCpLIHYF/qLgKIZh0JpIejMVemdi53N0vMNcSWNrv3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GLQjHP6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GLQjHP6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBA5C4CEFB;
	Tue, 30 Dec 2025 18:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767118586;
	bh=tctQprGuwOc/qNGjaRSZmbCjH4b1ymfWciCz9MePpU0=;
	h=Date:To:From:Subject:From;
	b=GLQjHP6ttUB6kTJdVL48V/puAJz3QghTWuzxC8YEjkzcdVLyb4cBlp7dUYVjQ2CR5
	 GrPwBZmFIkTYxrYuTZC8DQcpwdaD5tFv3z5FNGmSFA8shThAyvsoa0iCoZZ3bNWe48
	 49+Tw9OEuoDHv4FAitT+/GURrOv4OsAKgNlAJap8=
Date: Tue, 30 Dec 2025 10:16:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-cma_alloc_frozen_compound.patch added to mm-new branch
Message-Id: <20251230181625.EDBA5C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cma: add cma_alloc_frozen{_compound}()
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-add-cma_alloc_frozen_compound.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-add-cma_alloc_frozen_compound.patch

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
Subject: mm: cma: add cma_alloc_frozen{_compound}()
Date: Tue, 30 Dec 2025 15:24:21 +0800

Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
incrementing their refcount, then convert hugetlb cma to use the
cma_alloc_frozen_compound() and cma_release_frozen() and remove the unused
cma_{alloc,free}_folio(), also move the cma_validate_zones() into
mm/internal.h since no outside user.

The set_pages_refcounted() is only called to set non-compound pages after
above changes, so remove the processing about PageHead.

Link: https://lkml.kernel.org/r/20251230072422.265265-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |   26 ++--------
 mm/cma.c            |  107 ++++++++++++++++++++++++++++--------------
 mm/hugetlb_cma.c    |   24 +++++----
 mm/internal.h       |   10 +--
 4 files changed, 97 insertions(+), 70 deletions(-)

--- a/include/linux/cma.h~mm-cma-add-cma_alloc_frozen_compound
+++ a/include/linux/cma.h
@@ -51,29 +51,15 @@ extern struct page *cma_alloc(struct cma
 			      bool no_warn);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
+struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
+		unsigned int align, bool no_warn);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+bool cma_release_frozen(struct cma *cma, const struct page *pages,
+		unsigned long count);
+
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
 extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
 
-#ifdef CONFIG_CMA
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
-bool cma_free_folio(struct cma *cma, const struct folio *folio);
-bool cma_validate_zones(struct cma *cma);
-#else
-static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
-{
-	return NULL;
-}
-
-static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
-{
-	return false;
-}
-static inline bool cma_validate_zones(struct cma *cma)
-{
-	return false;
-}
-#endif
-
 #endif
--- a/mm/cma.c~mm-cma-add-cma_alloc_frozen_compound
+++ a/mm/cma.c
@@ -856,8 +856,8 @@ out:
 	return ret;
 }
 
-static struct page *__cma_alloc(struct cma *cma, unsigned long count,
-		       unsigned int align, gfp_t gfp)
+static struct page *__cma_alloc_frozen(struct cma *cma,
+		unsigned long count, unsigned int align, gfp_t gfp)
 {
 	struct page *page = NULL;
 	int ret = -ENOMEM, r;
@@ -904,7 +904,6 @@ static struct page *__cma_alloc(struct c
 	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
 			       page, count, align, ret);
 	if (page) {
-		set_pages_refcounted(page, count);
 		count_vm_event(CMA_ALLOC_SUCCESS);
 		cma_sysfs_account_success_pages(cma, count);
 	} else {
@@ -915,6 +914,21 @@ static struct page *__cma_alloc(struct c
 	return page;
 }
 
+struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
+		unsigned int align, bool no_warn)
+{
+	gfp_t gfp = GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0);
+
+	return __cma_alloc_frozen(cma, count, align, gfp);
+}
+
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+{
+	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+
+	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
+}
+
 /**
  * cma_alloc() - allocate pages from contiguous area
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -928,42 +942,26 @@ static struct page *__cma_alloc(struct c
 struct page *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
 {
-	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
-}
-
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
-{
 	struct page *page;
 
-	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
-		return NULL;
-
-	page = __cma_alloc(cma, 1 << order, order, gfp);
+	page = cma_alloc_frozen(cma, count, align, no_warn);
+	if (page)
+		set_pages_refcounted(page, count);
 
-	return page ? page_folio(page) : NULL;
+	return page;
 }
 
-/**
- * cma_release() - release allocated pages
- * @cma:   Contiguous memory region for which the allocation is performed.
- * @pages: Allocated pages.
- * @count: Number of allocated pages.
- *
- * This function releases memory allocated by cma_alloc().
- * It returns false when provided pages do not belong to contiguous area and
- * true otherwise.
- */
-bool cma_release(struct cma *cma, const struct page *pages,
-		 unsigned long count)
+static struct cma_memrange *find_cma_memrange(struct cma *cma,
+		const struct page *pages, unsigned long count)
 {
-	struct cma_memrange *cmr;
+	struct cma_memrange *cmr = NULL;
 	unsigned long pfn, end_pfn;
 	int r;
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
 	if (!cma || !pages || count > cma->count)
-		return false;
+		return NULL;
 
 	pfn = page_to_pfn(pages);
 
@@ -981,27 +979,66 @@ bool cma_release(struct cma *cma, const
 	if (r == cma->nranges) {
 		pr_debug("%s(page %p, count %lu, no cma range matches the page range)\n",
 			 __func__, (void *)pages, count);
-		return false;
+		return NULL;
 	}
 
-	if (PageHead(pages))
-		__free_pages((struct page *)pages, compound_order(pages));
-	else
-		free_contig_range(pfn, count);
+	return cmr;
+}
+
+static void __cma_release_frozen(struct cma *cma, struct cma_memrange *cmr,
+		const struct page *pages, unsigned long count)
+{
+	unsigned long pfn = page_to_pfn(pages);
+
+	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
+	free_contig_frozen_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
+}
+
+/**
+ * cma_release() - release allocated pages
+ * @cma:   Contiguous memory region for which the allocation is performed.
+ * @pages: Allocated pages.
+ * @count: Number of allocated pages.
+ *
+ * This function releases memory allocated by cma_alloc().
+ * It returns false when provided pages do not belong to contiguous area and
+ * true otherwise.
+ */
+bool cma_release(struct cma *cma, const struct page *pages,
+		 unsigned long count)
+{
+	struct cma_memrange *cmr;
+	unsigned long pfn;
+
+	cmr = find_cma_memrange(cma, pages, count);
+	if (!cmr)
+		return false;
+
+	pfn = page_to_pfn(pages);
+	for (; count--; pfn++)
+		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+
+	__cma_release_frozen(cma, cmr, pages, count);
 
 	return true;
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_release_frozen(struct cma *cma, const struct page *pages,
+		unsigned long count)
 {
-	if (WARN_ON(!folio_test_large(folio)))
+	struct cma_memrange *cmr;
+
+	cmr = find_cma_memrange(cma, pages, count);
+	if (!cmr)
 		return false;
 
-	return cma_release(cma, &folio->page, folio_nr_pages(folio));
+	__cma_release_frozen(cma, cmr, pages, count);
+
+	return true;
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
--- a/mm/hugetlb_cma.c~mm-cma-add-cma_alloc_frozen_compound
+++ a/mm/hugetlb_cma.c
@@ -20,35 +20,39 @@ static unsigned long hugetlb_cma_size __
 
 void hugetlb_cma_free_folio(struct folio *folio)
 {
-	int nid = folio_nid(folio);
+	folio_ref_dec(folio);
 
-	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
+					 &folio->page, folio_nr_pages(folio)));
 }
 
-
 struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask)
 {
 	int node;
-	struct folio *folio = NULL;
+	struct folio *folio;
+	struct page *page = NULL;
 
 	if (hugetlb_cma[nid])
-		folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
-	if (!folio && !(gfp_mask & __GFP_THISNODE)) {
+	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
-			if (folio)
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			if (page)
 				break;
 		}
 	}
 
-	if (folio)
-		folio_set_hugetlb_cma(folio);
+	if (!page)
+		return NULL;
 
+	set_page_refcounted(page);
+	folio = page_folio(page);
+	folio_set_hugetlb_cma(folio);
 	return folio;
 }
 
--- a/mm/internal.h~mm-cma-add-cma_alloc_frozen_compound
+++ a/mm/internal.h
@@ -517,11 +517,6 @@ static inline void set_pages_refcounted(
 {
 	unsigned long pfn = page_to_pfn(page);
 
-	if (PageHead(page)) {
-		set_page_refcounted(page);
-		return;
-	}
-
 	for (; nr_pages--; pfn++)
 		set_page_refcounted(pfn_to_page(pfn));
 }
@@ -949,9 +944,14 @@ void init_cma_reserved_pageblock(struct
 struct cma;
 
 #ifdef CONFIG_CMA
+bool cma_validate_zones(struct cma *cma);
 void *cma_reserve_early(struct cma *cma, unsigned long size);
 void init_cma_pageblock(struct page *page);
 #else
+static inline bool cma_validate_zones(struct cma *cma)
+{
+	return false;
+}
 static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 {
 	return NULL;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

