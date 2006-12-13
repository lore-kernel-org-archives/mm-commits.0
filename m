From: akpm@osdl.org
Subject: - io-accounting-core-statistics.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:52:32 -0800
Message-ID: <200612130652.kBD6qWDa030446@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964985AbWLMGwv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:52:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, balbir@in.ibm.com, csturtiv@sgi.com, daw@sgi.com, guillaume.thouvenin@bull.net, jlan@sgi.com, nagar@watson.ibm.com, tee@sgi.com, mm-commits@vger.kernel.org


The patch titled
     io-accounting: core statistics
has been removed from the -mm tree.  Its filename was
     io-accounting-core-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: io-accounting: core statistics
From: Andrew Morton <akpm@osdl.org>

The present per-task IO accounting isn't very useful.  It simply counts the
number of bytes passed into read() and write().  So if a process reads 1MB
from an already-cached file, it is accused of having performed 1MB of I/O,
which is wrong.

(David Wright had some comments on the applicability of the present logical IO accounting:

  For billing purposes it is useless but for workload analysis it is very
  useful

  read_bytes/read_calls  average read request size
  write_bytes/write_calls average write request size

  read_bytes/read_blocks ie logical/physical can indicate hit rate or thrashing
  write_bytes/write_blocks  ie logical/physical  guess since pdflush writes can
                                                be missed

  I often look for logical larger than physical to see filesystem cache
  problems.  And the bytes/cpusec can help find applications that are
  dominating the cache and causing slow interactive response from page cache
  contention.

  I want to find the IO intensive applications and make sure they are doing
  efficient IO.  Thus the acctcms(sysV) or csacms command would give the high
  IO commands).


This patchset adds new accounting which tries to be more accurate.  We account
for three things:

reads:

  attempt to count the number of bytes which this process really did cause
  to be fetched from the storage layer.  Done at the submit_bio() level, so it
  is accurate for block-backed filesystems.  I also attempt to wire up NFS and
  CIFS.

writes:

  attempt to count the number of bytes which this process caused to be sent
  to the storage layer.  This is done at page-dirtying time.

  The big inaccuracy here is truncate.  If a process writes 1MB to a file
  and then deletes the file, it will in fact perform no writeout.  But it will
  have been accounted as having caused 1MB of write.

  So...

cancelled_writes:

  account the number of bytes which this process caused to not happen, by
  truncating pagecache.

  We _could_ just subtract this from the process's `write' accounting.  But
  that means that some processes would be reported to have done negative
  amounts of write IO, which is silly.

  So we just report the raw number and punt this decision up to userspace.


Now, we _could_ account for writes at the physical I/O level.  But

- This would require that we track memory-dirtying tasks at the per-page
  level (would require a new pointer in struct page).

- It would mean that IO statistics for a process are usually only available
  long after that process has exitted.  Which means that we probably cannot
  communicate this info via taskstats.


This patch:

Wire up the kernel-private data structures and the accessor functions to
manipulate them.

Cc: Jay Lan <jlan@sgi.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Chris Sturtivant <csturtiv@sgi.com>
Cc: Tony Ernst <tee@sgi.com>
Cc: Guillaume Thouvenin <guillaume.thouvenin@bull.net>
Cc: David Wright <daw@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/sched.h                  |    2 
 include/linux/task_io_accounting.h     |   37 ++++++++++++++++++
 include/linux/task_io_accounting_ops.h |   47 +++++++++++++++++++++++
 init/Kconfig                           |    9 ++++
 kernel/fork.c                          |    2 
 5 files changed, 97 insertions(+)

