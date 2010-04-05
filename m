From: akpm@linux-foundation.org
Subject: + raw-fsync-method-is-now-required.patch added to -mm tree
Date: Mon, 05 Apr 2010 13:39:08 -0700
Message-ID: <201004052039.o35Kd8w0007795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab0DEUj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 16:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, hch@lst.de, jack@suse.cz, jens.axboe@oracle.com, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     raw: fsync method is now required
has been added to the -mm tree.  Its filename is
     raw-fsync-method-is-now-required.patch

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
Subject: raw: fsync method is now required
From: Anton Blanchard <anton@samba.org>

Commit 148f948ba877f4d3cdef036b1ff6d9f68986706a (vfs: Introduce new
helpers for syncing after writing to O_SYNC file or IS_SYNC inode) broke
the raw driver.

We now call through generic_file_aio_write -> generic_write_sync ->
vfs_fsync_range.  vfs_fsync_range has:

        if (!fop || !fop->fsync) {
                ret = -EINVAL;
                goto out;
        }

But drivers/char/raw.c doesn't set an fsync method.

We have two options: fix it or remove the raw driver completely.  I'm
happy to do either, the fact this has been broken for so long suggests it
is rarely used.

The patch below adds an fsync method to the raw driver.  My knowledge of
the block layer is pretty sketchy so this could do with a once over.

If we instead decide to remove the raw driver, this patch might still be
useful as a backport to 2.6.33 and 2.6.32.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/raw.c |    1 +
 fs/block_dev.c     |    3 ++-
 include/linux/fs.h |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/raw.c~raw-fsync-method-is-now-required drivers/char/raw.c
--- a/drivers/char/raw.c~raw-fsync-method-is-now-required
+++ a/drivers/char/raw.c
@@ -248,6 +248,7 @@ static const struct file_operations raw_
 	.aio_read = 	generic_file_aio_read,
 	.write	=	do_sync_write,
 	.aio_write =	blkdev_aio_write,
+	.fsync	=	block_fsync,
 	.open	=	raw_open,
 	.release=	raw_release,
 	.ioctl	=	raw_ioctl,
diff -puN fs/block_dev.c~raw-fsync-method-is-now-required fs/block_dev.c
--- a/fs/block_dev.c~raw-fsync-method-is-now-required
+++ a/fs/block_dev.c
@@ -404,7 +404,7 @@ static loff_t block_llseek(struct file *
  *	NULL first argument is nfsd_sync_dir() and that's not a directory.
  */
  
-static int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
+int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
 {
 	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
 	int error;
@@ -418,6 +418,7 @@ static int block_fsync(struct file *filp
 		error = 0;
 	return error;
 }
+EXPORT_SYMBOL(block_fsync);
 
 /*
  * pseudo-fs
diff -puN include/linux/fs.h~raw-fsync-method-is-now-required include/linux/fs.h
--- a/include/linux/fs.h~raw-fsync-method-is-now-required
+++ a/include/linux/fs.h
@@ -2212,6 +2212,7 @@ extern int generic_segment_checks(const 
 /* fs/block_dev.c */
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
+extern int block_fsync(struct file *filp, struct dentry *dentry, int datasync);
 
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
_

Patches currently in -mm which might be from anton@samba.org are

devmem-handle-class_create-failure.patch
raw-fsync-method-is-now-required.patch

