From: akpm@linux-foundation.org
Subject: - return-pfn-from-direct_access-for-xip.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:49 -0700
Message-ID: <200804282152.m3SLqnTp017804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934832AbYD1VxC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaredeh@gmail.com, cotte@de.ibm.com, heiko.carstens@de.ibm.com, npiggin@suse.de, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     return pfn from direct_access, for XIP
has been removed from the -mm tree.  Its filename was
     return-pfn-from-direct_access-for-xip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: return pfn from direct_access, for XIP
From: Jared Hulbert <jaredeh@gmail.com>

Alter the block device ->direct_access() API to work with the new
get_xip_mem() API (that requires both kaddr and pfn are returned).

Some architectures will not do the right thing in their virt_to_page() for use
by XIP (to translate from the kernel virtual address returned by
direct_access(), to a user mappable pfn in XIP's page fault handler.

However, we can't switch it to just return the pfn and not the kaddr, because
we have no good way to get a kva from a pfn, and XIP requires the kva for its
read(2) and write(2) handlers.  So we have to return both.

Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-mm@kvack.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/axonram.c |    5 +++--
 drivers/block/brd.c           |    5 +++--
 drivers/s390/block/dcssblk.c  |    8 +++++---
 fs/ext2/xip.c                 |   24 ++++++++++++++----------
 include/linux/fs.h            |    3 ++-
 5 files changed, 27 insertions(+), 18 deletions(-)

diff -puN arch/powerpc/sysdev/axonram.c~return-pfn-from-direct_access-for-xip arch/powerpc/sysdev/axonram.c
--- a/arch/powerpc/sysdev/axonram.c~return-pfn-from-direct_access-for-xip
+++ a/arch/powerpc/sysdev/axonram.c
@@ -143,7 +143,7 @@ axon_ram_make_request(struct request_que
  */
 static int
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       unsigned long *data)
+		       void **kaddr, unsigned long *pfn)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset;
@@ -154,7 +154,8 @@ axon_ram_direct_access(struct block_devi
 		return -ERANGE;
 	}
 
-	*data = bank->ph_addr + offset;
+	*kaddr = (void *)(bank->ph_addr + offset);
+	*pfn = virt_to_phys(kaddr) >> PAGE_SHIFT;
 
 	return 0;
 }
diff -puN drivers/block/brd.c~return-pfn-from-direct_access-for-xip drivers/block/brd.c
--- a/drivers/block/brd.c~return-pfn-from-direct_access-for-xip
+++ a/drivers/block/brd.c
@@ -319,7 +319,7 @@ out:
 
 #ifdef CONFIG_BLK_DEV_XIP
 static int brd_direct_access (struct block_device *bdev, sector_t sector,
-			unsigned long *data)
+			void **kaddr, unsigned long *pfn)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
@@ -333,7 +333,8 @@ static int brd_direct_access (struct blo
 	page = brd_insert_page(brd, sector);
 	if (!page)
 		return -ENOMEM;
-	*data = (unsigned long)page_address(page);
+	*kaddr = page_address(page);
+	*pfn = page_to_pfn(page);
 
 	return 0;
 }
diff -puN drivers/s390/block/dcssblk.c~return-pfn-from-direct_access-for-xip drivers/s390/block/dcssblk.c
--- a/drivers/s390/block/dcssblk.c~return-pfn-from-direct_access-for-xip
+++ a/drivers/s390/block/dcssblk.c
@@ -36,7 +36,7 @@ static int dcssblk_open(struct inode *in
 static int dcssblk_release(struct inode *inode, struct file *filp);
 static int dcssblk_make_request(struct request_queue *q, struct bio *bio);
 static int dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-				 unsigned long *data);
+				 void **kaddr, unsigned long *pfn);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -636,7 +636,7 @@ fail:
 
 static int
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			unsigned long *data)
+			void **kaddr, unsigned long *pfn)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long pgoff;
@@ -649,7 +649,9 @@ dcssblk_direct_access (struct block_devi
 	pgoff = secnum / (PAGE_SIZE / 512);
 	if ((pgoff+1)*PAGE_SIZE-1 > dev_info->end - dev_info->start)
 		return -ERANGE;
-	*data = (unsigned long) (dev_info->start+pgoff*PAGE_SIZE);
+	*kaddr = (void *) (dev_info->start+pgoff*PAGE_SIZE);
+	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+
 	return 0;
 }
 
diff -puN fs/ext2/xip.c~return-pfn-from-direct_access-for-xip fs/ext2/xip.c
--- a/fs/ext2/xip.c~return-pfn-from-direct_access-for-xip
+++ a/fs/ext2/xip.c
@@ -16,11 +16,13 @@
 
 static inline int
 __inode_direct_access(struct inode *inode, sector_t sector,
-		      unsigned long *data)
+		      void **kaddr, unsigned long *pfn)
 {
-	BUG_ON(!inode->i_sb->s_bdev->bd_disk->fops->direct_access);
-	return inode->i_sb->s_bdev->bd_disk->fops
-		->direct_access(inode->i_sb->s_bdev,sector,data);
+	struct block_device *bdev = inode->i_sb->s_bdev;
+	struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	BUG_ON(!ops->direct_access);
+	return ops->direct_access(bdev, sector, kaddr, pfn);
 }
 
 static inline int
@@ -48,12 +50,13 @@ int
 ext2_clear_xip_target(struct inode *inode, int block)
 {
 	sector_t sector = block * (PAGE_SIZE/512);
-	unsigned long data;
+	void *kaddr;
+	unsigned long pfn;
 	int rc;
 
-	rc = __inode_direct_access(inode, sector, &data);
+	rc = __inode_direct_access(inode, sector, &kaddr, &pfn);
 	if (!rc)
-		clear_page((void*)data);
+		clear_page(kaddr);
 	return rc;
 }
 
@@ -74,7 +77,8 @@ ext2_get_xip_page(struct address_space *
 		   int create)
 {
 	int rc;
-	unsigned long data;
+	void *kaddr;
+	unsigned long pfn;
 	sector_t sector;
 
 	/* first, retrieve the sector number */
@@ -84,9 +88,9 @@ ext2_get_xip_page(struct address_space *
 
 	/* retrieve address of the target data */
 	rc = __inode_direct_access
-		(mapping->host, sector * (PAGE_SIZE/512), &data);
+		(mapping->host, sector * (PAGE_SIZE/512), &kaddr, &pfn);
 	if (!rc)
-		return virt_to_page(data);
+		return pfn_to_page(pfn);
 
  error:
 	return ERR_PTR(rc);
diff -puN include/linux/fs.h~return-pfn-from-direct_access-for-xip include/linux/fs.h
--- a/include/linux/fs.h~return-pfn-from-direct_access-for-xip
+++ a/include/linux/fs.h
@@ -1178,7 +1178,8 @@ struct block_device_operations {
 	int (*ioctl) (struct inode *, struct file *, unsigned, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned, unsigned long);
-	int (*direct_access) (struct block_device *, sector_t, unsigned long *);
+	int (*direct_access) (struct block_device *, sector_t,
+						void **, unsigned long *);
 	int (*media_changed) (struct gendisk *);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
_

Patches currently in -mm which might be from jaredeh@gmail.com are

origin.patch

