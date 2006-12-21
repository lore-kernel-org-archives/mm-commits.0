From: akpm@osdl.org
Subject: + sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code.patch added to -mm tree
Date: Thu, 21 Dec 2006 12:36:21 -0800
Message-ID: <200612212036.kBLKaL9L004194@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38221 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423065AbWLUUgi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:36:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, ak@suse.de, nando@ccrma.Stanford.EDU


The patch titled
     sched: fix bad missed wakeups in the i386, x86_64, ia64, ACPI and APM idle code
has been added to the -mm tree.  Its filename is
     sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: fix bad missed wakeups in the i386, x86_64, ia64, ACPI and APM idle code
From: Ingo Molnar <mingo@elte.hu>

Fernando Lopez-Lezcano reported frequent scheduling latencies and audio
xruns starting at the 2.6.18-rt kernel, and those problems persisted all
until current -rt kernels. The latencies were serious and unjustified by
system load, often in the milliseconds range.

After a patient and heroic multi-month effort of Fernando, where he
tested dozens of kernels, tried various configs, boot options,
test-patches of mine and provided latency traces of those incidents, the
following 'smoking gun' trace was captured by him:

                 _------=> CPU#
                / _-----=> irqs-off
               | / _----=> need-resched
               || / _---=> hardirq/softirq
               ||| / _--=> preempt-depth
               |||| /
               |||||     delay
   cmd     pid ||||| time  |   caller
      \   /    |||||   \   |   /
  IRQ_19-1479  1D..1    0us : __trace_start_sched_wakeup (try_to_wake_up)
  IRQ_19-1479  1D..1    0us : __trace_start_sched_wakeup <<...>-5856> (37 0)
  IRQ_19-1479  1D..1    0us : __trace_start_sched_wakeup (c01262ba 0 0)
  IRQ_19-1479  1D..1    0us : resched_task (try_to_wake_up)
  IRQ_19-1479  1D..1    0us : __spin_unlock_irqrestore (try_to_wake_up)
  ...
  <idle>-0     1...1   11us!: default_idle (cpu_idle)
  ...
  <idle>-0     0Dn.1  602us : smp_apic_timer_interrupt (c0103baf 1 0)
  ...
   <...>-5856  0D..2  618us : __switch_to (__schedule)
   <...>-5856  0D..2  618us : __schedule <<idle>-0> (20 162)
   <...>-5856  0D..2  619us : __spin_unlock_irq (__schedule)
   <...>-5856  0...1  619us : trace_stop_sched_switched (__schedule)
   <...>-5856  0D..1  619us : trace_stop_sched_switched <<...>-5856> (37 0)

what is visible in this trace is that CPU#1 ran try_to_wake_up() for
PID:5856, it placed PID:5856 on CPU#0's runqueue and ran resched_task()
for CPU#0. But it decided to not send an IPI that no CPU - due to
TS_POLLING. But CPU#0 never woke up after its NEED_RESCHED bit was set,
and only rescheduled to PID:5856 upon the next lapic timer IRQ. The
result was a 600+ usecs latency and a missed wakeup!

the bug turned out to be an idle-wakeup bug introduced into the mainline
kernel this summer via an optimization in the x86_64 tree:

    commit 495ab9c045e1b0e5c82951b762257fe1c9d81564
    Author: Andi Kleen <ak@suse.de>
    Date:   Mon Jun 26 13:59:11 2006 +0200

    [PATCH] i386/x86-64/ia64: Move polling flag into thread_info_status

    During some profiling I noticed that default_idle causes a lot of
    memory traffic. I think that is caused by the atomic operations
    to clear/set the polling flag in thread_info. There is actually
    no reason to make this atomic - only the idle thread does it
    to itself, other CPUs only read it. So I moved it into ti->status.

