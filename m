From: akpm@linux-foundation.org
Subject: + shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:32:29 -0800
Message-ID: <200702160032.l1G0WTdV013778@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422872AbXBPAce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 19:32:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, michal.k.k.piotrowski@gmail.com


The patch titled
     shm: fix the locking and cleanup error handling in do_shmat
has been added to the -mm tree.  Its filename is
     shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: shm: fix the locking and cleanup error handling in do_shmat
From: ebiederm@xmission.com (Eric W. Biederman)

When enhancing do_shmat I forgot to take into account that shm_lock
is a spinlock, and was allocating memory with the lock held.

This patch fixes that by grabbing a reference to the dentry and mounts of
shm_file before we drop the shm_lock and then performing the memory
allocations.

This is also a bit of a general scrub on the error handling.  Everything is
now forced through the single return statement for clarity, and the
handling of the return address now uses fewer casts.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   54 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 23 deletions(-)

diff -puN ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix ipc/shm.c
--- a/ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix
+++ a/ipc/shm.c
@@ -816,15 +816,16 @@ long do_shmat(int shmid, char __user *sh
 	unsigned long flags;
 	unsigned long prot;
 	int acc_mode;
-	void *user_addr;
+	unsigned long user_addr;
 	struct ipc_namespace *ns;
 	struct shm_file_data *sfd;
+	struct path path;
 	mode_t f_mode;
 
-	if (shmid < 0) {
-		err = -EINVAL;
+	err = -EINVAL;
+	if (shmid < 0)
 		goto out;
-	} else if ((addr = (ulong)shmaddr)) {
+	else if ((addr = (ulong)shmaddr)) {
 		if (addr & (SHMLBA-1)) {
 			if (shmflg & SHM_RND)
 				addr &= ~(SHMLBA-1);	   /* round down */
@@ -832,12 +833,12 @@ long do_shmat(int shmid, char __user *sh
 #ifndef __ARCH_FORCE_SHMLBA
 				if (addr & ~PAGE_MASK)
 #endif
-					return -EINVAL;
+					goto out;
 		}
 		flags = MAP_SHARED | MAP_FIXED;
 	} else {
 		if ((shmflg & SHM_REMAP))
-			return -EINVAL;
+			goto out;
 
 		flags = MAP_SHARED;
 	}
@@ -861,7 +862,6 @@ long do_shmat(int shmid, char __user *sh
 	 * additional creator id...
 	 */
 	ns = current->nsproxy->ipc_ns;
-	err = -EINVAL;
 	shp = shm_lock(ns, shmid);
 	if(shp == NULL)
 		goto out;
@@ -878,19 +878,25 @@ long do_shmat(int shmid, char __user *sh
 	if (err)
 		goto out_unlock;
 
+	path.dentry = dget(shp->shm_file->f_path.dentry);
+	path.mnt    = mntget(shp->shm_file->f_path.mnt);
+	shp->shm_nattch++;
+	size = i_size_read(path.dentry->d_inode);
+	shm_unlock(shp);
+
 	err = -ENOMEM;
 	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
 	if (!sfd)
-		goto out_unlock;
+		goto out_put_path;
 
+	err = -ENOMEM;
 	file = get_empty_filp();
 	if (!file)
 		goto out_free;
 
 	file->f_op = &shm_file_operations;
 	file->private_data = sfd;
-	file->f_path.dentry = dget(shp->shm_file->f_path.dentry);
-	file->f_path.mnt = mntget(shp->shm_file->f_path.mnt);
+	file->f_path = path;
 	file->f_mapping = shp->shm_file->f_mapping;
 	file->f_mode = f_mode;
 	sfd->id = shp->id;
@@ -898,13 +904,9 @@ long do_shmat(int shmid, char __user *sh
 	sfd->file = shp->shm_file;
 	sfd->vm_ops = NULL;
 
-	size = i_size_read(file->f_path.dentry->d_inode);
-	shp->shm_nattch++;
-	shm_unlock(shp);
-
 	down_write(&current->mm->mmap_sem);
 	if (addr && !(shmflg & SHM_REMAP)) {
-		user_addr = ERR_PTR(-EINVAL);
+		err = -EINVAL;
 		if (find_vma_intersection(current->mm, addr, addr + size))
 			goto invalid;
 		/*
@@ -916,13 +918,17 @@ long do_shmat(int shmid, char __user *sh
 			goto invalid;
 	}
 		
-	user_addr = (void*) do_mmap (file, addr, size, prot, flags, 0);
-
+	user_addr = do_mmap (file, addr, size, prot, flags, 0);
+	*raddr = user_addr;
+	err = 0;
+	if (IS_ERR_VALUE(user_addr))
+		err = (long)user_addr;
 invalid:
 	up_write(&current->mm->mmap_sem);
 
 	fput(file);
 
+out_nattch:
 	mutex_lock(&shm_ids(ns).mutex);
 	shp = shm_lock(ns, shmid);
 	BUG_ON(!shp);
@@ -934,18 +940,20 @@ invalid:
 		shm_unlock(shp);
 	mutex_unlock(&shm_ids(ns).mutex);
 
-	*raddr = (unsigned long) user_addr;
-	err = 0;
-	if (IS_ERR(user_addr))
-		err = PTR_ERR(user_addr);
 out:
 	return err;
-out_free:
-	kfree(sfd);
+
 out_unlock:
 	shm_unlock(shp);
 	goto out;
 
+out_free:
+	kfree(sfd);
+out_put_path:
+	dput(path.dentry);
+	mntput(path.mnt);
+	goto out_nattch;
+
 }
 
 asmlinkage long sys_shmat(int shmid, char __user *shmaddr, int shmflg)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files-fix.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
