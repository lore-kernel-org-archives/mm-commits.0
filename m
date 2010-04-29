From: akpm@linux-foundation.org
Subject: [merged] laptop-mode-make-flushes-per-device-fix.patch removed from -mm tree
Date: Thu, 29 Apr 2010 13:56:55 -0400
Message-ID: <201004292058.o3TKwSgM011792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932757Ab0D3RJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mjg@redhat.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     "laptop-mode: Make flushes per-device" fix
has been removed from the -mm tree.  Its filename was
     laptop-mode-make-flushes-per-device-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-fix-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-acpi-use-kasprintf.patch
acpi_pad-processor_aggregator-name-too-long.patch
x86-fix-handling-of-the-reservetop-boot-option.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
sched-introduce-get_cpu_iowait_time_us.patch
jfs-free-sbi-memory-in-error-path.patch
dib3000mc-reduce-large-stack-usage-fix.patch
dib7000p-reduce-large-stack-usage-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.patch
drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries.patch
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

