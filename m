From: akpm@osdl.org
Subject: + kvm-move-find_vmx_entry-to-vmxc.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:20:28 -0800
Message-ID: <200612112020.kBBKKSQ2006080@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33109 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937643AbWLKUUp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     KVM: Move find_vmx_entry() to vmx.c
has been added to the -mm tree.  Its filename is
     kvm-move-find_vmx_entry-to-vmxc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Move find_vmx_entry() to vmx.c
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   21 ++-------------------
 drivers/kvm/vmx.c      |   12 ++++++++++--
 2 files changed, 12 insertions(+), 21 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-move-find_vmx_entry-to-vmxc drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-move-find_vmx_entry-to-vmxc
+++ a/drivers/kvm/kvm_main.c
@@ -72,17 +72,6 @@ static struct dentry *debugfs_dir;
 #define CR8_RESEVED_BITS (~0x0fULL)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
-struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
-{
-	int i;
-
-	for (i = 0; i < vcpu->nmsrs; ++i)
-		if (vcpu->guest_msrs[i].index == msr)
-			return &vcpu->guest_msrs[i];
-	return 0;
-}
-EXPORT_SYMBOL_GPL(find_msr_entry);
-
 #ifdef CONFIG_X86_64
 // LDT or TSS descriptor in the GDT. 16 bytes.
 struct segment_descriptor_64 {
@@ -1124,8 +1113,6 @@ static int get_msr(struct kvm_vcpu *vcpu
 
 void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	struct vmx_msr_entry *msr;
-
 	if (efer & EFER_RESERVED_BITS) {
 		printk(KERN_DEBUG "set_efer: 0x%llx #GP, reserved bits\n",
 		       efer);
@@ -1140,16 +1127,12 @@ void set_efer(struct kvm_vcpu *vcpu, u64
 		return;
 	}
 
+	kvm_arch_ops->set_efer(vcpu, efer);
+
 	efer &= ~EFER_LMA;
 	efer |= vcpu->shadow_efer & EFER_LMA;
 
 	vcpu->shadow_efer = efer;
-
-	msr = find_msr_entry(vcpu, MSR_EFER);
-
-	if (!(efer & EFER_LMA))
-	    efer &= ~EFER_LME;
-	msr->data = efer;
 }
 EXPORT_SYMBOL_GPL(set_efer);
 
diff -puN drivers/kvm/vmx.c~kvm-move-find_vmx_entry-to-vmxc drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-move-find_vmx_entry-to-vmxc
+++ a/drivers/kvm/vmx.c
@@ -78,8 +78,6 @@ static const u32 vmx_msr_index[] = {
 };
 #define NR_VMX_MSR (sizeof(vmx_msr_index) / sizeof(*vmx_msr_index))
 
-struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr);
-
 static inline int is_page_fault(u32 intr_info)
 {
 	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
@@ -93,6 +91,16 @@ static inline int is_external_interrupt(
 		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
 }
 
+static struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr)
+{
+	int i;
+
+	for (i = 0; i < vcpu->nmsrs; ++i)
+		if (vcpu->guest_msrs[i].index == msr)
+			return &vcpu->guest_msrs[i];
+	return 0;
+}
+
 static void vmcs_clear(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-add-missing-include.patch
kvm-put-kvm-in-a-new-virtualization-menu.patch
kvm-clean-up-amd-svm-debug-registers-load-and-unload.patch
kvm-replace-__x86_64__-with-config_x86_64.patch
kvm-make-the-get_sregs-and-set_sregs-ioctls-symmetric.patch
kvm-move-find_vmx_entry-to-vmxc.patch
kvm-remove-extranous-put_cpu-from-vcpu_put.patch
kvm-mmu-ignore-pcd-pwt-and-pat-bits-on-ptes.patch
kvm-add-maintainers-entry.patch

