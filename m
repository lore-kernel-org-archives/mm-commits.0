From: akpm@linux-foundation.org
Subject: + fs-remove-prepare_write-commit_write.patch added to -mm tree
Date: Tue, 21 Oct 2008 14:30:42 -0700
Message-ID: <200810212130.m9LLUgAV024425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbYJUVa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 17:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hch@lst.de


The patch titled
     fs: remove prepare_write/commit_write
has been added to the -mm tree.  Its filename is
     fs-remove-prepare_write-commit_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: remove prepare_write/commit_write
From: Nick Piggin <npiggin@suse.de>

Nothing uses prepare_write or commit_write. Remove them from the tree
completely.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |   12 -
 Documentation/filesystems/vfs.txt |   39 ----
 drivers/block/loop.c              |    5 
 fs/fat/inode.c                    |    2 
 fs/ocfs2/file.c                   |    3 
 fs/splice.c                       |    4 
 include/linux/fs.h                |    7 
 mm/filemap.c                      |  242 ----------------------------
 8 files changed, 22 insertions(+), 292 deletions(-)

diff -puN Documentation/filesystems/Locking~fs-remove-prepare_write-commit_write Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~fs-remove-prepare_write-commit_write
+++ a/Documentation/filesystems/Locking
@@ -161,8 +161,12 @@ prototypes:
 	int (*set_page_dirty)(struct page *page);
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
-	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
-	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
+	int (*write_begin)(struct file *, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata);
+	int (*write_end)(struct file *, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata);
 	sector_t (*bmap)(struct address_space *, sector_t);
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
@@ -180,8 +184,6 @@ sync_page:		no	maybe
 writepages:		no
 set_page_dirty		no	no
 readpages:		no
-prepare_write:		no	yes			yes
-commit_write:		no	yes			yes
 write_begin:		no	locks the page		yes
 write_end:		no	yes, unlocks		yes
 perform_write:		no	n/a			yes
@@ -191,7 +193,7 @@ releasepage:		no	yes
 direct_IO:		no
 launder_page:		no	yes
 
-	->prepare_write(), ->commit_write(), ->sync_page() and ->readpage()
+	->write_begin(), ->write_end(), ->sync_page() and ->readpage()
 may be called from the request handler (/dev/loop).
 
 	->readpage() unlocks the page, either synchronously or via I/O
diff -puN Documentation/filesystems/vfs.txt~fs-remove-prepare_write-commit_write Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~fs-remove-prepare_write-commit_write
+++ a/Documentation/filesystems/vfs.txt
@@ -492,7 +492,7 @@ written-back to storage typically in who
 address_space has finer control of write sizes.
 
 The read process essentially only requires 'readpage'.  The write
-process is more complicated and uses prepare_write/commit_write or
+process is more complicated and uses write_begin/write_end or
 set_page_dirty to write data into the address_space, and writepage,
 sync_page, and writepages to writeback data to storage.
 
