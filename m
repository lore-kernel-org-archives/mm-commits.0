From: akpm@linux-foundation.org
Subject: + kill-generic_file_direct_io.patch added to -mm tree
Date: Mon, 12 May 2008 15:47:08 -0700
Message-ID: <200805122247.m4CMl8w2013034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbYELWrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de


The patch titled
     kill generic_file_direct_IO()
has been added to the -mm tree.  Its filename is
     kill-generic_file_direct_io.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill generic_file_direct_IO()
From: Christoph Hellwig <hch@lst.de>

generic_file_direct_IO is a common helper around the invocation of
->direct_IO.  But there's almost nothing shared between the read and write
side, so we're better off without this helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |  117 +++++++++++++++++++++----------------------------
 1 file changed, 51 insertions(+), 66 deletions(-)

diff -puN mm/filemap.c~kill-generic_file_direct_io mm/filemap.c
--- a/mm/filemap.c~kill-generic_file_direct_io
+++ a/mm/filemap.c
@@ -42,9 +42,6 @@
 
 #include <asm/mman.h>
 
-static ssize_t
-generic_file_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs);
 
 /*
  * Shared mappings implemented 30.11.1994. It's not fully working yet,
@@ -1204,8 +1201,11 @@ generic_file_aio_read(struct kiocb *iocb
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
-			retval = generic_file_direct_IO(READ, iocb,
-						iov, pos, nr_segs);
+			retval = filemap_write_and_wait(mapping);
+			if (!retval) {
+				retval = mapping->a_ops->direct_IO(READ, iocb,
+							iov, pos, nr_segs);
+			}
 			if (retval > 0)
 				*ppos = pos + retval;
 		}
@@ -2003,11 +2003,55 @@ generic_file_direct_write(struct kiocb *
 	struct address_space *mapping = file->f_mapping;
 	struct inode	*inode = mapping->host;
 	ssize_t		written;
+	size_t		write_len;
+	pgoff_t		end;
 
 	if (count != ocount)
 		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
 
-	written = generic_file_direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+	/*
+	 * Unmap all mmappings of the file up-front.
+	 *
+	 * This will cause any pte dirty bits to be propagated into the
+	 * pageframes for the subsequent filemap_write_and_wait().
+	 */
+	write_len = iov_length(iov, *nr_segs);
+	end = (pos + write_len - 1) >> PAGE_CACHE_SHIFT;
+       	if (mapping_mapped(mapping))
+		unmap_mapping_range(mapping, pos, write_len, 0);
+
+	written = filemap_write_and_wait(mapping);
+	if (written)
+		goto out;
+
+	/*
+	 * After a write we want buffered reads to be sure to go to disk to get
+	 * the new data.  We invalidate clean cached page from the region we're
+	 * about to write.  We do this *before* the write so that we can return
+	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
+	 */
+	if (mapping->nrpages) {
+		written = invalidate_inode_pages2_range(mapping,
+					pos >> PAGE_CACHE_SHIFT, end);
+		if (written)
+			goto out;
+	}
+
+	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+
+	/*
+	 * Finally, try again to invalidate clean pages which might have been
+	 * cached by non-direct readahead, or faulted in by get_user_pages()
+	 * if the source of the write was an mmap'ed region of the file
+	 * we're writing.  Either one is a pretty crazy thing to do,
+	 * so we don't support it 100%.  If this invalidation
+	 * fails, tough, the write still worked...
+	 */
+	if (mapping->nrpages) {
+		invalidate_inode_pages2_range(mapping,
+					      pos >> PAGE_CACHE_SHIFT, end);
+	}
+
 	if (written > 0) {
 		loff_t end = pos + written;
 		if (end > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
@@ -2023,6 +2067,7 @@ generic_file_direct_write(struct kiocb *
 	 * i_mutex is held, which protects generic_osync_inode() from
 	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
 	 */
+out:
 	if ((written >= 0 || written == -EIOCBQUEUED) &&
 	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		int err = generic_osync_inode(inode, mapping, OSYNC_METADATA);
@@ -2510,66 +2555,6 @@ ssize_t generic_file_aio_write(struct ki
 }
 EXPORT_SYMBOL(generic_file_aio_write);
 
-/*
- * Called under i_mutex for writes to S_ISREG files.   Returns -EIO if something
- * went wrong during pagecache shootdown.
- */
-static ssize_t
-generic_file_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs)
-{
-	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	ssize_t retval;
-	size_t write_len;
-	pgoff_t end = 0; /* silence gcc */
-
-	/*
-	 * If it's a write, unmap all mmappings of the file up-front.  This
-	 * will cause any pte dirty bits to be propagated into the pageframes
-	 * for the subsequent filemap_write_and_wait().
-	 */
-	if (rw == WRITE) {
-		write_len = iov_length(iov, nr_segs);
-		end = (offset + write_len - 1) >> PAGE_CACHE_SHIFT;
-	       	if (mapping_mapped(mapping))
-			unmap_mapping_range(mapping, offset, write_len, 0);
-	}
-
-	retval = filemap_write_and_wait(mapping);
-	if (retval)
-		goto out;
-
-	/*
-	 * After a write we want buffered reads to be sure to go to disk to get
-	 * the new data.  We invalidate clean cached page from the region we're
-	 * about to write.  We do this *before* the write so that we can return
-	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
-	 */
-	if (rw == WRITE && mapping->nrpages) {
-		retval = invalidate_inode_pages2_range(mapping,
-					offset >> PAGE_CACHE_SHIFT, end);
-		if (retval)
-			goto out;
-	}
-
-	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
-
-	/*
-	 * Finally, try again to invalidate clean pages which might have been
-	 * cached by non-direct readahead, or faulted in by get_user_pages()
-	 * if the source of the write was an mmap'ed region of the file
-	 * we're writing.  Either one is a pretty crazy thing to do,
-	 * so we don't support it 100%.  If this invalidation
-	 * fails, tough, the write still worked...
-	 */
-	if (rw == WRITE && mapping->nrpages) {
-		invalidate_inode_pages2_range(mapping, offset >> PAGE_CACHE_SHIFT, end);
-	}
-out:
-	return retval;
-}
