From: akpm@osdl.org
Subject: - kvm-make-__set_efer-an-arch-operation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:40 -0800
Message-ID: <200612100754.kBA7sebN017812@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59748 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760411AbWLJHyn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make __set_efer() an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-make-__set_efer-an-arch-operation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make __set_efer() an arch operation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    3 +--
 drivers/kvm/kvm_main.c |   27 +--------------------------
 drivers/kvm/vmx.c      |   27 ++++++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 29 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-__set_efer-an-arch-operation drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-__set_efer-an-arch-operation
+++ a/drivers/kvm/kvm.h
@@ -271,6 +271,7 @@ struct kvm_arch_ops {
 			    struct kvm_segment *var, int seg);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
+	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
@@ -339,8 +340,6 @@ void set_cr4(struct kvm_vcpu *vcpu, unsi
 void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
 void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 
-void __set_efer(struct kvm_vcpu *vcpu, u64 efer);
-
 void inject_gp(struct kvm_vcpu *vcpu);
 
 #ifdef __x86_64__
diff -puN drivers/kvm/kvm_main.c~kvm-make-__set_efer-an-arch-operation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-__set_efer-an-arch-operation
+++ a/drivers/kvm/kvm_main.c
@@ -510,31 +510,6 @@ void guest_write_tsc(u64 guest_tsc)
 }
 EXPORT_SYMBOL_GPL(guest_write_tsc);
 
-#ifdef __x86_64__
-
-void __set_efer(struct kvm_vcpu *vcpu, u64 efer)
-{
-	struct vmx_msr_entry *msr = find_msr_entry(vcpu, MSR_EFER);
-
-	vcpu->shadow_efer = efer;
-	if (efer & EFER_LMA) {
-		vmcs_write32(VM_ENTRY_CONTROLS,
-				     vmcs_read32(VM_ENTRY_CONTROLS) |
-				     VM_ENTRY_CONTROLS_IA32E_MASK);
-		msr->data = efer;
-
-	} else {
-		vmcs_write32(VM_ENTRY_CONTROLS,
-				     vmcs_read32(VM_ENTRY_CONTROLS) &
-				     ~VM_ENTRY_CONTROLS_IA32E_MASK);
-
-		msr->data = efer & ~EFER_LME;
-	}
-}
-EXPORT_SYMBOL_GPL(__set_efer);
-
-#endif
-
 static int pdptrs_have_reserved_bits_set(struct kvm_vcpu *vcpu,
 					 unsigned long cr3)
 {
@@ -1588,7 +1563,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 
 	mmu_reset_needed |= vcpu->shadow_efer != sregs->efer;
 #ifdef __x86_64__
-	__set_efer(vcpu, sregs->efer);
+	kvm_arch_ops->set_efer(vcpu, sregs->efer);
 #endif
 	vcpu->apic_base = sregs->apic_base;
 
diff -puN drivers/kvm/vmx.c~kvm-make-__set_efer-an-arch-operation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-__set_efer-an-arch-operation
+++ a/drivers/kvm/vmx.c
@@ -555,6 +555,30 @@ static void vmx_set_cr4(struct kvm_vcpu 
 	vcpu->cr4 = cr4;
 }
 
+#ifdef __x86_64__
+
+static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	struct vmx_msr_entry *msr = find_msr_entry(vcpu, MSR_EFER);
+
+	vcpu->shadow_efer = efer;
+	if (efer & EFER_LMA) {
+		vmcs_write32(VM_ENTRY_CONTROLS,
+				     vmcs_read32(VM_ENTRY_CONTROLS) |
+				     VM_ENTRY_CONTROLS_IA32E_MASK);
+		msr->data = efer;
+
+	} else {
+		vmcs_write32(VM_ENTRY_CONTROLS,
+				     vmcs_read32(VM_ENTRY_CONTROLS) &
+				     ~VM_ENTRY_CONTROLS_IA32E_MASK);
+
+		msr->data = efer & ~EFER_LME;
+	}
+}
+
+#endif
+
 static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -884,7 +908,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 	vmx_set_cr0(vcpu, vcpu->cr0); // enter rmode
 	vmx_set_cr4(vcpu, 0);
 #ifdef __x86_64__
-	__set_efer(vcpu, 0);
+	vmx_set_efer(vcpu, 0);
 #endif
 
 	return 0;
@@ -1608,6 +1632,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.set_segment = vmx_set_segment,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr4 = vmx_set_cr4,
+	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

