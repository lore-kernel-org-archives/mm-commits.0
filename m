From: akpm@linux-foundation.org
Subject: + usb-serial-add-ftdi-usb-serial-converter-devices.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:09:22 -0800
Message-ID: <200903052209.n25M9MRb006767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbZCEWJb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:09:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.wachtler@atmel.com, greg@kroah.com, robert.richter@amd.com


The patch titled
     usb/serial: add FTDI USB/Serial converter devices
has been added to the -mm tree.  Its filename is
     usb-serial-add-ftdi-usb-serial-converter-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb/serial: add FTDI USB/Serial converter devices
From: Axel Wachtler <axel.wachtler@atmel.com>

Add the following devices to the USB FTDI SIO device table:

 Bus 001 Device 009: ID 03eb:2109 Atmel Corp.
 http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4187

 Bus 001 Device 008: ID 1cf1:0001
 http://www.dresden-elektronik.de/shop/prod75.html

 Bus 001 Device 007: ID 1c1f:0004
 http://www.dresden-elektronik.de/shop/prod64.html

Signed-off-by: Axel Wachtler <axel.wachtler@atmel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    3 +++
 drivers/usb/serial/ftdi_sio.h |   13 +++++++++++++
 2 files changed, 16 insertions(+)

diff -puN drivers/usb/serial/ftdi_sio.c~usb-serial-add-ftdi-usb-serial-converter-devices drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-serial-add-ftdi-usb-serial-converter-devices
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -663,6 +663,9 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(ALTI2_VID, ALTI2_N3_PID) },
 	{ USB_DEVICE(FTDI_VID, DIEBOLD_BCS_SE923_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_HUC_PID) },
+	{ USB_DEVICE(ATMEL_VID, STK541_PID) },
+	{ USB_DEVICE(DE_VID, STB_PID) },
+	{ USB_DEVICE(DE_VID, WHT_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff -puN drivers/usb/serial/ftdi_sio.h~usb-serial-add-ftdi-usb-serial-converter-devices drivers/usb/serial/ftdi_sio.h
--- a/drivers/usb/serial/ftdi_sio.h~usb-serial-add-ftdi-usb-serial-converter-devices
+++ a/drivers/usb/serial/ftdi_sio.h
@@ -893,6 +893,19 @@
 #define DIEBOLD_BCS_SE923_PID	0xfb99
 
 /*
+ * Atmel STK541
+ */
+#define ATMEL_VID		0x03eb /* Vendor ID */
+#define STK541_PID		0x2109 /* Zigbee Controller */
+
+/*
+ * Dresden Elektronic Sensor Terminal Board
+ */
+#define DE_VID			0x1cf1 /* Vendor ID */
+#define STB_PID			0x0001 /* Sensor Terminal Board */
+#define WHT_PID			0x0004 /* Wireless Handheld Terminal */
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
_

Patches currently in -mm which might be from axel.wachtler@atmel.com are

usb-serial-add-ftdi-usb-serial-converter-devices.patch

