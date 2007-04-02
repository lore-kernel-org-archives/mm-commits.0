From: akpm@linux-foundation.org
Subject: + forcedeth-improve-napi-logic.patch added to -mm tree
Date: Mon, 02 Apr 2007 14:21:39 -0700
Message-ID: <200704022121.l32LLdmo009811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46684 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965927AbXDBVVs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 17:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, aabdulla@nvidia.com


The patch titled
     forcedeth: improve NAPI logic
has been added to the -mm tree.  Its filename is
     forcedeth-improve-napi-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: improve NAPI logic
From: Ingo Molnar <mingo@elte.hu>

Another forcedeth.c thing: i noticed that its NAPI handler does not do
tx-ring processing.  The patch below implements this - tested on DESC_VER_2
hardware, with CONFIG_FORCEDETH_NAPI=y.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN drivers/net/forcedeth.c~forcedeth-improve-napi-logic drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-improve-napi-logic
+++ a/drivers/net/forcedeth.c
@@ -3108,9 +3108,17 @@ static int nv_napi_poll(struct net_devic
 	int retcode;
 
 	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
+		spin_lock_irqsave(&np->lock, flags);
+		nv_tx_done(dev);
+		spin_unlock_irqrestore(&np->lock, flags);
+
 		pkts = nv_rx_process(dev, limit);
 		retcode = nv_alloc_rx(dev);
 	} else {
+		spin_lock_irqsave(&np->lock, flags);
+		nv_tx_done_optimized(dev, np->tx_ring_size);
+		spin_unlock_irqrestore(&np->lock, flags);
+
 		pkts = nv_rx_process_optimized(dev, limit);
 		retcode = nv_alloc_rx_optimized(dev);
 	}
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
revert-retries-in-ext3_prepare_write-violate-ordering-requirements.patch
revert-retries-in-ext4_prepare_write-violate-ordering-requirements.patch
driver-core-fix-built-in-drivers-sysfs-links.patch
git-ieee1394.patch
git-kvm.patch
forcedeth-improve-napi-logic.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
allow-per-cpu-variables-to-be-page-aligned.patch
forcedeth-work-around-null-skb-dereference-crash.patch
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
