From: akpm@linux-foundation.org
Subject: - kvm-add-hypercall-host-support-for-svm.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:47 -0800
Message-ID: <200702282354.l1SNsl5H031220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48525 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXB1Xyv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Add hypercall host support for svm
has been removed from the -mm tree.  Its filename was
     kvm-add-hypercall-host-support-for-svm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
