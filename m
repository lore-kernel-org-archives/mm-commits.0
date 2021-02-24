Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EA2C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0451A64F26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhBXUDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235278AbhBXUCh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C29BB64F0E;
        Wed, 24 Feb 2021 20:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196920;
        bh=aCK0dNgwGkv90of6nPlfiG1AVyeLOiO5Ok0TXQU0XMc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D5IzzQK/qajMCdfut204yMk9o/QPSWaK/gcOBWiYEh3t7WQPbYAF0ht3XjcaJ5LMm
         cb46X6COJ+VNPBrQZq1j6OVsKgLKYaYn0OBbK+Asxkq2GjuNqRCq0iN2U6sXFDmQI7
         1550nZBo0PmZlZafnawguYrx7VerSdxv1e/nyCKM=
Date:   Wed, 24 Feb 2021 12:01:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, kent.overstreet@gmail.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 033/173] mm/filemap: use head pages in
 generic_file_buffered_read
Message-ID: <20210224200159.h_ITNzOVN%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: use head pages in generic_file_buffered_read

Add filemap_get_read_batch() which returns the head pages which represent
a contiguous array of bytes in the file.  It also stops when encountering
a page marked as Readahead or !Uptodate (but does return that page) so it
can be handled appropriately by filemap_get_pages().  That lets us remove
the loop in filemap_get_pages() and check only the last page.

Link: https://lkml.kernel.org/r/20210122160140.223228-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  122 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 85 insertions(+), 37 deletions(-)

--- a/mm/filemap.c~mm-filemap-use-head-pages-in-generic_file_buffered_read
+++ a/mm/filemap.c
@@ -2178,6 +2178,51 @@ static int lock_page_for_iocb(struct kio
 		return lock_page_killable(page);
 }
 
