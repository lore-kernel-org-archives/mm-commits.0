From: akpm@linux-foundation.org
Subject: - setup_boot_apic_clock-irq-enable-fix.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:21 -0800
Message-ID: <200703260105.l2Q15LCx008707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933339AbXCZBFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, michal.k.k.piotrowski@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     setup_boot_APIC_clock() irq-enable fix
has been removed from the -mm tree.  Its filename was
     setup_boot_apic_clock-irq-enable-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: setup_boot_APIC_clock() irq-enable fix
From: Ingo Molnar <mingo@elte.hu>

latest -git triggers an irqtrace/lockdep warning of a leaked irqs-off
condition:

  BUG: at kernel/fork.c:1033 copy_process()

after some debugging it turns out that commit ca1b940c accidentally left
interrupts disabled - which trickled down all the way to the first time we
fork a kernel thread and triggered the warning.

the fix is to re-enable interrupts in the 'else' branch of
setup_boot_APIC_clock()'s pmtimers calibration path.

Reported-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/apic.c~setup_boot_apic_clock-irq-enable-fix arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~setup_boot_apic_clock-irq-enable-fix
+++ a/arch/i386/kernel/apic.c
@@ -506,7 +506,8 @@ void __init setup_boot_APIC_clock(void)
 			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
 		else
 			local_apic_timer_verify_ok = 0;
-	}
+	} else
+		local_irq_enable();
 
 	if (!local_apic_timer_verify_ok) {
 		printk(KERN_WARNING
_

Patches currently in -mm which might be from mingo@elte.hu are

correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
ntp-avoid-time_offset-overflows-fix.patch
git-ieee1394.patch
git-kvm.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
log-reason-why-tsc-was-marked-unstable.patch
allow-per-cpu-variables-to-be-page-aligned.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
fix-bogus-softlockup-warning-with-sysrq-t.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
aio-is-unlikely.patch
sched-accurate-user-accounting.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
lists-add-list-splice-tail.patch
sched-remove-sleepavg-from-proc.patch
sched-remove-noninteractive-flag.patch
sched-implement-rsdl-cpu-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
sched-rsdl-improvements.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
mm-only-hrtimers-debug-patch.patch
