From: akpm@osdl.org
Subject: - kvm-add-get_segment_base-arch-accessor.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:12 -0800
Message-ID: <200612100754.kBA7sC4k017777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760337AbWLJHyO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: add get_segment_base() arch accessor
has been removed from the -mm tree.  Its filename was
     kvm-add-get_segment_base-arch-accessor.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: add get_segment_base() arch accessor
From: Avi Kivity <avi@qumranet.com>

This could have been implemented in terms of the existing get_segment(), but
that make unnecessary vmx accesses.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   21 ++++++++++++++-------
 drivers/kvm/vmx.c      |    8 ++++++++
 3 files changed, 23 insertions(+), 7 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-add-get_segment_base-arch-accessor drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-add-get_segment_base-arch-accessor
+++ a/drivers/kvm/kvm.h
@@ -248,6 +248,7 @@ struct kvm_arch_ops {
 			       struct kvm_debug_guest *dbg);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
 	int (*set_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
+	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*set_segment)(struct kvm_vcpu *vcpu,
diff -puN drivers/kvm/kvm_main.c~kvm-add-get_segment_base-arch-accessor drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-get_segment_base-arch-accessor
+++ a/drivers/kvm/kvm_main.c
@@ -1777,12 +1777,19 @@ static int emulator_cmpxchg_emulated(uns
 	return emulator_write_emulated(addr, new, bytes, ctxt);
 }
 
+static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
+{
+	return kvm_arch_ops->get_segment_base(vcpu, seg);
+}
+
 static void report_emulation_failure(struct x86_emulate_ctxt *ctxt)
 {
 	static int reported;
 	u8 opcodes[4];
 	unsigned long rip = vmcs_readl(GUEST_RIP);
-	unsigned long rip_linear = rip + vmcs_readl(GUEST_CS_BASE);
+	unsigned long rip_linear;
+
+	rip_linear = rip + get_segment_base(ctxt->vcpu, VCPU_SREG_CS);
 
 	if (reported)
 		return;
@@ -1836,14 +1843,14 @@ static int emulate_instruction(struct kv
 		emulate_ctxt.es_base = 0;
 		emulate_ctxt.ss_base = 0;
 	} else {
-		emulate_ctxt.cs_base = vmcs_readl(GUEST_CS_BASE);
-		emulate_ctxt.ds_base = vmcs_readl(GUEST_DS_BASE);
-		emulate_ctxt.es_base = vmcs_readl(GUEST_ES_BASE);
-		emulate_ctxt.ss_base = vmcs_readl(GUEST_SS_BASE);
+		emulate_ctxt.cs_base = get_segment_base(vcpu, VCPU_SREG_CS);
+		emulate_ctxt.ds_base = get_segment_base(vcpu, VCPU_SREG_DS);
+		emulate_ctxt.es_base = get_segment_base(vcpu, VCPU_SREG_ES);
+		emulate_ctxt.ss_base = get_segment_base(vcpu, VCPU_SREG_SS);
 	}
 
-	emulate_ctxt.gs_base = vmcs_readl(GUEST_GS_BASE);
-	emulate_ctxt.fs_base = vmcs_readl(GUEST_FS_BASE);
+	emulate_ctxt.gs_base = get_segment_base(vcpu, VCPU_SREG_GS);
+	emulate_ctxt.fs_base = get_segment_base(vcpu, VCPU_SREG_FS);
 
 	vcpu->mmio_is_write = 0;
 	r = x86_emulate_memop(&emulate_ctxt, &emulate_ops);
diff -puN drivers/kvm/vmx.c~kvm-add-get_segment_base-arch-accessor drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-get_segment_base-arch-accessor
+++ a/drivers/kvm/vmx.c
@@ -309,6 +309,13 @@ static __exit void hardware_unsetup(void
 	free_kvm_area();
 }
 
+static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+{
+	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+
+	return vmcs_readl(sf->base);
+}
+
 static void vmx_get_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
@@ -367,6 +374,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.set_guest_debug = set_guest_debug,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
+	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
 };
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

