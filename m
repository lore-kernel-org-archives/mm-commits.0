From: akpm@osdl.org
Subject: - kvm-make-set_cr3-and-tlb-flushing-arch-operations.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:46 -0800
Message-ID: <200612100754.kBA7skxI017818@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59757 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760532AbWLJHyt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make set_cr3() and tlb flushing arch operations
has been removed from the -mm tree.  Its filename was
     kvm-make-set_cr3-and-tlb-flushing-arch-operations.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make set_cr3() and tlb flushing arch operations
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |    3 +++
 drivers/kvm/mmu.c |   12 +++++-------
 drivers/kvm/vmx.c |   13 +++++++++++++
 3 files changed, 21 insertions(+), 7 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-set_cr3-and-tlb-flushing-arch-operations drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-set_cr3-and-tlb-flushing-arch-operations
+++ a/drivers/kvm/kvm.h
@@ -270,6 +270,7 @@ struct kvm_arch_ops {
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
+	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
@@ -279,6 +280,8 @@ struct kvm_arch_ops {
 	void (*cache_regs)(struct kvm_vcpu *vcpu);
 	void (*decache_regs)(struct kvm_vcpu *vcpu);
 
+	void (*flush_tlb)(struct kvm_vcpu *vcpu);
+
 	int (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*vcpu_setup)(struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
diff -puN drivers/kvm/mmu.c~kvm-make-set_cr3-and-tlb-flushing-arch-operations drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-make-set_cr3-and-tlb-flushing-arch-operations
+++ a/drivers/kvm/mmu.c
@@ -323,7 +323,7 @@ static void nonpaging_flush(struct kvm_v
 	vcpu->mmu.root_hpa = root;
 	if (is_paging(vcpu))
 		root |= (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK));
-	vmcs_writel(GUEST_CR3, root);
+	kvm_arch_ops->set_cr3(vcpu, root);
 }
 
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr)
@@ -386,7 +386,7 @@ static int nonpaging_init_context(struct
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = kvm_mmu_alloc_page(vcpu, 0);
 	ASSERT(VALID_PAGE(context->root_hpa));
-	vmcs_writel(GUEST_CR3, context->root_hpa);
+	kvm_arch_ops->set_cr3(vcpu, context->root_hpa);
 	return 0;
 }
 
@@ -539,9 +539,7 @@ static void paging_inval_page(struct kvm
 			table[index] = 0;
 			release_pt_page_64(vcpu, page_addr, PT_PAGE_TABLE_LEVEL);
 
-			//flush tlb
-			vmcs_writel(GUEST_CR3, vcpu->mmu.root_hpa |
-				    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
+			kvm_arch_ops->flush_tlb(vcpu);
 			return;
 		}
 	}
@@ -574,7 +572,7 @@ static int paging64_init_context(struct 
 	context->shadow_root_level = PT64_ROOT_LEVEL;
 	context->root_hpa = kvm_mmu_alloc_page(vcpu, 0);
 	ASSERT(VALID_PAGE(context->root_hpa));
-	vmcs_writel(GUEST_CR3, context->root_hpa |
+	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
 		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
 	return 0;
 }
@@ -592,7 +590,7 @@ static int paging32_init_context(struct 
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = kvm_mmu_alloc_page(vcpu, 0);
 	ASSERT(VALID_PAGE(context->root_hpa));
-	vmcs_writel(GUEST_CR3, context->root_hpa |
+	kvm_arch_ops->set_cr3(vcpu, context->root_hpa |
 		    (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK)));
 	return 0;
 }
diff -puN drivers/kvm/vmx.c~kvm-make-set_cr3-and-tlb-flushing-arch-operations drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-set_cr3-and-tlb-flushing-arch-operations
+++ a/drivers/kvm/vmx.c
@@ -547,6 +547,11 @@ static void vmx_set_cr0(struct kvm_vcpu 
 	vcpu->cr0 = cr0;
 }
 
+static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	vmcs_writel(GUEST_CR3, cr3);
+}
+
 static void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	vmcs_writel(CR4_READ_SHADOW, cr4);
@@ -1616,6 +1621,11 @@ again:
 	return 0;
 }
 
+static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	vmcs_writel(GUEST_CR3, vmcs_readl(GUEST_CR3));
+}
+
 static struct kvm_arch_ops vmx_arch_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -1631,6 +1641,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
 	.set_cr0 = vmx_set_cr0,
+	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
 #ifdef __x86_64__
 	.set_efer = vmx_set_efer,
@@ -1642,6 +1653,8 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.cache_regs = vcpu_load_rsp_rip,
 	.decache_regs = vcpu_put_rsp_rip,
 
+	.flush_tlb = vmx_flush_tlb,
+
 	.run = vmx_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.vcpu_setup = vmx_vcpu_setup,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

