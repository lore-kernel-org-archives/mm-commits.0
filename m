From: akpm@linux-foundation.org
Subject: [folded] rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 06 Apr 2010 14:32:13 -0700
Message-ID: <201004062132.o36LWDWP009404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836Ab0DFVc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 17:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, daniel@caiaq.de, vzapolskiy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#45: FILE: drivers/rtc/rtc-mxc.c:398:
+^I                             resource_size(res), pdev->name))$

ERROR: code indent should use tabs where possible
#49: FILE: drivers/rtc/rtc-mxc.c:402:
+^I                             resource_size(res));$

ERROR: code indent should use tabs where possible
#74: FILE: drivers/rtc/rtc-mxc.c:457:
+^I                     IRQF_SHARED, pdev->name, pdev) < 0) {$

total: 3 errors, 0 warnings, 72 lines checked

./patches/rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes
+++ a/drivers/rtc/rtc-mxc.c
@@ -396,11 +396,11 @@ static int __init mxc_rtc_probe(struct p
 		return -ENOMEM;
 
 	if (!devm_request_mem_region(&pdev->dev, res->start,
-	                             resource_size(res), pdev->name))
+				     resource_size(res), pdev->name))
 		return -EBUSY;
 
 	pdata->ioaddr = devm_ioremap(&pdev->dev, res->start,
-	                             resource_size(res));
+				     resource_size(res));
 
 	clk = clk_get(&pdev->dev, "ckil");
 	if (IS_ERR(clk)) {
@@ -455,7 +455,7 @@ static int __init mxc_rtc_probe(struct p
 
 	if (pdata->irq >= 0 &&
 	    devm_request_irq(&pdev->dev, pdata->irq, mxc_rtc_interrupt,
-	                     IRQF_SHARED, pdev->name, pdev) < 0) {
+			     IRQF_SHARED, pdev->name, pdev) < 0) {
 		dev_warn(&pdev->dev, "interrupt not available.\n");
 		pdata->irq = -1;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-remove-temporary-for_each_bit.patch
exit-fix-oops-in-sync_mm_rss.patch
drivers-char-amiserialc-add-missing-local_irq_restore.patch
mxser-spin_lock-=-spin_lock_irq.patch
vfs-rename-block_fsync-to-blkdev_fsync.patch
ratelimit-annotate-___ratelimit.patch
rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method.patch
rtc-mxc-multiple-fixes-in-rtc-mxc-probe-method-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
drivers-acpi-use-kasprintf-fix.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
ipc-mqueuec-let-message-queue-timeout-use-hrtimers-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
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

