From: akpm@osdl.org
Subject: - kvm-cache-guest-cr0-in-vcpu-structure.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:09 -0800
Message-ID: <200612100754.kBA7s92S017774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59704 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760496AbWLJHyM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: cache guest cr0 in vcpu structure
has been removed from the -mm tree.  Its filename was
     kvm-cache-guest-cr0-in-vcpu-structure.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: cache guest cr0 in vcpu structure
From: Avi Kivity <avi@qumranet.com>

This eliminates needing to have an arch operation to get cr0.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h         |   12 +++---------
 drivers/kvm/kvm_main.c    |   28 ++++++++++++++++------------
 drivers/kvm/mmu.c         |    8 ++++----
 drivers/kvm/paging_tmpl.h |    2 +-
 4 files changed, 24 insertions(+), 26 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-cache-guest-cr0-in-vcpu-structure drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-cache-guest-cr0-in-vcpu-structure
+++ a/drivers/kvm/kvm.h
@@ -41,7 +41,6 @@
 	 | CR0_NW_MASK | CR0_CD_MASK)
 #define KVM_VM_CR0_ALWAYS_ON \
 	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK)
-
 #define KVM_GUEST_CR4_MASK \
 	(CR4_PSE_MASK | CR4_PAE_MASK | CR4_PGE_MASK | CR4_VMXE_MASK | CR4_VME_MASK)
 #define KVM_PMODE_VM_CR4_ALWAYS_ON (CR4_VMXE_MASK | CR4_PAE_MASK)
@@ -166,6 +165,7 @@ struct kvm_vcpu {
 	unsigned long regs[NR_VCPU_REGS]; /* for rsp: vcpu_load_rsp_rip() */
 	unsigned long rip;      /* needs vcpu_load_rsp_rip() */
 
+	unsigned long cr0;
 	unsigned long cr2;
 	unsigned long cr3;
 	unsigned long cr4;
@@ -346,20 +346,14 @@ static inline int is_pse(struct kvm_vcpu
 	return vcpu->cr4 & CR4_PSE_MASK;
 }
 
-static inline unsigned long guest_cr0(void)
-{
-	return (vmcs_readl(CR0_READ_SHADOW) & KVM_GUEST_CR0_MASK) |
-		(vmcs_readl(GUEST_CR0) & ~KVM_GUEST_CR0_MASK);
-}
-
 static inline unsigned guest_cpl(void)
 {
 	return vmcs_read16(GUEST_CS_SELECTOR) & SELECTOR_RPL_MASK;
 }
 
-static inline int is_paging(void)
+static inline int is_paging(struct kvm_vcpu *vcpu)
 {
-	return guest_cr0() & CR0_PG_MASK;
+	return vcpu->cr0 & CR0_PG_MASK;
 }
 
 static inline int is_page_fault(u32 intr_info)
diff -puN drivers/kvm/kvm_main.c~kvm-cache-guest-cr0-in-vcpu-structure drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-cache-guest-cr0-in-vcpu-structure
+++ a/drivers/kvm/kvm_main.c
@@ -875,9 +875,9 @@ static void __set_cr0(struct kvm_vcpu *v
 
 #ifdef __x86_64__
 	if (vcpu->shadow_efer & EFER_LME) {
-		if (!is_paging() && (cr0 & CR0_PG_MASK))
+		if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK))
 			enter_lmode(vcpu);
-		if (is_paging() && !(cr0 & CR0_PG_MASK))
+		if (is_paging(vcpu) && !(cr0 & CR0_PG_MASK))
 			exit_lmode(vcpu);
 	}
 #endif
