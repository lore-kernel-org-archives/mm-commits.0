From: akpm@osdl.org
Subject: - kvm-move-the-vmx-segment-field-definitions-to-vmxc.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:04 -0800
Message-ID: <200612100755.kBA7t4YQ017842@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59786 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760557AbWLJHzG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: move the vmx segment field definitions to vmx.c
has been removed from the -mm tree.  Its filename was
     kvm-move-the-vmx-segment-field-definitions-to-vmxc.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: move the vmx segment field definitions to vmx.c
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   25 -------------------------
 drivers/kvm/vmx.c      |   21 +++++++++++++++++++--
 2 files changed, 19 insertions(+), 27 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-move-the-vmx-segment-field-definitions-to-vmxc drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-move-the-vmx-segment-field-definitions-to-vmxc
+++ a/drivers/kvm/kvm_main.c
@@ -66,31 +66,6 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
-#define VMX_SEGMENT_FIELD(seg)					\
-	[VCPU_SREG_##seg] {                                     \
-		GUEST_##seg##_SELECTOR,				\
-		GUEST_##seg##_BASE,			   	\
-		GUEST_##seg##_LIMIT,			   	\
-		GUEST_##seg##_AR_BYTES,			   	\
-	}
-
-struct kvm_vmx_segment_field {
-	unsigned selector;
-	unsigned base;
-	unsigned limit;
-	unsigned ar_bytes;
-} kvm_vmx_segment_fields[] = {
-	VMX_SEGMENT_FIELD(CS),
-	VMX_SEGMENT_FIELD(DS),
-	VMX_SEGMENT_FIELD(ES),
-	VMX_SEGMENT_FIELD(FS),
-	VMX_SEGMENT_FIELD(GS),
-	VMX_SEGMENT_FIELD(SS),
-	VMX_SEGMENT_FIELD(TR),
-	VMX_SEGMENT_FIELD(LDTR),
-};
-EXPORT_SYMBOL_GPL(kvm_vmx_segment_fields);
-
 #define MAX_IO_MSRS 256
 
 #define CR0_RESEVED_BITS 0xffffffff1ffaffc0ULL
diff -puN drivers/kvm/vmx.c~kvm-move-the-vmx-segment-field-definitions-to-vmxc drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-move-the-vmx-segment-field-definitions-to-vmxc
+++ a/drivers/kvm/vmx.c
@@ -44,12 +44,29 @@ extern struct vmcs_descriptor {
 	u32 revision_id;
 } vmcs_descriptor;
 
-extern struct kvm_vmx_segment_field {
+#define VMX_SEGMENT_FIELD(seg)					\
+	[VCPU_SREG_##seg] {                                     \
+		GUEST_##seg##_SELECTOR,				\
+		GUEST_##seg##_BASE,			   	\
+		GUEST_##seg##_LIMIT,			   	\
+		GUEST_##seg##_AR_BYTES,			   	\
+	}
+
+static struct kvm_vmx_segment_field {
 	unsigned selector;
 	unsigned base;
 	unsigned limit;
 	unsigned ar_bytes;
-} kvm_vmx_segment_fields[];
+} kvm_vmx_segment_fields[] = {
+	VMX_SEGMENT_FIELD(CS),
+	VMX_SEGMENT_FIELD(DS),
+	VMX_SEGMENT_FIELD(ES),
+	VMX_SEGMENT_FIELD(FS),
+	VMX_SEGMENT_FIELD(GS),
+	VMX_SEGMENT_FIELD(SS),
+	VMX_SEGMENT_FIELD(TR),
+	VMX_SEGMENT_FIELD(LDTR),
+};
 
 static const u32 vmx_msr_index[] = {
 #ifdef __x86_64__
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-move-the-vmx-segment-field-definitions-to-vmxc.patch
kvm-add-an-arch-accessor-for-cs-d-b-and-l-bits.patch
kvm-add-a-set_cr0_no_modeswitch-arch-accessor.patch
kvm-make-vcpu_load-and-vcpu_put-arch-operations.patch
kvm-make-vcpu-creation-and-destruction-arch-operations.patch
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

