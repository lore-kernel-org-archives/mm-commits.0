From: akpm@linux-foundation.org
Subject: + fs-move-code-out-of-bufferc.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:51:03 -0700
Message-ID: <201006042251.o54Mp3dx022926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab0FDWvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     fs: move code out of buffer.c
has been added to the -mm tree.  Its filename is
     fs-move-code-out-of-bufferc.patch

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
Subject: fs: move code out of buffer.c
From: Nick Piggin <npiggin@suse.de>

Move invalidate_bdev, block_sync_page into fs/block_dev.c.  Export
kill_bdev as well, so brd doesn't have to open code it.  Reduce
buffer_head.h requirement accordingly.

Removed a rather large comment from invalidate_bdev, as it looked a bit
obsolete to bother moving.  The small comment replacing it says enough.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/axonram.c           |    1 
 block/genhd.c                           |    1 
 block/ioctl.c                           |    2 
 drivers/block/amiflop.c                 |    2 
 drivers/block/brd.c                     |    9 +--
 drivers/block/floppy.c                  |    1 
 drivers/block/loop.c                    |    1 
 drivers/cdrom/cdrom.c                   |    1 
 drivers/char/sysrq.c                    |    1 
 drivers/md/dm.c                         |    1 
 drivers/md/md.c                         |    2 
 drivers/mtd/devices/block2mtd.c         |    1 
 drivers/s390/block/dasd.c               |    1 
 drivers/s390/char/tape_block.c          |    1 
 drivers/scsi/scsicam.c                  |    1 
 drivers/staging/ramzswap/ramzswap_drv.c |    1 
 fs/block_dev.c                          |   36 ++++++++++++--
 fs/buffer.c                             |   56 ----------------------
 fs/cachefiles/interface.c               |    1 
 fs/cramfs/inode.c                       |    1 
 fs/fs-writeback.c                       |    1 
 fs/libfs.c                              |    2 
 fs/quota/dquot.c                        |    1 
 fs/quota/quota.c                        |    1 
 fs/splice.c                             |    1 
 fs/sync.c                               |    1 
 include/linux/buffer_head.h             |    1 
 include/linux/fs.h                      |    3 +
 kernel/power/swap.c                     |    1 
 mm/page-writeback.c                     |    2 
 mm/swap_state.c                         |    1 
 31 files changed, 45 insertions(+), 91 deletions(-)

diff -puN arch/powerpc/sysdev/axonram.c~fs-move-code-out-of-bufferc arch/powerpc/sysdev/axonram.c
--- a/arch/powerpc/sysdev/axonram.c~fs-move-code-out-of-bufferc
+++ a/arch/powerpc/sysdev/axonram.c
@@ -25,7 +25,6 @@
 
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/buffer_head.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
diff -puN block/genhd.c~fs-move-code-out-of-bufferc block/genhd.c
--- a/block/genhd.c~fs-move-code-out-of-bufferc
+++ a/block/genhd.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <linux/kmod.h>
 #include <linux/kobj_map.h>
-#include <linux/buffer_head.h>
 #include <linux/mutex.h>
 #include <linux/idr.h>
 
diff -puN block/ioctl.c~fs-move-code-out-of-bufferc block/ioctl.c
--- a/block/ioctl.c~fs-move-code-out-of-bufferc
+++ a/block/ioctl.c
@@ -4,7 +4,7 @@
 #include <linux/blkpg.h>
 #include <linux/hdreg.h>
 #include <linux/backing-dev.h>
-#include <linux/buffer_head.h>
+#include <linux/fs.h>
 #include <linux/smp_lock.h>
 #include <linux/blktrace_api.h>
 #include <asm/uaccess.h>
diff -puN drivers/block/amiflop.c~fs-move-code-out-of-bufferc drivers/block/amiflop.c
--- a/drivers/block/amiflop.c~fs-move-code-out-of-bufferc
+++ a/drivers/block/amiflop.c
@@ -62,7 +62,7 @@
 #include <linux/init.h>
 #include <linux/amifdreg.h>
 #include <linux/amifd.h>
-#include <linux/buffer_head.h>
+#include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
 #include <linux/interrupt.h>
diff -puN drivers/block/brd.c~fs-move-code-out-of-bufferc drivers/block/brd.c
--- a/drivers/block/brd.c~fs-move-code-out-of-bufferc
+++ a/drivers/block/brd.c
@@ -16,7 +16,7 @@
 #include <linux/bio.h>
 #include <linux/highmem.h>
 #include <linux/radix-tree.h>
-#include <linux/buffer_head.h> /* invalidate_bh_lrus() */
+#include <linux/fs.h>
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
@@ -405,14 +405,13 @@ static int brd_ioctl(struct block_device
 	error = -EBUSY;
 	if (bdev->bd_openers <= 1) {
 		/*
-		 * Invalidate the cache first, so it isn't written
-		 * back to the device.
+		 * Kill the cache first, so it isn't written back to the
+		 * device.
 		 *
 		 * Another thread might instantiate more buffercache here,
 		 * but there is not much we can do to close that race.
 		 */
-		invalidate_bh_lrus();
-		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
+		kill_bdev(bdev);
 		brd_free_pages(brd);
 		error = 0;
 	}
diff -puN drivers/block/floppy.c~fs-move-code-out-of-bufferc drivers/block/floppy.c
--- a/drivers/block/floppy.c~fs-move-code-out-of-bufferc
+++ a/drivers/block/floppy.c
@@ -188,7 +188,6 @@ static int print_unex = 1;
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
-#include <linux/buffer_head.h>	/* for invalidate_buffers() */
 #include <linux/mutex.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
diff -puN drivers/block/loop.c~fs-move-code-out-of-bufferc drivers/block/loop.c
--- a/drivers/block/loop.c~fs-move-code-out-of-bufferc
+++ a/drivers/block/loop.c
@@ -68,7 +68,6 @@
 #include <linux/suspend.h>
 #include <linux/freezer.h>
 #include <linux/writeback.h>
-#include <linux/buffer_head.h>		/* for invalidate_bdev() */
 #include <linux/completion.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
diff -puN drivers/cdrom/cdrom.c~fs-move-code-out-of-bufferc drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~fs-move-code-out-of-bufferc
+++ a/drivers/cdrom/cdrom.c
@@ -265,7 +265,6 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
-#include <linux/buffer_head.h>
 #include <linux/major.h>
 #include <linux/types.h>
 #include <linux/errno.h>
diff -puN drivers/char/sysrq.c~fs-move-code-out-of-bufferc drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~fs-move-code-out-of-bufferc
+++ a/drivers/char/sysrq.c
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/suspend.h>
 #include <linux/writeback.h>
-#include <linux/buffer_head.h>		/* for fsync_bdev() */
 #include <linux/swap.h>
 #include <linux/spinlock.h>
 #include <linux/vt_kern.h>
diff -puN drivers/md/dm.c~fs-move-code-out-of-bufferc drivers/md/dm.c
--- a/drivers/md/dm.c~fs-move-code-out-of-bufferc
+++ a/drivers/md/dm.c
@@ -14,7 +14,6 @@
 #include <linux/moduleparam.h>
 #include <linux/blkpg.h>
 #include <linux/bio.h>
-#include <linux/buffer_head.h>
 #include <linux/mempool.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
diff -puN drivers/md/md.c~fs-move-code-out-of-bufferc drivers/md/md.c
--- a/drivers/md/md.c~fs-move-code-out-of-bufferc
+++ a/drivers/md/md.c
@@ -36,7 +36,7 @@
 #include <linux/blkdev.h>
 #include <linux/sysctl.h>
 #include <linux/seq_file.h>
-#include <linux/buffer_head.h> /* for invalidate_bdev */
+#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/ctype.h>
 #include <linux/string.h>
diff -puN drivers/mtd/devices/block2mtd.c~fs-move-code-out-of-bufferc drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~fs-move-code-out-of-bufferc
+++ a/drivers/mtd/devices/block2mtd.c
@@ -14,7 +14,6 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/mtd/mtd.h>
-#include <linux/buffer_head.h>
 #include <linux/mutex.h>
 #include <linux/mount.h>
 #include <linux/slab.h>
diff -puN drivers/s390/block/dasd.c~fs-move-code-out-of-bufferc drivers/s390/block/dasd.c
--- a/drivers/s390/block/dasd.c~fs-move-code-out-of-bufferc
+++ a/drivers/s390/block/dasd.c
@@ -17,7 +17,6 @@
 #include <linux/ctype.h>
 #include <linux/major.h>
 #include <linux/slab.h>
-#include <linux/buffer_head.h>
 #include <linux/hdreg.h>
 #include <linux/async.h>
 #include <linux/mutex.h>
diff -puN drivers/s390/char/tape_block.c~fs-move-code-out-of-bufferc drivers/s390/char/tape_block.c
--- a/drivers/s390/char/tape_block.c~fs-move-code-out-of-bufferc
+++ a/drivers/s390/char/tape_block.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
-#include <linux/buffer_head.h>
 #include <linux/kernel.h>
 
 #include <asm/debug.h>
diff -puN drivers/scsi/scsicam.c~fs-move-code-out-of-bufferc drivers/scsi/scsicam.c
--- a/drivers/scsi/scsicam.c~fs-move-code-out-of-bufferc
+++ a/drivers/scsi/scsicam.c
@@ -16,7 +16,6 @@
 #include <linux/genhd.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
-#include <linux/buffer_head.h>
 #include <asm/unaligned.h>
 
 #include <scsi/scsicam.h>
diff -puN drivers/staging/ramzswap/ramzswap_drv.c~fs-move-code-out-of-bufferc drivers/staging/ramzswap/ramzswap_drv.c
--- a/drivers/staging/ramzswap/ramzswap_drv.c~fs-move-code-out-of-bufferc
+++ a/drivers/staging/ramzswap/ramzswap_drv.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
-#include <linux/buffer_head.h>
 #include <linux/device.h>
 #include <linux/genhd.h>
 #include <linux/highmem.h>
diff -puN fs/block_dev.c~fs-move-code-out-of-bufferc fs/block_dev.c
--- a/fs/block_dev.c~fs-move-code-out-of-bufferc
+++ a/fs/block_dev.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/blkpg.h>
 #include <linux/buffer_head.h>
+#include <linux/swap.h>
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 #include <linux/mpage.h>
@@ -62,13 +63,31 @@ static sector_t max_block(struct block_d
 }
 
 /* Kill _all_ buffers and pagecache , dirty or not.. */
-static void kill_bdev(struct block_device *bdev)
+void kill_bdev(struct block_device *bdev)
 {
-	if (bdev->bd_inode->i_mapping->nrpages == 0)
+	struct address_space *mapping = bdev->bd_inode->i_mapping;
+
+	if (mapping->nrpages == 0)
 		return;
+
 	invalidate_bh_lrus();
-	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
+	truncate_inode_pages(mapping, 0);
 }	
+EXPORT_SYMBOL(kill_bdev);
+
+/* Invalidate clean unused buffers and pagecache. */
+void invalidate_bdev(struct block_device *bdev)
+{
+	struct address_space *mapping = bdev->bd_inode->i_mapping;
+
+	if (mapping->nrpages == 0)
+		return;
+
+	invalidate_bh_lrus();
+	lru_add_drain_all();	/* make sure all lru add caches are flushed */
+	invalidate_mapping_pages(mapping, 0, -1);
+}
+EXPORT_SYMBOL(invalidate_bdev);
 
 int set_blocksize(struct block_device *bdev, int size)
 {
@@ -1607,6 +1626,17 @@ ssize_t blkdev_aio_write(struct kiocb *i
 }
 EXPORT_SYMBOL_GPL(blkdev_aio_write);
 
+void block_sync_page(struct page *page)
+{
+	struct address_space *mapping;
+
+	smp_mb();
+	mapping = page_mapping(page);
+	if (mapping)
+		blk_run_backing_dev(mapping->backing_dev_info, page);
+}
+EXPORT_SYMBOL(block_sync_page);
+
 /*
  * Try to release a page associated with block device when the system
  * is under memory pressure.
diff -puN fs/buffer.c~fs-move-code-out-of-bufferc fs/buffer.c
--- a/fs/buffer.c~fs-move-code-out-of-bufferc
+++ a/fs/buffer.c
@@ -235,51 +235,6 @@ out:
 	return ret;
 }
 
-/* If invalidate_buffers() will trash dirty buffers, it means some kind
-   of fs corruption is going on. Trashing dirty data always imply losing
-   information that was supposed to be just stored on the physical layer
-   by the user.
-
-   Thus invalidate_buffers in general usage is not allwowed to trash
-   dirty buffers. For example ioctl(FLSBLKBUF) expects dirty data to
-   be preserved.  These buffers are simply skipped.
-  
-   We also skip buffers which are still in use.  For example this can
-   happen if a userspace program is reading the block device.
-
-   NOTE: In the case where the user removed a removable-media-disk even if
-   there's still dirty data not synced on disk (due a bug in the device driver
-   or due an error of the user), by not destroying the dirty buffers we could
-   generate corruption also on the next media inserted, thus a parameter is
-   necessary to handle this case in the most safe way possible (trying
-   to not corrupt also the new disk inserted with the data belonging to
-   the old now corrupted disk). Also for the ramdisk the natural thing
-   to do in order to release the ramdisk memory is to destroy dirty buffers.
-
-   These are two special cases. Normal usage imply the device driver
-   to issue a sync on the device (without waiting I/O completion) and
-   then an invalidate_buffers call that doesn't trash dirty buffers.
-
-   For handling cache coherency with the blkdev pagecache the 'update' case
-   is been introduced. It is needed to re-read from disk any pinned
-   buffer. NOTE: re-reading from disk is destructive so we can do it only
-   when we assume nobody is changing the buffercache under our I/O and when
-   we think the disk contains more recent information than the buffercache.
-   The update == 1 pass marks the buffers we need to update, the update == 2
-   pass does the actual I/O. */
-void invalidate_bdev(struct block_device *bdev)
-{
-	struct address_space *mapping = bdev->bd_inode->i_mapping;
-
-	if (mapping->nrpages == 0)
-		return;
-
-	invalidate_bh_lrus();
-	lru_add_drain_all();	/* make sure all lru add caches are flushed */
-	invalidate_mapping_pages(mapping, 0, -1);
-}
-EXPORT_SYMBOL(invalidate_bdev);
-
 /*
  * Kick the writeback threads then try to free up some ZONE_NORMAL memory.
  */
@@ -3257,17 +3212,6 @@ out:
 }
 EXPORT_SYMBOL(try_to_free_buffers);
 
-void block_sync_page(struct page *page)
-{
-	struct address_space *mapping;
-
-	smp_mb();
-	mapping = page_mapping(page);
-	if (mapping)
-		blk_run_backing_dev(mapping->backing_dev_info, page);
-}
-EXPORT_SYMBOL(block_sync_page);
-
 /*
  * There are no bdflush tunables left.  But distributions are
  * still running obsolete flush daemons, so we terminate them here.
diff -puN fs/cachefiles/interface.c~fs-move-code-out-of-bufferc fs/cachefiles/interface.c
--- a/fs/cachefiles/interface.c~fs-move-code-out-of-bufferc
+++ a/fs/cachefiles/interface.c
@@ -11,7 +11,6 @@
 
 #include <linux/slab.h>
 #include <linux/mount.h>
-#include <linux/buffer_head.h>
 #include "internal.h"
 
 #define list_to_page(head) (list_entry((head)->prev, struct page, lru))
diff -puN fs/cramfs/inode.c~fs-move-code-out-of-bufferc fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-move-code-out-of-bufferc
+++ a/fs/cramfs/inode.c
@@ -20,7 +20,6 @@
 #include <linux/cramfs_fs.h>
 #include <linux/slab.h>
 #include <linux/cramfs_fs_sb.h>
-#include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
 
diff -puN fs/fs-writeback.c~fs-move-code-out-of-bufferc fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-move-code-out-of-bufferc
+++ a/fs/fs-writeback.c
@@ -25,7 +25,6 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
-#include <linux/buffer_head.h>
 #include "internal.h"
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
diff -puN fs/libfs.c~fs-move-code-out-of-bufferc fs/libfs.c
--- a/fs/libfs.c~fs-move-code-out-of-bufferc
+++ a/fs/libfs.c
@@ -12,7 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
-#include <linux/buffer_head.h>
+#include <linux/buffer_head.h> /* sync_mapping_buffers */
 
 #include <asm/uaccess.h>
 
diff -puN fs/quota/dquot.c~fs-move-code-out-of-bufferc fs/quota/dquot.c
--- a/fs/quota/dquot.c~fs-move-code-out-of-bufferc
+++ a/fs/quota/dquot.c
@@ -73,7 +73,6 @@
 #include <linux/security.h>
 #include <linux/kmod.h>
 #include <linux/namei.h>
-#include <linux/buffer_head.h>
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h> /* for inode_lock, oddly enough.. */
diff -puN fs/quota/quota.c~fs-move-code-out-of-bufferc fs/quota/quota.c
--- a/fs/quota/quota.c~fs-move-code-out-of-bufferc
+++ a/fs/quota/quota.c
@@ -13,7 +13,6 @@
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
-#include <linux/buffer_head.h>
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/types.h>
diff -puN fs/splice.c~fs-move-code-out-of-bufferc fs/splice.c
--- a/fs/splice.c~fs-move-code-out-of-bufferc
+++ a/fs/splice.c
@@ -25,7 +25,6 @@
 #include <linux/mm_inline.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/buffer_head.h>
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/uio.h>
diff -puN fs/sync.c~fs-move-code-out-of-bufferc fs/sync.c
--- a/fs/sync.c~fs-move-code-out-of-bufferc
+++ a/fs/sync.c
@@ -13,7 +13,6 @@
 #include <linux/linkage.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
-#include <linux/buffer_head.h>
 #include <linux/backing-dev.h>
 #include "internal.h"
 
diff -puN include/linux/buffer_head.h~fs-move-code-out-of-bufferc include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fs-move-code-out-of-bufferc
+++ a/include/linux/buffer_head.h
@@ -227,7 +227,6 @@ int generic_cont_expand_simple(struct in
 int block_commit_write(struct page *page, unsigned from, unsigned to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
-void block_sync_page(struct page *);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int file_fsync(struct file *, int);
diff -puN include/linux/fs.h~fs-move-code-out-of-bufferc include/linux/fs.h
--- a/include/linux/fs.h~fs-move-code-out-of-bufferc
+++ a/include/linux/fs.h
@@ -1947,6 +1947,7 @@ extern void bd_set_size(struct block_dev
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
 extern struct block_device *open_by_devnum(dev_t, fmode_t);
+extern void kill_bdev(struct block_device *);
 extern void invalidate_bdev(struct block_device *);
 extern int sync_blockdev(struct block_device *bdev);
 extern struct super_block *freeze_bdev(struct block_device *);
@@ -1956,6 +1957,7 @@ extern int fsync_bdev(struct block_devic
 #else
 static inline void bd_forget(struct inode *inode) {}
 static inline int sync_blockdev(struct block_device *bdev) { return 0; }
+static inline void kill_bdev(struct block_device *bdev) {}
 static inline void invalidate_bdev(struct block_device *bdev) {}
 
 static inline struct super_block *freeze_bdev(struct block_device *sb)
@@ -2213,6 +2215,7 @@ extern int generic_segment_checks(const 
 extern ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 extern int blkdev_fsync(struct file *filp, int datasync);
+extern void block_sync_page(struct page *page);
 
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
diff -puN kernel/power/swap.c~fs-move-code-out-of-bufferc kernel/power/swap.c
--- a/kernel/power/swap.c~fs-move-code-out-of-bufferc
+++ a/kernel/power/swap.c
@@ -17,7 +17,6 @@
 #include <linux/bitops.h>
 #include <linux/genhd.h>
 #include <linux/device.h>
-#include <linux/buffer_head.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/swap.h>
diff -puN mm/page-writeback.c~fs-move-code-out-of-bufferc mm/page-writeback.c
--- a/mm/page-writeback.c~fs-move-code-out-of-bufferc
+++ a/mm/page-writeback.c
@@ -32,7 +32,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
-#include <linux/buffer_head.h>
+#include <linux/buffer_head.h> /* __set_page_dirty_buffers */
 #include <linux/pagevec.h>
 
 /*
diff -puN mm/swap_state.c~fs-move-code-out-of-bufferc mm/swap_state.c
--- a/mm/swap_state.c~fs-move-code-out-of-bufferc
+++ a/mm/swap_state.c
@@ -14,7 +14,6 @@
 #include <linux/swapops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
-#include <linux/buffer_head.h>
 #include <linux/backing-dev.h>
 #include <linux/pagevec.h>
 #include <linux/migrate.h>
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
frv-invoke-oom-killer-from-page-fault.patch
m32r-invoke-oom-killer-from-page-fault.patch
mn10300-invoke-oom-killer-from-page-fault.patch
xtensa-invoke-oom-killer-from-page-fault.patch
fb_defio-redo-fix-for-non-dirty-ptes.patch
linux-next.patch
block-bd_start_claiming-fix-module-refcount.patch
block-bd_start_claiming-cleanup.patch
avr32-invoke-oom-killer-from-page-fault.patch
fs-move-code-out-of-bufferc.patch
mm-vmap-area-cache.patch
mm-vmap-area-cache-fix.patch
reiser4.patch

