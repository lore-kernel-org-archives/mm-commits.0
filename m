From: akpm@osdl.org
Subject: - kvm-cache-guest-cr4-in-vcpu-structure.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:06 -0800
Message-ID: <200612100754.kBA7s6LS017771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760504AbWLJHyJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: cache guest cr4 in vcpu structure
has been removed from the -mm tree.  Its filename was
     kvm-cache-guest-cr4-in-vcpu-structure.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: cache guest cr4 in vcpu structure
From: Avi Kivity <avi@qumranet.com>

This eliminates needing to have an arch operation to get cr4.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h         |   15 +++++----------
 drivers/kvm/kvm_main.c    |   17 +++++++++--------
 drivers/kvm/kvm_vmx.h     |   20 ++++++++++++++++++++
 drivers/kvm/mmu.c         |    4 ++--
 drivers/kvm/paging_tmpl.h |    6 +++---
 5 files changed, 39 insertions(+), 23 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-cache-guest-cr4-in-vcpu-structure drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-cache-guest-cr4-in-vcpu-structure
+++ a/drivers/kvm/kvm.h
@@ -168,6 +168,7 @@ struct kvm_vcpu {
 
 	unsigned long cr2;
 	unsigned long cr3;
+	unsigned long cr4;
 	unsigned long cr8;
 	u64 shadow_efer;
 	u64 apic_base;
@@ -335,20 +336,14 @@ static inline int is_long_mode(void)
 	return vmcs_read32(VM_ENTRY_CONTROLS) & VM_ENTRY_CONTROLS_IA32E_MASK;
 }
 
-static inline unsigned long guest_cr4(void)
+static inline int is_pae(struct kvm_vcpu *vcpu)
 {
-	return (vmcs_readl(CR4_READ_SHADOW) & KVM_GUEST_CR4_MASK) |
-		(vmcs_readl(GUEST_CR4) & ~KVM_GUEST_CR4_MASK);
+	return vcpu->cr4 & CR4_PAE_MASK;
 }
 
-static inline int is_pae(void)
+static inline int is_pse(struct kvm_vcpu *vcpu)
 {
-	return guest_cr4() & CR4_PAE_MASK;
-}
-
-static inline int is_pse(void)
-{
-	return guest_cr4() & CR4_PSE_MASK;
+	return vcpu->cr4 & CR4_PSE_MASK;
 }
 
 static inline unsigned long guest_cr0(void)
