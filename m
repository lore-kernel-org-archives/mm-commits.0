Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A4710FA
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 00:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723596032; cv=none; b=Nwq45FPAVESwJjTcRxNXLkixfSQkLQyCt5xD3f9Xa+3xArnxxCWkq8QxPqMzFWVeKwdvXg6uEzNXTpaSXpxepbDLhgSXAMTR9RCR45K2Qe9jB588qgiQZtowORIHIH2FPAM5h4fN7wqh1qMM5CreghTkIZnrqYl6xDO6/iVh0qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723596032; c=relaxed/simple;
	bh=VHceWJlT/JevPxJMi985/zVhSDw2RAy8CLQHc2GzwAo=;
	h=Date:To:From:Subject:Message-Id; b=ghTMS6CZVGv0mRJzS2LRN0Zpu59WXQ0WM69NNa2uSypVyIZ/wqSEmAJjOwKDrYT/+B78XWTmqDwheZUxrG1+MrvAQNMx5LWsNCtw9pYoYkrl5NwutrDFsfKBzziGm6gALBD+Sn1tI8Uj0gQfeQylxUqqo1t5ouVx8ixEiEWMj3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sd1SfCy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sd1SfCy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5443C32782;
	Wed, 14 Aug 2024 00:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723596031;
	bh=VHceWJlT/JevPxJMi985/zVhSDw2RAy8CLQHc2GzwAo=;
	h=Date:To:From:Subject:From;
	b=Sd1SfCy8+EjW/Mr9ORnO2QengNsqBmna3W2iPvK242ZCTUOUlc2NxAoBrnz2zuE8f
	 2sgjhlko7nwec4pEjtREs0CaI3uP5iV0PGjgkuTLGd63+P2V32T3JeDYWVjFOu4s3h
	 n9XpoFrjb3b54aAdi1+8iOQ7zhpqUXngPBFWlKoY=
Date: Tue, 13 Aug 2024 17:40:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,muchun.song@linux.dev,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-contig_alloc-support-__gfp_comp.patch added to mm-unstable branch
Message-Id: <20240814004031.D5443C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/contig_alloc: support __GFP_COMP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-contig_alloc-support-__gfp_comp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-contig_alloc-support-__gfp_comp.patch

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
Subject: mm/contig_alloc: support __GFP_COMP
Date: Sun, 11 Aug 2024 15:21:27 -0600

Use __GFP_COMP for gigantic folios can greatly reduce not only the
complexity in the code but also the allocation and free time.

Approximate LOC to mm/hugetlb.c: -200, +50

Allocate and free 500 1GB hugeTLB memory without HVO by:
  time echo 500 >/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
  time echo 0 >/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

       Before  After
Alloc  ~13s    ~10s
Free   ~15s    <1s

The above magnitude generally holds for multiple x86 and arm64 CPU
models.


This patch (of 2):

Support __GFP_COMP in alloc_contig_range().  When the flag is set, upon
success the function returns a large folio prepared by prep_new_page(),
rather than a range of order-0 pages prepared by split_free_pages() (which
is renamed from split_map_pages()).

alloc_contig_range() can return folios larger than MAX_PAGE_ORDER, e.g.,
gigantic hugeTLB folios.  As a result, on the free path free_one_page()
needs to handle this case by split_large_buddy(), in addition to
free_contig_range() properly handling large folios by folio_put().

Link: https://lkml.kernel.org/r/20240811212129.3074314-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/20240811212129.3074314-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   48 ++-----------------
 mm/internal.h   |    9 +++
 mm/page_alloc.c |  111 +++++++++++++++++++++++++++++++++-------------
 3 files changed, 94 insertions(+), 74 deletions(-)

--- a/mm/compaction.c~mm-contig_alloc-support-__gfp_comp
+++ a/mm/compaction.c
@@ -79,40 +79,6 @@ static inline bool is_via_compact_memory
 #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #endif
 
