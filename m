From: akpm@osdl.org
Subject: - debug-add-sysrq_always_enabled-boot-option.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:08:51 -0800
Message-ID: <200612140608.kBE68pBt001958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52253 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbWLNGMV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:12:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     debug: add sysrq_always_enabled boot option
has been removed from the -mm tree.  Its filename was
     debug-add-sysrq_always_enabled-boot-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: debug: add sysrq_always_enabled boot option
From: Ingo Molnar <mingo@elte.hu>

Most distributions enable sysrq support but set it to 0 by default.  Add a
sysrq_always_enabled boot option to always-enable sysrq keys.  Useful for
debugging - without having to modify the disribution's config files (which
might not be possible if the kernel is on a live CD, etc.).

Also, while at it, clean up the sysrq interfaces.

[bunk@stusta.de: make sysrq_always_enabled_setup() static]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
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
@@ -1656,6 +1656,12 @@ and is between 256 and 4096 characters. 
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
+static int __init sysrq_always_enabled_setup(char *str)
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
@@ -543,7 +542,7 @@ static ctl_table kern_table[] = {
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

conditionally-check-expected_preempt_count-in-__resched_legal.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
debugging-feature-proc-timer_list.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
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
kmap_atomic-debugging.patch

