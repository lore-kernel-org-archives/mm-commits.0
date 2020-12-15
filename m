Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD67C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF09224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgLODFl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgLODFg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:05:36 -0500
Date:   Mon, 14 Dec 2020 19:04:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001493;
        bh=cESV9qqh1yVOh8wKoxPQ/Ms2YKelR4Xb+/Z/IaqNHpY=;
        h=From:To:Subject:In-Reply-To:From;
        b=aWxus1k5/nG2jKFlOD7X8ks/c+8KojoAVwp57SL5dY2GAQ3POz6YepoF39k6Srkmm
         hX2qWBu/ztBCXoo3RuVo2OVpklqU8rVjj0eJhEyArVfPmNMNbiiUhXpBjtvk6BP6YH
         WC+BPPROmxHSuIVdokOVUCTxgD0j0zSanGqiRwtE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk,
        kent.overstreet@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 028/200] mm/filemap/c: break
 generic_file_buffered_read up into multiple functions
Message-ID: <20201215030452.lt-vcqAaF%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: mm/filemap/c: break generic_file_buffered_read up into multiple functions

Patch series "generic_file_buffered_read() improvements", v2.

generic_file_buffered_read() has turned into a real monstrosity to work
with.  And it's a major performance improvement, for both small random and
large sequential reads.  On my test box, 4k buffered random reads go from
~150k to ~250k iops, and the improvements to big sequential reads are even
bigger.

This incorporates the fix for IOCB_WAITQ handling that Jens just posted as
well, also factors out lock_page_for_iocb() to improve handling of the
various iocb flags.


This patch (of 2):

This is prep work for changing generic_file_buffered_read() to use
find_get_pages_contig() to batch up all the pagecache lookups.

This patch should be functionally identical to the existing code and
changes as little as of the flow control as possible.  More refactoring
could be done, this patch is intended to be relatively minimal.

Link: https://lkml.kernel.org/r/20201025212949.602194-1-kent.overstreet@gmail.com
Link: https://lkml.kernel.org/r/20201025212949.602194-2-kent.overstreet@gmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  483 ++++++++++++++++++++++++++-----------------------
 1 file changed, 261 insertions(+), 222 deletions(-)

--- a/mm/filemap.c~fs-break-generic_file_buffered_read-up-into-multiple-functions
+++ a/mm/filemap.c
@@ -2166,6 +2166,234 @@ static void shrink_readahead_size_eio(st
 	ra->ra_pages /= 4;
 }
 
+static int lock_page_for_iocb(struct kiocb *iocb, struct page *page)
+{
+	if (iocb->ki_flags & IOCB_WAITQ)
+		return lock_page_async(page, iocb->ki_waitq);
+	else if (iocb->ki_flags & IOCB_NOWAIT)
+		return trylock_page(page) ? 0 : -EAGAIN;
+	else
+		return lock_page_killable(page);
+}
+
+static int generic_file_buffered_read_page_ok(struct kiocb *iocb,
+			struct iov_iter *iter,
+			struct page *page)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	struct inode *inode = mapping->host;
+	struct file_ra_state *ra = &iocb->ki_filp->f_ra;
+	unsigned int offset = iocb->ki_pos & ~PAGE_MASK;
+	unsigned int bytes, copied;
+	loff_t isize, end_offset;
+
+	BUG_ON(iocb->ki_pos >> PAGE_SHIFT != page->index);
+
+	/*
+	 * i_size must be checked after we know the page is Uptodate.
+	 *
+	 * Checking i_size after the check allows us to calculate
+	 * the correct value for "bytes", which means the zero-filled
+	 * part of the page is not copied back to userspace (unless
+	 * another truncate extends the file - this is desired though).
+	 */
+
+	isize = i_size_read(inode);
+	if (unlikely(iocb->ki_pos >= isize))
+		return 1;
+
+	end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
+
+	bytes = min_t(loff_t, end_offset - iocb->ki_pos, PAGE_SIZE - offset);
+
+	/* If users can be writing to this page using arbitrary
+	 * virtual addresses, take care about potential aliasing
+	 * before reading the page on the kernel side.
+	 */
+	if (mapping_writably_mapped(mapping))
+		flush_dcache_page(page);
+
+	/*
+	 * Ok, we have the page, and it's up-to-date, so
+	 * now we can copy it to user space...
+	 */
+
+	copied = copy_page_to_iter(page, offset, bytes, iter);
+
+	iocb->ki_pos += copied;
+
+	/*
+	 * When a sequential read accesses a page several times,
+	 * only mark it as accessed the first time.
+	 */
+	if (iocb->ki_pos >> PAGE_SHIFT != ra->prev_pos >> PAGE_SHIFT)
+		mark_page_accessed(page);
+
+	ra->prev_pos = iocb->ki_pos;
+
+	if (copied < bytes)
+		return -EFAULT;
+
+	return !iov_iter_count(iter) || iocb->ki_pos == isize;
+}
+
+static struct page *
+generic_file_buffered_read_readpage(struct kiocb *iocb,
+				    struct file *filp,
+				    struct address_space *mapping,
+				    struct page *page)
+{
+	struct file_ra_state *ra = &filp->f_ra;
+	int error;
+
+	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
+		unlock_page(page);
+		put_page(page);
+		return ERR_PTR(-EAGAIN);
+	}
+
+	/*
+	 * A previous I/O error may have been due to temporary
+	 * failures, eg. multipath errors.
+	 * PG_error will be set again if readpage fails.
+	 */
+	ClearPageError(page);
+	/* Start the actual read. The read will unlock the page. */
+	error = mapping->a_ops->readpage(filp, page);
+
+	if (unlikely(error)) {
+		put_page(page);
+		return error != AOP_TRUNCATED_PAGE ? ERR_PTR(error) : NULL;
+	}
+
+	if (!PageUptodate(page)) {
+		error = lock_page_for_iocb(iocb, page);
+		if (unlikely(error)) {
+			put_page(page);
+			return ERR_PTR(error);
+		}
+		if (!PageUptodate(page)) {
+			if (page->mapping == NULL) {
+				/*
+				 * invalidate_mapping_pages got it
+				 */
+				unlock_page(page);
+				put_page(page);
+				return NULL;
+			}
+			unlock_page(page);
+			shrink_readahead_size_eio(ra);
+			put_page(page);
+			return ERR_PTR(-EIO);
+		}
+		unlock_page(page);
+	}
+
+	return page;
+}
+
+static struct page *
+generic_file_buffered_read_pagenotuptodate(struct kiocb *iocb,
+					   struct file *filp,
+					   struct iov_iter *iter,
+					   struct page *page,
+					   loff_t pos, loff_t count)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	int error;
+
+	/*
+	 * See comment in do_read_cache_page on why
+	 * wait_on_page_locked is used to avoid unnecessarily
+	 * serialisations and why it's safe.
+	 */
+	if (iocb->ki_flags & IOCB_WAITQ) {
+		error = wait_on_page_locked_async(page,
+						iocb->ki_waitq);
+	} else {
+		error = wait_on_page_locked_killable(page);
+	}
+	if (unlikely(error)) {
+		put_page(page);
+		return ERR_PTR(error);
+	}
+	if (PageUptodate(page))
+		return page;
+
+	if (inode->i_blkbits == PAGE_SHIFT ||
+			!mapping->a_ops->is_partially_uptodate)
+		goto page_not_up_to_date;
+	/* pipes can't handle partially uptodate pages */
+	if (unlikely(iov_iter_is_pipe(iter)))
+		goto page_not_up_to_date;
+	if (!trylock_page(page))
+		goto page_not_up_to_date;
+	/* Did it get truncated before we got the lock? */
+	if (!page->mapping)
+		goto page_not_up_to_date_locked;
+	if (!mapping->a_ops->is_partially_uptodate(page,
+				pos & ~PAGE_MASK, count))
+		goto page_not_up_to_date_locked;
+	unlock_page(page);
+	return page;
+
+page_not_up_to_date:
+	/* Get exclusive access to the page ... */
+	error = lock_page_for_iocb(iocb, page);
+	if (unlikely(error)) {
+		put_page(page);
+		return ERR_PTR(error);
+	}
+
+page_not_up_to_date_locked:
+	/* Did it get truncated before we got the lock? */
+	if (!page->mapping) {
+		unlock_page(page);
+		put_page(page);
+		return NULL;
+	}
+
+	/* Did somebody else fill it already? */
+	if (PageUptodate(page)) {
+		unlock_page(page);
+		return page;
+	}
+
+	return generic_file_buffered_read_readpage(iocb, filp, mapping, page);
+}
+
+static struct page *
+generic_file_buffered_read_no_cached_page(struct kiocb *iocb,
+					  struct iov_iter *iter)
+{
+	struct file *filp = iocb->ki_filp;
+	struct address_space *mapping = filp->f_mapping;
+	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
+	struct page *page;
+	int error;
+
+	if (iocb->ki_flags & IOCB_NOIO)
+		return ERR_PTR(-EAGAIN);
+
+	/*
+	 * Ok, it wasn't cached, so we need to create a new
+	 * page..
+	 */
+	page = page_cache_alloc(mapping);
+	if (!page)
+		return ERR_PTR(-ENOMEM);
+
+	error = add_to_page_cache_lru(page, mapping, index,
+				      mapping_gfp_constraint(mapping, GFP_KERNEL));
+	if (error) {
+		put_page(page);
+		return error != -EEXIST ? ERR_PTR(error) : NULL;
+	}
+
+	return generic_file_buffered_read_readpage(iocb, filp, mapping, page);
+}
+
 /**
  * generic_file_buffered_read - generic file read routine
  * @iocb:	the iocb to read
@@ -2189,23 +2417,15 @@ ssize_t generic_file_buffered_read(struc
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
 	struct file_ra_state *ra = &filp->f_ra;
-	loff_t *ppos = &iocb->ki_pos;
-	pgoff_t index;
+	size_t orig_count = iov_iter_count(iter);
 	pgoff_t last_index;
-	pgoff_t prev_index;
-	unsigned long offset;      /* offset into pagecache page */
-	unsigned int prev_offset;
 	int error = 0;
 
-	if (unlikely(*ppos >= inode->i_sb->s_maxbytes))
+	if (unlikely(iocb->ki_pos >= inode->i_sb->s_maxbytes))
 		return 0;
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
 
-	index = *ppos >> PAGE_SHIFT;
-	prev_index = ra->prev_pos >> PAGE_SHIFT;
-	prev_offset = ra->prev_pos & (PAGE_SIZE-1);
-	last_index = (*ppos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
-	offset = *ppos & ~PAGE_MASK;
+	last_index = (iocb->ki_pos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
 
 	/*
 	 * If we've already successfully copied some data, then we
@@ -2216,10 +2436,8 @@ ssize_t generic_file_buffered_read(struc
 		iocb->ki_flags |= IOCB_NOWAIT;
 
 	for (;;) {
+		pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
 		struct page *page;
-		pgoff_t end_index;
-		loff_t isize;
-		unsigned long nr, ret;
 
 		cond_resched();
 find_page:
@@ -2228,6 +2446,14 @@ find_page:
 			goto out;
 		}
 
+		/*
+		 * We can't return -EIOCBQUEUED once we've done some work, so
+		 * ensure we don't block:
+		 */
+		if ((iocb->ki_flags & IOCB_WAITQ) &&
+		    (written + orig_count - iov_iter_count(iter)))
+			iocb->ki_flags |= IOCB_NOWAIT;
+
 		page = find_get_page(mapping, index);
 		if (!page) {
 			if (iocb->ki_flags & IOCB_NOIO)
@@ -2236,8 +2462,15 @@ find_page:
 					ra, filp,
 					index, last_index - index);
 			page = find_get_page(mapping, index);
-			if (unlikely(page == NULL))
-				goto no_cached_page;
+			if (unlikely(page == NULL)) {
+				page = generic_file_buffered_read_no_cached_page(iocb, iter);
+				if (!page)
+					goto find_page;
+				if (IS_ERR(page)) {
+					error = PTR_ERR(page);
+					goto out;
+				}
+			}
 		}
 		if (PageReadahead(page)) {
 			if (iocb->ki_flags & IOCB_NOIO) {
@@ -2249,231 +2482,37 @@ find_page:
 					index, last_index - index);
 		}
 		if (!PageUptodate(page)) {
-			/*
-			 * See comment in do_read_cache_page on why
-			 * wait_on_page_locked is used to avoid unnecessarily
-			 * serialisations and why it's safe.
-			 */
-			if (iocb->ki_flags & IOCB_WAITQ) {
-				if (written) {
-					put_page(page);
-					goto out;
-				}
-				error = wait_on_page_locked_async(page,
-								iocb->ki_waitq);
-			} else {
-				if (iocb->ki_flags & IOCB_NOWAIT) {
-					put_page(page);
-					goto would_block;
-				}
-				error = wait_on_page_locked_killable(page);
-			}
-			if (unlikely(error))
-				goto readpage_error;
-			if (PageUptodate(page))
-				goto page_ok;
-
-			if (inode->i_blkbits == PAGE_SHIFT ||
-					!mapping->a_ops->is_partially_uptodate)
-				goto page_not_up_to_date;
-			/* pipes can't handle partially uptodate pages */
-			if (unlikely(iov_iter_is_pipe(iter)))
-				goto page_not_up_to_date;
-			if (!trylock_page(page))
-				goto page_not_up_to_date;
-			/* Did it get truncated before we got the lock? */
-			if (!page->mapping)
-				goto page_not_up_to_date_locked;
-			if (!mapping->a_ops->is_partially_uptodate(page,
-							offset, iter->count))
-				goto page_not_up_to_date_locked;
-			unlock_page(page);
-		}
-page_ok:
-		/*
-		 * i_size must be checked after we know the page is Uptodate.
-		 *
-		 * Checking i_size after the check allows us to calculate
-		 * the correct value for "nr", which means the zero-filled
-		 * part of the page is not copied back to userspace (unless
-		 * another truncate extends the file - this is desired though).
-		 */
-
-		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_SHIFT;
-		if (unlikely(!isize || index > end_index)) {
-			put_page(page);
-			goto out;
-		}
-
-		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_SIZE;
-		if (index == end_index) {
-			nr = ((isize - 1) & ~PAGE_MASK) + 1;
-			if (nr <= offset) {
+			if (iocb->ki_flags & IOCB_NOWAIT) {
 				put_page(page);
+				error = -EAGAIN;
 				goto out;
 			}
-		}
-		nr = nr - offset;
-
-		/* If users can be writing to this page using arbitrary
-		 * virtual addresses, take care about potential aliasing
-		 * before reading the page on the kernel side.
-		 */
-		if (mapping_writably_mapped(mapping))
-			flush_dcache_page(page);
-
-		/*
-		 * When a sequential read accesses a page several times,
-		 * only mark it as accessed the first time.
-		 */
-		if (prev_index != index || offset != prev_offset)
-			mark_page_accessed(page);
-		prev_index = index;
-
-		/*
-		 * Ok, we have the page, and it's up-to-date, so
-		 * now we can copy it to user space...
-		 */
-
-		ret = copy_page_to_iter(page, offset, nr, iter);
-		offset += ret;
-		index += offset >> PAGE_SHIFT;
-		offset &= ~PAGE_MASK;
-		prev_offset = offset;
-
-		put_page(page);
-		written += ret;
-		if (!iov_iter_count(iter))
-			goto out;
-		if (ret < nr) {
-			error = -EFAULT;
-			goto out;
-		}
-		continue;
-
-page_not_up_to_date:
-		/* Get exclusive access to the page ... */
-		if (iocb->ki_flags & IOCB_WAITQ) {
-			if (written) {
-				put_page(page);
-				goto out;
-			}
-			error = lock_page_async(page, iocb->ki_waitq);
-		} else {
-			error = lock_page_killable(page);
-		}
-		if (unlikely(error))
-			goto readpage_error;
-
-page_not_up_to_date_locked:
-		/* Did it get truncated before we got the lock? */
-		if (!page->mapping) {
-			unlock_page(page);
-			put_page(page);
-			continue;
-		}
-
-		/* Did somebody else fill it already? */
-		if (PageUptodate(page)) {
-			unlock_page(page);
-			goto page_ok;
-		}
-
-readpage:
-		if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
-			unlock_page(page);
-			put_page(page);
-			goto would_block;
-		}
-		/*
-		 * A previous I/O error may have been due to temporary
-		 * failures, eg. multipath errors.
-		 * PG_error will be set again if readpage fails.
-		 */
-		ClearPageError(page);
-		/* Start the actual read. The read will unlock the page. */
-		error = mapping->a_ops->readpage(filp, page);
-
-		if (unlikely(error)) {
-			if (error == AOP_TRUNCATED_PAGE) {
-				put_page(page);
-				error = 0;
+			page = generic_file_buffered_read_pagenotuptodate(iocb,
+					filp, iter, page, iocb->ki_pos, iter->count);
+			if (!page)
 				goto find_page;
+			if (IS_ERR(page)) {
+				error = PTR_ERR(page);
+				goto out;
 			}
-			goto readpage_error;
-		}
-
-		if (!PageUptodate(page)) {
-			if (iocb->ki_flags & IOCB_WAITQ) {
-				if (written) {
-					put_page(page);
-					goto out;
-				}
-				error = lock_page_async(page, iocb->ki_waitq);
-			} else {
-				error = lock_page_killable(page);
-			}
-
-			if (unlikely(error))
-				goto readpage_error;
-			if (!PageUptodate(page)) {
-				if (page->mapping == NULL) {
-					/*
-					 * invalidate_mapping_pages got it
-					 */
-					unlock_page(page);
-					put_page(page);
-					goto find_page;
-				}
-				unlock_page(page);
-				shrink_readahead_size_eio(ra);
-				error = -EIO;
-				goto readpage_error;
-			}
-			unlock_page(page);
 		}
 
-		goto page_ok;
-
-readpage_error:
-		/* UHHUH! A synchronous read error occurred. Report it */
+		error = generic_file_buffered_read_page_ok(iocb, iter, page);
 		put_page(page);
-		goto out;
 
-no_cached_page:
-		/*
-		 * Ok, it wasn't cached, so we need to create a new
-		 * page..
-		 */
-		page = page_cache_alloc(mapping);
-		if (!page) {
-			error = -ENOMEM;
-			goto out;
-		}
-		error = add_to_page_cache_lru(page, mapping, index,
-				mapping_gfp_constraint(mapping, GFP_KERNEL));
 		if (error) {
-			put_page(page);
-			if (error == -EEXIST) {
+			if (error > 0)
 				error = 0;
-				goto find_page;
-			}
 			goto out;
 		}
-		goto readpage;
 	}
 
 would_block:
 	error = -EAGAIN;
 out:
-	ra->prev_pos = prev_index;
-	ra->prev_pos <<= PAGE_SHIFT;
-	ra->prev_pos |= prev_offset;
-
-	*ppos = ((loff_t)index << PAGE_SHIFT) + offset;
 	file_accessed(filp);
+	written += orig_count - iov_iter_count(iter);
+
 	return written ? written : error;
 }
 EXPORT_SYMBOL_GPL(generic_file_buffered_read);
_
