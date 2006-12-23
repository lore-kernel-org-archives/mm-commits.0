From: akpm@osdl.org
Subject: - kvm-add-valid_vcpu-helper.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:09 -0800
Message-ID: <200612230753.kBN7r97Q010096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbWLWHxW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:53:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     KVM: add valid_vcpu() helper
has been removed from the -mm tree.  Its filename was
     kvm-add-valid_vcpu-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: KVM: add valid_vcpu() helper
From: James Morris <jmorris@namei.org>

Consolidate the logic for checking whether a vcpu index is valid.  Also, use
likely(), as a valid value should be the overwhelmingly common case.

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm_main.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-add-valid_vcpu-helper drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-valid_vcpu-helper
+++ a/drivers/kvm/kvm_main.c
@@ -113,6 +113,11 @@ unsigned long segment_base(u16 selector)
 }
 EXPORT_SYMBOL_GPL(segment_base);
 
+static inline int valid_vcpu(int n)
+{
+	return likely(n >= 0 && n < KVM_MAX_VCPUS);
+}
+
 int kvm_read_guest(struct kvm_vcpu *vcpu,
 			     gva_t addr,
 			     unsigned long size,
@@ -494,7 +499,7 @@ static int kvm_dev_ioctl_create_vcpu(str
 	struct kvm_vcpu *vcpu;
 
 	r = -EINVAL;
-	if (n < 0 || n >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(n))
 		goto out;
 
 	vcpu = &kvm->vcpus[n];
@@ -1179,7 +1184,7 @@ static int kvm_dev_ioctl_run(struct kvm 
 	struct kvm_vcpu *vcpu;
 	int r;
 
-	if (kvm_run->vcpu < 0 || kvm_run->vcpu >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(kvm_run->vcpu))
 		return -EINVAL;
 
 	vcpu = vcpu_load(kvm, kvm_run->vcpu);
@@ -1208,7 +1213,7 @@ static int kvm_dev_ioctl_get_regs(struct
 {
 	struct kvm_vcpu *vcpu;
 
-	if (regs->vcpu < 0 || regs->vcpu >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(regs->vcpu))
 		return -EINVAL;
 
 	vcpu = vcpu_load(kvm, regs->vcpu);
@@ -1254,7 +1259,7 @@ static int kvm_dev_ioctl_set_regs(struct
 {
 	struct kvm_vcpu *vcpu;
 
-	if (regs->vcpu < 0 || regs->vcpu >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(regs->vcpu))
 		return -EINVAL;
 
 	vcpu = vcpu_load(kvm, regs->vcpu);
@@ -1301,7 +1306,7 @@ static int kvm_dev_ioctl_get_sregs(struc
 	struct kvm_vcpu *vcpu;
 	struct descriptor_table dt;
 
-	if (sregs->vcpu < 0 || sregs->vcpu >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(sregs->vcpu))
 		return -EINVAL;
 	vcpu = vcpu_load(kvm, sregs->vcpu);
 	if (!vcpu)
@@ -1353,7 +1358,7 @@ static int kvm_dev_ioctl_set_sregs(struc
 	int i;
 	struct descriptor_table dt;
 
-	if (sregs->vcpu < 0 || sregs->vcpu >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(sregs->vcpu))
 		return -EINVAL;
 	vcpu = vcpu_load(kvm, sregs->vcpu);
 	if (!vcpu)
@@ -1444,7 +1449,7 @@ static int __msr_io(struct kvm *kvm, str
 	struct kvm_vcpu *vcpu;
 	int i;
 
-	if (msrs->vcpu < 0 || msrs->vcpu >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(msrs->vcpu))
 		return -EINVAL;
 
 	vcpu = vcpu_load(kvm, msrs->vcpu);
@@ -1537,7 +1542,7 @@ static int kvm_dev_ioctl_interrupt(struc
 {
 	struct kvm_vcpu *vcpu;
 
-	if (irq->vcpu < 0 || irq->vcpu >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(irq->vcpu))
 		return -EINVAL;
 	if (irq->irq < 0 || irq->irq >= 256)
 		return -EINVAL;
@@ -1559,7 +1564,7 @@ static int kvm_dev_ioctl_debug_guest(str
 	struct kvm_vcpu *vcpu;
 	int r;
 
-	if (dbg->vcpu < 0 || dbg->vcpu >= KVM_MAX_VCPUS)
+	if (!valid_vcpu(dbg->vcpu))
 		return -EINVAL;
 	vcpu = vcpu_load(kvm, dbg->vcpu);
 	if (!vcpu)
_

Patches currently in -mm which might be from jmorris@namei.org are

origin.patch
git-selinux.patch
implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
make-reading-proc-sys-kernel-cap-bould-not-require.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-main-include-fix.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
slim-documentation.patch

