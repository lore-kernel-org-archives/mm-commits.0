From: akpm@linux-foundation.org
Subject: + laptop-mode-make-flushes-per-device-fix.patch added to -mm tree
Date: Tue, 27 Apr 2010 11:04:53 -0400
Message-ID: <201004271806.o3RI6QYW011137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab0D0SG7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:06:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, mjg@redhat.com, randy.dunlap@oracle.com


The patch titled
     "laptop-mode: Make flushes per-device" fix
has been added to the -mm tree.  Its filename is
     laptop-mode-make-flushes-per-device-fix.patch

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
Subject: "laptop-mode: Make flushes per-device" fix
From: Andrew Morton <akpm@linux-foundation.org>

When CONFIG_BLOCK is not enabled:

mm/page-writeback.c:707: error: dereferencing pointer to incomplete type
mm/page-writeback.c:708: error: dereferencing pointer to incomplete type

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c          |   15 +++++++++++++++
 include/linux/writeback.h |    1 -
 mm/page-writeback.c       |   15 ---------------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff -puN block/blk-core.c~laptop-mode-make-flushes-per-device-fix block/blk-core.c
--- a/block/blk-core.c~laptop-mode-make-flushes-per-device-fix
+++ a/block/blk-core.c
@@ -488,6 +488,21 @@ struct request_queue *blk_alloc_queue(gf
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
+static void laptop_mode_timer_fn(unsigned long data)
+{
+	struct request_queue *q = (struct request_queue *)data;
+	int nr_pages = global_page_state(NR_FILE_DIRTY) +
+		global_page_state(NR_UNSTABLE_NFS);
+
+	/*
+	 * We want to write everything out, not just down to the dirty
+	 * threshold
+	 */
+
+	if (bdi_has_dirty_io(&q->backing_dev_info))
+		bdi_start_writeback(&q->backing_dev_info, NULL, nr_pages);
+}
+
 struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 {
 	struct request_queue *q;
diff -puN mm/page-writeback.c~laptop-mode-make-flushes-per-device-fix mm/page-writeback.c
--- a/mm/page-writeback.c~laptop-mode-make-flushes-per-device-fix
+++ a/mm/page-writeback.c
@@ -693,21 +693,6 @@ int dirty_writeback_centisecs_handler(ct
 	return 0;
 }
 
-void laptop_mode_timer_fn(unsigned long data)
-{
-	struct request_queue *q = (struct request_queue *)data;
-	int nr_pages = global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS);
-
-	/*
-	 * We want to write everything out, not just down to the dirty
-	 * threshold
-	 */
-
-	if (bdi_has_dirty_io(&q->backing_dev_info))
-		bdi_start_writeback(&q->backing_dev_info, NULL, nr_pages);
-}
-
 /*
  * We've spun up the disk and we're in laptop mode: schedule writeback
  * of all dirty data a few seconds from now.  If the flush is already scheduled
diff -puN include/linux/writeback.h~laptop-mode-make-flushes-per-device-fix include/linux/writeback.h
--- a/include/linux/writeback.h~laptop-mode-make-flushes-per-device-fix
+++ a/include/linux/writeback.h
@@ -99,7 +99,6 @@ static inline void inode_sync_wait(struc
 void laptop_io_completion(struct backing_dev_info *info);
 void laptop_sync_completion(void);
 void laptop_mode_sync(struct work_struct *work);
-void laptop_mode_timer_fn(unsigned long data);
 void throttle_vm_writeout(gfp_t gfp_mask);
 
 /* These are exported to sysctl. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
fix-pca953x-set_type-scheduling-while-atomic-bug-checkpatch-fixes.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
drivers-acpi-use-kasprintf-fix.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface-checkpatch-fixes.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
jfs-free-sbi-memory-in-error-path.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
hpet-factor-timer-allocate-from-open-fix.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries-checkpatch-fixes.patch
laptop-mode-make-flushes-per-device-fix.patch
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

