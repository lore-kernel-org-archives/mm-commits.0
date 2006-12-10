From: akpm@osdl.org
Subject: - kvm-use-the-tlb-flush-arch-operation-instead-of-an.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:24 -0800
Message-ID: <200612100755.kBA7tOc0017870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59830 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760571AbWLJHz0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: use the tlb flush arch operation instead of an inline
has been removed from the -mm tree.  Its filename was
     kvm-use-the-tlb-flush-arch-operation-instead-of-an.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: use the tlb flush arch operation instead of an inline
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    5 -----
 drivers/kvm/kvm_main.c |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-use-the-tlb-flush-arch-operation-instead-of-an drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-use-the-tlb-flush-arch-operation-instead-of-an
+++ a/drivers/kvm/kvm.h
@@ -445,11 +445,6 @@ static inline int is_external_interrupt(
 		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
 }
 
-static inline void flush_guest_tlb(struct kvm_vcpu *vcpu)
-{
-	vmcs_writel(GUEST_CR3, vmcs_readl(GUEST_CR3));
-}
-
 static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	return slot - kvm->memslots;
diff -puN drivers/kvm/kvm_main.c~kvm-use-the-tlb-flush-arch-operation-instead-of-an drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-use-the-tlb-flush-arch-operation-instead-of-an
+++ a/drivers/kvm/kvm_main.c
@@ -761,7 +761,7 @@ static int kvm_dev_ioctl_get_dirty_log(s
 
 			if (!vcpu)
 				continue;
-			flush_guest_tlb(vcpu);
+			kvm_arch_ops->flush_tlb(vcpu);
 			vcpu_put(vcpu);
 		}
 	}
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-use-the-tlb-flush-arch-operation-instead-of-an.patch
kvm-remove-guest_cpl.patch
kvm-move-vmcs-accessors-to-vmxc.patch
kvm-move-vmx-helper-inlines-to-vmxc.patch
kvm-remove-vmx-includes-from-arch-independent-code.patch
kvm-amd-svm-add-architecture-definitions-for-amd-svm.patch
kvm-amd-svm-enhance-x86-emulator.patch
kvm-amd-svm-enhance-x86-emulator-fix-mov-to-from-control-register-emulation.patch
kvm-amd-svm-add-missing-tlb-flushes-to-the-guest-mmu.patch
kvm-amd-svm-add-data-structures.patch
kvm-amd-svm-implementation.patch
kvm-amd-svm-implementation-avoid-three-more-new-instructions.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
kvm-amd-svm-implementation-printk-log-levels.patch
kvm-amd-svm-plumbing.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
kvm-load-i386-segment-bases.patch

