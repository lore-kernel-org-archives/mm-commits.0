From: akpm@linux-foundation.org
Subject: + lis3-add-free-fall-wakeup-function-via-platform_data.patch added to -mm tree
Date: Fri, 26 Jun 2009 14:32:47 -0700
Message-ID: <200906262132.n5QLWl74023523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799AbZFZVc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 17:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: add free-fall/wakeup function via platform_data
has been added to the -mm tree.  Its filename is
     lis3-add-free-fall-wakeup-function-via-platform_data.patch

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
Subject: lis3: add free-fall/wakeup function via platform_data
From: Daniel Mack <daniel@caiaq.de>

This offers a way for platforms to define flags and thresholds for the
free-fall/wakeup functions of the lis302d chips.

More registers needed to be seperated as they are specific to the

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |    9 +++++++++
 drivers/hwmon/lis3lv02d.h |   24 ++++++++++++++++++------
 include/linux/lis3lv02d.h |    9 +++++++++
 3 files changed, 36 insertions(+), 6 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-add-free-fall-wakeup-function-via-platform_data drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-add-free-fall-wakeup-function-via-platform_data
+++ a/drivers/hwmon/lis3lv02d.c
@@ -454,6 +454,15 @@ int lis3lv02d_init_device(struct lis3lv0
 					(p->click_thresh_y << 4));
 		}
 
+		if (p->wakeup_flags && (dev->whoami == LIS_SINGLE_ID)) {
+			dev->write(dev, FF_WU_CFG_1, p->wakeup_flags);
+			dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
+			/* default to 2.5ms for now */
+			dev->write(dev, FF_WU_DURATION_1, 1);
+			/* enable high pass filter for both free-fall units */
+			dev->write(dev, CTRL_REG2, HP_FF_WU1 | HP_FF_WU2);
+		}
+
 		if (p->irq_cfg)
 			dev->write(dev, CTRL_REG3, p->irq_cfg);
 	}
diff -puN drivers/hwmon/lis3lv02d.h~lis3-add-free-fall-wakeup-function-via-platform_data drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-add-free-fall-wakeup-function-via-platform_data
+++ a/drivers/hwmon/lis3lv02d.h
@@ -58,15 +58,17 @@ enum lis3_reg {
 	OUTZ_L		= 0x2C,
 	OUTZ_H		= 0x2D,
 	OUTZ		= 0x2D,
-	FF_WU_CFG	= 0x30,
-	FF_WU_SRC	= 0x31,
-	FF_WU_ACK	= 0x32,
-	FF_WU_THS_L	= 0x34,
-	FF_WU_THS_H	= 0x35,
-	FF_WU_DURATION	= 0x36,
 };
 
 enum lis302d_reg {
+	FF_WU_CFG_1	= 0x30,
+	FF_WU_SRC_1	= 0x31,
+	FF_WU_THS_1	= 0x32,
+	FF_WU_DURATION_1 = 0x33,
+	FF_WU_CFG_2	= 0x34,
+	FF_WU_SRC_2	= 0x35,
+	FF_WU_THS_2	= 0x36,
+	FF_WU_DURATION_2 = 0x37,
 	CLICK_CFG	= 0x38,
 	CLICK_SRC	= 0x39,
 	CLICK_THSY_X	= 0x3B,
@@ -77,6 +79,12 @@ enum lis302d_reg {
 };
 
 enum lis3lv02d_reg {
+	FF_WU_CFG	= 0x30,
+	FF_WU_SRC	= 0x31,
+	FF_WU_ACK	= 0x32,
+	FF_WU_THS_L	= 0x34,
+	FF_WU_THS_H	= 0x35,
+	FF_WU_DURATION	= 0x36,
 	DD_CFG		= 0x38,
 	DD_SRC		= 0x39,
 	DD_ACK		= 0x3A,
@@ -107,6 +115,10 @@ enum lis3lv02d_ctrl2 {
 	CTRL2_FS	= 0x80, /* Full Scale selection */
 };
 
+enum lis302d_ctrl2 {
+	HP_FF_WU2	= 0x08,
+	HP_FF_WU1	= 0x04,
+};
 
 enum lis3lv02d_ctrl3 {
 	CTRL3_CFS0	= 0x01,
diff -puN include/linux/lis3lv02d.h~lis3-add-free-fall-wakeup-function-via-platform_data include/linux/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3-add-free-fall-wakeup-function-via-platform_data
+++ a/include/linux/lis3lv02d.h
@@ -34,6 +34,15 @@ struct lis3lv02d_platform_data {
 #define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
 #define LIS3_IRQ_ACTIVE_LOW	(1 << 7)
 	unsigned char irq_cfg;
+
+#define LIS3_WAKEUP_X_LO	(1 << 0)
+#define LIS3_WAKEUP_X_HI	(1 << 1)
+#define LIS3_WAKEUP_Y_LO	(1 << 2)
+#define LIS3_WAKEUP_Y_HI	(1 << 3)
+#define LIS3_WAKEUP_Z_LO	(1 << 4)
+#define LIS3_WAKEUP_Z_HI	(1 << 5)
+	unsigned char wakeup_flags;
+	unsigned char wakeup_thresh;
 };
 
 #endif /* __LIS3LV02D_H_ */
_

Patches currently in -mm which might be from daniel@caiaq.de are

lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3_spi-code-cleanups.patch

