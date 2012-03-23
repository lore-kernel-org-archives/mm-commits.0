From: akpm@linux-foundation.org
Subject: [folded] rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:30:10 -0700
Message-ID: <20120323213010.CCA95A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:47773 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2CWVaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:30:12 -0400
Received: by ggnd2 with SMTP id d2so565692ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:30:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, ashish.jangam@kpitcummins.com, dchen@diasemi.com, p_gortmaker@yahoo.com, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-rtc-driver-for-da9052-53-pmic-v1-fix
has been removed from the -mm tree.  Its filename was
     rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch

This patch was dropped because it was folded into rtc-rtc-driver-for-da9052-53-pmic-v1.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rtc-driver-for-da9052-53-pmic-v1-fix

- clean up file header layout
- remove unneeded initialisation of local arrays

Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-da9052.c~rtc-rtc-driver-for-da9052-53-pmic-v1-fix drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-rtc-driver-for-da9052-53-pmic-v1-fix
+++ a/drivers/rtc/rtc-da9052.c
@@ -1,9 +1,9 @@
 /*
  * Real time clock driver for DA9052
  *
- *Copyright(c) 2012 Dialog Semiconductor Ltd.
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
  *
- *Author: Dajun Dajun Chen <dajun.chen@diasemi.com>
+ * Author: Dajun Dajun Chen <dajun.chen@diasemi.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -69,7 +69,7 @@ static irqreturn_t da9052_rtc_irq(int ir
 static int da9052_read_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
 {
 	int ret;
-	uint8_t v[5] = {0, 0, 0, 0, 0};
+	uint8_t v[5];
 
 	ret = da9052_group_read(da9052, DA9052_ALARM_MI_REG, 5, v);
 	if (ret != 0) {
@@ -92,7 +92,7 @@ static int da9052_read_alarm(struct da90
 static int da9052_set_alarm(struct da9052 *da9052, struct rtc_time *rtc_tm)
 {
 	int ret;
-	uint8_t v[3] = {0, 0, 0};
+	uint8_t v[3];
 
 	rtc_tm->tm_year -= 100;
 	rtc_tm->tm_mon += 1;
@@ -136,7 +136,7 @@ static int da9052_rtc_get_alarm_status(s
 static int da9052_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	struct da9052_rtc *rtc = dev_get_drvdata(dev);
-	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+	uint8_t v[6];
 	int ret;
 
 	ret = da9052_group_read(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
@@ -164,7 +164,7 @@ static int da9052_rtc_read_time(struct d
 static int da9052_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct da9052_rtc *rtc;
-	uint8_t v[6] = {0, 0, 0, 0, 0, 0};
+	uint8_t v[6];
 
 	rtc = dev_get_drvdata(dev);
 
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
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
rtc-rtc-driver-for-da9052-53-pmic-v1.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

