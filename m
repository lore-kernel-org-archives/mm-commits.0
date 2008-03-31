From: akpm@linux-foundation.org
Subject: + dvb-usb-leadtek-winfast-usb-dtv-dongle-support.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:11:42 -0700
Message-ID: <200803312111.m2VLBjm6026253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755644AbYCaVMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darryl.green@aanet.com.au, mchehab@infradead.org


The patch titled
     dvb-usb: Leadtek Winfast USB DTV Dongle support
has been added to the -mm tree.  Its filename is
     dvb-usb-leadtek-winfast-usb-dtv-dongle-support.patch

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
Subject: dvb-usb: Leadtek Winfast USB DTV Dongle support
From: Darryl Green <darryl.green@aanet.com.au>

Support Winfast USB DTV dongle with device ID 6f01.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/dib0700_devices.c |    3 ++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-usb/dib0700_devices.c~dvb-usb-leadtek-winfast-usb-dtv-dongle-support drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c~dvb-usb-leadtek-winfast-usb-dtv-dongle-support
+++ a/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -905,6 +905,7 @@ struct usb_device_id dib0700_usb_id_tabl
 		{ USB_DEVICE(USB_VID_ASUS,      USB_PID_ASUS_U3100) },
 /* 25 */	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_STICK_3) },
 		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_MYTV_T) },
+		{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
 		{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -969,7 +970,7 @@ struct dvb_usb_device_properties dib0700
 				{ NULL },
 			},
 			{   "Leadtek Winfast DTV Dongle (STK7700P based)",
-				{ &dib0700_usb_id_table[8], NULL },
+				{ &dib0700_usb_id_table[8], &dib0700_usb_id_table[27] },
 				{ NULL },
 			},
 			{   "AVerMedia AVerTV DVB-T Express",
diff -puN drivers/media/dvb/dvb-usb/dvb-usb-ids.h~dvb-usb-leadtek-winfast-usb-dtv-dongle-support drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h~dvb-usb-leadtek-winfast-usb-dtv-dongle-support
+++ a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -172,6 +172,7 @@
 #define USB_PID_WINFAST_DTV_DONGLE_COLD			0x6025
 #define USB_PID_WINFAST_DTV_DONGLE_WARM			0x6026
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P		0x6f00
+#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2		0x6f01
 #define USB_PID_GENPIX_8PSK_REV_1_COLD			0x0200
 #define USB_PID_GENPIX_8PSK_REV_1_WARM			0x0201
 #define USB_PID_GENPIX_8PSK_REV_2			0x0202
_

Patches currently in -mm which might be from darryl.green@aanet.com.au are

dvb-usb-leadtek-winfast-usb-dtv-dongle-support.patch

