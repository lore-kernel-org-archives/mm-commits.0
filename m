From: akpm@linux-foundation.org
Subject: + kvm-add-hypercall-host-support-for-svm.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:49:45 -0800
Message-ID: <200702212049.l1LKnjIF025478@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44133 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161351AbXBUUtr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:49:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Add hypercall host support for svm
has been added to the -mm tree.  Its filename is
     kvm-add-hypercall-host-support-for-svm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Add hypercall host support for svm
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/svm.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~kvm-add-hypercall-host-support-for-svm drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-add-hypercall-host-support-for-svm
+++ a/drivers/kvm/svm.c
@@ -1076,6 +1076,20 @@ static int halt_interception(struct kvm_
 	return 0;
 }
 
+static int vmmcall_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	printk(KERN_DEBUG "got vmmcall at RIP %08llx\n",
+	       vcpu->svm->vmcb->save.rip);
+	printk(KERN_DEBUG "vmmcall params: %08llx, %08lx, %08lx, %08lx\n",
+	       vcpu->svm->vmcb->save.rax,
+	       vcpu->regs[VCPU_REGS_RCX],
+	       vcpu->regs[VCPU_REGS_RDX],
+	       vcpu->regs[VCPU_REGS_RBP]);
+	vcpu->svm->vmcb->save.rax = 0;
+	vcpu->svm->vmcb->save.rip += 3;
+	return 1;
+}
+
 static int invalid_op_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	inject_ud(vcpu);
@@ -1276,7 +1290,7 @@ static int (*svm_exit_handlers[])(struct
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= invalid_op_interception,
-	[SVM_EXIT_VMMCALL]			= invalid_op_interception,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= invalid_op_interception,
 	[SVM_EXIT_VMSAVE]			= invalid_op_interception,
 	[SVM_EXIT_STGI]				= invalid_op_interception,
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