@@ -521,8 +521,6 @@ struct address_space_operations {
 	int (*set_page_dirty)(struct page *page);
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
-	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
-	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
 	int (*write_begin)(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata);
@@ -598,37 +596,7 @@ struct address_space_operations {
 	readpages is only used for read-ahead, so read errors are
   	ignored.  If anything goes wrong, feel free to give up.
 
-  prepare_write: called by the generic write path in VM to set up a write
-  	request for a page.  This indicates to the address space that
-  	the given range of bytes is about to be written.  The
-  	address_space should check that the write will be able to
-  	complete, by allocating space if necessary and doing any other
-  	internal housekeeping.  If the write will update parts of
-  	any basic-blocks on storage, then those blocks should be
-  	pre-read (if they haven't been read already) so that the
-  	updated blocks can be written out properly.
-	The page will be locked.
-
-	Note: the page _must not_ be marked uptodate in this function
-	(or anywhere else) unless it actually is uptodate right now. As
-	soon as a page is marked uptodate, it is possible for a concurrent
-	read(2) to copy it to userspace.
-
-  commit_write: If prepare_write succeeds, new data will be copied
-        into the page and then commit_write will be called.  It will
-        typically update the size of the file (if appropriate) and
-        mark the inode as dirty, and do any other related housekeeping
-        operations.  It should avoid returning an error if possible -
-        errors should have been handled by prepare_write.
-
-  write_begin: This is intended as a replacement for prepare_write. The
-	key differences being that:
-		- it returns a locked page (in *pagep) rather than being
-		  given a pre locked page;
-		- it must be able to cope with short writes (where the
-		  length passed to write_begin is greater than the number
-		  of bytes copied into the page).
-
+  write_begin:
 	Called by the generic buffered write code to ask the filesystem to
 	prepare to write len bytes at the given offset in the file. The
 	address_space should check that the write will be able to complete,
@@ -640,6 +608,9 @@ struct address_space_operations {
         The filesystem must return the locked pagecache page for the specified
 	offset, in *pagep, for the caller to write into.
 
+	It must be able to cope with short writes (where the length passed to
+	write_begin is greater than the number of bytes copied into the page).
+
 	flags is a field for AOP_FLAG_xxx flags, described in
 	include/linux/fs.h.
 
diff -puN drivers/block/loop.c~fs-remove-prepare_write-commit_write drivers/block/loop.c
--- a/drivers/block/loop.c~fs-remove-prepare_write-commit_write
+++ a/drivers/block/loop.c
@@ -40,8 +40,7 @@
  * Heinz Mauelshagen <mge@sistina.com>, Feb 2002
  *
  * Support for falling back on the write file operation when the address space
- * operations prepare_write and/or commit_write are not available on the
- * backing filesystem.
+ * operations write_begin is not available on the backing filesystem.
  * Anton Altaparmakov, 16 Feb 2005
  *
  * Still To Fix:
@@ -766,7 +765,7 @@ static int loop_set_fd(struct loop_devic
 		 */
 		if (!file->f_op->splice_read)
 			goto out_putf;
-		if (aops->prepare_write || aops->write_begin)
+		if (aops->write_begin)
 			lo_flags |= LO_FLAGS_USE_AOPS;
 		if (!(lo_flags & LO_FLAGS_USE_AOPS) && !file->f_op->write)
 			lo_flags |= LO_FLAGS_READ_ONLY;
diff -puN fs/fat/inode.c~fs-remove-prepare_write-commit_write fs/fat/inode.c
--- a/fs/fat/inode.c~fs-remove-prepare_write-commit_write
+++ a/fs/fat/inode.c
@@ -175,7 +175,7 @@ static ssize_t fat_direct_IO(int rw, str
 
 	if (rw == WRITE) {
 		/*
-		 * FIXME: blockdev_direct_IO() doesn't use ->prepare_write(),
+		 * FIXME: blockdev_direct_IO() doesn't use ->write_begin(),
 		 * so we need to update the ->mmu_private to block boundary.
 		 *
 		 * But we must fill the remaining area or hole by nul for
diff -puN fs/ocfs2/file.c~fs-remove-prepare_write-commit_write fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~fs-remove-prepare_write-commit_write
+++ a/fs/ocfs2/file.c
@@ -679,8 +679,7 @@ leave:
 
 /* Some parts of this taken from generic_cont_expand, which turned out
  * to be too fragile to do exactly what we need without us having to
- * worry about recursive locking in ->prepare_write() and
- * ->commit_write(). */
+ * worry about recursive locking in ->write_begin() and ->write_end(). */
 static int ocfs2_write_zero_page(struct inode *inode,
 				 u64 size)
 {
diff -puN fs/splice.c~fs-remove-prepare_write-commit_write fs/splice.c
--- a/fs/splice.c~fs-remove-prepare_write-commit_write
+++ a/fs/splice.c
@@ -731,8 +731,8 @@ ssize_t splice_from_pipe(struct pipe_ino
 	};
 
 	/*
-	 * The actor worker might be calling ->prepare_write and
-	 * ->commit_write. Most of the time, these expect i_mutex to
+	 * The actor worker might be calling ->write_begin and
+	 * ->write_end. Most of the time, these expect i_mutex to
 	 * be held. Since this may result in an ABBA deadlock with
 	 * pipe->inode, we have to order lock acquiry here.
 	 */
diff -puN include/linux/fs.h~fs-remove-prepare_write-commit_write include/linux/fs.h
--- a/include/linux/fs.h~fs-remove-prepare_write-commit_write
+++ a/include/linux/fs.h
@@ -484,13 +484,6 @@ struct address_space_operations {
 	int (*readpages)(struct file *filp, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
 
-	/*
-	 * ext3 requires that a successful prepare_write() call be followed
-	 * by a commit_write() call - they must be balanced
-	 */
-	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
-	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
-
 	int (*write_begin)(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata);
diff -puN mm/filemap.c~fs-remove-prepare_write-commit_write mm/filemap.c
--- a/mm/filemap.c~fs-remove-prepare_write-commit_write
+++ a/mm/filemap.c
@@ -2029,48 +2029,8 @@ int pagecache_write_begin(struct file *f
 {
 	const struct address_space_operations *aops = mapping->a_ops;
 
-	if (aops->write_begin) {
-		return aops->write_begin(file, mapping, pos, len, flags,
+	return aops->write_begin(file, mapping, pos, len, flags,
 							pagep, fsdata);
-	} else {
-		int ret;
-		pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
-		struct inode *inode = mapping->host;
-		struct page *page;
-again:
-		page = __grab_cache_page(mapping, index);
-		*pagep = page;
-		if (!page)
-			return -ENOMEM;
-
-		if (flags & AOP_FLAG_UNINTERRUPTIBLE && !PageUptodate(page)) {
-			/*
-			 * There is no way to resolve a short write situation
-			 * for a !Uptodate page (except by double copying in
-			 * the caller done by generic_perform_write_2copy).
-			 *
-			 * Instead, we have to bring it uptodate here.
-			 */
-			ret = aops->readpage(file, page);
-			page_cache_release(page);
-			if (ret) {
-				if (ret == AOP_TRUNCATED_PAGE)
-					goto again;
-				return ret;
-			}
-			goto again;
-		}
-
-		ret = aops->prepare_write(file, page, offset, offset+len);
-		if (ret) {
-			unlock_page(page);
-			page_cache_release(page);
-			if (pos + len > inode->i_size)
-				vmtruncate(inode, inode->i_size);
-		}
-		return ret;
-	}
 }
 EXPORT_SYMBOL(pagecache_write_begin);
 
@@ -2079,32 +2039,9 @@ int pagecache_write_end(struct file *fil
 				struct page *page, void *fsdata)
 {
 	const struct address_space_operations *aops = mapping->a_ops;
-	int ret;
-
-	if (aops->write_end) {
-		mark_page_accessed(page);
-		ret = aops->write_end(file, mapping, pos, len, copied,
-							page, fsdata);
-	} else {
-		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
-		struct inode *inode = mapping->host;
-
-		flush_dcache_page(page);
-		ret = aops->commit_write(file, page, offset, offset+len);
-		unlock_page(page);
-		mark_page_accessed(page);
-		page_cache_release(page);
 
-		if (ret < 0) {
-			if (pos + len > inode->i_size)
-				vmtruncate(inode, inode->i_size);
-		} else if (ret > 0)
-			ret = min_t(size_t, copied, ret);
-		else
-			ret = copied;
-	}
-
-	return ret;
+	mark_page_accessed(page);
+	return aops->write_end(file, mapping, pos, len, copied, page, fsdata);
 }
 EXPORT_SYMBOL(pagecache_write_end);
 
@@ -2226,174 +2163,6 @@ repeat:
 }
 EXPORT_SYMBOL(__grab_cache_page);
 
-static ssize_t generic_perform_write_2copy(struct file *file,
-				struct iov_iter *i, loff_t pos)
-{
-	struct address_space *mapping = file->f_mapping;
-	const struct address_space_operations *a_ops = mapping->a_ops;
-	struct inode *inode = mapping->host;
-	long status = 0;
-	ssize_t written = 0;
-
-	do {
-		struct page *src_page;
-		struct page *page;
-		pgoff_t index;		/* Pagecache index for current page */
-		unsigned long offset;	/* Offset into pagecache page */
-		unsigned long bytes;	/* Bytes to write to page */
-		size_t copied;		/* Bytes copied from user */
-
-		offset = (pos & (PAGE_CACHE_SIZE - 1));
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
-						iov_iter_count(i));
-
-		/*
-		 * a non-NULL src_page indicates that we're doing the
-		 * copy via get_user_pages and kmap.
-		 */
-		src_page = NULL;
-
-		/*
-		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 *
-		 * Not only is this an optimisation, but it is also required
-		 * to check that the address is actually valid, when atomic
-		 * usercopies are used, below.
-		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
-			status = -EFAULT;
-			break;
-		}
-
-		page = __grab_cache_page(mapping, index);
-		if (!page) {
-			status = -ENOMEM;
-			break;
-		}
-
-		/*
-		 * non-uptodate pages cannot cope with short copies, and we
-		 * cannot take a pagefault with the destination page locked.
-		 * So pin the source page to copy it.
-		 */
-		if (!PageUptodate(page) && !segment_eq(get_fs(), KERNEL_DS)) {
-			unlock_page(page);
-
-			src_page = alloc_page(GFP_KERNEL);
-			if (!src_page) {
-				page_cache_release(page);
-				status = -ENOMEM;
-				break;
-			}
-
-			/*
-			 * Cannot get_user_pages with a page locked for the
-			 * same reason as we can't take a page fault with a
-			 * page locked (as explained below).
-			 */
-			copied = iov_iter_copy_from_user(src_page, i,
-								offset, bytes);
-			if (unlikely(copied == 0)) {
-				status = -EFAULT;
-				page_cache_release(page);
-				page_cache_release(src_page);
-				break;
-			}
-			bytes = copied;
-
-			lock_page(page);
-			/*
-			 * Can't handle the page going uptodate here, because
-			 * that means we would use non-atomic usercopies, which
-			 * zero out the tail of the page, which can cause
-			 * zeroes to become transiently visible. We could just
-			 * use a non-zeroing copy, but the APIs aren't too
-			 * consistent.
-			 */
-			if (unlikely(!page->mapping || PageUptodate(page))) {
-				unlock_page(page);
-				page_cache_release(page);
-				page_cache_release(src_page);
-				continue;
-			}
-		}
-
-		status = a_ops->prepare_write(file, page, offset, offset+bytes);
-		if (unlikely(status))
-			goto fs_write_aop_error;
-
-		if (!src_page) {
-			/*
-			 * Must not enter the pagefault handler here, because
-			 * we hold the page lock, so we might recursively
-			 * deadlock on the same lock, or get an ABBA deadlock
-			 * against a different lock, or against the mmap_sem
-			 * (which nests outside the page lock).  So increment
-			 * preempt count, and use _atomic usercopies.
-			 *
-			 * The page is uptodate so we are OK to encounter a
-			 * short copy: if unmodified parts of the page are
-			 * marked dirty and written out to disk, it doesn't
-			 * really matter.
-			 */
-			pagefault_disable();
-			copied = iov_iter_copy_from_user_atomic(page, i,
-								offset, bytes);
-			pagefault_enable();
-		} else {
-			void *src, *dst;
-			src = kmap_atomic(src_page, KM_USER0);
-			dst = kmap_atomic(page, KM_USER1);
-			memcpy(dst + offset, src + offset, bytes);
-			kunmap_atomic(dst, KM_USER1);
-			kunmap_atomic(src, KM_USER0);
-			copied = bytes;
-		}
-		flush_dcache_page(page);
-
-		status = a_ops->commit_write(file, page, offset, offset+bytes);
-		if (unlikely(status < 0))
-			goto fs_write_aop_error;
-		if (unlikely(status > 0)) /* filesystem did partial write */
-			copied = min_t(size_t, copied, status);
-
-		unlock_page(page);
-		mark_page_accessed(page);
-		page_cache_release(page);
-		if (src_page)
-			page_cache_release(src_page);
-
-		iov_iter_advance(i, copied);
-		pos += copied;
-		written += copied;
-
-		balance_dirty_pages_ratelimited(mapping);
-		cond_resched();
-		continue;
-
-fs_write_aop_error:
-		unlock_page(page);
-		page_cache_release(page);
-		if (src_page)
-			page_cache_release(src_page);
-
-		/*
-		 * prepare_write() may have instantiated a few blocks
-		 * outside i_size.  Trim these off again. Don't need
-		 * i_size_read because we hold i_mutex.
-		 */
-		if (pos + bytes > inode->i_size)
-			vmtruncate(inode, inode->i_size);
-		break;
-	} while (iov_iter_count(i));
-
-	return written ? written : status;
-}
-
 static ssize_t generic_perform_write(struct file *file,
 				struct iov_iter *i, loff_t pos)
 {
@@ -2494,10 +2263,7 @@ generic_file_buffered_write(struct kiocb
 	struct iov_iter i;
 
 	iov_iter_init(&i, iov, nr_segs, count, written);
-	if (a_ops->write_begin)
-		status = generic_perform_write(file, &i, pos);
-	else
-		status = generic_perform_write_2copy(file, &i, pos);
+	status = generic_perform_write(file, &i, pos);
 
 	if (likely(status >= 0)) {
 		written += status;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-increase-the-default-mlock-limit-from-32k-to-64k.patch
fs-remove-prepare_write-commit_write.patch
linux-next.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

