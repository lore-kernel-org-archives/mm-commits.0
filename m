Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04919C2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7772224DE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgLODFe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgLODFM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:12 -0500
Date:   Mon, 14 Dec 2020 19:04:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001496;
        bh=N7W5lp1dcQrAYk5b738/qngRfVlJr9f7UId0u+xbiYQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=E1OyJ/rEQSPu+Ht5gHl1AdC297abkPFkoYa79xN9k9GiCYCkITIGIIaE+bTKxB61F
         NWHl9H/KhfDxwgF/orVccL2aoTMv94yi3vHVOQdCRSE/+ubxf6rQEqU2+akTsvO7qb
         95NNB1NDPULl6Gl0ah9BPUzfzUK5laTgsVcFSgMs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk,
        kent.overstreet@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 029/200] mm/filemap.c:
 generic_file_buffered_read() now uses find_get_pages_contig
Message-ID: <20201215030456.8JFbdw4xD%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: mm/filemap.c: generic_file_buffered_read() now uses find_get_pages_contig

Convert generic_file_buffered_read() to get pages to read from in batches,
and then copy data to userspace from many pages at once - in particular,
we now don't touch any cachelines that might be contended while we're in
the loop to copy data to userspace.

This is is a performance improvement on workloads that do buffered reads
with large blocksizes, and a very large performance improvement if that
file is also being accessed concurrently by different threads.

On smaller reads (512 bytes), there's a very small performance improvement
(1%, within the margin of error).

akpm: kernel test robot found a 32% speedup on one test:
https://lkml.kernel.org/r/20201030081456.GY31092@shao2-debian

Link: https://lkml.kernel.org/r/20201025212949.602194-3-kent.overstreet@gmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  313 +++++++++++++++++++++++++++----------------------
 1 file changed, 175 insertions(+), 138 deletions(-)

--- a/mm/filemap.c~fs-generic_file_buffered_read-now-uses-find_get_pages_contig
+++ a/mm/filemap.c
@@ -2176,67 +2176,6 @@ static int lock_page_for_iocb(struct kio
 		return lock_page_killable(page);
 }
 
-static int generic_file_buffered_read_page_ok(struct kiocb *iocb,
-			struct iov_iter *iter,
-			struct page *page)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-	struct inode *inode = mapping->host;
-	struct file_ra_state *ra = &iocb->ki_filp->f_ra;
-	unsigned int offset = iocb->ki_pos & ~PAGE_MASK;
-	unsigned int bytes, copied;
-	loff_t isize, end_offset;
-
-	BUG_ON(iocb->ki_pos >> PAGE_SHIFT != page->index);
-
-	/*
-	 * i_size must be checked after we know the page is Uptodate.
-	 *
-	 * Checking i_size after the check allows us to calculate
-	 * the correct value for "bytes", which means the zero-filled
-	 * part of the page is not copied back to userspace (unless
-	 * another truncate extends the file - this is desired though).
-	 */
-
-	isize = i_size_read(inode);
-	if (unlikely(iocb->ki_pos >= isize))
-		return 1;
-
-	end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
-
-	bytes = min_t(loff_t, end_offset - iocb->ki_pos, PAGE_SIZE - offset);
-
-	/* If users can be writing to this page using arbitrary
-	 * virtual addresses, take care about potential aliasing
-	 * before reading the page on the kernel side.
-	 */
-	if (mapping_writably_mapped(mapping))
-		flush_dcache_page(page);
-
-	/*
-	 * Ok, we have the page, and it's up-to-date, so
-	 * now we can copy it to user space...
-	 */
-
-	copied = copy_page_to_iter(page, offset, bytes, iter);
-
-	iocb->ki_pos += copied;
-
-	/*
-	 * When a sequential read accesses a page several times,
-	 * only mark it as accessed the first time.
-	 */
-	if (iocb->ki_pos >> PAGE_SHIFT != ra->prev_pos >> PAGE_SHIFT)
-		mark_page_accessed(page);
-
-	ra->prev_pos = iocb->ki_pos;
-
-	if (copied < bytes)
-		return -EFAULT;
-
-	return !iov_iter_count(iter) || iocb->ki_pos == isize;
-}
-
 static struct page *
 generic_file_buffered_read_readpage(struct kiocb *iocb,
 				    struct file *filp,
@@ -2394,6 +2333,92 @@ generic_file_buffered_read_no_cached_pag
 	return generic_file_buffered_read_readpage(iocb, filp, mapping, page);
 }
 
