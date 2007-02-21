From: akpm@linux-foundation.org
Subject: + kvm-add-host-hypercall-support-for-vmx.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:43 -0800
Message-ID: <200702212049.l1LKnhI4025473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44157 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161354AbXBUUuA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:50:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, avi@qumranet.com


The patch titled
     KVM: Add host hypercall support for vmx
has been added to the -mm tree.  Its filename is
     kvm-add-host-hypercall-support-for-vmx.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Add host hypercall support for vmx
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/vmx.c        |   15 +++++++++++++++
 include/linux/kvm_para.h |   18 ++++++++++++++++++
 2 files changed, 33 insertions(+)

diff -puN drivers/kvm/vmx.c~kvm-add-host-hypercall-support-for-vmx drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-host-hypercall-support-for-vmx
+++ a/drivers/kvm/vmx.c
@@ -1657,6 +1657,20 @@ static int handle_halt(struct kvm_vcpu *
 	return 0;
 }
 
+static int handle_vmcall(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->exit_reason = KVM_EXIT_DEBUG;
+	printk(KERN_DEBUG "got vmcall at RIP %08lx\n", vmcs_readl(GUEST_RIP));
+	printk(KERN_DEBUG "vmcall params: %08lx, %08lx, %08lx, %08lx\n",
+		vcpu->regs[VCPU_REGS_RAX],
+		vcpu->regs[VCPU_REGS_RCX],
+		vcpu->regs[VCPU_REGS_RDX],
+		vcpu->regs[VCPU_REGS_RBP]);
+	vcpu->regs[VCPU_REGS_RAX] = 0;
+	vmcs_writel(GUEST_RIP, vmcs_readl(GUEST_RIP)+3);
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -1675,6 +1689,7 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_MSR_WRITE]               = handle_wrmsr,
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = handle_halt,
+	[EXIT_REASON_VMCALL]                  = handle_vmcall,
 };
 
 static const int kvm_vmx_max_exit_handlers =
diff -puN include/linux/kvm_para.h~kvm-add-host-hypercall-support-for-vmx include/linux/kvm_para.h
--- a/include/linux/kvm_para.h~kvm-add-host-hypercall-support-for-vmx
+++ a/include/linux/kvm_para.h
@@ -52,4 +52,22 @@ struct kvm_vcpu_para_state {
 
 #define KVM_EINVAL 1
 
+/*
+ * Hypercall calling convention:
+ *
+ * Each hypercall may have 0-6 parameters.
+ *
+ * 64-bit hypercall index is in RAX, goes from 0 to __NR_hypercalls-1
+ *
+ * 64-bit parameters 1-6 are in the standard gcc x86_64 calling convention
+ * order: RDI, RSI, RDX, RCX, R8, R9.
+ *
+ * 32-bit index is EBX, parameters are: EAX, ECX, EDX, ESI, EDI, EBP.
+ * (the first 3 are according to the gcc regparm calling convention)
+ *
+ * No registers are clobbered by the hypercall, except that the
+ * return value is in RAX.
+ */
+#define __NR_hypercalls			0
+
 #endif
_

Patches currently in -mm which might be from mingo@elte.hu are

x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
kvm-add-msr-based-hypercall-api.patch
kvm-add-host-hypercall-support-for-vmx.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v2.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
