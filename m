From: akpm@osdl.org
Subject: + debug-add-sysrq_always_enabled-boot-option.patch added to -mm tree
Date: Thu, 07 Dec 2006 12:28:01 -0800
Message-ID: <200612072028.kB7KS1Vj024495@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163292AbWLGU2I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 15:28:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     debug: add sysrq_always_enabled boot option
has been added to the -mm tree.  Its filename is
     debug-add-sysrq_always_enabled-boot-option.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: debug: add sysrq_always_enabled boot option
From: Ingo Molnar <mingo@elte.hu>

Most distributions enable sysrq support but set it to 0 by default.  Add a
sysrq_always_enabled boot option to always-enable sysrq keys.  Useful for
debugging - without having to modify the disribution's config files (which
might not be possible if the kernel is on a live CD, etc.).

Also, while at it, clean up the sysrq interfaces.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |    6 ++++
 drivers/char/sysrq.c                |   37 +++++++++++++++++++++-----
 drivers/char/viocons.c              |   10 ++-----
 include/linux/sysrq.h               |   22 ++++++++++++---
 kernel/sysctl.c                     |    3 --
 5 files changed, 60 insertions(+), 18 deletions(-)

diff -puN Documentation/kernel-parameters.txt~debug-add-sysrq_always_enabled-boot-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~debug-add-sysrq_always_enabled-boot-option
+++ a/Documentation/kernel-parameters.txt
@@ -1663,6 +1663,12 @@ and is between 256 and 4096 characters. 
 	sym53c416=	[HW,SCSI]
 			See header of drivers/scsi/sym53c416.c.
 
+	sysrq_always_enabled
+			[KNL]
+			Ignore sysrq setting - this boot parameter will
+			neutralize any effect of /proc/sys/kernel/sysrq.
+			Useful for debugging.
+
 	t128=		[HW,SCSI]
 			See header of drivers/scsi/t128.c.
 
diff -puN drivers/char/sysrq.c~debug-add-sysrq_always_enabled-boot-option drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~debug-add-sysrq_always_enabled-boot-option
+++ a/drivers/char/sysrq.c
@@ -41,7 +41,34 @@
 #include <asm/irq_regs.h>
 
 /* Whether we react on sysrq keys or just ignore them */
