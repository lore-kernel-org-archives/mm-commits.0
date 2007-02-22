From: akpm@linux-foundation.org
Subject: + kvm-move-kvm_vm_ioctl_create_vcpu-around.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:21:01 -0800
Message-ID: <200702220221.l1M2L1kR001698@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbXBVCVE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     kvm: move kvm_vm_ioctl_create_vcpu() around
has been added to the -mm tree.  Its filename is
     kvm-move-kvm_vm_ioctl_create_vcpu-around.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-mmu-add-missing-dirty-page-tracking-cases.patch
kvm-move-virtualization-deactivation-from-cpu_dead.patch
kvm-cosmetics.patch
kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-use-array_size-macro-instead-of-manual-calculation.patch
kvm-use-page_private-set_page_private-apis.patch
kvm-add-msr-based-hypercall-api.patch
kvm-add-host-hypercall-support-for-vmx.patch
kvm-add-hypercall-host-support-for-svm.patch
kvm-wire-up-hypercall-handlers-to-a-central.patch
kvm-svm-init-cr0-with-the-wp-bit-set.patch
kvm-svm-intercept-smi-to-handle-it-at-host-level.patch
kvm-more-0-null-conversions.patch
kvm-add-internal-filesystem-for-generating-inodes.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
kvm-create-an-inode-per-virtual-machine.patch
kvm-rename-some-kvm_dev_ioctl_-functions-to.patch
kvm-move-kvm_vm_ioctl_create_vcpu-around.patch
kvm-per-vcpu-inodes.patch
kvm-bump-api-version.patch
