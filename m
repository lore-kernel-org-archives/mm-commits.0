Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA3FC4361A
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD4E207A3
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgLCV6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgLCV6p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 16:58:45 -0500
Date:   Thu, 03 Dec 2020 13:58:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607032683;
        bh=iOJCA7QniRzZQbOJW9dQnhm0J2RZQrvgMB+3nhCAaLQ=;
        h=From:To:Subject:From;
        b=SxidTGDErvzDEuL1hIn59u7kxCbNzzzKs9K/yUh9FkslrCZYtAKpyv8hePqxmM51f
         tHrAmJtZjRYJ1XJGm/dl/3o4FsiflS2GK/cilKUVUbaNzDx8kGuc6gSUvU8yUIIAfo
         74/Oje+KU6trTwTj6pzEYwMODyX+CorU5F4UiKJI=
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [failures]
 mm-truncateshmem-handle-truncates-that-split-thps.patch removed from -mm
 tree
Message-ID: <20201203215801.icUowb-sf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate,shmem: handle truncates that split THPs
has been removed from the -mm tree.  Its filename was
     mm-truncateshmem-handle-truncates-that-split-thps.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/truncate,shmem: handle truncates that split THPs

Handle THP splitting in the parts of the truncation functions which
already handle partial pages.  Factor all that code out into a new
function called truncate_inode_partial_page().

We lose the easy 'bail out' path if a truncate or hole punch is entirely
within a single page.  We can add some more complex logic to restore the
optimisation if it proves to be worthwhile.

[willy@infradead.org: rewrite]
  Link: https://lkml.kernel.org/r/20201125023234.GH4327@casper.infradead.org
[akpm@linux-foundation.org: fix page unlocking, per Hugh]
  Link: https://lkml.kernel.org/r/CANsGZ6a95WK7+2H4Zyg5FwDxhdJQqR8nKND1Cn6r6e3QxWeW4Q@mail.gmail.com
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

 mm/internal.h |    2 
 mm/shmem.c    |  140 ++++++++++++++----------------------------
 mm/truncate.c |  157 +++++++++++++++++++++++-------------------------
 3 files changed, 125 insertions(+), 174 deletions(-)

--- a/mm/internal.h~mm-truncateshmem-handle-truncates-that-split-thps
+++ a/mm/internal.h
@@ -623,4 +623,6 @@ struct migration_target_control {
 	gfp_t gfp_mask;
 };
 
+pgoff_t truncate_inode_partial_page(struct address_space *mapping,
+		struct page *page, loff_t start, loff_t end);
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
@@ -892,26 +866,33 @@ static void shmem_undo_range(struct inod
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	pgoff_t start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	pgoff_t end = (lend + 1) >> PAGE_SHIFT;
-	unsigned int partial_start = lstart & (PAGE_SIZE - 1);
-	unsigned int partial_end = (lend + 1) & (PAGE_SIZE - 1);
+	pgoff_t start, end;
 	struct pagevec pvec;
 	pgoff_t indices[PAGEVEC_SIZE];
+	struct page *page;
 	long nr_swaps_freed = 0;
 	pgoff_t index;
 	int i;
 
-	if (lend == -1)
-		end = -1;	/* unsigned, so actually very big */
+	page = NULL;
+	start = lstart >> PAGE_SHIFT;
+	shmem_getpage(inode, start, &page, SGP_READ);
+	if (page) {
+		page = thp_head(page);
+		set_page_dirty(page);
+		start = truncate_inode_partial_page(mapping, page, lstart,
+							lend);
+	}
+
+	/* 'end' includes a partial page */
+	end = lend / PAGE_SIZE;
 
 	pagevec_init(&pvec);
 	index = start;
 	while (index < end && find_lock_entries(mapping, index, end - 1,
-			&pvec, indices)) {
+							&pvec, indices)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
-
+			page = pvec.pages[i];
 			index = indices[i];
 
 			if (xa_is_value(page)) {
@@ -921,8 +902,6 @@ static void shmem_undo_range(struct inod
 								index, page);
 				continue;
 			}
-			index += thp_nr_pages(page) - 1;
-
 			if (!unfalloc || !PageUptodate(page))
 				truncate_inode_page(mapping, page);
 			unlock_page(page);
@@ -933,90 +912,63 @@ static void shmem_undo_range(struct inod
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
-		}
-	}
-	if (partial_end) {
-		struct page *page = NULL;
-		shmem_getpage(inode, end, &page, SGP_READ);
-		if (page) {
-			zero_user_segment(page, 0, partial_end);
-			set_page_dirty(page);
-			unlock_page(page);
-			put_page(page);
-		}
-	}
-	if (start >= end)
-		return;
-
 	index = start;
