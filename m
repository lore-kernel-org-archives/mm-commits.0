From: akpm@linux-foundation.org
Subject: + lis3-separate-configuration-function-for-8-bit-device.patch added to -mm tree
Date: Wed, 07 Apr 2010 14:20:16 -0700
Message-ID: <201004072120.o37LKGcO007966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab0DGVVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 17:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: separate configuration function for 8 bit device
has been added to the -mm tree.  Its filename is
     lis3-separate-configuration-function-for-8-bit-device.patch

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
Subject: lis3: separate configuration function for 8 bit device
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Separate configuration function for 8 bit version of the chip.  This way
generic part of the init function stays little bit more readable.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Tested-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   45 ++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-separate-configuration-function-for-8-bit-device drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-separate-configuration-function-for-8-bit-device
+++ a/drivers/hwmon/lis3lv02d.c
@@ -521,6 +521,30 @@ int lis3lv02d_remove_fs(struct lis3lv02d
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 
+static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
+				struct lis3lv02d_platform_data *p)
+{
+	if (p->click_flags) {
+		dev->write(dev, CLICK_CFG, p->click_flags);
+		dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
+		dev->write(dev, CLICK_LATENCY, p->click_latency);
+		dev->write(dev, CLICK_WINDOW, p->click_window);
+		dev->write(dev, CLICK_THSZ, p->click_thresh_z & 0xf);
+		dev->write(dev, CLICK_THSY_X,
+			(p->click_thresh_x & 0xf) |
+			(p->click_thresh_y << 4));
+	}
+
+	if (p->wakeup_flags) {
+		dev->write(dev, FF_WU_CFG_1, p->wakeup_flags);
+		dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
+		/* default to 2.5ms for now */
+		dev->write(dev, FF_WU_DURATION_1, 1);
+		/* enable high pass filter for both free-fall units */
+		dev->write(dev, CTRL_REG2, HP_FF_WU1 | HP_FF_WU2);
+	}
+}
+
 /*
  * Initialise the accelerometer and the various subsystems.
  * Should be rather independent of the bus system.
@@ -567,25 +591,8 @@ int lis3lv02d_init_device(struct lis3lv0
 	if (dev->pdata) {
 		struct lis3lv02d_platform_data *p = dev->pdata;
 
-		if (p->click_flags && (dev->whoami == WAI_8B)) {
-			dev->write(dev, CLICK_CFG, p->click_flags);
-			dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
-			dev->write(dev, CLICK_LATENCY, p->click_latency);
-			dev->write(dev, CLICK_WINDOW, p->click_window);
-			dev->write(dev, CLICK_THSZ, p->click_thresh_z & 0xf);
-			dev->write(dev, CLICK_THSY_X,
-					(p->click_thresh_x & 0xf) |
-					(p->click_thresh_y << 4));
-		}
