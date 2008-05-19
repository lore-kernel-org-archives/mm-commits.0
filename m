From: akpm@linux-foundation.org
Subject: + usb-file-storagec-use-unaligned-access-helpers.patch added to -mm tree
Date: Mon, 19 May 2008 14:22:46 -0700
Message-ID: <200805192122.m4JLMkkX021200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763077AbYESVX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb: file-storage.c use unaligned access helpers
has been added to the -mm tree.  Its filename is
     usb-file-storagec-use-unaligned-access-helpers.patch

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
Subject: usb: file-storage.c use unaligned access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Replace the put_be16/32 and get_be16/32 helpers with the common unaligned
access routines.  Note that these put_ helpers had the pointer/value
parameter in the opposite order from the common version.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/file_storage.c |   79 ++++++++--------------------
 1 file changed, 25 insertions(+), 54 deletions(-)

diff -puN drivers/usb/gadget/file_storage.c~usb-file-storagec-use-unaligned-access-helpers drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~usb-file-storagec-use-unaligned-access-helpers
+++ a/drivers/usb/gadget/file_storage.c
@@ -242,6 +242,8 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 
+#include <asm/unaligned.h>
+
 #include "gadget_chips.h"
 
 
@@ -763,37 +765,6 @@ static int fsg_set_halt(struct fsg_dev *
 	return usb_ep_set_halt(ep);
 }
 
-
-/*-------------------------------------------------------------------------*/
-
-/* Routines for unaligned data access */
-
-static u16 get_be16(u8 *buf)
-{
-	return ((u16) buf[0] << 8) | ((u16) buf[1]);
-}
-
-static u32 get_be32(u8 *buf)
-{
-	return ((u32) buf[0] << 24) | ((u32) buf[1] << 16) |
-			((u32) buf[2] << 8) | ((u32) buf[3]);
-}
-
-static void put_be16(u8 *buf, u16 val)
-{
-	buf[0] = val >> 8;
-	buf[1] = val;
-}
-
-static void put_be32(u8 *buf, u32 val)
-{
-	buf[0] = val >> 24;
-	buf[1] = val >> 16;
-	buf[2] = val >> 8;
-	buf[3] = val & 0xff;
-}
-
-
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -1551,9 +1522,9 @@ static int do_read(struct fsg_dev *fsg)
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
 	if (fsg->cmnd[0] == SC_READ_6)