diff -puN drivers/kvm/kvm_main.c~kvm-cache-guest-cr4-in-vcpu-structure drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-cache-guest-cr4-in-vcpu-structure
+++ a/drivers/kvm/kvm_main.c
@@ -940,7 +940,7 @@ static void set_cr0(struct kvm_vcpu *vcp
 #ifdef __x86_64__
 		if ((vcpu->shadow_efer & EFER_LME)) {
 			u32 guest_cs_ar;
-			if (!is_pae()) {
+			if (!is_pae(vcpu)) {
 				printk(KERN_DEBUG "set_cr0: #GP, start paging "
 				       "in long mode while PAE is disabled\n");
 				inject_gp(vcpu);
@@ -956,7 +956,7 @@ static void set_cr0(struct kvm_vcpu *vcp
 			}
 		} else
 #endif
-		if (is_pae() &&
+		if (is_pae(vcpu) &&
 			    pdptrs_have_reserved_bits_set(vcpu, vcpu->cr3)) {
 			printk(KERN_DEBUG "set_cr0: #GP, pdptrs "
 			       "reserved bits\n");
@@ -993,6 +993,7 @@ static void __set_cr4(struct kvm_vcpu *v
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, cr4 | (vcpu->rmode.active ?
 		    KVM_RMODE_VM_CR4_ALWAYS_ON : KVM_PMODE_VM_CR4_ALWAYS_ON));
+	vcpu->cr4 = cr4;
 }
 
 static void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -1010,7 +1011,7 @@ static void set_cr4(struct kvm_vcpu *vcp
 			inject_gp(vcpu);
 			return;
 		}
-	} else if (is_paging() && !is_pae() && (cr4 & CR4_PAE_MASK)
+	} else if (is_paging() && !is_pae(vcpu) && (cr4 & CR4_PAE_MASK)
 		   && pdptrs_have_reserved_bits_set(vcpu, vcpu->cr3)) {
 		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		inject_gp(vcpu);
@@ -1041,7 +1042,7 @@ static void set_cr3(struct kvm_vcpu *vcp
 			inject_gp(vcpu);
 			return;
 		}
-		if (is_paging() && is_pae() &&
+		if (is_paging() && is_pae(vcpu) &&
 		    pdptrs_have_reserved_bits_set(vcpu, cr3)) {
 			printk(KERN_DEBUG "set_cr3: #GP, pdptrs "
 			       "reserved bits\n");
@@ -1903,7 +1904,7 @@ unsigned long realmode_get_cr(struct kvm
 	case 3:
 		return vcpu->cr3;
 	case 4:
-		return guest_cr4();
+		return vcpu->cr4;
 	default:
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
 		return 0;
@@ -1925,7 +1926,7 @@ void realmode_set_cr(struct kvm_vcpu *vc
 		set_cr3(vcpu, val);
 		break;
 	case 4:
-		set_cr4(vcpu, mk_cr_64(guest_cr4(), val));
+		set_cr4(vcpu, mk_cr_64(vcpu->cr4, val));
 		break;
 	default:
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
@@ -2845,7 +2846,7 @@ static int kvm_dev_ioctl_get_sregs(struc
 	sregs->cr0 = guest_cr0();
 	sregs->cr2 = vcpu->cr2;
 	sregs->cr3 = vcpu->cr3;
-	sregs->cr4 = guest_cr4();
+	sregs->cr4 = vcpu->cr4;
 	sregs->cr8 = vcpu->cr8;
 	sregs->efer = vcpu->shadow_efer;
 	sregs->apic_base = vcpu->apic_base;
@@ -2913,7 +2914,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 	vmcs_writel(GUEST_CR0,
 		    (sregs->cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
 
-	mmu_reset_needed |=  guest_cr4() != sregs->cr4;
+	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
 	__set_cr4(vcpu, sregs->cr4);
 
 	if (mmu_reset_needed)
diff -puN /dev/null drivers/kvm/kvm_vmx.h
--- /dev/null
+++ a/drivers/kvm/kvm_vmx.h
@@ -0,0 +1,20 @@
+#ifndef __KVM_VMX_H
+#define __KVM_VMX_H
+
+static inline void vmcs_write16(unsigned long field, u16 value)
+{
+	vmcs_writel(field, value);
+}
+
+static inline void vmcs_write64(unsigned long field, u64 value)
+{
+#ifdef __x86_64__
+	vmcs_writel(field, value);
+#else
+	vmcs_writel(field, value);
+	asm volatile ("");
+	vmcs_writel(field+1, value >> 32);
+#endif
+}
+
+#endif
diff -puN drivers/kvm/mmu.c~kvm-cache-guest-cr4-in-vcpu-structure drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-cache-guest-cr4-in-vcpu-structure
+++ a/drivers/kvm/mmu.c
@@ -564,7 +564,7 @@ static int paging64_init_context(struct 
 {
 	struct kvm_mmu *context = &vcpu->mmu;
 
-	ASSERT(is_pae());
+	ASSERT(is_pae(vcpu));
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging64_page_fault;
 	context->inval_page = paging_inval_page;
@@ -618,7 +618,7 @@ static int init_kvm_mmu(struct kvm_vcpu 
 		return nonpaging_init_context(vcpu);
 	else if (is_long_mode())
 		return paging64_init_context(vcpu);
-	else if (is_pae())
+	else if (is_pae(vcpu))
 		return paging32E_init_context(vcpu);
 	else
 		return paging32_init_context(vcpu);
diff -puN drivers/kvm/paging_tmpl.h~kvm-cache-guest-cr4-in-vcpu-structure drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-cache-guest-cr4-in-vcpu-structure
+++ a/drivers/kvm/paging_tmpl.h
@@ -70,7 +70,7 @@ static void FNAME(init_walker)(struct gu
 	hpa = safe_gpa_to_hpa(vcpu, vcpu->cr3 & PT64_BASE_ADDR_MASK);
 	walker->table = kmap_atomic(pfn_to_page(hpa >> PAGE_SHIFT), KM_USER0);
 
-	ASSERT((!is_long_mode() && is_pae()) ||
+	ASSERT((!is_long_mode() && is_pae(vcpu)) ||
 	       (vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) == 0);
 
 	walker->table = (pt_element_t *)( (unsigned long)walker->table |
@@ -133,7 +133,7 @@ static pt_element_t *FNAME(fetch_guest)(
 		    !is_present_pte(walker->table[index]) ||
 		    (walker->level == PT_DIRECTORY_LEVEL &&
 		     (walker->table[index] & PT_PAGE_SIZE_MASK) &&
-		     (PTTYPE == 64 || is_pse())))
+		     (PTTYPE == 64 || is_pse(vcpu))))
 			return &walker->table[index];
 		if (walker->level != 3 || is_long_mode())
 			walker->inherited_ar &= walker->table[index];
@@ -369,7 +369,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kv
 
 	if (walker.level == PT_DIRECTORY_LEVEL) {
 		ASSERT((guest_pte & PT_PAGE_SIZE_MASK));
-		ASSERT(PTTYPE == 64 || is_pse());
+		ASSERT(PTTYPE == 64 || is_pse(vcpu));
 
 		gpa = (guest_pte & PT_DIR_BASE_ADDR_MASK) | (vaddr &
 			(PT_LEVEL_MASK(PT_PAGE_TABLE_LEVEL) | ~PAGE_MASK));
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

