From: akpm@linux-foundation.org
Subject: + hid-dont-allow-dealextreme-usb-radio-be-handled-by-usb-hid-driver.patch added to -mm tree
Date: Sat, 06 Dec 2008 19:36:48 -0800
Message-ID: <200812070336.mB73amw1017863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbYLGDhJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 22:37:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: klimov.linux@gmail.com, jirislaby@gmail.com, jkosina@suse.cz, mchehab@infradead.org, mlord@pobox.com, tobias.lorenz@gmx.net


The patch titled
     hid: don't allow DealExtreme usb-radio be handled by usb hid driver
has been added to the -mm tree.  Its filename is
     hid-dont-allow-dealextreme-usb-radio-be-handled-by-usb-hid-driver.patch

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
Subject: hid: don't allow DealExtreme usb-radio be handled by usb hid driver
From: Alexey Klimov <klimov.linux@gmail.com>

This device is already handled by radio-si470x driver, and we therefore
want usbhid to ignore it.  Patch places usb ids of that device in
ignore section of hid-core.c

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: Mark Lord <mlord@pobox.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    3 +++
 2 files changed, 4 insertions(+)

diff -puN drivers/hid/hid-core.c~hid-dont-allow-dealextreme-usb-radio-be-handled-by-usb-hid-driver drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-dont-allow-dealextreme-usb-radio-be-handled-by-usb-hid-driver
+++ a/drivers/hid/hid-core.c
@@ -1496,6 +1496,7 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CMEDIA, USB_DEVICE_ID_CM109) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_HIDCOM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_ULTRAMOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DEALEXTREAME, USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EARTHMATE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
diff -puN drivers/hid/hid-ids.h~hid-dont-allow-dealextreme-usb-radio-be-handled-by-usb-hid-driver drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h~hid-dont-allow-dealextreme-usb-radio-be-handled-by-usb-hid-driver
+++ a/drivers/hid/hid-ids.h
@@ -138,6 +138,9 @@
 #define USB_DEVICE_ID_CYPRESS_BARCODE_1	0xde61
 #define USB_DEVICE_ID_CYPRESS_BARCODE_2	0xde64
 
+#define USB_VENDOR_ID_DEALEXTREAME	0x10c5
+#define USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701	0x819a
+
 #define USB_VENDOR_ID_DELORME		0x1163
 #define USB_DEVICE_ID_DELORME_EARTHMATE 0x0100
 #define USB_DEVICE_ID_DELORME_EM_LT20	0x0200
_

Patches currently in -mm which might be from klimov.linux@gmail.com are

hid-dont-allow-dealextreme-usb-radio-be-handled-by-usb-hid-driver.patch