-int sysrq_enabled = 1;
+int __read_mostly __sysrq_enabled = 1;
+
+static int __read_mostly sysrq_always_enabled;
+
+int sysrq_on(void)
+{
+	return __sysrq_enabled || sysrq_always_enabled;
+}
+
+/*
+ * A value of 1 means 'all', other nonzero values are an op mask:
+ */
+static inline int sysrq_on_mask(int mask)
+{
+	return sysrq_always_enabled || __sysrq_enabled == 1 ||
+						(__sysrq_enabled & mask);
+}
+
+int __init sysrq_always_enabled_setup(char *str)
+{
+	sysrq_always_enabled = 1;
+	printk(KERN_INFO "debug: sysrq always enabled.\n");
+
+	return 1;
+}
+
+__setup("sysrq_always_enabled", sysrq_always_enabled_setup);
+
 
 static void sysrq_handle_loglevel(int key, struct tty_struct *tty)
 {
@@ -379,8 +406,7 @@ void __handle_sysrq(int key, struct tty_
 		 * Should we check for enabled operations (/proc/sysrq-trigger
 		 * should not) and is the invoked operation enabled?
 		 */
-		if (!check_mask || sysrq_enabled == 1 ||
-		    (sysrq_enabled & op_p->enable_mask)) {
+		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
 			printk("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
 			op_p->handler(key, tty);
@@ -414,9 +440,8 @@ void __handle_sysrq(int key, struct tty_
  */
 void handle_sysrq(int key, struct tty_struct *tty)
 {
-	if (!sysrq_enabled)
-		return;
-	__handle_sysrq(key, tty, 1);
+	if (sysrq_on())
+		__handle_sysrq(key, tty, 1);
 }
 EXPORT_SYMBOL(handle_sysrq);
 
diff -puN drivers/char/viocons.c~debug-add-sysrq_always_enabled-boot-option drivers/char/viocons.c
--- a/drivers/char/viocons.c~debug-add-sysrq_always_enabled-boot-option
+++ a/drivers/char/viocons.c
@@ -61,10 +61,7 @@
 static DEFINE_SPINLOCK(consolelock);
 static DEFINE_SPINLOCK(consoleloglock);
 
-#ifdef CONFIG_MAGIC_SYSRQ
 static int vio_sysrq_pressed;
-extern int sysrq_enabled;
-#endif
 
 #define VIOCHAR_NUM_BUF		16
 
@@ -936,8 +933,10 @@ static void vioHandleData(struct HvLpEve
 	 */
 	num_pushed = 0;
 	for (index = 0; index < cevent->len; index++) {
-#ifdef CONFIG_MAGIC_SYSRQ
-		if (sysrq_enabled) {
+		/*
+		 * Will be optimized away if !CONFIG_MAGIC_SYSRQ:
+		 */
+		if (sysrq_on()) {
 			/* 0x0f is the ascii character for ^O */
 			if (cevent->data[index] == '\x0f') {
 				vio_sysrq_pressed = 1;
@@ -956,7 +955,6 @@ static void vioHandleData(struct HvLpEve
 				continue;
 			}
 		}
-#endif
 		/*
 		 * The sysrq sequence isn't included in this check if
 		 * sysrq is enabled and compiled into the kernel because
diff -puN include/linux/sysrq.h~debug-add-sysrq_always_enabled-boot-option include/linux/sysrq.h
--- a/include/linux/sysrq.h~debug-add-sysrq_always_enabled-boot-option
+++ a/include/linux/sysrq.h
@@ -37,23 +37,37 @@ struct sysrq_key_op {
 
 #ifdef CONFIG_MAGIC_SYSRQ
 
+extern int sysrq_on(void);
+
+/*
+ * Do not use this one directly:
+ */
+extern int __sysrq_enabled;
+
 /* Generic SysRq interface -- you may call it from any device driver, supplying
  * ASCII code of the key, pointer to registers and kbd/tty structs (if they
  * are available -- else NULL's).
  */
 
-void handle_sysrq(int, struct tty_struct *);
-void __handle_sysrq(int, struct tty_struct *, int check_mask);
-int register_sysrq_key(int, struct sysrq_key_op *);
-int unregister_sysrq_key(int, struct sysrq_key_op *);
+void handle_sysrq(int key, struct tty_struct *tty);
+void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
+int register_sysrq_key(int key, struct sysrq_key_op *op);
+int unregister_sysrq_key(int key, struct sysrq_key_op *op);
 struct sysrq_key_op *__sysrq_get_key_op(int key);
 
 #else
 
+static inline int sysrq_on(void)
+{
+	return 0;
+}
 static inline int __reterr(void)
 {
 	return -EINVAL;
 }
+static inline void handle_sysrq(int key, struct tty_struct *tty)
+{
+}
 
 #define register_sysrq_key(ig,nore) __reterr()
 #define unregister_sysrq_key(ig,nore) __reterr()
diff -puN kernel/sysctl.c~debug-add-sysrq_always_enabled-boot-option kernel/sysctl.c
--- a/kernel/sysctl.c~debug-add-sysrq_always_enabled-boot-option
+++ a/kernel/sysctl.c
@@ -65,7 +65,6 @@ extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
 extern int max_threads;
-extern int sysrq_enabled;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
@@ -539,7 +538,7 @@ static ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_SYSRQ,
 		.procname	= "sysrq",
-		.data		= &sysrq_enabled,
+		.data		= &__sysrq_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
add-bottom_half.h.patch
convert-pm_sem-to-a-mutex.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets.patch
sysrq-x-show-blocked-tasks.patch
lockdep-internal-locking-fixes.patch
lockdep-misc-fixes-in-lockdepc.patch
binfmt_elf-randomize-pie-binaries.patch
disable-clone_child_cleartid-for-abnormal-exit.patch
lockdep-annotate-bcsp-driver.patch
lockdep-print-current-locks-on-in_atomic-warnings.patch
lockdep-name-some-old-style-locks.patch
sleep-profiling.patch
debug-workqueue-locking-sanity.patch
retries-in-ext3_prepare_write-violate-ordering-requirements.patch
retries-in-ext4_prepare_write-violate-ordering-requirements.patch
ktime-fix-signed--unsigned-mismatch-in-ktime_to_ns.patch
kprobes-enable-booster-on-the-preemptible-kernel.patch
declare-smp_call_function_single-in-generic-code.patch
smp_call_function_single-check-that-local-interrupts-are-enabled.patch
hotplug-cpu-clean-up-hotcpu_notifier-use.patch
remove-kernel-lockdepclockdep_internal.patch
lockdep-more-chains.patch
lockdep-show-more-details-about-self-test-failures.patch
softirq-remove-bug_ons-which-can-incorrectly-trigger.patch
futex-remove-unneeded-barrier.patch
lockdep-register_lock_class-fix.patch
add-ignore_loglevel-boot-option.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpei-gets-warning-at-kernel-irq-migrationc27-move_masked_irq.patch
time-re-add-verify_pmtmr_rate.patch
debug-add-sysrq_always_enabled-boot-option.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
fix-generic-warn_on-message.patch
schedc-correct-comment-for-this_rq_lock-routine.patch
sched-fix-migration-cost-estimator.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch
sched-domain-increase-the-smt-busy-rebalance-interval.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-decrease-number-of-load-balances.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
kernel-schedc-whitespace-cleanups.patch
kernel-schedc-whitespace-cleanups-more.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dynticks-core-code-fix-resume-bug.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
round_jiffies-infrastructure.patch
round_jiffies-infrastructure-fix.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch

