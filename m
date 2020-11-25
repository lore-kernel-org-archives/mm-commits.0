Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16363C56201
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91F8F207BC
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 23:07:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hk4WKfVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgKYXHC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:07:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbgKYXHB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 18:07:01 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0402D206F7;
        Wed, 25 Nov 2020 23:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606345620;
        bh=swebKoU5HcX/t2QWVP4QWl9XYyOjTRhHAah0S5lqSgo=;
        h=Date:From:To:Subject:From;
        b=Hk4WKfVf3qE40BBgHhZCyPKvpd3euzV+s4riMOdIs8iOG1VLJ+KYoy8ReZIH355Br
         nn5un7UMUPMsQ0Qo+yDXUcNouazbXr+W/WJKXMUwG5106Y0RXGaoQvzGuzWCZRkrWa
         2NMeQIIxffHFu3mDb9AR/FbRT/HMcNqxK0mAjuq4=
Date:   Wed, 25 Nov 2020 15:06:59 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 mm-truncateshmem-handle-truncates-that-split-thps-fix.patch added to -mm
 tree
Message-ID: <20201125230659.hBiV6HG_z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-truncateshmem-handle-truncates-that-split-thps-fix
has been added to the -mm tree.  Its filename is
     mm-truncateshmem-handle-truncates-that-split-thps-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-truncateshmem-handle-truncates-that-split-thps-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-truncateshmem-handle-truncates-that-split-thps-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-truncateshmem-handle-truncates-that-split-thps-fix

Link: https://lkml.kernel.org/r/20201125023234.GH4327@casper.infradead.org
Cc: Jan Kara <jack@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 -
 mm/shmem.c    |  100 ++++++++++++++----------------------
 mm/truncate.c |  131 +++++++++++++++++-------------------------------
 3 files changed, 91 insertions(+), 143 deletions(-)

--- a/mm/internal.h~mm-truncateshmem-handle-truncates-that-split-thps-fix
+++ a/mm/internal.h
@@ -623,5 +623,6 @@ struct migration_target_control {
 	gfp_t gfp_mask;
 };
 
-bool truncate_inode_partial_page(struct page *page, loff_t start, loff_t end);
+pgoff_t truncate_inode_partial_page(struct address_space *mapping,
+		struct page *page, loff_t start, loff_t end);
 #endif	/* __MM_INTERNAL_H */
--- a/mm/shmem.c~mm-truncateshmem-handle-truncates-that-split-thps-fix
+++ a/mm/shmem.c
@@ -866,26 +866,33 @@ static void shmem_undo_range(struct inod
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	pgoff_t start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	pgoff_t end = (lend + 1) >> PAGE_SHIFT;
+	pgoff_t start, end;
 	struct pagevec pvec;
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct page *page;
 	long nr_swaps_freed = 0;
 	pgoff_t index;
 	int i;
-	bool partial_end;
 
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
 			page = pvec.pages[i];
-
 			index = indices[i];
 
 			if (xa_is_value(page)) {
@@ -895,8 +902,6 @@ static void shmem_undo_range(struct inod
 								index, page);
 				continue;
 			}
-			index += thp_nr_pages(page) - 1;
-
 			if (!unfalloc || !PageUptodate(page))
 				truncate_inode_page(mapping, page);
 			unlock_page(page);
@@ -907,85 +912,60 @@ static void shmem_undo_range(struct inod
 		index++;
 	}
 
-	partial_end = ((lend + 1) % PAGE_SIZE) > 0;
-	page = NULL;
-	shmem_getpage(inode, lstart >> PAGE_SHIFT, &page, SGP_READ);
-	if (page) {
-		bool same_page;
-
-		page = thp_head(page);
-		same_page = lend < page_offset(page) + thp_size(page);
-		if (same_page)
-			partial_end = false;
-		set_page_dirty(page);
-		if (!truncate_inode_partial_page(page, lstart, lend)) {
-			start = page->index + thp_nr_pages(page);
-			if (same_page)
-				end = page->index;
-		}
-		unlock_page(page);
-		put_page(page);
-		page = NULL;
-	}
-
-	if (partial_end)
-		shmem_getpage(inode, end, &page, SGP_READ);
-	if (page) {
-		page = thp_head(page);
-		set_page_dirty(page);
-		if (!truncate_inode_partial_page(page, lstart, lend))
-			end = page->index;
-		unlock_page(page);
-		put_page(page);
-	}
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
 			page = pvec.pages[i];
 
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
-				truncate_inode_page(mapping, page);
+				index = truncate_inode_partial_page(mapping,
+						page, lstart, lend);
+				if (index > end)
+					end = indices[i] - 1;
 			}
-			index = page->index + thp_nr_pages(page) - 1;
-			unlock_page(page);
 		}
+		index = indices[i - 1] + 1;
 		pagevec_remove_exceptionals(&pvec);
-		pagevec_release(&pvec);
-		index++;
+		pagevec_reinit(&pvec);
 	}
 
 	spin_lock_irq(&info->lock);
