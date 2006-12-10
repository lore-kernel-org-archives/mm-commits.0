From: akpm@osdl.org
Subject: - kvm-make-inject_gp-an-arch-operation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:52 -0800
Message-ID: <200612100754.kBA7sqX1017824@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59764 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760544AbWLJHyz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make inject_gp() an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-make-inject_gp-an-arch-operation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make inject_gp() an arch operation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    4 ++--
 drivers/kvm/kvm_main.c |   12 ++----------
 drivers/kvm/vmx.c      |   18 ++++++++++++++++--
 3 files changed, 20 insertions(+), 14 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-inject_gp-an-arch-operation drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-inject_gp-an-arch-operation
+++ a/drivers/kvm/kvm.h
@@ -284,6 +284,8 @@ struct kvm_arch_ops {
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  unsigned long addr, u32 err_code);
 
+	void (*inject_gp)(struct kvm_vcpu *vcpu, unsigned err_code);
+
 	int (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*vcpu_setup)(struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
@@ -345,8 +347,6 @@ void set_cr4(struct kvm_vcpu *vcpu, unsi
 void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
 void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 
-void inject_gp(struct kvm_vcpu *vcpu);
-
 #ifdef __x86_64__
 void set_efer(struct kvm_vcpu *vcpu, u64 efer);
 #endif
diff -puN drivers/kvm/kvm_main.c~kvm-make-inject_gp-an-arch-operation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-inject_gp-an-arch-operation
+++ a/drivers/kvm/kvm_main.c
@@ -470,18 +470,10 @@ void vmcs_writel(unsigned long field, un
 }
 EXPORT_SYMBOL_GPL(vmcs_writel);
 
-void inject_gp(struct kvm_vcpu *vcpu)
+static void inject_gp(struct kvm_vcpu *vcpu)
 {
-	printk(KERN_DEBUG "inject_general_protection: rip 0x%lx\n",
-	       vmcs_readl(GUEST_RIP));
-	vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, 0);
-	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
-		     GP_VECTOR |
-		     INTR_TYPE_EXCEPTION |
-		     INTR_INFO_DELIEVER_CODE_MASK |
-		     INTR_INFO_VALID_MASK);
+	kvm_arch_ops->inject_gp(vcpu, 0);
 }
-EXPORT_SYMBOL_GPL(inject_gp);
 
 /*
  * reads and returns guest's timestamp counter "register"
diff -puN drivers/kvm/vmx.c~kvm-make-inject_gp-an-arch-operation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-inject_gp-an-arch-operation
+++ a/drivers/kvm/vmx.c
@@ -82,6 +82,18 @@ static void skip_emulated_instruction(st
 			     interruptibility & ~3);
 }
 
+static void vmx_inject_gp(struct kvm_vcpu *vcpu, unsigned error_code)
+{
+	printk(KERN_DEBUG "inject_general_protection: rip 0x%lx\n",
+	       vmcs_readl(GUEST_RIP));
+	vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+		     GP_VECTOR |
+		     INTR_TYPE_EXCEPTION |
+		     INTR_INFO_DELIEVER_CODE_MASK |
+		     INTR_INFO_VALID_MASK);
+}
+
 static void reload_tss(void)
 {
 #ifndef __x86_64__
@@ -1320,7 +1332,7 @@ static int handle_rdmsr(struct kvm_vcpu 
 	u64 data;
 
 	if (vmx_get_msr(vcpu, ecx, &data)) {
-		inject_gp(vcpu);
+		vmx_inject_gp(vcpu, 0);
 		return 1;
 	}
 
@@ -1338,7 +1350,7 @@ static int handle_wrmsr(struct kvm_vcpu 
 		| ((u64)(vcpu->regs[VCPU_REGS_RDX] & -1u) << 32);
 
 	if (vmx_set_msr(vcpu, ecx, data) != 0) {
-		inject_gp(vcpu);
+		vmx_inject_gp(vcpu, 0);
 		return 1;
 	}
 
@@ -1686,6 +1698,8 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.flush_tlb = vmx_flush_tlb,
 	.inject_page_fault = vmx_inject_page_fault,
 
+	.inject_gp = vmx_inject_gp,
+
 	.run = vmx_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.vcpu_setup = vmx_vcpu_setup,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

