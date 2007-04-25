From: akpm@linux-foundation.org
Subject: + block-debug.patch added to -mm tree
Date: Wed, 25 Apr 2007 00:48:23 -0700
Message-ID: <200704250748.l3P7mNA3030046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161837AbXDYHs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 03:48:26 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l3P7mNwP004581
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 25 Apr 2007 00:48:24 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     block-debug
has been added to the -mm tree.  Its filename is
     block-debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: block-debug
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c    |    6 +++++-
 drivers/ide/ide-io.c    |   24 +++++++++++++++++++-----
 drivers/scsi/scsi_lib.c |    2 ++
 include/linux/kernel.h  |    9 +++++++++
 4 files changed, 35 insertions(+), 6 deletions(-)

diff -puN drivers/ide/ide-cd.c~block-debug drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~block-debug
+++ a/drivers/ide/ide-cd.c
@@ -724,8 +724,10 @@ static int cdrom_decode_status(ide_drive
 		 * if we have an error, pass back CHECK_CONDITION as the
 		 * scsi status byte
 		 */
-		if (blk_pc_request(rq) && !rq->errors)
+		if (blk_pc_request(rq) && !rq->errors) {
 			rq->errors = SAM_STAT_CHECK_CONDITION;
+			MMMMM(rq->errors);
+		}
 
 		/* Check for tray open. */
 		if (sense_key == NOT_READY) {
@@ -791,6 +793,7 @@ static int cdrom_decode_status(ide_drive
 				if (!rq->errors)
 					info->write_timeout = jiffies + ATAPI_WAIT_WRITE_BUSY;
 				rq->errors = 1;
+				MMMMM(rq->errors);
 				if (time_after(jiffies, info->write_timeout))
 					do_end_request = 1;
 				else {
@@ -3127,6 +3130,7 @@ static int ide_cdrom_prep_pc(struct requ
 	 */
 	if (c[0] == MODE_SENSE || c[0] == MODE_SELECT) {
 		rq->errors = ILLEGAL_REQUEST;
+		MMMMM(rq->errors);
 		return BLKPREP_KILL;
 	}
 	
diff -puN drivers/ide/ide-io.c~block-debug drivers/ide/ide-io.c
--- a/drivers/ide/ide-io.c~block-debug
+++ a/drivers/ide/ide-io.c
@@ -66,8 +66,10 @@ static int __ide_end_request(ide_drive_t
 	if (blk_noretry_request(rq) && end_io_error(uptodate))
 		nr_sectors = rq->hard_nr_sectors;
 
-	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors)
+	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors) {
 		rq->errors = -EIO;
+		MMMMM(rq->errors);
+	}
 
 	/*
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
@@ -265,8 +267,10 @@ int ide_end_dequeued_request(ide_drive_t
 	if (blk_noretry_request(rq) && end_io_error(uptodate))
 		nr_sectors = rq->hard_nr_sectors;
 
-	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors)
+	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors) {
 		rq->errors = -EIO;
+		MMMMM(rq->errors);
+	}
 
 	/*
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
@@ -380,8 +384,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 
 	if (rq->cmd_type == REQ_TYPE_ATA_CMD) {
 		u8 *args = (u8 *) rq->buffer;
-		if (rq->errors == 0)
+		if (rq->errors == 0) {
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
+			MMMMM(rq->errors);
+		}
 
 		if (args) {
 			args[0] = stat;
@@ -390,8 +396,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 		}
 	} else if (rq->cmd_type == REQ_TYPE_ATA_TASK) {
 		u8 *args = (u8 *) rq->buffer;
-		if (rq->errors == 0)
+		if (rq->errors == 0) {
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
+			MMMMM(rq->errors);
+		}
 
 		if (args) {
 			args[0] = stat;
@@ -404,8 +412,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 		}
 	} else if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *args = (ide_task_t *) rq->special;
-		if (rq->errors == 0)
+		if (rq->errors == 0) {
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
+			MMMMM(rq->errors);
+		}
 			
 		if (args) {
 			if (args->tf_in_flags.b.data) {
@@ -448,6 +458,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
 	rq->errors = err;
+	MMMMM(rq->errors);
 	end_that_request_last(rq, !rq->errors);
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
@@ -510,6 +521,7 @@ static ide_startstop_t ide_ata_error(ide
 		} else if (err & (BBD_ERR | ECC_ERR)) {
 			/* retries won't help these */
 			rq->errors = ERROR_MAX;
+			MMMMM(rq->errors);
 		} else if (err & TRK0_ERR) {
 			/* help it find track zero */
 			rq->errors |= ERROR_RECAL;
@@ -604,6 +616,7 @@ ide_startstop_t ide_error (ide_drive_t *
 	/* retry only "normal" I/O: */
 	if (!blk_fs_request(rq)) {
 		rq->errors = 1;
+		MMMMM(rq->errors);
 		ide_end_drive_cmd(drive, stat, err);
 		return ide_stopped;
 	}
@@ -655,6 +668,7 @@ ide_startstop_t ide_abort(ide_drive_t *d
 	/* retry only "normal" I/O: */
 	if (!blk_fs_request(rq)) {
 		rq->errors = 1;
+		MMMMM(rq->errors);
 		ide_end_drive_cmd(drive, BUSY_STAT, 0);
 		return ide_stopped;
 	}
diff -puN drivers/scsi/scsi_lib.c~block-debug drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~block-debug
+++ a/drivers/scsi/scsi_lib.c
@@ -835,6 +835,7 @@ void scsi_io_completion(struct scsi_cmnd
 
 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
 		req->errors = result;
+		MMMMM(req->errors);
 		if (result) {
 			clear_errors = 0;
 			if (sense_valid && req->sense) {
@@ -1252,6 +1253,7 @@ static int scsi_prep_fn(struct request_q
 	switch (ret) {
 	case BLKPREP_KILL:
 		req->errors = DID_NO_CONNECT << 16;
+		MMMMM(req->errors);
 		break;
 	case BLKPREP_DEFER:
 		/*
diff -puN include/linux/kernel.h~block-debug include/linux/kernel.h
--- a/include/linux/kernel.h~block-debug
+++ a/include/linux/kernel.h
@@ -20,6 +20,15 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+#define MMMMM(n)							\
+	do {								\
+		if (n) {						\
+			printk("%s:%d: setting error to %d\n",		\
+				__FILE__, __LINE__, (int)n);		\
+			dump_stack();					\
+		}							\
+	} while (0)
+
 #define INT_MAX		((int)(~0U>>1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-thermal-fix-mod_timer-interval.patch
packet-fix-error-handling.patch
fix-x86-fix-potential-overflow-in-perfctr-reservation.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage-fix.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
device_schedule_callback-needs-a-module-reference-fix.patch
define-platform-wakeup-hook-use-in-pci_enable_wake-fix.patch
dev_dbg-check-dev_dbg-arguments-fix.patch
dev_dbg-check-dev_dbg-arguments-fix-2.patch
sysfs-binc-printk-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
sbp2-include-fixes.patch
git-infiniband-make-it-build-hack.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
git-ubi-fixup.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
git-netdev-all-fixup.patch
reapply-gitpowerpc-ehea-changes.patch
git-netdev-all-baycom_ser_fdx-fix.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-fix-yamc.patch
git-net-vs-git-netdev-all.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-3.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-s390-fixup.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
pci-error-recovery-symbios-scsi-base-support-fixes.patch
pci-error-recovery-symbios-scsi-first-failure-fix.patch
cxacru-add-documentation-file-fix.patch
fix-x86_64-mm-fam10-mwait-idle.patch
more-fix-x86_64-mm-fam10-mwait-idle.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
x86_64-unexport-cpu_llc_id.patch
xfs-clean-up-shrinker-games.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
extend-print_symbol-capability-fix-fix.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-more-statics.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
unprivileged-mounts-account-user-mounts-fix.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt-fix.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
block-debug.patch
