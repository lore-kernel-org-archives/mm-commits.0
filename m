Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405EE7346D
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 21:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723671802; cv=none; b=oLVXEEAFi10lrmYJTk6xa3ks5zcpJpEKX9t0O0pyASr/OZimEVMEAuhLVqdch9hi+jxGYPvhgC8+0CYybnrUdi98WjbScj66GILQ4qC9QW/uxpTAkvNPOK66RT1fKfqu8jv+9ZpiwImln+wllvNxRqI/IGm2Z+W+NCjvUq3I7t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723671802; c=relaxed/simple;
	bh=sM5OMRva1qhBd9oldOJwCq/Sc3a/FNFXgogyvbx9IyM=;
	h=Date:To:From:Subject:Message-Id; b=L7/1uTyLkt/PG9TDFU5bg9vUwRawzvPw1ztUg7mBfp/E2FxEc8DZW6Bszw43UOeUnvBx4yHmyMaNrGp/upjHLkaQfMMGawv7IE5+rilvIShTNMgmyHC3M/sF4I5uq4nJy4V4jEOvknMB3Np6QUXJTTA7H0hlrNBg5vVCEb0qQ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w9JICObY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w9JICObY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7311C116B1;
	Wed, 14 Aug 2024 21:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723671801;
	bh=sM5OMRva1qhBd9oldOJwCq/Sc3a/FNFXgogyvbx9IyM=;
	h=Date:To:From:Subject:From;
	b=w9JICObY8QQqE+gQ8ALuHWoqXOj+g/3UsLtyu85FWcRtcmj6rj6Hjn6eF2TiYzHPy
	 fJN7JKmsuIkK8BdQlVgCOLf8q5+REH7VscD5u81dTOTzK0dXsgkCDT6qLsnB8n3Wd3
	 ni7TFhPprqQ2A3HqeFaSwUtWNu36ZAFZ6HRZDJbY=
Date: Wed, 14 Aug 2024 14:43:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,muchun.song@linux.dev,fvdl@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-cma_allocfree_folio.patch added to mm-unstable branch
Message-Id: <20240814214321.C7311C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: add cma_{alloc,free}_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-add-cma_allocfree_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-add-cma_allocfree_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/cma: add cma_{alloc,free}_folio()
Date: Tue, 13 Aug 2024 21:54:50 -0600

With alloc_contig_range() and free_contig_range() supporting large folios,
CMA can allocate and free large folios too, by cma_alloc_folio() and
cma_free_folio().

Link: https://lkml.kernel.org/r/20240814035451.773331-3-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |   16 ++++++++++++
 mm/cma.c            |   55 ++++++++++++++++++++++++++++++------------
 2 files changed, 56 insertions(+), 15 deletions(-)

--- a/include/linux/cma.h~mm-cma-add-cma_allocfree_folio
+++ a/include/linux/cma.h
@@ -52,4 +52,20 @@ extern bool cma_release(struct cma *cma,
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
+
+#ifdef CONFIG_CMA
+struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
+bool cma_free_folio(struct cma *cma, const struct folio *folio);
+#else
+static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+{
+	return NULL;
+}
+
+static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
+{
+	return false;
+}
+#endif
+
 #endif
--- a/mm/cma.c~mm-cma-add-cma_allocfree_folio
+++ a/mm/cma.c
@@ -403,18 +403,8 @@ static void cma_debug_show_areas(struct
 	spin_unlock_irq(&cma->lock);
 }
 
-/**
- * cma_alloc() - allocate pages from contiguous area
- * @cma:   Contiguous memory region for which the allocation is performed.
- * @count: Requested number of pages.
- * @align: Requested alignment of pages (in PAGE_SIZE order).
- * @no_warn: Avoid printing message about failed allocation
- *
- * This function allocates part of contiguous memory on specific
- * contiguous memory area.
- */
-struct page *cma_alloc(struct cma *cma, unsigned long count,
-		       unsigned int align, bool no_warn)
+static struct page *__cma_alloc(struct cma *cma, unsigned long count,
+				unsigned int align, gfp_t gfp)
 {
 	unsigned long mask, offset;
 	unsigned long pfn = -1;
@@ -463,8 +453,7 @@ struct page *cma_alloc(struct cma *cma,
 
 		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
 		mutex_lock(&cma_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
-				     GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
+		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA, gfp);
 		mutex_unlock(&cma_mutex);
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
@@ -494,7 +483,7 @@ struct page *cma_alloc(struct cma *cma,
 			page_kasan_tag_reset(nth_page(page, i));
 	}
 
-	if (ret && !no_warn) {
+	if (ret && !(gfp & __GFP_NOWARN)) {
 		pr_err_ratelimited("%s: %s: alloc failed, req-size: %lu pages, ret: %d\n",
 				   __func__, cma->name, count, ret);
 		cma_debug_show_areas(cma);
@@ -513,6 +502,34 @@ struct page *cma_alloc(struct cma *cma,
 	return page;
 }
 
+/**
+ * cma_alloc() - allocate pages from contiguous area
+ * @cma:   Contiguous memory region for which the allocation is performed.
+ * @count: Requested number of pages.
+ * @align: Requested alignment of pages (in PAGE_SIZE order).
+ * @no_warn: Avoid printing message about failed allocation
+ *
+ * This function allocates part of contiguous memory on specific
+ * contiguous memory area.
+ */
+struct page *cma_alloc(struct cma *cma, unsigned long count,
+		       unsigned int align, bool no_warn)
+{
+	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
+}
+
+struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
+{
+	struct page *page;
+
+	if (WARN_ON(!order || !(gfp | __GFP_COMP)))
+		return NULL;
+
+	page = __cma_alloc(cma, 1 << order, order, gfp);
+
+	return page ? page_folio(page) : NULL;
+}
+
 bool cma_pages_valid(struct cma *cma, const struct page *pages,
 		     unsigned long count)
 {
@@ -564,6 +581,14 @@ bool cma_release(struct cma *cma, const
 	return true;
 }
 
+bool cma_free_folio(struct cma *cma, const struct folio *folio)
+{
+	if (WARN_ON(!folio_test_large(folio)))
+		return false;
+
+	return cma_release(cma, &folio->page, folio_nr_pages(folio));
+}
+
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
 {
 	int i;
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch
mm-swap-remove-boilerplate-fix.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch
mm-hugetlb_vmemmap-batch-hvo-work-when-demoting.patch
mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch

