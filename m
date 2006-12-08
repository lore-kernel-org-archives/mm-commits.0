From: akpm@osdl.org
Subject: - add-address_space_operationsbatch_write.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:06 -0800
Message-ID: <200612081105.kB8B566V018616@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49418 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425402AbWLHLKF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:10:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, akpm@osdl.org, hch@lst.de, mark.fasheh@oracle.com, miklos@szeredi.hu, nathans@sgi.com, reiser@namesys.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     add address_space_operations.batch_write
has been removed from the -mm tree.  Its filename was
     add-address_space_operationsbatch_write.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: add address_space_operations.batch_write
From: Vladimir Saveliev <vs@namesys.com>

Add a method batch_write to struct address_space_operations.  A filesystem
may want to implement this operation to improve write performance.  Generic
implementation for the method is made by cut-n-paste off
generic_file_buffered_write: it writes one page using prepare_write and
commit_write address space operations.

It is anticipated that this interface will be of benefit to Reiser4, FUSE,
maybe XFS, and GFS2.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hans Reiser <reiser@namesys.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nathan Scott <nathans@sgi.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
DESC
add-address_space_operationsbatch_write-fix
EDESC

RLIMIT_FSIZE can cause generic_write_checks() to reduce `count'.  So we cannot
assume that `count' is equal to the total size of the incoming iovec.

Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hans Reiser <reiser@namesys.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nathan Scott <nathans@sgi.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/vfs.txt |   13 +
 include/linux/fs.h                |   22 ++
 mm/filemap.c                      |  246 ++++++++++++++++------------
 3 files changed, 179 insertions(+), 102 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~add-address_space_operationsbatch_write Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~add-address_space_operationsbatch_write
+++ a/Documentation/filesystems/vfs.txt
@@ -534,6 +534,8 @@ struct address_space_operations {
 			struct list_head *pages, unsigned nr_pages);
 	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
 	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
+	long (*batch_write)(struct file *file, struct write_descriptor *desc,
+			    size_t *written);
 	sector_t (*bmap)(struct address_space *, sector_t);
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
@@ -624,6 +626,17 @@ struct address_space_operations {
         operations.  It should avoid returning an error if possible -
         errors should have been handled by prepare_write.
 
+  batch_write: optional
+        When calling the filesystem for writes, there is processing
+        that must be done:
+        1) per word
+        2) per page
+        3) per call to the FS
+        If the FS is called per page, then it turns out that 3) costs more
+        than 1) and 2) for sophisticated filesystems.  To allow the FS to
+        choose to pay the cost of 3) only once we call batch_write, if the
+        FS supports it.
+
   bmap: called by the VFS to map a logical block offset within object to
   	physical block number. This method is used by the FIBMAP
   	ioctl and for working with swap-files.  To be able to swap to
diff -puN include/linux/fs.h~add-address_space_operationsbatch_write include/linux/fs.h
--- a/include/linux/fs.h~add-address_space_operationsbatch_write
+++ a/include/linux/fs.h
@@ -292,6 +292,7 @@ struct poll_table_struct;
 struct kstatfs;
 struct vm_area_struct;
 struct vfsmount;
+struct pagevec;
 
 extern void __init inode_init(unsigned long);
 extern void __init inode_init_early(void);
@@ -393,6 +394,25 @@ struct page;
 struct address_space;
 struct writeback_control;
 
