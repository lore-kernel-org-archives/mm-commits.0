From: akpm@linux-foundation.org
Subject: - kvm-cpu-hotplug-support.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:06 -0800
Message-ID: <200702122249.l1CMn65U014081@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45607 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030382AbXBLWtL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: cpu hotplug support
has been removed from the -mm tree.  Its filename was
     kvm-cpu-hotplug-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: cpu hotplug support
From: Avi Kivity <avi@qumranet.com>

On hotplug, we execute the hardware extension enable sequence.  On unplug, we
decache any vcpus that last ran on the exiting cpu, and execute the hardware
extension disable sequence.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm.h      |    1 
 drivers/kvm/kvm_main.c |   64 +++++++++++++++++++++++++++++++++++++++
 drivers/kvm/svm.c      |    5 +++
 drivers/kvm/vmx.c      |    8 ++++
 4 files changed, 77 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm.h~kvm-cpu-hotplug-support drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-cpu-hotplug-support
+++ a/drivers/kvm/kvm.h
@@ -341,6 +341,7 @@ struct kvm_arch_ops {
 
 	struct kvm_vcpu *(*vcpu_load)(struct kvm_vcpu *vcpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
 
 	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
 			       struct kvm_debug_guest *dbg);
diff -puN drivers/kvm/kvm_main.c~kvm-cpu-hotplug-support drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-cpu-hotplug-support
+++ a/drivers/kvm/kvm_main.c
@@ -34,6 +34,7 @@
 #include <linux/highmem.h>
 #include <linux/file.h>
 #include <asm/desc.h>
+#include <linux/cpu.h>
 
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
@@ -2039,6 +2040,64 @@ static struct notifier_block kvm_reboot_
 	.priority = 0,
 };
 
+/*
+ * Make sure that a cpu that is being hot-unplugged does not have any vcpus
+ * cached on it.
+ */
+static void decache_vcpus_on_cpu(int cpu)
+{
+	struct kvm *vm;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	spin_lock(&kvm_lock);
+	list_for_each_entry(vm, &vm_list, vm_list)
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = &vm->vcpus[i];
+			/*
+			 * If the vcpu is locked, then it is running on some
+			 * other cpu and therefore it is not cached on the
+			 * cpu in question.
+			 *
+			 * If it's not locked, check the last cpu it executed
+			 * on.
+			 */
+			if (mutex_trylock(&vcpu->mutex)) {
+				if (vcpu->cpu == cpu) {
+					kvm_arch_ops->vcpu_decache(vcpu);
+					vcpu->cpu = -1;
+				}
+				mutex_unlock(&vcpu->mutex);
+			}
+		}
+	spin_unlock(&kvm_lock);
+}
+
+static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
+			   void *v)
+{
+	int cpu = (long)v;
+
+	switch (val) {
+	case CPU_DEAD:
+	case CPU_UP_CANCELED:
+		decache_vcpus_on_cpu(cpu);
+		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
+					 NULL, 0, 1);
+		break;
+	case CPU_UP_PREPARE:
+		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
+					 NULL, 0, 1);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kvm_cpu_notifier = {
+	.notifier_call = kvm_cpu_hotplug,
+	.priority = 20, /* must be > scheduler priority */
+};
+
 static __init void kvm_init_debug(void)
 {
 	struct kvm_stats_debugfs_item *p;
@@ -2085,6 +2144,9 @@ int kvm_init_arch(struct kvm_arch_ops *o
 	    return r;
 
 	on_each_cpu(kvm_arch_ops->hardware_enable, NULL, 0, 1);
+	r = register_cpu_notifier(&kvm_cpu_notifier);
+	if (r)
+		goto out_free_1;
 	register_reboot_notifier(&kvm_reboot_notifier);
 
 	kvm_chardev_ops.owner = module;
@@ -2099,6 +2161,8 @@ int kvm_init_arch(struct kvm_arch_ops *o
 
 out_free:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
+	unregister_cpu_notifier(&kvm_cpu_notifier);
+out_free_1:
 	on_each_cpu(kvm_arch_ops->hardware_disable, NULL, 0, 1);
 	kvm_arch_ops->hardware_unsetup();
 	return r;
diff -puN drivers/kvm/svm.c~kvm-cpu-hotplug-support drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-cpu-hotplug-support
+++ a/drivers/kvm/svm.c
@@ -609,6 +609,10 @@ static void svm_vcpu_put(struct kvm_vcpu
 	put_cpu();
 }
 
+static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
+{
+}
+
 static void svm_cache_regs(struct kvm_vcpu *vcpu)
 {
 	vcpu->regs[VCPU_REGS_RAX] = vcpu->svm->vmcb->save.rax;
@@ -1677,6 +1681,7 @@ static struct kvm_arch_ops svm_arch_ops 
 
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
+	.vcpu_decache = svm_vcpu_decache,
 
 	.set_guest_debug = svm_guest_debug,
 	.get_msr = svm_get_msr,
diff -puN drivers/kvm/vmx.c~kvm-cpu-hotplug-support drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-cpu-hotplug-support
+++ a/drivers/kvm/vmx.c
@@ -250,6 +250,11 @@ static void vmx_vcpu_put(struct kvm_vcpu
 	put_cpu();
 }
 
+static void vmx_vcpu_decache(struct kvm_vcpu *vcpu)
+{
+	vcpu_clear(vcpu);
+}
+
 static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 {
 	return vmcs_readl(GUEST_RFLAGS);
@@ -509,7 +514,7 @@ static __init int vmx_disabled_by_bios(v
 	return (msr & 5) == 1; /* locked but not enabled */
 }
 
-static __init void hardware_enable(void *garbage)
+static void hardware_enable(void *garbage)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2023,6 +2028,7 @@ static struct kvm_arch_ops vmx_arch_ops 
 
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
+	.vcpu_decache = vmx_vcpu_decache,
 
 	.set_guest_debug = set_guest_debug,
 	.get_msr = vmx_get_msr,
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
