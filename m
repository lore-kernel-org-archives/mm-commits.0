From: akpm@osdl.org
Subject: - kvm-kvm-data-structures.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:51:55 -0800
Message-ID: <200612100751.kBA7pt2j017611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760372AbWLJHv6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:51:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, yaniv@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: kvm data structures
has been removed from the -mm tree.  Its filename was
     kvm-kvm-data-structures.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: kvm: kvm data structures
From: Avi Kivity <avi@qumranet.com>

Define data structures and some constants for a virtual machine.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |  206 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

diff -puN /dev/null drivers/kvm/kvm.h
--- /dev/null
+++ a/drivers/kvm/kvm.h
@@ -0,0 +1,206 @@
+#ifndef __KVM_H
+#define __KVM_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/mm.h>
+
+#define INVALID_PAGE (~(hpa_t)0)
+#define UNMAPPED_GVA (~(gpa_t)0)
+
+#define KVM_MAX_VCPUS 1
+#define KVM_MEMORY_SLOTS 4
+#define KVM_NUM_MMU_PAGES 256
+
+#define FX_IMAGE_SIZE 512
+#define FX_IMAGE_ALIGN 16
+#define FX_BUF_SIZE (2 * FX_IMAGE_SIZE + FX_IMAGE_ALIGN)
+
+/*
+ * Address types:
+ *
+ *  gva - guest virtual address
+ *  gpa - guest physical address
+ *  gfn - guest frame number
+ *  hva - host virtual address
+ *  hpa - host physical address
+ *  hfn - host frame number
+ */
+
+typedef unsigned long  gva_t;
+typedef u64            gpa_t;
+typedef unsigned long  gfn_t;
+
+typedef unsigned long  hva_t;
+typedef u64            hpa_t;
+typedef unsigned long  hfn_t;
+
+struct kvm_mmu_page {
+	struct list_head link;
+	hpa_t page_hpa;
+	unsigned long slot_bitmap; /* One bit set per slot which has memory
+				    * in this shadow page.
+				    */
+	int global;              /* Set if all ptes in this page are global */
+	u64 *parent_pte;
+};
+
+struct vmcs {
+	u32 revision_id;
+	u32 abort;
+	char data[0];
+};
+
+struct vmx_msr_entry {
+	u32 index;
+	u32 reserved;
+	u64 data;
+};
+
+struct kvm_vcpu;
+
+/*
+ * x86 supports 3 paging modes (4-level 64-bit, 3-level 64-bit, and 2-level
+ * 32-bit).  The kvm_mmu structure abstracts the details of the current mmu
+ * mode.
+ */
+struct kvm_mmu {
+	void (*new_cr3)(struct kvm_vcpu *vcpu);
+	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
+	void (*inval_page)(struct kvm_vcpu *vcpu, gva_t gva);
+	void (*free)(struct kvm_vcpu *vcpu);
+	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva);
+	hpa_t root_hpa;
+	int root_level;
+	int shadow_root_level;
+};
+
+struct kvm_guest_debug {
+	int enabled;
+	unsigned long bp[4];
+	int singlestep;
+};
+
+enum {
+	VCPU_REGS_RAX = 0,
+	VCPU_REGS_RCX = 1,
+	VCPU_REGS_RDX = 2,
+	VCPU_REGS_RBX = 3,
+	VCPU_REGS_RSP = 4,
+	VCPU_REGS_RBP = 5,
+	VCPU_REGS_RSI = 6,
+	VCPU_REGS_RDI = 7,
+#ifdef __x86_64__
+	VCPU_REGS_R8 = 8,
+	VCPU_REGS_R9 = 9,
+	VCPU_REGS_R10 = 10,
+	VCPU_REGS_R11 = 11,
+	VCPU_REGS_R12 = 12,
+	VCPU_REGS_R13 = 13,
+	VCPU_REGS_R14 = 14,
+	VCPU_REGS_R15 = 15,
+#endif
+	NR_VCPU_REGS
+};
+
+struct kvm_vcpu {
+	struct kvm *kvm;
+	struct vmcs *vmcs;
+	struct mutex mutex;
+	int   cpu;
+	int   launched;
+	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
+#define NR_IRQ_WORDS (256 / BITS_PER_LONG)
+	unsigned long irq_pending[NR_IRQ_WORDS];
+	unsigned long regs[NR_VCPU_REGS]; /* for rsp: vcpu_load_rsp_rip() */
+	unsigned long rip;      /* needs vcpu_load_rsp_rip() */
+
+	unsigned long cr2;
+	unsigned long cr3;
+	unsigned long cr8;
+	u64 shadow_efer;
+	u64 apic_base;
+	struct vmx_msr_entry *guest_msrs;
+	struct vmx_msr_entry *host_msrs;
+
+	struct list_head free_pages;
+	struct kvm_mmu_page page_header_buf[KVM_NUM_MMU_PAGES];
+	struct kvm_mmu mmu;
+
+	struct kvm_guest_debug guest_debug;
+
+	char fx_buf[FX_BUF_SIZE];
+	char *host_fx_image;
+	char *guest_fx_image;
+
+	int mmio_needed;
+	int mmio_read_completed;
+	int mmio_is_write;
+	int mmio_size;
+	unsigned char mmio_data[8];
+	gpa_t mmio_phys_addr;
+
+	struct{
+		int active;
+		u8 save_iopl;
+		struct {
+			unsigned long base;
+			u32 limit;
+			u32 ar;
+		} tr;
+	} rmode;
+};
+
+struct kvm_memory_slot {
+	gfn_t base_gfn;
+	unsigned long npages;
+	unsigned long flags;
+	struct page **phys_mem;
+	unsigned long *dirty_bitmap;
+};
+
+struct kvm {
+	spinlock_t lock; /* protects everything except vcpus */
+	int nmemslots;
+	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS];
+	struct list_head active_mmu_pages;
+	struct kvm_vcpu vcpus[KVM_MAX_VCPUS];
+	int memory_config_version;
+	int busy;
+};
+
+struct kvm_stat {
+	u32 pf_fixed;
+	u32 pf_guest;
+	u32 tlb_flush;
+	u32 invlpg;
+
+	u32 exits;
+	u32 io_exits;
+	u32 mmio_exits;
+	u32 signal_exits;
+	u32 irq_exits;
+};
+
+extern struct kvm_stat kvm_stat;
+
+#define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
+#define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
+
+void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
+int kvm_mmu_init(struct kvm_vcpu *vcpu);
+
+int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
+void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
+
+hpa_t gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa);
+#define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
+#define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
+static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
+hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva);
+
+extern hpa_t bad_page_address;
+
+#endif
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-kvm-data-structures.patch
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

