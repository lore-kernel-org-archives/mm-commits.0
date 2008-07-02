From: akpm@linux-foundation.org
Subject: + mtd-handle-pci_name-being-const.patch added to -mm tree
Date: Wed, 02 Jul 2008 16:19:25 -0700
Message-ID: <200807022319.m62NJP9H008908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbYGBXTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 19:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gregkh@suse.de, dwmw2@infradead.org


The patch titled
     MTD: handle pci_name() being const
has been added to the -mm tree.  Its filename is
     mtd-handle-pci_name-being-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MTD: handle pci_name() being const
From: Greg Kroah-Hartman <gregkh@suse.de>

This changes the MTD core to handle pci_name() now returning a constant
string.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/block2mtd.c |    8 +++++---
 include/linux/mtd/map.h         |    2 +-
 include/linux/mtd/mtd.h         |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/devices/block2mtd.c~mtd-handle-pci_name-being-const drivers/mtd/devices/block2mtd.c
--- a/drivers/mtd/devices/block2mtd.c~mtd-handle-pci_name-being-const
+++ a/drivers/mtd/devices/block2mtd.c
@@ -241,6 +241,7 @@ static struct block2mtd_dev *add_device(
 {
 	struct block_device *bdev;
 	struct block2mtd_dev *dev;
+	char *name;
 
 	if (!devname)
 		return NULL;
@@ -279,12 +280,13 @@ static struct block2mtd_dev *add_device(
 
 	/* Setup the MTD structure */
 	/* make the name contain the block device in */
-	dev->mtd.name = kmalloc(sizeof("block2mtd: ") + strlen(devname),
+	name = kmalloc(sizeof("block2mtd: ") + strlen(devname) + 1,
 			GFP_KERNEL);
-	if (!dev->mtd.name)
+	if (!name)
 		goto devinit_err;
 
-	sprintf(dev->mtd.name, "block2mtd: %s", devname);
+	sprintf(name, "block2mtd: %s", devname);
+	dev->mtd.name = name;
 
 	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
 	dev->mtd.erasesize = erase_size;
diff -puN include/linux/mtd/map.h~mtd-handle-pci_name-being-const include/linux/mtd/map.h
--- a/include/linux/mtd/map.h~mtd-handle-pci_name-being-const
+++ a/include/linux/mtd/map.h
@@ -189,7 +189,7 @@ typedef union {
 */
 
 struct map_info {
-	char *name;
+	const char *name;
 	unsigned long size;
 	resource_size_t phys;
 #define NO_XIP (-1UL)
diff -puN include/linux/mtd/mtd.h~mtd-handle-pci_name-being-const include/linux/mtd/mtd.h
--- a/include/linux/mtd/mtd.h~mtd-handle-pci_name-being-const
+++ a/include/linux/mtd/mtd.h
@@ -121,7 +121,7 @@ struct mtd_info {
 	u_int32_t oobavail;  // Available OOB bytes per block
 
 	// Kernel-only stuff starts here.
-	char *name;
+	const char *name;
 	int index;
 
 	/* ecc layout structure pointer - read only ! */
_

Patches currently in -mm which might be from gregkh@suse.de are

sisusbvga-fix-oops-on-disconnect.patch
linux-next.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch
hugetlb-new-sysfs-interface.patch
checkpatch-usb_free_urb-can-take-null.patch
firmware-use-memory_read_from_buffer.patch
edac-core-fix-to-use-dynamic-kobject.patch
mtd-handle-pci_name-being-const.patch
pci-handle-pci_name-being-const.patch
3c59x-handle-pci_name-being-const.patch
usb-handle-pci_name-being-const.patch

