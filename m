From: akpm@linux-foundation.org
Subject: [folded-dropped] backlight-add-new-lm3639-backlight-driver-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:55:54 -0700
Message-ID: <20121004235554.CC5D21E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36826 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JDXz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:55:56 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so128584ggm.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:55:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.jeong@ti.com, gshark.jeong@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-new-lm3639-backlight-driver-fix
has been removed from the -mm tree.  Its filename was
     backlight-add-new-lm3639-backlight-driver-fix.patch

This patch was dropped because it was folded into backlight-add-new-lm3639-backlight-driver.patch

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

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch
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

