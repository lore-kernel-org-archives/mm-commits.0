From: akpm@linux-foundation.org
Subject: [folded] leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:27:14 -0700
Message-ID: <20120323212714.B37C4A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:50886 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2CWV1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:27:16 -0400
Received: by wejx9 with SMTP id x9so189030wej.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:27:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-lm3530-replace-i2c_client-with-led_classdev-fix
has been removed from the -mm tree.  Its filename was
     leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch

This patch was dropped because it was folded into leds-lm3530-replace-i2c_client-with-led_classdev.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: leds-lm3530-replace-i2c_client-with-led_classdev-fix

fix 80-column fixes more nicely

Cc: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-replace-i2c_client-with-led_classdev-fix drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-replace-i2c_client-with-led_classdev-fix
+++ a/drivers/leds/leds-lm3530.c
@@ -298,10 +298,10 @@ static ssize_t lm3530_mode_get(struct de
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lm3530_data *drvdata =
-	    container_of(led_cdev, struct lm3530_data, led_dev);
+	struct lm3530_data *drvdata;
 	int i, len = 0;
 
+	drvdata = container_of(led_cdev, struct lm3530_data, led_dev);
 	for (i = 0; i < ARRAY_SIZE(mode_map); i++)
 		if (drvdata->mode == mode_map[i].mode_val)
 			len += sprintf(buf + len, "[%s] ", mode_map[i].mode);
@@ -317,10 +317,10 @@ static ssize_t lm3530_mode_set(struct de
 				   *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lm3530_data *drvdata =
-	    container_of(led_cdev, struct lm3530_data, led_dev);
+	struct lm3530_data *drvdata;
 	int mode, err;
 
+	drvdata = container_of(led_cdev, struct lm3530_data, led_dev);
 	mode = lm3530_get_mode_from_str(buf);
 	if (mode < 0) {
 		dev_err(dev, "Invalid mode\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

