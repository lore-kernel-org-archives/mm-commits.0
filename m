From: akpm@linux-foundation.org
Subject: + hid-support-apple-mini-aluminum-keyboard.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:21:22 -0800
Message-ID: <200903052221.n25MLMh9007872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbZCEWVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:21:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ryan@finnie.org, jkosina@suse.cz


The patch titled
     hid: support Apple mini aluminum keyboard
has been added to the -mm tree.  Its filename is
     hid-support-apple-mini-aluminum-keyboard.patch

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

hid-support-apple-mini-aluminum-keyboard.patch

