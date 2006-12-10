From: akpm@osdl.org
Subject: - kvm-amd-svm-implementation-more-i386-fixes.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:58 -0800
Message-ID: <200612100755.kBA7twYB017915@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760588AbWLJH4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:56:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: More i386 fixes
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-implementation-more-i386-fixes.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: More i386 fixes
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |    2 +-
 drivers/kvm/mmu.c      |    6 +++---
 drivers/kvm/svm.c      |   18 ++++++++++--------
 drivers/kvm/vmx.c      |    2 +-
 5 files changed, 16 insertions(+), 14 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-amd-svm-implementation-more-i386-fixes drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-amd-svm-implementation-more-i386-fixes
+++ a/drivers/kvm/kvm.h
@@ -299,7 +299,7 @@ struct kvm_arch_ops {
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t addr);
-	void (*flush_tlb)(struct kvm_vcpu *vcpu);
+	void (*tlb_flush)(struct kvm_vcpu *vcpu);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  unsigned long addr, u32 err_code);
 
diff -puN drivers/kvm/kvm_main.c~kvm-amd-svm-implementation-more-i386-fixes drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-amd-svm-implementation-more-i386-fixes
+++ a/drivers/kvm/kvm_main.c
@@ -737,7 +737,7 @@ static int kvm_dev_ioctl_get_dirty_log(s
 
 			if (!vcpu)
 				continue;
-			kvm_arch_ops->flush_tlb(vcpu);
+			kvm_arch_ops->tlb_flush(vcpu);
 			vcpu_put(vcpu);
 		}
 	}
diff -puN drivers/kvm/mmu.c~kvm-amd-svm-implementation-more-i386-fixes drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-amd-svm-implementation-more-i386-fixes
+++ a/drivers/kvm/mmu.c
@@ -324,7 +324,7 @@ static void nonpaging_flush(struct kvm_v
 	if (is_paging(vcpu))
 		root |= (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK));
 	kvm_arch_ops->set_cr3(vcpu, root);
-	kvm_arch_ops->flush_tlb(vcpu);
+	kvm_arch_ops->tlb_flush(vcpu);
 }
 
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr)
@@ -408,7 +408,7 @@ static void kvm_mmu_flush_tlb(struct kvm
 		release_pt_page_64(vcpu, page->page_hpa, 1);
 	}
 	++kvm_stat.tlb_flush;
-	kvm_arch_ops->flush_tlb(vcpu);
+	kvm_arch_ops->tlb_flush(vcpu);
 }
 
 static void paging_new_cr3(struct kvm_vcpu *vcpu)
@@ -516,7 +516,7 @@ static void paging_inval_page(struct kvm
 			table[index] = 0;
 			release_pt_page_64(vcpu, page_addr, PT_PAGE_TABLE_LEVEL);
 
-			kvm_arch_ops->flush_tlb(vcpu);
+			kvm_arch_ops->tlb_flush(vcpu);
 			return;
 		}
 	}
diff -puN drivers/kvm/svm.c~kvm-amd-svm-implementation-more-i386-fixes drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-amd-svm-implementation-more-i386-fixes
+++ a/drivers/kvm/svm.c
@@ -115,7 +115,7 @@ static inline void invlpga(unsigned long
 	asm volatile (SVM_INVLPGA :: "a"(addr), "c"(asid));
 }
 
-static inline unsigned long read_cr2(void)
+static inline unsigned long kvm_read_cr2(void)
 {
 	unsigned long cr2;
 
@@ -123,7 +123,7 @@ static inline unsigned long read_cr2(voi
 	return cr2;
 }
 
-static inline void write_cr2(unsigned long val)
+static inline void kvm_write_cr2(unsigned long val)
 {
 	asm volatile ("mov %0, %%cr2" :: "r" (val));
 }
@@ -1129,9 +1129,11 @@ static int rdmsr_interception(struct kvm
 static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 {
 	switch (ecx) {
+#ifdef __x86_64__
 	case MSR_EFER:
 		set_efer(vcpu, data);
 		break;
+#endif
 	case MSR_IA32_MC0_STATUS:
 		printk(KERN_WARNING "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n"
 			    , __FUNCTION__, data);
@@ -1367,7 +1369,7 @@ again:
 	fs_selector = read_fs();
 	gs_selector = read_gs();
 	ldt_selector = read_ldt();
-	vcpu->svm->host_cr2 = read_cr2();
+	vcpu->svm->host_cr2 = kvm_read_cr2();
 	vcpu->svm->host_dr6 = read_dr6();
 	vcpu->svm->host_dr7 = read_dr7();
 	vcpu->svm->vmcb->save.cr2 = vcpu->cr2;
@@ -1384,7 +1386,7 @@ again:
 		"push %%r8;  push %%r9;  push %%r10; push %%r11;"
 		"push %%r12; push %%r13; push %%r14; push %%r15;"
 #else
-		"push %%ebx; push %%rcx push %%edx;"
+		"push %%ebx; push %%ecx; push %%edx;"
 		"push %%esi; push %%edi; push %%ebp;"
 #endif
 
@@ -1462,9 +1464,9 @@ again:
 		  [rdx]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDX])),
 		  [rsi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RSI])),
 		  [rdi]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RDI])),
-		  [rbp]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBP])),
+		  [rbp]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RBP]))
 #ifdef __x86_64__
-		  [r8 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R8 ])),
+		  ,[r8 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R8 ])),
 		  [r9 ]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R9 ])),
 		  [r10]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R10])),
 		  [r11]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_R11])),
@@ -1482,7 +1484,7 @@ again:
 
 	write_dr6(vcpu->svm->host_dr6);
 	write_dr7(vcpu->svm->host_dr7);
-	write_cr2(vcpu->svm->host_cr2);
+	kvm_write_cr2(vcpu->svm->host_cr2);
 
 	load_fs(fs_selector);
 	load_gs(gs_selector);
@@ -1596,7 +1598,7 @@ static struct kvm_arch_ops svm_arch_ops 
 	.set_rflags = svm_set_rflags,
 
 	.invlpg = svm_invlpg,
-	.flush_tlb = svm_flush_tlb,
+	.tlb_flush = svm_flush_tlb,
 	.inject_page_fault = svm_inject_page_fault,
 
 	.inject_gp = svm_inject_gp,
diff -puN drivers/kvm/vmx.c~kvm-amd-svm-implementation-more-i386-fixes drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-amd-svm-implementation-more-i386-fixes
+++ a/drivers/kvm/vmx.c
@@ -1974,7 +1974,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.get_rflags = vmx_get_rflags,
 	.set_rflags = vmx_set_rflags,
 
-	.flush_tlb = vmx_flush_tlb,
+	.tlb_flush = vmx_flush_tlb,
 	.inject_page_fault = vmx_inject_page_fault,
 
 	.inject_gp = vmx_inject_gp,
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
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
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
schedc-correct-comment-for-this_rq_lock-routine.patch
sched-fix-migration-cost-estimator.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch
sched-domain-increase-the-smt-busy-rebalance-interval.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-decrease-number-of-load-balances.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
kernel-schedc-whitespace-cleanups.patch
kernel-schedc-whitespace-cleanups-more.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-add-a-framework-to-manage-clock-event-devices-next_event-calculation-fix.patch
updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dynticks-core-code-fix-resume-bug.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
round_jiffies-infrastructure.patch
round_jiffies-infrastructure-fix.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
kvm-userspace-interface.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
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

