From: akpm@osdl.org
Subject: - kvm-svm-fix-svm-idt-confusion.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:30:55 -0800
Message-ID: <200701270130.l0R1Utjf031801@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbXA0Bbj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leonard.norrgard@refactor.fi, avi@qumranet.com, uril@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: SVM: Fix SVM idt confusion
has been removed from the -mm tree.  Its filename was
     kvm-svm-fix-svm-idt-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: SVM: Fix SVM idt confusion
From: Leonard Norrgard <leonard.norrgard@refactor.fi>

There's an obvious typo in svm_{get,set}_idt, causing it to access the ldt
instead.

Because these functions are only called for save/load on AMD, the bug does not
impact normal operation.  With the fix, save/load works as expected on AMD
hosts.

Signed-off-by: Uri Lublin <uril@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/kvm/svm.c~kvm-svm-fix-svm-idt-confusion drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-svm-fix-svm-idt-confusion
+++ a/drivers/kvm/svm.c
@@ -680,14 +680,14 @@ static void svm_get_cs_db_l_bits(struct 
 
 static void svm_get_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
-	dt->limit = vcpu->svm->vmcb->save.ldtr.limit;
-	dt->base = vcpu->svm->vmcb->save.ldtr.base;
+	dt->limit = vcpu->svm->vmcb->save.idtr.limit;
+	dt->base = vcpu->svm->vmcb->save.idtr.base;
 }
 
 static void svm_set_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
-	vcpu->svm->vmcb->save.ldtr.limit = dt->limit;
-	vcpu->svm->vmcb->save.ldtr.base = dt->base ;
+	vcpu->svm->vmcb->save.idtr.limit = dt->limit;
+	vcpu->svm->vmcb->save.idtr.base = dt->base ;
 }
 
 static void svm_get_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
_

Patches currently in -mm which might be from leonard.norrgard@refactor.fi are

origin.patch
git-alsa.patch
