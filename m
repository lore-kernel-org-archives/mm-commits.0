From: akpm@osdl.org
Subject: + debugging-feature-sysrq-q-to-print-timers.patch added to -mm tree
Date: Mon, 18 Dec 2006 15:28:59 -0800
Message-ID: <200612182328.kBINSxWr016152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58245 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbWLRX3E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:29:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     debugging feature: SysRq-Q to print timers
has been added to the -mm tree.  Its filename is
     debugging-feature-sysrq-q-to-print-timers.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: debugging feature: SysRq-Q to print timers
From: Ingo Molnar <mingo@elte.hu>

Add SysRq-Q to print pending timers and other timer info.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sysrq.c    |   14 +++++++++++++-
 include/linux/hrtimer.h |    3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/char/sysrq.c~debugging-feature-sysrq-q-to-print-timers drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~debugging-feature-sysrq-q-to-print-timers
+++ a/drivers/char/sysrq.c
@@ -36,6 +36,7 @@
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
 #include <linux/irq.h>
+#include <linux/hrtimer.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -159,6 +160,17 @@ static struct sysrq_key_op sysrq_sync_op
 	.enable_mask	= SYSRQ_ENABLE_SYNC,
 };
 
+static void sysrq_handle_show_timers(int key, struct tty_struct *tty)
+{
+	sysrq_timer_list_show();
+}
+
+static struct sysrq_key_op sysrq_show_timers_op = {
+	.handler	= sysrq_handle_show_timers,
+	.help_msg	= "show-all-timers(Q)",
+	.action_msg	= "Show Pending Timers",
+};
+
 static void sysrq_handle_mountro(int key, struct tty_struct *tty)
 {
 	emergency_remount();
@@ -335,7 +347,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	/* This will often be registered as 'Off' at init time */
 	NULL,				/* o */
 	&sysrq_showregs_op,		/* p */
-	NULL,				/* q */
+	&sysrq_show_timers_op,		/* q */
 	&sysrq_unraw_op,			/* r */
 	&sysrq_sync_op,			/* s */
 	&sysrq_showstate_op,		/* t */
diff -puN include/linux/hrtimer.h~debugging-feature-sysrq-q-to-print-timers include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~debugging-feature-sysrq-q-to-print-timers
+++ a/include/linux/hrtimer.h
@@ -344,6 +344,9 @@ static inline void show_no_hz_stats(stru
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
+/* Show pending timers: */
+extern void sysrq_timer_list_show(void);
+
 /*
  * Timer-statistics info:
  */
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch
genirq-fix-irq-flow-handler-uninstall.patch
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
cpuset-remove-sched-domain-hooks-from-cpusets.patch
schedule_on_each_cpu-use-preempt_disable.patch
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
debugging-feature-sysrq-q-to-print-timers.patch
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

