From: akpm@linux-foundation.org
Subject: [folded] c2port-fix-device_create-return-value-check-fix.patch removed from -mm tree
Date: Tue, 23 Mar 2010 13:30:57 -0700
Message-ID: <201003232030.o2NKUvmJ024204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab0CWUbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 16:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ext-jani.1.nikula@nokia.com, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     c2port-fix-device_create-return-value-check-fix
has been removed from the -mm tree.  Its filename was
     c2port-fix-device_create-return-value-check-fix.patch

This patch was dropped because it was folded into c2port-fix-device_create-return-value-check.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: c2port-fix-device_create-return-value-check-fix
From: Andrew Morton <akpm@linux-foundation.org>

preserve the error code

Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/c2port/core.c~c2port-fix-device_create-return-value-check-fix drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~c2port-fix-device_create-return-value-check-fix
+++ a/drivers/misc/c2port/core.c
@@ -913,7 +913,7 @@ struct c2port_device *c2port_device_regi
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
 					"c2port%d", id);
 	if (unlikely(IS_ERR(c2dev->dev))) {
-		ret = -ENOMEM;
+		ret = PTR_ERR(c2dev->dev);
 		goto error_device_create;
 	}
 	dev_set_drvdata(c2dev->dev, c2dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

c2port-fix-device_create-return-value-check.patch
c2port-fix-device_create-return-value-check-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
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

