From: akpm@osdl.org
Subject: - kernel-change-uses-of-f_dentry.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:02 -0800
Message-ID: <200612082002.kB8K22jq001939@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56950 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426224AbWLHUCF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     kernel: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     kernel-change-uses-of-f_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in
linux/kernel/.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/acct.c   |   14 +++++++-------
 kernel/fork.c   |    2 +-
 kernel/futex.c  |   10 +++++-----
 kernel/relay.c  |    4 ++--
 kernel/sysctl.c |    2 +-
 5 files changed, 16 insertions(+), 16 deletions(-)

diff -puN kernel/acct.c~kernel-change-uses-of-f_dentry kernel/acct.c
--- a/kernel/acct.c~kernel-change-uses-of-f_dentry
+++ a/kernel/acct.c
@@ -118,7 +118,7 @@ static int check_free_space(struct file 
 	spin_unlock(&acct_globals.lock);
 
 	/* May block */
-	if (vfs_statfs(file->f_dentry, &sbuf))
+	if (vfs_statfs(file->f_path.dentry, &sbuf))
 		return res;
 	suspend = sbuf.f_blocks * SUSPEND;
 	resume = sbuf.f_blocks * RESUME;
@@ -194,7 +194,7 @@ static void acct_file_reopen(struct file
 		add_timer(&acct_globals.timer);
 	}
 	if (old_acct) {
-		mnt_unpin(old_acct->f_vfsmnt);
+		mnt_unpin(old_acct->f_path.mnt);
 		spin_unlock(&acct_globals.lock);
 		do_acct_process(old_acct);
 		filp_close(old_acct, NULL);
@@ -212,7 +212,7 @@ static int acct_on(char *name)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	if (!S_ISREG(file->f_dentry->d_inode->i_mode)) {
+	if (!S_ISREG(file->f_path.dentry->d_inode->i_mode)) {
 		filp_close(file, NULL);
 		return -EACCES;
 	}
@@ -229,11 +229,11 @@ static int acct_on(char *name)
 	}
 
 	spin_lock(&acct_globals.lock);
-	mnt_pin(file->f_vfsmnt);
+	mnt_pin(file->f_path.mnt);
 	acct_file_reopen(file);
 	spin_unlock(&acct_globals.lock);
 
-	mntput(file->f_vfsmnt);	/* it's pinned, now give up active reference */
+	mntput(file->f_path.mnt); /* it's pinned, now give up active reference */
 
 	return 0;
 }
@@ -283,7 +283,7 @@ asmlinkage long sys_acct(const char __us
 void acct_auto_close_mnt(struct vfsmount *m)
 {
 	spin_lock(&acct_globals.lock);
-	if (acct_globals.file && acct_globals.file->f_vfsmnt == m)
+	if (acct_globals.file && acct_globals.file->f_path.mnt == m)
 		acct_file_reopen(NULL);
 	spin_unlock(&acct_globals.lock);
 }
@@ -299,7 +299,7 @@ void acct_auto_close(struct super_block 
 {
 	spin_lock(&acct_globals.lock);
 	if (acct_globals.file &&
-	    acct_globals.file->f_vfsmnt->mnt_sb == sb) {
+	    acct_globals.file->f_path.mnt->mnt_sb == sb) {
 		acct_file_reopen(NULL);
 	}
 	spin_unlock(&acct_globals.lock);
diff -puN kernel/fork.c~kernel-change-uses-of-f_dentry kernel/fork.c
--- a/kernel/fork.c~kernel-change-uses-of-f_dentry
+++ a/kernel/fork.c
@@ -252,7 +252,7 @@ static inline int dup_mmap(struct mm_str
 		anon_vma_link(tmp);
 		file = tmp->vm_file;
 		if (file) {
-			struct inode *inode = file->f_dentry->d_inode;
+			struct inode *inode = file->f_path.dentry->d_inode;
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
diff -puN kernel/futex.c~kernel-change-uses-of-f_dentry kernel/futex.c
--- a/kernel/futex.c~kernel-change-uses-of-f_dentry
+++ a/kernel/futex.c
@@ -166,7 +166,7 @@ static inline int match_futex(union fute
 /*
  * Get parameters which are the keys for a futex.
  *
- * For shared mappings, it's (page->index, vma->vm_file->f_dentry->d_inode,
+ * For shared mappings, it's (page->index, vma->vm_file->f_path.dentry->d_inode,
  * offset_within_page).  For private mappings, it's (uaddr, current->mm).
  * We can usually work out the index without swapping in the page.
  *
@@ -223,7 +223,7 @@ static int get_futex_key(u32 __user *uad
 	/*
 	 * Linear file mappings are also simple.
 	 */
-	key->shared.inode = vma->vm_file->f_dentry->d_inode;
+	key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
 	key->both.offset++; /* Bit 0 of offset indicates inode-based key. */
 	if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
 		key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
@@ -1528,9 +1528,9 @@ static int futex_fd(u32 __user *uaddr, i
 		goto out;
 	}
 	filp->f_op = &futex_fops;
-	filp->f_vfsmnt = mntget(futex_mnt);
-	filp->f_dentry = dget(futex_mnt->mnt_root);
-	filp->f_mapping = filp->f_dentry->d_inode->i_mapping;
+	filp->f_path.mnt = mntget(futex_mnt);
+	filp->f_path.dentry = dget(futex_mnt->mnt_root);
+	filp->f_mapping = filp->f_path.dentry->d_inode->i_mapping;
 
 	if (signal) {
 		err = __f_setown(filp, task_pid(current), PIDTYPE_PID, 1);
diff -puN kernel/relay.c~kernel-change-uses-of-f_dentry kernel/relay.c
--- a/kernel/relay.c~kernel-change-uses-of-f_dentry
+++ a/kernel/relay.c
@@ -959,7 +959,7 @@ static inline ssize_t relay_file_read_su
 	if (!desc->count)
 		return 0;
 
-	mutex_lock(&filp->f_dentry->d_inode->i_mutex);
+	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
 	do {
 		if (!relay_file_read_avail(buf, *ppos))
 			break;
@@ -979,7 +979,7 @@ static inline ssize_t relay_file_read_su
 			*ppos = relay_file_read_end_pos(buf, read_start, ret);
 		}
 	} while (desc->count && ret);
-	mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
+	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
 
 	return desc->written;
 }
diff -puN kernel/sysctl.c~kernel-change-uses-of-f_dentry kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-change-uses-of-f_dentry
+++ a/kernel/sysctl.c
@@ -1614,7 +1614,7 @@ static ssize_t do_rw_proc(int write, str
 			  size_t count, loff_t *ppos)
 {
 	int op;
-	struct proc_dir_entry *de = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *de = PDE(file->f_path.dentry->d_inode);
 	struct ctl_table *table;
 	size_t res;
 	ssize_t error = -ENOTDIR;
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

