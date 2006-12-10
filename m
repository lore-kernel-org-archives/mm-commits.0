From: akpm@osdl.org
Subject: - kvm-vcpu-creation-and-maintenance-segment-access-cleanup.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:52:32 -0800
Message-ID: <200612100752.kBA7qWkR017663@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760399AbWLJHwf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:52:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Segment access cleanup
has been removed from the -mm tree.  Its filename was
     kvm-vcpu-creation-and-maintenance-segment-access-cleanup.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: Segment access cleanup
From: Avi Kivity <avi@qumranet.com>

Instead of using pasting macros, put the vmx segment field indices into an
array and use the array to access the fields indirectly.  Cleaner code as well
as ~200 bytes saved.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    4 
 drivers/kvm/kvm_main.c |  256 ++++++++++++++++++++++-----------------
 2 files changed, 151 insertions(+), 109 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-vcpu-creation-and-maintenance-segment-access-cleanup drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-vcpu-creation-and-maintenance-segment-access-cleanup
+++ a/drivers/kvm/kvm.h
@@ -187,10 +187,10 @@ struct kvm_vcpu {
 	unsigned char mmio_data[8];
 	gpa_t mmio_phys_addr;
 
-	struct{
+	struct {
 		int active;
 		u8 save_iopl;
-		struct {
+		struct kvm_save_segment {
 			u16 selector;
 			unsigned long base;
 			u32 limit;
diff -puN drivers/kvm/kvm_main.c~kvm-vcpu-creation-and-maintenance-segment-access-cleanup drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-vcpu-creation-and-maintenance-segment-access-cleanup
+++ a/drivers/kvm/kvm_main.c
@@ -59,6 +59,41 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
+enum {
+	VCPU_SREG_CS,
+	VCPU_SREG_DS,
+	VCPU_SREG_ES,
+	VCPU_SREG_FS,
+	VCPU_SREG_GS,
+	VCPU_SREG_SS,
+	VCPU_SREG_TR,
+	VCPU_SREG_LDTR,
+};
+
+#define VMX_SEGMENT_FIELD(seg)					\
+	[VCPU_SREG_##seg] {                                     \
+		GUEST_##seg##_SELECTOR,				\
+		GUEST_##seg##_BASE,			   	\
+		GUEST_##seg##_LIMIT,			   	\
+		GUEST_##seg##_AR_BYTES,			   	\
+	}
+
+static struct kvm_vmx_segment_field {
+	unsigned selector;
+	unsigned base;
+	unsigned limit;
+	unsigned ar_bytes;
+} kvm_vmx_segment_fields[] = {
+	VMX_SEGMENT_FIELD(CS),
+	VMX_SEGMENT_FIELD(DS),
+	VMX_SEGMENT_FIELD(ES),
+	VMX_SEGMENT_FIELD(FS),
+	VMX_SEGMENT_FIELD(GS),
+	VMX_SEGMENT_FIELD(SS),
+	VMX_SEGMENT_FIELD(TR),
+	VMX_SEGMENT_FIELD(LDTR),
+};
+
 static const u32 vmx_msr_index[] = {
 	MSR_EFER, MSR_K6_STAR,
 #ifdef __x86_64__
@@ -683,6 +718,22 @@ static void update_exception_bitmap(stru
 		vmcs_write32(EXCEPTION_BITMAP, 1 << PF_VECTOR);
 }
 
+static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
+{
+	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+
+	if (vmcs_readl(sf->base) == save->base) {
+		vmcs_write16(sf->selector, save->selector);
+		vmcs_writel(sf->base, save->base);
+		vmcs_write32(sf->limit, save->limit);
+		vmcs_write32(sf->ar_bytes, save->ar);
+	} else {
+		u32 dpl = (vmcs_read16(sf->selector) & SELECTOR_RPL_MASK)
+			<< AR_DPL_SHIFT;
+		vmcs_write32(sf->ar_bytes, 0x93 | dpl);
+	}
+}
+
 static void enter_pmode(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
@@ -703,24 +754,10 @@ static void enter_pmode(struct kvm_vcpu 
 
 	update_exception_bitmap(vcpu);
 
-	#define FIX_PMODE_DATASEG(seg, save) {				\
-		if (vmcs_readl(GUEST_##seg##_BASE) == save.base) { \
-			vmcs_write16(GUEST_##seg##_SELECTOR, save.selector); \
-			vmcs_writel(GUEST_##seg##_BASE, save.base); \
-			vmcs_write32(GUEST_##seg##_LIMIT, save.limit); \
-			vmcs_write32(GUEST_##seg##_AR_BYTES, save.ar); \
-		} else { \
-			u32 dpl = (vmcs_read16(GUEST_##seg##_SELECTOR) & \
-				   SELECTOR_RPL_MASK) << AR_DPL_SHIFT; \
-			vmcs_write32(GUEST_##seg##_AR_BYTES, 0x93 | dpl); \
-		} \
-	}
-
-	FIX_PMODE_DATASEG(ES, vcpu->rmode.es);
-	FIX_PMODE_DATASEG(DS, vcpu->rmode.ds);
-	FIX_PMODE_DATASEG(GS, vcpu->rmode.gs);
-	FIX_PMODE_DATASEG(FS, vcpu->rmode.fs);
-
+	fix_pmode_dataseg(VCPU_SREG_ES, &vcpu->rmode.es);
+	fix_pmode_dataseg(VCPU_SREG_DS, &vcpu->rmode.ds);
+	fix_pmode_dataseg(VCPU_SREG_GS, &vcpu->rmode.gs);
+	fix_pmode_dataseg(VCPU_SREG_FS, &vcpu->rmode.fs);
 
 	vmcs_write16(GUEST_SS_SELECTOR, 0);
 	vmcs_write32(GUEST_SS_AR_BYTES, 0x93);
@@ -736,6 +773,19 @@ static int rmode_tss_base(struct kvm* kv
 	return base_gfn << PAGE_SHIFT;
 }
 
+static void fix_rmode_seg(int seg, struct kvm_save_segment *save)
+{
+	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+
+	save->selector = vmcs_read16(sf->selector);
+	save->base = vmcs_readl(sf->base);
+	save->limit = vmcs_read32(sf->limit);
+	save->ar = vmcs_read32(sf->ar_bytes);
+	vmcs_write16(sf->selector, vmcs_readl(sf->base) >> 4);
+	vmcs_write32(sf->limit, 0xffff);
+	vmcs_write32(sf->ar_bytes, 0xf3);
+}
+
 static void enter_rmode(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
@@ -760,17 +810,6 @@ static void enter_rmode(struct kvm_vcpu 
 	vmcs_writel(GUEST_CR4, vmcs_readl(GUEST_CR4) | CR4_VME_MASK);
 	update_exception_bitmap(vcpu);
 
-	#define FIX_RMODE_SEG(seg, save) { \
-		save.selector = vmcs_read16(GUEST_##seg##_SELECTOR); \
-		save.base = vmcs_readl(GUEST_##seg##_BASE); \
-		save.limit = vmcs_read32(GUEST_##seg##_LIMIT); \
-		save.ar = vmcs_read32(GUEST_##seg##_AR_BYTES); \
-		vmcs_write16(GUEST_##seg##_SELECTOR, 			   \
-					vmcs_readl(GUEST_##seg##_BASE) >> 4); \
-		vmcs_write32(GUEST_##seg##_LIMIT, 0xffff);		   \
-		vmcs_write32(GUEST_##seg##_AR_BYTES, 0xf3);		   \
-	}
-
 	vmcs_write16(GUEST_SS_SELECTOR, vmcs_readl(GUEST_SS_BASE) >> 4);
 	vmcs_write32(GUEST_SS_LIMIT, 0xffff);
 	vmcs_write32(GUEST_SS_AR_BYTES, 0xf3);
@@ -778,10 +817,10 @@ static void enter_rmode(struct kvm_vcpu 
 	vmcs_write32(GUEST_CS_AR_BYTES, 0xf3);
 	vmcs_write16(GUEST_CS_SELECTOR, vmcs_readl(GUEST_CS_BASE) >> 4);
 
-	FIX_RMODE_SEG(ES, vcpu->rmode.es);
-	FIX_RMODE_SEG(DS, vcpu->rmode.ds);
-	FIX_RMODE_SEG(GS, vcpu->rmode.gs);
-	FIX_RMODE_SEG(FS, vcpu->rmode.fs);
+	fix_rmode_seg(VCPU_SREG_ES, &vcpu->rmode.es);
+	fix_rmode_seg(VCPU_SREG_DS, &vcpu->rmode.ds);
+	fix_rmode_seg(VCPU_SREG_GS, &vcpu->rmode.gs);
+	fix_rmode_seg(VCPU_SREG_FS, &vcpu->rmode.fs);
 }
 
 static int init_rmode_tss(struct kvm* kvm)
@@ -1116,6 +1155,16 @@ static void vmcs_write32_fixedbits(u32 m
 	vmcs_write32(vmcs_field, val);
 }
 
+static void seg_setup(int seg)
+{
+	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+
+	vmcs_write16(sf->selector, 0);
+	vmcs_writel(sf->base, 0);
+	vmcs_write32(sf->limit, 0xffff);
+	vmcs_write32(sf->ar_bytes, 0x93);
+}
+
 /*
  * Sets up the vmcs for emulated real mode.
  */
@@ -1145,13 +1194,6 @@ static int kvm_vcpu_setup(struct kvm_vcp
 
 	fx_init(vcpu);
 
-#define SEG_SETUP(seg) do {					\
-		vmcs_write16(GUEST_##seg##_SELECTOR, 0);	\
-		vmcs_writel(GUEST_##seg##_BASE, 0);		\
-		vmcs_write32(GUEST_##seg##_LIMIT, 0xffff);	\
-		vmcs_write32(GUEST_##seg##_AR_BYTES, 0x93); 	\
-	} while (0)
-
 	/*
 	 * GUEST_CS_BASE should really be 0xffff0000, but VT vm86 mode
 	 * insists on having GUEST_CS_BASE == GUEST_CS_SELECTOR << 4.  Sigh.
@@ -1161,11 +1203,11 @@ static int kvm_vcpu_setup(struct kvm_vcp
 	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
 	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
 
-	SEG_SETUP(DS);
-	SEG_SETUP(ES);
-	SEG_SETUP(FS);
-	SEG_SETUP(GS);
-	SEG_SETUP(SS);
+	seg_setup(VCPU_SREG_DS);
+	seg_setup(VCPU_SREG_ES);
+	seg_setup(VCPU_SREG_FS);
+	seg_setup(VCPU_SREG_GS);
+	seg_setup(VCPU_SREG_SS);
 
 	vmcs_write16(GUEST_TR_SELECTOR, 0);
 	vmcs_writel(GUEST_TR_BASE, 0);
@@ -1842,6 +1884,28 @@ static int kvm_dev_ioctl_set_regs(struct
 	return 0;
 }
 
+static void get_segment(struct kvm_segment *var, int seg)
+{
+	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+	u32 ar;
+
+	var->base = vmcs_readl(sf->base);
+	var->limit = vmcs_read32(sf->limit);
+	var->selector = vmcs_read16(sf->selector);
+	ar = vmcs_read32(sf->ar_bytes);
+	if (ar & AR_UNUSABLE_MASK)
+		ar = 0;
+	var->type = ar & 15;
+	var->s = (ar >> 4) & 1;
+	var->dpl = (ar >> 5) & 3;
+	var->present = (ar >> 7) & 1;
+	var->avl = (ar >> 12) & 1;
+	var->l = (ar >> 13) & 1;
+	var->db = (ar >> 14) & 1;
+	var->g = (ar >> 15) & 1;
+	var->unusable = (ar >> 16) & 1;
+}
+
 static int kvm_dev_ioctl_get_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
 {
 	struct kvm_vcpu *vcpu;
@@ -1852,36 +1916,15 @@ static int kvm_dev_ioctl_get_sregs(struc
 	if (!vcpu)
 		return -ENOENT;
 
-#define get_segment(var, seg) \
-	do { \
-		u32 ar; \
-		\
-		sregs->var.base = vmcs_readl(GUEST_##seg##_BASE); \
-		sregs->var.limit = vmcs_read32(GUEST_##seg##_LIMIT); \
-		sregs->var.selector = vmcs_read16(GUEST_##seg##_SELECTOR); \
-		ar = vmcs_read32(GUEST_##seg##_AR_BYTES); \
-		if (ar & AR_UNUSABLE_MASK) ar = 0; \
-		sregs->var.type = ar & 15; \
-		sregs->var.s = (ar >> 4) & 1; \
-		sregs->var.dpl = (ar >> 5) & 3; \
-		sregs->var.present = (ar >> 7) & 1; \
-		sregs->var.avl = (ar >> 12) & 1; \
-		sregs->var.l = (ar >> 13) & 1; \
-		sregs->var.db = (ar >> 14) & 1; \
-		sregs->var.g = (ar >> 15) & 1; \
-		sregs->var.unusable = (ar >> 16) & 1; \
-	} while (0);
-
-	get_segment(cs, CS);
-	get_segment(ds, DS);
-	get_segment(es, ES);
-	get_segment(fs, FS);
-	get_segment(gs, GS);
-	get_segment(ss, SS);
-
-	get_segment(tr, TR);
-	get_segment(ldt, LDTR);
-#undef get_segment
+	get_segment(&sregs->cs, VCPU_SREG_CS);
+	get_segment(&sregs->ds, VCPU_SREG_DS);
+	get_segment(&sregs->es, VCPU_SREG_ES);
+	get_segment(&sregs->fs, VCPU_SREG_FS);
+	get_segment(&sregs->gs, VCPU_SREG_GS);
+	get_segment(&sregs->ss, VCPU_SREG_SS);
+
+	get_segment(&sregs->tr, VCPU_SREG_TR);
+	get_segment(&sregs->ldt, VCPU_SREG_LDTR);
 
 #define get_dtable(var, table) \
 	sregs->var.limit = vmcs_read32(GUEST_##table##_LIMIT), \
@@ -1906,6 +1949,29 @@ static int kvm_dev_ioctl_get_sregs(struc
 	return 0;
 }
 
+static void set_segment(struct kvm_segment *var, int seg)
+{
+	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+	u32 ar;
+
+	vmcs_writel(sf->base, var->base);
+	vmcs_write32(sf->limit, var->limit);
+	vmcs_write16(sf->selector, var->selector);
+	if (var->unusable)
+		ar = 1 << 16;
+	else {
+		ar = var->type & 15;
+		ar |= (var->s & 1) << 4;
+		ar |= (var->dpl & 3) << 5;
+		ar |= (var->present & 1) << 7;
+		ar |= (var->avl & 1) << 12;
+		ar |= (var->l & 1) << 13;
+		ar |= (var->db & 1) << 14;
+		ar |= (var->g & 1) << 15;
+	}
+	vmcs_write32(sf->ar_bytes, ar);
+}
+
 static int kvm_dev_ioctl_set_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
 {
 	struct kvm_vcpu *vcpu;
@@ -1917,39 +1983,15 @@ static int kvm_dev_ioctl_set_sregs(struc
 	if (!vcpu)
 		return -ENOENT;
 
-#define set_segment(var, seg) \
-	do { \
-		u32 ar; \
-		\
-		vmcs_writel(GUEST_##seg##_BASE, sregs->var.base);  \
-		vmcs_write32(GUEST_##seg##_LIMIT, sregs->var.limit); \
-		vmcs_write16(GUEST_##seg##_SELECTOR, sregs->var.selector); \
-		if (sregs->var.unusable) { \
-			ar = (1 << 16); \
-		} else { \
-			ar = (sregs->var.type & 15); \
-			ar |= (sregs->var.s & 1) << 4; \
-			ar |= (sregs->var.dpl & 3) << 5; \
-			ar |= (sregs->var.present & 1) << 7; \
-			ar |= (sregs->var.avl & 1) << 12; \
-			ar |= (sregs->var.l & 1) << 13; \
-			ar |= (sregs->var.db & 1) << 14; \
-			ar |= (sregs->var.g & 1) << 15; \
-		} \
-		vmcs_write32(GUEST_##seg##_AR_BYTES, ar); \
-	} while (0);
-
-	set_segment(cs, CS);
-	set_segment(ds, DS);
-	set_segment(es, ES);
-	set_segment(fs, FS);
-	set_segment(gs, GS);
-	set_segment(ss, SS);
-
-	set_segment(tr, TR);
+	set_segment(&sregs->cs, VCPU_SREG_CS);
+	set_segment(&sregs->ds, VCPU_SREG_DS);
+	set_segment(&sregs->es, VCPU_SREG_ES);
+	set_segment(&sregs->fs, VCPU_SREG_FS);
+	set_segment(&sregs->gs, VCPU_SREG_GS);
+	set_segment(&sregs->ss, VCPU_SREG_SS);
 
-	set_segment(ldt, LDTR);
-#undef set_segment
+	set_segment(&sregs->tr, VCPU_SREG_TR);
+	set_segment(&sregs->ldt, VCPU_SREG_LDTR);
 
 #define set_dtable(var, table) \
 	vmcs_write32(GUEST_##table##_LIMIT, sregs->var.limit), \
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

