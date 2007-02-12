From: akpm@linux-foundation.org
Subject: - kvm-add-a-global-list-of-all-virtual-machines.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:02 -0800
Message-ID: <200702122249.l1CMn28G014075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45595 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030378AbXBLWtG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     KVM: Add a global list of all virtual machines
has been removed from the -mm tree.  Its filename was
     kvm-add-a-global-list-of-all-virtual-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: Add a global list of all virtual machines
From: Avi Kivity <avi@qumranet.com>

This will allow us to iterate over all vcpus and see which cpus they are
running on.

[akpm@osdl.org: use standard (ugly) initialisers]
Signed-off-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
 
+static DEFINE_SPINLOCK(kvm_lock);
+static LIST_HEAD(vm_list);
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
