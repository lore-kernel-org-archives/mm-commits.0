From: akpm@linux-foundation.org
Subject: + lis3-add-support-for-new-lis3dc-hp3dc-chip.patch added to -mm tree
Date: Thu, 23 Sep 2010 13:13:10 -0700
Message-ID: <201009232013.o8NKDAJH016379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317Ab0IWUOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 16:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, Eric.Piel@tremplin-utc.net, guenter.roeck@ericsson.com, khali@linux-fr.org


The patch titled
     lis3: add support for new LIS3DC / HP3DC chip
has been added to the -mm tree.  Its filename is
     lis3-add-support-for-new-lis3dc-hp3dc-chip.patch

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
Subject: lis3: add support for new LIS3DC / HP3DC chip
From: Takashi Iwai <tiwai@suse.de>

A new version of LIS3 chip has slight incompatibilities from former
versions.  This patch adds the minimal support for it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   35 +++++++++++++++++++++++++++--------
 drivers/hwmon/lis3lv02d.h |   17 +++++++++++++++++
 2 files changed, 44 insertions(+), 8 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-add-support-for-new-lis3dc-hp3dc-chip drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-add-support-for-new-lis3dc-hp3dc-chip
+++ a/drivers/hwmon/lis3lv02d.c
@@ -162,6 +162,7 @@ static void lis3lv02d_get_xyz(struct lis
 /* conversion btw sampling rate and the register values */
 static int lis3_12_rates[4] = {40, 160, 640, 2560};
 static int lis3_8_rates[2] = {100, 400};
+static int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};
 
 /* ODR is Output Data Rate */
 static int lis3lv02d_get_odr(void)
@@ -180,6 +181,9 @@ static int lis3lv02d_set_odr(int rate)
 	u8 ctrl;
 	int i, len, shift;
 
+	if (!rate)
+		return -EINVAL;
+
 	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
 	ctrl &= ~lis3_dev.odr_mask;
 	len = 1 << hweight_long(lis3_dev.odr_mask); /* # of possible values */
@@ -196,19 +200,25 @@ static int lis3lv02d_set_odr(int rate)
 
 static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 {
-	u8 reg;
+	u8 ctlreg, reg;
 	s16 x, y, z;
 	u8 selftest;
 	int ret;
 
 	mutex_lock(&lis3->mutex);
-	if (lis3_dev.whoami == WAI_12B)
-		selftest = CTRL1_ST;
-	else
-		selftest = CTRL1_STP;
+	if (lis3_dev.whoami == WAI_3DC) {
+		ctlreg = CTRL_REG4;
+		selftest = CTRL4_ST0;
+	} else {
+		ctlreg = CTRL_REG1;
+		if (lis3_dev.whoami == WAI_12B)
+			selftest = CTRL1_ST;
+		else
+			selftest = CTRL1_STP;
+	}
 
-	lis3->read(lis3, CTRL_REG1, &reg);
-	lis3->write(lis3, CTRL_REG1, (reg | selftest));
+	lis3->read(lis3, ctlreg, &reg);
+	lis3->write(lis3, ctlreg, (reg | selftest));
 	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
 
 	/* Read directly to avoid axis remap */
@@ -217,7 +227,7 @@ static int lis3lv02d_selftest(struct lis
 	z = lis3->read_data(lis3, OUTZ);
 
 	/* back to normal settings */
-	lis3->write(lis3, CTRL_REG1, reg);
+	lis3->write(lis3, ctlreg, reg);
 	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
 
 	results[0] = x - lis3->read_data(lis3, OUTX);
@@ -698,6 +708,15 @@ int lis3lv02d_init_device(struct lis3lv0
 		dev->odr_mask = CTRL1_DR;
 		dev->scale = LIS3_SENSITIVITY_8B;
 		break;
+	case WAI_3DC:
+		printk(KERN_INFO DRIVER_NAME ": 8 bits 3DC sensor found\n");
+		dev->read_data = lis3lv02d_read_8;
+		dev->mdps_max_val = 128;
+		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
+		dev->odrs = lis3_3dc_rates;
+		dev->odr_mask = CTRL1_ODR0|CTRL1_ODR1|CTRL1_ODR2|CTRL1_ODR3;
+		dev->scale = LIS3_SENSITIVITY_8B;
+		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
 			": unknown sensor type 0x%X\n", dev->whoami);
diff -puN drivers/hwmon/lis3lv02d.h~lis3-add-support-for-new-lis3dc-hp3dc-chip drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-add-support-for-new-lis3dc-hp3dc-chip
+++ a/drivers/hwmon/lis3lv02d.h
@@ -45,6 +45,7 @@ enum lis3_reg {
 	CTRL_REG1	= 0x20,
 	CTRL_REG2	= 0x21,
 	CTRL_REG3	= 0x22,
+	CTRL_REG4	= 0x23,
 	HP_FILTER_RESET	= 0x23,
 	STATUS_REG	= 0x27,
 	OUTX_L		= 0x28,
@@ -93,6 +94,7 @@ enum lis3lv02d_reg {
 };
 
 enum lis3_who_am_i {
+	WAI_3DC		= 0x33,	/* 8 bits: LIS3DC, HP3DC */
 	WAI_12B		= 0x3A, /* 12 bits: LIS3LV02D[LQ]... */
 	WAI_8B		= 0x3B, /* 8 bits: LIS[23]02D[LQ]... */
 	WAI_6B		= 0x52, /* 6 bits: LIS331DLF - not supported */
@@ -118,6 +120,13 @@ enum lis3lv02d_ctrl1_8b {
 	CTRL1_DR	= 0x80,
 };
 
+enum lis3lv02d_ctrl1_3dc {
+	CTRL1_ODR0	= 0x10,
+	CTRL1_ODR1	= 0x20,
+	CTRL1_ODR2	= 0x40,
+	CTRL1_ODR3	= 0x80,
+};
+
 enum lis3lv02d_ctrl2 {
 	CTRL2_DAS	= 0x01,
 	CTRL2_SIM	= 0x02,
@@ -129,6 +138,14 @@ enum lis3lv02d_ctrl2 {
 	CTRL2_FS	= 0x80, /* Full Scale selection */
 };
 
+enum lis3lv02d_ctrl4_3dc {
+	CTRL4_SIM	= 0x01,
+	CTRL4_ST0	= 0x02,
+	CTRL4_ST1	= 0x04,
+	CTRL4_FS0	= 0x10,
+	CTRL4_FS1	= 0x20,
+};
+
 enum lis302d_ctrl2 {
 	HP_FF_WU2	= 0x08,
 	HP_FF_WU1	= 0x04,
_

Patches currently in -mm which might be from tiwai@suse.de are

linux-next.patch
lis3-fix-oops-with-null-platform-data.patch
lis3-add-axes-module-parameter-for-custom-axis-mapping.patch
lis3-add-support-for-new-lis3dc-hp3dc-chip.patch

