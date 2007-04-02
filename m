From: akpm@linux-foundation.org
Subject: + enhance-initcall_debug-measure-latency.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:50:46 -0700
Message-ID: <200704020550.l325okW0025402@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbXDBFu5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     enhance initcall_debug, measure latency
has been added to the -mm tree.  Its filename is
     enhance-initcall_debug-measure-latency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: enhance initcall_debug, measure latency
From: Ingo Molnar <mingo@elte.hu>

enhance the initcall_debug boot option:

 - measure the time the initcall took to execute and report
   it in units of milliseconds.

 - show the return code of initcalls (useful to see failures and
   to make sure that an initcall hung)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN init/main.c~enhance-initcall_debug-measure-latency init/main.c
--- a/init/main.c~enhance-initcall_debug-measure-latency
+++ a/init/main.c
@@ -652,6 +652,7 @@ static void __init do_initcalls(void)
 	int count = preempt_count();
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
+		ktime_t t0, t1, delta;
 		char *msg = NULL;
 		char msgbuf[40];
 		int result;
@@ -661,10 +662,26 @@ static void __init do_initcalls(void)
 			print_fn_descriptor_symbol(": %s()",
 					(unsigned long) *call);
 			printk("\n");
+			t0 = ktime_get();
 		}
 
 		result = (*call)();
 
+		if (initcall_debug) {
+			t1 = ktime_get();
+			delta = ktime_sub(t1, t0);
+
+			printk("initcall 0x%p", *call);
+			print_fn_descriptor_symbol(": %s()",
+					(unsigned long) *call);
+			printk(" returned %d.\n", result);
+
+			printk("initcall 0x%p ran for %Ld msecs: ",
+				*call, delta.tv64 >> 20);
+			print_fn_descriptor_symbol("%s()\n",
+				(unsigned long) *call);
+		}
+
 		if (result && result != -ENODEV && initcall_debug) {
 			sprintf(msgbuf, "error code %d", result);
 			msg = msgbuf;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
revert-retries-in-ext3_prepare_write-violate-ordering-requirements.patch
revert-retries-in-ext4_prepare_write-violate-ordering-requirements.patch
driver-core-fix-built-in-drivers-sysfs-links.patch
git-ieee1394.patch
git-kvm.patch
forcedeth-work-around-null-skb-dereference-crash.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
enhance-initcall_debug-measure-latency.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
declare-struct-ktime.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
sys_futex64-allows-64bit-futexes-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
clocksource-arm-initialize-list-value.patch
clocksource-parisc-initialize-list-value.patch
clocksource-avr32-initialize-list-value.patch
clocksource-mips-initialize-list-value.patch
clocksource-i386-initialize-list-value.patch
clocksource-x86_64-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
