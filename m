From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fs-generic_file_buffered_read-now-uses-find_get_pages_contig.patch removed
 from -mm tree
Date: Wed, 17 Jun 2020 18:06:19 -0700
Message-ID: <20200618010619.xXVpM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgFRBGV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@infradead.org, jack@suse.cz, kent.overstreet@gmail.com


The patch titled
     Subject: mm/filemap.c: generic_file_buffered_read() now uses find_get_pages_contig
has been removed from the -mm tree.  Its filename was
     fs-generic_file_buffered_read-now-uses-find_get_pages_contig.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
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

Link: http://lkml.kernel.org/r/20200610013642.4171512-2-kent.overstreet@gmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  278 +++++++++++++++++++++++++++----------------------
 1 file changed, 156 insertions(+), 122 deletions(-)

--- a/mm/filemap.c~fs-generic_file_buffered_read-now-uses-find_get_pages_contig
+++ a/mm/filemap.c
@@ -1972,67 +1972,6 @@ static void shrink_readahead_size_eio(st
 	ra->ra_pages /= 4;
 }
 
-static int generic_file_buffered_read_page_ok(struct kiocb *iocb,
-			struct iov_iter *iter,
-			struct page *page)
-{
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-	struct inode *inode = mapping->host;
-	struct file_ra_state *ra = &iocb->ki_filp->f_ra;
-	unsigned offset = iocb->ki_pos & ~PAGE_MASK;
-	unsigned bytes, copied;
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
 generic_file_buffered_read_readpage(struct file *filp,
 				    struct address_space *mapping,
@@ -2176,6 +2115,79 @@ generic_file_buffered_read_no_cached_pag
 	return generic_file_buffered_read_readpage(filp, mapping, page);
 }
 
+static int generic_file_buffered_read_get_pages(struct kiocb *iocb,
+						struct iov_iter *iter,
+						struct page **pages,
+						unsigned nr)
+{
+	struct file *filp = iocb->ki_filp;
+	struct address_space *mapping = filp->f_mapping;
+	struct file_ra_state *ra = &filp->f_ra;
+	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
+	pgoff_t last_index = (iocb->ki_pos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
+	int i, j, ret, err = 0;
+
+	nr = min_t(unsigned long, last_index - index, nr);
+find_page:
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	ret = find_get_pages_contig(mapping, index, nr, pages);
+	if (ret)
+		goto got_pages;
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		return -EAGAIN;
+
+	page_cache_sync_readahead(mapping, ra, filp, index, last_index - index);
+
+	ret = find_get_pages_contig(mapping, index, nr, pages);
+	if (ret)
+		goto got_pages;
+
+	pages[0] = generic_file_buffered_read_no_cached_page(iocb, iter);
+	err = PTR_ERR_OR_ZERO(pages[0]);
+	ret = !IS_ERR_OR_NULL(pages[0]);
+got_pages:
+	for (i = 0; i < ret; i++) {
+		struct page *page = pages[i];
+		pgoff_t pg_index = index +i;
+		loff_t pg_pos = max(iocb->ki_pos,
+				    (loff_t) pg_index << PAGE_SHIFT);
+		loff_t pg_count = iocb->ki_pos + iter->count - pg_pos;
+
+		if (PageReadahead(page))
+			page_cache_async_readahead(mapping, ra, filp, page,
+					pg_index, last_index - pg_index);
+
+		if (!PageUptodate(page)) {
+			if (iocb->ki_flags & IOCB_NOWAIT) {
+				for (j = i; j < ret; j++)
+					put_page(pages[j]);
+				ret = i;
+				err = -EAGAIN;
+				break;
+			}
+
+			page = generic_file_buffered_read_pagenotuptodate(filp,
+						iter, page, pg_pos, pg_count);
+			if (IS_ERR_OR_NULL(page)) {
+				for (j = i + 1; j < ret; j++)
+					put_page(pages[j]);
+				ret = i;
+				err = PTR_ERR_OR_ZERO(page);
+				break;
+			}
+		}
+	}
+
+	if (likely(ret))
+		return ret;
+	if (err)
+		return err;
+	goto find_page;
+}
+
 /**
  * generic_file_buffered_read - generic file read routine
  * @iocb:	the iocb to read
@@ -2196,86 +2208,108 @@ ssize_t generic_file_buffered_read(struc
 		struct iov_iter *iter, ssize_t written)
 {
 	struct file *filp = iocb->ki_filp;
+	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	struct file_ra_state *ra = &filp->f_ra;
 	size_t orig_count = iov_iter_count(iter);
-	pgoff_t last_index;
-	int error = 0;
+	struct page *page_array[8], **pages;
+	unsigned nr_pages = ARRAY_SIZE(page_array);
+	unsigned read_nr_pages = ((iocb->ki_pos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT) -
+		(iocb->ki_pos >> PAGE_SHIFT);
+	int i, pg_nr, error = 0;
+	bool writably_mapped;
+	loff_t isize, end_offset;
 
 	if (unlikely(iocb->ki_pos >= inode->i_sb->s_maxbytes))
 		return 0;
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
 
-	last_index = (iocb->ki_pos + iter->count + PAGE_SIZE-1) >> PAGE_SHIFT;
-
-	for (;;) {
-		pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
-		struct page *page;
+	if (read_nr_pages > nr_pages &&
+	    (pages = kmalloc_array(read_nr_pages, sizeof(void *), GFP_KERNEL)))
+		nr_pages = read_nr_pages;
+	else
+		pages = page_array;
 
+	do {
 		cond_resched();
-find_page:
-		if (fatal_signal_pending(current)) {
-			error = -EINTR;
-			goto out;
-		}
 
-		page = find_get_page(mapping, index);
-		if (!page) {
-			if (iocb->ki_flags & IOCB_NOWAIT)
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
+		i = 0;
+		pg_nr = generic_file_buffered_read_get_pages(iocb, iter,
+							 pages, nr_pages);
+		if (pg_nr < 0) {
+			error = pg_nr;
+			break;
 		}
-		if (PageReadahead(page)) {
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
 
-			page = generic_file_buffered_read_pagenotuptodate(filp,
-					iter, page, iocb->ki_pos, iter->count);
-			if (!page)
-				goto find_page;
-			if (IS_ERR(page)) {
-				error = PTR_ERR(page);
-				goto out;
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
+
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
+			unsigned offset = iocb->ki_pos & ~PAGE_MASK;
+			unsigned bytes = min_t(loff_t, end_offset - iocb->ki_pos,
+					       PAGE_SIZE - offset);
+			unsigned copied;
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
+			iocb->ki_pos += copied;
+			ra->prev_pos = iocb->ki_pos;
+
+			if (copied < bytes) {
+				error = -EFAULT;
+				break;
 			}
 		}
+put_pages:
+		for (i = 0; i < pg_nr; i++)
+			put_page(pages[i]);
+	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
-		error = generic_file_buffered_read_page_ok(iocb, iter, page);
-		put_page(page);
-
-		if (error) {
-			if (error > 0)
-				error = 0;
-			goto out;
-		}
-	}
