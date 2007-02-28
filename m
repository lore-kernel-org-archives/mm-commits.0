From: akpm@linux-foundation.org
Subject: - kvm-move-kvm_vm_ioctl_create_vcpu-around.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:55:04 -0800
Message-ID: <200702282355.l1SNt4J5031246@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48557 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932754AbXB1XzI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:55:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: move kvm_vm_ioctl_create_vcpu() around
has been removed from the -mm tree.  Its filename was
     kvm-move-kvm_vm_ioctl_create_vcpu-around.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: move kvm_vm_ioctl_create_vcpu() around
From: Avi Kivity <avi@qumranet.com>

In preparation of some hacking.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |  102 +++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-move-kvm_vm_ioctl_create_vcpu-around drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-move-kvm_vm_ioctl_create_vcpu-around
+++ a/drivers/kvm/kvm_main.c
@@ -599,57 +599,6 @@ void fx_init(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(fx_init);
 
 /*
- * Creates some virtual cpus.  Good luck creating more than one.
- */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
-{
-	int r;
-	struct kvm_vcpu *vcpu;
-
-	r = -EINVAL;
-	if (!valid_vcpu(n))
-		goto out;
-
-	vcpu = &kvm->vcpus[n];
-
-	mutex_lock(&vcpu->mutex);
-
-	if (vcpu->vmcs) {
-		mutex_unlock(&vcpu->mutex);
-		return -EEXIST;
-	}
-
-	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
-					   FX_IMAGE_ALIGN);
-	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
-
-	r = kvm_arch_ops->vcpu_create(vcpu);
-	if (r < 0)
-		goto out_free_vcpus;
-
-	r = kvm_mmu_create(vcpu);
-	if (r < 0)
-		goto out_free_vcpus;
-
-	kvm_arch_ops->vcpu_load(vcpu);
-	r = kvm_mmu_setup(vcpu);
-	if (r >= 0)
-		r = kvm_arch_ops->vcpu_setup(vcpu);
-	vcpu_put(vcpu);
-
-	if (r < 0)
-		goto out_free_vcpus;
-
-	return 0;
-
-out_free_vcpus:
-	kvm_free_vcpu(vcpu);
-	mutex_unlock(&vcpu->mutex);
-out:
-	return r;
-}
-
-/*
  * Allocate some memory and give it an address in the guest physical address
  * space.
  *
@@ -1964,6 +1913,57 @@ static int kvm_vm_ioctl_debug_guest(stru
 	return r;
 }
 
+/*
+ * Creates some virtual cpus.  Good luck creating more than one.
+ */
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
+{
+	int r;
+	struct kvm_vcpu *vcpu;
+
+	r = -EINVAL;
+	if (!valid_vcpu(n))
+		goto out;
+
+	vcpu = &kvm->vcpus[n];
+
+	mutex_lock(&vcpu->mutex);
+
+	if (vcpu->vmcs) {
+		mutex_unlock(&vcpu->mutex);
+		return -EEXIST;
+	}
+
+	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
+					   FX_IMAGE_ALIGN);
+	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
+
+	r = kvm_arch_ops->vcpu_create(vcpu);
+	if (r < 0)
+		goto out_free_vcpus;
+
+	r = kvm_mmu_create(vcpu);
+	if (r < 0)
+		goto out_free_vcpus;
+
+	kvm_arch_ops->vcpu_load(vcpu);
+	r = kvm_mmu_setup(vcpu);
+	if (r >= 0)
+		r = kvm_arch_ops->vcpu_setup(vcpu);
+	vcpu_put(vcpu);
+
+	if (r < 0)
+		goto out_free_vcpus;
+
+	return 0;
+
+out_free_vcpus:
+	kvm_free_vcpu(vcpu);
+	mutex_unlock(&vcpu->mutex);
+out:
+	return r;
+}
+
 static long kvm_vm_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
_

Patches currently in -mm which might be from avi@qumranet.com are

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
