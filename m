From: akpm@osdl.org
Subject: - dynticks-uninline-irq_enter.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:11:48 -0800
Message-ID: <200701250611.l0P6Bm9L007718@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49058 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965371AbXAYGL6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:11:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     dynticks: uninline irq_enter()
has been removed from the -mm tree.  Its filename was
     dynticks-uninline-irq_enter.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: dynticks: uninline irq_enter()
From: Ingo Molnar <mingo@elte.hu>

Uninline irq_enter().  [dynticks adds more stuff to it]

No functional changes.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hardirq.h |    7 +------
 kernel/softirq.c        |   10 ++++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN include/linux/hardirq.h~dynticks-uninline-irq_enter include/linux/hardirq.h
--- a/include/linux/hardirq.h~dynticks-uninline-irq_enter
+++ a/include/linux/hardirq.h
@@ -106,12 +106,7 @@ static inline void account_system_vtime(
  * always balanced, so the interrupted value of ->hardirq_context
  * will always be restored.
  */
-#define irq_enter()					\
-	do {						\
-		account_system_vtime(current);		\
-		add_preempt_count(HARDIRQ_OFFSET);	\
-		trace_hardirq_enter();			\
-	} while (0)
+extern void irq_enter(void);
 
 /*
  * Exit irq context without processing softirqs:
diff -puN kernel/softirq.c~dynticks-uninline-irq_enter kernel/softirq.c
--- a/kernel/softirq.c~dynticks-uninline-irq_enter
+++ a/kernel/softirq.c
@@ -273,6 +273,16 @@ EXPORT_SYMBOL(do_softirq);
 
 #endif
 
+/*
+ * Enter an interrupt context.
+ */
+void irq_enter(void)
+{
+	account_system_vtime(current);
+	add_preempt_count(HARDIRQ_OFFSET);
+	trace_hardirq_enter();
+}
+
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 # define invoke_softirq()	__do_softirq()
 #else
_

Patches currently in -mm which might be from mingo@elte.hu are

kvm-add-vm-exit-profiling-fix.patch
revert-nmi_known_cpu-check-during-boot-option-parsing.patch
paravirt-mark-the-paravirt_ops-export-internal.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
acpi-fix-cpufreq-regression.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
fix-for-crash-in-adummy_init.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
audit-fix-audit_filter_user_rules-initialization-bug.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
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
clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
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
debugging-feature-proc-timer_list-warning-fix.patch
debugging-feature-sysrq-q-to-print-timers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
sched-avoid-div-in-rebalance_tick.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
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
