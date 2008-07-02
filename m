From: akpm@linux-foundation.org
Subject: - input-add-support-for-egalax-touchkit-usb-touchscreen-used-on-hp-tx1305us.patch removed from -mm tree
Date: Wed, 02 Jul 2008 09:50:01 -0700
Message-ID: <200807021650.m62Go1ne026236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbYGBQuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 12:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nyef@lisphacker.com, dtor@mail.ru, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     input: add support for eGalax TouchKit USB touchscreen used on HP tx1305us
has been removed from the -mm tree.  Its filename was
     input-add-support-for-egalax-touchkit-usb-touchscreen-used-on-hp-tx1305us.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add support for eGalax TouchKit USB touchscreen used on HP tx1305us
From: Alastair Bridgewater <nyef@lisphacker.com>

The eGalax touchscreen used in the HP tx1305us tablet PC (and presumably
the rest of the tx1000 series) uses a different format for events from the
device than the existing driver supports.

Add a new device description and interrupt packet handler for the
touchscreen used in the tx1305us, claiming the USB device ID for the
device that this patch was tested with from the older eGalax device code.

Signed-off-by: Alastair Bridgewater <nyef@lisphacker.com>
Cc: Greg KH <greg@kroah.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/usbtouchscreen.c |   21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~input-add-support-for-egalax-touchkit-usb-touchscreen-used-on-hp-tx1305us drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~input-add-support-for-egalax-touchkit-usb-touchscreen-used-on-hp-tx1305us
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -103,6 +103,7 @@ struct usbtouch_usb {
 enum {
 	DEVTPYE_DUMMY = -1,
 	DEVTYPE_EGALAX,
+	DEVTYPE_EGALAX2,
 	DEVTYPE_PANJIT,
 	DEVTYPE_3M,
 	DEVTYPE_ITM,
@@ -120,7 +121,7 @@ static struct usb_device_id usbtouch_dev
 	{USB_DEVICE(0x3823, 0x0001), .driver_info = DEVTYPE_EGALAX},
 	{USB_DEVICE(0x3823, 0x0002), .driver_info = DEVTYPE_EGALAX},
 	{USB_DEVICE(0x0123, 0x0001), .driver_info = DEVTYPE_EGALAX},
-	{USB_DEVICE(0x0eef, 0x0001), .driver_info = DEVTYPE_EGALAX},
+	{USB_DEVICE(0x0eef, 0x0001), .driver_info = DEVTYPE_EGALAX2},
 	{USB_DEVICE(0x0eef, 0x0002), .driver_info = DEVTYPE_EGALAX},
 	{USB_DEVICE(0x1234, 0x0001), .driver_info = DEVTYPE_EGALAX},
 	{USB_DEVICE(0x1234, 0x0002), .driver_info = DEVTYPE_EGALAX},
@@ -217,6 +218,15 @@ static int egalax_get_pkt_len(unsigned c
 
 	return 0;
 }
+
+static int egalax2_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+	dev->x = ((pkt[3] & 0x0F) << 8) | pkt[2];
+	dev->y = ((pkt[5] & 0x0F) << 8) | pkt[4];
+	dev->touch = pkt[1] & 0x01;
+
+	return 1;
+}
 #endif
 
 
@@ -555,6 +565,15 @@ static struct usbtouch_device_info usbto
 		.get_pkt_len	= egalax_get_pkt_len,
 		.read_data	= egalax_read_data,
 	},
+
+	[DEVTYPE_EGALAX2] = {
+		.min_xc		= 0x0,
+		.max_xc		= 0x0fff,
+		.min_yc		= 0x0,
+		.max_yc		= 0x0fff,
+		.rept_size	= 8,
+		.read_data	= egalax2_read_data,
+	},
 #endif
 
 #ifdef CONFIG_TOUCHSCREEN_USB_PANJIT
_

Patches currently in -mm which might be from nyef@lisphacker.com are

input-add-support-for-egalax-touchkit-usb-touchscreen-used-on-hp-tx1305us.patch

