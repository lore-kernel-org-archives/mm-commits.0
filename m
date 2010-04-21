From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff.patch added to -mm tree
Date: Wed, 21 Apr 2010 15:08:02 -0700
Message-ID: <201004212208.o3LM82WL012621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299Ab0DUWIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 18:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maheshkuruganti@gmail.com, gregkh@suse.de, smurf@smurf.noris.de


The patch titled
     drivers/usb/serial/option.c: ZTEAC8710 support with Device ID 0xffff
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff.patch

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
Subject: drivers/usb/serial/option.c: ZTEAC8710 support with Device ID 0xffff
From: Mahesh Kuruganti <maheshkuruganti@gmail.com>

Extend support to AC8710 with 0xffff product ID.  I tested it and it
compiled with no problem and I am using it now as i type.

Signed-off-by: Mahesh Kuruganti <maheshkuruganti@gmail.com>
Cc: Matthias Urlichs <smurf@smurf.noris.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/usb/serial/option.c~drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff
+++ a/drivers/usb/serial/option.c
@@ -305,6 +305,8 @@ static int  option_resume(struct usb_ser
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
 #define ZTE_PRODUCT_AC8710			0xfff1
 #define ZTE_PRODUCT_AC2726			0xfff5
+/* There seems to be an Alternate Device ID for the AC8710 supplied in India */
+#define ZTE_PRODUCT_AC8710T			0xffff
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -678,6 +680,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0141, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710T, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_AC2726, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
_

Patches currently in -mm which might be from maheshkuruganti@gmail.com are

drivers-usb-serial-optionc-zteac8710-support-with-device-id-0xffff.patch