@@ -885,6 +885,7 @@ static void __set_cr0(struct kvm_vcpu *v
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0,
 		    (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
+	vcpu->cr0 = cr0;
 }
 
 static int pdptrs_have_reserved_bits_set(struct kvm_vcpu *vcpu,
@@ -918,7 +919,7 @@ static void set_cr0(struct kvm_vcpu *vcp
 {
 	if (cr0 & CR0_RESEVED_BITS) {
 		printk(KERN_DEBUG "set_cr0: 0x%lx #GP, reserved bits 0x%lx\n",
-		       cr0, guest_cr0());
+		       cr0, vcpu->cr0);
 		inject_gp(vcpu);
 		return;
 	}
@@ -936,7 +937,7 @@ static void set_cr0(struct kvm_vcpu *vcp
 		return;
 	}
 
-	if (!is_paging() && (cr0 & CR0_PG_MASK)) {
+	if (!is_paging(vcpu) && (cr0 & CR0_PG_MASK)) {
 #ifdef __x86_64__
 		if ((vcpu->shadow_efer & EFER_LME)) {
 			u32 guest_cs_ar;
@@ -975,7 +976,7 @@ static void set_cr0(struct kvm_vcpu *vcp
 
 static void lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
-	unsigned long cr0 = guest_cr0();
+	unsigned long cr0 = vcpu->cr0;
 
 	if ((msw & CR0_PE_MASK) && !(cr0 & CR0_PE_MASK)) {
 		enter_pmode(vcpu);
@@ -986,6 +987,7 @@ static void lmsw(struct kvm_vcpu *vcpu, 
 
 	vmcs_writel(GUEST_CR0, (vmcs_readl(GUEST_CR0) & ~LMSW_GUEST_MASK)
 				| (msw & LMSW_GUEST_MASK));
+	vcpu->cr0 = (vcpu->cr0 & ~0xfffful) | msw;
 }
 
 static void __set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -1011,7 +1013,7 @@ static void set_cr4(struct kvm_vcpu *vcp
 			inject_gp(vcpu);
 			return;
 		}
-	} else if (is_paging() && !is_pae(vcpu) && (cr4 & CR4_PAE_MASK)
+	} else if (is_paging(vcpu) && !is_pae(vcpu) && (cr4 & CR4_PAE_MASK)
 		   && pdptrs_have_reserved_bits_set(vcpu, vcpu->cr3)) {
 		printk(KERN_DEBUG "set_cr4: #GP, pdptrs reserved bits\n");
 		inject_gp(vcpu);
@@ -1042,7 +1044,7 @@ static void set_cr3(struct kvm_vcpu *vcp
 			inject_gp(vcpu);
 			return;
 		}
-		if (is_paging() && is_pae(vcpu) &&
+		if (is_paging(vcpu) && is_pae(vcpu) &&
 		    pdptrs_have_reserved_bits_set(vcpu, cr3)) {
 			printk(KERN_DEBUG "set_cr3: #GP, pdptrs "
 			       "reserved bits\n");
@@ -1898,7 +1900,7 @@ unsigned long realmode_get_cr(struct kvm
 {
 	switch (cr) {
 	case 0:
-		return guest_cr0();
+		return vcpu->cr0;
 	case 2:
 		return vcpu->cr2;
 	case 3:
@@ -1916,7 +1918,7 @@ void realmode_set_cr(struct kvm_vcpu *vc
 {
 	switch (cr) {
 	case 0:
-		set_cr0(vcpu, mk_cr_64(guest_cr0(), val));
+		set_cr0(vcpu, mk_cr_64(vcpu->cr0, val));
 		*rflags = vmcs_readl(GUEST_RFLAGS);
 		break;
 	case 2:
@@ -2265,7 +2267,8 @@ void set_efer(struct kvm_vcpu *vcpu, u64
 		return;
 	}
 
-	if (is_paging() && (vcpu->shadow_efer & EFER_LME) != (efer & EFER_LME)) {
+	if (is_paging(vcpu)
+	    && (vcpu->shadow_efer & EFER_LME) != (efer & EFER_LME)) {
 		printk(KERN_DEBUG "set_efer: #GP, change LME while paging\n");
 		inject_gp(vcpu);
 		return;
@@ -2843,7 +2846,7 @@ static int kvm_dev_ioctl_get_sregs(struc
 	get_dtable(gdt, GDTR);
 #undef get_dtable
 
-	sregs->cr0 = guest_cr0();
+	sregs->cr0 = vcpu->cr0;
 	sregs->cr2 = vcpu->cr2;
 	sregs->cr3 = vcpu->cr3;
 	sregs->cr4 = vcpu->cr4;
@@ -2907,12 +2910,13 @@ static int kvm_dev_ioctl_set_sregs(struc
 #endif
 	vcpu->apic_base = sregs->apic_base;
 
-	mmu_reset_needed |= guest_cr0() != sregs->cr0;
+	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
 	vcpu->rmode.active = ((sregs->cr0 & CR0_PE_MASK) == 0);
 	update_exception_bitmap(vcpu);
 	vmcs_writel(CR0_READ_SHADOW, sregs->cr0);
 	vmcs_writel(GUEST_CR0,
 		    (sregs->cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
+	vcpu->cr0 = sregs->cr0;
 
 	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
 	__set_cr4(vcpu, sregs->cr4);
diff -puN drivers/kvm/mmu.c~kvm-cache-guest-cr0-in-vcpu-structure drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-cache-guest-cr0-in-vcpu-structure
+++ a/drivers/kvm/mmu.c
@@ -138,9 +138,9 @@
 #define PT_DIRECTORY_LEVEL 2
 #define PT_PAGE_TABLE_LEVEL 1
 
-static int is_write_protection(void)
+static int is_write_protection(struct kvm_vcpu *vcpu)
 {
-	return guest_cr0() & CR0_WP_MASK;
+	return vcpu->cr0 & CR0_WP_MASK;
 }
 
 static int is_cpuid_PSE36(void)
@@ -321,7 +321,7 @@ static void nonpaging_flush(struct kvm_v
 	root = kvm_mmu_alloc_page(vcpu, 0);
 	ASSERT(VALID_PAGE(root));
 	vcpu->mmu.root_hpa = root;
-	if (is_paging())
+	if (is_paging(vcpu))
 		root |= (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK));
 	vmcs_writel(GUEST_CR3, root);
 }
@@ -614,7 +614,7 @@ static int init_kvm_mmu(struct kvm_vcpu 
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
 
-	if (!is_paging())
+	if (!is_paging(vcpu))
 		return nonpaging_init_context(vcpu);
 	else if (is_long_mode())
 		return paging64_init_context(vcpu);
diff -puN drivers/kvm/paging_tmpl.h~kvm-cache-guest-cr0-in-vcpu-structure drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-cache-guest-cr0-in-vcpu-structure
+++ a/drivers/kvm/paging_tmpl.h
@@ -251,7 +251,7 @@ static int FNAME(fix_write_pf)(struct kv
 		 * supervisor write protection is enabled.
 		 */
 		if (!writable_shadow) {
-			if (is_write_protection())
+			if (is_write_protection(vcpu))
 				return 0;
 			*shadow_ent &= ~PT_USER_MASK;
 		}
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

