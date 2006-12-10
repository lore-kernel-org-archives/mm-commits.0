From: akpm@osdl.org
Subject: - kvm-make-__set_cr4-an-arch-operation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:37 -0800
Message-ID: <200612100754.kBA7sbCW017809@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59743 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760526AbWLJHyj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make __set_cr4() an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-make-__set_cr4-an-arch-operation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make __set_cr4() an arch operation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |   13 ++-----------
 drivers/kvm/vmx.c      |   11 ++++++++++-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-__set_cr4-an-arch-operation drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-__set_cr4-an-arch-operation
+++ a/drivers/kvm/kvm.h
@@ -270,6 +270,7 @@ struct kvm_arch_ops {
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
+	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
@@ -339,7 +340,6 @@ void set_cr8(struct kvm_vcpu *vcpu, unsi
 void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 
 void __set_efer(struct kvm_vcpu *vcpu, u64 efer);
-void __set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
 
 void inject_gp(struct kvm_vcpu *vcpu);
 
diff -puN drivers/kvm/kvm_main.c~kvm-make-__set_cr4-an-arch-operation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-__set_cr4-an-arch-operation
+++ a/drivers/kvm/kvm_main.c
@@ -630,15 +630,6 @@ void lmsw(struct kvm_vcpu *vcpu, unsigne
 }
 EXPORT_SYMBOL_GPL(lmsw);
 
-void __set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
-{
-	vmcs_writel(CR4_READ_SHADOW, cr4);
-	vmcs_writel(GUEST_CR4, cr4 | (vcpu->rmode.active ?
-		    KVM_RMODE_VM_CR4_ALWAYS_ON : KVM_PMODE_VM_CR4_ALWAYS_ON));
-	vcpu->cr4 = cr4;
-}
-EXPORT_SYMBOL_GPL(__set_cr4);
-
 void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	if (cr4 & CR4_RESEVED_BITS) {
@@ -665,7 +656,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsi
 		inject_gp(vcpu);
 		return;
 	}
-	__set_cr4(vcpu, cr4);
+	kvm_arch_ops->set_cr4(vcpu, cr4);
 	spin_lock(&vcpu->kvm->lock);
 	kvm_mmu_reset_context(vcpu);
 	spin_unlock(&vcpu->kvm->lock);
@@ -1610,7 +1601,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 	vcpu->cr0 = sregs->cr0;
 
 	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
-	__set_cr4(vcpu, sregs->cr4);
+	kvm_arch_ops->set_cr4(vcpu, sregs->cr4);
 
 	if (mmu_reset_needed)
 		kvm_mmu_reset_context(vcpu);
diff -puN drivers/kvm/vmx.c~kvm-make-__set_cr4-an-arch-operation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-__set_cr4-an-arch-operation
+++ a/drivers/kvm/vmx.c
@@ -547,6 +547,14 @@ static void vmx_set_cr0(struct kvm_vcpu 
 	vcpu->cr0 = cr0;
 }
 
+static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	vmcs_writel(CR4_READ_SHADOW, cr4);
+	vmcs_writel(GUEST_CR4, cr4 | (vcpu->rmode.active ?
+		    KVM_RMODE_VM_CR4_ALWAYS_ON : KVM_PMODE_VM_CR4_ALWAYS_ON));
+	vcpu->cr4 = cr4;
+}
+
 static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -874,7 +882,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 
 	vcpu->cr0 = 0x60000010;
 	vmx_set_cr0(vcpu, vcpu->cr0); // enter rmode
-	__set_cr4(vcpu, 0);
+	vmx_set_cr4(vcpu, 0);
 #ifdef __x86_64__
 	__set_efer(vcpu, 0);
 #endif
@@ -1599,6 +1607,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
 	.set_cr0 = vmx_set_cr0,
+	.set_cr4 = vmx_set_cr4,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

