From: akpm@osdl.org
Subject: - kvm-make-is_long_mode-an-arch-operation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:21 -0800
Message-ID: <200612100755.kBA7tLjK017867@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59827 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760571AbWLJHzY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make is_long_mode() an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-make-is_long_mode-an-arch-operation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make is_long_mode() an arch operation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h         |    6 +-----
 drivers/kvm/kvm_main.c    |    4 ++--
 drivers/kvm/mmu.c         |    2 +-
 drivers/kvm/paging_tmpl.h |    6 +++---
 drivers/kvm/vmx.c         |    6 ++++++
 5 files changed, 13 insertions(+), 11 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-is_long_mode-an-arch-operation drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-is_long_mode-an-arch-operation
+++ a/drivers/kvm/kvm.h
@@ -275,6 +275,7 @@ struct kvm_arch_ops {
 			    struct kvm_segment *var, int seg);
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
+	int (*is_long_mode)(struct kvm_vcpu *vcpu);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr0_no_modeswitch)(struct kvm_vcpu *vcpu,
@@ -411,11 +412,6 @@ static inline void vmcs_write32(unsigned
 	vmcs_writel(field, value);
 }
 
-static inline int is_long_mode(void)
-{
-	return vmcs_read32(VM_ENTRY_CONTROLS) & VM_ENTRY_CONTROLS_IA32E_MASK;
-}
-
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
 	return vcpu->cr4 & CR4_PAE_MASK;
diff -puN drivers/kvm/kvm_main.c~kvm-make-is_long_mode-an-arch-operation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-is_long_mode-an-arch-operation
+++ a/drivers/kvm/kvm_main.c
@@ -426,7 +426,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsi
 		return;
 	}
 
-	if (is_long_mode()) {
+	if (kvm_arch_ops->is_long_mode(vcpu)) {
 		if (!(cr4 & CR4_PAE_MASK)) {
 			printk(KERN_DEBUG "set_cr4: #GP, clearing PAE while "
 			       "in long mode\n");
@@ -453,7 +453,7 @@ EXPORT_SYMBOL_GPL(set_cr4);
 
 void set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
-	if (is_long_mode()) {
+	if (kvm_arch_ops->is_long_mode(vcpu)) {
 		if ( cr3 & CR3_L_MODE_RESEVED_BITS) {
 			printk(KERN_DEBUG "set_cr3: #GP, reserved bits\n");
 			inject_gp(vcpu);
diff -puN drivers/kvm/mmu.c~kvm-make-is_long_mode-an-arch-operation drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-make-is_long_mode-an-arch-operation
+++ a/drivers/kvm/mmu.c
@@ -589,7 +589,7 @@ static int init_kvm_mmu(struct kvm_vcpu 
 
 	if (!is_paging(vcpu))
 		return nonpaging_init_context(vcpu);
-	else if (is_long_mode())
+	else if (kvm_arch_ops->is_long_mode(vcpu))
 		return paging64_init_context(vcpu);
 	else if (is_pae(vcpu))
 		return paging32E_init_context(vcpu);
diff -puN drivers/kvm/paging_tmpl.h~kvm-make-is_long_mode-an-arch-operation drivers/kvm/paging_tmpl.h
--- a/drivers/kvm/paging_tmpl.h~kvm-make-is_long_mode-an-arch-operation
+++ a/drivers/kvm/paging_tmpl.h
@@ -70,7 +70,7 @@ static void FNAME(init_walker)(struct gu
 	hpa = safe_gpa_to_hpa(vcpu, vcpu->cr3 & PT64_BASE_ADDR_MASK);
 	walker->table = kmap_atomic(pfn_to_page(hpa >> PAGE_SHIFT), KM_USER0);
 
-	ASSERT((!is_long_mode() && is_pae(vcpu)) ||
+	ASSERT((!kvm_arch_ops->is_long_mode(vcpu) && is_pae(vcpu)) ||
 	       (vcpu->cr3 & ~(PAGE_MASK | CR3_FLAGS_MASK)) == 0);
 
 	walker->table = (pt_element_t *)( (unsigned long)walker->table |
@@ -135,7 +135,7 @@ static pt_element_t *FNAME(fetch_guest)(
 		     (walker->table[index] & PT_PAGE_SIZE_MASK) &&
 		     (PTTYPE == 64 || is_pse(vcpu))))
 			return &walker->table[index];
-		if (walker->level != 3 || is_long_mode())
+		if (walker->level != 3 || kvm_arch_ops->is_long_mode(vcpu))
 			walker->inherited_ar &= walker->table[index];
 		paddr = safe_gpa_to_hpa(vcpu, walker->table[index] & PT_BASE_ADDR_MASK);
 		kunmap_atomic(walker->table, KM_USER0);
@@ -204,7 +204,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu
 		shadow_addr = kvm_mmu_alloc_page(vcpu, shadow_ent);
 		if (!VALID_PAGE(shadow_addr))
 			return ERR_PTR(-ENOMEM);
-		if (!is_long_mode() && level == 3)
+		if (!kvm_arch_ops->is_long_mode(vcpu) && level == 3)
 			*shadow_ent = shadow_addr |
 				(*guest_ent & (PT_PRESENT_MASK | PT_PWT_MASK | PT_PCD_MASK));
 		else {
diff -puN drivers/kvm/vmx.c~kvm-make-is_long_mode-an-arch-operation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-is_long_mode-an-arch-operation
+++ a/drivers/kvm/vmx.c
@@ -813,6 +813,11 @@ static void vmx_set_segment(struct kvm_v
 	vmcs_write32(sf->ar_bytes, ar);
 }
 
+static int vmx_is_long_mode(struct kvm_vcpu *vcpu)
+{
+	return vmcs_read32(VM_ENTRY_CONTROLS) & VM_ENTRY_CONTROLS_IA32E_MASK;
+}
+
 static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 {
 	u32 ar = vmcs_read32(GUEST_CS_AR_BYTES);
@@ -1886,6 +1891,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
+	.is_long_mode = vmx_is_long_mode,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr0_no_modeswitch = vmx_set_cr0_no_modeswitch,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