--- a/mm/truncate.c~mm-truncateshmem-handle-truncates-that-split-thps-fix
+++ a/mm/truncate.c
@@ -225,19 +225,20 @@ int truncate_inode_page(struct address_s
 }
 
 /*
- * Handle partial (transparent) pages.  The page may be entirely within the
- * range if a split has raced with us.  If not, we zero the part of the
- * page that's within the [start, end] range, and then split the page if
- * it's a THP.  split_page_range() will discard pages which now lie beyond
- * i_size, and we rely on the caller to discard pages which lie within a
+ * Handle partial (transparent) pages.  If the page is entirely within
+ * the range, we discard it.  If not, we split the page if it's a THP
+ * and zero the part of the page that's within the [start, end] range.
+ * split_page_range() will discard any of the subpages which now lie
+ * beyond i_size, and the caller will discard pages which lie within a
  * newly created hole.
  *
- * Returns false if THP splitting failed so the caller can avoid
- * discarding the entire page which is stubbornly unsplit.
+ * Return: The index after the current page.
  */
-bool truncate_inode_partial_page(struct page *page, loff_t start, loff_t end)
+pgoff_t truncate_inode_partial_page(struct address_space *mapping,
+		struct page *page, loff_t start, loff_t end)
 {
 	loff_t pos = page_offset(page);
+	pgoff_t next_index = page->index + thp_nr_pages(page);
 	unsigned int offset, length;
 
 	if (pos < start)
@@ -251,24 +252,33 @@ bool truncate_inode_partial_page(struct
 		length = end + 1 - pos - offset;
 
 	wait_on_page_writeback(page);
-	if (length == thp_size(page)) {
-		truncate_inode_page(page->mapping, page);
-		return true;
-	}
-
-	/*
-	 * We may be zeroing pages we're about to discard, but it avoids
-	 * doing a complex calculation here, and then doing the zeroing
-	 * anyway if the page split fails.
-	 */
-	zero_user(page, offset, length);
+	if (length == thp_size(page))
+		goto truncate;
 
 	cleancache_invalidate_page(page->mapping, page);
 	if (page_has_private(page))
 		do_invalidatepage(page, offset, length);
 	if (!PageTransHuge(page))
-		return true;
-	return split_huge_page(page) == 0;
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
 }
 
 /*
@@ -322,10 +332,6 @@ int invalidate_inode_page(struct page *p
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
@@ -333,34 +339,24 @@ int invalidate_inode_page(struct page *p
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, loff_t lend)
 {
-	pgoff_t		start;		/* inclusive */
-	pgoff_t		end;		/* exclusive */
+	pgoff_t start, end;
 	struct pagevec	pvec;
 	pgoff_t		indices[PAGEVEC_SIZE];
 	pgoff_t		index;
 	int		i;
 	struct page *	page;
-	bool partial_end;
 
 	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
 		goto out;
 
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
+	start = lstart >> PAGE_SHIFT;
+	page = find_lock_head(mapping, start);
+	if (page)
+		start = truncate_inode_partial_page(mapping, page, lstart,
+							lend);
+
+	/* 'end' includes a partial page */
+	end = lend / PAGE_SIZE;
 
 	pagevec_init(&pvec);
 	index = start;
@@ -377,37 +373,11 @@ void truncate_inode_pages_range(struct a
 		cond_resched();
 	}
 
-	partial_end = ((lend + 1) % PAGE_SIZE) > 0;
-	page = find_lock_head(mapping, lstart >> PAGE_SHIFT);
-	if (page) {
-		bool same_page = lend < page_offset(page) + thp_size(page);
-		if (same_page)
-			partial_end = false;
-		if (!truncate_inode_partial_page(page, lstart, lend)) {
-			start = page->index + thp_nr_pages(page);
-			if (same_page)
-				end = page->index;
-		}
-		unlock_page(page);
-		put_page(page);
-		page = NULL;
-	}
-
-	if (partial_end)
-		page = find_lock_head(mapping, end);
-	if (page) {
-		if (!truncate_inode_partial_page(page, lstart, lend))
-			end = page->index;
-		unlock_page(page);
-		put_page(page);
-	}
-
 	index = start;
-	while (index < end) {
+	while (index <= end) {
 		cond_resched();
 
-		if (!find_get_entries(mapping, index, end - 1, &pvec,
-				indices)) {
+		if (!find_get_entries(mapping, index, end, &pvec, indices)) {
 			/* If all gone from start onwards, we're done */
 			if (index == start)
 				break;
@@ -418,22 +388,19 @@ void truncate_inode_pages_range(struct a
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			page = pvec.pages[i];
-
-			/* We rely upon deletion not changing page->index */
-			index = indices[i];
-
 			if (xa_is_value(page))
 				continue;
 
 			lock_page(page);
-			index = page->index + thp_nr_pages(page) - 1;
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
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch

