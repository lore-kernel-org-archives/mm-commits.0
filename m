From: akpm@osdl.org
Subject: - kvm-add-a-set_cr0_no_modeswitch-arch-accessor.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:55:10 -0800
Message-ID: <200612100755.kBA7tAB3017853@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59802 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760562AbWLJHzM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:55:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: add a set_cr0_no_modeswitch() arch accessor
has been removed from the -mm tree.  Its filename was
     kvm-add-a-set_cr0_no_modeswitch-arch-accessor.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: add a set_cr0_no_modeswitch() arch accessor
From: Avi Kivity <avi@qumranet.com>

A side effect of using vm86 mode to simulate real mode is that we mangle the
segment registers on mode switching.  The new set_cr0_no_modeswitch() accessor
avoids the mangling when the restore is due to loading the virtual machine
from a file.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    4 ++--
 drivers/kvm/kvm_main.c |    7 +------
 drivers/kvm/vmx.c      |   16 ++++++++++++++--
 3 files changed, 17 insertions(+), 10 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-add-a-set_cr0_no_modeswitch-arch-accessor drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-add-a-set_cr0_no_modeswitch-arch-accessor
+++ a/drivers/kvm/kvm.h
@@ -271,6 +271,8 @@ struct kvm_arch_ops {
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
+	void (*set_cr0_no_modeswitch)(struct kvm_vcpu *vcpu,
+				      unsigned long cr0);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
@@ -292,8 +294,6 @@ struct kvm_arch_ops {
 	int (*run)(struct kvm_vcpu *vcpu, struct kvm_run *run);
 	int (*vcpu_setup)(struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
-
-	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu); /* hack */
 };
 
 extern struct kvm_stat kvm_stat;
diff -puN drivers/kvm/kvm_main.c~kvm-add-a-set_cr0_no_modeswitch-arch-accessor drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-a-set_cr0_no_modeswitch-arch-accessor
+++ a/drivers/kvm/kvm_main.c
@@ -1515,12 +1515,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 	vcpu->apic_base = sregs->apic_base;
 
 	mmu_reset_needed |= vcpu->cr0 != sregs->cr0;
-	vcpu->rmode.active = ((sregs->cr0 & CR0_PE_MASK) == 0);
-	kvm_arch_ops->update_exception_bitmap(vcpu);
-	vmcs_writel(CR0_READ_SHADOW, sregs->cr0);
-	vmcs_writel(GUEST_CR0,
-		    (sregs->cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
-	vcpu->cr0 = sregs->cr0;
+	kvm_arch_ops->set_cr0_no_modeswitch(vcpu, sregs->cr0);
 
 	mmu_reset_needed |= vcpu->cr4 != sregs->cr4;
 	kvm_arch_ops->set_cr4(vcpu, sregs->cr4);
diff -puN drivers/kvm/vmx.c~kvm-add-a-set_cr0_no_modeswitch-arch-accessor drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-a-set_cr0_no_modeswitch-arch-accessor
+++ a/drivers/kvm/vmx.c
@@ -609,6 +609,19 @@ static void vmx_set_cr0(struct kvm_vcpu 
 	vcpu->cr0 = cr0;
 }
 
+/*
+ * Used when restoring the VM to avoid corrupting segment registers
+ */
+static void vmx_set_cr0_no_modeswitch(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	vcpu->rmode.active = ((cr0 & CR0_PE_MASK) == 0);
+	update_exception_bitmap(vcpu);
+	vmcs_writel(CR0_READ_SHADOW, cr0);
+	vmcs_writel(GUEST_CR0,
+		    (cr0 & ~KVM_GUEST_CR0_MASK) | KVM_VM_CR0_ALWAYS_ON);
+	vcpu->cr0 = cr0;
+}
+
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	vmcs_writel(GUEST_CR3, cr3);
@@ -1742,6 +1755,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.set_segment = vmx_set_segment,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.set_cr0 = vmx_set_cr0,
+	.set_cr0_no_modeswitch = vmx_set_cr0_no_modeswitch,
 	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
 #ifdef __x86_64__
@@ -1764,8 +1778,6 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.run = vmx_vcpu_run,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.vcpu_setup = vmx_vcpu_setup,
-
-	.update_exception_bitmap = update_exception_bitmap,
 };
 
 static int __init vmx_init(void)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

