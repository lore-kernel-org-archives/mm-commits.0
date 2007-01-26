From: akpm@osdl.org
Subject: - kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:23 -0800
Message-ID: <200701260751.l0Q7pNVg010721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50461 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030809AbXAZHvf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: make sure there is a vcpu context loaded when destroying the mmu
has been removed from the -mm tree.  Its filename was
     kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: make sure there is a vcpu context loaded when destroying the mmu
From: Avi Kivity <avi@qumranet.com>

This makes the vmwrite errors on vm shutdown go away.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/kvm/kvm_main.c~kvm-make-sure-there-is-a-vcpu-context-loaded-when drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-sure-there-is-a-vcpu-context-loaded-when
+++ a/drivers/kvm/kvm_main.c
@@ -272,7 +272,9 @@ static void kvm_free_physmem(struct kvm 
 
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
+	vcpu_load(vcpu->kvm, vcpu_slot(vcpu));
 	kvm_mmu_destroy(vcpu);
+	vcpu_put(vcpu);
 	kvm_arch_ops->vcpu_free(vcpu);
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are

kvm-svm-fix-svm-idt-confusion.patch
kvm-emulate-ia32_misc_enable-msr.patch
kvm-mmu-perform-access-checks-in-walk_addr.patch
kvm-mmu-report-nx-faults-to-the-guest.patch
kvm-svm-propagate-cpu-shutdown-events-to-userspace.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
