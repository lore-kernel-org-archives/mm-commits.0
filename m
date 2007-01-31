From: akpm@osdl.org
Subject: + kvm-host-suspend-resume-support.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:51:34 -0800
Message-ID: <200701310051.l0V0pYBl002976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59617 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbXAaAvv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: Host suspend/resume support
has been added to the -mm tree.  Its filename is
     kvm-host-suspend-resume-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Host suspend/resume support
From: Avi Kivity <avi@qumranet.com>

Add the necessary callbacks to suspend and resume a host running kvm.  This is
just a repeat of the cpu hotplug/unplug work.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   41 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 40 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-host-suspend-resume-support drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-host-suspend-resume-support
+++ a/drivers/kvm/kvm_main.c
@@ -34,6 +34,7 @@
 #include <linux/highmem.h>
 #include <linux/file.h>
 #include <asm/desc.h>
+#include <linux/sysdev.h>
 #include <linux/cpu.h>
 
 #include "x86_emulate.h"
@@ -2116,6 +2117,30 @@ static void kvm_exit_debug(void)
 	debugfs_remove(debugfs_dir);
 }
 
+static int kvm_suspend(struct sys_device *dev, pm_message_t state)
+{
+	decache_vcpus_on_cpu(raw_smp_processor_id());
+	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
+	return 0;
+}
+
+static int kvm_resume(struct sys_device *dev)
+{
+	on_each_cpu(kvm_arch_ops->hardware_enable, 0, 0, 1);
+	return 0;
+}
+
+static struct sysdev_class kvm_sysdev_class = {
+	set_kset_name("kvm"),
+	.suspend = kvm_suspend,
+	.resume = kvm_resume,
+};
+
+static struct sys_device kvm_sysdev = {
+	.id = 0,
+	.cls = &kvm_sysdev_class,
+};
+
 hpa_t bad_page_address;
 
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
@@ -2148,6 +2173,14 @@ int kvm_init_arch(struct kvm_arch_ops *o
 		goto out_free_1;
 	register_reboot_notifier(&kvm_reboot_notifier);
 
+	r = sysdev_class_register(&kvm_sysdev_class);
+	if (r)
+		goto out_free_2;
+
+	r = sysdev_register(&kvm_sysdev);
+	if (r)
+		goto out_free_3;
+
 	kvm_chardev_ops.owner = module;
 
 	r = misc_register(&kvm_dev);
@@ -2159,6 +2192,10 @@ int kvm_init_arch(struct kvm_arch_ops *o
 	return r;
 
 out_free:
+	sysdev_unregister(&kvm_sysdev);
+out_free_3:
+	sysdev_class_unregister(&kvm_sysdev_class);
+out_free_2:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_1:
@@ -2170,8 +2207,10 @@ out_free_1:
 void kvm_exit_arch(void)
 {
 	misc_deregister(&kvm_dev);
-
+	sysdev_unregister(&kvm_sysdev);
+	sysdev_class_unregister(&kvm_sysdev_class);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(kvm_arch_ops->hardware_disable, 0, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	kvm_arch_ops = NULL;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
kvm-optimize-inline-assembly.patch
kvm-fix-asm-constraint-for-lldt-instruction.patch
kvm-fix-gva_to_gpa.patch
kvm-vmx-handle-triple-faults-by-returning-exit_reason_shutdown-to-userspace.patch
kvm-fix-mmu-going-crazy-of-guest-sets-cr0wp-==-0.patch
kvm-svm-hack-initial-cpu-csbase-to-be-consistent-with-intel.patch
kvm-two-way-apic-tpr-synchronization.patch
kvm-vmx-reload-ds-and-es-even-in-64-bit-mode.patch
kvm-fix-mismatch-between-32-bit-and-64-bit-abi.patch
kvm-fix-vcpu-freeing-bug.patch
hotplug-allow-modules-to-use-the-cpu-hotplug-notifiers.patch
kvm-add-a-global-list-of-all-virtual-machines.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
kvm-vmx-add-vcpu_clear.patch
kvm-cpu-hotplug-support.patch
kvm-host-suspend-resume-support.patch