-	while (index < end) {
+	while (index <= end) {
 		cond_resched();
 
-		if (!find_get_entries(mapping, index, end - 1, &pvec,
-				indices)) {
+		if (!find_get_entries(mapping, index, end, &pvec, indices)) {
 			/* If all gone or hole-punch or unfalloc, we're done */
-			if (index == start || end != -1)
+			if (index == start || lend != (loff_t)-1)
 				break;
 			/* But if truncating, restart to make sure all gone */
 			index = start;
 			continue;
 		}
+
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
+			page = pvec.pages[i];
 
-			index = indices[i];
 			if (xa_is_value(page)) {
 				if (unfalloc)
 					continue;
-				if (shmem_free_swap(mapping, index, page)) {
-					/* Swap was replaced by page: retry */
-					index--;
-					break;
+				index = indices[i];
+				if (index == end) {
+					/* Partial page swapped out? */
+					shmem_getpage(inode, end, &page,
+								SGP_READ);
+				} else {
+					if (shmem_free_swap(mapping, index,
+								page)) {
+						/* Swap replaced: retry */
+						break;
+					}
+					nr_swaps_freed++;
+					continue;
 				}
-				nr_swaps_freed++;
-				continue;
+			} else {
+				lock_page(page);
 			}
 
-			lock_page(page);
-
 			if (!unfalloc || !PageUptodate(page)) {
 				if (page_mapping(page) != mapping) {
 					/* Page was replaced by swap: retry */
 					unlock_page(page);
-					index--;
+					put_page(page);
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
+				index = truncate_inode_partial_page(mapping,
+						page, lstart, lend);
+				if (index > end)
+					end = indices[i] - 1;
+			} else {
+				unlock_page(page);
 			}
-			unlock_page(page);
 		}
+
+		index = indices[i - 1] + 1;
 		pagevec_remove_exceptionals(&pvec);
-		pagevec_release(&pvec);
-		index++;
+		pagevec_reinit(&pvec);
 	}
 
 	spin_lock_irq(&info->lock);
--- a/mm/truncate.c~mm-truncateshmem-handle-truncates-that-split-thps
+++ a/mm/truncate.c
@@ -225,6 +225,63 @@ int truncate_inode_page(struct address_s
 }
 
 /*
+ * Handle partial (transparent) pages.  If the page is entirely within
+ * the range, we discard it.  If not, we split the page if it's a THP
+ * and zero the part of the page that's within the [start, end] range.
+ * split_page_range() will discard any of the subpages which now lie
+ * beyond i_size, and the caller will discard pages which lie within a
+ * newly created hole.
+ *
+ * Return: The index after the current page.
+ */
+pgoff_t truncate_inode_partial_page(struct address_space *mapping,
+		struct page *page, loff_t start, loff_t end)
+{
+	loff_t pos = page_offset(page);
+	pgoff_t next_index = page->index + thp_nr_pages(page);
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
+	if (length == thp_size(page))
+		goto truncate;
+
+	cleancache_invalidate_page(page->mapping, page);
+	if (page_has_private(page))
+		do_invalidatepage(page, offset, length);
+	if (!PageTransHuge(page))
+		goto zero;
+	page += offset / PAGE_SIZE;
+	if (split_huge_page(page) < 0) {
+		page -= offset / PAGE_SIZE;
+		goto zero;
+	}
+	next_index = page->index + 1;
+	offset %= PAGE_SIZE;
+	if (offset == 0 && length >= PAGE_SIZE)
+		goto truncate;
+	length = PAGE_SIZE - offset;
+zero:
+	zero_user(page, offset, length);
+	goto out;
+truncate:
+	truncate_inode_page(mapping, page);
+out:
+	unlock_page(page);
+	put_page(page);
+	return next_index;
+}
+
+/*
  * Used to get rid of pages on hardware memory corruption.
  */
 int generic_error_remove_page(struct address_space *mapping, struct page *page)
@@ -275,10 +332,6 @@ int invalidate_inode_page(struct page *p
  * The first pass will remove most pages, so the search cost of the second pass
  * is low.
  *
- * We pass down the cache-hot hint to the page freeing code.  Even if the
- * mapping is large, it is probably the case that the final pages are the most
- * recently touched, and freeing happens in ascending file offset order.
- *
  * Note that since ->invalidatepage() accepts range to invalidate
  * truncate_inode_pages_range is able to handle cases where lend + 1 is not
  * page aligned properly.
@@ -286,38 +339,24 @@ int invalidate_inode_page(struct page *p
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, loff_t lend)
 {
-	pgoff_t		start;		/* inclusive */
-	pgoff_t		end;		/* exclusive */
-	unsigned int	partial_start;	/* inclusive */
-	unsigned int	partial_end;	/* exclusive */
+	pgoff_t start, end;
 	struct pagevec	pvec;
 	pgoff_t		indices[PAGEVEC_SIZE];
 	pgoff_t		index;
 	int		i;
+	struct page *	page;
 
 	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
 		goto out;
 
-	/* Offsets within partial pages */
-	partial_start = lstart & (PAGE_SIZE - 1);
-	partial_end = (lend + 1) & (PAGE_SIZE - 1);
+	start = lstart >> PAGE_SHIFT;
+	page = find_lock_head(mapping, start);
+	if (page)
+		start = truncate_inode_partial_page(mapping, page, lstart,
+							lend);
 
-	/*
-	 * 'start' and 'end' always covers the range of pages to be fully
-	 * truncated. Partial pages are covered with 'partial_start' at the
-	 * start of the range and 'partial_end' at the end of the range.
-	 * Note that 'end' is exclusive while 'lend' is inclusive.
-	 */
-	start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (lend == -1)
-		/*
-		 * lend == -1 indicates end-of-file so we have to set 'end'
-		 * to the highest possible pgoff_t and since the type is
-		 * unsigned we're using -1.
-		 */
-		end = -1;
-	else
-		end = (lend + 1) >> PAGE_SHIFT;
+	/* 'end' includes a partial page */
+	end = lend / PAGE_SIZE;
 
 	pagevec_init(&pvec);
 	index = start;
@@ -334,50 +373,11 @@ void truncate_inode_pages_range(struct a
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
-		}
-	}
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
-	}
-	/*
-	 * If the truncation happened within a single page no pages
-	 * will be released, just zeroed, so we can bail out now.
-	 */
-	if (start >= end)
-		goto out;
-
 	index = start;
-	for ( ; ; ) {
+	while (index <= end) {
 		cond_resched();
-		if (!find_get_entries(mapping, index, end - 1, &pvec,
-				indices)) {
+
+		if (!find_get_entries(mapping, index, end, &pvec, indices)) {
 			/* If all gone from start onwards, we're done */
 			if (index == start)
 				break;
@@ -387,23 +387,20 @@ void truncate_inode_pages_range(struct a
 		}
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
-
-			/* We rely upon deletion not changing page->index */
-			index = indices[i];
-
+			page = pvec.pages[i];
 			if (xa_is_value(page))
 				continue;
 
 			lock_page(page);
-			WARN_ON(page_to_index(page) != index);
-			wait_on_page_writeback(page);
-			truncate_inode_page(mapping, page);
-			unlock_page(page);
+			index = truncate_inode_partial_page(mapping, page,
+							lstart, lend);
+			/* Couldn't split a THP? */
+			if (index > end)
+				end = indices[i] - 1;
 		}
+		index = indices[i - 1] + 1;
 		truncate_exceptional_pvec_entries(mapping, &pvec, indices);
-		pagevec_release(&pvec);
-		index++;
+		pagevec_reinit(&pvec);
 	}
 
 out:
_

Patches currently in -mm which might be from willy@infradead.org are

sparc-fix-handling-of-page-table-constructor-failure.patch
mm-move-free_unref_page-to-mm-internalh.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-support-thps-in-zero_user_segments.patch
mm-support-thps-in-zero_user_segments-fix.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch

