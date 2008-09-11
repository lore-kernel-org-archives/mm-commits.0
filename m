From: akpm@linux-foundation.org
Subject: - input-mousedev-emulate-right-and-middle-buttons-for-single-button-touchpads.patch removed from -mm tree
Date: Wed, 10 Sep 2008 17:09:32 -0700
Message-ID: <200809110009.m8B09W5d001510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbYIKAJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 20:09:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     input: mousedev: emulate right and middle buttons for single-button touchpads
has been removed from the -mm tree.  Its filename was
     input-mousedev-emulate-right-and-middle-buttons-for-single-button-touchpads.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: mousedev: emulate right and middle buttons for single-button touchpads
From: Henrik Rydberg <rydberg@euromail.se>

On most linux-based systems, the right and middle buttons are used
extensively.  On computers lacking either of those buttons, such as the
Apple Macbooks, emulation is needed.  This patch adds emulation of the
missing buttons via two-fingers-and-click and three-fingers- and-click
operations, which has recently become standard, both in MacOS and in the
Xorg synaptics driver.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mousedev.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff -puN drivers/input/mousedev.c~input-mousedev-emulate-right-and-middle-buttons-for-single-button-touchpads drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~input-mousedev-emulate-right-and-middle-buttons-for-single-button-touchpads
+++ a/drivers/input/mousedev.c
@@ -53,6 +53,14 @@ static unsigned tap_move = 20;
 module_param(tap_move, uint, 0644);
 MODULE_PARM_DESC(tap_move, "Tap distance for touchpads in absolute mode (res)");
 
+static unsigned two_finger_code = BTN_RIGHT;
+module_param(two_finger_code, uint, 0644);
+MODULE_PARM_DESC(two_finger_code, "Button code of two-finger click");
+
+static unsigned three_finger_code = BTN_MIDDLE;
+module_param(three_finger_code, uint, 0644);
+MODULE_PARM_DESC(three_finger_code, "Button code of three-finger click");
+
 struct mousedev_hw_data {
 	int dx, dy, dz;
 	int x, y;
@@ -81,6 +89,7 @@ struct mousedev {
 	int frac_dx, frac_dy;
 	unsigned long touch;
 	int touch_dx, touch_dy;
+	int double_tap, triple_tap;
 };
 
 enum mousedev_emul {
@@ -225,11 +234,31 @@ static void mousedev_rel_event(struct mo
 	}
 }
 
+/* multi-finger emulation of non-existing buttons */
+static unsigned int get_button_code(const struct mousedev *mousedev)
+{
+	unsigned int code = BTN_LEFT;
+	if (mousedev->double_tap)
+		code = two_finger_code;
+	if (mousedev->triple_tap)
+		code = three_finger_code;
+	if (test_bit(code, mousedev->handle.dev->keybit))
+		code = BTN_LEFT;
+	return code;
+}
+
 static void mousedev_key_event(struct mousedev *mousedev,
 				unsigned int code, int value)
 {
 	int index;
 
+	if (code == BTN_TOOL_DOUBLETAP)
+		mousedev->double_tap = value;
+	if (code == BTN_TOOL_TRIPLETAP)
+		mousedev->triple_tap = value;
+	if (code == BTN_LEFT)
+		code = get_button_code(mousedev);
+
 	switch (code) {
 
 	case BTN_TOUCH:
@@ -327,6 +356,8 @@ static void mousedev_touchpad_touch(stru
 {
 	if (!value) {
 		if (mousedev->touch &&
+		    !mousedev->double_tap &&
+		    !mousedev->triple_tap &&
 		    abs(mousedev->touch_dx) < tap_move &&
 		    abs(mousedev->touch_dy) < tap_move &&
 		    time_before(jiffies,
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
input-mousedev-emulate-right-and-middle-buttons-for-single-button-touchpads.patch

