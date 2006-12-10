From: akpm@osdl.org
Subject: - kvm-create-kvm-intelko-module.patch removed from -mm tree
Date: Sat, 09 Dec 2006 23:53:42 -0800
Message-ID: <200612100753.kBA7rg7F017744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59660 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760482AbWLJHxp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 02:53:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: create kvm-intel.ko module
has been removed from the -mm tree.  Its filename was
     kvm-create-kvm-intelko-module.patch

This patch was dropped because it was folded into kvm-userspace-interface.patch

------------------------------------------------------
Subject: KVM: create kvm-intel.ko module
From: Avi Kivity <avi@qumranet.com>

This patch lays the foundation for arch-independent kvm: it creates the
kvm-intel.ko module and prepares an arch function vector for the arch-specific
implementation.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/Kconfig    |   12 ++++++++++--
 drivers/kvm/Makefile   |    2 ++
 drivers/kvm/kvm.h      |    7 +++++++
 drivers/kvm/kvm_main.c |   13 +++++++++++++
 drivers/kvm/vmx.c      |   39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 71 insertions(+), 2 deletions(-)

diff -puN drivers/kvm/Kconfig~kvm-create-kvm-intelko-module drivers/kvm/Kconfig
--- a/drivers/kvm/Kconfig~kvm-create-kvm-intelko-module
+++ a/drivers/kvm/Kconfig
@@ -6,8 +6,9 @@ config KVM
 	depends on X86 && EXPERIMENTAL
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
-	  virtualization extensions.  You will need a fairly recent Intel
-	  processor equipped with VT extensions.
+	  virtualization extensions.  You will need a fairly recent
+	  processor equipped with virtualization extensions. You will also
+	  need to select one or more of the processor modules below.
 
 	  This module provides access to the hardware capabilities through
 	  a character device node named /dev/kvm.
@@ -16,3 +17,10 @@ config KVM
 	  will be called kvm.
 
 	  If unsure, say N.
+
+config KVM_INTEL
+	tristate "KVM for Intel processors support"
+	depends on KVM
+	---help---
+	  Provides support for KVM on Intel processors equipped with the VT
+	  extensions.
diff -puN drivers/kvm/Makefile~kvm-create-kvm-intelko-module drivers/kvm/Makefile
--- a/drivers/kvm/Makefile~kvm-create-kvm-intelko-module
+++ a/drivers/kvm/Makefile
@@ -4,3 +4,5 @@
 
 kvm-objs := kvm_main.o mmu.o x86_emulate.o
 obj-$(CONFIG_KVM) += kvm.o
+kvm-intel-objs = vmx.o
+obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
diff -puN drivers/kvm/kvm.h~kvm-create-kvm-intelko-module drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-create-kvm-intelko-module
+++ a/drivers/kvm/kvm.h
@@ -235,11 +235,18 @@ struct kvm_stat {
 	u32 irq_exits;
 };
 
+struct kvm_arch_ops {
+};
+
 extern struct kvm_stat kvm_stat;
+extern struct kvm_arch_ops *kvm_arch_ops;
 
 #define kvm_printf(kvm, fmt ...) printk(KERN_DEBUG fmt)
 #define vcpu_printf(vcpu, fmt...) kvm_printf(vcpu->kvm, fmt)
 
+void kvm_init_arch(struct kvm_arch_ops *ops);
+void kvm_exit_arch(void);
+
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_init(struct kvm_vcpu *vcpu);
 
diff -puN drivers/kvm/kvm_main.c~kvm-create-kvm-intelko-module drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-create-kvm-intelko-module
+++ a/drivers/kvm/kvm_main.c
@@ -41,6 +41,7 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+struct kvm_arch_ops *kvm_arch_ops;
 struct kvm_stat kvm_stat;
 
 static struct kvm_stats_debugfs_item {
@@ -3612,6 +3613,15 @@ static void kvm_exit_debug(void)
 
 hpa_t bad_page_address;
 
+void kvm_init_arch(struct kvm_arch_ops *ops)
+{
+	kvm_arch_ops = ops;
+}
+
+void kvm_exit_arch(void)
+{
+}
+
 static __init int kvm_init(void)
 {
 	static struct page *bad_page;
@@ -3671,3 +3681,6 @@ static __exit void kvm_exit(void)
 
 module_init(kvm_init)
 module_exit(kvm_exit)
+
+EXPORT_SYMBOL_GPL(kvm_init_arch);
+EXPORT_SYMBOL_GPL(kvm_exit_arch);
diff -puN /dev/null drivers/kvm/vmx.c
--- /dev/null
+++ a/drivers/kvm/vmx.c
@@ -0,0 +1,39 @@
+/*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * This module enables machines with Intel VT-x extensions to run virtual
+ * machines without emulation or binary translation.
+ *
+ * Copyright (C) 2006 Qumranet, Inc.
+ *
+ * Authors:
+ *   Avi Kivity   <avi@qumranet.com>
+ *   Yaniv Kamay  <yaniv@qumranet.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#include "kvm.h"
+#include <linux/module.h>
+
+MODULE_AUTHOR("Qumranet");
+MODULE_LICENSE("GPL");
+
+static struct kvm_arch_ops vmx_arch_ops = {
+};
+
+static int __init vmx_init(void)
+{
+	kvm_init_arch(&vmx_arch_ops);
+	return 0;
+}
+
+static void __exit vmx_exit(void)
+{
+	kvm_exit_arch();
+}
+
+module_init(vmx_init)
+module_exit(vmx_exit)
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
kvm-userspace-interface.patch
kvm-create-kvm-intelko-module.patch
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

