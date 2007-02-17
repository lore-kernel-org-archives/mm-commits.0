From: akpm@linux-foundation.org
Subject: - add-sysrq-q-to-print-timer_list-debug-info.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:26 -0800
Message-ID: <200702170715.l1H7FQ5Z021625@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51440 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946596AbXBQHWO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:22:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Add SysRq-Q to print timer_list debug info
has been removed from the -mm tree.  Its filename was
     add-sysrq-q-to-print-timer_list-debug-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add SysRq-Q to print timer_list debug info
From: Ingo Molnar <mingo@elte.hu>

Add SysRq-Q to print pending timers and other timer info.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c    |   14 +++++++++++++-
 include/linux/hrtimer.h |    3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/char/sysrq.c~add-sysrq-q-to-print-timer_list-debug-info drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~add-sysrq-q-to-print-timer_list-debug-info
+++ a/drivers/char/sysrq.c
@@ -36,6 +36,7 @@
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
 #include <linux/irq.h>
+#include <linux/hrtimer.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -158,6 +159,17 @@ static struct sysrq_key_op sysrq_sync_op
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
 	/* o: This will often be registered as 'Off' at init time */
 	NULL,				/* o */
 	&sysrq_showregs_op,		/* p */
-	NULL,				/* q */
+	&sysrq_show_timers_op,		/* q */
 	&sysrq_unraw_op,		/* r */
 	&sysrq_sync_op,			/* s */
 	&sysrq_showstate_op,		/* t */
diff -puN include/linux/hrtimer.h~add-sysrq-q-to-print-timer_list-debug-info include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~add-sysrq-q-to-print-timer_list-debug-info
+++ a/include/linux/hrtimer.h
@@ -316,6 +316,9 @@ extern unsigned long ktime_divns(const k
 # define ktime_divns(kt, div)		(unsigned long)((kt).tv64 / (div))
 #endif
 
+/* Show pending timers: */
+extern void sysrq_timer_list_show(void);
+
 /*
  * Timer-statistics info:
  */
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
lockdep-debug_locks-check-after-check_chain_key.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
