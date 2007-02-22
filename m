From: akpm@linux-foundation.org
Subject: + kvm-rename-some-kvm_dev_ioctl_-functions-to.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:20:59 -0800
Message-ID: <200702220220.l1M2Kx3w001691@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbXBVCVH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     kvm: rename some kvm_dev_ioctl_*() functions to kvm_vm_ioctl_*()
has been added to the -mm tree.  Its filename is
     kvm-rename-some-kvm_dev_ioctl_-functions-to.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: rename some kvm_dev_ioctl_*() functions to kvm_vm_ioctl_*()
From: Avi Kivity <avi@qumranet.com>

This reflects the changed scope, from device-wide to single vm (previously
every device open created a virtual machine).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |   48 +++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-rename-some-kvm_dev_ioctl_-functions-to drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-rename-some-kvm_dev_ioctl_-functions-to
+++ a/drivers/kvm/kvm_main.c
@@ -601,7 +601,7 @@ EXPORT_SYMBOL_GPL(fx_init);
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_dev_ioctl_create_vcpu(struct kvm *kvm, int n)
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
@@ -655,8 +655,8 @@ out:
  *
  * Discontiguous memory is allowed, mostly for framebuffers.
  */
-static int kvm_dev_ioctl_set_memory_region(struct kvm *kvm,
-					   struct kvm_memory_region *mem)
+static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
+					  struct kvm_memory_region *mem)
 {
 	int r;
 	gfn_t base_gfn;
@@ -804,8 +804,8 @@ static void do_remove_write_access(struc
 /*
  * Get (and clear) the dirty memory log for a memory slot.
  */
-static int kvm_dev_ioctl_get_dirty_log(struct kvm *kvm,
-				       struct kvm_dirty_log *log)
+static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
+				      struct kvm_dirty_log *log)
 {
 	struct kvm_memory_slot *memslot;
 	int r, i;
@@ -1535,7 +1535,7 @@ void save_msrs(struct vmx_msr_entry *e, 
 }
 EXPORT_SYMBOL_GPL(save_msrs);
 
-static int kvm_dev_ioctl_run(struct kvm *kvm, struct kvm_run *kvm_run)
+static int kvm_vm_ioctl_run(struct kvm *kvm, struct kvm_run *kvm_run)
 {
 	struct kvm_vcpu *vcpu;
 	int r;
@@ -1568,7 +1568,7 @@ static int kvm_dev_ioctl_run(struct kvm 
 	return r;
 }
 
-static int kvm_dev_ioctl_get_regs(struct kvm *kvm, struct kvm_regs *regs)
+static int kvm_vm_ioctl_get_regs(struct kvm *kvm, struct kvm_regs *regs)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -1614,7 +1614,7 @@ static int kvm_dev_ioctl_get_regs(struct
 	return 0;
 }
 
-static int kvm_dev_ioctl_set_regs(struct kvm *kvm, struct kvm_regs *regs)
+static int kvm_vm_ioctl_set_regs(struct kvm *kvm, struct kvm_regs *regs)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -1660,7 +1660,7 @@ static void get_segment(struct kvm_vcpu 
 	return kvm_arch_ops->get_segment(vcpu, var, seg);
 }
 
-static int kvm_dev_ioctl_get_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
+static int kvm_vm_ioctl_get_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
 {
 	struct kvm_vcpu *vcpu;
 	struct descriptor_table dt;
@@ -1711,7 +1711,7 @@ static void set_segment(struct kvm_vcpu 
 	return kvm_arch_ops->set_segment(vcpu, var, seg);
 }
 
-static int kvm_dev_ioctl_set_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
+static int kvm_vm_ioctl_set_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
 {
 	struct kvm_vcpu *vcpu;
 	int mmu_reset_needed = 0;
@@ -1904,7 +1904,7 @@ out:
 /*
  * Translate a guest virtual address to a guest physical address.
  */
-static int kvm_dev_ioctl_translate(struct kvm *kvm, struct kvm_translation *tr)
+static int kvm_vm_ioctl_translate(struct kvm *kvm, struct kvm_translation *tr)
 {
 	unsigned long vaddr = tr->linear_address;
 	struct kvm_vcpu *vcpu;
@@ -1925,7 +1925,7 @@ static int kvm_dev_ioctl_translate(struc
 	return 0;
 }
 
-static int kvm_dev_ioctl_interrupt(struct kvm *kvm, struct kvm_interrupt *irq)
+static int kvm_vm_ioctl_interrupt(struct kvm *kvm, struct kvm_interrupt *irq)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -1945,7 +1945,7 @@ static int kvm_dev_ioctl_interrupt(struc
 	return 0;
 }
 
-static int kvm_dev_ioctl_debug_guest(struct kvm *kvm,
+static int kvm_vm_ioctl_debug_guest(struct kvm *kvm,
 				     struct kvm_debug_guest *dbg)
 {
 	struct kvm_vcpu *vcpu;
@@ -1973,7 +1973,7 @@ static long kvm_vm_ioctl(struct file *fi
 
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
-		r = kvm_dev_ioctl_create_vcpu(kvm, arg);
+		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
 		if (r)
 			goto out;
 		break;
@@ -1983,7 +1983,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&kvm_run, argp, sizeof kvm_run))
 			goto out;
-		r = kvm_dev_ioctl_run(kvm, &kvm_run);
+		r = kvm_vm_ioctl_run(kvm, &kvm_run);
 		if (r < 0 &&  r != -EINTR)
 			goto out;
 		if (copy_to_user(argp, &kvm_run, sizeof kvm_run)) {
@@ -1998,7 +1998,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
 			goto out;
-		r = kvm_dev_ioctl_get_regs(kvm, &kvm_regs);
+		r = kvm_vm_ioctl_get_regs(kvm, &kvm_regs);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2013,7 +2013,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
 			goto out;
-		r = kvm_dev_ioctl_set_regs(kvm, &kvm_regs);
+		r = kvm_vm_ioctl_set_regs(kvm, &kvm_regs);
 		if (r)
 			goto out;
 		r = 0;
@@ -2025,7 +2025,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
 			goto out;
-		r = kvm_dev_ioctl_get_sregs(kvm, &kvm_sregs);
+		r = kvm_vm_ioctl_get_sregs(kvm, &kvm_sregs);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2040,7 +2040,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
 			goto out;
-		r = kvm_dev_ioctl_set_sregs(kvm, &kvm_sregs);
+		r = kvm_vm_ioctl_set_sregs(kvm, &kvm_sregs);
 		if (r)
 			goto out;
 		r = 0;
@@ -2052,7 +2052,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&tr, argp, sizeof tr))
 			goto out;
-		r = kvm_dev_ioctl_translate(kvm, &tr);
+		r = kvm_vm_ioctl_translate(kvm, &tr);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2067,7 +2067,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&irq, argp, sizeof irq))
 			goto out;
-		r = kvm_dev_ioctl_interrupt(kvm, &irq);
+		r = kvm_vm_ioctl_interrupt(kvm, &irq);
 		if (r)
 			goto out;
 		r = 0;
@@ -2079,7 +2079,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&dbg, argp, sizeof dbg))
 			goto out;
-		r = kvm_dev_ioctl_debug_guest(kvm, &dbg);
+		r = kvm_vm_ioctl_debug_guest(kvm, &dbg);
 		if (r)
 			goto out;
 		r = 0;
@@ -2091,7 +2091,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&kvm_mem, argp, sizeof kvm_mem))
 			goto out;
-		r = kvm_dev_ioctl_set_memory_region(kvm, &kvm_mem);
+		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_mem);
 		if (r)
 			goto out;
 		break;
@@ -2102,7 +2102,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&log, argp, sizeof log))
 			goto out;
-		r = kvm_dev_ioctl_get_dirty_log(kvm, &log);
+		r = kvm_vm_ioctl_get_dirty_log(kvm, &log);
 		if (r)
 			goto out;
 		break;
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
