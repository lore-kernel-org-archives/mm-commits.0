From: akpm@osdl.org
Subject: - kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:46 -0800
Message-ID: <200612100755.kBA7tkGL017900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59872 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760576AbWLJHzs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, yaniv@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: AMD SVM: Add missing tlb flushes to the guest mmu
has been removed from the -mm tree.  Its filename was
     kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: AMD SVM: Add missing tlb flushes to the guest mmu
From: Avi Kivity <avi@qumranet.com>

Add a couple of missing mmu flushes.  The Intel tlb is too coarse to be
affected, but they are necessary for AMD.

Signed-off-by: Yaniv Kamay <yaniv@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/mmu.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/kvm/mmu.c~kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu
+++ a/drivers/kvm/mmu.c
@@ -324,6 +324,7 @@ static void nonpaging_flush(struct kvm_v
 	if (is_paging(vcpu))
 		root |= (vcpu->cr3 & (CR3_PCD_MASK | CR3_WPT_MASK));
 	kvm_arch_ops->set_cr3(vcpu, root);
+	kvm_arch_ops->flush_tlb(vcpu);
 }
 
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr)
@@ -407,6 +408,7 @@ static void kvm_mmu_flush_tlb(struct kvm
 		release_pt_page_64(vcpu, page->page_hpa, 1);
 	}
 	++kvm_stat.tlb_flush;
+	kvm_arch_ops->flush_tlb(vcpu);
 }
 
 static void paging_new_cr3(struct kvm_vcpu *vcpu)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

