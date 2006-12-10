From: akpm@osdl.org
Subject: - kvm-move-the-vmx-tsc-accessors-to-vmxc.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:00 -0800
Message-ID: <200612100755.kBA7t03D017836@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760421AbWLJHzC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: move the vmx tsc accessors to vmx.c
has been removed from the -mm tree.  Its filename was
     kvm-move-the-vmx-tsc-accessors-to-vmxc.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: move the vmx tsc accessors to vmx.c
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   27 ---------------------------
 drivers/kvm/vmx.c      |   27 +++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 29 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-move-the-vmx-tsc-accessors-to-vmxc drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-move-the-vmx-tsc-accessors-to-vmxc
+++ a/drivers/kvm/kvm_main.c
@@ -475,33 +475,6 @@ static void inject_gp(struct kvm_vcpu *v
 	kvm_arch_ops->inject_gp(vcpu, 0);
 }
 
-/*
- * reads and returns guest's timestamp counter "register"
- * guest_tsc = host_tsc + tsc_offset    -- 21.3
- */
-u64 guest_read_tsc(void)
-{
-	u64 host_tsc, tsc_offset;
-
-	rdtscll(host_tsc);
-	tsc_offset = vmcs_read64(TSC_OFFSET);
-	return host_tsc + tsc_offset;
-}
-EXPORT_SYMBOL_GPL(guest_read_tsc);
-
-/*
- * writes 'guest_tsc' into guest's timestamp counter "register"
- * guest_tsc = host_tsc + tsc_offset ==> tsc_offset = guest_tsc - host_tsc
- */
-void guest_write_tsc(u64 guest_tsc)
-{
-	u64 host_tsc;
-
-	rdtscll(host_tsc);
-	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
-}
-EXPORT_SYMBOL_GPL(guest_write_tsc);
-
 static int pdptrs_have_reserved_bits_set(struct kvm_vcpu *vcpu,
 					 unsigned long cr3)
 {
diff -puN drivers/kvm/vmx.c~kvm-move-the-vmx-tsc-accessors-to-vmxc drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-move-the-vmx-tsc-accessors-to-vmxc
+++ a/drivers/kvm/vmx.c
@@ -59,8 +59,6 @@ static const u32 vmx_msr_index[] = {
 };
 #define NR_VMX_MSR (sizeof(vmx_msr_index) / sizeof(*vmx_msr_index))
 
-u64 guest_read_tsc(void);
-void guest_write_tsc(u64 guest_tsc);
 struct vmx_msr_entry *find_msr_entry(struct kvm_vcpu *vcpu, u32 msr);
 
 static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
@@ -94,6 +92,31 @@ static void vmx_inject_gp(struct kvm_vcp
 		     INTR_INFO_VALID_MASK);
 }
 
+/*
+ * reads and returns guest's timestamp counter "register"
+ * guest_tsc = host_tsc + tsc_offset    -- 21.3
+ */
+static u64 guest_read_tsc(void)
+{
+	u64 host_tsc, tsc_offset;
+
+	rdtscll(host_tsc);
+	tsc_offset = vmcs_read64(TSC_OFFSET);
+	return host_tsc + tsc_offset;
+}
+
+/*
+ * writes 'guest_tsc' into guest's timestamp counter "register"
+ * guest_tsc = host_tsc + tsc_offset ==> tsc_offset = guest_tsc - host_tsc
+ */
+static void guest_write_tsc(u64 guest_tsc)
+{
+	u64 host_tsc;
+
+	rdtscll(host_tsc);
+	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
+}
+
 static void reload_tss(void)
 {
 #ifndef __x86_64__
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-move-the-vmx-tsc-accessors-to-vmxc.patch
kvm-access-rflags-through-an-arch-operation.patch
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

