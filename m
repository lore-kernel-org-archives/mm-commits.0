From: akpm@osdl.org
Subject: - kvm-make-the-per-cpu-enable-disable-functions-arch.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:51 -0800
Message-ID: <200612100753.kBA7rpPc017753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59674 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760486AbWLJHxy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make the per-cpu enable/disable functions arch operations
has been removed from the -mm tree.  Its filename was
     kvm-make-the-per-cpu-enable-disable-functions-arch.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make the per-cpu enable/disable functions arch operations
From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    2 ++
 drivers/kvm/kvm_main.c |   38 ++++++++++----------------------------
 drivers/kvm/vmx.c      |   24 ++++++++++++++++++++++++
 drivers/kvm/vmx.h      |    2 ++
 4 files changed, 38 insertions(+), 28 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-the-per-cpu-enable-disable-functions-arch drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-the-per-cpu-enable-disable-functions-arch
+++ a/drivers/kvm/kvm.h
@@ -238,6 +238,8 @@ struct kvm_stat {
 struct kvm_arch_ops {
 	int (*cpu_has_kvm_support)(void);          /* __init */
 	int (*disabled_by_bios)(void);             /* __init */
+	void (*hardware_enable)(void *dummy);      /* __init */
+	void (*hardware_disable)(void *dummy);
 };
 
 extern struct kvm_stat kvm_stat;
diff -puN drivers/kvm/kvm_main.c~kvm-make-the-per-cpu-enable-disable-functions-arch drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-the-per-cpu-enable-disable-functions-arch
+++ a/drivers/kvm/kvm_main.c
@@ -135,7 +135,6 @@ static const u32 vmx_msr_index[] = {
 #define CR0_RESEVED_BITS 0xffffffff1ffaffc0ULL
 #define LMSW_GUEST_MASK 0x0eULL
 #define CR4_RESEVED_BITS (~((1ULL << 11) - 1))
-#define CR4_VMXE 0x2000
 #define CR8_RESEVED_BITS (~0x0fULL)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
@@ -300,7 +299,8 @@ static void reload_tss(void)
 #endif
 }
 
-static DEFINE_PER_CPU(struct vmcs *, vmxarea);
+DEFINE_PER_CPU(struct vmcs *, vmxarea);
+EXPORT_SYMBOL_GPL(per_cpu__vmxarea); /* temporary hack */
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 
 static struct vmcs_descriptor {
@@ -553,26 +553,6 @@ static __init int alloc_kvm_area(void)
 	return 0;
 }
 
-static __init void kvm_enable(void *garbage)
-{
-	int cpu = raw_smp_processor_id();
-	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
-	u64 old;
-
-	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-	if ((old & 5) == 0)
-		/* enable and lock */
-		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | 5);
-	write_cr4(read_cr4() | CR4_VMXE); /* FIXME: not cpu hotplug safe */
-	asm volatile (ASM_VMX_VMXON_RAX : : "a"(&phys_addr), "m"(phys_addr)
-		      : "memory", "cc");
-}
-
-static void kvm_disable(void *garbage)
-{
-	asm volatile (ASM_VMX_VMXOFF : : : "cc");
-}
-
 static int kvm_dev_open(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
@@ -3566,8 +3546,8 @@ static int kvm_reboot(struct notifier_bl
 		 * Some (well, at least mine) BIOSes hang on reboot if
 		 * in vmx root mode.
 		 */
-		printk(KERN_INFO "kvm: exiting vmx mode\n");
-		on_each_cpu(kvm_disable, 0, 0, 1);
+		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
+		on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
 	}
 	return NOTIFY_OK;
 }
@@ -3613,6 +3593,9 @@ int kvm_init_arch(struct kvm_arch_ops *o
 		return -EOPNOTSUPP;
 	}
 
+	on_each_cpu(kvm_arch_ops->hardware_enable, 0, 0, 1);
+	register_reboot_notifier(&kvm_reboot_notifier);
+
 	kvm_chardev_ops.owner = module;
 
 	r = misc_register(&kvm_dev);
@@ -3628,6 +3611,9 @@ out_free:
 void kvm_exit_arch(void)
 {
 	misc_deregister(&kvm_dev);
+
+	unregister_reboot_notifier(&kvm_reboot_notifier);
+	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
 }
 
 static __init int kvm_init(void)
@@ -3641,8 +3627,6 @@ static __init int kvm_init(void)
 	r = alloc_kvm_area();
 	if (r)
 		goto out;
-	on_each_cpu(kvm_enable, 0, 0, 1);
-	register_reboot_notifier(&kvm_reboot_notifier);
 
 	if ((bad_page = alloc_page(GFP_KERNEL)) == NULL) {
 		r = -ENOMEM;
@@ -3664,8 +3648,6 @@ out:
 static __exit void kvm_exit(void)
 {
 	kvm_exit_debug();
-	unregister_reboot_notifier(&kvm_reboot_notifier);
-	on_each_cpu(kvm_disable, 0, 0, 1);
 	free_kvm_area();
 	__free_page(pfn_to_page(bad_page_address >> PAGE_SHIFT));
 }
diff -puN drivers/kvm/vmx.c~kvm-make-the-per-cpu-enable-disable-functions-arch drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-the-per-cpu-enable-disable-functions-arch
+++ a/drivers/kvm/vmx.c
@@ -23,6 +23,8 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+DECLARE_PER_CPU(struct vmcs *, vmxarea);
+
 static __init int cpu_has_kvm_support(void)
 {
 	unsigned long ecx = cpuid_ecx(1);
@@ -37,9 +39,31 @@ static __init int vmx_disabled_by_bios(v
 	return (msr & 5) == 1; /* locked but not enabled */
 }
 
+static __init void hardware_enable(void *garbage)
+{
+	int cpu = raw_smp_processor_id();
+	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
+	u64 old;
+
+	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
+	if ((old & 5) == 0)
+		/* enable and lock */
+		wrmsrl(MSR_IA32_FEATURE_CONTROL, old | 5);
+	write_cr4(read_cr4() | CR4_VMXE); /* FIXME: not cpu hotplug safe */
+	asm volatile (ASM_VMX_VMXON_RAX : : "a"(&phys_addr), "m"(phys_addr)
+		      : "memory", "cc");
+}
+
+static void hardware_disable(void *garbage)
+{
+	asm volatile (ASM_VMX_VMXOFF : : : "cc");
+}
+
 static struct kvm_arch_ops vmx_arch_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
+	.hardware_enable = hardware_enable,
+	.hardware_disable = hardware_disable,
 };
 
 static int __init vmx_init(void)
diff -puN drivers/kvm/vmx.h~kvm-make-the-per-cpu-enable-disable-functions-arch drivers/kvm/vmx.h
--- a/drivers/kvm/vmx.h~kvm-make-the-per-cpu-enable-disable-functions-arch
+++ a/drivers/kvm/vmx.h
@@ -284,4 +284,6 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
+#define CR4_VMXE 0x2000
+
 #endif
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
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

