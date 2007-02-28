From: akpm@linux-foundation.org
Subject: - kvm-per-vcpu-inodes.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:55:06 -0800
Message-ID: <200702282355.l1SNt64t031249@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48562 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXB1XzL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:55:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: per-vcpu inodes
has been removed from the -mm tree.  Its filename was
     kvm-per-vcpu-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: per-vcpu inodes
From: Avi Kivity <avi@qumranet.com>

Allocate a distinct inode for every vcpu in a VM.  This has the following
benefits:

 - the filp cachelines are no longer bounced when f_count is incremented on
   every ioctl()
 - the API and internal code are distinctly clearer; for example, on the
   KVM_GET_REGS ioctl, there is no need to copy the vcpu number from
   userspace and then copy the registers back; the vcpu identity is derived
   from the fd used to make the call

Right now the performance benefits are completely theoretical since (a) we
don't support more than one vcpu per VM and (b) virtualization hardware
inefficiencies completely everwhelm any cacheline bouncing effects.  But both
of these will change, and we need to prepare the API today.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm.h      |    3 
 drivers/kvm/kvm_main.c |  263 ++++++++++++++++++++++-----------------
 drivers/kvm/svm.c      |    3 
 drivers/kvm/vmx.c      |    3 
 include/linux/kvm.h    |   38 ++---
 5 files changed, 170 insertions(+), 140 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-per-vcpu-inodes drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-per-vcpu-inodes
+++ a/drivers/kvm/kvm.h
@@ -309,6 +309,7 @@ struct kvm {
 	int busy;
 	unsigned long rmap_overflow;
 	struct list_head vm_list;
+	struct file *filp;
 };
 
 struct kvm_stat {
@@ -343,7 +344,7 @@ struct kvm_arch_ops {
 	int (*vcpu_create)(struct kvm_vcpu *vcpu);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 
-	struct kvm_vcpu *(*vcpu_load)(struct kvm_vcpu *vcpu);
+	void (*vcpu_load)(struct kvm_vcpu *vcpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 	void (*vcpu_decache)(struct kvm_vcpu *vcpu);
 
diff -puN drivers/kvm/kvm_main.c~kvm-per-vcpu-inodes drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-per-vcpu-inodes
+++ a/drivers/kvm/kvm_main.c
@@ -96,6 +96,9 @@ struct segment_descriptor_64 {
 
 #endif
 
+static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
+			   unsigned long arg);
+
 static struct inode *kvmfs_inode(struct file_operations *fops)
 {
 	int error = -ENOMEM;
@@ -246,24 +249,30 @@ int kvm_write_guest(struct kvm_vcpu *vcp
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest);
 
-static int vcpu_slot(struct kvm_vcpu *vcpu)
+/*
+ * Switches to specified vcpu, until a matching vcpu_put()
+ */
+static void vcpu_load(struct kvm_vcpu *vcpu)
 {
-	return vcpu - vcpu->kvm->vcpus;
+	mutex_lock(&vcpu->mutex);
+	kvm_arch_ops->vcpu_load(vcpu);
 }
 
 /*
- * Switches to specified vcpu, until a matching vcpu_put()
+ * Switches to specified vcpu, until a matching vcpu_put(). Will return NULL
+ * if the slot is not populated.
  */
-static struct kvm_vcpu *vcpu_load(struct kvm *kvm, int vcpu_slot)
+static struct kvm_vcpu *vcpu_load_slot(struct kvm *kvm, int slot)
 {
-	struct kvm_vcpu *vcpu = &kvm->vcpus[vcpu_slot];
+	struct kvm_vcpu *vcpu = &kvm->vcpus[slot];
 
 	mutex_lock(&vcpu->mutex);
-	if (unlikely(!vcpu->vmcs)) {
+	if (!vcpu->vmcs) {
 		mutex_unlock(&vcpu->mutex);
 		return NULL;
 	}
-	return kvm_arch_ops->vcpu_load(vcpu);
+	kvm_arch_ops->vcpu_load(vcpu);
+	return vcpu;
 }
 
 static void vcpu_put(struct kvm_vcpu *vcpu)
@@ -336,9 +345,10 @@ static void kvm_free_physmem(struct kvm 
 
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu_load(vcpu->kvm, vcpu_slot(vcpu)))
+	if (!vcpu->vmcs)
 		return;
 
+	vcpu_load(vcpu);
 	kvm_mmu_destroy(vcpu);
 	vcpu_put(vcpu);
 	kvm_arch_ops->vcpu_free(vcpu);
@@ -725,7 +735,7 @@ raced:
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		struct kvm_vcpu *vcpu;
 
-		vcpu = vcpu_load(kvm, i);
+		vcpu = vcpu_load_slot(kvm, i);
 		if (!vcpu)
 			continue;
 		kvm_mmu_reset_context(vcpu);
@@ -791,8 +801,9 @@ static int kvm_vm_ioctl_get_dirty_log(st
 	if (any) {
 		cleared = 0;
 		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-			struct kvm_vcpu *vcpu = vcpu_load(kvm, i);
+			struct kvm_vcpu *vcpu;
 
+			vcpu = vcpu_load_slot(kvm, i);
 			if (!vcpu)
 				continue;
 			if (!cleared) {
@@ -1461,8 +1472,7 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 {
 	vcpu_put(vcpu);
 	cond_resched();
-	/* Cannot fail -  no vcpu unplug yet. */
-	vcpu_load(vcpu->kvm, vcpu_slot(vcpu));
+	vcpu_load(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
@@ -1484,17 +1494,11 @@ void save_msrs(struct vmx_msr_entry *e, 
 }
 EXPORT_SYMBOL_GPL(save_msrs);
 
-static int kvm_vm_ioctl_run(struct kvm *kvm, struct kvm_run *kvm_run)
+static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
-	struct kvm_vcpu *vcpu;
 	int r;
 
-	if (!valid_vcpu(kvm_run->vcpu))
-		return -EINVAL;
-
-	vcpu = vcpu_load(kvm, kvm_run->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	vcpu_load(vcpu);
 
 	/* re-sync apic's tpr */
 	vcpu->cr8 = kvm_run->cr8;
@@ -1517,16 +1521,10 @@ static int kvm_vm_ioctl_run(struct kvm *
 	return r;
 }
 
-static int kvm_vm_ioctl_get_regs(struct kvm *kvm, struct kvm_regs *regs)
+static int kvm_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu,
+				   struct kvm_regs *regs)
 {
-	struct kvm_vcpu *vcpu;
-
-	if (!valid_vcpu(regs->vcpu))
-		return -EINVAL;
-
-	vcpu = vcpu_load(kvm, regs->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	vcpu_load(vcpu);
 
 	kvm_arch_ops->cache_regs(vcpu);
 
@@ -1563,16 +1561,10 @@ static int kvm_vm_ioctl_get_regs(struct 
 	return 0;
 }
 
-static int kvm_vm_ioctl_set_regs(struct kvm *kvm, struct kvm_regs *regs)
+static int kvm_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu,
+				   struct kvm_regs *regs)
 {
-	struct kvm_vcpu *vcpu;
-
-	if (!valid_vcpu(regs->vcpu))
-		return -EINVAL;
-
-	vcpu = vcpu_load(kvm, regs->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	vcpu_load(vcpu);
 
 	vcpu->regs[VCPU_REGS_RAX] = regs->rax;
 	vcpu->regs[VCPU_REGS_RBX] = regs->rbx;
@@ -1609,16 +1601,12 @@ static void get_segment(struct kvm_vcpu 
 	return kvm_arch_ops->get_segment(vcpu, var, seg);
 }
 
-static int kvm_vm_ioctl_get_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
+static int kvm_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				    struct kvm_sregs *sregs)
 {
-	struct kvm_vcpu *vcpu;
 	struct descriptor_table dt;
 
-	if (!valid_vcpu(sregs->vcpu))
-		return -EINVAL;
-	vcpu = vcpu_load(kvm, sregs->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	vcpu_load(vcpu);
 
 	get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
@@ -1660,18 +1648,14 @@ static void set_segment(struct kvm_vcpu 
 	return kvm_arch_ops->set_segment(vcpu, var, seg);
 }
 
-static int kvm_vm_ioctl_set_sregs(struct kvm *kvm, struct kvm_sregs *sregs)
+static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				    struct kvm_sregs *sregs)
 {
-	struct kvm_vcpu *vcpu;
 	int mmu_reset_needed = 0;
 	int i;
 	struct descriptor_table dt;
 
-	if (!valid_vcpu(sregs->vcpu))
-		return -EINVAL;
-	vcpu = vcpu_load(kvm, sregs->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	vcpu_load(vcpu);
 
 	set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
@@ -1777,20 +1761,14 @@ static int do_set_msr(struct kvm_vcpu *v
  *
  * @return number of msrs set successfully.
  */
-static int __msr_io(struct kvm *kvm, struct kvm_msrs *msrs,
+static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    struct kvm_msr_entry *entries,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
-	struct kvm_vcpu *vcpu;
 	int i;
 
-	if (!valid_vcpu(msrs->vcpu))
-		return -EINVAL;
-
-	vcpu = vcpu_load(kvm, msrs->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	vcpu_load(vcpu);
 
 	for (i = 0; i < msrs->nmsrs; ++i)
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
@@ -1806,7 +1784,7 @@ static int __msr_io(struct kvm *kvm, str
  *
  * @return number of msrs set successfully.
  */
-static int msr_io(struct kvm *kvm, struct kvm_msrs __user *user_msrs,
+static int msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs __user *user_msrs,
 		  int (*do_msr)(struct kvm_vcpu *vcpu,
 				unsigned index, u64 *data),
 		  int writeback)
@@ -1834,7 +1812,7 @@ static int msr_io(struct kvm *kvm, struc
 	if (copy_from_user(entries, user_msrs->entries, size))
 		goto out_free;
 
-	r = n = __msr_io(kvm, &msrs, entries, do_msr);
+	r = n = __msr_io(vcpu, &msrs, entries, do_msr);
 	if (r < 0)
 		goto out_free;
 
@@ -1853,38 +1831,31 @@ out:
 /*
  * Translate a guest virtual address to a guest physical address.
  */
-static int kvm_vm_ioctl_translate(struct kvm *kvm, struct kvm_translation *tr)
+static int kvm_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				    struct kvm_translation *tr)
 {
 	unsigned long vaddr = tr->linear_address;
-	struct kvm_vcpu *vcpu;
 	gpa_t gpa;
 
-	vcpu = vcpu_load(kvm, tr->vcpu);
-	if (!vcpu)
-		return -ENOENT;
-	spin_lock(&kvm->lock);
+	vcpu_load(vcpu);
+	spin_lock(&vcpu->kvm->lock);
 	gpa = vcpu->mmu.gva_to_gpa(vcpu, vaddr);
 	tr->physical_address = gpa;
 	tr->valid = gpa != UNMAPPED_GVA;
 	tr->writeable = 1;
 	tr->usermode = 0;
-	spin_unlock(&kvm->lock);
+	spin_unlock(&vcpu->kvm->lock);
 	vcpu_put(vcpu);
 
 	return 0;
 }
 
-static int kvm_vm_ioctl_interrupt(struct kvm *kvm, struct kvm_interrupt *irq)
+static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
+				    struct kvm_interrupt *irq)
 {
-	struct kvm_vcpu *vcpu;
-
-	if (!valid_vcpu(irq->vcpu))
-		return -EINVAL;
 	if (irq->irq < 0 || irq->irq >= 256)
 		return -EINVAL;
-	vcpu = vcpu_load(kvm, irq->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	vcpu_load(vcpu);
 
 	set_bit(irq->irq, vcpu->irq_pending);
 	set_bit(irq->irq / BITS_PER_LONG, &vcpu->irq_summary);
@@ -1894,17 +1865,12 @@ static int kvm_vm_ioctl_interrupt(struct
 	return 0;
 }
 
-static int kvm_vm_ioctl_debug_guest(struct kvm *kvm,
-				     struct kvm_debug_guest *dbg)
+static int kvm_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
+				      struct kvm_debug_guest *dbg)
 {
-	struct kvm_vcpu *vcpu;
 	int r;
 
-	if (!valid_vcpu(dbg->vcpu))
-		return -EINVAL;
-	vcpu = vcpu_load(kvm, dbg->vcpu);
-	if (!vcpu)
-		return -ENOENT;
+	vcpu_load(vcpu);
 
 	r = kvm_arch_ops->set_guest_debug(vcpu, dbg);
 
@@ -1913,6 +1879,59 @@ static int kvm_vm_ioctl_debug_guest(stru
 	return r;
 }
 
+static int kvm_vcpu_release(struct inode *inode, struct file *filp)
+{
+	struct kvm_vcpu *vcpu = filp->private_data;
+
+	fput(vcpu->kvm->filp);
+	return 0;
+}
+
+static struct file_operations kvm_vcpu_fops = {
+	.release        = kvm_vcpu_release,
+	.unlocked_ioctl = kvm_vcpu_ioctl,
+	.compat_ioctl   = kvm_vcpu_ioctl,
+};
+
+/*
+ * Allocates an inode for the vcpu.
+ */
+static int create_vcpu_fd(struct kvm_vcpu *vcpu)
+{
+	int fd, r;
+	struct inode *inode;
+	struct file *file;
+
+	atomic_inc(&vcpu->kvm->filp->f_count);
+	inode = kvmfs_inode(&kvm_vcpu_fops);
+	if (IS_ERR(inode)) {
+		r = PTR_ERR(inode);
+		goto out1;
+	}
+
+	file = kvmfs_file(inode, vcpu);
+	if (IS_ERR(file)) {
+		r = PTR_ERR(file);
+		goto out2;
+	}
+
+	r = get_unused_fd();
+	if (r < 0)
+		goto out3;
+	fd = r;
+	fd_install(fd, file);
+
+	return fd;
+
+out3:
+	fput(file);
+out2:
+	iput(inode);
+out1:
+	fput(vcpu->kvm->filp);
+	return r;
+}
+
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
@@ -1955,7 +1974,11 @@ static int kvm_vm_ioctl_create_vcpu(stru
 	if (r < 0)
 		goto out_free_vcpus;
 
-	return 0;
+	r = create_vcpu_fd(vcpu);
+	if (r < 0)
+		goto out_free_vcpus;
+
+	return r;
 
 out_free_vcpus:
 	kvm_free_vcpu(vcpu);
@@ -1964,26 +1987,21 @@ out:
 	return r;
 }
 
-static long kvm_vm_ioctl(struct file *filp,
-			 unsigned int ioctl, unsigned long arg)
+static long kvm_vcpu_ioctl(struct file *filp,
+			   unsigned int ioctl, unsigned long arg)
 {
-	struct kvm *kvm = filp->private_data;
+	struct kvm_vcpu *vcpu = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r = -EINVAL;
 
 	switch (ioctl) {
-	case KVM_CREATE_VCPU:
-		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
-		if (r)
-			goto out;
-		break;
 	case KVM_RUN: {
 		struct kvm_run kvm_run;
 
 		r = -EFAULT;
 		if (copy_from_user(&kvm_run, argp, sizeof kvm_run))
 			goto out;
-		r = kvm_vm_ioctl_run(kvm, &kvm_run);
+		r = kvm_vcpu_ioctl_run(vcpu, &kvm_run);
 		if (r < 0 &&  r != -EINTR)
 			goto out;
 		if (copy_to_user(argp, &kvm_run, sizeof kvm_run)) {
@@ -1995,10 +2013,8 @@ static long kvm_vm_ioctl(struct file *fi
 	case KVM_GET_REGS: {
 		struct kvm_regs kvm_regs;
 
-		r = -EFAULT;
-		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
-			goto out;
-		r = kvm_vm_ioctl_get_regs(kvm, &kvm_regs);
+		memset(&kvm_regs, 0, sizeof kvm_regs);
+		r = kvm_vcpu_ioctl_get_regs(vcpu, &kvm_regs);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2013,7 +2029,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&kvm_regs, argp, sizeof kvm_regs))
 			goto out;
-		r = kvm_vm_ioctl_set_regs(kvm, &kvm_regs);
+		r = kvm_vcpu_ioctl_set_regs(vcpu, &kvm_regs);
 		if (r)
 			goto out;
 		r = 0;
@@ -2022,10 +2038,8 @@ static long kvm_vm_ioctl(struct file *fi
 	case KVM_GET_SREGS: {
 		struct kvm_sregs kvm_sregs;
 
-		r = -EFAULT;
-		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
-			goto out;
-		r = kvm_vm_ioctl_get_sregs(kvm, &kvm_sregs);
+		memset(&kvm_sregs, 0, sizeof kvm_sregs);
+		r = kvm_vcpu_ioctl_get_sregs(vcpu, &kvm_sregs);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2040,7 +2054,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&kvm_sregs, argp, sizeof kvm_sregs))
 			goto out;
-		r = kvm_vm_ioctl_set_sregs(kvm, &kvm_sregs);
+		r = kvm_vcpu_ioctl_set_sregs(vcpu, &kvm_sregs);
 		if (r)
 			goto out;
 		r = 0;
@@ -2052,7 +2066,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&tr, argp, sizeof tr))
 			goto out;
-		r = kvm_vm_ioctl_translate(kvm, &tr);
+		r = kvm_vcpu_ioctl_translate(vcpu, &tr);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2067,7 +2081,7 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&irq, argp, sizeof irq))
 			goto out;
-		r = kvm_vm_ioctl_interrupt(kvm, &irq);
+		r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
 		if (r)
 			goto out;
 		r = 0;
@@ -2079,12 +2093,38 @@ static long kvm_vm_ioctl(struct file *fi
 		r = -EFAULT;
 		if (copy_from_user(&dbg, argp, sizeof dbg))
 			goto out;
-		r = kvm_vm_ioctl_debug_guest(kvm, &dbg);
+		r = kvm_vcpu_ioctl_debug_guest(vcpu, &dbg);
 		if (r)
 			goto out;
 		r = 0;
 		break;
 	}
+	case KVM_GET_MSRS:
+		r = msr_io(vcpu, argp, get_msr, 1);
+		break;
+	case KVM_SET_MSRS:
+		r = msr_io(vcpu, argp, do_set_msr, 0);
+		break;
+	default:
+		;
+	}
+out:
+	return r;
+}
+
+static long kvm_vm_ioctl(struct file *filp,
+			   unsigned int ioctl, unsigned long arg)
+{
+	struct kvm *kvm = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	int r = -EINVAL;
+
+	switch (ioctl) {
+	case KVM_CREATE_VCPU:
+		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
+		if (r < 0)
+			goto out;
+		break;
 	case KVM_SET_MEMORY_REGION: {
 		struct kvm_memory_region kvm_mem;
 
@@ -2107,12 +2147,6 @@ static long kvm_vm_ioctl(struct file *fi
 			goto out;
 		break;
 	}
-	case KVM_GET_MSRS:
-		r = msr_io(kvm, argp, get_msr, 1);
-		break;
-	case KVM_SET_MSRS:
-		r = msr_io(kvm, argp, do_set_msr, 0);
-		break;
 	default:
 		;
 	}
@@ -2182,6 +2216,7 @@ static int kvm_dev_ioctl_create_vm(void)
 		r = PTR_ERR(file);
 		goto out3;
 	}
+	kvm->filp = file;
 
 	r = get_unused_fd();
 	if (r < 0)
diff -puN drivers/kvm/svm.c~kvm-per-vcpu-inodes drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~kvm-per-vcpu-inodes
+++ a/drivers/kvm/svm.c
@@ -600,10 +600,9 @@ static void svm_free_vcpu(struct kvm_vcp
 	kfree(vcpu->svm);
 }
 
-static struct kvm_vcpu *svm_vcpu_load(struct kvm_vcpu *vcpu)
+static void svm_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	get_cpu();
-	return vcpu;
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
diff -puN drivers/kvm/vmx.c~kvm-per-vcpu-inodes drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-per-vcpu-inodes
+++ a/drivers/kvm/vmx.c
@@ -204,7 +204,7 @@ static void vmcs_write64(unsigned long f
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
  */
-static struct kvm_vcpu *vmx_vcpu_load(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	u64 phys_addr = __pa(vcpu->vmcs);
 	int cpu;
@@ -242,7 +242,6 @@ static struct kvm_vcpu *vmx_vcpu_load(st
 		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
 		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
 	}
-	return vcpu;
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
diff -puN include/linux/kvm.h~kvm-per-vcpu-inodes include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-per-vcpu-inodes
+++ a/include/linux/kvm.h
@@ -52,11 +52,10 @@ enum kvm_exit_reason {
 /* for KVM_RUN */
 struct kvm_run {
 	/* in */
-	__u32 vcpu;
 	__u32 emulated;  /* skip current instruction */
 	__u32 mmio_completed; /* mmio request completed */
 	__u8 request_interrupt_window;
-	__u8 padding1[3];
+	__u8 padding1[7];
 
 	/* out */
 	__u32 exit_type;
@@ -111,10 +110,6 @@ struct kvm_run {
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
-	/* in */
-	__u32 vcpu;
-	__u32 padding;
-
 	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
 	__u64 rax, rbx, rcx, rdx;
 	__u64 rsi, rdi, rsp, rbp;
@@ -141,10 +136,6 @@ struct kvm_dtable {
 
 /* for KVM_GET_SREGS and KVM_SET_SREGS */
 struct kvm_sregs {
-	/* in */
-	__u32 vcpu;
-	__u32 padding;
-
 	/* out (KVM_GET_SREGS) / in (KVM_SET_SREGS) */
 	struct kvm_segment cs, ds, es, fs, gs, ss;
 	struct kvm_segment tr, ldt;
@@ -163,8 +154,8 @@ struct kvm_msr_entry {
 
 /* for KVM_GET_MSRS and KVM_SET_MSRS */
 struct kvm_msrs {
-	__u32 vcpu;
 	__u32 nmsrs; /* number of msrs in entries */
+	__u32 pad;
 
 	struct kvm_msr_entry entries[0];
 };
@@ -179,8 +170,6 @@ struct kvm_msr_list {
 struct kvm_translation {
 	/* in */
 	__u64 linear_address;
-	__u32 vcpu;
-	__u32 padding;
 
 	/* out */
 	__u64 physical_address;
@@ -193,7 +182,6 @@ struct kvm_translation {
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
 	/* in */
-	__u32 vcpu;
 	__u32 irq;
 };
 
@@ -206,8 +194,8 @@ struct kvm_breakpoint {
 /* for KVM_DEBUG_GUEST */
 struct kvm_debug_guest {
 	/* int */
-	__u32 vcpu;
 	__u32 enabled;
+	__u32 pad;
 	struct kvm_breakpoint breakpoints[4];
 	__u32 singlestep;
 };
@@ -234,18 +222,26 @@ struct kvm_dirty_log {
 /*
  * ioctls for VM fds
  */
+#define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 10, struct kvm_memory_region)
+/*
+ * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
+ * a vcpu fd.
+ */
+#define KVM_CREATE_VCPU           _IOW(KVMIO, 11, int)
+#define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 12, struct kvm_dirty_log)
+
+/*
+ * ioctls for vcpu fds
+ */
 #define KVM_RUN                   _IOWR(KVMIO, 2, struct kvm_run)
-#define KVM_GET_REGS              _IOWR(KVMIO, 3, struct kvm_regs)
+#define KVM_GET_REGS              _IOR(KVMIO, 3, struct kvm_regs)
 #define KVM_SET_REGS              _IOW(KVMIO, 4, struct kvm_regs)
-#define KVM_GET_SREGS             _IOWR(KVMIO, 5, struct kvm_sregs)
+#define KVM_GET_SREGS             _IOR(KVMIO, 5, struct kvm_sregs)
 #define KVM_SET_SREGS             _IOW(KVMIO, 6, struct kvm_sregs)
 #define KVM_TRANSLATE             _IOWR(KVMIO, 7, struct kvm_translation)
 #define KVM_INTERRUPT             _IOW(KVMIO, 8, struct kvm_interrupt)
 #define KVM_DEBUG_GUEST           _IOW(KVMIO, 9, struct kvm_debug_guest)
-#define KVM_SET_MEMORY_REGION     _IOW(KVMIO, 10, struct kvm_memory_region)
-#define KVM_CREATE_VCPU           _IOW(KVMIO, 11, int /* vcpu_slot */)
-#define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 12, struct kvm_dirty_log)
 #define KVM_GET_MSRS              _IOWR(KVMIO, 13, struct kvm_msrs)
-#define KVM_SET_MSRS              _IOWR(KVMIO, 14, struct kvm_msrs)
+#define KVM_SET_MSRS              _IOW(KVMIO, 14, struct kvm_msrs)
 
 #endif
_

Patches currently in -mm which might be from avi@qumranet.com are

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
