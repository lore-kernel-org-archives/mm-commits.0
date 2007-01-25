From: akpm@osdl.org
Subject: - debugging-feature-sysrq-q-to-print-timers.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:13:06 -0800
Message-ID: <200701250613.l0P6D6gv007876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49222 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965510AbXAYGNO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     debugging feature: SysRq-Q to print timers
has been removed from the -mm tree.  Its filename was
     debugging-feature-sysrq-q-to-print-timers.patch

This patch was dropped because an updated version will be merged

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
@@ -336,7 +348,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	/* o: This will often be registered as 'Off' at init time */
 	NULL,				/* o */
 	&sysrq_showregs_op,		/* p */
-	NULL,				/* q */
+	&sysrq_show_timers_op,		/* q */
 	&sysrq_unraw_op,		/* r */
 	&sysrq_sync_op,			/* s */
 	&sysrq_showstate_op,		/* t */
diff -puN include/linux/hrtimer.h~debugging-feature-sysrq-q-to-print-timers include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~debugging-feature-sysrq-q-to-print-timers
+++ a/include/linux/hrtimer.h
@@ -353,6 +353,9 @@ static inline void show_no_hz_stats(stru
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
