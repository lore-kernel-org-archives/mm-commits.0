From: akpm@linux-foundation.org
Subject: + kvm-add-msr-based-hypercall-api.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:41 -0800
Message-ID: <200702212049.l1LKnfwr025469@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161352AbXBUUt7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:49:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, avi@qumranet.com


The patch titled
     KVM: add MSR based hypercall API
has been added to the -mm tree.  Its filename is
     kvm-add-msr-based-hypercall-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: add MSR based hypercall API
From: Ingo Molnar <mingo@elte.hu>

This adds a special MSR based hypercall API to KVM.  This is to be used by
paravirtual kernels and virtual drivers.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm.h        |    6 +++
 drivers/kvm/kvm_main.c   |   73 +++++++++++++++++++++++++++++++++++++
 drivers/kvm/svm.c        |   13 ++++++
 drivers/kvm/vmx.c        |   13 ++++++
 include/linux/kvm_para.h |   55 +++++++++++++++++++++++++++
 5 files changed, 160 insertions(+)

diff -puN drivers/kvm/kvm.h~kvm-add-msr-based-hypercall-api drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-add-msr-based-hypercall-api
+++ a/drivers/kvm/kvm.h
@@ -14,6 +14,7 @@
 
 #include "vmx.h"
 #include <linux/kvm.h>
+#include <linux/kvm_para.h>
 
 #define CR0_PE_MASK (1ULL << 0)
 #define CR0_TS_MASK (1ULL << 3)
@@ -237,6 +238,9 @@ struct kvm_vcpu {
 	unsigned long cr0;
 	unsigned long cr2;
 	unsigned long cr3;
+	gpa_t para_state_gpa;
+	struct page *para_state_page;
+	gpa_t hypercall_gpa;
 	unsigned long cr4;
 	unsigned long cr8;
 	u64 pdptrs[4]; /* pae */
@@ -382,6 +386,8 @@ struct kvm_arch_ops {
 	int (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*vcpu_setup)(struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
+				unsigned char *hypercall_addr);
 };
 
 extern struct kvm_stat kvm_stat;
diff -puN drivers/kvm/kvm_main.c~kvm-add-msr-based-hypercall-api drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-msr-based-hypercall-api
+++ a/drivers/kvm/kvm_main.c
@@ -1204,6 +1204,73 @@ void realmode_set_cr(struct kvm_vcpu *vc
 	}
 }
 
+/*
+ * Register the para guest with the host:
+ */
+static int vcpu_register_para(struct kvm_vcpu *vcpu, gpa_t para_state_gpa)
+{
+	struct kvm_vcpu_para_state *para_state;
+	hpa_t para_state_hpa, hypercall_hpa;
+	struct page *para_state_page;
+	unsigned char *hypercall;
+	gpa_t hypercall_gpa;
+
+	printk(KERN_DEBUG "kvm: guest trying to enter paravirtual mode\n");
+	printk(KERN_DEBUG ".... para_state_gpa: %08Lx\n", para_state_gpa);
+
+	/*
+	 * Needs to be page aligned:
+	 */
+	if (para_state_gpa != PAGE_ALIGN(para_state_gpa))
+		goto err_gp;
+
+	para_state_hpa = gpa_to_hpa(vcpu, para_state_gpa);
+	printk(KERN_DEBUG ".... para_state_hpa: %08Lx\n", para_state_hpa);
+	if (is_error_hpa(para_state_hpa))
+		goto err_gp;
+
+	para_state_page = pfn_to_page(para_state_hpa >> PAGE_SHIFT);
+	para_state = kmap_atomic(para_state_page, KM_USER0);
+
+	printk(KERN_DEBUG "....  guest version: %d\n", para_state->guest_version);
+	printk(KERN_DEBUG "....           size: %d\n", para_state->size);
+
+	para_state->host_version = KVM_PARA_API_VERSION;
+	/*
+	 * We cannot support guests that try to register themselves
+	 * with a newer API version than the host supports:
+	 */
+	if (para_state->guest_version > KVM_PARA_API_VERSION) {
+		para_state->ret = -KVM_EINVAL;
+		goto err_kunmap_skip;
+	}
+
+	hypercall_gpa = para_state->hypercall_gpa;
+	hypercall_hpa = gpa_to_hpa(vcpu, hypercall_gpa);
+	printk(KERN_DEBUG ".... hypercall_hpa: %08Lx\n", hypercall_hpa);
+	if (is_error_hpa(hypercall_hpa)) {
+		para_state->ret = -KVM_EINVAL;
+		goto err_kunmap_skip;
+	}
+
+	printk(KERN_DEBUG "kvm: para guest successfully registered.\n");
+	vcpu->para_state_page = para_state_page;
+	vcpu->para_state_gpa = para_state_gpa;
+	vcpu->hypercall_gpa = hypercall_gpa;
+
+	hypercall = kmap_atomic(pfn_to_page(hypercall_hpa >> PAGE_SHIFT),
+				KM_USER1) + (hypercall_hpa & ~PAGE_MASK);
+	kvm_arch_ops->patch_hypercall(vcpu, hypercall);
+	kunmap_atomic(hypercall, KM_USER1);
+
+	para_state->ret = 0;
+err_kunmap_skip:
+	kunmap_atomic(para_state, KM_USER0);
+	return 0;
+err_gp:
+	return 1;
+}
+
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 {
 	u64 data;
@@ -1312,6 +1379,12 @@ int kvm_set_msr_common(struct kvm_vcpu *
 	case MSR_IA32_MISC_ENABLE:
 		vcpu->ia32_misc_enable_msr = data;
 		break;
+	/*
+	 * This is the 'probe whether the host is KVM' logic:
+	 */
+	case MSR_KVM_API_MAGIC:
+		return vcpu_register_para(vcpu, data);
+
 	default:
 		printk(KERN_ERR "kvm: unhandled wrmsr: 0x%x\n", msr);
 		return 1;
diff -puN drivers/kvm/svm.c~kvm-add-msr-based-hypercall-api drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-add-msr-based-hypercall-api
+++ a/drivers/kvm/svm.c
@@ -1669,6 +1669,18 @@ static int is_disabled(void)
 	return 0;
 }
 
+static void
+svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
+{
+	/*
+	 * Patch in the VMMCALL instruction:
+	 */
+	hypercall[0] = 0x0f;
+	hypercall[1] = 0x01;
+	hypercall[2] = 0xd9;
+	hypercall[3] = 0xc3;
+}
+
 static struct kvm_arch_ops svm_arch_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -1717,6 +1729,7 @@ static struct kvm_arch_ops svm_arch_ops 
 	.run = svm_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.vcpu_setup = svm_vcpu_setup,
+	.patch_hypercall = svm_patch_hypercall,
 };
 
 static int __init svm_init(void)
