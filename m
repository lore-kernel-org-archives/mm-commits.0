From: akpm@linux-foundation.org
Subject: + backlight-add-new-lm3639-backlight-driver-fix.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:40:36 -0700
Message-ID: <20120820204037.957CE20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:49853 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2HTUkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 16:40:39 -0400
Received: by wibhr14 with SMTP id hr14so218511wib.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:40:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, daniel.jeong@ti.com, gshark.jeong@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight-add-new-lm3639-backlight-driver-fix
has been added to the -mm tree.  Its filename is
     backlight-add-new-lm3639-backlight-driver-fix.patch

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
Subject: backlight-add-new-lm3639-backlight-driver-fix

code layout tweaks

Cc: "G.Shark Jeong" <gshark.jeong@gmail.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>
Cc: G.Shark Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3639_bl.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/lm3639_bl.c~backlight-add-new-lm3639-backlight-driver-fix drivers/video/backlight/lm3639_bl.c
--- a/drivers/video/backlight/lm3639_bl.c~backlight-add-new-lm3639-backlight-driver-fix
+++ a/drivers/video/backlight/lm3639_bl.c
@@ -222,8 +222,9 @@ static void lm3639_torch_brightness_set(
 {
 	int ret;
 	unsigned int reg_val;
-	struct lm3639_chip_data *pchip =
-	    container_of(cdev, struct lm3639_chip_data, cdev_torch);
+	struct lm3639_chip_data *pchip;
+
+	pchip = container_of(cdev, struct lm3639_chip_data, cdev_torch);
 
 	ret = regmap_read(pchip->regmap, REG_FLAG, &reg_val);
 	if (ret < 0)
@@ -259,8 +260,9 @@ static void lm3639_flash_brightness_set(
 {
 	int ret;
 	unsigned int reg_val;
-	struct lm3639_chip_data *pchip =
-	    container_of(cdev, struct lm3639_chip_data, cdev_flash);
+	struct lm3639_chip_data *pchip;
+
+	pchip = container_of(cdev, struct lm3639_chip_data, cdev_flash);
 
 	ret = regmap_read(pchip->regmap, REG_FLAG, &reg_val);
 	if (ret < 0)
@@ -303,7 +305,6 @@ static int __devinit lm3639_probe(struct
 	int ret;
 	struct lm3639_chip_data *pchip;
 	struct lm3639_platform_data *pdata = client->dev.platform_data;
-
 	struct backlight_properties props;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
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
backlight-add-new-lm3639-backlight-driver-fix.patch
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