the problem is this type of change:

        if (!hlt_counter && boot_cpu_data.hlt_works_ok) {
-               clear_thread_flag(TIF_POLLING_NRFLAG);
+               current_thread_info()->status &= ~TS_POLLING;
                smp_mb__after_clear_bit();
                while (!need_resched()) {
                        local_irq_disable();

this changes clear_thread_flag() to an explicit clearing of TS_POLLING.
clear_thread_flag() is defined as:

        clear_bit(flag, &ti->flags);

and clear_bit() is a LOCK-ed atomic instruction on all x86 platforms:

  static inline void clear_bit(int nr, volatile unsigned long * addr)
  {
          __asm__ __volatile__( LOCK_PREFIX
                  "btrl %1,%0"

hence smp_mb__after_clear_bit() is defined as a simple compile barrier:

  #define smp_mb__after_clear_bit()       barrier()

but the explicit TS_POLLING clearing introduced by the patch:

+               current_thread_info()->status &= ~TS_POLLING;

is not an atomic op! So the clearing of the TS_POLLING bit is freely
reorderable with the reading of the NEED_RESCHED bit - and both now
reside in different memory addresses.

CPU idle wakeup very much depends on ordered memory ops, the clearing of
the TS_POLLING flag must always be done before we test need_resched()
and hit the idle instruction(s). [Symmetrically, the wakeup code needs
to set NEED_RESCHED before it tests the TS_POLLING flag, so memory
ordering is paramount.]

Fernando's dual-core Athlon64 system has a sufficiently advanced memory
ordering model so that it triggered this scenario very often.

( And it also turned out that the reason why these latencies never
  triggered on my testsystems is that i routinely use idle=poll, which
  was the only idle variant not affected by this bug. )

The fix is to change the smp_mb__after_clear_bit() to an smp_mb(), to
act as an absolute barrier between the TS_POLLING write and the
NEED_RESCHED read. This affects almost all idling methods (default,
ACPI, APM), on all 3 x86 architectures: i386, x86_64, ia64.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/apm.c        |    6 +++++-
 arch/i386/kernel/process.c    |    7 ++++++-
 arch/ia64/kernel/process.c    |   10 ++++++++--
 arch/x86_64/kernel/process.c  |    6 +++++-
 drivers/acpi/processor_idle.c |   12 ++++++++++--
 5 files changed, 34 insertions(+), 7 deletions(-)

diff -puN arch/i386/kernel/apm.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code
+++ a/arch/i386/kernel/apm.c
@@ -785,7 +785,11 @@ static int apm_do_idle(void)
 	polling = !!(current_thread_info()->status & TS_POLLING);
 	if (polling) {
 		current_thread_info()->status &= ~TS_POLLING;
-		smp_mb__after_clear_bit();
+		/*
+		 * TS_POLLING-cleared state must be visible before we
+		 * test NEED_RESCHED:
+		 */
+		smp_mb();
 	}
 	if (!need_resched()) {
 		idled = 1;
diff -puN arch/i386/kernel/process.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code
+++ a/arch/i386/kernel/process.c
@@ -102,7 +102,12 @@ void default_idle(void)
 {
 	if (!hlt_counter && boot_cpu_data.hlt_works_ok) {
 		current_thread_info()->status &= ~TS_POLLING;
-		smp_mb__after_clear_bit();
+		/*
+		 * TS_POLLING-cleared state must be visible before we
+		 * test NEED_RESCHED:
+		 */
+		smp_mb();
+
 		local_irq_disable();
 		if (!need_resched())
 			safe_halt();	/* enables interrupts racelessly */
diff -puN arch/ia64/kernel/process.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code
+++ a/arch/ia64/kernel/process.c
@@ -268,10 +268,16 @@ cpu_idle (void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		if (can_do_pal_halt)
+		if (can_do_pal_halt) {
 			current_thread_info()->status &= ~TS_POLLING;
-		else
+			/*
+			 * TS_POLLING-cleared state must be visible before we
+			 * test NEED_RESCHED:
+			 */
+			smp_mb();
+		} else {
 			current_thread_info()->status |= TS_POLLING;
+		}
 
 		if (!need_resched()) {
 			void (*idle)(void);
diff -puN arch/x86_64/kernel/process.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code
+++ a/arch/x86_64/kernel/process.c
@@ -109,7 +109,11 @@ void exit_idle(void)
 static void default_idle(void)
 {
 	current_thread_info()->status &= ~TS_POLLING;
-	smp_mb__after_clear_bit();
+	/*
+	 * TS_POLLING-cleared state must be visible before we
+	 * test NEED_RESCHED:
+	 */
+	smp_mb();
 	local_irq_disable();
 	if (!need_resched()) {
 		/* Enables interrupts one instruction before HLT.
diff -puN drivers/acpi/processor_idle.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code
+++ a/drivers/acpi/processor_idle.c
@@ -211,7 +211,11 @@ acpi_processor_power_activate(struct acp
 static void acpi_safe_halt(void)
 {
 	current_thread_info()->status &= ~TS_POLLING;
-	smp_mb__after_clear_bit();
+	/*
+	 * TS_POLLING-cleared state must be visible before we
+	 * test NEED_RESCHED:
+	 */
+	smp_mb();
 	if (!need_resched())
 		safe_halt();
 	current_thread_info()->status |= TS_POLLING;
@@ -345,7 +349,11 @@ static void acpi_processor_idle(void)
 	 */
 	if (cx->type == ACPI_STATE_C2 || cx->type == ACPI_STATE_C3) {
 		current_thread_info()->status &= ~TS_POLLING;
-		smp_mb__after_clear_bit();
+		/*
+		 * TS_POLLING-cleared state must be visible before we
+		 * test NEED_RESCHED:
+		 */
+		smp_mb();
 		if (need_resched()) {
 			current_thread_info()->status |= TS_POLLING;
 			local_irq_enable();
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
conditionally-check-expected_preempt_count-in-__resched_legal.patch
sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch
genirq-fix-irq-flow-handler-uninstall.patch
lock-debugging-fix-debug_locks_warn_on-debug_locks_silent.patch
sched-fix-bad-missed-wakeups-in-the-i386-x86_64-ia64-acpi-and-apm-idle-code.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
schedule_on_each_cpu-use-preempt_disable.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
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
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
debugging-feature-proc-timer_list.patch
debugging-feature-sysrq-q-to-print-timers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
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

