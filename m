From: akpm@linux-foundation.org
Subject: - kvm-create-an-inode-per-virtual-machine.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:59 -0800
Message-ID: <200702282354.l1SNsxkF031240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739AbXB1XzE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:55:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: create an inode per virtual machine
has been removed from the -mm tree.  Its filename was
     kvm-create-an-inode-per-virtual-machine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: create an inode per virtual machine
From: Avi Kivity <avi@qumranet.com>

This avoids having filp->f_op and the corresponding inode->i_fop different,
which is a little unorthodox.

The ioctl list is split into two: global kvm ioctls and per-vm ioctls.  A new
ioctl, KVM_CREATE_VM, is used to create VMs and return the VM fd.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |  212 +++++++++++++++++++++++++++++++--------
 include/linux/kvm.h    |   10 +
 2 files changed, 180 insertions(+), 42 deletions(-)

diff -puN drivers/kvm/kvm_main.c~kvm-create-an-inode-per-virtual-machine drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-create-an-inode-per-virtual-machine
+++ a/drivers/kvm/kvm_main.c
@@ -37,6 +37,7 @@
 #include <asm/desc.h>
 #include <linux/sysdev.h>
 #include <linux/cpu.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 
@@ -95,6 +96,55 @@ struct segment_descriptor_64 {
 
 #endif
 
+static struct inode *kvmfs_inode(struct file_operations *fops)
+{
+	int error = -ENOMEM;
+	struct inode *inode = new_inode(kvmfs_mnt->mnt_sb);
+
+	if (!inode)
+		goto eexit_1;
+
+	inode->i_fop = fops;
+
+	/*
+	 * Mark the inode dirty from the very beginning,
+	 * that way it will never be moved to the dirty
+	 * list because mark_inode_dirty() will think
+	 * that it already _is_ on the dirty list.
+	 */
+	inode->i_state = I_DIRTY;
+	inode->i_mode = S_IRUSR | S_IWUSR;
+	inode->i_uid = current->fsuid;
+	inode->i_gid = current->fsgid;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	return inode;
+
+eexit_1:
+	return ERR_PTR(error);
+}
+
+static struct file *kvmfs_file(struct inode *inode, void *private_data)
+{
+	struct file *file = get_empty_filp();
+
+	if (!file)
+		return ERR_PTR(-ENFILE);
+
+	file->f_path.mnt = mntget(kvmfs_mnt);
+	file->f_path.dentry = d_alloc_anon(inode);
+	if (!file->f_path.dentry)
+		return ERR_PTR(-ENOMEM);
+	file->f_mapping = inode->i_mapping;
+
+	file->f_pos = 0;
+	file->f_flags = O_RDWR;
+	file->f_op = inode->i_fop;
+	file->f_mode = FMODE_READ | FMODE_WRITE;
+	file->f_version = 0;
+	file->private_data = private_data;
+	return file;
+}
+
 unsigned long segment_base(u16 selector)
 {
 	struct descriptor_table gdt;
@@ -222,13 +272,13 @@ static void vcpu_put(struct kvm_vcpu *vc
 	mutex_unlock(&vcpu->mutex);
 }
 
-static int kvm_dev_open(struct inode *inode, struct file *filp)
+static struct kvm *kvm_create_vm(void)
 {
 	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
 	int i;
 
 	if (!kvm)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&kvm->lock);
 	INIT_LIST_HEAD(&kvm->active_mmu_pages);
@@ -244,7 +294,11 @@ static int kvm_dev_open(struct inode *in
 		list_add(&kvm->vm_list, &vm_list);
 		spin_unlock(&kvm_lock);
 	}
-	filp->private_data = kvm;
+	return kvm;
+}
+
+static int kvm_dev_open(struct inode *inode, struct file *filp)
+{
 	return 0;
 }
 
@@ -300,14 +354,24 @@ static void kvm_free_vcpus(struct kvm *k
 
 static int kvm_dev_release(struct inode *inode, struct file *filp)
 {
-	struct kvm *kvm = filp->private_data;
+	return 0;
+}
 
+static void kvm_destroy_vm(struct kvm *kvm)
+{
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
 	kfree(kvm);
+}
+
+static int kvm_vm_release(struct inode *inode, struct file *filp)
+{
+	struct kvm *kvm = filp->private_data;
+
+	kvm_destroy_vm(kvm);
 	return 0;
 }
 
@@ -1900,17 +1964,14 @@ static int kvm_dev_ioctl_debug_guest(str
 	return r;
 }
 
-static long kvm_dev_ioctl(struct file *filp,
-			  unsigned int ioctl, unsigned long arg)
+static long kvm_vm_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r = -EINVAL;
 
 	switch (ioctl) {
-	case KVM_GET_API_VERSION:
-		r = KVM_API_VERSION;
-		break;
 	case KVM_CREATE_VCPU:
 		r = kvm_dev_ioctl_create_vcpu(kvm, arg);
 		if (r)
@@ -2052,6 +2113,107 @@ static long kvm_dev_ioctl(struct file *f
 	case KVM_SET_MSRS:
 		r = msr_io(kvm, argp, do_set_msr, 0);
 		break;
+	default:
+		;
+	}
+out:
+	return r;
+}
+
+static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
+				  unsigned long address,
+				  int *type)
+{
+	struct kvm *kvm = vma->vm_file->private_data;
+	unsigned long pgoff;
+	struct kvm_memory_slot *slot;
+	struct page *page;
+
+	*type = VM_FAULT_MINOR;
+	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	slot = gfn_to_memslot(kvm, pgoff);
+	if (!slot)
+		return NOPAGE_SIGBUS;
+	page = gfn_to_page(slot, pgoff);
+	if (!page)
+		return NOPAGE_SIGBUS;
+	get_page(page);
+	return page;
+}
+
+static struct vm_operations_struct kvm_vm_vm_ops = {
+	.nopage = kvm_vm_nopage,
+};
+
+static int kvm_vm_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_ops = &kvm_vm_vm_ops;
+	return 0;
+}
+
+static struct file_operations kvm_vm_fops = {
+	.release        = kvm_vm_release,
+	.unlocked_ioctl = kvm_vm_ioctl,
+	.compat_ioctl   = kvm_vm_ioctl,
+	.mmap           = kvm_vm_mmap,
+};
+
+static int kvm_dev_ioctl_create_vm(void)
+{
+	int fd, r;
+	struct inode *inode;
+	struct file *file;
+	struct kvm *kvm;
+
+	inode = kvmfs_inode(&kvm_vm_fops);
+	if (IS_ERR(inode)) {
+		r = PTR_ERR(inode);
+		goto out1;
+	}
+
+	kvm = kvm_create_vm();
+	if (IS_ERR(kvm)) {
+		r = PTR_ERR(kvm);
+		goto out2;
+	}
+
+	file = kvmfs_file(inode, kvm);
+	if (IS_ERR(file)) {
+		r = PTR_ERR(file);
+		goto out3;
+	}
+
+	r = get_unused_fd();
+	if (r < 0)
+		goto out4;
+	fd = r;
+	fd_install(fd, file);
+
+	return fd;
+
+out4:
+	fput(file);
+out3:
+	kvm_destroy_vm(kvm);
+out2:
+	iput(inode);
+out1:
+	return r;
+}
+
+static long kvm_dev_ioctl(struct file *filp,
+			  unsigned int ioctl, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int r = -EINVAL;
+
+	switch (ioctl) {
+	case KVM_GET_API_VERSION:
+		r = KVM_API_VERSION;
+		break;
+	case KVM_CREATE_VM:
+		r = kvm_dev_ioctl_create_vm();
+		break;
 	case KVM_GET_MSR_INDEX_LIST: {
 		struct kvm_msr_list __user *user_msr_list = argp;
 		struct kvm_msr_list msr_list;
@@ -2086,43 +2248,11 @@ out:
 	return r;
 }
 
-static struct page *kvm_dev_nopage(struct vm_area_struct *vma,
-				   unsigned long address,
-				   int *type)
-{
-	struct kvm *kvm = vma->vm_file->private_data;
-	unsigned long pgoff;
-	struct kvm_memory_slot *slot;
-	struct page *page;
-
-	*type = VM_FAULT_MINOR;
-	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	slot = gfn_to_memslot(kvm, pgoff);
-	if (!slot)
-		return NOPAGE_SIGBUS;
-	page = gfn_to_page(slot, pgoff);
-	if (!page)
-		return NOPAGE_SIGBUS;
-	get_page(page);
-	return page;
-}
-
-static struct vm_operations_struct kvm_dev_vm_ops = {
-	.nopage = kvm_dev_nopage,
-};
-
-static int kvm_dev_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	vma->vm_ops = &kvm_dev_vm_ops;
-	return 0;
-}
-
 static struct file_operations kvm_chardev_ops = {
 	.open		= kvm_dev_open,
 	.release        = kvm_dev_release,
 	.unlocked_ioctl = kvm_dev_ioctl,
 	.compat_ioctl   = kvm_dev_ioctl,
-	.mmap           = kvm_dev_mmap,
 };
 
 static struct miscdevice kvm_dev = {
diff -puN include/linux/kvm.h~kvm-create-an-inode-per-virtual-machine include/linux/kvm.h
--- a/include/linux/kvm.h~kvm-create-an-inode-per-virtual-machine
+++ a/include/linux/kvm.h
@@ -224,7 +224,16 @@ struct kvm_dirty_log {
 
 #define KVMIO 0xAE
 
+/*
+ * ioctls for /dev/kvm fds:
+ */
 #define KVM_GET_API_VERSION       _IO(KVMIO, 1)
+#define KVM_CREATE_VM             _IO(KVMIO, 2) /* returns a VM fd */
+#define KVM_GET_MSR_INDEX_LIST    _IOWR(KVMIO, 15, struct kvm_msr_list)
+
+/*
+ * ioctls for VM fds
+ */
 #define KVM_RUN                   _IOWR(KVMIO, 2, struct kvm_run)
 #define KVM_GET_REGS              _IOWR(KVMIO, 3, struct kvm_regs)
 #define KVM_SET_REGS              _IOW(KVMIO, 4, struct kvm_regs)
@@ -238,6 +247,5 @@ struct kvm_dirty_log {
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 12, struct kvm_dirty_log)
 #define KVM_GET_MSRS              _IOWR(KVMIO, 13, struct kvm_msrs)
 #define KVM_SET_MSRS              _IOWR(KVMIO, 14, struct kvm_msrs)
-#define KVM_GET_MSR_INDEX_LIST    _IOWR(KVMIO, 15, struct kvm_msr_list)
 
 #endif
_

Patches currently in -mm which might be from avi@qumranet.com are

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
