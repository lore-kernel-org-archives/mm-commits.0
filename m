From: akpm@osdl.org
Subject: - kvm-mmu-destroy-mmu-while-we-still-have-a-vcpu-left.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:07 -0800
Message-ID: <200701070800.l078077R013159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480AbXAGIAM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:00:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: MMU: Destroy mmu while we still have a vcpu left
has been removed from the -mm tree.  Its filename was
     kvm-mmu-destroy-mmu-while-we-still-have-a-vcpu-left.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: MMU: Destroy mmu while we still have a vcpu left
From: Avi Kivity <avi@qumranet.com>

mmu_destroy flushes the guest tlb (indirectly), which needs a valid vcpu.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-mmu-destroy-mmu-while-we-still-have-a-vcpu-left drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-mmu-destroy-mmu-while-we-still-have-a-vcpu-left
+++ a/drivers/kvm/kvm_main.c
@@ -271,8 +271,8 @@ static void kvm_free_physmem(struct kvm 
 
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
-	kvm_arch_ops->vcpu_free(vcpu);
 	kvm_mmu_destroy(vcpu);
+	kvm_arch_ops->vcpu_free(vcpu);
 }
 
 static void kvm_free_vcpus(struct kvm *kvm)
_

Patches currently in -mm which might be from avi@qumranet.com are
