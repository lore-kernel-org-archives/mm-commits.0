From: akpm@linux-foundation.org
Subject: + rd-support-xip.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:33:52 -0800
Message-ID: <200712052233.lB5MXqJl028455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38343 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbXLEWd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     rd: support XIP
has been added to the -mm tree.  Its filename is
     rd-support-xip.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rd: support XIP
From: Nick Piggin <npiggin@suse.de>

Support direct_access XIP method with brd.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig |   10 ++++++++++
 drivers/block/brd.c   |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff -puN drivers/block/Kconfig~rd-support-xip drivers/block/Kconfig
--- a/drivers/block/Kconfig~rd-support-xip
+++ a/drivers/block/Kconfig
@@ -346,6 +346,16 @@ config BLK_DEV_RAM_SIZE
 	  The default value is 4096 kilobytes. Only change this if you know
 	  what you are doing.
 
+config BLK_DEV_XIP
+	bool "Support XIP filesystems on RAM block device"
+	depends on BLK_DEV_RAM
+	default n
+	help
+	  Support XIP filesystems (such as ext2 with XIP support on) on
+	  top of block ram device. This will slightly enlarge the kernel, and
+	  will prevent RAM block device backing store memory from being
+	  allocated from highmem (only a problem for highmem systems).
+
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff -puN drivers/block/brd.c~rd-support-xip drivers/block/brd.c
--- a/drivers/block/brd.c~rd-support-xip
+++ a/drivers/block/brd.c
@@ -89,6 +89,7 @@ static struct page *brd_insert_page(stru
 {
 	pgoff_t idx;
 	struct page *page;
+	gfp_t gfp_flags;
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
@@ -97,7 +98,16 @@ static struct page *brd_insert_page(stru
 	/*
 	 * Must use NOIO because we don't want to recurse back into the
 	 * block or filesystem layers from page reclaim.
+	 *
+	 * Cannot support XIP and highmem, because our ->direct_access
+	 * routine for XIP must return memory that is always addressable.
+	 * If XIP was reworked to use pfns and kmap throughout, this
+	 * restriction might be able to be lifted.
 	 */
+	gfp_flags = GFP_NOIO | __GFP_ZERO;
+#ifndef CONFIG_BLK_DEV_XIP
+	gfp_flags |= __GFP_HIGHMEM;
+#endif
 	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);
 	if (!page)
 		return NULL;
@@ -307,6 +317,28 @@ out:
 	return 0;
 }
 
+#ifdef CONFIG_BLK_DEV_XIP
+static int brd_direct_access (struct block_device *bdev, sector_t sector,
+			unsigned long *data)
+{
+	struct brd_device *brd = bdev->bd_disk->private_data;
+	struct page *page;
+
+	if (!brd)
+		return -ENODEV;
+	if (sector & (PAGE_SECTORS-1))
+		return -EINVAL;
+	if (sector + PAGE_SECTORS > get_capacity(bdev->bd_disk))
+		return -ERANGE;
+	page = brd_insert_page(brd, sector);
+	if (!page)
+		return -ENOMEM;
+	*data = (unsigned long)page_address(page);
+
+	return 0;
+}
+#endif
+
 static int brd_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
@@ -342,8 +374,11 @@ static int brd_ioctl(struct inode *inode
 }
 
 static struct block_device_operations brd_fops = {
-	.owner =	THIS_MODULE,
-	.ioctl =	brd_ioctl,
+	.owner =		THIS_MODULE,
+	.ioctl =		brd_ioctl,
+#ifdef CONFIG_BLK_DEV_XIP
+	.direct_access =	brd_direct_access,
+#endif
 };
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-xip-file-writes.patch
git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
