From: akpm@linux-foundation.org
Subject: + isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd.patch added to -mm tree
Date: Thu, 13 Mar 2008 13:01:20 -0700
Message-ID: <200803132001.m2DK1Kc9030357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757276AbYCMUEi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 16:04:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, James.Bottomley@HansenPartnership.com, greg@kroah.com, mdharm-usb@one-eyed-alien.net, oliver@neukum.org, stern@rowland.harvard.edu


The patch titled
     isd200: Allocate sense_buffer for hacked up scsi_cmnd
has been added to the -mm tree.  Its filename is
     isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd.patch

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
gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch
isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch
isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd.patch

