From: akpm@linux-foundation.org
Subject: [folded] fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 27 Apr 2010 13:12:15 -0700
Message-ID: <201004272039.o3RKdef6018397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929Ab0D0Ujy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 16:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, maz@misterjones.org, mm-commits@vger.kernel.org


The patch titled
     fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes.patch

This patch was dropped because it was folded into fix-pca953x-set_type-scheduling-while-atomic-bug.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required before the open parenthesis '('
#39: FILE: drivers/gpio/pca953x.c:262:
+	while(new_irqs) {

total: 1 errors, 0 warnings, 26 lines checked

./patches/fix-pca953x-set_type-scheduling-while-atomic-bug.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Marc Zyngier <maz@misterjones.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/pca953x.c~fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes
+++ a/drivers/gpio/pca953x.c
@@ -259,7 +259,7 @@ static void pca953x_irq_bus_sync_unlock(
 	new_irqs = chip->irq_trig_fall | chip->irq_trig_raise;
 	new_irqs &= ~chip->reg_direction;
 
-	while(new_irqs) {
+	while (new_irqs) {
 		level = __ffs(new_irqs);
 		pca953x_gpio_direction_input(&chip->gpio_chip, level);
 		new_irqs &= ~(1 << level);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-pca953x-set_type-scheduling-while-atomic-bug.patch
fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-acpi-use-kasprintf.patch
acpi_pad-processor_aggregator-name-too-long.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
compal-laptop-added-jhl90-battery-hwmon-interface-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
sched-introduce-get_cpu_iowait_time_us.patch
jfs-free-sbi-memory-in-error-path.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.patch
kernel-irq-managec-add-raise_threaded_irq.patch
max3100-to_max3100_port-small-style-fixes.patch
drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries.patch
laptop-mode-make-flushes-per-device-fix.patch
libertastf-add-configurable-debug-messages-fix.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
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

