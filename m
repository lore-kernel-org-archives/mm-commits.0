From: akpm@osdl.org
Subject: - kvm-add-vm-exit-profiling.patch removed from -mm tree
Date: Fri, 12 Jan 2007 14:18:00 -0800
Message-ID: <200701122218.l0CMI0gE030766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39115 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161148AbXALWSt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:18:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: add VM-exit profiling
has been removed from the -mm tree.  Its filename was
     kvm-add-vm-exit-profiling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: add VM-exit profiling
From: Ingo Molnar <mingo@elte.hu>

This adds the profile=kvm boot option, which enables KVM to profile VM
exits.

Use: "readprofile -m ./System.map | sort -n" to see the resulting
output:

   [...]
   18246 serial_out                               148.3415
   18945 native_flush_tlb                         378.9000
   23618 serial_in                                212.7748
   29279 __spin_unlock_irq                        622.9574
   43447 native_apic_write                        2068.9048
   52702 enable_8259A_irq                         742.2817
   54250 vgacon_scroll                             89.3740
   67394 ide_inb                                  6126.7273
   79514 copy_page_range                           98.1654
   84868 do_wp_page                                86.6000
  140266 pit_read                                 783.6089
  151436 ide_outb                                 25239.3333
  152668 native_io_delay                          21809.7143
  174783 mask_and_ack_8259A                       783.7803
  362404 native_set_pte_at                        36240.4000
 1688747 total                                      0.5009

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c       |    8 ++++++++
 drivers/kvm/vmx.c       |    7 +++++++
 include/linux/profile.h |    1 +
 kernel/profile.c        |   14 ++++++++++++++
 4 files changed, 30 insertions(+)

diff -puN drivers/kvm/svm.c~kvm-add-vm-exit-profiling drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-add-vm-exit-profiling
+++ a/drivers/kvm/svm.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
+#include <linux/profile.h>
 #include <asm/desc.h>
 
 #include "kvm_svm.h"
@@ -1558,6 +1559,13 @@ again:
 
 	reload_tss(vcpu);
 
+	/*
+	 * Profile KVM exit RIPs:
+	 */
+	if (unlikely(prof_on == KVM_PROFILING))
+		profile_hit(KVM_PROFILING,
+			(void *)(unsigned long)vcpu->svm->vmcb->save.rip);
+
 	stgi();
 
 	kvm_reput_irq(vcpu);
diff -puN drivers/kvm/vmx.c~kvm-add-vm-exit-profiling drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-vm-exit-profiling
+++ a/drivers/kvm/vmx.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/profile.h>
 #include <asm/io.h>
 #include <asm/desc.h>
 
@@ -1859,6 +1860,12 @@ again:
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 #endif
 
+	/*
+	 * Profile KVM exit RIPs:
+	 */
+	if (unlikely(prof_on == KVM_PROFILING))
+		profile_hit(KVM_PROFILING, (void *)vmcs_readl(GUEST_RIP));
+
 	kvm_run->exit_type = 0;
 	if (fail) {
 		kvm_run->exit_type = KVM_EXIT_TYPE_FAIL_ENTRY;
diff -puN include/linux/profile.h~kvm-add-vm-exit-profiling include/linux/profile.h
--- a/include/linux/profile.h~kvm-add-vm-exit-profiling
+++ a/include/linux/profile.h
@@ -15,6 +15,7 @@ extern int prof_on __read_mostly;
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
 #define SLEEP_PROFILING	3
+#define KVM_PROFILING	4
 
 struct proc_dir_entry;
 struct pt_regs;
diff -puN kernel/profile.c~kvm-add-vm-exit-profiling kernel/profile.c
--- a/kernel/profile.c~kvm-add-vm-exit-profiling
+++ a/kernel/profile.c
@@ -40,7 +40,10 @@ int (*timer_hook)(struct pt_regs *) __re
 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
+
 int prof_on __read_mostly;
+EXPORT_SYMBOL_GPL(prof_on);
+
 static cpumask_t prof_cpu_mask = CPU_MASK_ALL;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct profile_hit *[2], cpu_profile_hits);
@@ -52,6 +55,7 @@ static int __init profile_setup(char * s
 {
 	static char __initdata schedstr[] = "schedule";
 	static char __initdata sleepstr[] = "sleep";
+	static char __initdata kvmstr[] = "kvm";
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
@@ -72,6 +76,15 @@ static int __init profile_setup(char * s
 		printk(KERN_INFO
 			"kernel schedule profiling enabled (shift: %ld)\n",
 			prof_shift);
+	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
+		prof_on = KVM_PROFILING;
+		if (str[strlen(kvmstr)] == ',')
+			str += strlen(kvmstr) + 1;
+		if (get_option(&str, &par))
+			prof_shift = par;
+		printk(KERN_INFO
+			"kernel KVM profiling enabled (shift: %ld)\n",
+			prof_shift);
 	} else if (get_option(&str, &par)) {
 		prof_shift = par;
 		prof_on = CPU_PROFILING;
@@ -318,6 +331,7 @@ out:
 	local_irq_restore(flags);
 	put_cpu();
 }
+EXPORT_SYMBOL_GPL(profile_hits);
 
 static int __devinit profile_cpu_callback(struct notifier_block *info,
 					unsigned long action, void *__cpu)
_

Patches currently in -mm which might be from mingo@elte.hu are

kvm-add-vm-exit-profiling-fix.patch
revert-nmi_known_cpu-check-during-boot-option-parsing.patch
paravirt-mark-the-paravirt_ops-export-internal.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-asm-constraints-with-config_frame_pointer=n.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
fix-for-crash-in-adummy_init.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
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
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
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
