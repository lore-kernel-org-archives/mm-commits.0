From: akpm@linux-foundation.org
Subject: [merged] input-bcm5974-add-support-for-the-macbook-5-unibody.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:17:39 -0700
Message-ID: <200904291917.n3TJHdNj030667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253AbZD2TTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dmlary@gmail.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: bcm5974: Add support for the Macbook 5 (Unibody)
has been removed from the -mm tree.  Its filename was
     input-bcm5974-add-support-for-the-macbook-5-unibody.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: bcm5974: Add support for the Macbook 5 (Unibody)
From: "Henrik Rydberg" <rydberg@euromail.se>

Add support for the new unibody Macbook, with physically integrated button
and trackpad.  A new button, BTN_TOOL_PRESS, is introduced to allow for
non-trivial handling of this device in user space.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: David M. Lary <dmlary@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |   42 ++++++++++++++++++++++++++++++--
 include/linux/input.h         |    1 
 2 files changed, 41 insertions(+), 2 deletions(-)

diff -puN drivers/input/mouse/bcm5974.c~input-bcm5974-add-support-for-the-macbook-5-unibody drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~input-bcm5974-add-support-for-the-macbook-5-unibody
+++ a/drivers/input/mouse/bcm5974.c
@@ -51,6 +51,10 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI	0x0230
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO	0x0231
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232
+/* Macbook5,1 (unibody), aka wellspring3 */
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
+#define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
@@ -72,6 +76,10 @@ static const struct usb_device_id bcm597
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_ISO),
 	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_JIS),
+	/* Macbook5,1 */
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
 	/* Terminating entry */
 	{}
 };
@@ -98,11 +106,19 @@ struct bt_data {
 
 /* trackpad header types */
 enum tp_type {
-	TYPE1			/* plain trackpad */
+	TYPE1,			/* plain trackpad */
+	TYPE2			/* button integrated in trackpad */
 };
 
 /* trackpad finger data offsets */
 #define FINGER_TYPE1		26
+#define FINGER_TYPE2		30
+
+/* trackpad button data offsets */
+#define BUTTON_TYPE2		15
+
+/* integrated button capability by configuration */
+#define HAS_INTEGRATED_BUTTON(c)	(c->tp_type == TYPE2)
 
 /* trackpad finger structure */
 struct tp_finger {
@@ -202,6 +218,17 @@ static const struct bcm5974_config bcm59
 		{ DIM_X, DIM_X / SN_COORD, -4824, 4824 },
 		{ DIM_Y, DIM_Y / SN_COORD, -172, 4290 }
 	},
+	{
+		USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING3_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING3_JIS,
+		0x84, sizeof(struct bt_data),
+		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
+		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
+		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
+		{ DIM_X, DIM_X / SN_COORD, -4460, 5166 },
+		{ DIM_Y, DIM_Y / SN_COORD, -75, 6700 }
+	},
 	{}
 };
 
@@ -259,6 +286,8 @@ static void setup_events_to_report(struc
 	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
+	if (HAS_INTEGRATED_BUTTON(cfg))
+		__set_bit(BTN_TOOL_PRESS, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
 }
 
@@ -281,7 +310,7 @@ static int report_tp_state(struct bcm597
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
 	int raw_p, raw_w, raw_x, raw_y, raw_n;
-	int ptest = 0, origin = 0, nmin = 0, nmax = 0;
+	int ptest = 0, origin = 0, ibt = 0, nmin = 0, nmax = 0;
 	int abs_p = 0, abs_w = 0, abs_x = 0, abs_y = 0;
 
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
@@ -303,6 +332,10 @@ static int report_tp_state(struct bcm597
 
 		ptest = int2bound(&c->p, raw_p);
 		origin = raw2int(f->origin);
+
+		/* set the integrated button if applicable */
+		if (c->tp_type == TYPE2)
+			ibt = raw2int(dev->tp_data[BUTTON_TYPE2]);
 	}
 
 	/* while tracking finger still valid, count all fingers */
@@ -346,6 +379,11 @@ static int report_tp_state(struct bcm597
 
 	}
 
+	if (HAS_INTEGRATED_BUTTON(c)) {
+		input_report_key(input, BTN_TOOL_PRESS, ibt);
+		input_report_key(input, BTN_LEFT, ibt);
+	}
+
 	input_sync(input);
 
 	return 0;
diff -puN include/linux/input.h~input-bcm5974-add-support-for-the-macbook-5-unibody include/linux/input.h
--- a/include/linux/input.h~input-bcm5974-add-support-for-the-macbook-5-unibody
+++ a/include/linux/input.h
@@ -440,6 +440,7 @@ struct input_absinfo {
 #define BTN_TOOL_FINGER		0x145
 #define BTN_TOOL_MOUSE		0x146
 #define BTN_TOOL_LENS		0x147
+#define BTN_TOOL_PRESS		0x148	/* The trackpad is a physical button */
 #define BTN_TOUCH		0x14a
 #define BTN_STYLUS		0x14b
 #define BTN_STYLUS2		0x14c
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

