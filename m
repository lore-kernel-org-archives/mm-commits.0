Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E7774070
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423488; cv=none; b=I4lFaIcvpVHWN3aoqPJYTwhQ3U0LzajqoyvmBw3JetF4fWwxFPWKWofYx9jRzSBoigcnxXcim2PrZ1/ff0YPjXaQmGsIFOYcpPu3gJ2YKbTMjdUOD6Qct9hAdlmEG3Yt/6wkw4/FIe8fTPwizXtrIOT8ifq2BgjrQ5IX7kQb29A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423488; c=relaxed/simple;
	bh=u2b803r8n63U0A+1yXt+LOsh3zgMB/iaWJY+0gloJAc=;
	h=Date:To:From:Subject:Message-Id; b=IOGIv/Pshd9MqmJhTfui/jwE0LcAJdcHS9yhKUm3Yhc7TUBdE/84LJGMG8rxD02JmfTwJUiPx84c5Qf9Vw4S7Cma3H+4sYLD+KXbVyDLPbh5funlMU1Q98SSxclVk1lzlh6BzT2xSNQpIR6aFKemUd6RY3Qo6BS4xF4OwsorM0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0wBa7P04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0wBa7P04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06FBC4CEC2;
	Wed,  4 Sep 2024 04:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423487;
	bh=u2b803r8n63U0A+1yXt+LOsh3zgMB/iaWJY+0gloJAc=;
	h=Date:To:From:Subject:From;
	b=0wBa7P04BivBRUTAHtQHRD7ecXK+Vq6jupL7RCQ00mpdokrW0TtMu7SMRDp01+bVr
	 30C6fDeOVb14u/QMLq2Tkbr5gc+wvgEX+9vrc4lFzRc3leMQw65n9bJ3JUA2JYxemN
	 haZjbUUV4SBcawvVufZUqcPnGqNaCx3hxolH49zc=
Date: Tue, 03 Sep 2024 21:18:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,muchun.song@linux.dev,fvdl@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-add-cma_allocfree_folio.patch removed from -mm tree
Message-Id: <20240904041807.D06FBC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: add cma_{alloc,free}_folio()
has been removed from the -mm tree.  Its filename was
     mm-cma-add-cma_allocfree_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/cma: add cma_{alloc,free}_folio()
Date: Tue, 13 Aug 2024 21:54:50 -0600

With alloc_contig_range() and free_contig_range() supporting large folios,
CMA can allocate and free large folios too, by cma_alloc_folio() and
cma_free_folio().

[yuzhao@google.com: fix WARN in cma_alloc_folio()]
  Link: https://lkml.kernel.org/r/Zsd0PgAQmbpR8jS6@google.com
Link: https://lkml.kernel.org/r/20240814035451.773331-3-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
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
+	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
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

mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

