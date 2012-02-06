From: akpm@linux-foundation.org
Subject: + rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch added to -mm tree
Date: Mon, 06 Feb 2012 14:26:04 -0800
Message-ID: <20120206222604.D4D8DA035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62569 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2BFW0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 17:26:05 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so35079yen.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 14:26:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, ashish.jangam@kpitcummins.com, dchen@diasemi.com, p_gortmaker@yahoo.com, sameo@linux.intel.com


The patch titled
     Subject: rtc-rtc-driver-for-da9052-53-pmic-v1-fix
has been added to the -mm tree.  Its filename is
     rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch

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
Subject: Subject: rtc-rtc-driver-for-da9052-53-pmic-v1-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-fix.patch
video-backlight-support-s6e8ax0-panel-driver-based-on-mipi-dsi-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

