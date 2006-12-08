From: akpm@osdl.org
Subject: + implement-flush_work.patch added to -mm tree
Date: Thu, 07 Dec 2006 16:23:12 -0800
Message-ID: <200612080023.kB80ND3k000929@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1164214AbWLHAYZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 19:24:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, auke-jan.h.kok@intel.com, axboe@suse.de, bcrl@kvack.org, davem@davemloft.net, dhowells@redhat.com, jeff@garzik.org, macro@linux-mips.org, mchan@broadcom.com, nickpiggin@yahoo.com.au, torvalds@osdl.org, zach.brown@oracle.com


The patch titled
     implement flush_work() and flush_keventd_work()
has been added to the -mm tree.  Its filename is
     implement-flush_work.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: implement flush_work() and flush_keventd_work()
From: Andrew Morton <akpm@osdl.org>

A basic problem with flush_scheduled_work() is that it blocks behind _all_
presently-queued works, rather than just the work whcih the caller wants to
flush.  If the caller holds some lock, and if one of the queued work happens
to want that lock as well then accidental deadlocks can occur.

One example of this is the phy layer: it wants to flush work while holding
rtnl_lock().  But if a linkwatch event happens to be queued, the phy code will
deadlock because the linkwatch callback function takes rtnl_lock.

So we implement a new function which will flush a *single* work - just the one
which the caller wants to free up.  Thus we avoid the accidental deadlocks
which can arise from unrelated subsystems' callbacks taking shared locks.

It plays games with workqueue_mutex to avoid deadlocks which can occur when a
work callback itself wants to run flush_scheduled_work.  scsi does this when
tearing down a request_queue.

It might well explode when used in combination with no-auto-release
work_structs.  But they need to go away...

(Various patches which use this new facility in various popular places
follow..)

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Linus Torvalds <torvalds@osdl.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jens Axboe <axboe@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/workqueue.h |    4 +
 kernel/workqueue.c        |   89 +++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 3 deletions(-)

diff -puN kernel/workqueue.c~implement-flush_work kernel/workqueue.c
--- a/kernel/workqueue.c~implement-flush_work
+++ a/kernel/workqueue.c
@@ -56,6 +56,7 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
+	struct work_struct *current_work;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 
@@ -78,6 +79,7 @@ static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu;
+static struct workqueue_struct *keventd_wq;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
@@ -323,6 +325,7 @@ static void run_workqueue(struct cpu_wor
 		work_func_t f = work->func;
 
 		list_del_init(cwq->worklist.next);
+		cwq->current_work = work;
 		spin_unlock_irqrestore(&cwq->lock, flags);
 
 		BUG_ON(get_wq_data(work) != cwq);
@@ -342,6 +345,7 @@ static void run_workqueue(struct cpu_wor
 		}
 
 		spin_lock_irqsave(&cwq->lock, flags);
+		cwq->current_work = NULL;
 		cwq->remove_sequence++;
 		wake_up(&cwq->work_done);
 	}
@@ -440,6 +444,89 @@ static void flush_cpu_workqueue(struct c
 	}
 }
 
