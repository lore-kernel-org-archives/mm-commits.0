From: akpm@osdl.org
Subject: - kvm-make-dev-registration-happen-when-the-arch.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:45 -0800
Message-ID: <200612100753.kBA7rjG1017747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59667 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760477AbWLJHxr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: make /dev/registration happen when the arch specific module is loaded
has been removed from the -mm tree.  Its filename was
     kvm-make-dev-registration-happen-when-the-arch.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: make /dev/registration happen when the arch specific module is loaded
From: Avi Kivity <avi@qumranet.com>

This avoids exposing the driver capabilities before they are loaded.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    2 +-
 drivers/kvm/kvm_main.c |   24 ++++++++++++++----------
 drivers/kvm/vmx.c      |    2 +-
 3 files changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-make-dev-registration-happen-when-the-arch drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-make-dev-registration-happen-when-the-arch
+++ a/drivers/kvm/kvm.h
@@ -244,7 +244,7 @@ extern struct kvm_arch_ops *kvm_arch_ops
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
 
-void kvm_init_arch(struct kvm_arch_ops *ops);
+int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module);
 void kvm_exit_arch(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
diff -puN drivers/kvm/kvm_main.c~kvm-make-dev-registration-happen-when-the-arch drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-make-dev-registration-happen-when-the-arch
+++ a/drivers/kvm/kvm_main.c
@@ -3559,7 +3559,6 @@ static int kvm_dev_mmap(struct file *fil
 }
 
 static struct file_operations kvm_chardev_ops = {
-	.owner		= THIS_MODULE,
 	.open		= kvm_dev_open,
 	.release        = kvm_dev_release,
 	.unlocked_ioctl = kvm_dev_ioctl,
@@ -3613,13 +3612,26 @@ static void kvm_exit_debug(void)
 
 hpa_t bad_page_address;
 
-void kvm_init_arch(struct kvm_arch_ops *ops)
+int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 {
+	int r;
+
 	kvm_arch_ops = ops;
+	kvm_chardev_ops.owner = module;
+
+	r = misc_register(&kvm_dev);
+	if (r) {
+		printk (KERN_ERR "kvm: misc device register failed\n");
+		goto out_free;
+	}
+
+out_free:
+	return r;
 }
 
 void kvm_exit_arch(void)
 {
+	misc_deregister(&kvm_dev);
 }
 
 static __init int kvm_init(void)
@@ -3645,13 +3657,6 @@ static __init int kvm_init(void)
 	on_each_cpu(kvm_enable, 0, 0, 1);
 	register_reboot_notifier(&kvm_reboot_notifier);
 
-	r = misc_register(&kvm_dev);
-	if (r) {
-		printk (KERN_ERR "kvm: misc device register failed\n");
-		goto out_free;
-	}
-
-
 	if ((bad_page = alloc_page(GFP_KERNEL)) == NULL) {
 		r = -ENOMEM;
 		goto out_free;
@@ -3672,7 +3677,6 @@ out:
 static __exit void kvm_exit(void)
 {
 	kvm_exit_debug();
-	misc_deregister(&kvm_dev);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	on_each_cpu(kvm_disable, 0, 0, 1);
 	free_kvm_area();
diff -puN drivers/kvm/vmx.c~kvm-make-dev-registration-happen-when-the-arch drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-make-dev-registration-happen-when-the-arch
+++ a/drivers/kvm/vmx.c
@@ -26,7 +26,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 
 static int __init vmx_init(void)
 {
-	kvm_init_arch(&vmx_arch_ops);
+	kvm_init_arch(&vmx_arch_ops, THIS_MODULE);
 	return 0;
 }
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-make-dev-registration-happen-when-the-arch.patch
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

