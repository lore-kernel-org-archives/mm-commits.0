Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EA01E9B1C
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 18:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767118582; cv=none; b=RO+U9u0f9R5AcMi2Tu9TaDRwIqPQU3vgGu/ymTGnnhXeQYYw8F3KqtO5z8aic+4D4/7NXhT3E6/OBtQC/un7P7+HhIRPqZ5eDLvfuJk6grXmQU1z4QuZNyv1aVK5lNHLJTjqSyf3hee3qRcpFho1qefmHc9CWk6DQAFJvjoE808=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767118582; c=relaxed/simple;
	bh=JXkFtqms4Uq9RFYgqOlzyRY/ZjK/PGbXxIW/pgz0lFg=;
	h=Date:To:From:Subject:Message-Id; b=RcAzdjcJ4N5wrVwUI6WgzvhKqopJqkQl+Uaue86rPnXmmoou8RmK24k1vD5UhzubwYdx0c1MVLJPAnvo4rIqg0hmsEVpwJhCjgsm8GGmH2Y87A2WSMZBPO9FY1x8/ic2A90jykxJa8javxowTh9rUDIEYwvY7ecn3ZPCbc8tg/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=peudUSgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="peudUSgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07AFC4CEFB;
	Tue, 30 Dec 2025 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767118581;
	bh=JXkFtqms4Uq9RFYgqOlzyRY/ZjK/PGbXxIW/pgz0lFg=;
	h=Date:To:From:Subject:From;
	b=peudUSgZ0fwYpi5wngn6HrEqgdrZWtQV3VNRTaFWUcgEuM2m1B72+Mhp9NNO8HqHy
	 fqOYrPg9RCu3GurJniG0ga20eIKOOY2GKl+zjBSm6bfYAojcT6eJq+iqEfcXwyCioy
	 7z3Rzo9HJ+YXf2yLqCi8VTEsZu05rxj3ppJiqF3s=
Date: Tue, 30 Dec 2025 10:16:21 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,jane.chu@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-alloc_contig_frozen_rangepages.patch added to mm-new branch
Message-Id: <20251230181621.C07AFC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: add alloc_contig_frozen_{range,pages}()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-add-alloc_contig_frozen_rangepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-alloc_contig_frozen_rangepages.patch

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
Subject: mm: page_alloc: add alloc_contig_frozen_{range,pages}()
Date: Tue, 30 Dec 2025 15:24:20 +0800

In order to allocate given range of pages or allocate compound pages
without incrementing their refcount, adding two new helper
alloc_contig_frozen_{range,pages}() which may be beneficial to some users
(eg hugetlb).

The new alloc_contig_{range,pages} only take !__GFP_COMP gfp now, and the
free_contig_range() is refactored to only free non-compound pages, the
only caller to free compound pages in cma_free_folio() is changed
accordingly, and the free_contig_frozen_range() is provided to match the
alloc_contig_frozen_range(), which is used to free frozen pages.

Link: https://lkml.kernel.org/r/20251230072422.265265-5-wangkefeng.wang@huawei.com
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

 include/linux/gfp.h |   50 ++++-------
 mm/cma.c            |    9 +-
 mm/hugetlb.c        |    9 +-
 mm/internal.h       |   13 ++
 mm/page_alloc.c     |  186 ++++++++++++++++++++++++++++++------------
 5 files changed, 183 insertions(+), 84 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-add-alloc_contig_frozen_rangepages
+++ a/include/linux/gfp.h
@@ -430,40 +430,30 @@ typedef unsigned int __bitwise acr_flags
 #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
 
 /* The below functions must be run on a range from a single zone. */
-extern int alloc_contig_range_noprof(unsigned long start, unsigned long end,
-				     acr_flags_t alloc_flags, gfp_t gfp_mask);
-#define alloc_contig_range(...)			alloc_hooks(alloc_contig_range_noprof(__VA_ARGS__))
-
-extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
-					      int nid, nodemask_t *nodemask);
-#define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
+int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask);
+#define alloc_contig_frozen_range(...)	\
+	alloc_hooks(alloc_contig_frozen_range_noprof(__VA_ARGS__))
+
+int alloc_contig_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask);
+#define alloc_contig_range(...)	\
+	alloc_hooks(alloc_contig_range_noprof(__VA_ARGS__))
+
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask);
+#define alloc_contig_frozen_pages(...) \
+	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
+
+struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask);
+#define alloc_contig_pages(...)	\
+	alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
 
+void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages);
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 #endif
 
