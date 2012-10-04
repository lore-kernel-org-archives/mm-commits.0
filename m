From: akpm@linux-foundation.org
Subject: [folded-dropped] backlight-add-backlight-driver-for-lm3630-chip-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:55:05 -0700
Message-ID: <20121004235506.5F9D2100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36775 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JDXzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:55:07 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so129084ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:55:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.jeong@ti.com, gshark.jeong@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-backlight-driver-for-lm3630-chip-fix
has been removed from the -mm tree.  Its filename was
     backlight-add-backlight-driver-for-lm3630-chip-fix.patch

This patch was dropped because it was folded into backlight-add-backlight-driver-for-lm3630-chip.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-backlight-driver-for-lm3630-chip-fix

- make bled_name[] static

- a few coding style tuneups

- create new set_intensity(), partly to avoid awkward layout gymnastics

Cc: "G.Shark Jeong" <gshark.jeong@gmail.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>
Cc: G.Shark Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3630_bl.c |   41 ++++++++++++--------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff -puN drivers/video/backlight/lm3630_bl.c~backlight-add-backlight-driver-for-lm3630-chip-fix drivers/video/backlight/lm3630_bl.c
--- a/drivers/video/backlight/lm3630_bl.c~backlight-add-backlight-driver-for-lm3630-chip-fix
+++ a/drivers/video/backlight/lm3630_bl.c
@@ -37,7 +37,7 @@ enum lm3630_leds {
 	BLED_2
 };
 
-const char *bled_name[] = {
+static const char *bled_name[] = {
 	[BLED_ALL] = "lm3630_bled",	/*Bank1 controls all string */
 	[BLED_1] = "lm3630_bled1",	/*Bank1 controls bled1 */
 	[BLED_2] = "lm3630_bled2",	/*Bank1 or 2 controls bled2 */
@@ -62,15 +62,14 @@ static int __devinit lm3630_chip_init(st
 	struct lm3630_platform_data *pdata = pchip->pdata;
 
 	/*pwm control */
-	reg_val = ((pdata->pwm_active & 0x01) << 2)
-	    | (pdata->pwm_ctrl & 0x03);
+	reg_val = ((pdata->pwm_active & 0x01) << 2) | (pdata->pwm_ctrl & 0x03);
 	ret = regmap_update_bits(pchip->regmap, REG_CONFIG, 0x07, reg_val);
 	if (ret < 0)
 		goto out;
 
 	/* bank control */
-	reg_val = ((pdata->bank_b_ctrl & 0x01) << 1)
-	    | (pdata->bank_a_ctrl & 0x07);
+	reg_val = ((pdata->bank_b_ctrl & 0x01) << 1) |
+			(pdata->bank_a_ctrl & 0x07);
 	ret = regmap_update_bits(pchip->regmap, REG_CTRL, 0x07, reg_val);
 	if (ret < 0)
 		goto out;
@@ -105,8 +104,9 @@ static void lm3630_delayed_func(struct w
 {
 	int ret;
 	unsigned int reg_val;
-	struct lm3630_chip_data *pchip =
-	    container_of(work, struct lm3630_chip_data, work.work);
+	struct lm3630_chip_data *pchip;
+
+	pchip = container_of(work, struct lm3630_chip_data, work.work);
 
 	ret = regmap_read(pchip->regmap, REG_INT_STATUS, &reg_val);
 	if (ret < 0) {
@@ -153,6 +153,16 @@ static int lm3630_intr_config(struct lm3
 	return 0;
 }
 
+static bool
+set_intensity(struct backlight_device *bl, struct lm3630_chip_data *pchip)
+{
+	if (!pchip->pdata->pwm_set_intensity)
+		return false;
+	pchip->pdata->pwm_set_intensity(bl->props.brightness - 1,
+					pchip->pdata->pwm_period);
+	return true;
+}
+
 /* update and get brightness */
 static int lm3630_bank_a_update_status(struct backlight_device *bl)
 {
@@ -170,14 +180,8 @@ static int lm3630_bank_a_update_status(s
 
 	/* pwm control */
 	if (pwm_ctrl == PWM_CTRL_BANK_A || pwm_ctrl == PWM_CTRL_BANK_ALL) {
-		if (pchip->pdata->pwm_set_intensity)
-			pchip->pdata->pwm_set_intensity(bl->props.brightness -
-							1,
-							pchip->pdata->
-							pwm_period);
-		else
-			dev_err(pchip->dev,
-				"No pwm control func. in plat-data\n");
+		if (!set_intensity(bl, pchip))
+			dev_err(pchip->dev, "No pwm control func. in plat-data\n");
 	} else {
 
 		/* i2c control */
@@ -242,12 +246,7 @@ static int lm3630_bank_b_update_status(s
 	enum lm3630_pwm_ctrl pwm_ctrl = pchip->pdata->pwm_ctrl;
 
 	if (pwm_ctrl == PWM_CTRL_BANK_B || pwm_ctrl == PWM_CTRL_BANK_ALL) {
-		if (pchip->pdata->pwm_set_intensity)
-			pchip->pdata->pwm_set_intensity(bl->props.brightness -
-							1,
-							pchip->pdata->
-							pwm_period);
-		else
+		if (!set_intensity(bl, pchip))
 			dev_err(pchip->dev,
 				"no pwm control func. in plat-data\n");
 	} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

