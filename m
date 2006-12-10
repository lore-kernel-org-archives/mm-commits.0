From: akpm@osdl.org
Subject: - kvm-move-vmcs-accessors-to-vmxc.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:30 -0800
Message-ID: <200612100755.kBA7tUqe017876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59849 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760571AbWLJHzd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: move vmcs accessors to vmx.c
has been removed from the -mm tree.  Its filename was
     kvm-move-vmcs-accessors-to-vmxc.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: move vmcs accessors to vmx.c
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |   27 -----------------
 drivers/kvm/kvm_main.c |   22 --------------
 drivers/kvm/kvm_vmx.h  |   16 ----------
 drivers/kvm/vmx.c      |   60 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 65 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-move-vmcs-accessors-to-vmxc drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-move-vmcs-accessors-to-vmxc
+++ a/drivers/kvm/kvm.h
@@ -377,9 +377,6 @@ int kvm_write_guest(struct kvm_vcpu *vcp
 		unsigned long size,
 		void *data);
 
-void vmcs_writel(unsigned long field, unsigned long value);
-unsigned long vmcs_readl(unsigned long field);
-
 unsigned long segment_base(u16 selector);
 
 static inline struct page *_gfn_to_page(struct kvm *kvm, gfn_t gfn)
@@ -388,30 +385,6 @@ static inline struct page *_gfn_to_page(
 	return (slot) ? slot->phys_mem[gfn - slot->base_gfn] : 0;
 }
 
-static inline u16 vmcs_read16(unsigned long field)
-{
-	return vmcs_readl(field);
-}
-
-static inline u32 vmcs_read32(unsigned long field)
-{
-	return vmcs_readl(field);
-}
-
-static inline u64 vmcs_read64(unsigned long field)
-{
-#ifdef __x86_64__
-	return vmcs_readl(field);
-#else
-	return vmcs_readl(field) | ((u64)vmcs_readl(field+1) << 32);
-#endif
-}
-
-static inline void vmcs_write32(unsigned long field, u32 value)
-{
-	vmcs_writel(field, value);
-}
-
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
 	return vcpu->cr4 & CR4_PAE_MASK;
diff -puN drivers/kvm/kvm_main.c~kvm-move-vmcs-accessors-to-vmxc drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-move-vmcs-accessors-to-vmxc
+++ a/drivers/kvm/kvm_main.c
@@ -295,28 +295,6 @@ static int kvm_dev_release(struct inode 
 	return 0;
 }
 
-unsigned long vmcs_readl(unsigned long field)
-{
-	unsigned long value;
-
-	asm volatile (ASM_VMX_VMREAD_RDX_RAX
-		      : "=a"(value) : "d"(field) : "cc");
-	return value;
-}
-EXPORT_SYMBOL_GPL(vmcs_readl);
-
-void vmcs_writel(unsigned long field, unsigned long value)
-{
-	u8 error;
-
-	asm volatile (ASM_VMX_VMWRITE_RAX_RDX "; setna %0"
-		       : "=q"(error) : "a"(value), "d"(field) : "cc" );
-	if (error)
-		printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
-		       field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
-}
-EXPORT_SYMBOL_GPL(vmcs_writel);
-
 static void inject_gp(struct kvm_vcpu *vcpu)
 {
 	kvm_arch_ops->inject_gp(vcpu, 0);
diff -puN drivers/kvm/kvm_vmx.h~kvm-move-vmcs-accessors-to-vmxc drivers/kvm/kvm_vmx.h
--- a/drivers/kvm/kvm_vmx.h~kvm-move-vmcs-accessors-to-vmxc
+++ a/drivers/kvm/kvm_vmx.h
@@ -1,22 +1,6 @@
 #ifndef __KVM_VMX_H
 #define __KVM_VMX_H
 
-static inline void vmcs_write16(unsigned long field, u16 value)
-{
-	vmcs_writel(field, value);
-}
-
-static inline void vmcs_write64(unsigned long field, u64 value)
-{
-#ifdef __x86_64__
-	vmcs_writel(field, value);
-#else
-	vmcs_writel(field, value);
-	asm volatile ("");
-	vmcs_writel(field+1, value >> 32);
-#endif
-}
-
 #ifdef __x86_64__
 /*
  * avoid save/load MSR_SYSCALL_MASK and MSR_LSTAR by std vt
diff -puN drivers/kvm/vmx.c~kvm-move-vmcs-accessors-to-vmxc drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-move-vmcs-accessors-to-vmxc
+++ a/drivers/kvm/vmx.c
@@ -103,6 +103,66 @@ static void __vcpu_clear(void *arg)
 		per_cpu(current_vmcs, cpu) = 0;
 }
 
+static unsigned long vmcs_readl(unsigned long field)
+{
+	unsigned long value;
+
+	asm volatile (ASM_VMX_VMREAD_RDX_RAX
+		      : "=a"(value) : "d"(field) : "cc");
+	return value;
+}
+
+static u16 vmcs_read16(unsigned long field)
+{
+	return vmcs_readl(field);
+}
+
+static u32 vmcs_read32(unsigned long field)
+{
+	return vmcs_readl(field);
+}
+
+static u64 vmcs_read64(unsigned long field)
+{
+#ifdef __x86_64__
+	return vmcs_readl(field);
+#else
+	return vmcs_readl(field) | ((u64)vmcs_readl(field+1) << 32);
+#endif
+}
+
+static void vmcs_writel(unsigned long field, unsigned long value)
+{
+	u8 error;
+
+	asm volatile (ASM_VMX_VMWRITE_RAX_RDX "; setna %0"
+		       : "=q"(error) : "a"(value), "d"(field) : "cc" );
+	if (error)
+		printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
+		       field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
+}
+
+static void vmcs_write16(unsigned long field, u16 value)
+{
+	vmcs_writel(field, value);
+}
+
+static void vmcs_write32(unsigned long field, u32 value)
+{
+	vmcs_writel(field, value);
+}
+
+static void vmcs_write64(unsigned long field, u64 value)
+{
+#ifdef __x86_64__
+	vmcs_writel(field, value);
+#else
+	vmcs_writel(field, value);
+	asm volatile ("");
+	vmcs_writel(field+1, value >> 32);
+#endif
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