-#ifdef CONFIG_CONTIG_ALLOC
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
-{
-	struct page *page;
-
-	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
-		return NULL;
-
-	page = alloc_contig_pages_noprof(1 << order, gfp, nid, node);
-
-	return page ? page_folio(page) : NULL;
-}
-#else
-static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
-							int nid, nodemask_t *node)
-{
-	return NULL;
-}
-#endif
-/* This should be paired with folio_put() rather than free_contig_range(). */
-#define folio_alloc_gigantic(...) alloc_hooks(folio_alloc_gigantic_noprof(__VA_ARGS__))
-
 DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
 
 #endif /* __LINUX_GFP_H */
--- a/mm/cma.c~mm-page_alloc-add-alloc_contig_frozen_rangepages
+++ a/mm/cma.c
@@ -836,7 +836,7 @@ static int cma_range_alloc(struct cma *c
 		spin_unlock_irq(&cma->lock);
 
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		ret = alloc_contig_frozen_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (!ret)
 			break;
@@ -904,6 +904,7 @@ static struct page *__cma_alloc(struct c
 	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
 			       page, count, align, ret);
 	if (page) {
+		set_pages_refcounted(page, count);
 		count_vm_event(CMA_ALLOC_SUCCESS);
 		cma_sysfs_account_success_pages(cma, count);
 	} else {
@@ -983,7 +984,11 @@ bool cma_release(struct cma *cma, const
 		return false;
 	}
 
-	free_contig_range(pfn, count);
+	if (PageHead(pages))
+		__free_pages((struct page *)pages, compound_order(pages));
+	else
+		free_contig_range(pfn, count);
+
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
--- a/mm/hugetlb.c~mm-page_alloc-add-alloc_contig_frozen_rangepages
+++ a/mm/hugetlb.c
@@ -1428,12 +1428,17 @@ static struct folio *alloc_gigantic_foli
 retry:
 	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
+		struct page *page;
+
 		if (hugetlb_cma_exclusive_alloc())
 			return NULL;
 
-		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
-		if (!folio)
+		page = alloc_contig_frozen_pages(1 << order, gfp_mask, nid, nodemask);
+		if (!page)
 			return NULL;
+
+		set_page_refcounted(page);
+		folio = page_folio(page);
 	}
 
 	if (folio_ref_freeze(folio, 1))
--- a/mm/internal.h~mm-page_alloc-add-alloc_contig_frozen_rangepages
+++ a/mm/internal.h
@@ -513,6 +513,19 @@ static inline void set_page_refcounted(s
 	set_page_count(page, 1);
 }
 
+static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	if (PageHead(page)) {
+		set_page_refcounted(page);
+		return;
+	}
+
+	for (; nr_pages--; pfn++)
+		set_page_refcounted(pfn_to_page(pfn));
+}
+
 /*
  * Return true if a folio needs ->release_folio() calling upon it.
  */
--- a/mm/page_alloc.c~mm-page_alloc-add-alloc_contig_frozen_rangepages
+++ a/mm/page_alloc.c
@@ -6882,7 +6882,7 @@ static int __alloc_contig_migrate_range(
 	return (ret < 0) ? ret : 0;
 }
 
