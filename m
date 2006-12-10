From: akpm@osdl.org
Subject: - kvm-make-hardware-detection-an-arch-operation.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:48 -0800
Message-ID: <200612100753.kBA7rmlx017750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59671 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760485AbWLJHxv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make hardware detection an arch operation
has been removed from the -mm tree.  Its filename was
     kvm-make-hardware-detection-an-arch-operation.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make hardware detection an arch operation
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    2 ++
 drivers/kvm/kvm_main.c |   33 ++++++++++-----------------------
 drivers/kvm/vmx.c      |   18 ++++++++++++++++++
 3 files changed, 30 insertions(+), 23 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-hardware-detection-an-arch-operation drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-hardware-detection-an-arch-operation
+++ a/drivers/kvm/kvm.h
@@ -236,6 +236,8 @@ struct kvm_stat {
 };
 
 struct kvm_arch_ops {
+	int (*cpu_has_kvm_support)(void);          /* __init */
+	int (*disabled_by_bios)(void);             /* __init */
 };
 
 extern struct kvm_stat kvm_stat;
diff -puN drivers/kvm/kvm_main.c~kvm-make-hardware-detection-an-arch-operation drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-hardware-detection-an-arch-operation
+++ a/drivers/kvm/kvm_main.c
@@ -527,12 +527,6 @@ static void free_vmcs(struct vmcs *vmcs)
 	free_pages((unsigned long)vmcs, vmcs_descriptor.order);
 }
 
-static __init int cpu_has_kvm_support(void)
-{
-	unsigned long ecx = cpuid_ecx(1);
-	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
-}
-
 static __exit void free_kvm_area(void)
 {
 	int cpu;
@@ -559,14 +553,6 @@ static __init int alloc_kvm_area(void)
 	return 0;
 }
 
-static __init int vmx_disabled_by_bios(void)
-{
-	u64 msr;
-
-	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
-	return (msr & 5) == 1; /* locked but not enabled */
-}
-
 static __init void kvm_enable(void *garbage)
 {
 	int cpu = raw_smp_processor_id();
@@ -3617,6 +3603,16 @@ int kvm_init_arch(struct kvm_arch_ops *o
 	int r;
 
 	kvm_arch_ops = ops;
+
+	if (!kvm_arch_ops->cpu_has_kvm_support()) {
+		printk(KERN_ERR "kvm: no hardware support\n");
+		return -EOPNOTSUPP;
+	}
+	if (kvm_arch_ops->disabled_by_bios()) {
+		printk(KERN_ERR "kvm: disabled by bios\n");
+		return -EOPNOTSUPP;
+	}
+
 	kvm_chardev_ops.owner = module;
 
 	r = misc_register(&kvm_dev);
@@ -3639,15 +3635,6 @@ static __init int kvm_init(void)
 	static struct page *bad_page;
 	int r = 0;
 
-	if (!cpu_has_kvm_support()) {
-		printk(KERN_ERR "kvm: no hardware support\n");
-		return -EOPNOTSUPP;
-	}
-	if (vmx_disabled_by_bios()) {
-		printk(KERN_ERR "kvm: disabled by bios\n");
-		return -EOPNOTSUPP;
-	}
-
 	kvm_init_debug();
 
 	setup_vmcs_descriptor();
diff -puN drivers/kvm/vmx.c~kvm-make-hardware-detection-an-arch-operation drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-hardware-detection-an-arch-operation
+++ a/drivers/kvm/vmx.c
@@ -18,10 +18,28 @@
 #include "kvm.h"
 #include <linux/module.h>
 
+#define MSR_IA32_FEATURE_CONTROL 		0x03a
+
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+static __init int cpu_has_kvm_support(void)
+{
+	unsigned long ecx = cpuid_ecx(1);
+	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
+}
+
+static __init int vmx_disabled_by_bios(void)
+{
+	u64 msr;
+
+	rdmsrl(MSR_IA32_FEATURE_CONTROL, msr);
+	return (msr & 5) == 1; /* locked but not enabled */
+}
+
 static struct kvm_arch_ops vmx_arch_ops = {
+	.cpu_has_kvm_support = cpu_has_kvm_support,
+	.disabled_by_bios = vmx_disabled_by_bios,
 };
 
 static int __init vmx_init(void)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-make-hardware-detection-an-arch-operation.patch
kvm-make-the-per-cpu-enable-disable-functions-arch.patch
kvm-make-the-hardware-setup-operations-non-percpu.patch
kvm-make-the-guest-debugger-an-arch-operation.patch
kvm-make-msr-accessors-arch-operations.patch
kvm-make-the-segment-accessors-arch-operations.patch
kvm-cache-guest-cr4-in-vcpu-structure.patch
kvm-cache-guest-cr0-in-vcpu-structure.patch
kvm-add-get_segment_base-arch-accessor.patch
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

