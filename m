From: akpm@linux-foundation.org
Subject: + isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:45:39 -0700
Message-ID: <200803120445.m2C4jdcu010579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbYCLErD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, gregkh@suse.de, mdharm-usb@one-eyed-alien.net, oliver@neukum.org, snakebyte@gmx.de, stern@rowland.harvard.edu, svens@stackframe.org


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

Since the separation of sense_buffer from scsi_cmnd, Drivers that hack
their own struct scsi_cmnd like here isd200, must also take care of their
own sense_buffer.

(akpm: needs runtime testing?)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Sven Schnelle <svens@stackframe.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/isd200.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/usb/storage/isd200.c~isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd drivers/usb/storage/isd200.c
--- a/drivers/usb/storage/isd200.c~isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd
+++ a/drivers/usb/storage/isd200.c
@@ -294,6 +294,7 @@ struct isd200_info {
 	unsigned char MaxLUNs;
 	struct scsi_cmnd srb;
 	struct scatterlist sg;
+	u8*	sense_buffer;
 };
 
 
@@ -1469,6 +1470,7 @@ static void isd200_free_info_ptrs(void *
 	if (info) {
 		kfree(info->id);
 		kfree(info->RegsBuf);
+		kfree(info->sense_buffer);
 	}
 }
 
@@ -1494,11 +1496,14 @@ static int isd200_init_info(struct us_da
 				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
-		if (!info->id || !info->RegsBuf) {
+		info->sense_buffer = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+		if (!info->id || !info->RegsBuf || !info->sense_buffer) {
 			isd200_free_info_ptrs(info);
 			kfree(info);
 			retStatus = ISD200_ERROR;
 		}
+		else
+			info->srb.sense_buffer = info->sense_buffer;
 	}
 
 	if (retStatus == ISD200_GOOD) {
_

Patches currently in -mm which might be from bharrosh@panasas.com are

git-scsi-misc.patch
gdth-allocate-sense_buffer-to-prevent-null-pointer-dereference.patch
isd200-allocate-sense_buffer-for-hacked-up-scsi_cmnd.patch

