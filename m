From: akpm@linux-foundation.org
Subject: + bcm5974-063-finger-counting-improved.patch added to -mm tree
Date: Thu, 04 Sep 2008 13:52:48 -0700
Message-ID: <200809042052.m84Kqmje030432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbYIDUyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 16:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se


The patch titled
     bcm5974-0.63: finger counting improved
has been added to the -mm tree.  Its filename is
     bcm5974-063-finger-counting-improved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bcm5974-0.63: finger counting improved
From: Henrik Rydberg <rydberg@euromail.se>

A finger counting method based on pressure information from all fingers is
introduced.  Together with a pressure hysteresis window, this yields a
more stable counting of the number of fingers on the trackpad.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/bcm5974.c |   54 +++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff -puN drivers/input/mouse/bcm5974.c~bcm5974-063-finger-counting-improved drivers/input/mouse/bcm5974.c
--- a/drivers/input/mouse/bcm5974.c~bcm5974-063-finger-counting-improved
+++ a/drivers/input/mouse/bcm5974.c
@@ -159,6 +159,7 @@ struct bcm5974 {
 	struct bt_data *bt_data;	/* button transferred data */
 	struct urb *tp_urb;		/* trackpad usb request block */
 	struct tp_data *tp_data;	/* trackpad transferred data */
+	int fingers;			/* number of fingers on trackpad */
 };
 
 /* logical dimensions */
@@ -172,6 +173,10 @@ struct bcm5974 {
 #define SN_WIDTH	100		/* width signal-to-noise ratio */
 #define SN_COORD	250		/* coordinate signal-to-noise ratio */
 
+/* pressure thresholds */
+#define PRESSURE_LOW	(2 * DIM_PRESSURE / SN_PRESSURE)
+#define PRESSURE_HIGH	(3 * PRESSURE_LOW)
+
 /* device constants */
 static const struct bcm5974_config bcm5974_config_table[] = {
 	{
@@ -273,32 +278,47 @@ static int report_tp_state(struct bcm597
 	const struct tp_finger *f = dev->tp_data->finger;
 	struct input_dev *input = dev->input;
 	const int fingers = (size - 26) / 28;
-	int p = 0, w, x, y, n = 0;
+	int nmin = 0, nmax = 0, p = 0, w = 0, x = 0, y = 0;
 
 	if (size < 26 || (size - 26) % 28 != 0)
 		return -EIO;
 
-	if (fingers) {
-		p = raw2int(f->force_major);
-		w = raw2int(f->size_major);
-		x = raw2int(f->abs_x);
-		y = raw2int(f->abs_y);
-		n = p > 0 ? fingers : 0;
-
-		dprintk(9,
-			"bcm5974: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
-			p, w, x, y, n);
+	for (; f != dev->tp_data->finger + fingers; f++) {
+		int ptest = raw2int(f->force_major);
+		if (ptest > PRESSURE_LOW) {
+			if (!nmax++) {
+				p = ptest;
+				w = raw2int(f->size_major);
+				x = raw2int(f->abs_x) - c->x.devmin;
+				y = c->y.devmax - raw2int(f->abs_y);
+			}
+		}
+		if (ptest > PRESSURE_HIGH)
+			nmin++;
 
-		input_report_abs(input, ABS_TOOL_WIDTH, int2bound(&c->w, w));
-		input_report_abs(input, ABS_X, int2bound(&c->x, x - c->x.devmin));
-		input_report_abs(input, ABS_Y, int2bound(&c->y, c->y.devmax - y));
 	}
 
+	if (dev->fingers < nmin)
+		dev->fingers = nmin;
+	if (dev->fingers > nmax)
+		dev->fingers = nmax;
+
+	input_report_key(input, BTN_TOOL_FINGER, dev->fingers == 1);
+	input_report_key(input, BTN_TOOL_DOUBLETAP, dev->fingers == 2);
+	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers > 2);
+
 	input_report_abs(input, ABS_PRESSURE, int2bound(&c->p, p));
+	input_report_abs(input, ABS_TOOL_WIDTH, int2bound(&c->w, w));
 
-	input_report_key(input, BTN_TOOL_FINGER, n == 1);
-	input_report_key(input, BTN_TOOL_DOUBLETAP, n == 2);
-	input_report_key(input, BTN_TOOL_TRIPLETAP, n > 2);
+	if (nmax > 0) {
+		dprintk(9,
+			"bcm5974: p: %+05d w: %+05d x: %+05d y: %+05d "
+			"nmin: %d nmax: %d\n",
+			p, w, x, y, nmin, nmax);
+
+		input_report_abs(input, ABS_X, int2bound(&c->x, x));
+		input_report_abs(input, ABS_Y, int2bound(&c->y, y));
+	}
 
 	input_sync(input);
 
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
linux-next.patch
bcm5974-063-finger-counting-improved.patch
bcm5974-063-btn_touch-event-added-for-mousedev.patch

