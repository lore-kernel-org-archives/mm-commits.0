From: akpm@linux-foundation.org
Subject: + input-bcm5974-add-quad-finger-tapping.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:33:46 -0800
Message-ID: <200901290833.n0T8Xk0M022995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbZA2IeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:34:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, dtor@mail.ru


The patch titled
     input: bcm5974: Add quad-finger tapping
has been added to the -mm tree.  Its filename is
     input-bcm5974-add-quad-finger-tapping.patch

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

hwmon-applesmc-add-support-for-macpro-3-temperature-sensors.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
input-bcm5974-prepare-for-a-new-trackpad-header-type.patch
input-bcm5974-add-quad-finger-tapping.patch
input-bcm5974-add-support-for-the-macbook-5-unibody.patch
input-bcm5974-augmented-debug-information.patch
input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-add-a-detailed-multi-touch-finger-data-report-protocol-rev2.patch

