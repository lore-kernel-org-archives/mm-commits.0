From: akpm@linux-foundation.org
Subject: + lis3-introduce-platform-data-for-second-ff-wu-unit.patch added to -mm tree
Date: Wed, 07 Apr 2010 14:20:18 -0700
Message-ID: <201004072120.o37LKI05007969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab0DGVVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 17:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: introduce platform data for second ff / wu unit
has been added to the -mm tree.  Its filename is
     lis3-introduce-platform-data-for-second-ff-wu-unit.patch

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
Subject: lis3: introduce platform data for second ff / wu unit
From: Samu Onkalo <samu.p.onkalo@nokia.com>

8 bit device has two wakeup / free fall units.  It was not possible to
configure the second unit.  This patch introduces configuration entry to
the platform data and also corresponding changes to the 8 bit setup
function.

High pass filters were enabled by default.  Patch introduces configuration
option for high pass filter cut off frequency and also possibility to
disable or enable the filter via platform data.  Since the control is a
new one and default state was filter enabled, new option is used to
disable the filter.  This way old platform data is still compatible with
the change.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Tested-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   15 +++++++++++++--
 include/linux/lis3lv02d.h |    9 +++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-introduce-platform-data-for-second-ff-wu-unit drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-introduce-platform-data-for-second-ff-wu-unit
+++ a/drivers/hwmon/lis3lv02d.c
@@ -524,6 +524,8 @@ EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 static void lis3lv02d_8b_configure(struct lis3lv02d *dev,
 				struct lis3lv02d_platform_data *p)
 {
+	int ctrl2 = p->hipass_ctrl;
+
 	if (p->click_flags) {
 		dev->write(dev, CLICK_CFG, p->click_flags);
 		dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
@@ -540,9 +542,18 @@ static void lis3lv02d_8b_configure(struc
 		dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
 		/* default to 2.5ms for now */
 		dev->write(dev, FF_WU_DURATION_1, 1);
-		/* enable high pass filter for both free-fall units */
-		dev->write(dev, CTRL_REG2, HP_FF_WU1 | HP_FF_WU2);
+		ctrl2 ^= HP_FF_WU1; /* Xor to keep compatible with old pdata*/
+	}
+
+	if (p->wakeup_flags2) {
+		dev->write(dev, FF_WU_CFG_2, p->wakeup_flags2);
+		dev->write(dev, FF_WU_THS_2, p->wakeup_thresh2 & 0x7f);
+		/* default to 2.5ms for now */
+		dev->write(dev, FF_WU_DURATION_2, 1);
+		ctrl2 ^= HP_FF_WU2; /* Xor to keep compatible with old pdata*/
 	}
+	/* Configure hipass filters */
+	dev->write(dev, CTRL_REG2, ctrl2);
 }
 
 /*
diff -puN include/linux/lis3lv02d.h~lis3-introduce-platform-data-for-second-ff-wu-unit include/linux/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3-introduce-platform-data-for-second-ff-wu-unit
+++ a/include/linux/lis3lv02d.h
@@ -43,6 +43,15 @@ struct lis3lv02d_platform_data {
 #define LIS3_WAKEUP_Z_HI	(1 << 5)
 	unsigned char wakeup_flags;
 	unsigned char wakeup_thresh;
+	unsigned char wakeup_flags2;
+	unsigned char wakeup_thresh2;
+#define LIS3_HIPASS_CUTFF_8HZ   0
+#define LIS3_HIPASS_CUTFF_4HZ   1
+#define LIS3_HIPASS_CUTFF_2HZ   2
+#define LIS3_HIPASS_CUTFF_1HZ   3
+#define LIS3_HIPASS1_DISABLE    (1 << 2)
+#define LIS3_HIPASS2_DISABLE    (1 << 3)
+	unsigned char hipass_ctrl;
 #define LIS3_NO_MAP		0
 #define LIS3_DEV_X		1
 #define LIS3_DEV_Y		2
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

lis3-add-missing-constants-for-8bit-device.patch
lis3-separate-configuration-function-for-8-bit-device.patch
lis3-introduce-platform-data-for-second-ff-wu-unit.patch
lis3-add-skeletons-for-interrupt-handlers.patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch
lis3-setup-poll-interval-limits.patch

