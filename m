From: akpm@osdl.org
Subject: - kvm-use-the-general-purpose-register-accessors-rather.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:58 -0800
Message-ID: <200612100754.kBA7swKe017833@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59772 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760404AbWLJHzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: use the general purpose register accessors rather than direct access
has been removed from the -mm tree.  Its filename was
     kvm-use-the-general-purpose-register-accessors-rather.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: use the general purpose register accessors rather than direct access
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-use-the-general-purpose-register-accessors-rather drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-use-the-general-purpose-register-accessors-rather
+++ a/drivers/kvm/kvm_main.c
@@ -1116,7 +1116,7 @@ static void report_emulation_failure(str
 {
 	static int reported;
 	u8 opcodes[4];
-	unsigned long rip = vmcs_readl(GUEST_RIP);
+	unsigned long rip = ctxt->vcpu->rip;
 	unsigned long rip_linear;
 
 	rip_linear = rip + get_segment_base(ctxt->vcpu, VCPU_SREG_CS);
@@ -1392,13 +1392,15 @@ static int kvm_dev_ioctl_get_regs(struct
 	if (!vcpu)
 		return -ENOENT;
 
+	kvm_arch_ops->cache_regs(vcpu);
+
 	regs->rax = vcpu->regs[VCPU_REGS_RAX];
 	regs->rbx = vcpu->regs[VCPU_REGS_RBX];
 	regs->rcx = vcpu->regs[VCPU_REGS_RCX];
 	regs->rdx = vcpu->regs[VCPU_REGS_RDX];
 	regs->rsi = vcpu->regs[VCPU_REGS_RSI];
 	regs->rdi = vcpu->regs[VCPU_REGS_RDI];
-	regs->rsp = vmcs_readl(GUEST_RSP);
+	regs->rsp = vcpu->regs[VCPU_REGS_RSP];
 	regs->rbp = vcpu->regs[VCPU_REGS_RBP];
 #ifdef __x86_64__
 	regs->r8 = vcpu->regs[VCPU_REGS_R8];
@@ -1411,7 +1413,7 @@ static int kvm_dev_ioctl_get_regs(struct
 	regs->r15 = vcpu->regs[VCPU_REGS_R15];
 #endif
 
-	regs->rip = vmcs_readl(GUEST_RIP);
+	regs->rip = vcpu->rip;
 	regs->rflags = vmcs_readl(GUEST_RFLAGS);
 
 	/*
@@ -1442,7 +1444,7 @@ static int kvm_dev_ioctl_set_regs(struct
 	vcpu->regs[VCPU_REGS_RDX] = regs->rdx;
 	vcpu->regs[VCPU_REGS_RSI] = regs->rsi;
 	vcpu->regs[VCPU_REGS_RDI] = regs->rdi;
-	vmcs_writel(GUEST_RSP, regs->rsp);
+	vcpu->regs[VCPU_REGS_RSP] = regs->rsp;
 	vcpu->regs[VCPU_REGS_RBP] = regs->rbp;
 #ifdef __x86_64__
 	vcpu->regs[VCPU_REGS_R8] = regs->r8;
@@ -1455,9 +1457,11 @@ static int kvm_dev_ioctl_set_regs(struct
 	vcpu->regs[VCPU_REGS_R15] = regs->r15;
 #endif
 
-	vmcs_writel(GUEST_RIP, regs->rip);
+	vcpu->rip = regs->rip;
 	vmcs_writel(GUEST_RFLAGS, regs->rflags);
 
+	kvm_arch_ops->decache_regs(vcpu);
+
 	vcpu_put(vcpu);
 
 	return 0;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

