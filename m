From: akpm@osdl.org
Subject: - kvm-less-common-exit-handlers.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:48 -0800
Message-ID: <200612100752.kBA7qmvg017684@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59580 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760420AbWLJHww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, yaniv@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: less common exit handlers
has been removed from the -mm tree.  Its filename was
     kvm-less-common-exit-handlers.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: kvm: less common exit handlers
From: Avi Kivity <avi@qumranet.com>

Add exit handlers for msrs, debug registers, and cpuid.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |  183 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 183 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-less-common-exit-handlers drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-less-common-exit-handlers
+++ a/drivers/kvm/kvm_main.c
@@ -2223,6 +2223,113 @@ static int handle_cr(struct kvm_vcpu *vc
 	return 0;
 }
 
+static int handle_dr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	u64 exit_qualification;
+	unsigned long val;
+	int dr, reg;
+
+	/*
+	 * FIXME: this code assumes the host is debugging the guest.
+	 *        need to deal with guest debugging itself too.
+	 */
+	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
+	dr = exit_qualification & 7;
+	reg = (exit_qualification >> 8) & 15;
+	vcpu_load_rsp_rip(vcpu);
+	if (exit_qualification & 16) {
+		/* mov from dr */
+		switch (dr) {
+		case 6:
+			val = 0xffff0ff0;
+			break;
+		case 7:
+			val = 0x400;
+			break;
+		default:
+			val = 0;
+		}
+		vcpu->regs[reg] = val;
+	} else {
+		/* mov to dr */
+	}
+	vcpu_put_rsp_rip(vcpu);
+	skip_emulated_instruction(vcpu);
+	return 1;
+}
+
+static int handle_cpuid(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_run->exit_reason = KVM_EXIT_CPUID;
+	return 0;
+}
+
+static int handle_rdmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
+	struct vmx_msr_entry *msr = find_msr_entry(vcpu, ecx);
+	u64 data;
+
+#ifdef KVM_DEBUG
+	if (guest_cpl() != 0) {
+		vcpu_printf(vcpu, "%s: not supervisor\n", __FUNCTION__);
+		inject_gp(vcpu);
+		return 1;
+	}
+#endif
+
+	switch (ecx) {
+#ifdef __x86_64__
+	case MSR_FS_BASE:
+		data = vmcs_readl(GUEST_FS_BASE);
+		break;
+	case MSR_GS_BASE:
+		data = vmcs_readl(GUEST_GS_BASE);
+		break;
+#endif
+	case MSR_IA32_SYSENTER_CS:
+		data = vmcs_read32(GUEST_SYSENTER_CS);
+		break;
+	case MSR_IA32_SYSENTER_EIP:
+		data = vmcs_read32(GUEST_SYSENTER_EIP);
+		break;
+	case MSR_IA32_SYSENTER_ESP:
+		data = vmcs_read32(GUEST_SYSENTER_ESP);
+		break;
+	case MSR_IA32_MC0_CTL:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MC0_MISC:
+	case MSR_IA32_MC0_MISC+4:
+	case MSR_IA32_MC0_MISC+8:
+	case MSR_IA32_MC0_MISC+12:
+	case MSR_IA32_MC0_MISC+16:
+	case MSR_IA32_UCODE_REV:
+		/* MTRR registers */
+	case 0xfe:
+	case 0x200 ... 0x2ff:
+		data = 0;
+		break;
+	case MSR_IA32_APICBASE:
+		data = vcpu->apic_base;
+		break;
+	default:
+		if (msr) {
+			data = msr->data;
+			break;
+		}
+		printk(KERN_ERR "kvm: unhandled rdmsr: %x\n", ecx);
+		inject_gp(vcpu);
+		return 1;
+	}
+
+	/* FIXME: handling of bits 32:63 of rax, rdx */
+	vcpu->regs[VCPU_REGS_RAX] = data & -1u;
+	vcpu->regs[VCPU_REGS_RDX] = (data >> 32) & -1u;
+	skip_emulated_instruction(vcpu);
+	return 1;
+}
+
 #ifdef __x86_64__
 
 static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
@@ -2257,6 +2364,78 @@ static void set_efer(struct kvm_vcpu *vc
 
 #endif
 
+#define MSR_IA32_TIME_STAMP_COUNTER 0x10
+
+static int handle_wrmsr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	u32 ecx = vcpu->regs[VCPU_REGS_RCX];
+	struct vmx_msr_entry *msr;
+	u64 data = (vcpu->regs[VCPU_REGS_RAX] & -1u)
+		| ((u64)(vcpu->regs[VCPU_REGS_RDX] & -1u) << 32);
+
+#ifdef KVM_DEBUG
+	if (guest_cpl() != 0) {
+		vcpu_printf(vcpu, "%s: not supervisor\n", __FUNCTION__);
+		inject_gp(vcpu);
+		return 1;
+	}
+#endif
+
+	switch (ecx) {
+#ifdef __x86_64__
+	case MSR_FS_BASE:
+		vmcs_writel(GUEST_FS_BASE, data);
+		break;
+	case MSR_GS_BASE:
+		vmcs_writel(GUEST_GS_BASE, data);
+		break;
+#endif
+	case MSR_IA32_SYSENTER_CS:
+		vmcs_write32(GUEST_SYSENTER_CS, data);
+		break;
+	case MSR_IA32_SYSENTER_EIP:
+		vmcs_write32(GUEST_SYSENTER_EIP, data);
+		break;
+	case MSR_IA32_SYSENTER_ESP:
+		vmcs_write32(GUEST_SYSENTER_ESP, data);
+		break;
+#ifdef __x86_64
+	case MSR_EFER:
+		set_efer(vcpu, data);
+		return 1;
+	case MSR_IA32_MC0_STATUS:
+		printk(KERN_WARNING "%s: MSR_IA32_MC0_STATUS 0x%llx, nop\n"
+			    , __FUNCTION__, data);
+		break;
+#endif
+	case MSR_IA32_TIME_STAMP_COUNTER: {
+		u64 tsc;
+
+		rdtscll(tsc);
+		vmcs_write64(TSC_OFFSET, data - tsc);
+		break;
+	}
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_UCODE_WRITE:
+	case 0x200 ... 0x2ff: /* MTRRs */
+		break;
+	case MSR_IA32_APICBASE:
+		vcpu->apic_base = data;
+		break;
+	default:
+		msr = find_msr_entry(vcpu, ecx);
+		if (msr) {
+			msr->data = data;
+			break;
+		}
+		printk(KERN_ERR "kvm: unhandled wrmsr: %x\n", ecx);
+		inject_gp(vcpu);
+		return 1;
+	}
+	skip_emulated_instruction(vcpu);
+	return 1;
+}
+
 static int handle_interrupt_window(struct kvm_vcpu *vcpu,
 				   struct kvm_run *kvm_run)
 {
@@ -2289,6 +2468,10 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_IO_INSTRUCTION]          = handle_io,
 	[EXIT_REASON_INVLPG]                  = handle_invlpg,
 	[EXIT_REASON_CR_ACCESS]               = handle_cr,
+	[EXIT_REASON_DR_ACCESS]               = handle_dr,
+	[EXIT_REASON_CPUID]                   = handle_cpuid,
+	[EXIT_REASON_MSR_READ]                = handle_rdmsr,
+	[EXIT_REASON_MSR_WRITE]               = handle_wrmsr,
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = handle_halt,
 };
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-less-common-exit-handlers.patch
kvm-less-common-exit-handlers-handle-rdmsrmsr_efer.patch
kvm-mmu.patch
kvm-mmu-mmu-honor-global-bit-on-huge-pages.patch
kvm-x86-emulator.patch
kvm-x86-emulator-x86-emulator-handle-smsw.patch
kvm-clarify-licensing.patch
kvm-x86-emulator-fix-emulator-mov-cr-decoding.patch
kvm-plumbing.patch
kvm-dynamically-determine-which-msrs-to-load-and-save.patch
kvm-fix-calculation-of-initial-value-of-rdx-register.patch
kvm-avoid-using-vmx-instruction-directly.patch
kvm-avoid-using-vmx-instruction-directly-fix-asm-constraints.patch
kvm-expose-interrupt-bitmap.patch
kvm-add-time-stamp-counter-msr-and-accessors.patch
kvm-expose-msrs-to-userspace.patch
kvm-expose-msrs-to-userspace-v2.patch
kvm-create-kvm-intelko-module.patch
kvm-make-dev-registration-happen-when-the-arch.patch
kvm-make-hardware-detection-an-arch-operation.patch
kvm-make-the-per-cpu-enable-disable-functions-arch.patch
kvm-make-the-hardware-setup-operations-non-percpu.patch
kvm-make-the-guest-debugger-an-arch-operation.patch
kvm-make-msr-accessors-arch-operations.patch
kvm-make-the-segment-accessors-arch-operations.patch
kvm-cache-guest-cr4-in-vcpu-structure.patch
kvm-cache-guest-cr0-in-vcpu-structure.patch
kvm-add-get_segment_base-arch-accessor.patch
kvm-add-idt-and-gdt-descriptor-accessors.patch
kvm-make-syncing-the-register-file-to-the-vcpu.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-move-the-vmx-exit-handlers-to-vmxc.patch
kvm-make-vcpu_setup-an-arch-operation.patch
kvm-make-__set_cr0-and-dependencies-arch-operations.patch
kvm-make-__set_cr4-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
kvm-make-set_cr3-and-tlb-flushing-arch-operations.patch
kvm-make-inject_page_fault-an-arch-operation.patch
kvm-make-inject_gp-an-arch-operation.patch
kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation.patch
kvm-use-the-general-purpose-register-accessors-rather.patch
kvm-move-the-vmx-tsc-accessors-to-vmxc.patch
kvm-access-rflags-through-an-arch-operation.patch
kvm-move-the-vmx-segment-field-definitions-to-vmxc.patch
kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits.patch
kvm-add-a-set_cr0_no_modeswitch-arch-accessor.patch
kvm-make-vcpu_load-and-vcpu_put-arch-operations.patch
kvm-make-vcpu-creation-and-destruction-arch-operations.patch
kvm-move-vmcs-static-variables-to-vmxc.patch
kvm-make-is_long_mode-an-arch-operation.patch
kvm-use-the-tlb-flush-arch-operation-instead-of-an.patch
kvm-remove-guest_cpl.patch
kvm-move-vmcs-accessors-to-vmxc.patch
kvm-move-vmx-helper-inlines-to-vmxc.patch
kvm-remove-vmx-includes-from-arch-independent-code.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