-static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
-{
-	post_alloc_hook(page, order, __GFP_MOVABLE);
-	return page;
-}
-#define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
-
-static void split_map_pages(struct list_head *freepages)
-{
-	unsigned int i, order;
-	struct page *page, *next;
-	LIST_HEAD(tmp_list);
-
-	for (order = 0; order < NR_PAGE_ORDERS; order++) {
-		list_for_each_entry_safe(page, next, &freepages[order], lru) {
-			unsigned int nr_pages;
-
-			list_del(&page->lru);
-
-			nr_pages = 1 << order;
-
-			mark_allocated(page, order, __GFP_MOVABLE);
-			if (order)
-				split_page(page, order);
-
-			for (i = 0; i < nr_pages; i++) {
-				list_add(&page->lru, &tmp_list);
-				page++;
-			}
-		}
-		list_splice_init(&tmp_list, &freepages[0]);
-	}
-}
-
 static unsigned long release_free_list(struct list_head *freepages)
 {
 	int order;
@@ -742,11 +708,11 @@ isolate_fail:
  *
  * Non-free pages, invalid PFNs, or zone boundaries within the
  * [start_pfn, end_pfn) range are considered errors, cause function to
- * undo its actions and return zero.
+ * undo its actions and return zero. cc->freepages[] are empty.
  *
  * Otherwise, function returns one-past-the-last PFN of isolated page
  * (which may be greater then end_pfn if end fell in a middle of
- * a free page).
+ * a free page). cc->freepages[] contain free pages isolated.
  */
 unsigned long
 isolate_freepages_range(struct compact_control *cc,
@@ -754,10 +720,9 @@ isolate_freepages_range(struct compact_c
 {
 	unsigned long isolated, pfn, block_start_pfn, block_end_pfn;
 	int order;
-	struct list_head tmp_freepages[NR_PAGE_ORDERS];
 
 	for (order = 0; order < NR_PAGE_ORDERS; order++)
-		INIT_LIST_HEAD(&tmp_freepages[order]);
+		INIT_LIST_HEAD(&cc->freepages[order]);
 
 	pfn = start_pfn;
 	block_start_pfn = pageblock_start_pfn(pfn);
@@ -788,7 +753,7 @@ isolate_freepages_range(struct compact_c
 			break;
 
 		isolated = isolate_freepages_block(cc, &isolate_start_pfn,
-					block_end_pfn, tmp_freepages, 0, true);
+					block_end_pfn, cc->freepages, 0, true);
 
 		/*
 		 * In strict mode, isolate_freepages_block() returns 0 if
@@ -807,13 +772,10 @@ isolate_freepages_range(struct compact_c
 
 	if (pfn < end_pfn) {
 		/* Loop terminated early, cleanup. */
-		release_free_list(tmp_freepages);
+		release_free_list(cc->freepages);
 		return 0;
 	}
 
-	/* __isolate_free_page() does not map the pages */
-	split_map_pages(tmp_freepages);
-
 	/* We don't use freelists for anything. */
 	return pfn;
 }
--- a/mm/internal.h~mm-contig_alloc-support-__gfp_comp
+++ a/mm/internal.h
@@ -681,6 +681,15 @@ extern void prep_compound_page(struct pa
 
 extern void post_alloc_hook(struct page *page, unsigned int order,
 					gfp_t gfp_flags);
+
+static inline struct page *post_alloc_hook_noprof(struct page *page, unsigned int order,
+						  gfp_t gfp_flags)
+{
+	post_alloc_hook(page, order, __GFP_MOVABLE);
+	return page;
+}
+#define mark_allocated(...) alloc_hooks(post_alloc_hook_noprof(__VA_ARGS__))
+
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
--- a/mm/page_alloc.c~mm-contig_alloc-support-__gfp_comp
+++ a/mm/page_alloc.c
@@ -1197,16 +1197,36 @@ static void free_pcppages_bulk(struct zo
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
+/* Split a multi-block free page into its individual pageblocks */
+static void split_large_buddy(struct zone *zone, struct page *page,
+			      unsigned long pfn, int order, fpi_t fpi)
+{
+	unsigned long end = pfn + (1 << order);
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
+	/* Caller removed page from freelist, buddy info cleared! */
+	VM_WARN_ON_ONCE(PageBuddy(page));
+
+	if (order > pageblock_order)
+		order = pageblock_order;
+
+	while (pfn != end) {
+		int mt = get_pfnblock_migratetype(page, pfn);
+
+		__free_one_page(page, pfn, zone, order, mt, fpi);
+		pfn += 1 << order;
+		page = pfn_to_page(pfn);
+	}
+}
+
 static void free_one_page(struct zone *zone, struct page *page,
 			  unsigned long pfn, unsigned int order,
 			  fpi_t fpi_flags)
 {
 	unsigned long flags;
-	int migratetype;
 
 	spin_lock_irqsave(&zone->lock, flags);
-	migratetype = get_pfnblock_migratetype(page, pfn);
-	__free_one_page(page, pfn, zone, order, migratetype, fpi_flags);
+	split_large_buddy(zone, page, pfn, order, fpi_flags);
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
@@ -1698,27 +1718,6 @@ static unsigned long find_large_buddy(un
 	return start_pfn;
 }
 
-/* Split a multi-block free page into its individual pageblocks */
-static void split_large_buddy(struct zone *zone, struct page *page,
-			      unsigned long pfn, int order)
-{
-	unsigned long end_pfn = pfn + (1 << order);
-
-	VM_WARN_ON_ONCE(order <= pageblock_order);
-	VM_WARN_ON_ONCE(pfn & (pageblock_nr_pages - 1));
-
-	/* Caller removed page from freelist, buddy info cleared! */
-	VM_WARN_ON_ONCE(PageBuddy(page));
-
-	while (pfn != end_pfn) {
-		int mt = get_pfnblock_migratetype(page, pfn);
-
-		__free_one_page(page, pfn, zone, pageblock_order, mt, FPI_NONE);
-		pfn += pageblock_nr_pages;
-		page = pfn_to_page(pfn);
-	}
-}
-
 /**
  * move_freepages_block_isolate - move free pages in block for page isolation
  * @zone: the zone
@@ -1759,7 +1758,7 @@ bool move_freepages_block_isolate(struct
 		del_page_from_free_list(buddy, zone, order,
 					get_pfnblock_migratetype(buddy, pfn));
 		set_pageblock_migratetype(page, migratetype);
-		split_large_buddy(zone, buddy, pfn, order);
+		split_large_buddy(zone, buddy, pfn, order, FPI_NONE);
 		return true;
 	}
 
@@ -1770,7 +1769,7 @@ bool move_freepages_block_isolate(struct
 		del_page_from_free_list(page, zone, order,
 					get_pfnblock_migratetype(page, pfn));
 		set_pageblock_migratetype(page, migratetype);
-		split_large_buddy(zone, page, pfn, order);
+		split_large_buddy(zone, page, pfn, order, FPI_NONE);
 		return true;
 	}
 move:
@@ -6440,6 +6439,31 @@ int __alloc_contig_migrate_range(struct
 	return (ret < 0) ? ret : 0;
 }
 
+static void split_free_pages(struct list_head *list)
+{
+	int order;
+
+	for (order = 0; order < NR_PAGE_ORDERS; order++) {
+		struct page *page, *next;
+		int nr_pages = 1 << order;
+
+		list_for_each_entry_safe(page, next, &list[order], lru) {
+			int i;
+
+			mark_allocated(page, order, __GFP_MOVABLE);
+			if (!order)
+				continue;
+
+			split_page(page, order);
+
+			/* add all subpages to the order-0 head, in sequence */
+			list_del(&page->lru);
+			for (i = 0; i < nr_pages; i++)
+				list_add_tail(&page[i].lru, &list[0]);
+		}
+	}
+}
+
 /**
  * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
@@ -6552,12 +6576,25 @@ int alloc_contig_range_noprof(unsigned l
 		goto done;
 	}
 
-	/* Free head and tail (if any) */
-	if (start != outer_start)
-		free_contig_range(outer_start, start - outer_start);
-	if (end != outer_end)
-		free_contig_range(end, outer_end - end);
+	if (!(gfp_mask & __GFP_COMP)) {
+		split_free_pages(cc.freepages);
 
+		/* Free head and tail (if any) */
+		if (start != outer_start)
+			free_contig_range(outer_start, start - outer_start);
+		if (end != outer_end)
+			free_contig_range(end, outer_end - end);
+	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
+		struct page *head = pfn_to_page(start);
+		int order = ilog2(end - start);
+
+		check_new_pages(head, order);
+		prep_new_page(head, order, gfp_mask, 0);
+	} else {
+		ret = -EINVAL;
+		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
+		     start, end, outer_start, outer_end);
+	}
 done:
 	undo_isolate_page_range(start, end, migratetype);
 	return ret;
@@ -6666,6 +6703,18 @@ struct page *alloc_contig_pages_noprof(u
 void free_contig_range(unsigned long pfn, unsigned long nr_pages)
 {
 	unsigned long count = 0;
+	struct folio *folio = pfn_folio(pfn);
+
+	if (folio_test_large(folio)) {
+		int expected = folio_nr_pages(folio);
+
+		if (nr_pages == expected)
+			folio_put(folio);
+		else
+			WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
+			     pfn, nr_pages, expected);
+		return;
+	}
 
 	for (; nr_pages--; pfn++) {
 		struct page *page = pfn_to_page(pfn);
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

