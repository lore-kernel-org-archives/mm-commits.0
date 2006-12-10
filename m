From: akpm@osdl.org
Subject: - kvm-random-accessors-and-constants.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:51:58 -0800
Message-ID: <200612100751.kBA7pxxf017614@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760365AbWLJHwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, yaniv@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: random accessors and constants
has been removed from the -mm tree.  Its filename was
     kvm-random-accessors-and-constants.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: kvm: random accessors and constants
From: Avi Kivity <avi@qumranet.com>

Define some constants and accessors to be used later on.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |  166 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)

diff -puN drivers/kvm/kvm.h~kvm-random-accessors-and-constants drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-random-accessors-and-constants
+++ a/drivers/kvm/kvm.h
@@ -7,6 +7,38 @@
 #include <linux/spinlock.h>
 #include <linux/mm.h>
 
+#include "vmx.h"
+
+#define CR0_PE_MASK (1ULL << 0)
+#define CR0_TS_MASK (1ULL << 3)
+#define CR0_NE_MASK (1ULL << 5)
+#define CR0_WP_MASK (1ULL << 16)
+#define CR0_NW_MASK (1ULL << 29)
+#define CR0_CD_MASK (1ULL << 30)
+#define CR0_PG_MASK (1ULL << 31)
+
+#define CR3_WPT_MASK (1ULL << 3)
+#define CR3_PCD_MASK (1ULL << 4)
+
+#define CR3_RESEVED_BITS 0x07ULL
+#define CR3_L_MODE_RESEVED_BITS (~((1ULL << 40) - 1) | 0x0fe7ULL)
+#define CR3_FLAGS_MASK ((1ULL << 5) - 1)
+
+#define CR4_VME_MASK (1ULL << 0)
+#define CR4_PSE_MASK (1ULL << 4)
+#define CR4_PAE_MASK (1ULL << 5)
+#define CR4_PGE_MASK (1ULL << 7)
+#define CR4_VMXE_MASK (1ULL << 13)
+
+#define KVM_GUEST_CR0_MASK \
+	(CR0_PG_MASK | CR0_PE_MASK | CR0_WP_MASK | CR0_NE_MASK)
+#define KVM_VM_CR0_ALWAYS_ON KVM_GUEST_CR0_MASK
+
+#define KVM_GUEST_CR4_MASK \
+	(CR4_PSE_MASK | CR4_PAE_MASK | CR4_PGE_MASK | CR4_VMXE_MASK | CR4_VME_MASK)
+#define KVM_PMODE_VM_CR4_ALWAYS_ON (CR4_VMXE_MASK | CR4_PAE_MASK)
+#define KVM_RMODE_VM_CR4_ALWAYS_ON (CR4_VMXE_MASK | CR4_PAE_MASK | CR4_VME_MASK)
+
 #define INVALID_PAGE (~(hpa_t)0)
 #define UNMAPPED_GVA (~(gpa_t)0)
 
@@ -18,6 +50,19 @@
 #define FX_IMAGE_ALIGN 16
 #define FX_BUF_SIZE (2 * FX_IMAGE_SIZE + FX_IMAGE_ALIGN)
 
