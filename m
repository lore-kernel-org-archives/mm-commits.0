From: akpm@osdl.org
Subject: - updated-dynticks-core-code-fix-resume-bug.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:53 -0800
Message-ID: <200612132249.kBDMnrxK023183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbWLMWt5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:49:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     dynticks: fix resume bug
has been removed from the -mm tree.  Its filename was
     updated-dynticks-core-code-fix-resume-bug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: dynticks: fix resume bug
From: Ingo Molnar <mingo@elte.hu>

Found a hotplug-CPU removal related bug in the dynticks code: the sched
tick hrtimer needs to be deactivated, otherwise it will be migrated to
another CPU's hrtimers queue and might confuse the high-res timers code
there.

The bug was found via lockdep - the bug itself didnt cause an actual crash
or other regression - nevertheless we want to fix it.

The lockdep message was:

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
swapper/0 is trying to release lock (cpu1_base->lock) at:
[<ffffffff8024e9e9>] hrtimer_sched_tick+0x5b/0xac
but there are no more locks to release!

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (cpu0_base->lock){+...}, at: [<ffffffff8024ece3>] hrtimer_interrupt+0x73/0x1a8

stack backtrace:

Call Trace:
 [<ffffffff8020b5e3>] dump_trace+0xaa/0x406
 [<ffffffff8020b979>] show_trace+0x3a/0x60
 [<ffffffff8020bbb9>] dump_stack+0x15/0x17
 [<ffffffff80252655>] print_unlock_inbalance_bug+0x108/0x118
 [<ffffffff802541db>] lock_release_non_nested+0x81/0x121
 [<ffffffff80254397>] lock_release+0x11c/0x13e
 [<ffffffff804ab5be>] __spin_unlock+0x1b/0x4b
 [<ffffffff8024e9e9>] hrtimer_sched_tick+0x5b/0xac
 [<ffffffff8024ed83>] hrtimer_interrupt+0x113/0x1a8
 [<ffffffff80219f60>] smp_apic_timer_interrupt+0x66/0x82
 [<ffffffff8020ac6b>] apic_timer_interrupt+0x6b/0x70
 [<ffffffff80208857>] default_idle+0x4a/0x7c
 [<ffffffff80208939>] cpu_idle+0xb0/0x109
 [<ffffffff80207049>] rest_init+0x49/0x4b
 [<ffffffff80b927b3>] start_kernel+0x28a/0x28c
 [<ffffffff80b9216f>] _sinittext+0x16f/0x176

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/hrtimer.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN kernel/hrtimer.c~updated-dynticks-core-code-fix-resume-bug kernel/hrtimer.c
--- a/kernel/hrtimer.c~updated-dynticks-core-code-fix-resume-bug
+++ a/kernel/hrtimer.c
@@ -1709,6 +1709,11 @@ static void migrate_hrtimers(int cpu)
 	old_base = &per_cpu(hrtimer_bases, cpu);
 	new_base = &get_cpu_var(hrtimer_bases);
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+	if (old_base->hres_active)
+		hrtimer_cancel(&old_base->sched_timer);
+#endif
+
 	local_irq_disable();
 
 	spin_lock(&new_base->lock);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
optimize-calc_load.patch
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

