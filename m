From: akpm@linux-foundation.org
Subject: [merged] ntfs-remove-ntfs_file_write.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:14 -0700
Message-ID: <200909231953.n8NJrEc3030765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbZIWTxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     ntfs: remove ntfs_file_write
has been removed from the -mm tree.  Its filename was
     ntfs-remove-ntfs_file_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: remove ntfs_file_write
From: Christoph Hellwig <hch@lst.de>

do_sync_write() does the right thing for turning the aio_writev method
into a normal non-vectored synchronous write, no need to duplicate it in
ntfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c |   42 +-----------------------------------------
 1 file changed, 1 insertion(+), 41 deletions(-)

diff -puN fs/ntfs/file.c~ntfs-remove-ntfs_file_write fs/ntfs/file.c
--- a/fs/ntfs/file.c~ntfs-remove-ntfs_file_write
+++ a/fs/ntfs/file.c
@@ -2146,46 +2146,6 @@ static ssize_t ntfs_file_aio_write(struc
 }
 
 /**
- * ntfs_file_writev -
- *
- * Basically the same as generic_file_writev() except that it ends up calling
- * ntfs_file_aio_write_nolock() instead of __generic_file_aio_write_nolock().
- */
-static ssize_t ntfs_file_writev(struct file *file, const struct iovec *iov,
-		unsigned long nr_segs, loff_t *ppos)
-{
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	struct kiocb kiocb;
-	ssize_t ret;
-
-	mutex_lock(&inode->i_mutex);
-	init_sync_kiocb(&kiocb, file);
-	ret = ntfs_file_aio_write_nolock(&kiocb, iov, nr_segs, ppos);
-	if (ret == -EIOCBQUEUED)
-		ret = wait_on_sync_kiocb(&kiocb);
-	mutex_unlock(&inode->i_mutex);
-	if (ret > 0) {
-		int err = generic_write_sync(file, *ppos - ret, ret);
-		if (err < 0)
-			ret = err;
-	}
-	return ret;
-}
-
-/**
- * ntfs_file_write - simple wrapper for ntfs_file_writev()
- */
-static ssize_t ntfs_file_write(struct file *file, const char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct iovec local_iov = { .iov_base = (void __user *)buf,
-				   .iov_len = count };
-
-	return ntfs_file_writev(file, &local_iov, 1, ppos);
-}
-
-/**
  * ntfs_file_fsync - sync a file to disk
  * @filp:	file to be synced
  * @dentry:	dentry describing the file to sync
@@ -2247,7 +2207,7 @@ const struct file_operations ntfs_file_o
 	.read		= do_sync_read,		 /* Read from file. */
 	.aio_read	= generic_file_aio_read, /* Async read from file. */
 #ifdef NTFS_RW
-	.write		= ntfs_file_write,	 /* Write to file. */
+	.write		= do_sync_write,	 /* Write to file. */
 	.aio_write	= ntfs_file_aio_write,	 /* Async write to file. */
 	/*.release	= ,*/			 /* Last file is closed.  See
 						    fs/ext2/file.c::
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
vfs-seq_file-add-helpers-for-data-filling.patch
libfs-return-error-code-on-failed-attr-set.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
xtensa-convert-to-asm-generic-hardirqh.patch
fcntl-add-f_etown_ex.patch

