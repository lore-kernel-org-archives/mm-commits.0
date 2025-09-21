Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B3C28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489833; cv=none; b=Cl2VZ3HkORrL9P+3o5KInMoyBkkj1h+jdFlDm1pcX42JWPk/xHNpdvAcS94ofs46f5/6a/5Sw2/7Enjkof5AjAq8ks8jxek1DEmpOeaK/ONoYS9KUouFsGY2oYZuNKerNQD7tmVlWZSh2c0DSfZFxSLqY1Igj1w2sb4UWBNIDw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489833; c=relaxed/simple;
	bh=w+NUk8Ym1HhuJoTOeBRwNYrzISvuOiSBY6IbHD78zTM=;
	h=Date:To:From:Subject:Message-Id; b=eKoU52pL0jgurlYjDUun+LdJLUqY9+mW5QWtbioOSKSn3pVKqpRMB6gJM0dpzUjUSEwyPknftgx2yHbkW66RqWGVZXJOY00XSAJcNEAFuuK5LWKREpQY3H75TVq7QOu8UZWqIGLKJd/qMgKG3tZ7EwvB8J6uO2w9ovklOf42gJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RZLq9xkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RZLq9xkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAABC4CEE7;
	Sun, 21 Sep 2025 21:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489833;
	bh=w+NUk8Ym1HhuJoTOeBRwNYrzISvuOiSBY6IbHD78zTM=;
	h=Date:To:From:Subject:From;
	b=RZLq9xkn7xDi/rY0mgegbpHwetF60yYD8D/R1kvACnlDasI1UhAbRxBlO9ITlVTpI
	 IO9wxYeEPfta5LOoOnEmzseFOotZ0I0+51+o8HjF1/wuhBPEpzQGdkk502j/euY2v5
	 PkpPtXqYOPrzhktfY51AuJeggPRwSZM54aXQ0IOc=
Date: Sun, 21 Sep 2025 14:23:52 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,alexandru.elisei@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-refuse-handing-out-non-contiguous-page-ranges.patch removed from -mm tree
Message-Id: <20250921212353.3BAABC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: refuse handing out non-contiguous page ranges
has been removed from the -mm tree.  Its filename was
     mm-cma-refuse-handing-out-non-contiguous-page-ranges.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/cma: refuse handing out non-contiguous page ranges
Date: Mon, 1 Sep 2025 17:03:43 +0200

Let's disallow handing out PFN ranges with non-contiguous pages, so we can
remove the nth-page usage in __cma_alloc(), and so any callers don't have
to worry about that either when wanting to blindly iterate pages.

This is really only a problem in configs with SPARSEMEM but without
SPARSEMEM_VMEMMAP, and only when we would cross memory sections in some
cases.

Will this cause harm?  Probably not, because it's mostly 32bit that does
not support SPARSEMEM_VMEMMAP.  If this ever becomes a problem we could
look into allocating the memmap for the memory sections spanned by a
single CMA region in one go from memblock.

[david@redhat.com: we can have NUMMU configs with SPARSEMEM enabled]
  Link: https://lkml.kernel.org/r/6ec933b1-b3f7-41c0-95d8-e518bb87375e@redhat.com
Link: https://lkml.kernel.org/r/20250901150359.867252-23-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++++
 mm/cma.c           |   39 ++++++++++++++++++++++++---------------
 mm/util.c          |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-cma-refuse-handing-out-non-contiguous-page-ranges
+++ a/include/linux/mm.h
@@ -209,9 +209,15 @@ extern unsigned long sysctl_user_reserve
 extern unsigned long sysctl_admin_reserve_kbytes;
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 #else
 #define nth_page(page,n) ((page) + (n))
+static inline bool page_range_contiguous(const struct page *page,
+		unsigned long nr_pages)
+{
+	return true;
+}
 #endif
 
 /* to align the pointer to the (next) page boundary */
