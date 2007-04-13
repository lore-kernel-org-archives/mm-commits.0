From: akpm@linux-foundation.org
Subject: - berry_chargec-8100-8800-support.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:35:14 -0700
Message-ID: <200704132335.l3DNZERc012871@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60902 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030433AbXDMXfR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:35:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tengel@steelyecho.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     berry_charge.c 8100/8800 support
has been removed from the -mm tree.  Its filename was
     berry_chargec-8100-8800-support.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: berry_charge.c 8100/8800 support
From: "troy engel" <tengel@steelyecho.com>

berry_charge.c will only work for older models and not the current/newer ones
being released.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/berry_charge.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/usb/misc/berry_charge.c~berry_chargec-8100-8800-support drivers/usb/misc/berry_charge.c
--- a/drivers/usb/misc/berry_charge.c~berry_chargec-8100-8800-support
+++ a/drivers/usb/misc/berry_charge.c
@@ -26,6 +26,8 @@
 
 #define RIM_VENDOR		0x0fca
 #define BLACKBERRY		0x0001
+#define BLACKBERRY_CONTROL	0x0004
+#define BLACKBERRY_STORAGE	0x0006
 
 static int debug;
 
@@ -38,6 +40,8 @@ static int debug;
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(RIM_VENDOR, BLACKBERRY) },
+	{ USB_DEVICE(RIM_VENDOR, BLACKBERRY_CONTROL) },
+	{ USB_DEVICE(RIM_VENDOR, BLACKBERRY_STORAGE) },
 	{ },					/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
_

Patches currently in -mm which might be from tengel@steelyecho.com are

berry_chargec-8100-8800-support.patch
