From: akpm@linux-foundation.org
Subject: [merged] work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch removed from -mm tree
Date: Thu, 05 Mar 2009 11:56:25 -0800
Message-ID: <200903051956.n25JuPND027257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbZCET4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 14:56:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     work_on_cpu(): rewrite it to create a kernel thread on demand
has been removed from the -mm tree.  Its filename was
     work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
From: Andrew Morton <akpm@linux-foundation.org>

The various implementations and proposed implementations of work_on_cpu()
are vulnerable to various deadlocks because they all use queues of some
form.

Unrelated pieces of kernel code thus gained dependencies wherein if one
work_on_cpu() caller holds a lock which some other work_on_cpu() callback
also takes, the kernel could rarely deadlock.

Also, the present work_on_cpu() implementation creates yet another kernel
thread per CPU.

Fix this by creating a short-lived kernel thread for each work_on_cpu()
invokation.

This is not terribly fast, but the only current caller of work_on_cpu() is
pci_call_probe().

It would be nice to find some other way of doing the node-local
allocations in the PCI probe code so that we can zap work_on_cpu()
altogether.  The code there is rather nasty.  I can't think of anything
simple at this time...

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff -puN kernel/workqueue.c~work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand kernel/workqueue.c
--- a/kernel/workqueue.c~work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand
+++ a/kernel/workqueue.c
@@ -985,20 +985,20 @@ undo:
 }
 
 #ifdef CONFIG_SMP
-static struct workqueue_struct *work_on_cpu_wq __read_mostly;
 
 struct work_for_cpu {
-	struct work_struct work;
+	struct completion completion;
 	long (*fn)(void *);
 	void *arg;
 	long ret;
 };
 
-static void do_work_for_cpu(struct work_struct *w)
+static int do_work_for_cpu(void *_wfc)
 {
-	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
-
+	struct work_for_cpu *wfc = _wfc;
 	wfc->ret = wfc->fn(wfc->arg);
+	complete(&wfc->completion);
+	return 0;
 }
 
 /**
@@ -1009,17 +1009,23 @@ static void do_work_for_cpu(struct work_
  *
  * This will return the value @fn returns.
  * It is up to the caller to ensure that the cpu doesn't go offline.
+ * The caller must not hold any locks which would prevent @fn from completing.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
-	struct work_for_cpu wfc;
-
-	INIT_WORK(&wfc.work, do_work_for_cpu);
-	wfc.fn = fn;
-	wfc.arg = arg;
-	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
-	flush_work(&wfc.work);
-
+	struct task_struct *sub_thread;
+	struct work_for_cpu wfc = {
+		.completion = COMPLETION_INITIALIZER_ONSTACK(wfc.completion),
+		.fn = fn,
+		.arg = arg,
+	};
+
+	sub_thread = kthread_create(do_work_for_cpu, &wfc, "work_for_cpu");
+	if (IS_ERR(sub_thread))
+		return PTR_ERR(sub_thread);
+	kthread_bind(sub_thread, cpu);
+	wake_up_process(sub_thread);
+	wait_for_completion(&wfc.completion);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
@@ -1035,8 +1041,4 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
-#ifdef CONFIG_SMP
-	work_on_cpu_wq = create_workqueue("work_on_cpu");
-	BUG_ON(!work_on_cpu_wq);
-#endif
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
git-acpi-vs-git-cpufreq.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
arch-x86-mm-iomap_32c-fix-warning.patch
kernel-auditscc-fix-warning.patch
early-platform-driver-v3.patch
sysfs-dont-block-indefinitely-for-unmapped-files.patch
drivers-gpu-drm-drm_infoc-fix-warnings.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
leds-add-bd2802gu-led-driver.patch
mmc-add-extended-csd-register-to-debugfs.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-flex-onenand-support-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
vfs-simple_set_mnt-should-return-void.patch
libfs-make-simple_read_from_buffer-conventional-fix.patch
__tty_open-use-the-correct-type-for-saved_flags.patch
mtd_dataflash-fix-probing-of-at45db321c-chips-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ia64-fix-pci-dma-flag-propagation-on-sn-altix-with-pics.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
do_pipe-drop-its-last-user-in-arch-alpha-checkpatch-fixes.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
ubd-stop-defintining-major_nr-checkpatch-fixes.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-checkpatch-fixes.patch
flat-fix-data-sections-alignment-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
drivers-video-uvesafbc-dont-use-gfp_any.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
cirrusfb-fix-clock-doubling-fix.patch
fbdev-uninline-lock_fb_info.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
nbd-add-locking-to-nbd_ioctl-checkpatch-fixes.patch
nbd-add-locking-to-nbd_ioctl-fix.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-checkpatch-fixes-cleanup.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

