From: akpm@linux-foundation.org
Subject: - kvm-host-suspend-resume-support.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:08 -0800
Message-ID: <200702122249.l1CMn8if014087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030383AbXBLWtM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: Host suspend/resume support
has been removed from the -mm tree.  Its filename was
     kvm-host-suspend-resume-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Host suspend/resume support
From: Avi Kivity <avi@qumranet.com>

Add the necessary callbacks to suspend and resume a host running kvm.  This is
just a repeat of the cpu hotplug/unplug work.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |   41 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

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
@@ -2117,6 +2118,30 @@ static void kvm_exit_debug(void)
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
@@ -2149,6 +2174,14 @@ int kvm_init_arch(struct kvm_arch_ops *o
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
@@ -2160,6 +2193,10 @@ int kvm_init_arch(struct kvm_arch_ops *o
 	return r;
 
 out_free:
+	sysdev_unregister(&kvm_sysdev);
+out_free_3:
+	sysdev_class_unregister(&kvm_sysdev_class);
+out_free_2:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_1:
@@ -2171,8 +2208,10 @@ out_free_1:
 void kvm_exit_arch(void)
 {
 	misc_deregister(&kvm_dev);
-
+	sysdev_unregister(&kvm_sysdev);
+	sysdev_class_unregister(&kvm_sysdev_class);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	kvm_arch_ops = NULL;
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
