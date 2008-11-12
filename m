From: akpm@linux-foundation.org
Subject: - hid-add-support-for-the-new-unibody-macbooks.patch removed from -mm tree
Date: Wed, 12 Nov 2008 12:46:58 -0800
Message-ID: <200811122046.mACKkwtI006754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692AbYKLUrH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 15:47:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dmitry.torokhov@gmail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid: add support for the new unibody macbooks
has been removed from the -mm tree.  Its filename was
     hid-add-support-for-the-new-unibody-macbooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: add support for the new unibody macbooks
From: Henrik Rydberg <rydberg@euromail.se>

The unibody MacBook 5 and MacBook Pro 5 come with a new version of
the bcm5974 trackpad. This patch adds the USB device ids and the
appropriate quirks.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-apple.c |    6 ++++++
 drivers/hid/hid-core.c  |    3 +++
 drivers/hid/hid-ids.h   |    3 +++
 3 files changed, 12 insertions(+)

diff -puN drivers/hid/hid-apple.c~hid-add-support-for-the-new-unibody-macbooks drivers/hid/hid-apple.c
--- a/drivers/hid/hid-apple.c~hid-add-support-for-the-new-unibody-macbooks
+++ a/drivers/hid/hid-apple.c
@@ -418,6 +418,12 @@ static const struct hid_device_id apple_
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
diff -puN drivers/hid/hid-core.c~hid-add-support-for-the-new-unibody-macbooks drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-add-support-for-the-new-unibody-macbooks
+++ a/drivers/hid/hid-core.c
@@ -1567,6 +1567,9 @@ static const struct hid_device_id hid_mo
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING3_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ }
diff -puN drivers/hid/hid-ids.h~hid-add-support-for-the-new-unibody-macbooks drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h~hid-add-support-for-the-new-unibody-macbooks
+++ a/drivers/hid/hid-ids.h
@@ -82,6 +82,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI	0x0230
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO	0x0231
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_ATV_IRCONTROL	0x8241
_

Patches currently in -mm which might be from rydberg@euromail.se are

hwmon-applesmc-add-support-for-macbook-4.patch
linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

