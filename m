From: akpm@linux-foundation.org
Subject: + ntfs-remove-ntfs_file_write.patch added to -mm tree
Date: Mon, 24 Aug 2009 15:04:26 -0700
Message-ID: <200908242204.n7OM4Q1L002383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526AbZHXWFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 18:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, aia21@cantab.net


The patch titled
     ntfs: remove ntfs_file_write
has been added to the -mm tree.  Its filename is
     ntfs-remove-ntfs_file_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2154,46 +2154,6 @@ static ssize_t ntfs_file_aio_write(struc
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
-	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-		int err = sync_page_range(inode, mapping, *ppos - ret, ret);
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
@@ -2255,7 +2215,7 @@ const struct file_operations ntfs_file_o
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

linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-fix-d_path-for-unreachable-paths.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
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
frv-convert-to-asm-generic-hardirqh.patch
h8300-convert-to-asm-generic-hardirqh.patch
alpha-convert-to-asm-generic-hardirqh.patch
m32r-convert-to-asm-generic-hardirqh.patch
m68k-convert-to-asm-generic-hardirqh.patch
cris-convert-to-asm-generic-hardirqh.patch
um-convert-to-asm-generic-hardirqh.patch
fs-turn-iprune_mutex-into-rwsem.patch
ntfs-remove-ntfs_file_write.patch
fcntl-add-f_etown_ex.patch

