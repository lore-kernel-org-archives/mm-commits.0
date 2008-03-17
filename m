From: akpm@linux-foundation.org
Subject: - isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:56 -0700
Message-ID: <200803172100.m2HL0uuS030895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbYCQVFh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:05:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharrosh@panasas.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, mdharm-usb@one-eyed-alien.net, oliver@neukum.org, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     isd200: Allocate sense_buffer for hacked up scsi_cmnd
has been removed from the -mm tree.  Its filename was
     isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isd200: Allocate sense_buffer for hacked up scsi_cmnd
From: Boaz Harrosh <bharrosh@panasas.com>

Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
own struct scsi_cmnd like here isd200, must also take care of their own
sense_buffer.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/isd200.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/usb/storage/isd200.c~isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd drivers/usb/storage/isd200.c
--- a/drivers/usb/storage/isd200.c~isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd
+++ a/drivers/usb/storage/isd200.c
@@ -1469,6 +1469,7 @@ static void isd200_free_info_ptrs(void *
 	if (info) {
 		kfree(info->id);
 		kfree(info->RegsBuf);
+		kfree(info->srb.sense_buffer);
 	}
 }
 
@@ -1494,7 +1495,9 @@ static int isd200_init_info(struct us_da
 				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
-		if (!info->id || !info->RegsBuf) {
+		info->srb.sense_buffer =
+				kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+		if (!info->id || !info->RegsBuf || !info->srb.sense_buffer) {
 			isd200_free_info_ptrs(info);
 			kfree(info);
 			retStatus = ISD200_ERROR;
_

Patches currently in -mm which might be from bharrosh@panasas.com are

git-scsi-misc.patch
git-scsi-rc-fixes.patch
isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch

