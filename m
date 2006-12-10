From: akpm@osdl.org
Subject: - kvm-move-vmx-helper-inlines-to-vmxc.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:33 -0800
Message-ID: <200612100755.kBA7tXQK017882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760575AbWLJHzf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: move vmx helper inlines to vmx.c
has been removed from the -mm tree.  Its filename was
     kvm-move-vmx-helper-inlines-to-vmxc.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: move vmx helper inlines to vmx.c
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h |   13 -------------
 drivers/kvm/vmx.c |   13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-move-vmx-helper-inlines-to-vmxc drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-move-vmx-helper-inlines-to-vmxc
+++ a/drivers/kvm/kvm.h
@@ -400,19 +400,6 @@ static inline int is_paging(struct kvm_v
 	return vcpu->cr0 & CR0_PG_MASK;
 }
 
-static inline int is_page_fault(u32 intr_info)
-{
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
-			     INTR_INFO_VALID_MASK)) ==
-		(INTR_TYPE_EXCEPTION | PF_VECTOR | INTR_INFO_VALID_MASK);
-}
-
-static inline int is_external_interrupt(u32 intr_info)
-{
-	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
-		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
-}
-
 static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	return slot - kvm->memslots;
diff -puN drivers/kvm/vmx.c~kvm-move-vmx-helper-inlines-to-vmxc drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-move-vmx-helper-inlines-to-vmxc
+++ a/drivers/kvm/vmx.c
@@ -79,6 +79,19 @@ static const u32 vmx_msr_index[] = {
 
 struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr);
 
+static inline int is_page_fault(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
+			     INTR_INFO_VALID_MASK)) ==
+		(INTR_TYPE_EXCEPTION | PF_VECTOR | INTR_INFO_VALID_MASK);
+}
+
+static inline int is_external_interrupt(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
+		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
+}
+
 static void vmcs_clear(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

