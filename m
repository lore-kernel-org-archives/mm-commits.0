From: akpm@osdl.org
Subject: - kvm-use-more-traditional-error-handling-in-kvm_mmu_init.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:15 -0800
Message-ID: <200612230753.kBN7rFOE010107@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49577 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbWLWHxV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:53:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: Use more traditional error handling in kvm_mmu_init()
has been removed from the -mm tree.  Its filename was
     kvm-use-more-traditional-error-handling-in-kvm_mmu_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Use more traditional error handling in kvm_mmu_init()
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/kvm/mmu.c~kvm-use-more-traditional-error-handling-in-kvm_mmu_init drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-use-more-traditional-error-handling-in-kvm_mmu_init
+++ a/drivers/kvm/mmu.c
@@ -647,14 +647,20 @@ int kvm_mmu_init(struct kvm_vcpu *vcpu)
 	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
 	ASSERT(list_empty(&vcpu->free_pages));
 
-	if ((r = alloc_mmu_pages(vcpu)))
-		return r;
+	r = alloc_mmu_pages(vcpu);
+	if (r)
+		goto out;
+
+	r = init_kvm_mmu(vcpu);
+	if (r)
+		goto out_free_pages;
 
-	if ((r = init_kvm_mmu(vcpu))) {
-		free_mmu_pages(vcpu);
-		return r;
-	}
 	return 0;
+
+out_free_pages:
+	free_mmu_pages(vcpu);
+out:
+	return r;
 }
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch

