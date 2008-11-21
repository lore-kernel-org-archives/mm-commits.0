From: akpm@linux-foundation.org
Subject: + input-synaptics-only-report-double-triple-tap-if-supported-by-the-device.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:04:38 -0800
Message-ID: <200811212004.mALK4cUZ013834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYKUUEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.hutterer@who-t.net, peter.hutterer@redhat.com


The patch titled
     input: synaptics: only report double/triple tap if supported by the device.
has been added to the -mm tree.  Its filename is
     input-synaptics-only-report-double-triple-tap-if-supported-by-the-device.patch

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
