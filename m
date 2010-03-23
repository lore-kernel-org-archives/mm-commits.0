From: akpm@linux-foundation.org
Subject: + firmware-loader-use-statically-initialized-data-attribute-fix.patch added to -mm tree
Date: Tue, 23 Mar 2010 14:10:53 -0700
Message-ID: <201003232137.o2NLbUDI027438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899Ab0CWViF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 17:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Valdis.Kletnieks@vt.edu, dtor@mail.ru, greg@kroah.com, peterz@infradead.org, tglx@linutronix.de, w.sang@pengutronix.de


The patch titled
     firmware-loader-use-statically-initialized-data-attribute-fix
has been added to the -mm tree.  Its filename is
     firmware-loader-use-statically-initialized-data-attribute-fix.patch

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
Subject: firmware-loader-use-statically-initialized-data-attribute-fix
From: Andrew Morton <akpm@linux-foundation.org>

This file got fiddled with in linux-next.  Is this patch still needed/correct?

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/firmware_class.c~firmware-loader-use-statically-initialized-data-attribute-fix drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-loader-use-statically-initialized-data-attribute-fix
+++ a/drivers/base/firmware_class.c
@@ -441,7 +441,7 @@ static int fw_setup_device(struct firmwa
 	fw_priv = dev_get_drvdata(f_dev);
 
 	fw_priv->fw = fw;
-	sysfs_bin_attr_init(&fw_priv->attr_data);
+	sysfs_bin_attr_init(&firmware_attr_data);
 	retval = sysfs_create_bin_file(&f_dev->kobj, &firmware_attr_data);
 	if (retval) {
 		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

c2port-fix-device_create-return-value-check.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
ratelimit-annotate-___ratelimit-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
hpet-factor-timer-allocate-from-open-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

