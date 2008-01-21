From: akpm@linux-foundation.org
Subject: - usbtouchscreen-fix-buffer-overflow-make-more-egalax-work.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:14:11 -0800
Message-ID: <200801212314.m0LNEBtf024960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760029AbYAUXTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch, dtor@mail.ru, greg@kroah.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     usbtouchscreen: fix buffer overflow, make more egalax work
has been removed from the -mm tree.  Its filename was
     usbtouchscreen-fix-buffer-overflow-make-more-egalax-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usbtouchscreen: fix buffer overflow, make more egalax work
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>

Fixes a buffer overflow in mutli-packet handling code.  The overflow can
only happen with eGalax devices and is even there very unlikely (only
non-report packet are affected any only when truncated after the first
byte).

It also changes the mutli-packet handling code not to drop unknown packets,
but rather just drop one byte.  This allows synchronizing on report packets
in the data stream.  It's required for some egalax devices to work at all.

Also removes the pointless 'flags' member of the device struct and sets the
version number to 0.6.  And some minor cleanups.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/usbtouchscreen.c |   55 +++++++++++--------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-fix-buffer-overflow-make-more-egalax-work drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-fix-buffer-overflow-make-more-egalax-work
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -11,6 +11,7 @@
  *  - DMC TSC-10/25
  *  - IRTOUCHSYSTEMS/UNITOP
  *  - IdealTEK URTC1000
+ *  - General Touch
  *  - GoTop Super_Q2/GogoPen/PenPower tablets
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
@@ -50,7 +51,7 @@
 #include <linux/usb/input.h>
 
 
-#define DRIVER_VERSION		"v0.5"
+#define DRIVER_VERSION		"v0.6"
 #define DRIVER_AUTHOR		"Daniel Ritz <daniel.ritz@gmx.ch>"
 #define DRIVER_DESC		"USB Touchscreen Driver"
 
@@ -65,17 +66,21 @@ struct usbtouch_device_info {
 	int min_yc, max_yc;
 	int min_press, max_press;
 	int rept_size;
-	int flags;
 
 	void (*process_pkt) (struct usbtouch_usb *usbtouch, unsigned char *pkt, int len);
+
+	/*
+	 * used to get the packet len. possible return values:
+	 * > 0: packet len
+	 * = 0: skip one byte
+	 * < 0: -return value more bytes needed
+	 */
 	int  (*get_pkt_len) (unsigned char *pkt, int len);
+
 	int  (*read_data)   (struct usbtouch_usb *usbtouch, unsigned char *pkt);
 	int  (*init)        (struct usbtouch_usb *usbtouch);
 };
 
-#define USBTOUCH_FLG_BUFFER	0x01
-
-
 /* a usbtouch device */
 struct usbtouch_usb {
 	unsigned char *data;
@@ -94,15 +99,6 @@ struct usbtouch_usb {
 };
 
 
-#if defined(CONFIG_TOUCHSCREEN_USB_EGALAX) || defined(CONFIG_TOUCHSCREEN_USB_ETURBO) || defined(CONFIG_TOUCHSCREEN_USB_IDEALTEK)
-#define MULTI_PACKET
-#endif
-
-#ifdef MULTI_PACKET
-static void usbtouch_process_multi(struct usbtouch_usb *usbtouch,
-                                   unsigned char *pkt, int len);
-#endif
-
 /* device types */
 enum {
 	DEVTPYE_DUMMY = -1,
@@ -186,6 +182,10 @@ static struct usb_device_id usbtouch_dev
 
 #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
 
+#ifndef MULTI_PACKET
+#define MULTI_PACKET
+#endif
+
 #define EGALAX_PKT_TYPE_MASK		0xFE
 #define EGALAX_PKT_TYPE_REPT		0x80
 #define EGALAX_PKT_TYPE_DIAG		0x0A
@@ -323,6 +323,9 @@ static int itm_read_data(struct usbtouch
  * eTurboTouch part
  */
 #ifdef CONFIG_TOUCHSCREEN_USB_ETURBO
+#ifndef MULTI_PACKET
+#define MULTI_PACKET
+#endif
 static int eturbo_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 {
 	unsigned int shift;
@@ -461,6 +464,9 @@ static int irtouch_read_data(struct usbt
  * IdealTEK URTC1000 Part
  */
 #ifdef CONFIG_TOUCHSCREEN_USB_IDEALTEK
+#ifndef MULTI_PACKET
+#define MULTI_PACKET
+#endif
 static int idealtek_get_pkt_len(unsigned char *buf, int len)
 {
 	if (buf[0] & 0x80)
@@ -525,6 +531,11 @@ static int gotop_read_data(struct usbtou
 /*****************************************************************************
  * the different device descriptors
  */
+#ifdef MULTI_PACKET
+static void usbtouch_process_multi(struct usbtouch_usb *usbtouch,
+				   unsigned char *pkt, int len);
+#endif
+
 static struct usbtouch_device_info usbtouch_dev_info[] = {
 #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
 	[DEVTYPE_EGALAX] = {
@@ -533,7 +544,6 @@ static struct usbtouch_device_info usbto
 		.min_yc		= 0x0,
 		.max_yc		= 0x07ff,
 		.rept_size	= 16,
-		.flags		= USBTOUCH_FLG_BUFFER,
 		.process_pkt	= usbtouch_process_multi,
 		.get_pkt_len	= egalax_get_pkt_len,
 		.read_data	= egalax_read_data,
@@ -582,7 +592,6 @@ static struct usbtouch_device_info usbto
 		.min_yc		= 0x0,
 		.max_yc		= 0x07ff,
 		.rept_size	= 8,
-		.flags		= USBTOUCH_FLG_BUFFER,
 		.process_pkt	= usbtouch_process_multi,
 		.get_pkt_len	= eturbo_get_pkt_len,
 		.read_data	= eturbo_read_data,
@@ -630,7 +639,6 @@ static struct usbtouch_device_info usbto
 		.min_yc		= 0x0,
 		.max_yc		= 0x0fff,
 		.rept_size	= 8,
-		.flags		= USBTOUCH_FLG_BUFFER,
 		.process_pkt	= usbtouch_process_multi,
 		.get_pkt_len	= idealtek_get_pkt_len,
 		.read_data	= idealtek_read_data,
@@ -738,11 +746,14 @@ static void usbtouch_process_multi(struc
 	pos = 0;
 	while (pos < buf_len) {
 		/* get packet len */
-		pkt_len = usbtouch->type->get_pkt_len(buffer + pos, len);
+		pkt_len = usbtouch->type->get_pkt_len(buffer + pos,
+							buf_len - pos);
 
-		/* unknown packet: drop everything */
-		if (unlikely(!pkt_len))
-			goto out_flush_buf;
+		/* unknown packet: skip one byte */
+		if (unlikely(!pkt_len)) {
+			pos++;
+			continue;
+		}
 
 		/* full packet: process */
 		if (likely((pkt_len > 0) && (pkt_len <= buf_len - pos))) {
@@ -857,7 +868,7 @@ static int usbtouch_probe(struct usb_int
 	if (!usbtouch->data)
 		goto out_free;
 
-	if (type->flags & USBTOUCH_FLG_BUFFER) {
+	if (type->get_pkt_len) {
 		usbtouch->buffer = kmalloc(type->rept_size, GFP_KERNEL);
 		if (!usbtouch->buffer)
 			goto out_free_buffers;
_

Patches currently in -mm which might be from daniel.ritz-ml@swissonline.ch are

origin.patch
