From: akpm@linux-foundation.org
Subject: - input-synaptics-only-report-double-triple-tap-if-supported-by-the-device.patch removed from -mm tree
Date: Mon, 24 Nov 2008 11:29:38 -0800
Message-ID: <200811241929.mAOJTcjP027832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbYKXTaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 14:30:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter.hutterer@who-t.net, peter.hutterer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     input: synaptics: only report double/triple tap if supported by the device.
has been removed from the -mm tree.  Its filename was
     input-synaptics-only-report-double-triple-tap-if-supported-by-the-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: synaptics: only report double/triple tap if supported by the device.
From: Peter Hutterer <peter.hutterer@who-t.net>

According to Section 2.4.4 of the Synaptics TouchPad Interfacing Guide,
bit 2 specifies if multi-finger detection is provided by the touchpad. 
Thus, only set BTN_TOOL_DOUBLETAP and BTN_TOOL_TRIPLETAP if the device
actually supports it.

Signed-off-by: Peter Hutterer <peter.hutterer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/synaptics.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/input/mouse/synaptics.c~input-synaptics-only-report-double-triple-tap-if-supported-by-the-device drivers/input/mouse/synaptics.c
--- a/drivers/input/mouse/synaptics.c~input-synaptics-only-report-double-triple-tap-if-supported-by-the-device
+++ a/drivers/input/mouse/synaptics.c
@@ -445,12 +445,14 @@ static void synaptics_process_packet(str
 
 	input_report_abs(dev, ABS_TOOL_WIDTH, finger_width);
 	input_report_key(dev, BTN_TOOL_FINGER, num_fingers == 1);
-	input_report_key(dev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
-	input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
-
 	input_report_key(dev, BTN_LEFT, hw.left);
 	input_report_key(dev, BTN_RIGHT, hw.right);
 
+	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
+		input_report_key(dev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
+		input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
+	}
+
 	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities))
 		input_report_key(dev, BTN_MIDDLE, hw.middle);
 
@@ -543,12 +545,14 @@ static void set_input_params(struct inpu
 	set_bit(EV_KEY, dev->evbit);
 	set_bit(BTN_TOUCH, dev->keybit);
 	set_bit(BTN_TOOL_FINGER, dev->keybit);
-	set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
-	set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
