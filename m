From: akpm@osdl.org
Subject: + kvm-add-a-global-list-of-all-virtual-machines.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:51:26 -0800
Message-ID: <200701310051.l0V0pQU5002964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59601 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbXAaAvf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com, mingo@elte.hu


The patch titled
     KVM: Add a global list of all virtual machines
has been added to the -mm tree.  Its filename is
     kvm-add-a-global-list-of-all-virtual-machines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Add a global list of all virtual machines
From: Avi Kivity <avi@qumranet.com>

This will allow us to iterate over all vcpus and see which cpus they are
running on.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm.h~kvm-add-a-global-list-of-all-virtual-machines drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-add-a-global-list-of-all-virtual-machines
+++ a/drivers/kvm/kvm.h
@@ -304,6 +304,7 @@ struct kvm {
 	int memory_config_version;
 	int busy;
 	unsigned long rmap_overflow;
+	struct list_head vm_list;
 };
 
 struct kvm_stat {
diff -puN drivers/kvm/kvm_main.c~kvm-add-a-global-list-of-all-virtual-machines drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-a-global-list-of-all-virtual-machines
+++ a/drivers/kvm/kvm_main.c
@@ -41,6 +41,9 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+static spinlock_t kvm_lock = SPIN_LOCK_UNLOCKED;
+static struct list_head vm_list = LIST_HEAD_INIT(vm_list);
+
 struct kvm_arch_ops *kvm_arch_ops;
 struct kvm_stat kvm_stat;
 EXPORT_SYMBOL_GPL(kvm_stat);
@@ -230,9 +233,13 @@ static int kvm_dev_open(struct inode *in
 		struct kvm_vcpu *vcpu = &kvm->vcpus[i];
 
 		mutex_init(&vcpu->mutex);
+		vcpu->cpu = -1;
 		vcpu->kvm = kvm;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
 		INIT_LIST_HEAD(&vcpu->free_pages);
+		spin_lock(&kvm_lock);
+		list_add(&kvm->vm_list, &vm_list);
+		spin_unlock(&kvm_lock);
 	}
 	filp->private_data = kvm;
 	return 0;
@@ -292,6 +299,9 @@ static int kvm_dev_release(struct inode 
 {
 	struct kvm *kvm = filp->private_data;
 
+	spin_lock(&kvm_lock);
+	list_del(&kvm->vm_list);
+	spin_unlock(&kvm_lock);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
 	kfree(kvm);
@@ -546,7 +556,6 @@ static int kvm_dev_ioctl_create_vcpu(str
 					   FX_IMAGE_ALIGN);
 	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
 
-	vcpu->cpu = -1;  /* First load will set up TR */
 	r = kvm_arch_ops->vcpu_create(vcpu);
 	if (r < 0)
 		goto out_free_vcpus;
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
