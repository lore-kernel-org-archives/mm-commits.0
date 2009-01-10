From: akpm@linux-foundation.org
Subject: - usb-use-unaligned-endian-helpers-in-storage-drivers.patch removed from -mm tree
Date: Fri, 09 Jan 2009 16:17:03 -0800
Message-ID: <200901100033.n0A0XSb1007410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755956AbZAJAdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 19:33:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: use unaligned endian helpers in storage drivers
has been removed from the -mm tree.  Its filename was
     usb-use-unaligned-endian-helpers-in-storage-drivers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: use unaligned endian helpers in storage drivers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/datafab.c       |   32 +++++++----------------
 drivers/usb/storage/jumpshot.c      |   32 +++++++----------------
 drivers/usb/storage/shuttle_usbat.c |   36 +++++++-------------------
 3 files changed, 31 insertions(+), 69 deletions(-)

diff -puN drivers/usb/storage/datafab.c~usb-use-unaligned-endian-helpers-in-storage-drivers drivers/usb/storage/datafab.c
--- a/drivers/usb/storage/datafab.c~usb-use-unaligned-endian-helpers-in-storage-drivers
+++ a/drivers/usb/storage/datafab.c
@@ -50,6 +50,7 @@
 
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -373,10 +374,7 @@ static int datafab_id_device(struct us_d
 	if (rc == USB_STOR_XFER_GOOD) {
 		// capacity is at word offset 57-58
 		//
-		info->sectors = ((u32)(reply[117]) << 24) | 
-				((u32)(reply[116]) << 16) |
-				((u32)(reply[115]) <<  8) | 
-				((u32)(reply[114])      );
+		info->sectors = load_le32_noalign((__le32 *)&reply[114]);
 		rc = USB_STOR_TRANSPORT_GOOD;
 		goto leave;
 	}
@@ -556,10 +554,8 @@ int datafab_transport(struct scsi_cmnd *
 	// don't bother implementing READ_6 or WRITE_6.
 	//
 	if (srb->cmnd[0] == READ_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("datafab_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
 		return datafab_read_data(us, info, block, blocks);
@@ -568,21 +564,16 @@ int datafab_transport(struct scsi_cmnd *
 	if (srb->cmnd[0] == READ_12) {
 		// we'll probably never see a READ_12 but we'll do it anyway...
 		//
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("datafab_transport:  READ_12: read block 0x%04lx  count %ld\n", block, blocks);
 		return datafab_read_data(us, info, block, blocks);
 	}
 
 	if (srb->cmnd[0] == WRITE_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("datafab_transport:  WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
 		return datafab_write_data(us, info, block, blocks);
@@ -591,11 +582,8 @@ int datafab_transport(struct scsi_cmnd *
 	if (srb->cmnd[0] == WRITE_12) {
 		// we'll probably never see a WRITE_12 but we'll do it anyway...
 		//
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("datafab_transport:  WRITE_12: write block 0x%04lx  count %ld\n", block, blocks);
 		return datafab_write_data(us, info, block, blocks);
diff -puN drivers/usb/storage/jumpshot.c~usb-use-unaligned-endian-helpers-in-storage-drivers drivers/usb/storage/jumpshot.c
--- a/drivers/usb/storage/jumpshot.c~usb-use-unaligned-endian-helpers-in-storage-drivers
+++ a/drivers/usb/storage/jumpshot.c
@@ -47,6 +47,7 @@
 
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -309,10 +310,7 @@ static int jumpshot_id_device(struct us_
 		goto leave;
 	}
 
-	info->sectors = ((u32)(reply[117]) << 24) |
-			((u32)(reply[116]) << 16) |
-			((u32)(reply[115]) <<  8) |
-			((u32)(reply[114])      );
+	info->sectors = load_le32_noalign((__le32 *)&reply[114]);
 
 	rc = USB_STOR_TRANSPORT_GOOD;
 
@@ -486,10 +484,8 @@ int jumpshot_transport(struct scsi_cmnd 
 	}
 
 	if (srb->cmnd[0] == READ_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("jumpshot_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
 		return jumpshot_read_data(us, info, block, blocks);
@@ -498,21 +494,16 @@ int jumpshot_transport(struct scsi_cmnd 
 	if (srb->cmnd[0] == READ_12) {
 		// I don't think we'll ever see a READ_12 but support it anyway...
 		//
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("jumpshot_transport:  READ_12: read block 0x%04lx  count %ld\n", block, blocks);
 		return jumpshot_read_data(us, info, block, blocks);
 	}
 
 	if (srb->cmnd[0] == WRITE_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("jumpshot_transport:  WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
 		return jumpshot_write_data(us, info, block, blocks);
@@ -521,11 +512,8 @@ int jumpshot_transport(struct scsi_cmnd 
 	if (srb->cmnd[0] == WRITE_12) {
 		// I don't think we'll ever see a WRITE_12 but support it anyway...
 		//
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("jumpshot_transport:  WRITE_12: write block 0x%04lx  count %ld\n", block, blocks);
 		return jumpshot_write_data(us, info, block, blocks);
diff -puN drivers/usb/storage/shuttle_usbat.c~usb-use-unaligned-endian-helpers-in-storage-drivers drivers/usb/storage/shuttle_usbat.c
--- a/drivers/usb/storage/shuttle_usbat.c~usb-use-unaligned-endian-helpers-in-storage-drivers
+++ a/drivers/usb/storage/shuttle_usbat.c
@@ -44,6 +44,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/cdrom.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -957,10 +958,7 @@ static int usbat_flash_get_sector_count(
 	if (rc != USB_STOR_TRANSPORT_GOOD)
 		goto leave;
 
-	info->sectors = ((u32)(reply[117]) << 24) |
-		((u32)(reply[116]) << 16) |
-		((u32)(reply[115]) <<  8) |
-		((u32)(reply[114])      );
+	info->sectors = load_le32_noalign((__le32 *)&reply[114]);
 
 	rc = USB_STOR_TRANSPORT_GOOD;
 
@@ -1215,9 +1213,7 @@ static int usbat_hp8200e_handle_read10(s
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL) /* bloody hell! */
 		return USB_STOR_TRANSPORT_FAILED;
-	sector = short_pack(data[7+3], data[7+2]);
-	sector <<= 16;
-	sector |= short_pack(data[7+5], data[7+4]);
+	sector = load_be32_noalign((__be32 *)&data[7 + 2]);
 	transferred = 0;
 
 	while (transferred != scsi_bufflen(srb)) {
@@ -1596,10 +1592,8 @@ static int usbat_flash_transport(struct 
 	}
 
 	if (srb->cmnd[0] == READ_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-				((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("usbat_flash_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
 		return usbat_flash_read_data(us, info, block, blocks);
@@ -1609,21 +1603,16 @@ static int usbat_flash_transport(struct 
 		/*
 		 * I don't think we'll ever see a READ_12 but support it anyway
 		 */
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-		        ((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-		         ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("usbat_flash_transport: READ_12: read block 0x%04lx  count %ld\n", block, blocks);
 		return usbat_flash_read_data(us, info, block, blocks);
 	}
 
 	if (srb->cmnd[0] == WRITE_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-		        ((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("usbat_flash_transport: WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
 		return usbat_flash_write_data(us, info, block, blocks);
@@ -1633,11 +1622,8 @@ static int usbat_flash_transport(struct 
 		/*
 		 * I don't think we'll ever see a WRITE_12 but support it anyway
 		 */
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-		        ((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