+static void wait_on_work(struct cpu_workqueue_struct *cwq,
+				struct work_struct *work, int cpu)
+{
+	DEFINE_WAIT(wait);
+
+	spin_lock_irq(&cwq->lock);
+	while (cwq->current_work == work) {
+		prepare_to_wait(&cwq->work_done, &wait, TASK_UNINTERRUPTIBLE);
+		spin_unlock_irq(&cwq->lock);
+		if (cpu != -1)
+			mutex_unlock(&workqueue_mutex);
+		schedule();
+		if (cpu != -1) {
+			mutex_lock(&workqueue_mutex);
+			if (!cpu_online(cpu))	/* oops, CPU got unplugged */
+				goto bail;
+		}
+		spin_lock_irq(&cwq->lock);
+	}
+	spin_unlock_irq(&cwq->lock);
+bail:
+	finish_wait(&cwq->work_done, &wait);
+}
+
+static void flush_one_work(struct cpu_workqueue_struct *cwq,
+				struct work_struct *work, int cpu)
+{
+	spin_lock_irq(&cwq->lock);
+	if (test_and_clear_bit(WORK_STRUCT_PENDING, &work->management)) {
+		list_del_init(&work->entry);
+		spin_unlock_irq(&cwq->lock);
+		return;
+	}
+	spin_unlock_irq(&cwq->lock);
+
+	/* It's running, or it has completed */
+	wait_on_work(cwq, work, cpu);
+}
+
+/**
+ * flush_work - block until a work_struct's callback has terminated
+ * @wq: the workqueue on which the work is queued
+ * @work: the work which is to be flushed
+ *
+ * flush_work() will attempt to cancel the work if it is queued.  If the work's
+ * callback appears to be running, flush_work() will block until it has
+ * completed.
+ *
+ * flush_work() is designed to be used when the caller is tearing down data
+ * structures which the callback function operates upon.  It is expected that,
+ * prior to calling flush_work(), the caller has arranged for the work to not
+ * be requeued.
+ */
+void flush_work(struct workqueue_struct *wq, struct work_struct *work)
+{
+	if (is_single_threaded(wq)) {
+		/* Always use first cpu's area. */
+		flush_one_work(per_cpu_ptr(wq->cpu_wq, singlethread_cpu), work,
+				-1);
+	} else {
+		int cpu;
+
+		mutex_lock(&workqueue_mutex);
+		for_each_online_cpu(cpu)
+			flush_one_work(per_cpu_ptr(wq->cpu_wq, cpu), work, cpu);
+		mutex_unlock(&workqueue_mutex);
+	}
+}
+EXPORT_SYMBOL_GPL(flush_work);
+
+/**
+ * flush_keventd_work - block until a keventd-owned work_struct's callback has terminated
+ * @work: the work whcih is to be flushed
+ *
+ * flush_keventd_work() runs flush_work() against a work_struct which is handled
+ * by keventd.
+ */
+void flush_keventd_work(struct work_struct *work)
+{
+	flush_work(keventd_wq, work);
+}
+EXPORT_SYMBOL_GPL(flush_keventd_work);
+
 /**
  * flush_workqueue - ensure that any scheduled work has run to completion.
  * @wq: workqueue to flush
@@ -592,8 +679,6 @@ void destroy_workqueue(struct workqueue_
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
-static struct workqueue_struct *keventd_wq;
-
 /**
  * schedule_work - put work task in global workqueue
  * @work: job to be done
diff -puN include/linux/workqueue.h~implement-flush_work include/linux/workqueue.h
--- a/include/linux/workqueue.h~implement-flush_work
+++ a/include/linux/workqueue.h
@@ -160,6 +160,8 @@ extern int FASTCALL(queue_delayed_work(s
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct delayed_work *work, unsigned long delay);
 extern void FASTCALL(flush_workqueue(struct workqueue_struct *wq));
+extern void flush_work(struct workqueue_struct *wq, struct work_struct *work);
+extern void flush_keventd_work(struct work_struct *work);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
 extern int FASTCALL(run_scheduled_work(struct work_struct *work));
@@ -180,7 +182,7 @@ int execute_in_process_context(work_func
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
  * function may still be running on return from cancel_delayed_work().  Run
- * flush_scheduled_work() to wait on it.
+ * flush_scheduled_work() or flush_work() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
workqueue-tweaks.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
implement-flush_work.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
bridge-avoid-using-noautorel-workqueues.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-dont-select-pm.patch
implementation-of-acpi_video_get_next_level.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
alsa-workqueue-fixes.patch
git-cpufreq-prep.patch
git-cpufreq.patch
git-cpufreq-fixup.patch
platform_driver_probe-can-save-codespace-save-codespace.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-ia64.patch
git-ieee1394-fixup.patch
git-input.patch
git-input-fixup.patch
git-input-vs-git-alsa.patch
kbuild-fix-rr-is-now-default.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
pata_via-suspend-resume-support-fix.patch
pata_it8213-add-new-driver-for-the-it8213-card.patch
git-lxdialog-fixup.patch
git-mmc-fixup.patch
git-mmc-tifm_sd-warning-fix.patch
git-mtd.patch
git-mtd-ssfdc-build-fix.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
pci-fix-multiple-problems-with-via-hardware.patch
pci-legacy-resource-fix-tidy.patch
git-s390.patch
s390-workqueue-fixes.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-in2000-scsi_cmnd-convertion.patch
aic79xx-wrong-max-memory-at-driver-init.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver-fix.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy.patch
x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code-tidy-tidy-2.patch
touchkit-ps-2-touchscreen-driver.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
congestion-wait-dont-wait-when-there-are-no-pages-under-writeback.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
add-include-linux-freezerh-and-move-definitions-from-ucb1400_ts-fix.patch
ubi-versus-add-include-linux-freezerh-and-move-definitions-from.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
touch_atime-cleanup.patch
ocfs2-relative-atime-support-tweaks.patch
optimize-o_direct-on-block-device-v3-tweak.patch
add-retain_initrd-boot-option-tweak.patch
io-accounting-core-statistics.patch
clean-up-__set_page_dirty_nobuffers.patch
io-accounting-write-accounting.patch
io-accounting-write-cancel-accounting.patch
io-accounting-read-accounting-2.patch
io-accounting-read-accounting-nfs-fix.patch
io-accounting-read-accounting-cifs-fix.patch
io-accounting-direct-io.patch
io-accounting-report-in-procfs.patch
cleanup-taskstatsh.patch
io-accounting-via-taskstats.patch
getdelays-various-fixes.patch
io-accounting-add-to-getdelays.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
bug-test-1.patch
net-use-bitrev8-tidy.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
mxser-session-warning-fix.patch
mxser-workqueue-fixes.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-irda-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
tty_ioctl-use-termios-for-the-old-structure-and-termios2-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
fault-injection-capabilities-infrastructure-tidy.patch
fault-injection-capabilities-infrastructure-tweaks.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
sched-add-option-to-serialize-load-balancing-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch
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
video-get-the-default-mode-from-the-right-database.patch
various-fbdev-files-mark-structs-fix.patch
backlight-lcd-remove-dependenct-from-the-framebuffer-layer-tidy.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options-tidy.patch
md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure-fix.patch
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
round_jiffies-infrastructure-fix.patch
clocksource-small-cleanup-2-fix.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
zeromap_pte_range-debug.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch

