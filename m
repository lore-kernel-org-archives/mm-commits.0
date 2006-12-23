From: akpm@osdl.org
Subject: - kvm-amd-svm-save-and-restore-the-floating-point-unit.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:13 -0800
Message-ID: <200612230753.kBN7rDUK010102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49580 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbWLWHxW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: AMD SVM: Save and restore the floating point unit 	state
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-save-and-restore-the-floating-point-unit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: AMD SVM: Save and restore the floating point unit 	state
From: Avi Kivity <avi@qumranet.com>

Fixes sf bug 1614113 (segfaults in nbench).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/kvm/svm.c~kvm-amd-svm-save-and-restore-the-floating-point-unit drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-amd-svm-save-and-restore-the-floating-point-unit
+++ a/drivers/kvm/svm.c
@@ -575,6 +575,8 @@ static int svm_create_vcpu(struct kvm_vc
 	memset(vcpu->svm->db_regs, 0, sizeof(vcpu->svm->db_regs));
 	init_vmcb(vcpu->svm->vmcb);
 
+	fx_init(vcpu);
+
 	return 0;
 
 out2:
@@ -1387,6 +1389,10 @@ again:
 		save_db_regs(vcpu->svm->host_db_regs);
 		load_db_regs(vcpu->svm->db_regs);
 	}
+
+	fx_save(vcpu->host_fx_image);
+	fx_restore(vcpu->guest_fx_image);
+
 	asm volatile (
 #ifdef CONFIG_X86_64
 		"push %%rbx; push %%rcx; push %%rdx;"
@@ -1496,6 +1502,9 @@ again:
 #endif
 		: "cc", "memory" );
 
+	fx_save(vcpu->guest_fx_image);
+	fx_restore(vcpu->host_fx_image);
+
 	if ((vcpu->svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(vcpu->svm->host_db_regs);
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch

