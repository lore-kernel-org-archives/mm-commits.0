From: akpm@linux-foundation.org
Subject: + kvm-wire-up-hypercall-handlers-to-a-central.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:47 -0800
Message-ID: <200702212049.l1LKnlFk025481@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44141 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161349AbXBUUtx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:49:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Wire up hypercall handlers to a central arch-independent location
has been added to the -mm tree.  Its filename is
     kvm-wire-up-hypercall-handlers-to-a-central.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Wire up hypercall handlers to a central arch-independent location
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm.h      |    2 ++
 drivers/kvm/kvm_main.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/kvm/svm.c      |   10 +---------
 drivers/kvm/vmx.c      |   10 +---------
 4 files changed, 40 insertions(+), 18 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-wire-up-hypercall-handlers-to-a-central drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-wire-up-hypercall-handlers-to-a-central
+++ a/drivers/kvm/kvm.h
@@ -482,6 +482,8 @@ void kvm_mmu_post_write(struct kvm_vcpu 
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 
+int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
+
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				     u32 error_code)
 {
diff -puN drivers/kvm/kvm_main.c~kvm-wire-up-hypercall-handlers-to-a-central drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-wire-up-hypercall-handlers-to-a-central
+++ a/drivers/kvm/kvm_main.c
@@ -1138,6 +1138,42 @@ int emulate_instruction(struct kvm_vcpu 
 }
 EXPORT_SYMBOL_GPL(emulate_instruction);
 
+int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	unsigned long nr, a0, a1, a2, a3, a4, a5, ret;
+
+	kvm_arch_ops->decache_regs(vcpu);
+	ret = -KVM_EINVAL;
+#ifdef CONFIG_X86_64
+	if (is_long_mode(vcpu)) {
+		nr = vcpu->regs[VCPU_REGS_RAX];
+		a0 = vcpu->regs[VCPU_REGS_RDI];
+		a1 = vcpu->regs[VCPU_REGS_RSI];
+		a2 = vcpu->regs[VCPU_REGS_RDX];
+		a3 = vcpu->regs[VCPU_REGS_RCX];
+		a4 = vcpu->regs[VCPU_REGS_R8];
+		a5 = vcpu->regs[VCPU_REGS_R9];
+	} else
+#endif
+	{
+		nr = vcpu->regs[VCPU_REGS_RBX] & -1u;
+		a0 = vcpu->regs[VCPU_REGS_RAX] & -1u;
+		a1 = vcpu->regs[VCPU_REGS_RCX] & -1u;
+		a2 = vcpu->regs[VCPU_REGS_RDX] & -1u;
+		a3 = vcpu->regs[VCPU_REGS_RSI] & -1u;
+		a4 = vcpu->regs[VCPU_REGS_RDI] & -1u;
+		a5 = vcpu->regs[VCPU_REGS_RBP] & -1u;
+	}
+	switch (nr) {
+	default:
+		;
+	}
+	vcpu->regs[VCPU_REGS_RAX] = ret;
+	kvm_arch_ops->cache_regs(vcpu);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kvm_hypercall);
+
 static u64 mk_cr_64(u64 curr_cr, u32 new_val)
 {
 	return (curr_cr & ~((1ULL << 32) - 1)) | new_val;
diff -puN drivers/kvm/svm.c~kvm-wire-up-hypercall-handlers-to-a-central drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-wire-up-hypercall-handlers-to-a-central
+++ a/drivers/kvm/svm.c
@@ -1078,16 +1078,8 @@ static int halt_interception(struct kvm_
 
 static int vmmcall_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	printk(KERN_DEBUG "got vmmcall at RIP %08llx\n",
-	       vcpu->svm->vmcb->save.rip);
-	printk(KERN_DEBUG "vmmcall params: %08llx, %08lx, %08lx, %08lx\n",
-	       vcpu->svm->vmcb->save.rax,
-	       vcpu->regs[VCPU_REGS_RCX],
-	       vcpu->regs[VCPU_REGS_RDX],
-	       vcpu->regs[VCPU_REGS_RBP]);
-	vcpu->svm->vmcb->save.rax = 0;
 	vcpu->svm->vmcb->save.rip += 3;
-	return 1;
+	return kvm_hypercall(vcpu, kvm_run);
 }
 
 static int invalid_op_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
diff -puN drivers/kvm/vmx.c~kvm-wire-up-hypercall-handlers-to-a-central drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-wire-up-hypercall-handlers-to-a-central
+++ a/drivers/kvm/vmx.c
@@ -1659,16 +1659,8 @@ static int handle_halt(struct kvm_vcpu *
 
 static int handle_vmcall(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	kvm_run->exit_reason = KVM_EXIT_DEBUG;
-	printk(KERN_DEBUG "got vmcall at RIP %08lx\n", vmcs_readl(GUEST_RIP));
-	printk(KERN_DEBUG "vmcall params: %08lx, %08lx, %08lx, %08lx\n",
-		vcpu->regs[VCPU_REGS_RAX],
-		vcpu->regs[VCPU_REGS_RCX],
-		vcpu->regs[VCPU_REGS_RDX],
-		vcpu->regs[VCPU_REGS_RBP]);
-	vcpu->regs[VCPU_REGS_RAX] = 0;
 	vmcs_writel(GUEST_RIP, vmcs_readl(GUEST_RIP)+3);
-	return 1;
+	return kvm_hypercall(vcpu, kvm_run);
 }
 
 /*
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-mmu-add-missing-dirty-page-tracking-cases.patch
kvm-move-virtualization-deactivation-from-cpu_dead.patch
kvm-cosmetics.patch
kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-use-array_size-macro-instead-of-manual-calculation.patch
kvm-use-page_private-set_page_private-apis.patch
kvm-add-msr-based-hypercall-api.patch
kvm-add-host-hypercall-support-for-vmx.patch
kvm-add-hypercall-host-support-for-svm.patch
kvm-wire-up-hypercall-handlers-to-a-central.patch
kvm-svm-init-cr0-with-the-wp-bit-set.patch
kvm-svm-intercept-smi-to-handle-it-at-host-level.patch
kvm-more-0-null-conversions.patch
