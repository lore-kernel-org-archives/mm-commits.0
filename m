From: akpm@osdl.org
Subject: + usb-mass-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:49:12 -0800
Message-ID: <200701092049.l09KnDAl014820@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417AbXAIUtY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:49:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d13f00l@gmail.com, greg@kroah.com


The patch titled
     USB MASS STORAGE: US_FL_IGNORE_RESIDUE needed for Aiptek MP3 Player
has been added to the -mm tree.  Its filename is
     usb-mass-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB MASS STORAGE: US_FL_IGNORE_RESIDUE needed for Aiptek MP3 Player
From: Dylan Taft <d13f00l@gmail.com>

Device will not work as a mass storage device without US_FL_IGNORE_RESIDUE.

I bought this mp3 player that takes SD cards here

http://www.aiptek.com/Merchant2/merchant.mvc?Screen=PROD&Product_Code=AX4&Category_Code=MP3&Store_Code=AS

I can provide the errors in dmesg, if necessary, but this flag was
determined as necessary by doing a quick google on the errors that were
shown in dmesg.

Signed-off-by: Dylan Taft <d13f00l@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/storage/unusual_devs.h |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN drivers/usb/storage/unusual_devs.h~usb-mass-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-mass-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player
+++ a/drivers/usb/storage/unusual_devs.h
@@ -1089,6 +1089,15 @@ UNUSUAL_DEV(  0x08bd, 0x1100, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_SINGLE_LUN),
 
+/* Submitted by Dylan Taft <d13f00l@gmail.com>
+ * US_FL_IGNORE_RESIDUE Needed
+ */
+UNUSUAL_DEV(  0x08ca, 0x3103, 0x0100, 0x0100,
+                "AIPTEK",
+                "Aiptek USB Keychain MP3 Player",
+                US_SC_DEVICE, US_PR_DEVICE, NULL,
+                US_FL_IGNORE_RESIDUE),
+
 /* Entry needed for flags. Moreover, all devices with this ID use
  * bulk-only transport, but _some_ falsely report Control/Bulk instead.
  * One example is "Trumpion Digital Research MYMP3".
_

Patches currently in -mm which might be from d13f00l@gmail.com are

usb-mass-storage-us_fl_ignore_residue-needed-for-aiptek-mp3-player.patch
