From: akpm@osdl.org
Subject: - implement-flush_work.patch removed from -mm tree
Date: Tue, 02 Jan 2007 16:07:00 -0800
Message-ID: <200701030007.l03070QX002032@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXACAKo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 19:10:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, auke-jan.h.kok@intel.com, axboe@suse.de, bcrl@kvack.org, davem@davemloft.net, dhowells@redhat.com, jeff@garzik.org, macro@linux-mips.org, mchan@broadcom.com, nickpiggin@yahoo.com.au, torvalds@osdl.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     implement flush_work() and flush_keventd_work()
has been removed from the -mm tree.  Its filename was
     implement-flush_work.patch

This patch was dropped because it is obsolete

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
@@ -319,6 +321,7 @@ static void run_workqueue(struct cpu_wor
 		work_func_t f = work->func;
 
 		list_del_init(cwq->worklist.next);
+		cwq->current_work = work;
 		spin_unlock_irqrestore(&cwq->lock, flags);
 
 		BUG_ON(get_wq_data(work) != cwq);
@@ -338,6 +341,7 @@ static void run_workqueue(struct cpu_wor
 		}
 
 		spin_lock_irqsave(&cwq->lock, flags);
+		cwq->current_work = NULL;
 		cwq->remove_sequence++;
 		wake_up(&cwq->work_done);
 	}
@@ -436,6 +440,89 @@ static void flush_cpu_workqueue(struct c
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
+	for ( ; ; ) {
+		struct cpu_workqueue_struct *cwq;
+
+		cwq = get_wq_data(work);
+		if (!cwq) {
+			/*
+			 * It has never been queued.  And the flush_work()
+			 * caller is required to guarantee that a queueing is
+			 * not in progress now, and cannot occur in the future.
+			 * So we're done.
+			 */
+			return;
+		}
+
+
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
@@ -588,8 +675,6 @@ void destroy_workqueue(struct workqueue_
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

start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch
pci-prevent-down_read-when-pci_devices-is-empty-fix.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
sound-hda-detect-alc883-on-msi-k9a-platinum-motherboards.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
git-libata-all-fixup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
git-ubi-mtd_read-arg-fix.patch
ubi-missing-include.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
add-i386-idle-notifier-take-3-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
bluetooth-blacklist-lenovo-r60e.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
debugging-feature-proc-timer_list-warning-fix.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
fsaio-filesystem-aio-read-tidy.patch
aio-is-unlikely.patch
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
reiser4-test_clear_page_dirty.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
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
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
