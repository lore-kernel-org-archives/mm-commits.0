Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31843C63697
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B1C22277
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8gYxf7C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgKNBp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKNBp5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:57 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E90832225F;
        Sat, 14 Nov 2020 01:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318356;
        bh=HsRBM92qYnE58OK0YP+06ahPwA6GY0piZZwtMN/79TQ=;
        h=Date:From:To:Subject:From;
        b=G8gYxf7Cn9CQ8Q4Q71zIvUcK8w/ETYGlQCsh1C/dRUsGnIvrQjF4JqePnw7FyYMyS
         vQN++CEoI5KKm8GaPivlZ7F56fPeGm6PRpNb4C9WeEeBc+EfNFcMM21dO/4LPcBSF1
         n4CpFTq5IPYTz2cbAxuqG6F8BaDHnKCk4c+PrOmQ=
Date:   Fri, 13 Nov 2020 17:45:55 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  + mm-truncateshmem-handle-truncates-that-split-thps.patch
 added to -mm tree
Message-ID: <20201114014555.zmU8SP6fz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate,shmem: handle truncates that split THPs
has been added to the -mm tree.  Its filename is
     mm-truncateshmem-handle-truncates-that-split-thps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-truncateshmem-handle-truncates-that-split-thps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-truncateshmem-handle-truncates-that-split-thps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/truncate,shmem: handle truncates that split THPs

Handle THP splitting in the parts of the truncation functions which
already handle partial pages.  Factor all that code out into a new
function called truncate_inode_partial_page().

We lose the easy 'bail out' path if a truncate or hole punch is entirely
within a single page.  We can add some more complex logic to restore the
optimisation if it proves to be worthwhile.

Link: https://lkml.kernel.org/r/20201112212641.27837-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 
 mm/shmem.c    |   97 +++++++++++++--------------------------
 mm/truncate.c |  118 ++++++++++++++++++++++++++++++------------------
 3 files changed, 108 insertions(+), 108 deletions(-)

--- a/mm/internal.h~mm-truncateshmem-handle-truncates-that-split-thps
+++ a/mm/internal.h
@@ -620,4 +620,5 @@ struct migration_target_control {
 	gfp_t gfp_mask;
 };
 
+bool truncate_inode_partial_page(struct page *page, loff_t start, loff_t end);
 #endif	/* __MM_INTERNAL_H */
--- a/mm/shmem.c~mm-truncateshmem-handle-truncates-that-split-thps
+++ a/mm/shmem.c
@@ -858,32 +858,6 @@ void shmem_unlock_mapping(struct address
 }
 
 /*
- * Check whether a hole-punch or truncation needs to split a huge page,
- * returning true if no split was required, or the split has been successful.
- *
- * Eviction (or truncation to 0 size) should never need to split a huge page;
- * but in rare cases might do so, if shmem_undo_range() failed to trylock on
- * head, and then succeeded to trylock on tail.
- *
- * A split can only succeed when there are no additional references on the
- * huge page: so the split below relies upon find_get_entries() having stopped
- * when it found a subpage of the huge page, without getting further references.
- */
-static bool shmem_punch_compound(struct page *page, pgoff_t start, pgoff_t end)
-{
-	if (!PageTransCompound(page))
-		return true;
-
-	/* Just proceed to delete a huge page wholly within the range punched */
-	if (PageHead(page) &&
-	    page->index >= start && page->index + HPAGE_PMD_NR <= end)
-		return true;
-
-	/* Try to split huge page, so we can truly punch the hole or truncate */
-	return split_huge_page(page) >= 0;
-}
-
-/*
  * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
  */
@@ -894,13 +868,13 @@ static void shmem_undo_range(struct inod
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	pgoff_t end = (lend + 1) >> PAGE_SHIFT;
-	unsigned int partial_start = lstart & (PAGE_SIZE - 1);
-	unsigned int partial_end = (lend + 1) & (PAGE_SIZE - 1);
 	struct pagevec pvec;
 	pgoff_t indices[PAGEVEC_SIZE];
+	struct page *page;
 	long nr_swaps_freed = 0;
 	pgoff_t index;
 	int i;
+	bool partial_end;
 
 	if (lend == -1)
 		end = -1;	/* unsigned, so actually very big */
@@ -910,7 +884,7 @@ static void shmem_undo_range(struct inod
 	while (index < end && find_lock_entries(mapping, index, end - 1,
 			&pvec, indices)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
+			page = pvec.pages[i];
 
 			index = indices[i];
 
@@ -933,33 +907,37 @@ static void shmem_undo_range(struct inod
 		index++;
 	}
 
-	if (partial_start) {
-		struct page *page = NULL;
-		shmem_getpage(inode, start - 1, &page, SGP_READ);
-		if (page) {
-			unsigned int top = PAGE_SIZE;
-			if (start > end) {
-				top = partial_end;
-				partial_end = 0;
-			}
-			zero_user_segment(page, partial_start, top);
-			set_page_dirty(page);
-			unlock_page(page);
-			put_page(page);
+	partial_end = ((lend + 1) % PAGE_SIZE) > 0;
+	page = NULL;
+	shmem_getpage(inode, lstart >> PAGE_SHIFT, &page, SGP_READ);
+	if (page) {
+		bool same_page;
+
+		page = thp_head(page);
+		same_page = lend < page_offset(page) + thp_size(page);
+		if (same_page)
+			partial_end = false;
+		set_page_dirty(page);
+		if (!truncate_inode_partial_page(page, lstart, lend)) {
+			start = page->index + thp_nr_pages(page);
+			if (same_page)
+				end = page->index;
 		}
+		unlock_page(page);
+		put_page(page);
+		page = NULL;
 	}
-	if (partial_end) {
-		struct page *page = NULL;
+
+	if (partial_end)
 		shmem_getpage(inode, end, &page, SGP_READ);
-		if (page) {
-			zero_user_segment(page, 0, partial_end);
-			set_page_dirty(page);
-			unlock_page(page);
-			put_page(page);
-		}
+	if (page) {
+		page = thp_head(page);
+		set_page_dirty(page);
+		if (!truncate_inode_partial_page(page, lstart, lend))
+			end = page->index;
+		unlock_page(page);
+		put_page(page);
 	}
-	if (start >= end)
-		return;
 
 	index = start;
 	while (index < end) {
@@ -975,7 +953,7 @@ static void shmem_undo_range(struct inod
 			continue;
 		}
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
+			page = pvec.pages[i];
 
 			index = indices[i];
 			if (xa_is_value(page)) {
@@ -1000,18 +978,9 @@ static void shmem_undo_range(struct inod
 					break;
 				}
 				VM_BUG_ON_PAGE(PageWriteback(page), page);
-				if (shmem_punch_compound(page, start, end))
-					truncate_inode_page(mapping, page);
-				else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-					/* Wipe the page and don't get stuck */
-					clear_highpage(page);
-					flush_dcache_page(page);
-					set_page_dirty(page);
-					if (index <
-					    round_up(start, HPAGE_PMD_NR))
-						start = index + 1;
-				}
+				truncate_inode_page(mapping, page);
 			}
+			index = page->index + thp_nr_pages(page) - 1;
 			unlock_page(page);
 		}
 		pagevec_remove_exceptionals(&pvec);
--- a/mm/truncate.c~mm-truncateshmem-handle-truncates-that-split-thps
+++ a/mm/truncate.c
@@ -225,6 +225,53 @@ int truncate_inode_page(struct address_s
 }
 
 /*
+ * Handle partial (transparent) pages.  The page may be entirely within the
+ * range if a split has raced with us.  If not, we zero the part of the
+ * page that's within the [start, end] range, and then split the page if
+ * it's a THP.  split_page_range() will discard pages which now lie beyond
+ * i_size, and we rely on the caller to discard pages which lie within a
+ * newly created hole.
+ *
+ * Returns false if THP splitting failed so the caller can avoid
+ * discarding the entire page which is stubbornly unsplit.
+ */
+bool truncate_inode_partial_page(struct page *page, loff_t start, loff_t end)
+{
+	loff_t pos = page_offset(page);
+	unsigned int offset, length;
+
+	if (pos < start)
+		offset = start - pos;
+	else
+		offset = 0;
+	length = thp_size(page);
+	if (pos + length <= (u64)end)
+		length = length - offset;
+	else
+		length = end + 1 - pos - offset;
+
+	wait_on_page_writeback(page);
+	if (length == thp_size(page)) {
+		truncate_inode_page(page->mapping, page);
+		return true;
+	}
+
+	/*
+	 * We may be zeroing pages we're about to discard, but it avoids
+	 * doing a complex calculation here, and then doing the zeroing
+	 * anyway if the page split fails.
+	 */
+	zero_user(page, offset, length);
+
+	cleancache_invalidate_page(page->mapping, page);
+	if (page_has_private(page))
+		do_invalidatepage(page, offset, length);
+	if (!PageTransHuge(page))
+		return true;
+	return split_huge_page(page) == 0;
+}
+
+/*
  * Used to get rid of pages on hardware memory corruption.
  */
 int generic_error_remove_page(struct address_space *mapping, struct page *page)
@@ -288,20 +335,16 @@ void truncate_inode_pages_range(struct a
 {
 	pgoff_t		start;		/* inclusive */
 	pgoff_t		end;		/* exclusive */
-	unsigned int	partial_start;	/* inclusive */
-	unsigned int	partial_end;	/* exclusive */
 	struct pagevec	pvec;
 	pgoff_t		indices[PAGEVEC_SIZE];
 	pgoff_t		index;
 	int		i;
+	struct page *	page;
+	bool partial_end;
 
 	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
 		goto out;
 
-	/* Offsets within partial pages */
-	partial_start = lstart & (PAGE_SIZE - 1);
-	partial_end = (lend + 1) & (PAGE_SIZE - 1);
-
 	/*
 	 * 'start' and 'end' always covers the range of pages to be fully
 	 * truncated. Partial pages are covered with 'partial_start' at the
@@ -334,48 +377,35 @@ void truncate_inode_pages_range(struct a
 		cond_resched();
 	}
 
-	if (partial_start) {
-		struct page *page = find_lock_page(mapping, start - 1);
-		if (page) {
-			unsigned int top = PAGE_SIZE;
-			if (start > end) {
-				/* Truncation within a single page */
-				top = partial_end;
-				partial_end = 0;
-			}
-			wait_on_page_writeback(page);
-			zero_user_segment(page, partial_start, top);
-			cleancache_invalidate_page(mapping, page);
-			if (page_has_private(page))
-				do_invalidatepage(page, partial_start,
-						  top - partial_start);
-			unlock_page(page);
-			put_page(page);
+	partial_end = ((lend + 1) % PAGE_SIZE) > 0;
+	page = find_lock_head(mapping, lstart >> PAGE_SHIFT);
+	if (page) {
+		bool same_page = lend < page_offset(page) + thp_size(page);
+		if (same_page)
+			partial_end = false;
+		if (!truncate_inode_partial_page(page, lstart, lend)) {
+			start = page->index + thp_nr_pages(page);
+			if (same_page)
+				end = page->index;
 		}
+		unlock_page(page);
+		put_page(page);
+		page = NULL;
 	}
-	if (partial_end) {
-		struct page *page = find_lock_page(mapping, end);
-		if (page) {
-			wait_on_page_writeback(page);
-			zero_user_segment(page, 0, partial_end);
-			cleancache_invalidate_page(mapping, page);
-			if (page_has_private(page))
-				do_invalidatepage(page, 0,
-						  partial_end);
-			unlock_page(page);
-			put_page(page);
-		}
+
+	if (partial_end)
+		page = find_lock_head(mapping, end);
+	if (page) {
+		if (!truncate_inode_partial_page(page, lstart, lend))
+			end = page->index;
+		unlock_page(page);
+		put_page(page);
 	}
-	/*
-	 * If the truncation happened within a single page no pages
-	 * will be released, just zeroed, so we can bail out now.
-	 */
-	if (start >= end)
-		goto out;
 
 	index = start;
-	for ( ; ; ) {
+	while (index < end) {
 		cond_resched();
+
 		if (!find_get_entries(mapping, index, end - 1, &pvec,
 				indices)) {
 			/* If all gone from start onwards, we're done */
@@ -387,7 +417,7 @@ void truncate_inode_pages_range(struct a
 		}
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
+			page = pvec.pages[i];
 
 			/* We rely upon deletion not changing page->index */
 			index = indices[i];
@@ -396,7 +426,7 @@ void truncate_inode_pages_range(struct a
 				continue;
 
 			lock_page(page);
-			WARN_ON(page_to_index(page) != index);
+			index = page->index + thp_nr_pages(page) - 1;
 			wait_on_page_writeback(page);
 			truncate_inode_page(mapping, page);
 			unlock_page(page);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-mapping_seek_hole_data.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

