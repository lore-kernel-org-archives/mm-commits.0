From: akpm@linux-foundation.org
Subject: + backlight-add-backlight-driver-for-lm3630-chip-fix.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:36:51 -0700
Message-ID: <20120820203652.9BC1E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:50362 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2HTUgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:36:55 -0400
Received: by weyr1 with SMTP id r1so311673wey.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:36:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, daniel.jeong@ti.com, gshark.jeong@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight-add-backlight-driver-for-lm3630-chip-fix
has been added to the -mm tree.  Its filename is
     backlight-add-backlight-driver-for-lm3630-chip-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
rbtree-performance-and-correctness-test-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

