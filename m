From: akpm@osdl.org
Subject: - kvm-access-rflags-through-an-arch-operation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:02 -0800
Message-ID: <200612100755.kBA7t29A017839@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59783 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760556AbWLJHzF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: access rflags through an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-access-rflags-through-an-arch-operation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: access rflags through an arch operation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    2 ++
 drivers/kvm/kvm_main.c |   12 ++++++------
 drivers/kvm/vmx.c      |   12 ++++++++++++
 3 files changed, 20 insertions(+), 6 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-access-rflags-through-an-arch-operation drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-access-rflags-through-an-arch-operation
+++ a/drivers/kvm/kvm.h
@@ -279,6 +279,8 @@ struct kvm_arch_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*cache_regs)(struct kvm_vcpu *vcpu);
 	void (*decache_regs)(struct kvm_vcpu *vcpu);
+	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
+	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 
 	void (*flush_tlb)(struct kvm_vcpu *vcpu);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
diff -puN drivers/kvm/kvm_main.c~kvm-access-rflags-through-an-arch-operation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-access-rflags-through-an-arch-operation
+++ a/drivers/kvm/kvm_main.c
@@ -1127,7 +1127,7 @@ int emulate_instruction(struct kvm_vcpu 
 	cs_ar = vmcs_read32(GUEST_CS_AR_BYTES);
 
 	emulate_ctxt.vcpu = vcpu;
-	emulate_ctxt.eflags = vmcs_readl(GUEST_RFLAGS);
+	emulate_ctxt.eflags = kvm_arch_ops->get_rflags(vcpu);
 	emulate_ctxt.cr2 = cr2;
 	emulate_ctxt.mode = (emulate_ctxt.eflags & X86_EFLAGS_VM)
 		? X86EMUL_MODE_REAL : (cs_ar & AR_L_MASK)
@@ -1168,7 +1168,7 @@ int emulate_instruction(struct kvm_vcpu 
 	}
 
 	kvm_arch_ops->decache_regs(vcpu);
-	vmcs_writel(GUEST_RFLAGS, emulate_ctxt.eflags);
+	kvm_arch_ops->set_rflags(vcpu, emulate_ctxt.eflags);
 
 	if (vcpu->mmio_is_write)
 		return EMULATE_DO_MMIO;
@@ -1200,7 +1200,7 @@ void realmode_lmsw(struct kvm_vcpu *vcpu
 		   unsigned long *rflags)
 {
 	lmsw(vcpu, msw);
-	*rflags = vmcs_readl(GUEST_RFLAGS);
+	*rflags = kvm_arch_ops->get_rflags(vcpu);
 }
 
 unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
@@ -1226,7 +1226,7 @@ void realmode_set_cr(struct kvm_vcpu *vc
 	switch (cr) {
 	case 0:
 		set_cr0(vcpu, mk_cr_64(vcpu->cr0, val));
-		*rflags = vmcs_readl(GUEST_RFLAGS);
+		*rflags = kvm_arch_ops->get_rflags(vcpu);
 		break;
 	case 2:
 		vcpu->cr2 = val;
@@ -1387,7 +1387,7 @@ static int kvm_dev_ioctl_get_regs(struct
 #endif
 
 	regs->rip = vcpu->rip;
-	regs->rflags = vmcs_readl(GUEST_RFLAGS);
+	regs->rflags = kvm_arch_ops->get_rflags(vcpu);
 
 	/*
 	 * Don't leak debug flags in case they were set for guest debugging
@@ -1431,7 +1431,7 @@ static int kvm_dev_ioctl_set_regs(struct
 #endif
 
 	vcpu->rip = regs->rip;
-	vmcs_writel(GUEST_RFLAGS, regs->rflags);
+	kvm_arch_ops->set_rflags(vcpu, regs->rflags);
 
 	kvm_arch_ops->decache_regs(vcpu);
 
diff -puN drivers/kvm/vmx.c~kvm-access-rflags-through-an-arch-operation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-access-rflags-through-an-arch-operation
+++ a/drivers/kvm/vmx.c
@@ -61,6 +61,16 @@ static const u32 vmx_msr_index[] = {
 
 struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr);
 
+static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
+{
+	return vmcs_readl(GUEST_RFLAGS);
+}
+
+static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
+{
+	vmcs_writel(GUEST_RFLAGS, rflags);
+}
+
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	unsigned long rip;
@@ -1717,6 +1727,8 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.set_gdt = vmx_set_gdt,
 	.cache_regs = vcpu_load_rsp_rip,
 	.decache_regs = vcpu_put_rsp_rip,
+	.get_rflags = vmx_get_rflags,
+	.set_rflags = vmx_set_rflags,
 
 	.flush_tlb = vmx_flush_tlb,
 	.inject_page_fault = vmx_inject_page_fault,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

