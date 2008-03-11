From: akpm@linux-foundation.org
Subject: + usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:26:57 -0700
Message-ID: <200803110526.m2B5QvLo024259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbYCKF1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: const@tltsu.ru, greg@kroah.com, mdharm-kernel@one-eyed-alien.net


The patch titled
     usb: add support for Motorola ROKR Z6 cellphone in mass storage mode
has been added to the -mm tree.  Its filename is
     usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode.patch

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
Subject: usb: add support for Motorola ROKR Z6 cellphone in mass storage mode
From: Constantin Baranov <const@tltsu.ru>

Motorola ROKR Z6 cellphone has bugs in its USB, so it is impossible to use it
as mass storage.  Patch describes new "unusual" USB device for it with
FIX_INQUIRY and FIX_CAPACITY flags and new BULK_IGNORE_TAG flag.  Last flag
relaxes check for equality of bcs->Tag and us->tag in usb_stor_Bulk_transport
routine.

Signed-off-by: Constantin Baranov <const@tltsu.ru>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/transport.c    |    3 ++-
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 include/linux/usb_usual.h          |    4 +++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/usb/storage/transport.c~usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode drivers/usb/storage/transport.c
--- a/drivers/usb/storage/transport.c~usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode
+++ a/drivers/usb/storage/transport.c
@@ -1009,7 +1009,8 @@ int usb_stor_Bulk_transport(struct scsi_
 	US_DEBUGP("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
 			le32_to_cpu(bcs->Signature), bcs->Tag, 
 			residue, bcs->Status);
-	if (bcs->Tag != us->tag || bcs->Status > US_BULK_STAT_PHASE) {
+	if (!(bcs->Tag == us->tag || (us->flags & US_FL_BULK_IGNORE_TAG)) ||
+		bcs->Status > US_BULK_STAT_PHASE) {
 		US_DEBUGP("Bulk logical error\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
diff -puN drivers/usb/storage/unusual_devs.h~usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode
+++ a/drivers/usb/storage/unusual_devs.h
@@ -1589,6 +1589,16 @@ UNUSUAL_DEV(  0x22b8, 0x4810, 0x0001, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
+/*
+ * Patch by Constantin Baranov <const@tltsu.ru>
+ * Report by Andreas Koenecke
+ */
+UNUSUAL_DEV(  0x22b8, 0x6426, 0x0101, 0x0101,
+		"Motorola",
+		"MSnc.",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_INQUIRY | US_FL_FIX_CAPACITY | US_FL_BULK_IGNORE_TAG),
+
 /* Reported by Radovan Garabik <garabik@kassiopeia.juls.savba.sk> */
 UNUSUAL_DEV(  0x2735, 0x100b, 0x0000, 0x9999,
 		"MPIO",
diff -puN include/linux/usb_usual.h~usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode include/linux/usb_usual.h
--- a/include/linux/usb_usual.h~usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode
+++ a/include/linux/usb_usual.h
@@ -50,7 +50,9 @@
 	US_FLAG(CAPACITY_HEURISTICS,	0x00001000)		\
 		/* sometimes sizes is too big */		\
 	US_FLAG(MAX_SECTORS_MIN,0x00002000)			\
-		/* Sets max_sectors to arch min */
+		/* Sets max_sectors to arch min */		\
+	US_FLAG(BULK_IGNORE_TAG,0x00004000)			\
+		/* Ignore tag mismatch in bulk operations */
 
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
_

Patches currently in -mm which might be from const@tltsu.ru are

usb-add-support-for-motorola-rokr-z6-cellphone-in-mass-storage-mode.patch