-		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
+		lba = get_unaligned_be32(fsg->cmnd) & 0x00ffffff;
 	else {
-		lba = get_be32(&fsg->cmnd[2]);
+		lba = get_unaligned_be32(&fsg->cmnd[2]);
 
 		/* We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = don't read from the
@@ -1684,9 +1655,9 @@ static int do_write(struct fsg_dev *fsg)
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
 	if (fsg->cmnd[0] == SC_WRITE_6)
-		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
+		lba = get_unaligned_be32(fsg->cmnd) & 0x00ffffff;
 	else {
-		lba = get_be32(&fsg->cmnd[2]);
+		lba = get_unaligned_be32(&fsg->cmnd[2]);
 
 		/* We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = write directly to the
@@ -1920,7 +1891,7 @@ static int do_verify(struct fsg_dev *fsg
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
-	lba = get_be32(&fsg->cmnd[2]);
+	lba = get_unaligned_be32(&fsg->cmnd[2]);
 	if (lba >= curlun->num_sectors) {
 		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
 		return -EINVAL;
@@ -1933,7 +1904,7 @@ static int do_verify(struct fsg_dev *fsg
 		return -EINVAL;
 	}
 
-	verification_length = get_be16(&fsg->cmnd[7]);
+	verification_length = get_unaligned_be16(&fsg->cmnd[7]);
 	if (unlikely(verification_length == 0))
 		return -EIO;		// No default reply
 
@@ -2078,7 +2049,7 @@ static int do_request_sense(struct fsg_d
 	memset(buf, 0, 18);
 	buf[0] = valid | 0x70;			// Valid, current error
 	buf[2] = SK(sd);
-	put_be32(&buf[3], sdinfo);		// Sense information
+	put_unaligned_be32(sdinfo, &buf[3]);		// Sense information
 	buf[7] = 18 - 8;			// Additional sense length
 	buf[12] = ASC(sd);
 	buf[13] = ASCQ(sd);
@@ -2089,7 +2060,7 @@ static int do_request_sense(struct fsg_d
 static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 {
 	struct lun	*curlun = fsg->curlun;
-	u32		lba = get_be32(&fsg->cmnd[2]);
+	u32		lba = get_unaligned_be32(&fsg->cmnd[2]);
 	int		pmi = fsg->cmnd[8];
 	u8		*buf = (u8 *) bh->buf;
 
@@ -2099,8 +2070,8 @@ static int do_read_capacity(struct fsg_d
 		return -EINVAL;
 	}
 
-	put_be32(&buf[0], curlun->num_sectors - 1);	// Max logical block
-	put_be32(&buf[4], 512);				// Block length
+	put_unaligned_be32(curlun->num_sectors - 1, &buf[0]);	// Max logical block
+	put_unaligned_be32(512, &buf[4]);				// Block length
 	return 8;
 }
 
@@ -2158,10 +2129,10 @@ static int do_mode_sense(struct fsg_dev 
 			buf[2] = 0x04;	// Write cache enable,
 					// Read cache not disabled
 					// No cache retention priorities
-			put_be16(&buf[4], 0xffff);  // Don't disable prefetch
+			put_unaligned_be16(0xffff, &buf[4]);  // Don't disable prefetch
 					// Minimum prefetch = 0
-			put_be16(&buf[8], 0xffff);  // Maximum prefetch
-			put_be16(&buf[10], 0xffff); // Maximum prefetch ceiling
+			put_unaligned_be16(0xffff, &buf[8]);  // Maximum prefetch
+			put_unaligned_be16(0xffff, &buf[10]); // Maximum prefetch ceiling
 		}
 		buf += 12;
 	}
@@ -2178,7 +2149,7 @@ static int do_mode_sense(struct fsg_dev 
 	if (mscmnd == SC_MODE_SENSE_6)
 		buf0[0] = len - 1;
 	else
-		put_be16(buf0, len - 2);
+		put_unaligned_be16(len - 2, buf0);
 	return len;
 }
 
@@ -2266,8 +2237,8 @@ static int do_read_format_capacities(str
 	buf[3] = 8;		// Only the Current/Maximum Capacity Descriptor
 	buf += 4;
 
-	put_be32(&buf[0], curlun->num_sectors);		// Number of blocks
-	put_be32(&buf[4], 512);				// Block length
+	put_unaligned_be32(curlun->num_sectors, &buf[0]);	// Number of blocks
+	put_unaligned_be32(512, &buf[4]);			// Block length
 	buf[4] = 0x02;					// Current capacity
 	return 12;
 }
@@ -2775,7 +2746,7 @@ static int do_scsi_command(struct fsg_de
 		break;
 
 	case SC_MODE_SELECT_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (3<<7), 0,
 				"MODE SELECT(10)")) == 0)
@@ -2791,7 +2762,7 @@ static int do_scsi_command(struct fsg_de
 		break;
 
 	case SC_MODE_SENSE_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (1<<2) | (3<<7), 0,
 				"MODE SENSE(10)")) == 0)
@@ -2816,7 +2787,7 @@ static int do_scsi_command(struct fsg_de
 		break;
 
 	case SC_READ_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]) << 9;
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
 				"READ(10)")) == 0)
@@ -2824,7 +2795,7 @@ static int do_scsi_command(struct fsg_de
 		break;
 
 	case SC_READ_12:
-		fsg->data_size_from_cmnd = get_be32(&fsg->cmnd[6]) << 9;
+		fsg->data_size_from_cmnd = get_unaligned_be32(&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_TO_HOST,
 				(1<<1) | (0xf<<2) | (0xf<<6), 1,
 				"READ(12)")) == 0)
@@ -2840,7 +2811,7 @@ static int do_scsi_command(struct fsg_de
 		break;
 
 	case SC_READ_FORMAT_CAPACITIES:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(3<<7), 1,
 				"READ FORMAT CAPACITIES")) == 0)
@@ -2898,7 +2869,7 @@ static int do_scsi_command(struct fsg_de
 		break;
 
 	case SC_WRITE_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]) << 9;
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
 				"WRITE(10)")) == 0)
@@ -2906,7 +2877,7 @@ static int do_scsi_command(struct fsg_de
 		break;
 
 	case SC_WRITE_12:
-		fsg->data_size_from_cmnd = get_be32(&fsg->cmnd[6]) << 9;
+		fsg->data_size_from_cmnd = get_unaligned_be32(&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_FROM_HOST,
 				(1<<1) | (0xf<<2) | (0xf<<6), 1,
 				"WRITE(12)")) == 0)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
nfs-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
usb-file-storagec-use-unaligned-access-helpers.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

