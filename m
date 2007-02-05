From: akpm@linux-foundation.org
Subject: + shm-make-sysv-ipc-shared-memory-use-stacked-files.patch added to -mm tree
Date: Mon, 05 Feb 2007 15:00:30 -0800
Message-ID: <200702052300.l15N0UiC001964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37786 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964907AbXBEXAe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 18:00:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     shm: make sysv ipc shared memory use stacked files
has been added to the -mm tree.  Its filename is
     shm-make-sysv-ipc-shared-memory-use-stacked-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: shm: make sysv ipc shared memory use stacked files
From: ebiederm@xmission.com (Eric W. Biederman)

The current ipc shared memory code runs into several problems because it
does not quiet use files like the rest of the kernel.  With the option of
backing ipc shared memory with either hugetlbfs or ordinary shared memory
the problems got worse.  With the added support for ipc namespaces things
behaved so unexpected that we now have several bad namespace reference
counting bugs when using what appears at first glance to be a reasonable
idiom.

So to attack these problems and hopefully make the code more maintainable
this patch simply uses the files provided by other parts of the kernel and
builds it's own files out of them.  The shm files are allocated in do_shmat
and freed when their reference count drops to zero with their last unmap. 
The file and vm operations that we don't want to implement or we don't
implement completely we just delegate to the operations of our backing
file.

This means that we now get an accurate shm_nattch count for we have a
hugetlbfs inode for backing store, and the shm accounting of last attach
and last detach time work as well.

This means that getting a reference to the ipc namespace when we create the
file and dropping the referenece in the release method is now safe and
correct.

This means we no longer need a special case for clearing VM_MAYWRITE
as our file descriptor now only has write permissions when we have
requested write access when calling shmat.  Although VM_SHARED is now
cleared as well which I believe is harmless and is mostly likely a
minor bug fix.

By using the same set of operations for both the hugetlb case and regular
shared memory case shmdt is not simplified and made slightly more correct
as now the test "vma->vm_ops == &shm_vm_ops" is 100% accurate in spotting
all shared memory regions generated from sysvipc shared memory.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |  205 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 134 insertions(+), 71 deletions(-)

diff -puN ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files ipc/shm.c
--- a/ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files
+++ a/ipc/shm.c
@@ -37,11 +37,21 @@
 #include <linux/seq_file.h>
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
+#include <linux/mount.h>
 
 #include <asm/uaccess.h>
 
 #include "util.h"
 
+struct shm_file_data {
+	int id;
+	struct ipc_namespace *ns;
+	struct file *file;
+	const struct vm_operations_struct *vm_ops;
+};
+
+#define shm_file_data(file) (*((struct shm_file_data **)&(file)->private_data))
+
 static struct file_operations shm_file_operations;
 static struct vm_operations_struct shm_vm_ops;
 
@@ -60,8 +70,8 @@ static struct ipc_ids init_shm_ids;
 
 static int newseg (struct ipc_namespace *ns, key_t key,
 		int shmflg, size_t size);
