From: akpm@linux-foundation.org
Subject: + mm-clean-up-buffered-write-code.patch added to -mm tree
Date: Tue, 29 May 2007 14:19:39 -0700
Message-ID: <200705292119.l4TLJdqJ011696@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbXE2VTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, npiggin@suse.de


The patch titled
     mm: clean up buffered write code
has been added to the -mm tree.  Its filename is
     mm-clean-up-buffered-write-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: clean up buffered write code
From: Andrew Morton <akpm@osdl.org>

Rename some variables and fix some types.

Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/filemap.c~mm-clean-up-buffered-write-code mm/filemap.c
--- a/mm/filemap.c~mm-clean-up-buffered-write-code
+++ a/mm/filemap.c
@@ -1892,16 +1892,15 @@ generic_file_buffered_write(struct kiocb
 		size_t count, ssize_t written)
 {
 	struct file *file = iocb->ki_filp;
-	struct address_space * mapping = file->f_mapping;
+	struct address_space *mapping = file->f_mapping;
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	struct inode 	*inode = mapping->host;
 	long		status = 0;
 	struct page	*page;
 	struct page	*cached_page = NULL;
-	size_t		bytes;
 	struct pagevec	lru_pvec;
 	const struct iovec *cur_iov = iov; /* current iovec */
-	size_t		iov_base = 0;	   /* offset in the current iovec */
+	size_t		iov_offset = 0;	   /* offset in the current iovec */
 	char __user	*buf;
 
 	pagevec_init(&lru_pvec, 0);
@@ -1912,31 +1911,33 @@ generic_file_buffered_write(struct kiocb
 	if (likely(nr_segs == 1))
 		buf = iov->iov_base + written;
 	else {
-		filemap_set_next_iovec(&cur_iov, &iov_base, written);
-		buf = cur_iov->iov_base + iov_base;
+		filemap_set_next_iovec(&cur_iov, &iov_offset, written);
+		buf = cur_iov->iov_base + iov_offset;
 	}
 
 	do {
-		unsigned long index;
-		unsigned long offset;
-		unsigned long maxlen;
-		size_t copied;
+		pgoff_t index;		/* Pagecache index for current page */
+		unsigned long offset;	/* Offset into pagecache page */
+		unsigned long maxlen;	/* Bytes remaining in current iovec */
+		size_t bytes;		/* Bytes to write to page */
+		size_t copied;		/* Bytes copied from user */
 
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
+		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = PAGE_CACHE_SIZE - offset;
 		if (bytes > count)
 			bytes = count;
 
+		maxlen = cur_iov->iov_len - iov_offset;
+		if (maxlen > bytes)
+			maxlen = bytes;
+
 		/*
 		 * Bring in the user page that we will copy from _first_.
 		 * Otherwise there's a nasty deadlock on copying from the
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		maxlen = cur_iov->iov_len - iov_base;
-		if (maxlen > bytes)
-			maxlen = bytes;
 		fault_in_pages_readable(buf, maxlen);
 
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
@@ -1967,7 +1968,7 @@ generic_file_buffered_write(struct kiocb
 							buf, bytes);
 		else
 			copied = filemap_copy_from_user_iovec(page, offset,
-						cur_iov, iov_base, bytes);
+						cur_iov, iov_offset, bytes);
 		flush_dcache_page(page);
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
 		if (status == AOP_TRUNCATED_PAGE) {
@@ -1985,12 +1986,12 @@ generic_file_buffered_write(struct kiocb
 				buf += status;
 				if (unlikely(nr_segs > 1)) {
 					filemap_set_next_iovec(&cur_iov,
-							&iov_base, status);
+							&iov_offset, status);
 					if (count)
 						buf = cur_iov->iov_base +
-							iov_base;
+							iov_offset;
 				} else {
-					iov_base += status;
+					iov_offset += status;
 				}
 			}
 		}
_

Patches currently in -mm which might be from akpm@osdl.org are

update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
git-ipwireless_cs.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
