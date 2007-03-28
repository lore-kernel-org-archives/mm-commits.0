From: akpm@linux-foundation.org
Subject: - x86_64-do-not-enable-the-nmi-watchdog-by-default.patch removed from -mm tree
Date: Wed, 28 Mar 2007 12:57:45 -0700
Message-ID: <200703281957.l2SJvkm4018788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965735AbXC1T6E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 15:58:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     x86_64: do not enable the NMI watchdog by default
has been removed from the -mm tree.  Its filename was
     x86_64-do-not-enable-the-nmi-watchdog-by-default.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64: do not enable the NMI watchdog by default
From: Ingo Molnar <mingo@elte.hu>

Do not enable the NMI watchdog by default.  Now that we have lockdep i
cannot remember the last time it caught a real bug, but the NMI watchdog
can /cause/ problems.  Furthermore, to the typical user, an NMI watchdog
assert results in a total lockup anyway (if under X).  In that sense, all
that the NMI watchdog does is that it makes the system /less/ stable and
/less/ debuggable.

People can still enable it either after bootup via:

   echo 1 > /proc/sys/kernel/nmi

or via the nmi_watchdog=1 or nmi_watchdog=2 boot options.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/apic.c    |    1 -
 arch/x86_64/kernel/io_apic.c |    5 +----
 arch/x86_64/kernel/nmi.c     |    2 +-
 arch/x86_64/kernel/smpboot.c |    1 -
 include/asm-x86_64/nmi.h     |    1 -
 5 files changed, 2 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-do-not-enable-the-nmi-watchdog-by-default arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/arch/x86_64/kernel/apic.c
@@ -432,7 +432,6 @@ void __cpuinit setup_local_APIC (void)
 			oldvalue, value);
 	}
 
-	nmi_watchdog_default();
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
 }
diff -puN arch/x86_64/kernel/io_apic.c~x86_64-do-not-enable-the-nmi-watchdog-by-default arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1657,7 +1657,6 @@ static inline void check_timer(void)
 		 */
 		unmask_IO_APIC_irq(0);
 		if (!no_timer_check && timer_irq_works()) {
-			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
 				disable_8259A_irq(0);
 				setup_nmi();
@@ -1683,10 +1682,8 @@ static inline void check_timer(void)
 		setup_ExtINT_IRQ0_pin(apic2, pin2, cfg->vector);
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
-			nmi_watchdog_default();
-			if (nmi_watchdog == NMI_IO_APIC) {
+			if (nmi_watchdog == NMI_IO_APIC)
 				setup_nmi();
-			}
 			return;
 		}
 		/*
diff -puN arch/x86_64/kernel/nmi.c~x86_64-do-not-enable-the-nmi-watchdog-by-default arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/arch/x86_64/kernel/nmi.c
@@ -183,7 +183,7 @@ static __cpuinit inline int nmi_known_cp
 }
 
 /* Run after command line and cpu_init init, but before all other checks */
-void nmi_watchdog_default(void)
+static inline void nmi_watchdog_default(void)
 {
 	if (nmi_watchdog != NMI_DEFAULT)
 		return;
diff -puN arch/x86_64/kernel/smpboot.c~x86_64-do-not-enable-the-nmi-watchdog-by-default arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/arch/x86_64/kernel/smpboot.c
@@ -868,7 +868,6 @@ static int __init smp_sanity_check(unsig
  */
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	nmi_watchdog_default();
 	current_cpu_data = boot_cpu_data;
 	current_thread_info()->cpu = 0;  /* needed? */
 	set_cpu_sibling_map(0);
diff -puN include/asm-x86_64/nmi.h~x86_64-do-not-enable-the-nmi-watchdog-by-default include/asm-x86_64/nmi.h
--- a/include/asm-x86_64/nmi.h~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/include/asm-x86_64/nmi.h
@@ -59,7 +59,6 @@ extern void disable_timer_nmi_watchdog(v
 extern void enable_timer_nmi_watchdog(void);
 extern int nmi_watchdog_tick (struct pt_regs * regs, unsigned reason);
 
-extern void nmi_watchdog_default(void);
 extern int setup_nmi_watchdog(char *);
 
 extern atomic_t nmi_active;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
i386-fix-bogus-return-value-in-hpet_next_event.patch
hrtimers-fix-reprogramming-smp-race.patch
git-ieee1394.patch
git-kvm.patch
forcedeth-work-around-null-skb-dereference-crash.patch
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
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
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
mm-only-hrtimers-debug-patch.patch
mm-only-hrtimers-debug-patch-fix.patch
