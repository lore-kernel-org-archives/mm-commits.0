From: akpm@linux-foundation.org
Subject: + blkdev-flush-disk-cache-on-fsync.patch added to -mm tree
Date: Sun, 11 Oct 2009 00:39:35 -0700
Message-ID: <200910110739.n9B7dZuR026019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbZJKHlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Oct 2009 03:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jack@suse.cz, jens.axboe@oracle.com


The patch titled
     blkdev: flush disk cache on ->fsync
has been added to the -mm tree.  Its filename is
     blkdev-flush-disk-cache-on-fsync.patch

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
Subject: blkdev: flush disk cache on ->fsync
From: Christoph Hellwig <hch@lst.de>

Currently there is no barrier support in the block device code.  That
means we cannot guarantee any sort of data integrity when using the block
device node with dis kwrite caches enabled.  Using the raw block device
node is a typical use case for virtualization (and I assume databases,
too).  This patch changes block_fsync to issue a cache flush and thus make
fsync on block device nodes actually useful.

Note that in mainline we would also need to add such code to the
->aio_write method for O_SYNC handling, but assuming that Jan's patch
series for the O_SYNC rewrite goes in it will also call into ->fsync for
2.6.32.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~blkdev-flush-disk-cache-on-fsync fs/block_dev.c
--- a/fs/block_dev.c~blkdev-flush-disk-cache-on-fsync
+++ a/fs/block_dev.c
@@ -405,7 +405,17 @@ static loff_t block_llseek(struct file *
  
 static int block_fsync(struct file *filp, struct dentry *dentry, int datasync)
 {
-	return sync_blockdev(I_BDEV(filp->f_mapping->host));
+	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
+	int error;
+
+	error = sync_blockdev(bdev);
+	if (error)
+		return error;
+
+	error = blkdev_issue_flush(bdev, NULL);
+	if (error == -EOPNOTSUPP)
+		error = 0;
+	return error;
 }
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
xtensa-convert-to-asm-generic-hardirqh.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics.patch
qnx4fs-remove-remains-of-the-defunct-write-support.patch
blkdev-flush-disk-cache-on-fsync.patch
elf-kill-use_elf_core_dump.patch