-static void split_free_pages(struct list_head *list, gfp_t gfp_mask)
+static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 {
 	int order;
 
@@ -6894,11 +6894,10 @@ static void split_free_pages(struct list
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
-			set_page_refcounted(page);
 			if (!order)
 				continue;
 
-			split_page(page, order);
+			__split_page(page, order);
 
 			/* Add all subpages to the order-0 head, in sequence. */
 			list_del(&page->lru);
@@ -6942,8 +6941,14 @@ static int __alloc_contig_verify_gfp_mas
 	return 0;
 }
 
+static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
+{
+	for (; nr_pages--; pfn++)
+		free_frozen_pages(pfn_to_page(pfn), 0);
+}
+
 /**
- * alloc_contig_range() -- tries to allocate given range of pages
+ * alloc_contig_frozen_range() -- tries to allocate given range of frozen pages
  * @start:	start PFN to allocate
  * @end:	one-past-the-last PFN to allocate
  * @alloc_flags:	allocation information
@@ -6958,12 +6963,15 @@ static int __alloc_contig_verify_gfp_mas
  * pageblocks in the range.  Once isolated, the pageblocks should not
  * be modified by others.
  *
- * Return: zero on success or negative error code.  On success all
- * pages which PFN is in [start, end) are allocated for the caller and
- * need to be freed with free_contig_range().
+ * All frozen pages which PFN is in [start, end) are allocated for the
+ * caller, and they could be freed with free_contig_frozen_range(),
+ * free_frozen_pages() also could be used to free compound frozen pages
+ * directly.
+ *
+ * Return: zero on success or negative error code.
  */
-int alloc_contig_range_noprof(unsigned long start, unsigned long end,
-			      acr_flags_t alloc_flags, gfp_t gfp_mask)
+int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
 	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
@@ -7079,19 +7087,18 @@ int alloc_contig_range_noprof(unsigned l
 	}
 
 	if (!(gfp_mask & __GFP_COMP)) {
-		split_free_pages(cc.freepages, gfp_mask);
+		split_free_frozen_pages(cc.freepages, gfp_mask);
 
 		/* Free head and tail (if any) */
 		if (start != outer_start)
-			free_contig_range(outer_start, start - outer_start);
+			__free_contig_frozen_range(outer_start, start - outer_start);
 		if (end != outer_end)
-			free_contig_range(end, outer_end - end);
+			__free_contig_frozen_range(end, outer_end - end);
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-		set_page_refcounted(head);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7101,16 +7108,40 @@ done:
 	undo_isolate_page_range(start, end);
 	return ret;
 }
-EXPORT_SYMBOL(alloc_contig_range_noprof);
+EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
 
-static int __alloc_contig_pages(unsigned long start_pfn,
-				unsigned long nr_pages, gfp_t gfp_mask)
+/**
+ * alloc_contig_range() -- tries to allocate given range of pages
+ * @start:	start PFN to allocate
+ * @end:	one-past-the-last PFN to allocate
+ * @alloc_flags:	allocation information
+ * @gfp_mask:	GFP mask.
+ *
+ * This routine is a wrapper around alloc_contig_frozen_range(), it can't
+ * be used to allocate compound pages, the refcount of each allocated page
+ * will be set to one.
+ *
+ * All pages which PFN is in [start, end) are allocated for the caller,
+ * and should be freed with free_contig_range() or by manually calling
+ * __free_page() on each allocated page.
+ *
+ * Return: zero on success or negative error code.
+ */
+int alloc_contig_range_noprof(unsigned long start, unsigned long end,
+			      acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
-	unsigned long end_pfn = start_pfn + nr_pages;
+	int ret;
 
-	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
-					 gfp_mask);
+	if (WARN_ON(gfp_mask & __GFP_COMP))
+		return -EINVAL;
+
+	ret = alloc_contig_frozen_range_noprof(start, end, alloc_flags, gfp_mask);
+	if (!ret)
+		set_pages_refcounted(pfn_to_page(start), end - start);
+
+	return ret;
 }
+EXPORT_SYMBOL(alloc_contig_range_noprof);
 
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 				   unsigned long nr_pages, bool skip_hugetlb,
@@ -7179,7 +7210,7 @@ static bool zone_spans_last_pfn(const st
 }
 
 /**
- * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
+ * alloc_contig_frozen_pages() -- tries to find and allocate contiguous range of frozen pages
  * @nr_pages:	Number of contiguous pages to allocate
  * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
  *		action and reclaim modifiers are supported. Reclaim modifiers
@@ -7187,22 +7218,25 @@ static bool zone_spans_last_pfn(const st
  * @nid:	Target node
  * @nodemask:	Mask for other possible nodes
  *
- * This routine is a wrapper around alloc_contig_range(). It scans over zones
- * on an applicable zonelist to find a contiguous pfn range which can then be
- * tried for allocation with alloc_contig_range(). This routine is intended
- * for allocation requests which can not be fulfilled with the buddy allocator.
+ * This routine is a wrapper around alloc_contig_frozen_range(). It scans over
+ * zones on an applicable zonelist to find a contiguous pfn range which can then
+ * be tried for allocation with alloc_contig_frozen_range(). This routine is
+ * intended for allocation requests which can not be fulfilled with the buddy
+ * allocator.
  *
  * The allocated memory is always aligned to a page boundary. If nr_pages is a
  * power of two, then allocated range is also guaranteed to be aligned to same
  * nr_pages (e.g. 1GB request would be aligned to 1GB).
  *
- * Allocated pages can be freed with free_contig_range() or by manually calling
- * __free_page() on each allocated page.
+ * Allocated frozen pages need be freed with free_contig_frozen_range(),
+ * or by manually calling free_frozen_pages() on each allocated frozen
+ * non-compound page, for compound frozen pages could be freed with
+ * free_frozen_pages() directly.
  *
- * Return: pointer to contiguous pages on success, or NULL if not successful.
+ * Return: pointer to contiguous frozen pages on success, or NULL if not successful.
  */
-struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
-				 int nid, nodemask_t *nodemask)
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
 	struct zonelist *zonelist;
@@ -7224,13 +7258,15 @@ retry:
 						   &skipped_hugetlb)) {
 				/*
 				 * We release the zone lock here because
-				 * alloc_contig_range() will also lock the zone
-				 * at some point. If there's an allocation
-				 * spinning on this lock, it may win the race
-				 * and cause alloc_contig_range() to fail...
+				 * alloc_contig_frozen_range() will also lock
+				 * the zone at some point. If there's an
+				 * allocation spinning on this lock, it may
+				 * win the race and cause allocation to fail.
 				 */
 				spin_unlock_irqrestore(&zone->lock, flags);
-				ret = __alloc_contig_pages(pfn, nr_pages,
+				ret = alloc_contig_frozen_range_noprof(pfn,
+							pfn + nr_pages,
+							ACR_FLAGS_NONE,
 							gfp_mask);
 				if (!ret)
 					return pfn_to_page(pfn);
@@ -7253,30 +7289,80 @@ retry:
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(alloc_contig_frozen_pages_noprof);
 
-void free_contig_range(unsigned long pfn, unsigned long nr_pages)
+/**
+ * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
+ * @nr_pages:	Number of contiguous pages to allocate
+ * @gfp_mask:	GFP mask.
+ * @nid:	Target node
+ * @nodemask:	Mask for other possible nodes
+ *
+ * This routine is a wrapper around alloc_contig_frozen_pages(), it can't
+ * be used to allocate compound pages, the refcount of each allocated page
+ * will be set to one.
+ *
+ * Allocated pages can be freed with free_contig_range() or by manually
+ * calling __free_page() on each allocated page.
+ *
+ * Return: pointer to contiguous pages on success, or NULL if not successful.
+ */
+struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
+{
+	struct page *page;
+
+	if (WARN_ON(gfp_mask & __GFP_COMP))
+		return NULL;
+
+	page = alloc_contig_frozen_pages_noprof(nr_pages, gfp_mask, nid,
+						nodemask);
+	if (page)
+		set_pages_refcounted(page, nr_pages);
+
+	return page;
+}
+EXPORT_SYMBOL(alloc_contig_pages_noprof);
+
+/**
+ * free_contig_frozen_range() -- free the contiguous range of frozen pages
+ * @pfn:	start PFN to free
+ * @nr_pages:	Number of contiguous frozen pages to free
+ *
+ * This can be used to free the allocated compound/non-compound frozen pages.
+ */
+void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 {
-	unsigned long count = 0;
-	struct folio *folio = pfn_folio(pfn);
+	struct page *first_page = pfn_to_page(pfn);
+	const unsigned int order = ilog2(nr_pages);
 
-	if (folio_test_large(folio)) {
-		int expected = folio_nr_pages(folio);
+	if (WARN_ON_ONCE(first_page != compound_head(first_page)))
+		return;
 
-		if (nr_pages == expected)
-			folio_put(folio);
-		else
-			WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
-			     pfn, nr_pages, expected);
+	if (PageHead(first_page)) {
+		WARN_ON_ONCE(order != compound_order(first_page));
+		free_frozen_pages(first_page, order);
 		return;
 	}
 
-	for (; nr_pages--; pfn++) {
-		struct page *page = pfn_to_page(pfn);
+	__free_contig_frozen_range(pfn, nr_pages);
+}
+EXPORT_SYMBOL(free_contig_frozen_range);
 
-		count += page_count(page) != 1;
-		__free_page(page);
-	}
-	WARN(count != 0, "%lu pages are still in use!\n", count);
+/**
+ * free_contig_range() -- free the contiguous range of pages
+ * @pfn:	start PFN to free
+ * @nr_pages:	Number of contiguous pages to free
+ *
+ * This can be only used to free the allocated non-compound pages.
+ */
+void free_contig_range(unsigned long pfn, unsigned long nr_pages)
+{
+	if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
+		return;
+
+	for (; nr_pages--; pfn++)
+		__free_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL(free_contig_range);
 #endif /* CONFIG_CONTIG_ALLOC */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page.patch
mm-page_alloc-add-__split_page.patch
mm-cma-kill-cma_pages_valid.patch
mm-page_alloc-add-alloc_contig_frozen_rangepages.patch
mm-cma-add-cma_alloc_frozen_compound.patch
mm-hugetlb-allocate-frozen-pages-for-gigantic-allocation.patch