+/*
+ * filemap_get_read_batch - Get a batch of pages for read
+ *
+ * Get a batch of pages which represent a contiguous range of bytes
+ * in the file.  No tail pages will be returned.  If @index is in the
+ * middle of a THP, the entire THP will be returned.  The last page in
+ * the batch may have Readahead set or be not Uptodate so that the
+ * caller can take the appropriate action.
+ */
+static void filemap_get_read_batch(struct address_space *mapping,
+		pgoff_t index, pgoff_t max, struct pagevec *pvec)
+{
+	XA_STATE(xas, &mapping->i_pages, index);
+	struct page *head;
+
+	rcu_read_lock();
+	for (head = xas_load(&xas); head; head = xas_next(&xas)) {
+		if (xas_retry(&xas, head))
+			continue;
+		if (xas.xa_index > max || xa_is_value(head))
+			break;
+		if (!page_cache_get_speculative(head))
+			goto retry;
+
+		/* Has the page moved or been split? */
+		if (unlikely(head != xas_reload(&xas)))
+			goto put_page;
+
+		if (!pagevec_add(pvec, head))
+			break;
+		if (!PageUptodate(head))
+			break;
+		if (PageReadahead(head))
+			break;
+		xas.xa_index = head->index + thp_nr_pages(head) - 1;
+		xas.xa_offset = (xas.xa_index >> xas.xa_shift) & XA_CHUNK_MASK;
+		continue;
+put_page:
+		put_page(head);
+retry:
+		xas_reset(&xas);
+	}
+	rcu_read_unlock();
+}
+
 static struct page *filemap_read_page(struct kiocb *iocb, struct file *filp,
 		struct address_space *mapping, struct page *page)
 {
@@ -2331,15 +2376,15 @@ static int filemap_get_pages(struct kioc
 	struct address_space *mapping = filp->f_mapping;
 	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
-	pgoff_t last_index = (iocb->ki_pos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
-	unsigned int nr = min_t(unsigned long, last_index - index, PAGEVEC_SIZE);
-	int i, j, err = 0;
+	pgoff_t last_index;
+	int err = 0;
 
+	last_index = DIV_ROUND_UP(iocb->ki_pos + iter->count, PAGE_SIZE);
 find_page:
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
-	pvec->nr = find_get_pages_contig(mapping, index, nr, pvec->pages);
+	filemap_get_read_batch(mapping, index, last_index, pvec);
 	if (pvec->nr)
 		goto got_pages;
 
@@ -2348,29 +2393,30 @@ find_page:
 
 	page_cache_sync_readahead(mapping, ra, filp, index, last_index - index);
 
-	pvec->nr = find_get_pages_contig(mapping, index, nr, pvec->pages);
+	filemap_get_read_batch(mapping, index, last_index, pvec);
 	if (pvec->nr)
 		goto got_pages;
 
 	pvec->pages[0] = filemap_create_page(iocb, iter);
 	err = PTR_ERR_OR_ZERO(pvec->pages[0]);
-	if (!IS_ERR_OR_NULL(pvec->pages[0]))
-		pvec->nr = 1;
+	if (IS_ERR_OR_NULL(pvec->pages[0]))
+		goto err;
+	pvec->nr = 1;
+	return 0;
 got_pages:
-	for (i = 0; i < pvec->nr; i++) {
-		struct page *page = pvec->pages[i];
-		pgoff_t pg_index = index + i;
+	{
+		struct page *page = pvec->pages[pvec->nr - 1];
+		pgoff_t pg_index = page->index;
 		loff_t pg_pos = max(iocb->ki_pos,
 				    (loff_t) pg_index << PAGE_SHIFT);
 		loff_t pg_count = iocb->ki_pos + iter->count - pg_pos;
 
 		if (PageReadahead(page)) {
 			if (iocb->ki_flags & IOCB_NOIO) {
-				for (j = i; j < pvec->nr; j++)
-					put_page(pvec->pages[j]);
-				pvec->nr = i;
+				put_page(page);
+				pvec->nr--;
 				err = -EAGAIN;
-				break;
+				goto err;
 			}
 			page_cache_async_readahead(mapping, ra, filp, page,
 					pg_index, last_index - pg_index);
@@ -2378,26 +2424,23 @@ got_pages:
 
 		if (!PageUptodate(page)) {
 			if ((iocb->ki_flags & IOCB_NOWAIT) ||
-			    ((iocb->ki_flags & IOCB_WAITQ) && i)) {
-				for (j = i; j < pvec->nr; j++)
-					put_page(pvec->pages[j]);
-				pvec->nr = i;
+			    ((iocb->ki_flags & IOCB_WAITQ) && pvec->nr > 1)) {
+				put_page(page);
+				pvec->nr--;
 				err = -EAGAIN;
-				break;
+				goto err;
 			}
 
 			page = filemap_update_page(iocb, filp, iter, page,
 					pg_pos, pg_count);
 			if (IS_ERR_OR_NULL(page)) {
-				for (j = i + 1; j < pvec->nr; j++)
-					put_page(pvec->pages[j]);
-				pvec->nr = i;
+				pvec->nr--;
 				err = PTR_ERR_OR_ZERO(page);
-				break;
 			}
 		}
 	}
 
+err:
 	if (likely(pvec->nr))
 		return 0;
 	if (err)
@@ -2442,6 +2485,7 @@ ssize_t generic_file_buffered_read(struc
 		return 0;
 
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
+	pagevec_init(&pvec);
 
 	do {
 		cond_resched();
@@ -2469,13 +2513,8 @@ ssize_t generic_file_buffered_read(struc
 		isize = i_size_read(inode);
 		if (unlikely(iocb->ki_pos >= isize))
 			goto put_pages;
-
 		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
 
-		while ((iocb->ki_pos >> PAGE_SHIFT) + pvec.nr >
-		       (end_offset + PAGE_SIZE - 1) >> PAGE_SHIFT)
-			put_page(pvec.pages[--pvec.nr]);
-
 		/*
 		 * Once we start copying data, we don't want to be touching any
 		 * cachelines that might be contended:
@@ -2489,24 +2528,32 @@ ssize_t generic_file_buffered_read(struc
 		if (iocb->ki_pos >> PAGE_SHIFT !=
 		    ra->prev_pos >> PAGE_SHIFT)
 			mark_page_accessed(pvec.pages[0]);
-		for (i = 1; i < pagevec_count(&pvec); i++)
-			mark_page_accessed(pvec.pages[i]);
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			unsigned int offset = iocb->ki_pos & ~PAGE_MASK;
-			unsigned int bytes = min_t(loff_t, end_offset - iocb->ki_pos,
-						   PAGE_SIZE - offset);
-			unsigned int copied;
+			struct page *page = pvec.pages[i];
+			size_t page_size = thp_size(page);
+			size_t offset = iocb->ki_pos & (page_size - 1);
+			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
+					     page_size - offset);
+			size_t copied;
 
+			if (end_offset < page_offset(page))
+				break;
+			if (i > 0)
+				mark_page_accessed(page);
 			/*
 			 * If users can be writing to this page using arbitrary
 			 * virtual addresses, take care about potential aliasing
 			 * before reading the page on the kernel side.
 			 */
-			if (writably_mapped)
-				flush_dcache_page(pvec.pages[i]);
+			if (writably_mapped) {
+				int j;
+
+				for (j = 0; j < thp_nr_pages(page); j++)
+					flush_dcache_page(page + j);
+			}
 
-			copied = copy_page_to_iter(pvec.pages[i], offset, bytes, iter);
+			copied = copy_page_to_iter(page, offset, bytes, iter);
 
 			written += copied;
 			iocb->ki_pos += copied;
@@ -2520,6 +2567,7 @@ ssize_t generic_file_buffered_read(struc
 put_pages:
 		for (i = 0; i < pagevec_count(&pvec); i++)
 			put_page(pvec.pages[i]);
+		pagevec_reinit(&pvec);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
_
