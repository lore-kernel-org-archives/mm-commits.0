From: akpm@osdl.org
Subject: + kvm-svm-fix-svm-idt-confusion.patch added to -mm tree
Date: Tue, 23 Jan 2007 10:56:58 -0800
Message-ID: <200701231856.l0NIuwPw027767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48223 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965432AbXAWS5d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 13:57:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leonard.norrgard@refactor.fi, avi@qumranet.com, uril@qumranet.com


The patch titled
     KVM: SVM: Fix SVM idt confusion
has been added to the -mm tree.  Its filename is
     kvm-svm-fix-svm-idt-confusion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 insertions(+), 4 deletions(-)

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

kvm-svm-fix-svm-idt-confusion.patch
git-alsa.patch
