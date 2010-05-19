From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 19 May 2010 10:14:27 -0400
Message-ID: <201005191715.o4JHFrjW024892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573Ab0ESRTi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:19:38 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o4JHJaBX000848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 19 May 2010 10:19:37 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/microblaze_ksyms.c |    4 ----
 drivers/mfd/wm831x-core.c                 |   19 -------------------
 2 files changed, 23 deletions(-)

diff -puN arch/microblaze/kernel/microblaze_ksyms.c~linux-next-git-rejects arch/microblaze/kernel/microblaze_ksyms.c
--- a/arch/microblaze/kernel/microblaze_ksyms.c~linux-next-git-rejects
+++ a/arch/microblaze/kernel/microblaze_ksyms.c
@@ -57,10 +57,6 @@ EXPORT_SYMBOL(_mcount);
  * Assembly functions that may be used (directly or indirectly) by modules
  */
 EXPORT_SYMBOL(__copy_tofrom_user);
-<<<<<<< HEAD
-EXPORT_SYMBOL(__strncpy_user);
-=======
->>>>>>> FETCH_HEAD
 
 #ifdef CONFIG_OPT_LIB_ASM
 EXPORT_SYMBOL(memcpy);
diff -puN drivers/mfd/wm831x-core.c~linux-next-git-rejects drivers/mfd/wm831x-core.c
--- a/drivers/mfd/wm831x-core.c~linux-next-git-rejects
+++ a/drivers/mfd/wm831x-core.c
@@ -356,24 +356,6 @@ int wm831x_auxadc_read(struct wm831x *wm
 		goto disable;
 	}
 
-<<<<<<< HEAD
-	/* If an interrupt arrived late clean up after it */
-	try_wait_for_completion(&wm831x->auxadc_done);
-
-	/* Ignore the result to allow us to soldier on without IRQ hookup */
-	wait_for_completion_timeout(&wm831x->auxadc_done, msecs_to_jiffies(5));
-
-	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_CONTROL);
-	if (ret < 0) {
-		dev_err(wm831x->dev, "AUXADC status read failed: %d\n", ret);
-		goto disable;
-	}
-
-	if (ret & WM831X_AUX_CVT_ENA) {
-		dev_err(wm831x->dev, "Timed out reading AUXADC\n");
-		ret = -EBUSY;
-		goto disable;
-=======
 	if (irq_masked) {
 		/* If we're not using interrupts then poll the
 		 * interrupt status register */
@@ -414,7 +396,6 @@ int wm831x_auxadc_read(struct wm831x *wm
 			ret = -EBUSY;
 			goto disable;
 		}
->>>>>>> FETCH_HEAD
 	}
 
 	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-pci-intel-iommuc-errors-with-smaller-iommu-widths-fix.patch
x86-platform-driver-intelligent-power-sharing-driver-checkpatch-fixes.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
jfs-free-sbi-memory-in-error-path.patch
fix-drm-radeon-kms-hdmi-irq-support.patch
dib3000mc-reduce-large-stack-usage-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
kernel-mutexc-fix-unused-var-warning.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix-2.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-spelling.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-checkpatch-fixes.patch
highmem-remove-unneeded-ifdef-config_trace_irqflags_support-for-debug_kmap_atomic.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix-fix.patch
include-asm-generic-kmap_typesh-remove-km_sync_icache-and-km_sync_dcache.patch
include-asm-generic-kmap_typesh-add-helpful-reminder.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
lib-introduce-common-method-to-convert-hex-digits-fix.patch
lib-introduce-common-method-to-convert-hex-digits-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
s3c-fb-add-s5pv210-support-and-some-features-checkpatch-fixes.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-4.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs-checkpatch-fixes.patch
pids-increase-pid_max-based-on-num_possible_cpus-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-fix.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
kfifo-samples-dont-compile.patch
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

