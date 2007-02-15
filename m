From: akpm@linux-foundation.org
Subject: - usb-p990i-is-an-unusual-device.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:51:48 -0800
Message-ID: <200702150851.l1F8pm06025320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40395 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965575AbXBOIwU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, kernel@nn7.de, mm-commits@vger.kernel.org


The patch titled
     usb: P990i is an unusual device
has been removed from the -mm tree.  Its filename was
     usb-p990i-is-an-unusual-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/unusual_devs.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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

origin.patch
scsi-handle-bad-inquiry-responses.patch
