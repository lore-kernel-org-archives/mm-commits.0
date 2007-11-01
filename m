From: akpm@linux-foundation.org
Subject: + update-kerneldoc-comments-in-drivers-scsi-scsicamc.patch added to -mm tree
Date: Thu, 01 Nov 2007 14:36:31 -0700
Message-ID: <200711012136.lA1LaVTB016658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37219 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759448AbXKAVgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 17:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, James.Bottomley@steeleye.com, rdunlap@xenotime.net


The patch titled
     Update kerneldoc comments in drivers/scsi/scsicam.c
has been added to the -mm tree.  Its filename is
     update-kerneldoc-comments-in-drivers-scsi-scsicamc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update kerneldoc comments in drivers/scsi/scsicam.c
From: Rob Landley <rob@landley.net>

Signed-off-by: Rob Landley <rob@landley.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsicam.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/scsicam.c~update-kerneldoc-comments-in-drivers-scsi-scsicamc drivers/scsi/scsicam.c
--- a/drivers/scsi/scsicam.c~update-kerneldoc-comments-in-drivers-scsi-scsicamc
+++ a/drivers/scsi/scsicam.c
@@ -24,6 +24,14 @@
 static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds,
 		   unsigned int *secs);
 
+/**
+ * scsi_bios_ptable - Read PC partition table out of first sector of device.
+ * @dev: from this device
+ *
+ * Description: Reads the first sector from the device and returns %0x42 bytes
+ *              starting at offset %0x1be.
+ * Returns: partition table in kmalloc(GFP_KERNEL) memory, or NULL on error.
+ */
 unsigned char *scsi_bios_ptable(struct block_device *dev)
 {
 	unsigned char *res = kmalloc(66, GFP_KERNEL);
@@ -43,15 +51,17 @@ unsigned char *scsi_bios_ptable(struct b
 }
 EXPORT_SYMBOL(scsi_bios_ptable);
 
-/*
- * Function : int scsicam_bios_param (struct block_device *bdev, ector_t capacity, int *ip)
+/**
+ * scsicam_bios_param - Determine geometry of a disk in cylinders/heads/sectors.
+ * @bdev: which device
+ * @capacity: size of the disk in sectors
+ * @ip: return value: ip[0]=heads, ip[1]=sectors, ip[2]=cylinders
  *
- * Purpose : to determine the BIOS mapping used for a drive in a 
+ * Description : determine the BIOS mapping/geometry used for a drive in a 
  *      SCSI-CAM system, storing the results in ip as required
  *      by the HDIO_GETGEO ioctl().
  *
  * Returns : -1 on failure, 0 on success.
- *
  */
 
 int scsicam_bios_param(struct block_device *bdev, sector_t capacity, int *ip)
@@ -98,15 +108,18 @@ int scsicam_bios_param(struct block_devi
 }
 EXPORT_SYMBOL(scsicam_bios_param);
 
-/*
- * Function : static int scsi_partsize(unsigned char *buf, unsigned long 
- *     capacity,unsigned int *cyls, unsigned int *hds, unsigned int *secs);
+/**
+ * scsi_partsize - Parse cylinders/heads/sectors from PC partition table
+ * @buf: partition table, see scsi_bios_ptable()
+ * @capacity: size of the disk in sectors
+ * @cyls: put cylinders here
+ * @hds: put heads here
+ * @secs: put sectors here
  *
- * Purpose : to determine the BIOS mapping used to create the partition
+ * Description: determine the BIOS mapping/geometry used to create the partition
  *      table, storing the results in *cyls, *hds, and *secs 
  *
- * Returns : -1 on failure, 0 on success.
- *
+ * Returns: -1 on failure, 0 on success.
  */
 
 int scsi_partsize(unsigned char *buf, unsigned long capacity,
@@ -194,7 +207,7 @@ EXPORT_SYMBOL(scsi_partsize);
  *
  * WORKING                                                    X3T9.2
  * DRAFT                                                        792D
- *
+ * see http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf
  *
  *                                                        Revision 6
  *                                                         10-MAR-94
_

Patches currently in -mm which might be from rob@landley.net are

update-kerneldoc-comments-in-drivers-scsi-scsicamc.patch
add-missing-section-ids-to-genericirqtmpl.patch
add-missing-section-ids-to-genericirqtmpl-updated.patch
add-missing-section-id-to-lsmtmpl.patch
add-section-ids-to-mtdnandtmpl.patch
add-missing-ids-to-procfs-guidetmpl.patch
add-section-ids-to-rapidiotmpl.patch
add-table-ids-to-videobooktmpl.patch
add-chapter-ids-to-z8530booktmpl.patch
