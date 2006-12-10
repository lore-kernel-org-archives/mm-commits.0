From: akpm@osdl.org
Subject: - kvm-remove-guest_cpl.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:27 -0800
Message-ID: <200612100755.kBA7tRdO017873@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59837 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760374AbWLJHz3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: remove guest_cpl()
has been removed from the -mm tree.  Its filename was
     kvm-remove-guest_cpl.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: remove guest_cpl()
From: Avi Kivity <avi@qumranet.com>

This was used only in debugging.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |    5 -----
 drivers/kvm/vmx.c |    8 --------
 2 files changed, 13 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-remove-guest_cpl drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-remove-guest_cpl
+++ a/drivers/kvm/kvm.h
@@ -422,11 +422,6 @@ static inline int is_pse(struct kvm_vcpu
 	return vcpu->cr4 & CR4_PSE_MASK;
 }
 
-static inline unsigned guest_cpl(void)
-{
-	return vmcs_read16(GUEST_CS_SELECTOR) & SELECTOR_RPL_MASK;
-}
-
 static inline int is_paging(struct kvm_vcpu *vcpu)
 {
 	return vcpu->cr0 & CR0_PG_MASK;
diff -puN drivers/kvm/vmx.c~kvm-remove-guest_cpl drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-remove-guest_cpl
+++ a/drivers/kvm/vmx.c
@@ -1393,14 +1393,6 @@ static int handle_cr(struct kvm_vcpu *vc
 	int cr;
 	int reg;
 
-#ifdef KVM_DEBUG
-	if (guest_cpl() != 0) {
-		vcpu_printf(vcpu, "%s: not supervisor\n", __FUNCTION__);
-		inject_gp(vcpu);
-		return 1;
-	}
-#endif
-
 	exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
 	cr = exit_qualification & 15;
 	reg = (exit_qualification >> 8) & 15;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

