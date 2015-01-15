From: akpm@linux-foundation.org
Subject: [merged] block-change-direct_access-calling-convention.patch
 removed from -mm tree
Date: Thu, 15 Jan 2015 13:35:41 -0800
Message-ID: <54b832ad.UAam1WYHtPPxVirD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbbAOVgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 16:36:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: block: change direct_access calling convention
has been removed from the -mm tree.  Its filename was
     block-change-direct_access-calling-convention.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: block: change direct_access calling convention

In order to support accesses to larger chunks of memory, pass in a 'size'
parameter (counted in bytes), and return the amount available at that
address.

Add a new helper function, bdev_direct_access(), to handle common
functionality including partition handling, checking the length requested
is positive, checking for the sector being page-aligned, and checking the
length of the request does not pass the end of the partition.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Boaz Harrosh <boaz@plexistor.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/xip.txt |   15 ++++++----
 arch/powerpc/sysdev/axonram.c     |   17 ++---------
 drivers/block/brd.c               |   14 ++++-----
 drivers/s390/block/dcssblk.c      |   21 ++++++--------
 fs/block_dev.c                    |   40 ++++++++++++++++++++++++++++
 fs/ext2/xip.c                     |   31 +++++++++------------
 include/linux/blkdev.h            |    6 ++--
 7 files changed, 86 insertions(+), 58 deletions(-)

diff -puN Documentation/filesystems/xip.txt~block-change-direct_access-calling-convention Documentation/filesystems/xip.txt
--- a/Documentation/filesystems/xip.txt~block-change-direct_access-calling-convention
+++ a/Documentation/filesystems/xip.txt
@@ -28,12 +28,15 @@ Implementation
 Execute-in-place is implemented in three steps: block device operation,
 address space operation, and file operations.
 
-A block device operation named direct_access is used to retrieve a
-reference (pointer) to a block on-disk. The reference is supposed to be
-cpu-addressable, physical address and remain valid until the release operation
-is performed. A struct block_device reference is used to address the device,
-and a sector_t argument is used to identify the individual block. As an
-alternative, memory technology devices can be used for this.
+A block device operation named direct_access is used to translate the
+block device sector number to a page frame number (pfn) that identifies
+the physical page for the memory.  It also returns a kernel virtual
+address that can be used to access the memory.
+
+The direct_access method takes a 'size' parameter that indicates the
+number of bytes being requested.  The function should return the number
+of bytes that can be contiguously accessed at that offset.  It may also
+return a negative errno if an error occurs.
 
 The block device operation is optional, these block devices support it as of
 today:
diff -puN arch/powerpc/sysdev/axonram.c~block-change-direct_access-calling-convention arch/powerpc/sysdev/axonram.c
--- a/arch/powerpc/sysdev/axonram.c~block-change-direct_access-calling-convention
+++ a/arch/powerpc/sysdev/axonram.c
@@ -139,26 +139,17 @@ axon_ram_make_request(struct request_que
  * axon_ram_direct_access - direct_access() method for block device
  * @device, @sector, @data: see block_device_operations method
  */
-static int
+static long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void **kaddr, unsigned long *pfn)
+		       void **kaddr, unsigned long *pfn, long size)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
-	loff_t offset;
-
-	offset = sector;
-	if (device->bd_part != NULL)
-		offset += device->bd_part->start_sect;
-	offset <<= AXON_RAM_SECTOR_SHIFT;
-	if (offset >= bank->size) {
-		dev_err(&bank->device->dev, "Access outside of address space\n");
-		return -ERANGE;
-	}
+	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
 
 	*kaddr = (void *)(bank->ph_addr + offset);
 	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
 
-	return 0;
+	return bank->size - offset;
 }
 
 static const struct block_device_operations axon_ram_devops = {
diff -puN drivers/block/brd.c~block-change-direct_access-calling-convention drivers/block/brd.c
--- a/drivers/block/brd.c~block-change-direct_access-calling-convention
+++ a/drivers/block/brd.c
@@ -370,25 +370,25 @@ static int brd_rw_page(struct block_devi
 }
 
 #ifdef CONFIG_BLK_DEV_XIP
-static int brd_direct_access(struct block_device *bdev, sector_t sector,
-			void **kaddr, unsigned long *pfn)
+static long brd_direct_access(struct block_device *bdev, sector_t sector,
+			void **kaddr, unsigned long *pfn, long size)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
 
 	if (!brd)
 		return -ENODEV;
-	if (sector & (PAGE_SECTORS-1))
-		return -EINVAL;
-	if (sector + PAGE_SECTORS > get_capacity(bdev->bd_disk))
-		return -ERANGE;
 	page = brd_insert_page(brd, sector);
 	if (!page)
 		return -ENOSPC;
 	*kaddr = page_address(page);
 	*pfn = page_to_pfn(page);
 
-	return 0;
+	/*
+	 * TODO: If size > PAGE_SIZE, we could look to see if the next page in
+	 * the file happens to be mapped to the next page of physical RAM.
+	 */
+	return PAGE_SIZE;
 }
 #endif
 
diff -puN drivers/s390/block/dcssblk.c~block-change-direct_access-calling-convention drivers/s390/block/dcssblk.c
--- a/drivers/s390/block/dcssblk.c~block-change-direct_access-calling-convention
+++ a/drivers/s390/block/dcssblk.c
@@ -28,8 +28,8 @@
 static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static void dcssblk_make_request(struct request_queue *q, struct bio *bio);
-static int dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-				 void **kaddr, unsigned long *pfn);
+static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
+				 void **kaddr, unsigned long *pfn, long size);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -866,25 +866,22 @@ fail:
 	bio_io_error(bio);
 }
 
