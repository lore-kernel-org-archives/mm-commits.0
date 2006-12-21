From: akpm@osdl.org
Subject: + kvm-use-more-traditional-error-handling-in-kvm_mmu_init.patch added to -mm tree
Date: Thu, 21 Dec 2006 01:59:58 -0800
Message-ID: <200612210959.kBL9xwcD023467@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54649 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965187AbWLUKAB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 05:00:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Use more traditional error handling in kvm_mmu_init()
has been added to the -mm tree.  Its filename is
     kvm-use-more-traditional-error-handling-in-kvm_mmu_init.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-add-valid_vcpu-helper.patch
kvm-amd-svm-handle-msr_star-in-32-bit-mode.patch
kvm-amd-svm-save-and-restore-the-floating-point-unit.patch
kvm-use-more-traditional-error-handling-in-kvm_mmu_init.patch
kvm-do-not-export-unsupported-msrs-to-userspace.patch
kvm-do-not-export-unsupported-msrs-to-userspace-tweak.patch
kvm-force-real-mode-cs-limit-to-64k.patch
kvm-handle-p5-mce-msrs.patch
kvm-api-versioning.patch

