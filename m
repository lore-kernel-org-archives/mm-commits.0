From: akpm@linux-foundation.org
Subject: [merged] input-bcm5974-add-quad-finger-tapping.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:17:37 -0700
Message-ID: <200904291917.n3TJHbjh030658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759614AbZD2TTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: bcm5974: Add quad-finger tapping
has been removed from the -mm tree.  Its filename was
     input-bcm5974-add-quad-finger-tapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: bcm5974: Add quad-finger tapping
From: "Henrik Rydberg" <rydberg@euromail.se>

The integrated button on the new unibody Macbooks presents a need to
report explicit four-finger actions.  Evidently, the finger pressing the
button is also touching the trackpad, so in order to fully support
three-finger actions, the driver must be able to report four-finger
actions.  This patch adds a new button, BTN_TOOL_QUADTAP, which achieves
this.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |    4 +++-
 include/linux/input.h         |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/input/mouse/bcm5974.c~input-bcm5974-add-quad-finger-tapping drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~input-bcm5974-add-quad-finger-tapping
+++ a/drivers/input/mouse/bcm5974.c
@@ -258,6 +258,7 @@ static void setup_events_to_report(struc
 	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
 	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
 	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
+	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
 }
 
@@ -328,7 +329,8 @@ static int report_tp_state(struct bcm597
 	input_report_key(input, BTN_TOUCH, dev->fingers > 0);
 	input_report_key(input, BTN_TOOL_FINGER, dev->fingers == 1);
 	input_report_key(input, BTN_TOOL_DOUBLETAP, dev->fingers == 2);
-	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers > 2);
+	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers == 3);
+	input_report_key(input, BTN_TOOL_QUADTAP, dev->fingers > 3);
 
 	input_report_abs(input, ABS_PRESSURE, abs_p);
 	input_report_abs(input, ABS_TOOL_WIDTH, abs_w);
diff -puN include/linux/input.h~input-bcm5974-add-quad-finger-tapping include/linux/input.h
--- a/include/linux/input.h~input-bcm5974-add-quad-finger-tapping
+++ a/include/linux/input.h
@@ -445,6 +445,7 @@ struct input_absinfo {
 #define BTN_STYLUS2		0x14c
 #define BTN_TOOL_DOUBLETAP	0x14d
 #define BTN_TOOL_TRIPLETAP	0x14e
+#define BTN_TOOL_QUADTAP	0x14f	/* Four fingers on trackpad */
 
 #define BTN_WHEEL		0x150
 #define BTN_GEAR_DOWN		0x150
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