-static int
+static long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void **kaddr, unsigned long *pfn)
+			void **kaddr, unsigned long *pfn, long size)
 {
 	struct dcssblk_dev_info *dev_info;
-	unsigned long pgoff;
+	unsigned long offset, dev_sz;
 
 	dev_info = bdev->bd_disk->private_data;
 	if (!dev_info)
 		return -ENODEV;
-	if (secnum % (PAGE_SIZE/512))
-		return -EINVAL;
-	pgoff = secnum / (PAGE_SIZE / 512);
-	if ((pgoff+1)*PAGE_SIZE-1 > dev_info->end - dev_info->start)
-		return -ERANGE;
-	*kaddr = (void *) (dev_info->start+pgoff*PAGE_SIZE);
+	dev_sz = dev_info->end - dev_info->start;
+	offset = secnum * 512;
+	*kaddr = (void *) (dev_info->start + offset);
 	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
 
-	return 0;
+	return dev_sz - offset;
 }
 
 static void
diff -puN fs/block_dev.c~block-change-direct_access-calling-convention fs/block_dev.c
--- a/fs/block_dev.c~block-change-direct_access-calling-convention
+++ a/fs/block_dev.c
@@ -429,6 +429,46 @@ int bdev_write_page(struct block_device
 }
 EXPORT_SYMBOL_GPL(bdev_write_page);
 
+/**
+ * bdev_direct_access() - Get the address for directly-accessibly memory
+ * @bdev: The device containing the memory
+ * @sector: The offset within the device
+ * @addr: Where to put the address of the memory
+ * @pfn: The Page Frame Number for the memory
+ * @size: The number of bytes requested
+ *
+ * If a block device is made up of directly addressable memory, this function
+ * will tell the caller the PFN and the address of the memory.  The address
+ * may be directly dereferenced within the kernel without the need to call
+ * ioremap(), kmap() or similar.  The PFN is suitable for inserting into
+ * page tables.
+ *
+ * Return: negative errno if an error occurs, otherwise the number of bytes
+ * accessible at this address.
+ */
+long bdev_direct_access(struct block_device *bdev, sector_t sector,
+			void **addr, unsigned long *pfn, long size)
+{
+	long avail;
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (size < 0)
+		return size;
+	if (!ops->direct_access)
+		return -EOPNOTSUPP;
+	if ((sector + DIV_ROUND_UP(size, 512)) >
+					part_nr_sects_read(bdev->bd_part))
+		return -ERANGE;
+	sector += get_start_sect(bdev);
+	if (sector % (PAGE_SIZE / 512))
+		return -EINVAL;
+	avail = ops->direct_access(bdev, sector, addr, pfn, size);
+	if (!avail)
+		return -ERANGE;
+	return min(avail, size);
+}
+EXPORT_SYMBOL_GPL(bdev_direct_access);
+
 /*
  * pseudo-fs
  */
diff -puN fs/ext2/xip.c~block-change-direct_access-calling-convention fs/ext2/xip.c
--- a/fs/ext2/xip.c~block-change-direct_access-calling-convention
+++ a/fs/ext2/xip.c
@@ -13,18 +13,12 @@
 #include "ext2.h"
 #include "xip.h"
 
-static inline int
-__inode_direct_access(struct inode *inode, sector_t block,
-		      void **kaddr, unsigned long *pfn)
+static inline long __inode_direct_access(struct inode *inode, sector_t block,
+				void **kaddr, unsigned long *pfn, long size)
 {
 	struct block_device *bdev = inode->i_sb->s_bdev;
-	const struct block_device_operations *ops = bdev->bd_disk->fops;
-	sector_t sector;
-
-	sector = block * (PAGE_SIZE / 512); /* ext2 block to bdev sector */
-
-	BUG_ON(!ops->direct_access);
-	return ops->direct_access(bdev, sector, kaddr, pfn);
+	sector_t sector = block * (PAGE_SIZE / 512);
+	return bdev_direct_access(bdev, sector, kaddr, pfn, size);
 }
 
 static inline int
@@ -53,12 +47,13 @@ ext2_clear_xip_target(struct inode *inod
 {
 	void *kaddr;
 	unsigned long pfn;
-	int rc;
+	long size;
 
-	rc = __inode_direct_access(inode, block, &kaddr, &pfn);
-	if (!rc)
-		clear_page(kaddr);
-	return rc;
+	size = __inode_direct_access(inode, block, &kaddr, &pfn, PAGE_SIZE);
+	if (size < 0)
+		return size;
+	clear_page(kaddr);
+	return 0;
 }
 
 void ext2_xip_verify_sb(struct super_block *sb)
@@ -77,7 +72,7 @@ void ext2_xip_verify_sb(struct super_blo
 int ext2_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
 				void **kmem, unsigned long *pfn)
 {
-	int rc;
+	long rc;
 	sector_t block;
 
 	/* first, retrieve the sector number */
@@ -86,6 +81,6 @@ int ext2_get_xip_mem(struct address_spac
 		return rc;
 
 	/* retrieve address of the target data */
-	rc = __inode_direct_access(mapping->host, block, kmem, pfn);
-	return rc;
+	rc = __inode_direct_access(mapping->host, block, kmem, pfn, PAGE_SIZE);
+	return (rc < 0) ? rc : 0;
 }
diff -puN include/linux/blkdev.h~block-change-direct_access-calling-convention include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-change-direct_access-calling-convention
+++ a/include/linux/blkdev.h
@@ -1601,8 +1601,8 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	int (*direct_access) (struct block_device *, sector_t,
-						void **, unsigned long *);
+	long (*direct_access)(struct block_device *, sector_t,
+					void **, unsigned long *pfn, long size);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1620,6 +1620,8 @@ extern int __blkdev_driver_ioctl(struct
 extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
+extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
+						unsigned long *pfn, long size);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

linux-next.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

