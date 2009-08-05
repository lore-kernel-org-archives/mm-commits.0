From: akpm@linux-foundation.org
Subject: + ark3116-add-irda-support-for-gembird-uir-22.patch added to -mm tree
Date: Wed, 05 Aug 2009 10:59:42 -0700
Message-ID: <200908051759.n75HxgAi018014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbZHER76 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 13:59:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, greg@kroah.com


The patch titled
     ark3116: add IrDA support for Gembird UIR-22
has been added to the -mm tree.  Its filename is
     ark3116-add-irda-support-for-gembird-uir-22.patch

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
Subject: ark3116: add IrDA support for Gembird UIR-22
From: Ondrej Zary <linux@rainbow-software.org>

Add IrDA support to ark3116 driver.  This makes Gembird UIR-22 USB to IrDA
adapter work (vendor ID 0x18ec, device ID 0x3118).  This adapter contains
ARK3116T USB serial chip and an IrDA transceiver, thus a command like
"irattach /dev/ttyUSB0 -s" is needed.

All magic numbers were captured using usbsnoop from windows driver that
came with the device.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ark3116.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN drivers/usb/serial/ark3116.c~ark3116-add-irda-support-for-gembird-uir-22 drivers/usb/serial/ark3116.c
--- a/drivers/usb/serial/ark3116.c~ark3116-add-irda-support-for-gembird-uir-22
+++ a/drivers/usb/serial/ark3116.c
@@ -31,10 +31,20 @@ static int debug;
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x6547, 0x0232) },
+	{ USB_DEVICE(0x18ec, 0x3118) },		/* USB to IrDA adapter */
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
 
+static int is_irda(struct usb_serial *serial)
+{
+	struct usb_device *dev = serial->dev;
+	if (le16_to_cpu(dev->descriptor.idVendor) == 0x18ec &&
+			le16_to_cpu(dev->descriptor.idProduct) == 0x3118)
+		return 1;
+	return 0;
+}
+
 static inline void ARK3116_SND(struct usb_serial *serial, int seq,
 			       __u8 request, __u8 requesttype,
 			       __u16 value, __u16 index)
@@ -84,11 +94,21 @@ static int ark3116_attach(struct usb_ser
 		return -ENOMEM;
 	}
 
+	if (is_irda(serial))
+		dbg("IrDA mode");
+
 	/* 3 */
 	ARK3116_SND(serial, 3, 0xFE, 0x40, 0x0008, 0x0002);
 	ARK3116_SND(serial, 4, 0xFE, 0x40, 0x0008, 0x0001);
 	ARK3116_SND(serial, 5, 0xFE, 0x40, 0x0000, 0x0008);
-	ARK3116_SND(serial, 6, 0xFE, 0x40, 0x0000, 0x000B);
+	ARK3116_SND(serial, 6, 0xFE, 0x40, is_irda(serial) ? 0x0001 : 0x0000,
+		    0x000B);
+
+	if (is_irda(serial)) {
+		ARK3116_SND(serial, 1001, 0xFE, 0x40, 0x0000, 0x000C);
+		ARK3116_SND(serial, 1002, 0xFE, 0x40, 0x0041, 0x000D);
+		ARK3116_SND(serial, 1003, 0xFE, 0x40, 0x0001, 0x000A);
+	}
 
 	/* <-- seq7 */
 	ARK3116_RCV(serial,  7, 0xFE, 0xC0, 0x0000, 0x0003, 0x00, buf);
@@ -125,6 +145,8 @@ static int ark3116_attach(struct usb_ser
 	ARK3116_SND(serial, 147, 0xFE, 0x40, 0x0083, 0x0003);
 	ARK3116_SND(serial, 148, 0xFE, 0x40, 0x0038, 0x0000);
 	ARK3116_SND(serial, 149, 0xFE, 0x40, 0x0001, 0x0001);
+	if (is_irda(serial))
+		ARK3116_SND(serial, 1004, 0xFE, 0x40, 0x0000, 0x0009);
 	ARK3116_SND(serial, 150, 0xFE, 0x40, 0x0003, 0x0003);
 	ARK3116_RCV(serial, 151, 0xFE, 0xC0, 0x0000, 0x0004, 0x03, buf);
 	ARK3116_SND(serial, 152, 0xFE, 0x40, 0x0000, 0x0003);
_

Patches currently in -mm which might be from linux@rainbow-software.org are

linux-next.patch
ark3116-add-irda-support-for-gembird-uir-22.patch

