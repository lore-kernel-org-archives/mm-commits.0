From: akpm@linux-foundation.org
Subject: - enhance-initcall_debug-measure-latency.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:33 -0700
Message-ID: <200705090248.l492mXWk009124@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbXEICsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     enhance initcall_debug, measure latency
has been removed from the -mm tree.  Its filename was
     enhance-initcall_debug-measure-latency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: enhance initcall_debug, measure latency
From: Ingo Molnar <mingo@elte.hu>

enhance the initcall_debug boot option:

 - measure the time the initcall took to execute and report
   it in units of milliseconds.

 - show the return code of initcalls (useful to see failures and
   to make sure that an initcall hung)

[akpm@linux-foundation.org: fix printk warning]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN init/main.c~enhance-initcall_debug-measure-latency init/main.c
--- a/init/main.c~enhance-initcall_debug-measure-latency
+++ a/init/main.c
@@ -648,6 +648,7 @@ static void __init do_initcalls(void)
 	int count = preempt_count();
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
+		ktime_t t0, t1, delta;
 		char *msg = NULL;
 		char msgbuf[40];
 		int result;
@@ -657,10 +658,26 @@ static void __init do_initcalls(void)
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
+				*call, (unsigned long long)delta.tv64 >> 20);
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
git-ieee1394.patch
git-kvm.patch
forcedeth-improve-napi-logic.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
mutex_lock_interruptible-add-__must_check.patch
fix-printk-format-warnings-in-timer_listc.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
introduce-freezer-flags-rev-2.patch
aio-is-unlikely.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
declare-struct-ktime.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
futex_requeue_pi-optimization.patch
futex-new-private-futexes.patch
timer-parenthesis-fix-in-tbase_get_deferrable-etc.patch
clocksource-fix-resume-logic.patch
clockevents-fix-resume-logic-updated-version.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
