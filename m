From: akpm@osdl.org
Subject: + usb-p990i-is-an-unusual-device.patch added to -mm tree
Date: Thu, 01 Feb 2007 13:37:53 -0800
Message-ID: <200702012137.l11LbrxU023586@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbXBAViU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 16:38:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, kernel@nn7.de


The patch titled
     usb: P990i is an unusual device
has been added to the -mm tree.  Its filename is
     usb-p990i-is-an-unusual-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: P990i is an unusual device
From: Alan Stern <stern@rowland.harvard.edu>

Soeren Sonnenburg wrote:

  I am trying to use a P990 phone in via mass storage under linux.  I was
  able to copy data to/from the phone without trouble under winxp but
  receive millions of I/O errors (see below (*), basically on any sector).

The log revealed that the phone's firmware returns garbage values in the
Residue field for some WRITEs.  This patch should take care of it.

Cc: Soeren Sonnenburg <kernel@nn7.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/storage/unusual_devs.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/usb/storage/unusual_devs.h~usb-p990i-is-an-unusual-device drivers/usb/storage/unusual_devs.h
--- a/drivers/usb/storage/unusual_devs.h~usb-p990i-is-an-unusual-device
+++ a/drivers/usb/storage/unusual_devs.h
@@ -1327,12 +1327,13 @@ UNUSUAL_DEV(  0x0fce, 0xd008, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_NO_WP_DETECT ),
 
-/* Reported by Jan Mate <mate@fiit.stuba.sk> */
+/* Reported by Jan Mate <mate@fiit.stuba.sk>
+ * and by Soeren Sonnenburg <kernel@nn7.de> */
 UNUSUAL_DEV(  0x0fce, 0xe030, 0x0000, 0x0000,
 		"Sony Ericsson",
 		"P990i",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
+		US_FL_FIX_CAPACITY | US_FL_IGNORE_RESIDUE ),
 
 /* Reported by Emmanuel Vasilakis <evas@forthnet.gr> */
 UNUSUAL_DEV(  0x0fce, 0xe031, 0x0000, 0x0000,
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

scsi-handle-bad-inquiry-responses.patch
fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
usb-p990i-is-an-unusual-device.patch
arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
