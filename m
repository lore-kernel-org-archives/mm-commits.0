From: akpm@linux-foundation.org
Subject: [merged] hid-support-apple-mini-aluminum-keyboard.patch removed from -mm tree
Date: Fri, 06 Mar 2009 11:28:10 -0800
Message-ID: <200903061928.n26JSAO4022656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043AbZCFT2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 14:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan@finnie.org, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid: support Apple mini aluminum keyboard
has been removed from the -mm tree.  Its filename was
     hid-support-apple-mini-aluminum-keyboard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid: support Apple mini aluminum keyboard
From: Ryan Finnie <ryan@finnie.org>

New USB device ids and quirks for the "mini" Apple USB aluminum keyboards
released Tuesday, model A1242.  Note that while I own the ANSI (0x021d)
version and cannot verify that the ISO (0x021e) and JIS (0x021f) versions
exist, previous releases have followed the triple id convention for awhile
now, and the device ids fit perfectly between
USB_DEVICE_ID_APPLE_GEYSER4_* and USB_DEVICE_ID_APPLE_ALU_*.

Aside: Considering the device ids for the mini aluminum come before the
ids for the regular aluminum, and the model for the mini is A1242 while
the regular is A1243, it appears the mini aluminum keyboard may have been
developed before the regular, but delayed a few years.

Signed-off-by: Ryan Finnie <ryan@finnie.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-apple.c |    6 ++++++
 drivers/hid/hid-core.c  |    3 +++
 drivers/hid/hid-ids.h   |    3 +++
 3 files changed, 12 insertions(+)

diff -puN drivers/hid/hid-apple.c~hid-support-apple-mini-aluminum-keyboard drivers/hid/hid-apple.c
--- a/drivers/hid/hid-apple.c~hid-support-apple-mini-aluminum-keyboard
+++ a/drivers/hid/hid-apple.c
@@ -387,6 +387,12 @@ static const struct hid_device_id apple_
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
 			APPLE_RDESC_JIS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_JIS),
+		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI),
 		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO),
diff -puN drivers/hid/hid-core.c~hid-support-apple-mini-aluminum-keyboard drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-support-apple-mini-aluminum-keyboard
+++ a/drivers/hid/hid-core.c
@@ -1236,6 +1236,9 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_MINI_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_JIS) },
diff -puN drivers/hid/hid-ids.h~hid-support-apple-mini-aluminum-keyboard drivers/hid/hid-ids.h
--- a/drivers/hid/hid-ids.h~hid-support-apple-mini-aluminum-keyboard
+++ a/drivers/hid/hid-ids.h
@@ -67,6 +67,9 @@
 #define USB_DEVICE_ID_APPLE_GEYSER4_ANSI	0x021a
 #define USB_DEVICE_ID_APPLE_GEYSER4_ISO	0x021b
 #define USB_DEVICE_ID_APPLE_GEYSER4_JIS	0x021c
+#define USB_DEVICE_ID_APPLE_ALU_MINI_ANSI	0x021d
+#define USB_DEVICE_ID_APPLE_ALU_MINI_ISO	0x021e
+#define USB_DEVICE_ID_APPLE_ALU_MINI_JIS	0x021f
 #define USB_DEVICE_ID_APPLE_ALU_ANSI	0x0220
 #define USB_DEVICE_ID_APPLE_ALU_ISO	0x0221
 #define USB_DEVICE_ID_APPLE_ALU_JIS	0x0222
_

Patches currently in -mm which might be from ryan@finnie.org are

linux-next.patch

