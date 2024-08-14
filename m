Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C2B10FA
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 00:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723596035; cv=none; b=siFENv6c8yBV2NQ9EzOeFS+DURwHxtW8GR4SWvy3k5glAaV4Akba7P2mJSz/N6ViWP4vfwNzxCmjJzJYHMypRUgt18iHewoTB4djFl1WzTEbWNDC4UqVdBaG/FUM3YsgS8ankK3PQs0IrWv1beEr7jmZtqcfa7XmGOwTPicaxlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723596035; c=relaxed/simple;
	bh=0Gg0A9ebZIprdGvGyCR2LIi6ewYQmCrai30ZnqjnbRg=;
	h=Date:To:From:Subject:Message-Id; b=UVdrZP+ubcWeuDKm7r3Q3wnIG6pbPxTHLGn5mGu4tJbo8r8TaBJjcfXj8A4iWLzbs48rpruoBBzVPzkTMcYRBu7b6u2DAMYnMfl5hJwU2rMnVf2TazkyDVXS7tQh9Z5ZyiPtekclbmVfVrzrWVzb7++wIPN09j7qEAZzL0yjR0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GryY5P7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GryY5P7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C70DC4AF0C;
	Wed, 14 Aug 2024 00:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723596034;
	bh=0Gg0A9ebZIprdGvGyCR2LIi6ewYQmCrai30ZnqjnbRg=;
	h=Date:To:From:Subject:From;
	b=GryY5P7v1oWTwCWIdpscOJqBYKdD+N77JBO3C4DUEAMQySMk10vMvomT+JnlSSdHG
	 0SwVcaQgBRhUWaIj9fZTGllhXFSBBCx99PM0aLg6qnpeIky0I27FVf1V/5fJM+6bD5
	 kDMH6Fw6UmNUyw/QnmTl2SWVp/E+6osbSIEkEWds=
Date: Tue, 13 Aug 2024 17:40:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,muchun.song@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-cma_alloc_folio.patch added to mm-unstable branch
Message-Id: <20240814004034.8C70DC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: add cma_alloc_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-add-cma_alloc_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-add-cma_alloc_folio.patch

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
Subject: mm/cma: add cma_alloc_folio()
Date: Sun, 11 Aug 2024 15:21:28 -0600

With alloc_contig_range() and free_contig_range() supporting large folios,
CMA can allocate and free large folios too, by cma_alloc_folio() and
cma_release().

Link: https://lkml.kernel.org/r/20240811212129.3074314-3-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    1 
 mm/cma.c            |   47 ++++++++++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 15 deletions(-)

--- a/include/linux/cma.h~mm-cma-add-cma_alloc_folio
+++ a/include/linux/cma.h
@@ -46,6 +46,7 @@ extern int cma_init_reserved_mem(phys_ad
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
+extern struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
 extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
--- a/mm/cma.c~mm-cma-add-cma_alloc_folio
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
+	if (WARN_ON(order && !(gfp | __GFP_COMP)))
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
mm-cma-add-cma_alloc_folio.patch