--- a/mm/cma.c~mm-cma-refuse-handing-out-non-contiguous-page-ranges
+++ a/mm/cma.c
@@ -780,10 +780,8 @@ static int cma_range_alloc(struct cma *c
 				unsigned long count, unsigned int align,
 				struct page **pagep, gfp_t gfp)
 {
-	unsigned long mask, offset;
-	unsigned long pfn = -1;
-	unsigned long start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
+	unsigned long start, pfn, mask, offset;
 	int ret = -EBUSY;
 	struct page *page = NULL;
 
@@ -795,7 +793,7 @@ static int cma_range_alloc(struct cma *c
 	if (bitmap_count > bitmap_maxno)
 		goto out;
 
-	for (;;) {
+	for (start = 0; ; start = bitmap_no + mask + 1) {
 		spin_lock_irq(&cma->lock);
 		/*
 		 * If the request is larger than the available number
@@ -812,6 +810,22 @@ static int cma_range_alloc(struct cma *c
 			spin_unlock_irq(&cma->lock);
 			break;
 		}
+
+		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
+		page = pfn_to_page(pfn);
+
+		/*
+		 * Do not hand out page ranges that are not contiguous, so
+		 * callers can just iterate the pages without having to worry
+		 * about these corner cases.
+		 */
+		if (!page_range_contiguous(page, count)) {
+			spin_unlock_irq(&cma->lock);
+			pr_warn_ratelimited("%s: %s: skipping incompatible area [0x%lx-0x%lx]",
+					    __func__, cma->name, pfn, pfn + count - 1);
+			continue;
+		}
+
 		bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
 		cma->available_count -= count;
 		/*
@@ -821,29 +835,24 @@ static int cma_range_alloc(struct cma *c
 		 */
 		spin_unlock_irq(&cma->lock);
 
-		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
 		mutex_lock(&cma->alloc_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
-		if (ret == 0) {
-			page = pfn_to_page(pfn);
+		if (!ret)
 			break;
-		}
 
 		cma_clear_bitmap(cma, cmr, pfn, count);
 		if (ret != -EBUSY)
 			break;
 
 		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
-			 __func__, pfn, pfn_to_page(pfn));
+			 __func__, pfn, page);
 
-		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
-					   count, align);
-		/* try again with a bit different memory target */
-		start = bitmap_no + mask + 1;
+		trace_cma_alloc_busy_retry(cma->name, pfn, page, count, align);
 	}
 out:
-	*pagep = page;
+	if (!ret)
+		*pagep = page;
 	return ret;
 }
 
@@ -882,7 +891,7 @@ static struct page *__cma_alloc(struct c
 	 */
 	if (page) {
 		for (i = 0; i < count; i++)
-			page_kasan_tag_reset(nth_page(page, i));
+			page_kasan_tag_reset(page + i);
 	}
 
 	if (ret && !(gfp & __GFP_NOWARN)) {
--- a/mm/util.c~mm-cma-refuse-handing-out-non-contiguous-page-ranges
+++ a/mm/util.c
@@ -1281,3 +1281,38 @@ unsigned int folio_pte_batch(struct foli
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
 }
 #endif /* CONFIG_MMU */
+
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/**
+ * page_range_contiguous - test whether the page range is contiguous
+ * @page: the start of the page range.
+ * @nr_pages: the number of pages in the range.
+ *
+ * Test whether the page range is contiguous, such that they can be iterated
+ * naively, corresponding to iterating a contiguous PFN range.
+ *
+ * This function should primarily only be used for debug checks, or when
+ * working with page ranges that are not naturally contiguous (e.g., pages
+ * within a folio are).
+ *
+ * Returns true if contiguous, otherwise false.
+ */
+bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
+{
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long pfn;
+
+	/*
+	 * The memmap is allocated per memory section, so no need to check
+	 * within the first section. However, we need to check each other
+	 * spanned memory section once, making sure the first page in a
+	 * section could similarly be reached by just iterating pages.
+	 */
+	for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
+	     pfn < end_pfn; pfn += PAGES_PER_SECTION)
+		if (unlikely(page + (pfn - start_pfn) != pfn_to_page(pfn)))
+			return false;
+	return true;
+}
+#endif
_

Patches currently in -mm which might be from david@redhat.com are