diff -puN drivers/kvm/vmx.c~kvm-add-msr-based-hypercall-api drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-msr-based-hypercall-api
+++ a/drivers/kvm/vmx.c
@@ -1469,6 +1469,18 @@ static int handle_io(struct kvm_vcpu *vc
 	return 0;
 }
 
+static void
+vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
+{
+	/*
+	 * Patch in the VMCALL instruction:
+	 */
+	hypercall[0] = 0x0f;
+	hypercall[1] = 0x01;
+	hypercall[2] = 0xc1;
+	hypercall[3] = 0xc3;
+}
+
 static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u64 exit_qualification;
@@ -2064,6 +2076,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.run = vmx_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.vcpu_setup = vmx_vcpu_setup,
+	.patch_hypercall = vmx_patch_hypercall,
 };
 
 static int __init vmx_init(void)
diff -puN /dev/null include/linux/kvm_para.h
--- /dev/null
+++ a/include/linux/kvm_para.h
@@ -0,0 +1,55 @@
+#ifndef __LINUX_KVM_PARA_H
+#define __LINUX_KVM_PARA_H
+
+/*
+ * Guest OS interface for KVM paravirtualization
+ *
+ * Note: this interface is totally experimental, and is certain to change
+ *       as we make progress.
+ */
+
+/*
+ * Per-VCPU descriptor area shared between guest and host. Writable to
+ * both guest and host. Registered with the host by the guest when
+ * a guest acknowledges paravirtual mode.
+ *
+ * NOTE: all addresses are guest-physical addresses (gpa), to make it
+ * easier for the hypervisor to map between the various addresses.
+ */
+struct kvm_vcpu_para_state {
+	/*
+	 * API version information for compatibility. If there's any support
+	 * mismatch (too old host trying to execute too new guest) then
+	 * the host will deny entry into paravirtual mode. Any other
+	 * combination (new host + old guest and new host + new guest)
+	 * is supposed to work - new host versions will support all old
+	 * guest API versions.
+	 */
+	u32 guest_version;
+	u32 host_version;
+	u32 size;
+	u32 ret;
+
+	/*
+	 * The address of the vm exit instruction (VMCALL or VMMCALL),
+	 * which the host will patch according to the CPU model the
+	 * VM runs on:
+	 */
+	u64 hypercall_gpa;
+
+} __attribute__ ((aligned(PAGE_SIZE)));
+
+#define KVM_PARA_API_VERSION 1
+
+/*
+ * This is used for an RDMSR's ECX parameter to probe for a KVM host.
+ * Hopefully no CPU vendor will use up this number. This is placed well
+ * out of way of the typical space occupied by CPU vendors' MSR indices,
+ * and we think (or at least hope) it wont be occupied in the future
+ * either.
+ */
+#define MSR_KVM_API_MAGIC 0x87655678
+
+#define KVM_EINVAL 1
+
+#endif
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