-static void shm_open (struct vm_area_struct *shmd);
-static void shm_close (struct vm_area_struct *shmd);
+static void shm_open(struct vm_area_struct *vma);
+static void shm_close(struct vm_area_struct *vma);
 static void shm_destroy (struct ipc_namespace *ns, struct shmid_kernel *shp);
 #ifdef CONFIG_PROC_FS
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
@@ -150,11 +160,14 @@ static inline int shm_addid(struct ipc_n
 
 
 
-static inline void shm_inc(struct ipc_namespace *ns, int id)
+/* This is called by fork, once for every shm attach. */
+static void shm_open(struct vm_area_struct *vma)
 {
+	struct file *file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
 	struct shmid_kernel *shp;
 
-	shp = shm_lock(ns, id);
+	shp = shm_lock(sfd->ns, sfd->id);
 	BUG_ON(!shp);
 	shp->shm_atim = get_seconds();
 	shp->shm_lprid = current->tgid;
@@ -162,15 +175,6 @@ static inline void shm_inc(struct ipc_na
 	shm_unlock(shp);
 }
 
-#define shm_file_ns(file) (*((struct ipc_namespace **)&(file)->private_data))
-
-/* This is called by fork, once for every shm attach. */
-static void shm_open(struct vm_area_struct *shmd)
-{
-	shm_inc(shm_file_ns(shmd->vm_file),
-			shmd->vm_file->f_path.dentry->d_inode->i_ino);
-}
-
 /*
  * shm_destroy - free the struct shmid_kernel
  *
@@ -195,23 +199,21 @@ static void shm_destroy(struct ipc_names
 }
 
 /*
- * remove the attach descriptor shmd.
+ * remove the attach descriptor vma.
  * free memory for segment if it is marked destroyed.
  * The descriptor has already been removed from the current->mm->mmap list
  * and will later be kfree()d.
  */
-static void shm_close (struct vm_area_struct *shmd)
+static void shm_close(struct vm_area_struct *vma)
 {
-	struct file * file = shmd->vm_file;
-	int id = file->f_path.dentry->d_inode->i_ino;
+	struct file * file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
 	struct shmid_kernel *shp;
-	struct ipc_namespace *ns;
-
-	ns = shm_file_ns(file);
+	struct ipc_namespace *ns = sfd->ns;
 
 	mutex_lock(&shm_ids(ns).mutex);
 	/* remove from the list of attaches of the shm segment */
-	shp = shm_lock(ns, id);
+	shp = shm_lock(ns, sfd->id);
 	BUG_ON(!shp);
 	shp->shm_lprid = current->tgid;
 	shp->shm_dtim = get_seconds();
@@ -224,46 +226,91 @@ static void shm_close (struct vm_area_st
 	mutex_unlock(&shm_ids(ns).mutex);
 }
 
+struct page *shm_nopage(struct vm_area_struct *vma, unsigned long address,
+			int *type)
+{
+	struct file *file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
+
+	return sfd->vm_ops->nopage(vma, address, type);
+}
+
+#ifdef CONFIG_NUMA
+int shm_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
+{
+	struct file *file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
+	int err = 0;
+	if (sfd->vm_ops->set_policy)
+		err = sfd->vm_ops->set_policy(vma, new);
+	return err;
+}
+
+struct mempolicy *shm_get_policy(struct vm_area_struct *vma, unsigned long addr)
+{
+	struct file *file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
+	struct mempolicy *pol = NULL;
+
+	if (sfd->vm_ops->get_policy)
+		pol = sfd->vm_ops->get_policy(vma, addr);
+	else
+		pol = vma->vm_policy;
+	return pol;
+}
+#endif
+
 static int shm_mmap(struct file * file, struct vm_area_struct * vma)
 {
+	struct shm_file_data *sfd = shm_file_data(file);
 	int ret;
 
-	ret = shmem_mmap(file, vma);
-	if (ret == 0) {
-		vma->vm_ops = &shm_vm_ops;
-		if (!(vma->vm_flags & VM_WRITE))
-			vma->vm_flags &= ~VM_MAYWRITE;
-		shm_inc(shm_file_ns(file), file->f_path.dentry->d_inode->i_ino);
-	}
+	ret = sfd->file->f_op->mmap(sfd->file, vma);
+	if (ret != 0)
+		return ret;
+	sfd->vm_ops = vma->vm_ops;
+	vma->vm_ops = &shm_vm_ops;
+	shm_open(vma);
 
 	return ret;
 }
 
 static int shm_release(struct inode *ino, struct file *file)
 {
-	struct ipc_namespace *ns;
+	struct shm_file_data *sfd = shm_file_data(file);
 
-	ns = shm_file_ns(file);
-	put_ipc_ns(ns);
-	shm_file_ns(file) = NULL;
+	put_ipc_ns(sfd->ns);
+	shm_file_data(file) = NULL;
+	kfree(sfd);
 	return 0;
 }
 
+#ifndef CONFIG_MMU
+static unsigned long shm_get_unmapped_area(struct file *file,
+	unsigned long addr, unsigned long len, unsigned long pgoff,
+	unsigned long flags)
+{
+	struct shm_file_data *sfd = shm_file_data(file);
+	return sfd->file->f_op->get_unmapped_area(sfd->file, addr, len, pgoff,
+							flags);
+}
+#else
+#define shm_get_unmapped_area NULL
+#endif
+
 static struct file_operations shm_file_operations = {
 	.mmap		= shm_mmap,
 	.release	= shm_release,
-#ifndef CONFIG_MMU
-	.get_unmapped_area = shmem_get_unmapped_area,
-#endif
+	.get_unmapped_area	= shm_get_unmapped_area,
 };
 
 static struct vm_operations_struct shm_vm_ops = {
 	.open	= shm_open,	/* callback for a new vm-area open */
 	.close	= shm_close,	/* callback for when the vm-area is released */
-	.nopage	= shmem_nopage,
-#if defined(CONFIG_NUMA) && defined(CONFIG_SHMEM)
-	.set_policy = shmem_set_policy,
-	.get_policy = shmem_get_policy,
+	.nopage	= shm_nopage,
+#if defined(CONFIG_NUMA)
+	.set_policy = shm_set_policy,
+	.get_policy = shm_get_policy,
 #endif
 };
 
@@ -330,13 +377,6 @@ static int newseg (struct ipc_namespace 
 	shp->shm_nattch = 0;
 	shp->id = shm_buildid(ns, id, shp->shm_perm.seq);
 	shp->shm_file = file;
-	file->f_path.dentry->d_inode->i_ino = shp->id;
-
-	shm_file_ns(file) = get_ipc_ns(ns);
-
-	/* Hugetlb ops would have already been assigned. */
-	if (!(shmflg & SHM_HUGETLB))
-		file->f_op = &shm_file_operations;
 
 	ns->shm_tot += numpages;
 	shm_unlock(shp);
@@ -607,10 +647,7 @@ asmlinkage long sys_shmctl (int shmid, i
 		tbuf.shm_ctime	= shp->shm_ctim;
 		tbuf.shm_cpid	= shp->shm_cprid;
 		tbuf.shm_lpid	= shp->shm_lprid;
-		if (!is_file_hugepages(shp->shm_file))
-			tbuf.shm_nattch	= shp->shm_nattch;
-		else
-			tbuf.shm_nattch = file_count(shp->shm_file) - 1;
+		tbuf.shm_nattch	= shp->shm_nattch;
 		shm_unlock(shp);
 		if(copy_shmid_to_user (buf, &tbuf, version))
 			err = -EFAULT;
@@ -781,6 +818,8 @@ long do_shmat(int shmid, char __user *sh
 	int acc_mode;
 	void *user_addr;
 	struct ipc_namespace *ns;
+	struct shm_file_data *sfd;
+	mode_t f_mode;
 
 	if (shmid < 0) {
 		err = -EINVAL;
@@ -806,9 +845,11 @@ long do_shmat(int shmid, char __user *sh
 	if (shmflg & SHM_RDONLY) {
 		prot = PROT_READ;
 		acc_mode = S_IRUGO;
+		f_mode = FMODE_READ;
 	} else {
 		prot = PROT_READ | PROT_WRITE;
 		acc_mode = S_IRUGO | S_IWUGO;
+		f_mode = FMODE_READ | FMODE_WRITE;
 	}
 	if (shmflg & SHM_EXEC) {
 		prot |= PROT_EXEC;
@@ -820,29 +861,43 @@ long do_shmat(int shmid, char __user *sh
 	 * additional creator id...
 	 */
 	ns = current->nsproxy->ipc_ns;
+	err = -EINVAL;
 	shp = shm_lock(ns, shmid);
-	if(shp == NULL) {
-		err = -EINVAL;
+	if(shp == NULL)
 		goto out;
-	}
+
 	err = shm_checkid(ns, shp,shmid);
-	if (err) {
-		shm_unlock(shp);
-		goto out;
-	}
-	if (ipcperms(&shp->shm_perm, acc_mode)) {
-		shm_unlock(shp);
-		err = -EACCES;
-		goto out;
-	}
+	if (err)
+		goto out_unlock;
+
+	err = -EACCES;
+	if (ipcperms(&shp->shm_perm, acc_mode))
+		goto out_unlock;
 
 	err = security_shm_shmat(shp, shmaddr, shmflg);
-	if (err) {
-		shm_unlock(shp);
-		return err;
-	}
-		
-	file = shp->shm_file;
+	if (err)
+		goto out_unlock;
+
+	err = -ENOMEM;
+	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
+	if (!sfd)
+		goto out_unlock;
+
+	file = get_empty_filp();
+	if (!file)
+		goto out_free;
+
+	file->f_op = &shm_file_operations;
+	file->private_data = sfd;
+	file->f_path.dentry = dget(shp->shm_file->f_path.dentry);
+	file->f_path.mnt = mntget(shp->shm_file->f_path.mnt);
+	file->f_mapping = shp->shm_file->f_mapping;
+	file->f_mode = f_mode;
+	sfd->id = shp->id;
+	sfd->ns = get_ipc_ns(ns);
+	sfd->file = shp->shm_file;
+	sfd->vm_ops = NULL;
+
 	size = i_size_read(file->f_path.dentry->d_inode);
 	shp->shm_nattch++;
 	shm_unlock(shp);
@@ -866,6 +921,8 @@ long do_shmat(int shmid, char __user *sh
 invalid:
 	up_write(&current->mm->mmap_sem);
 
+	fput(file);
+
 	mutex_lock(&shm_ids(ns).mutex);
 	shp = shm_lock(ns, shmid);
 	BUG_ON(!shp);
@@ -883,6 +940,12 @@ invalid:
 		err = PTR_ERR(user_addr);
 out:
 	return err;
+out_free:
+	kfree(sfd);
+out_unlock:
+	shm_unlock(shp);
+	goto out;
+
 }
 
 asmlinkage long sys_shmat(int shmid, char __user *shmaddr, int shmflg)
@@ -944,7 +1007,7 @@ asmlinkage long sys_shmdt(char __user *s
 		 * a fragment created by mprotect() and/or munmap(), or it
 		 * otherwise it starts at this address with no hassles.
 		 */
-		if ((vma->vm_ops == &shm_vm_ops || is_vm_hugetlb_page(vma)) &&
+		if ((vma->vm_ops == &shm_vm_ops) &&
 			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) {
 
 
@@ -973,7 +1036,7 @@ asmlinkage long sys_shmdt(char __user *s
 		next = vma->vm_next;
 
 		/* finding a matching vma now does not alter retval */
-		if ((vma->vm_ops == &shm_vm_ops || is_vm_hugetlb_page(vma)) &&
+		if ((vma->vm_ops == &shm_vm_ops) &&
 			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff)
 
 			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
@@ -1004,7 +1067,7 @@ static int sysvipc_shm_proc_show(struct 
 			  shp->shm_segsz,
 			  shp->shm_cprid,
 			  shp->shm_lprid,
-			  is_file_hugepages(shp->shm_file) ? (file_count(shp->shm_file) - 1) : shp->shm_nattch,
+			  shp->shm_nattch,
 			  shp->shm_perm.uid,
 			  shp->shm_perm.gid,
 			  shp->shm_perm.cuid,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
powerpc-rtas-msi-support.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
fix-i-oat-for-kexec.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
kexec-update-io-apic-dest-field-to-8-bit-for.patch
x86_64-survive-having-no-irq-mapping-for-a-vector.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
_proc_do_string-fix-short-reads.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc-fix.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-reimplement-the-sysctl-proc-support-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-fix.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
