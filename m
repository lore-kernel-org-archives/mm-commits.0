From: akpm@linux-foundation.org
Subject: [wrecked] input-bcm5974-report-abs_mt-events.patch removed from -mm tree
Date: Thu, 07 Jan 2010 13:08:17 -0800
Message-ID: <201001072108.o07L8HWk017612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab0AGVJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 16:09:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: bcm5974: report ABS_MT events
has been removed from the -mm tree.  Its filename was
     input-bcm5974-report-abs_mt-events.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: bcm5974: report ABS_MT events
From: "Henrik Rydberg" <rydberg@euromail.se>

Make bcm5974 report raw multi-touch (MT) data in the form of ABS_MT
events.  The module parameter (nomt) may be used to turn off the effect of
this patch.

The module paremeter was added because all MT events bypass the input
filtering and get sent directly to the X driver.

Although it works as intended, without visible side effects, the stream of
events is rather large, and since the bypassing is completely new
behavior, I felt compelled to provide an option to turn it all off. 

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |   53 +++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff -puN drivers/input/mouse/bcm5974.c~input-bcm5974-report-abs_mt-events drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~input-bcm5974-report-abs_mt-events
+++ a/drivers/input/mouse/bcm5974.c
@@ -96,6 +96,10 @@ static int debug = 1;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activate debugging output");
 
+static int nomt;
+module_param(nomt, int, 0644);
+MODULE_PARM_DESC(nomt, "Disable multitouch (MT) events");
+
 /* button data structure */
 struct bt_data {
 	u8 unknown1;		/* constant */
@@ -139,6 +143,7 @@ struct tp_finger {
 /* trackpad finger data size, empirically at least ten fingers */
 #define SIZEOF_FINGER		sizeof(struct tp_finger)
 #define SIZEOF_ALL_FINGERS	(16 * SIZEOF_FINGER)
+#define MAX_FINGER_ORIENTATION	16384
 
 /* device-specific parameters */
 struct bcm5974_param {
@@ -284,6 +289,28 @@ static void setup_events_to_report(struc
 	input_set_abs_params(input_dev, ABS_Y,
 				0, cfg->y.dim, cfg->y.fuzz, 0);
 
+	if (!nomt) {
+		/* finger touch area */
+		input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
+				     cfg->w.devmin, cfg->w.devmax, 0, 0);
+		input_set_abs_params(input_dev, ABS_MT_TOUCH_MINOR,
+				     cfg->w.devmin, cfg->w.devmax, 0, 0);
+		/* finger approach area */
+		input_set_abs_params(input_dev, ABS_MT_WIDTH_MAJOR,
+				     cfg->w.devmin, cfg->w.devmax, 0, 0);
+		input_set_abs_params(input_dev, ABS_MT_WIDTH_MINOR,
+				     cfg->w.devmin, cfg->w.devmax, 0, 0);
+		/* finger orientation */
+		input_set_abs_params(input_dev, ABS_MT_ORIENTATION,
+				     -MAX_FINGER_ORIENTATION,
+				     MAX_FINGER_ORIENTATION, 0, 0);
+		/* finger position */
+		input_set_abs_params(input_dev, ABS_MT_POSITION_X,
+				     cfg->x.devmin, cfg->x.devmax, 0, 0);
+		input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
+				     cfg->y.devmin, cfg->y.devmax, 0, 0);
+	}
+
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
@@ -316,7 +343,7 @@ static int report_tp_state(struct bcm597
 	const struct bcm5974_config *c = &dev->cfg;
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
-	int raw_p, raw_w, raw_x, raw_y, raw_n;
+	int raw_p, raw_w, raw_x, raw_y, raw_n, i;
 	int ptest, origin, ibt = 0, nmin = 0, nmax = 0;
 	int abs_p = 0, abs_w = 0, abs_x = 0, abs_y = 0;
 
@@ -329,6 +356,30 @@ static int report_tp_state(struct bcm597
 
 	/* always track the first finger; when detached, start over */
 	if (raw_n) {
+
+		/* report raw trackpad data */
+		if (!nomt) {
+			for (i = 0; i < raw_n; i++) {
+				int y = c->y.devmin + c->y.devmax;
+				input_report_abs(input, ABS_MT_TOUCH_MAJOR,
+						 raw2int(f[i].force_major));
+				input_report_abs(input, ABS_MT_TOUCH_MINOR,
+						 raw2int(f[i].force_minor));
+				input_report_abs(input, ABS_MT_WIDTH_MAJOR,
+						 raw2int(f[i].size_major));
+				input_report_abs(input, ABS_MT_WIDTH_MINOR,
+						 raw2int(f[i].size_minor));
+				input_report_abs(input, ABS_MT_ORIENTATION,
+						 MAX_FINGER_ORIENTATION -
+						 raw2int(f[i].orientation));
+				input_report_abs(input, ABS_MT_POSITION_X,
+						 raw2int(f[i].abs_x));
+				input_report_abs(input, ABS_MT_POSITION_Y,
+						 y - raw2int(f[i].abs_y));
+				input_mt_sync(input);
+			}
+		}
+
 		raw_p = raw2int(f->force_major);
 		raw_w = raw2int(f->size_major);
 		raw_x = raw2int(f->abs_x);
_

Patches currently in -mm which might be from rydberg@euromail.se are

linux-next.patch
input-bcm5974-retract-efi-broken-suspend_resume.patch
input-bcm5974-report-abs_mt-events.patch