+#define DE_VECTOR 0
+#define DF_VECTOR 8
+#define TS_VECTOR 10
+#define NP_VECTOR 11
+#define SS_VECTOR 12
+#define GP_VECTOR 13
+#define PF_VECTOR 14
+
+#define SELECTOR_TI_MASK (1 << 2)
+#define SELECTOR_RPL_MASK 0x03
+
+#define IOPL_SHIFT 12
+
 /*
  * Address types:
  *
@@ -203,4 +248,125 @@ hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, 
 
 extern hpa_t bad_page_address;
 
+static inline struct page *gfn_to_page(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return slot->phys_mem[gfn - slot->base_gfn];
+}
+
+struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
+void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
+
+void realmode_lgdt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
+void realmode_lidt(struct kvm_vcpu *vcpu, u16 size, unsigned long address);
+void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
+		   unsigned long *rflags);
+
+unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr);
+void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long value,
+		     unsigned long *rflags);
+
+int kvm_read_guest(struct kvm_vcpu *vcpu,
+	       gva_t addr,
+	       unsigned long size,
+	       void *dest);
+
+int kvm_write_guest(struct kvm_vcpu *vcpu,
+		gva_t addr,
+		unsigned long size,
+		void *data);
+
+void vmcs_writel(unsigned long field, unsigned long value);
+unsigned long vmcs_readl(unsigned long field);
+
+static inline u16 vmcs_read16(unsigned long field)
+{
+	return vmcs_readl(field);
+}
+
+static inline u32 vmcs_read32(unsigned long field)
+{
+	return vmcs_readl(field);
+}
+
+static inline u64 vmcs_read64(unsigned long field)
+{
+#ifdef __x86_64__
+	return vmcs_readl(field);
+#else
+	return vmcs_readl(field) | ((u64)vmcs_readl(field+1) << 32);
+#endif
+}
+
+static inline void vmcs_write32(unsigned long field, u32 value)
+{
+	vmcs_writel(field, value);
+}
+
+static inline int is_long_mode(void)
+{
+	return vmcs_read32(VM_ENTRY_CONTROLS) & VM_ENTRY_CONTROLS_IA32E_MASK;
+}
+
+static inline unsigned long guest_cr4(void)
+{
+	return (vmcs_readl(CR4_READ_SHADOW) & KVM_GUEST_CR4_MASK) |
+		(vmcs_readl(GUEST_CR4) & ~KVM_GUEST_CR4_MASK);
+}
+
+static inline int is_pae(void)
+{
+	return guest_cr4() & CR4_PAE_MASK;
+}
+
+static inline int is_pse(void)
+{
+	return guest_cr4() & CR4_PSE_MASK;
+}
+
+static inline unsigned long guest_cr0(void)
+{
+	return (vmcs_readl(CR0_READ_SHADOW) & KVM_GUEST_CR0_MASK) |
+		(vmcs_readl(GUEST_CR0) & ~KVM_GUEST_CR0_MASK);
+}
+
+static inline unsigned guest_cpl(void)
+{
+	return vmcs_read16(GUEST_CS_SELECTOR) & SELECTOR_RPL_MASK;
+}
+
+static inline int is_paging(void)
+{
+	return guest_cr0() & CR0_PG_MASK;
+}
+
+static inline int is_page_fault(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
+			     INTR_INFO_VALID_MASK)) ==
+		(INTR_TYPE_EXCEPTION | PF_VECTOR | INTR_INFO_VALID_MASK);
+}
+
+static inline int is_external_interrupt(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
+		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
+}
+
+static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
+{
+	vmcs_writel(GUEST_CR3, vmcs_readl(GUEST_CR3));
+}
+
+static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	return slot - kvm->memslots;
+}
+
+static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
+{
+	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
+
+	return (struct kvm_mmu_page *)page->private;
+}
+
 #endif
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-random-accessors-and-constants.patch
kvm-virtualization-infrastructure.patch
kvm-virtualization-infrastructure-kvm-fix-guest-cr4-corruption.patch
kvm-virtualization-infrastructure-include-desch.patch
kvm-virtualization-infrastructure-fix-segment-state-changes-across-processor-mode-switches.patch
kvm-virtualization-infrastructure-fix-asm-constraints-for-segment-loads.patch
kvm-virtualization-infrastructure-fix-mmu-reset-locking-when-setting-cr0.patch
kvm-memory-slot-management.patch
kvm-memory-slot-management-zero-guest-memory-before-use.patch
kvm-vcpu-creation-and-maintenance.patch
kvm-vcpu-creation-and-maintenance-segment-access-cleanup.patch
kvm-workaround-cr0cd-cache-disable-bit-leak-from-guest-to.patch
kvm-vcpu-execution-loop.patch
kvm-define-exit-handlers.patch
kvm-define-exit-handlers-pass-fs-gs-segment-bases-to-x86-emulator.patch
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