+static int generic_file_buffered_read_get_pages(struct kiocb *iocb,
+						struct iov_iter *iter,
+						struct page **pages,
+						unsigned int nr)
+{
+	struct file *filp = iocb->ki_filp;
+	struct address_space *mapping = filp->f_mapping;
+	struct file_ra_state *ra = &filp->f_ra;
+	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
+	pgoff_t last_index = (iocb->ki_pos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
+	int i, j, nr_got, err = 0;
+
+	nr = min_t(unsigned long, last_index - index, nr);
+find_page:
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	nr_got = find_get_pages_contig(mapping, index, nr, pages);
+	if (nr_got)
+		goto got_pages;
+
+	if (iocb->ki_flags & IOCB_NOIO)
+		return -EAGAIN;
+
+	page_cache_sync_readahead(mapping, ra, filp, index, last_index - index);
+
+	nr_got = find_get_pages_contig(mapping, index, nr, pages);
+	if (nr_got)
+		goto got_pages;
+
+	pages[0] = generic_file_buffered_read_no_cached_page(iocb, iter);
+	err = PTR_ERR_OR_ZERO(pages[0]);
+	if (!IS_ERR_OR_NULL(pages[0]))
+		nr_got = 1;
+got_pages:
+	for (i = 0; i < nr_got; i++) {
+		struct page *page = pages[i];
+		pgoff_t pg_index = index + i;
+		loff_t pg_pos = max(iocb->ki_pos,
+				    (loff_t) pg_index << PAGE_SHIFT);
+		loff_t pg_count = iocb->ki_pos + iter->count - pg_pos;
+
+		if (PageReadahead(page)) {
+			if (iocb->ki_flags & IOCB_NOIO) {
+				for (j = i; j < nr_got; j++)
+					put_page(pages[j]);
+				nr_got = i;
+				err = -EAGAIN;
+				break;
+			}
+			page_cache_async_readahead(mapping, ra, filp, page,
+					pg_index, last_index - pg_index);
+		}
+
+		if (!PageUptodate(page)) {
+			if ((iocb->ki_flags & IOCB_NOWAIT) ||
+			    ((iocb->ki_flags & IOCB_WAITQ) && i)) {
+				for (j = i; j < nr_got; j++)
+					put_page(pages[j]);
+				nr_got = i;
+				err = -EAGAIN;
+				break;
+			}
+
+			page = generic_file_buffered_read_pagenotuptodate(iocb,
+					filp, iter, page, pg_pos, pg_count);
+			if (IS_ERR_OR_NULL(page)) {
+				for (j = i + 1; j < nr_got; j++)
+					put_page(pages[j]);
+				nr_got = i;
+				err = PTR_ERR_OR_ZERO(page);
+				break;
+			}
+		}
+	}
+
+	if (likely(nr_got))
+		return nr_got;
+	if (err)
+		return err;
+	/*
+	 * No pages and no error means we raced and should retry:
+	 */
+	goto find_page;
+}
+
 /**
  * generic_file_buffered_read - generic file read routine
  * @iocb:	the iocb to read
@@ -2414,104 +2439,116 @@ ssize_t generic_file_buffered_read(struc
 		struct iov_iter *iter, ssize_t written)
 {
 	struct file *filp = iocb->ki_filp;
+	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	struct file_ra_state *ra = &filp->f_ra;
-	size_t orig_count = iov_iter_count(iter);
-	pgoff_t last_index;
-	int error = 0;
+	struct page *pages_onstack[PAGEVEC_SIZE], **pages = NULL;
+	unsigned int nr_pages = min_t(unsigned int, 512,
+			((iocb->ki_pos + iter->count + PAGE_SIZE - 1) >> PAGE_SHIFT) -
+			(iocb->ki_pos >> PAGE_SHIFT));
+	int i, pg_nr, error = 0;
+	bool writably_mapped;
+	loff_t isize, end_offset;
 
 	if (unlikely(iocb->ki_pos >= inode->i_sb->s_maxbytes))
 		return 0;
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
 
-	last_index = (iocb->ki_pos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
-
-	/*
-	 * If we've already successfully copied some data, then we
-	 * can no longer safely return -EIOCBQUEUED. Hence mark
-	 * an async read NOWAIT at that point.
-	 */
-	if (written && (iocb->ki_flags & IOCB_WAITQ))
-		iocb->ki_flags |= IOCB_NOWAIT;
+	if (nr_pages > ARRAY_SIZE(pages_onstack))
+		pages = kmalloc_array(nr_pages, sizeof(void *), GFP_KERNEL);
 
-	for (;;) {
-		pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
-		struct page *page;
+	if (!pages) {
+		pages = pages_onstack;
+		nr_pages = min_t(unsigned int, nr_pages, ARRAY_SIZE(pages_onstack));
+	}
 
+	do {
 		cond_resched();
-find_page:
-		if (fatal_signal_pending(current)) {
-			error = -EINTR;
-			goto out;
-		}
 
 		/*
-		 * We can't return -EIOCBQUEUED once we've done some work, so
-		 * ensure we don't block:
+		 * If we've already successfully copied some data, then we
+		 * can no longer safely return -EIOCBQUEUED. Hence mark
+		 * an async read NOWAIT at that point.
 		 */
-		if ((iocb->ki_flags & IOCB_WAITQ) &&
-		    (written + orig_count - iov_iter_count(iter)))
+		if ((iocb->ki_flags & IOCB_WAITQ) && written)
 			iocb->ki_flags |= IOCB_NOWAIT;
 
-		page = find_get_page(mapping, index);
-		if (!page) {
-			if (iocb->ki_flags & IOCB_NOIO)
-				goto would_block;
-			page_cache_sync_readahead(mapping,
-					ra, filp,
-					index, last_index - index);
-			page = find_get_page(mapping, index);
-			if (unlikely(page == NULL)) {
-				page = generic_file_buffered_read_no_cached_page(iocb, iter);
-				if (!page)
-					goto find_page;
-				if (IS_ERR(page)) {
-					error = PTR_ERR(page);
-					goto out;
-				}
-			}
-		}
-		if (PageReadahead(page)) {
-			if (iocb->ki_flags & IOCB_NOIO) {
-				put_page(page);
-				goto out;
-			}
-			page_cache_async_readahead(mapping,
-					ra, filp, page,
-					index, last_index - index);
-		}
-		if (!PageUptodate(page)) {
-			if (iocb->ki_flags & IOCB_NOWAIT) {
-				put_page(page);
-				error = -EAGAIN;
-				goto out;
-			}
-			page = generic_file_buffered_read_pagenotuptodate(iocb,
-					filp, iter, page, iocb->ki_pos, iter->count);
-			if (!page)
-				goto find_page;
-			if (IS_ERR(page)) {
-				error = PTR_ERR(page);
-				goto out;
-			}
+		i = 0;
+		pg_nr = generic_file_buffered_read_get_pages(iocb, iter,
+							     pages, nr_pages);
+		if (pg_nr < 0) {
+			error = pg_nr;
+			break;
 		}
 
-		error = generic_file_buffered_read_page_ok(iocb, iter, page);
-		put_page(page);
+		/*
+		 * i_size must be checked after we know the pages are Uptodate.
+		 *
+		 * Checking i_size after the check allows us to calculate
+		 * the correct value for "nr", which means the zero-filled
+		 * part of the page is not copied back to userspace (unless
+		 * another truncate extends the file - this is desired though).
+		 */
+		isize = i_size_read(inode);
+		if (unlikely(iocb->ki_pos >= isize))
+			goto put_pages;
+
+		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
+
+		while ((iocb->ki_pos >> PAGE_SHIFT) + pg_nr >
+		       (end_offset + PAGE_SIZE - 1) >> PAGE_SHIFT)
+			put_page(pages[--pg_nr]);
+
+		/*
+		 * Once we start copying data, we don't want to be touching any
+		 * cachelines that might be contended:
+		 */
+		writably_mapped = mapping_writably_mapped(mapping);
 
-		if (error) {
-			if (error > 0)
-				error = 0;
-			goto out;
+		/*
+		 * When a sequential read accesses a page several times, only
+		 * mark it as accessed the first time.
+		 */
+		if (iocb->ki_pos >> PAGE_SHIFT !=
+		    ra->prev_pos >> PAGE_SHIFT)
+			mark_page_accessed(pages[0]);
+		for (i = 1; i < pg_nr; i++)
+			mark_page_accessed(pages[i]);
+
+		for (i = 0; i < pg_nr; i++) {
+			unsigned int offset = iocb->ki_pos & ~PAGE_MASK;
+			unsigned int bytes = min_t(loff_t, end_offset - iocb->ki_pos,
+						   PAGE_SIZE - offset);
+			unsigned int copied;
+
+			/*
+			 * If users can be writing to this page using arbitrary
+			 * virtual addresses, take care about potential aliasing
+			 * before reading the page on the kernel side.
+			 */
+			if (writably_mapped)
+				flush_dcache_page(pages[i]);
+
+			copied = copy_page_to_iter(pages[i], offset, bytes, iter);
+
+			written += copied;
+			iocb->ki_pos += copied;
+			ra->prev_pos = iocb->ki_pos;
+
+			if (copied < bytes) {
+				error = -EFAULT;
+				break;
+			}
 		}
-	}
+put_pages:
+		for (i = 0; i < pg_nr; i++)
+			put_page(pages[i]);
+	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
-would_block:
-	error = -EAGAIN;
-out:
 	file_accessed(filp);
-	written += orig_count - iov_iter_count(iter);
+
+	if (pages != pages_onstack)
+		kfree(pages);
 
 	return written ? written : error;
 }
_
