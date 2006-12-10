From: akpm@osdl.org
Subject: - kvm-make-syncing-the-register-file-to-the-vcpu.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:18 -0800
Message-ID: <200612100754.kBA7sIEM017787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760510AbWLJHyW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make syncing the register file to the vcpu structure an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-make-syncing-the-register-file-to-the-vcpu.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make syncing the register file to the vcpu structure an arch operation
From: Avi Kivity <avi@qumranet.com>

This copies any general purpose guest registers maintained by the hardware
to the vcpu structure (and back).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    2 +
 drivers/kvm/kvm_main.c |   44 ++++++++++-----------------------------
 drivers/kvm/vmx.c      |   22 +++++++++++++++++++
 3 files changed, 36 insertions(+), 32 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-syncing-the-register-file-to-the-vcpu drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-syncing-the-register-file-to-the-vcpu
+++ a/drivers/kvm/kvm.h
@@ -262,6 +262,8 @@ struct kvm_arch_ops {
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
+	void (*cache_regs)(struct kvm_vcpu *vcpu);
+	void (*decache_regs)(struct kvm_vcpu *vcpu);
 };
 
 extern struct kvm_stat kvm_stat;
diff -puN drivers/kvm/kvm_main.c~kvm-make-syncing-the-register-file-to-the-vcpu drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-syncing-the-register-file-to-the-vcpu
+++ a/drivers/kvm/kvm_main.c
@@ -1327,26 +1327,6 @@ out:
 }
 
 /*
- * Sync the rsp and rip registers into the vcpu structure.  This allows
- * registers to be accessed by indexing vcpu->regs.
- */
-static void vcpu_load_rsp_rip(struct kvm_vcpu *vcpu)
-{
-	vcpu->regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
-	vcpu->rip = vmcs_readl(GUEST_RIP);
-}
-
-/*
- * Syncs rsp and rip back into the vmcs.  Should be called after possible
- * modification.
- */
-static void vcpu_put_rsp_rip(struct kvm_vcpu *vcpu)
-{
-	vmcs_writel(GUEST_RSP, vcpu->regs[VCPU_REGS_RSP]);
-	vmcs_writel(GUEST_RIP, vcpu->rip);
-}
-
-/*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
 static int kvm_dev_ioctl_create_vcpu(struct kvm *kvm, int n)
@@ -1820,7 +1800,7 @@ static int emulate_instruction(struct kv
 	int r;
 	u32 cs_ar;
 
-	vcpu_load_rsp_rip(vcpu);
+	kvm_arch_ops->cache_regs(vcpu);
 
 	cs_ar = vmcs_read32(GUEST_CS_AR_BYTES);
 
@@ -1865,7 +1845,7 @@ static int emulate_instruction(struct kv
 		return EMULATE_DO_MMIO;
 	}
 
-	vcpu_put_rsp_rip(vcpu);
+	kvm_arch_ops->decache_regs(vcpu);
 	vmcs_writel(GUEST_RFLAGS, emulate_ctxt.eflags);
 
 	if (vcpu->mmio_is_write)
@@ -2135,22 +2115,22 @@ static int handle_cr(struct kvm_vcpu *vc
 	case 0: /* mov to cr */
 		switch (cr) {
 		case 0:
-			vcpu_load_rsp_rip(vcpu);
+			kvm_arch_ops->cache_regs(vcpu);
 			set_cr0(vcpu, vcpu->regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 3:
-			vcpu_load_rsp_rip(vcpu);
+			kvm_arch_ops->cache_regs(vcpu);
 			set_cr3(vcpu, vcpu->regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 4:
-			vcpu_load_rsp_rip(vcpu);
+			kvm_arch_ops->cache_regs(vcpu);
 			set_cr4(vcpu, vcpu->regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
-			vcpu_load_rsp_rip(vcpu);
+			kvm_arch_ops->cache_regs(vcpu);
 			set_cr8(vcpu, vcpu->regs[reg]);
 			skip_emulated_instruction(vcpu);
 			return 1;
@@ -2159,17 +2139,17 @@ static int handle_cr(struct kvm_vcpu *vc
 	case 1: /*mov from cr*/
 		switch (cr) {
 		case 3:
-			vcpu_load_rsp_rip(vcpu);
+			kvm_arch_ops->cache_regs(vcpu);
 			vcpu->regs[reg] = vcpu->cr3;
-			vcpu_put_rsp_rip(vcpu);
+			kvm_arch_ops->decache_regs(vcpu);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		case 8:
 			printk(KERN_DEBUG "handle_cr: read CR8 "
 			       "cpu erratum AA15\n");
-			vcpu_load_rsp_rip(vcpu);
+			kvm_arch_ops->cache_regs(vcpu);
 			vcpu->regs[reg] = vcpu->cr8;
-			vcpu_put_rsp_rip(vcpu);
+			kvm_arch_ops->decache_regs(vcpu);
 			skip_emulated_instruction(vcpu);
 			return 1;
 		}
@@ -2201,7 +2181,7 @@ static int handle_dr(struct kvm_vcpu *vc
 	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
 	dr = exit_qualification & 7;
 	reg = (exit_qualification >> 8) & 15;
-	vcpu_load_rsp_rip(vcpu);
+	kvm_arch_ops->cache_regs(vcpu);
 	if (exit_qualification & 16) {
 		/* mov from dr */
 		switch (dr) {
@@ -2218,7 +2198,7 @@ static int handle_dr(struct kvm_vcpu *vc
 	} else {
 		/* mov to dr */
 	}
-	vcpu_put_rsp_rip(vcpu);
+	kvm_arch_ops->decache_regs(vcpu);
 	skip_emulated_instruction(vcpu);
 	return 1;
 }
diff -puN drivers/kvm/vmx.c~kvm-make-syncing-the-register-file-to-the-vcpu drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-syncing-the-register-file-to-the-vcpu
+++ a/drivers/kvm/vmx.c
@@ -180,6 +180,26 @@ static int vmx_set_msr(struct kvm_vcpu *
 	return 0;
 }
 
+/*
+ * Sync the rsp and rip registers into the vcpu structure.  This allows
+ * registers to be accessed by indexing vcpu->regs.
+ */
+static void vcpu_load_rsp_rip(struct kvm_vcpu *vcpu)
+{
+	vcpu->regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
+	vcpu->rip = vmcs_readl(GUEST_RIP);
+}
+
+/*
+ * Syncs rsp and rip back into the vmcs.  Should be called after possible
+ * modification.
+ */
+static void vcpu_put_rsp_rip(struct kvm_vcpu *vcpu)
+{
+	vmcs_writel(GUEST_RSP, vcpu->regs[VCPU_REGS_RSP]);
+	vmcs_writel(GUEST_RIP, vcpu->rip);
+}
+
 static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 {
 	unsigned long dr7 = 0x400;
@@ -405,6 +425,8 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
+	.cache_regs = vcpu_load_rsp_rip,
+	.decache_regs = vcpu_put_rsp_rip,
 };
 
 static int __init vmx_init(void)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

