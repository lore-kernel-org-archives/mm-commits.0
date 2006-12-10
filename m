From: akpm@osdl.org
Subject: - kvm-move-vmcs-static-variables-to-vmxc.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:19 -0800
Message-ID: <200612100755.kBA7tJdo017864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59819 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760558AbWLJHzV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: move vmcs static variables to vmx.c
has been removed from the -mm tree.  Its filename was
     kvm-move-vmcs-static-variables-to-vmxc.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: move vmcs static variables to vmx.c
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   12 ------------
 drivers/kvm/vmx.c      |    6 +++---
 2 files changed, 3 insertions(+), 15 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-move-vmcs-static-variables-to-vmxc drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-move-vmcs-static-variables-to-vmxc
+++ a/drivers/kvm/kvm_main.c
@@ -123,18 +123,6 @@ unsigned long segment_base(u16 selector)
 }
 EXPORT_SYMBOL_GPL(segment_base);
 
-DEFINE_PER_CPU(struct vmcs *, vmxarea);
-EXPORT_SYMBOL_GPL(per_cpu__vmxarea); /* temporary hack */
-DEFINE_PER_CPU(struct vmcs *, current_vmcs);
-EXPORT_SYMBOL_GPL(per_cpu__current_vmcs); /* temporary hack */
-
-struct vmcs_descriptor {
-	int size;
-	int order;
-	u32 revision_id;
-} vmcs_descriptor;
-EXPORT_SYMBOL_GPL(vmcs_descriptor);
-
 int kvm_read_guest(struct kvm_vcpu *vcpu,
 			     gva_t addr,
 			     unsigned long size,
diff -puN drivers/kvm/vmx.c~kvm-move-vmcs-static-variables-to-vmxc drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-move-vmcs-static-variables-to-vmxc
+++ a/drivers/kvm/vmx.c
@@ -30,8 +30,8 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
-DECLARE_PER_CPU(struct vmcs *, vmxarea);
-DECLARE_PER_CPU(struct vmcs *, current_vmcs);
+static DEFINE_PER_CPU(struct vmcs *, vmxarea);
+static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 
 #ifdef __x86_64__
 #define HOST_IS_64 1
@@ -39,7 +39,7 @@ DECLARE_PER_CPU(struct vmcs *, current_v
 #define HOST_IS_64 0
 #endif
 
-extern struct vmcs_descriptor {
+static struct vmcs_descriptor {
 	int size;
 	int order;
 	u32 revision_id;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-move-vmcs-static-variables-to-vmxc.patch
kvm-make-is_long_mode-an-arch-operation.patch
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