+/**
+ * struct write_descriptor - set of write arguments
+ * @pos: offset from the start of the file to write to
+ * @count: number of bytes to write
+ * @buf: pointer to data to be written
+ * @lru_pvec: multipage container to batch adding pages to LRU list
+ * @cached_page: allocated but not used on previous call
+ *
+ * This structure is to pass to batch_write file operation all
+ * information which is needed to continue write.
+ */
+struct write_descriptor {
+	loff_t pos;
+	size_t count;
+	char __user *buf;
+	struct page *cached_page;
+	struct pagevec *lru_pvec;
+};
+
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	int (*readpage)(struct file *, struct page *);
@@ -413,6 +433,8 @@ struct address_space_operations {
 	 */
 	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
 	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
+	long (*batch_write)(struct file *file, struct write_descriptor *desc,
+			    size_t *written);
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
diff -puN mm/filemap.c~add-address_space_operationsbatch_write mm/filemap.c
--- a/mm/filemap.c~add-address_space_operationsbatch_write
+++ a/mm/filemap.c
@@ -2058,78 +2058,59 @@ generic_file_direct_write(struct kiocb *
 }
 EXPORT_SYMBOL(generic_file_direct_write);
 
-ssize_t
-generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long nr_segs, loff_t pos, loff_t *ppos,
-		size_t count, ssize_t written)
+/**
+ * generic_batch_write - generic batch_write address space operation
+ * @file: the file to write to
+ * @desc: set of write arguments
+ * @written: returned number of bytes successfully written
+ *
+ * This implementation of batch_write address space operation writes not more
+ * than one page of file. It faults in user space, allocates page and calls
+ * prepare_write and commit_write address space operations. User data are
+ * copied by filemap_copy_from_user.
+ */
+static long generic_batch_write(struct file *file,
+				struct write_descriptor *desc,
+				size_t *written)
 {
-	struct file *file = iocb->ki_filp;
-	struct address_space * mapping = file->f_mapping;
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	struct inode 	*inode = mapping->host;
-	long		status = 0;
-	struct page	*page;
-	struct page	*cached_page = NULL;
-	size_t		bytes;
-	struct pagevec	lru_pvec;
-	const struct iovec *cur_iov = iov; /* current iovec */
-	size_t		iov_base = 0;	   /* offset in the current iovec */
-	char __user	*buf;
-
-	pagevec_init(&lru_pvec, 0);
-
-	/*
-	 * handle partial DIO write.  Adjust cur_iov if needed.
-	 */
-	if (likely(nr_segs == 1))
-		buf = iov->iov_base + written;
-	else {
-		filemap_set_next_iovec(&cur_iov, &iov_base, written);
-		buf = cur_iov->iov_base + iov_base;
-	}
-
-	do {
-		unsigned long index;
-		unsigned long offset;
-		size_t copied;
-
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = PAGE_CACHE_SIZE - offset;
-
-		/* Limit the size of the copy to the caller's write size */
-		bytes = min(bytes, count);
-
-		/*
-		 * Limit the size of the copy to that of the current segment,
-		 * because fault_in_pages_readable() doesn't know how to walk
-		 * segments.
-		 */
-		bytes = min(bytes, cur_iov->iov_len - iov_base);
+  	const struct address_space_operations *a_ops = file->f_mapping->a_ops;
+	struct page *page;
+	pgoff_t index;
+	size_t bytes;
+	unsigned long offset;
+	long status;
+
+	/* offset within page write is to start at */
+	offset = (desc->pos & (PAGE_CACHE_SIZE - 1));
+
+	/* index of page we are to write to */
+	index = desc->pos >> PAGE_CACHE_SHIFT;
+
+	/* number of bytes which can be written to the page */
+	bytes = PAGE_CACHE_SIZE - offset;
+
+	/* limit the size of the copy to the caller's write size */
+	bytes = min(bytes, desc->count);
+	BUG_ON(bytes == 0);
 
+	while (1) {
 		/*
 		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
+		 * Otherwise there's a nasty deadlock on copying from the same
+		 * page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		fault_in_pages_readable(buf, bytes);
+		fault_in_pages_readable(desc->buf, bytes);
 
-		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
-		if (!page) {
-			status = -ENOMEM;
-			break;
-		}
-
-		if (unlikely(bytes == 0)) {
-			status = 0;
-			copied = 0;
-			goto zero_length_segment;
-		}
+		page = __grab_cache_page(file->f_mapping, index,
+					 &desc->cached_page, desc->lru_pvec);
+		if (!page)
+			return -ENOMEM;
 
-		status = a_ops->prepare_write(file, page, offset, offset+bytes);
+		status = a_ops->prepare_write(file, page, offset,
+					      offset+bytes);
 		if (unlikely(status)) {
-			loff_t isize = i_size_read(inode);
+			loff_t isize = i_size_read(file->f_mapping->host);
 
 			if (status != AOP_TRUNCATED_PAGE)
 				unlock_page(page);
@@ -2140,58 +2121,119 @@ generic_file_buffered_write(struct kiocb
 			 * prepare_write() may have instantiated a few blocks
 			 * outside i_size.  Trim these off again.
 			 */
-			if (pos + bytes > isize)
-				vmtruncate(inode, isize);
-			break;
+			if (desc->pos + bytes > isize)
+				vmtruncate(file->f_mapping->host, isize);
+			return status;
 		}
-		if (likely(nr_segs == 1))
-			copied = filemap_copy_from_user(page, offset,
-							buf, bytes);
-		else
-			copied = filemap_copy_from_user_iovec(page, offset,
-						cur_iov, iov_base, bytes);
+
+		/* copy user data to the page */
+		*written = filemap_copy_from_user(page, offset, desc->buf,
+						  bytes);
+
 		flush_dcache_page(page);
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
 		if (status == AOP_TRUNCATED_PAGE) {
 			page_cache_release(page);
 			continue;
 		}
-zero_length_segment:
-		if (likely(copied >= 0)) {
-			if (!status)
-				status = copied;
+  		unlock_page(page);
+  		mark_page_accessed(page);
+  		page_cache_release(page);
+		break;
+	}
+	/*
+	 * If commit_write returned error - write failed and we zero number of
+	 * written bytes. If filemap_copy_from_user copied less than it was
+	 * asked to we return -EFAULT and number of bytes actually written.
+	 */
+	if (status)
+		*written = 0;
+	else if (*written != bytes)
+		status = -EFAULT;
+	return status;
+}
+
+ssize_t
+generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
+			    unsigned long nr_segs, loff_t pos, loff_t *ppos,
+			    size_t count, ssize_t written)
+{
+	struct file *file = iocb->ki_filp;
+	struct address_space * mapping = file->f_mapping;
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	struct inode 	*inode = mapping->host;
+	long		status;
+	struct pagevec	lru_pvec;
+	struct write_descriptor desc;
+	size_t copied = 0;
+        const struct iovec *cur_iov = iov; /* current iovec */
+        size_t          iov_base = 0;      /* offset in the current iovec */
+	long (*batch_write)(struct file *file,
+			    struct write_descriptor *desc,
+			    size_t *written);
+
+	pagevec_init(&lru_pvec, 0);
 
-			if (status >= 0) {
-				written += status;
-				count -= status;
-				pos += status;
-				buf += status;
-				if (unlikely(nr_segs > 1)) {
+	/*
+	 * initialize write descriptor fields: position to write to
+	 * and number of bytes to write
+	 */
+	desc.pos = pos;
+	desc.cached_page = NULL;
+	desc.lru_pvec = &lru_pvec;
+
+	/*
+	 * handle partial DIO write.  Adjust cur_iov if needed.
+	 */
+	if (likely(nr_segs == 1))
+		iov_base = written;
+	else
+                filemap_set_next_iovec(&cur_iov, &iov_base, written);
+
+	/*
+	 * if file system implements batch_write method - use it, otherwise -
+	 * use generic_batch_write
+	 */
+	batch_write = generic_batch_write;
+	if (a_ops->batch_write)
+		batch_write = a_ops->batch_write;
+
+	do {
+		/* do not walk over current segment */
+		desc.buf = cur_iov->iov_base + iov_base;
+		desc.count = min(count, cur_iov->iov_len - iov_base);
+		if (desc.count > 0)
+			status = (*batch_write)(file, &desc, &copied);
+		else {
+			copied = 0;
+			status = 0;
+		}
+		if (likely(copied >= 0)) {
+			written += copied;
+			count -= copied;
+			if (count) {
+				/*
+				 * not everything is written yet. Adjust write
+				 * descriptor for next iteration
+				 */
+				desc.pos += copied;
+				if (likely(nr_segs == 1))
+					iov_base += copied;
+				else
 					filemap_set_next_iovec(&cur_iov,
-							&iov_base, status);
-					if (count)
-						buf = cur_iov->iov_base +
-							iov_base;
-				} else {
-					iov_base += status;
-				}
+							       &iov_base,
+							       copied);
 			}
 		}
-		if (unlikely(copied != bytes))
-			if (status >= 0)
-				status = -EFAULT;
-		unlock_page(page);
-		mark_page_accessed(page);
-		page_cache_release(page);
-		if (status < 0)
-			break;
-		balance_dirty_pages_ratelimited(mapping);
-		cond_resched();
+  		if (status < 0)
+  			break;
+  		balance_dirty_pages_ratelimited(mapping);
+  		cond_resched();
 	} while (count);
-	*ppos = pos;
+	*ppos = pos + written;
 
-	if (cached_page)
-		page_cache_release(cached_page);
+  	if (desc.cached_page)
+  		page_cache_release(desc.cached_page);
 
 	/*
 	 * For now, when the user asks for O_SYNC, we'll actually give O_DSYNC
_

Patches currently in -mm which might be from vs@namesys.com are

origin.patch
reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-bug-fixes.patch
reiser4-fix-gcc-ws-compains.patch
fs-reiser4-possible-cleanups.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-possible-cleanups-2.patch
reiser4-temp-fix.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch

