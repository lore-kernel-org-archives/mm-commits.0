From: akpm@osdl.org
Subject: - kvm-make-inject_page_fault-an-arch-operation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:49 -0800
Message-ID: <200612100754.kBA7sncI017821@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760543AbWLJHyv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make inject_page_fault() an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-make-inject_page_fault-an-arch-operation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make inject_page_fault() an arch operation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |    2 ++
 drivers/kvm/mmu.c |   27 +--------------------------
 drivers/kvm/vmx.c |   31 +++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 26 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-inject_page_fault-an-arch-operation drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-inject_page_fault-an-arch-operation
+++ a/drivers/kvm/kvm.h
@@ -281,6 +281,8 @@ struct kvm_arch_ops {
 	void (*decache_regs)(struct kvm_vcpu *vcpu);
 
 	void (*flush_tlb)(struct kvm_vcpu *vcpu);
+	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
+				  unsigned long addr, u32 err_code);
 
 	int (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*vcpu_setup)(struct kvm_vcpu *vcpu);
diff -puN drivers/kvm/mmu.c~kvm-make-inject_page_fault-an-arch-operation drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-make-inject_page_fault-an-arch-operation
+++ a/drivers/kvm/mmu.c
@@ -455,32 +455,7 @@ static void inject_page_fault(struct kvm
 			      u64 addr,
 			      u32 err_code)
 {
-	u32 vect_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
-
-	pgprintk("inject_page_fault: 0x%llx err 0x%x\n", addr, err_code);
-
-	++kvm_stat.pf_guest;
-
-	if (is_page_fault(vect_info)) {
-		printk(KERN_DEBUG "inject_page_fault: "
-		       "double fault 0x%llx @ 0x%lx\n",
-		       addr, vmcs_readl(GUEST_RIP));
-		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, 0);
-		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-			     DF_VECTOR |
-			     INTR_TYPE_EXCEPTION |
-			     INTR_INFO_DELIEVER_CODE_MASK |
-			     INTR_INFO_VALID_MASK);
-		return;
-	}
-	vcpu->cr2 = addr;
-	vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, err_code);
-	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-		     PF_VECTOR |
-		     INTR_TYPE_EXCEPTION |
-		     INTR_INFO_DELIEVER_CODE_MASK |
-		     INTR_INFO_VALID_MASK);
-
+	kvm_arch_ops->inject_page_fault(vcpu, addr, err_code);
 }
 
 static inline int fix_read_pf(u64 *shadow_ent)
diff -puN drivers/kvm/vmx.c~kvm-make-inject_page_fault-an-arch-operation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-inject_page_fault-an-arch-operation
+++ a/drivers/kvm/vmx.c
@@ -1626,6 +1626,36 @@ static void vmx_flush_tlb(struct kvm_vcp
 	vmcs_writel(GUEST_CR3, vmcs_readl(GUEST_CR3));
 }
 
+static void vmx_inject_page_fault(struct kvm_vcpu *vcpu,
+				  unsigned long addr,
+				  u32 err_code)
+{
+	u32 vect_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
+
+	++kvm_stat.pf_guest;
+
+	if (is_page_fault(vect_info)) {
+		printk(KERN_DEBUG "inject_page_fault: "
+		       "double fault 0x%lx @ 0x%lx\n",
+		       addr, vmcs_readl(GUEST_RIP));
+		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, 0);
+		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+			     DF_VECTOR |
+			     INTR_TYPE_EXCEPTION |
+			     INTR_INFO_DELIEVER_CODE_MASK |
+			     INTR_INFO_VALID_MASK);
+		return;
+	}
+	vcpu->cr2 = addr;
+	vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, err_code);
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+		     PF_VECTOR |
+		     INTR_TYPE_EXCEPTION |
+		     INTR_INFO_DELIEVER_CODE_MASK |
+		     INTR_INFO_VALID_MASK);
+
+}
+
 static struct kvm_arch_ops vmx_arch_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -1654,6 +1684,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.decache_regs = vcpu_put_rsp_rip,
 
 	.flush_tlb = vmx_flush_tlb,
+	.inject_page_fault = vmx_inject_page_fault,
 
 	.run = vmx_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

