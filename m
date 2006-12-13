From: akpm@osdl.org
Subject: - io-accounting-via-taskstats.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:53:00 -0800
Message-ID: <200612130653.kBD6r0ZV030476@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57470 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964993AbWLMGxQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:53:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, balbir@in.ibm.com, csturtiv@sgi.com, daw@sgi.com, guillaume.thouvenin@bull.net, jlan@sgi.com, nagar@watson.ibm.com, tee@sgi.com, mm-commits@vger.kernel.org


The patch titled
     io-accounting: via taskstats
has been removed from the -mm tree.  Its filename was
     io-accounting-via-taskstats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: io-accounting: via taskstats
From: Andrew Morton <akpm@osdl.org>

Deliver IO accounting via taskstats.

Cc: Jay Lan <jlan@sgi.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Chris Sturtivant <csturtiv@sgi.com>
Cc: Tony Ernst <tee@sgi.com>
Cc: Guillaume Thouvenin <guillaume.thouvenin@bull.net>
Cc: David Wright <daw@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/taskstats.h |    8 +++++++-
 kernel/tsacct.c           |    9 +++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN include/linux/taskstats.h~io-accounting-via-taskstats include/linux/taskstats.h
--- a/include/linux/taskstats.h~io-accounting-via-taskstats
+++ a/include/linux/taskstats.h
@@ -31,7 +31,7 @@
  */
 
 
-#define TASKSTATS_VERSION	2
+#define TASKSTATS_VERSION	3
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -140,6 +140,12 @@ struct taskstats {
 	__u64	read_syscalls;		/* read syscalls */
 	__u64	write_syscalls;		/* write syscalls */
 	/* Extended accounting fields end */
+
+#define TASKSTATS_HAS_IO_ACCOUNTING
+	/* Per-task storage I/O accounting starts */
+	__u64	read_bytes;		/* bytes of read I/O */
+	__u64	write_bytes;		/* bytes of write I/O */
+	__u64	cancelled_write_bytes;	/* bytes of cancelled write I/O */
 };
 
 
diff -puN kernel/tsacct.c~io-accounting-via-taskstats kernel/tsacct.c
--- a/kernel/tsacct.c~io-accounting-via-taskstats
+++ a/kernel/tsacct.c
@@ -96,6 +96,15 @@ void xacct_add_tsk(struct taskstats *sta
 	stats->write_char	= p->wchar;
 	stats->read_syscalls	= p->syscr;
 	stats->write_syscalls	= p->syscw;
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	stats->read_bytes	= p->ioac.read_bytes;
+	stats->write_bytes	= p->ioac.write_bytes;
+	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
+#else
+	stats->read_bytes	= 0;
+	stats->write_bytes	= 0;
+	stats->cancelled_write_bytes = 0;
+#endif
 }
 #undef KB
 #undef MB
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
x86-smp-export-smp_num_siblings-for-oprofile.patch
cciss-remove-calls-to-pci_disable_device-fix.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-drm.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-input-vs-git-alsa.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-ubi.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
driver-for-silan-sc92031-netdev-include-fix.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-legacy-resource-fix-tidy.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
fix-gregkh-usb-usb-ehci-hcd-add-shadow-budget-code.patch
git-wireless.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
touchkit-ps-2-touchscreen-driver.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-2.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap-fix-3.patch
lumpy-reclaim-v2-tidy.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
ecryptfs-public-key-packet-management-slab-fix.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
lockdep-fix-possible-races-while-disabling-lock-debugging-fix.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-i386-convert-to-clock-event-devices.patch
updated-i386-convert-to-clock-event-devices-fix.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

