From: akpm@osdl.org
Subject: - kvm-add-idt-and-gdt-descriptor-accessors.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:54:16 -0800
Message-ID: <200612100754.kBA7sGCx017781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760505AbWLJHyS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:54:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: add idt and gdt descriptor accessors
has been removed from the -mm tree.  Its filename was
     kvm-add-idt-and-gdt-descriptor-accessors.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: add idt and gdt descriptor accessors
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    9 +++++++++
 drivers/kvm/kvm_main.c |   33 ++++++++++++++-------------------
 drivers/kvm/vmx.c      |   28 ++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 19 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-add-idt-and-gdt-descriptor-accessors drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-add-idt-and-gdt-descriptor-accessors
+++ a/drivers/kvm/kvm.h
@@ -236,6 +236,11 @@ struct kvm_stat {
 	u32 irq_exits;
 };
 
+struct descriptor_table {
+	u16 limit;
+	unsigned long base;
+} __attribute__((packed));
+
 struct kvm_arch_ops {
 	int (*cpu_has_kvm_support)(void);          /* __init */
 	int (*disabled_by_bios)(void);             /* __init */
@@ -253,6 +258,10 @@ struct kvm_arch_ops {
 			    struct kvm_segment *var, int seg);
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
+	void (*get_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
+	void (*set_idt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
+	void (*get_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
+	void (*set_gdt)(struct kvm_vcpu *vcpu, struct descriptor_table *dt);
 };
 
 extern struct kvm_stat kvm_stat;
diff -puN drivers/kvm/kvm_main.c~kvm-add-idt-and-gdt-descriptor-accessors drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-idt-and-gdt-descriptor-accessors
+++ a/drivers/kvm/kvm_main.c
@@ -155,11 +155,6 @@ struct vmx_msr_entry *find_msr_entry(str
 }
 EXPORT_SYMBOL_GPL(find_msr_entry);
 
-struct descriptor_table {
-	u16 limit;
-	unsigned long base;
-} __attribute__((packed));
-
 static void get_gdt(struct descriptor_table *table)
 {
 	asm ("sgdt %0" : "=m"(*table));
@@ -2828,6 +2823,7 @@ static void get_segment(struct kvm_vcpu 
 static int kvm_dev_ioctl_get_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
 {
 	struct kvm_vcpu *vcpu;
+	struct descriptor_table dt;
 
 	if (sregs->vcpu < 0 || sregs->vcpu >= KVM_MAX_VCPUS)
 		return -EINVAL;
@@ -2845,13 +2841,12 @@ static int kvm_dev_ioctl_get_sregs(struc
 	get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
-#define get_dtable(var, table) \
-	sregs->var.limit = vmcs_read32(GUEST_##table##_LIMIT), \
-		sregs->var.base = vmcs_readl(GUEST_##table##_BASE)
-
-	get_dtable(idt, IDTR);
-	get_dtable(gdt, GDTR);
-#undef get_dtable
+	kvm_arch_ops->get_idt(vcpu, &dt);
+	sregs->idt.limit = dt.limit;
+	sregs->idt.base = dt.base;
+	kvm_arch_ops->get_gdt(vcpu, &dt);
+	sregs->gdt.limit = dt.limit;
+	sregs->gdt.base = dt.base;
 
 	sregs->cr0 = vcpu->cr0;
 	sregs->cr2 = vcpu->cr2;
@@ -2880,6 +2875,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 	struct kvm_vcpu *vcpu;
 	int mmu_reset_needed = 0;
 	int i;
+	struct descriptor_table dt;
 
 	if (sregs->vcpu < 0 || sregs->vcpu >= KVM_MAX_VCPUS)
 		return -EINVAL;
@@ -2897,13 +2893,12 @@ static int kvm_dev_ioctl_set_sregs(struc
 	set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
 	set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
 
-#define set_dtable(var, table) \
-	vmcs_write32(GUEST_##table##_LIMIT, sregs->var.limit), \
-	vmcs_writel(GUEST_##table##_BASE, sregs->var.base)
-
-	set_dtable(idt, IDTR);
-	set_dtable(gdt, GDTR);
-#undef set_dtable
+	dt.limit = sregs->idt.limit;
+	dt.base = sregs->idt.base;
+	kvm_arch_ops->set_idt(vcpu, &dt);
+	dt.limit = sregs->gdt.limit;
+	dt.base = sregs->gdt.base;
+	kvm_arch_ops->set_gdt(vcpu, &dt);
 
 	vcpu->cr2 = sregs->cr2;
 	mmu_reset_needed |= vcpu->cr3 != sregs->cr3;
diff -puN drivers/kvm/vmx.c~kvm-add-idt-and-gdt-descriptor-accessors drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-add-idt-and-gdt-descriptor-accessors
+++ a/drivers/kvm/vmx.c
@@ -363,6 +363,30 @@ static void vmx_set_segment(struct kvm_v
 	vmcs_write32(sf->ar_bytes, ar);
 }
 
+static void vmx_get_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
+{
+	dt->limit = vmcs_read32(GUEST_IDTR_LIMIT);
+	dt->base = vmcs_readl(GUEST_IDTR_BASE);
+}
+
+static void vmx_set_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
+{
+	vmcs_write32(GUEST_IDTR_LIMIT, dt->limit);
+	vmcs_writel(GUEST_IDTR_BASE, dt->base);
+}
+
+static void vmx_get_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
+{
+	dt->limit = vmcs_read32(GUEST_GDTR_LIMIT);
+	dt->base = vmcs_readl(GUEST_GDTR_BASE);
+}
+
+static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
+{
+	vmcs_write32(GUEST_GDTR_LIMIT, dt->limit);
+	vmcs_writel(GUEST_GDTR_BASE, dt->base);
+}
+
 static struct kvm_arch_ops vmx_arch_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -377,6 +401,10 @@ static struct kvm_arch_ops vmx_arch_ops 
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
+	.get_idt = vmx_get_idt,
+	.set_idt = vmx_set_idt,
+	.get_gdt = vmx_get_gdt,
+	.set_gdt = vmx_set_gdt,
 };
 
 static int __init vmx_init(void)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-add-idt-and-gdt-descriptor-accessors.patch
kvm-make-syncing-the-register-file-to-the-vcpu.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation.patch
kvm-make-the-vcpu-execution-loop-an-arch-operation-build-fix.patch
kvm-move-the-vmx-exit-handlers-to-vmxc.patch
kvm-make-vcpu_setup-an-arch-operation.patch
kvm-make-__set_cr0-and-dependencies-arch-operations.patch
kvm-make-__set_cr4-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation.patch
kvm-make-__set_efer-an-arch-operation-build-fix.patch
kvm-make-set_cr3-and-tlb-flushing-arch-operations.patch
kvm-make-inject_page_fault-an-arch-operation.patch
kvm-make-inject_gp-an-arch-operation.patch
kvm-use-the-idt-and-gdt-accessors-in-realmode-emulation.patch
kvm-use-the-general-purpose-register-accessors-rather.patch
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