diff -puN include/linux/sched.h~io-accounting-core-statistics include/linux/sched.h
--- a/include/linux/sched.h~io-accounting-core-statistics
+++ a/include/linux/sched.h
@@ -82,6 +82,7 @@ struct sched_param {
 #include <linux/resource.h>
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
+#include <linux/task_io_accounting.h>
 
 #include <asm/processor.h>
 
@@ -1013,6 +1014,7 @@ struct task_struct {
 	wait_queue_t *io_wait;
 /* i/o counters(bytes read/written, #syscalls */
 	u64 rchar, wchar, syscr, syscw;
+	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
 	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
diff -puN /dev/null include/linux/task_io_accounting.h
--- /dev/null
+++ a/include/linux/task_io_accounting.h
@@ -0,0 +1,37 @@
+/*
+ * task_io_accounting: a structure which is used for recording a single task's
+ * IO statistics.
+ *
+ * Don't include this header file directly - it is designed to be dragged in via
+ * sched.h.
+ *
+ * Blame akpm@osdl.org for all this.
+ */
+
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+struct task_io_accounting {
+	/*
+	 * The number of bytes which this task has caused to be read from
+	 * storage.
+	 */
+	u64 read_bytes;
+
+	/*
+	 * The number of bytes which this task has caused, or shall cause to be
+	 * written to disk.
+	 */
+	u64 write_bytes;
+
+	/*
+	 * A task can cause "negative" IO too.  If this task truncates some
+	 * dirty pagecache, some IO which another task has been accounted for
+	 * (in its write_bytes) will not be happening.  We _could_ just
+	 * subtract that from the truncating task's write_bytes, but there is
+	 * information loss in doing that.
+	 */
+	u64 cancelled_write_bytes;
+};
+#else
+struct task_io_accounting {
+};
+#endif
diff -puN /dev/null include/linux/task_io_accounting_ops.h
--- /dev/null
+++ a/include/linux/task_io_accounting_ops.h
@@ -0,0 +1,47 @@
+/*
+ * Task I/O accounting operations
+ */
+#ifndef __TASK_IO_ACCOUNTING_OPS_INCLUDED
+#define __TASK_IO_ACCOUNTING_OPS_INCLUDED
+
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+static inline void task_io_account_read(size_t bytes)
+{
+	current->ioac.read_bytes += bytes;
+}
+
+static inline void task_io_account_write(size_t bytes)
+{
+	current->ioac.write_bytes += bytes;
+}
+
+static inline void task_io_account_cancelled_write(size_t bytes)
+{
+	current->ioac.cancelled_write_bytes += bytes;
+}
+
+static inline void task_io_accounting_init(struct task_struct *tsk)
+{
+	memset(&tsk->ioac, 0, sizeof(tsk->ioac));
+}
+
+#else
+
+static inline void task_io_account_read(size_t bytes)
+{
+}
+
+static inline void task_io_account_write(size_t bytes)
+{
+}
+
+static inline void task_io_account_cancelled_write(size_t bytes)
+{
+}
+
+static inline void task_io_accounting_init(struct task_struct *tsk)
+{
+}
+
+#endif		/* CONFIG_TASK_IO_ACCOUNTING */
+#endif		/* __TASK_IO_ACCOUNTING_OPS_INCLUDED */
diff -puN init/Kconfig~io-accounting-core-statistics init/Kconfig
--- a/init/Kconfig~io-accounting-core-statistics
+++ a/init/Kconfig
@@ -304,6 +304,15 @@ config TASK_XACCT
 
 	  Say N if unsure.
 
+config TASK_IO_ACCOUNTING
+	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
+	depends on TASK_XACCT
+	help
+	  Collect information on the number of bytes of storage I/O which this
+	  task has caused.
+
+	  Say N if unsure.
+
 config SYSCTL
 	bool
 
diff -puN kernel/fork.c~io-accounting-core-statistics kernel/fork.c
--- a/kernel/fork.c~io-accounting-core-statistics
+++ a/kernel/fork.c
@@ -36,6 +36,7 @@
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
 #include <linux/futex.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/rcupdate.h>
 #include <linux/ptrace.h>
 #include <linux/mount.h>
@@ -1055,6 +1056,7 @@ static struct task_struct *copy_process(
 	p->wchar = 0;		/* I/O counter: bytes written */
 	p->syscr = 0;		/* I/O counter: read syscalls */
 	p->syscw = 0;		/* I/O counter: write syscalls */
+	task_io_accounting_init(p);
 	acct_clear_integrals(p);
 
  	p->it_virt_expires = cputime_zero;
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

