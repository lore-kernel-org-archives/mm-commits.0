From: akpm@linux-foundation.org
Subject: + usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:07:43 -0800
Message-ID: <200903062207.n26M7h8B004323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbZCFWH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:07:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, greg@kroah.com


The patch titled
     usb/serial: ftdi: enable UART detection on gnICE JTAG adaptors blacklist interface0
has been added to the -mm tree.  Its filename is
     usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch

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
Subject: usb/serial: ftdi: enable UART detection on gnICE JTAG adaptors blacklist interface0
From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 9 insertions(+)

diff -puN drivers/usb/serial/ftdi_sio.c~usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0 drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -666,6 +666,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(ATMEL_VID, STK541_PID) },
 	{ USB_DEVICE(DE_VID, STB_PID) },
 	{ USB_DEVICE(DE_VID, WHT_PID) },
+	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff -puN drivers/usb/serial/ftdi_sio.h~usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0 drivers/usb/serial/ftdi_sio.h
--- a/drivers/usb/serial/ftdi_sio.h~usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0
+++ a/drivers/usb/serial/ftdi_sio.h
@@ -906,6 +906,13 @@
 #define WHT_PID			0x0004 /* Wireless Handheld Terminal */
 
 /*
+ * Blackfin gnICE JTAG
+ * http://docs.blackfin.uclinux.org/doku.php?id=hw:jtag:gnice
+ */
+#define ADI_VID 		0x0456
+#define ADI_GNICE_PID 		0xF000
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-ad7879-touchscreen-driver.patch
usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch

