From: akpm@linux-foundation.org
Subject: - proc-drop-several-pde-valid-invalid-checks.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:53 -0700
Message-ID: <200804300545.m3U5jrGQ029552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756929AbYD3GDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: drop several "PDE valid/invalid" checks
has been removed from the -mm tree.  Its filename was
     proc-drop-several-pde-valid-invalid-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: drop several "PDE valid/invalid" checks
From: Alexey Dobriyan <adobriyan@gmail.com>

proc-misc code is noticeably full of "if (de)" checks when PDE passed is
always valid.  Remove them.

Addition of such check in proc_lookup_de() is for failed lookup case.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   31 ++++++++-----------
 fs/proc/inode.c   |   69 ++++++++++++++++++++------------------------
 2 files changed, 45 insertions(+), 55 deletions(-)

diff -puN fs/proc/generic.c~proc-drop-several-pde-valid-invalid-checks fs/proc/generic.c
--- a/fs/proc/generic.c~proc-drop-several-pde-valid-invalid-checks
+++ a/fs/proc/generic.c
@@ -388,20 +388,18 @@ struct dentry *proc_lookup_de(struct pro
 
 	lock_kernel();
 	spin_lock(&proc_subdir_lock);
-	if (de) {
-		for (de = de->subdir; de ; de = de->next) {
-			if (de->namelen != dentry->d_name.len)
-				continue;
-			if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
-				unsigned int ino;
+	for (de = de->subdir; de ; de = de->next) {
+		if (de->namelen != dentry->d_name.len)
+			continue;
+		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
+			unsigned int ino;
 
-				ino = de->low_ino;
-				de_get(de);
-				spin_unlock(&proc_subdir_lock);
-				error = -EINVAL;
-				inode = proc_get_inode(dir->i_sb, ino, de);
-				goto out_unlock;
-			}
+			ino = de->low_ino;
+			de_get(de);
+			spin_unlock(&proc_subdir_lock);
+			error = -EINVAL;
+			inode = proc_get_inode(dir->i_sb, ino, de);
+			goto out_unlock;
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
@@ -413,7 +411,8 @@ out_unlock:
 		d_add(dentry, inode);
 		return NULL;
 	}
-	de_put(de);
+	if (de)
+		de_put(de);
 	return ERR_PTR(error);
 }
 
@@ -443,10 +442,6 @@ int proc_readdir_de(struct proc_dir_entr
 	lock_kernel();
 
 	ino = inode->i_ino;
-	if (!de) {
-		ret = -EINVAL;
-		goto out;
-	}
 	i = filp->f_pos;
 	switch (i) {
 		case 0:
diff -puN fs/proc/inode.c~proc-drop-several-pde-valid-invalid-checks fs/proc/inode.c
--- a/fs/proc/inode.c~proc-drop-several-pde-valid-invalid-checks
+++ a/fs/proc/inode.c
@@ -25,8 +25,7 @@
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de)
 {
-	if (de)
-		atomic_inc(&de->count);
+	atomic_inc(&de->count);
 	return de;
 }
 
@@ -35,18 +34,16 @@ struct proc_dir_entry *de_get(struct pro
  */
 void de_put(struct proc_dir_entry *de)
 {
-	if (de) {	
-		lock_kernel();		
-		if (!atomic_read(&de->count)) {
-			printk("de_put: entry %s already free!\n", de->name);
-			unlock_kernel();
-			return;
-		}
-
-		if (atomic_dec_and_test(&de->count))
-			free_proc_entry(de);
+	lock_kernel();
+	if (!atomic_read(&de->count)) {
+		printk("de_put: entry %s already free!\n", de->name);
 		unlock_kernel();
+		return;
 	}
+
+	if (atomic_dec_and_test(&de->count))
+		free_proc_entry(de);
+	unlock_kernel();
 }
 
 /*
@@ -392,7 +389,7 @@ struct inode *proc_get_inode(struct supe
 {
 	struct inode * inode;
 
-	if (de != NULL && !try_module_get(de->owner))
+	if (!try_module_get(de->owner))
 		goto out_mod;
 
 	inode = iget_locked(sb, ino);
@@ -402,30 +399,29 @@ struct inode *proc_get_inode(struct supe
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
-		if (de) {
-			if (de->mode) {
-				inode->i_mode = de->mode;
-				inode->i_uid = de->uid;
-				inode->i_gid = de->gid;
-			}
-			if (de->size)
-				inode->i_size = de->size;
-			if (de->nlink)
-				inode->i_nlink = de->nlink;
-			if (de->proc_iops)
-				inode->i_op = de->proc_iops;
-			if (de->proc_fops) {
-				if (S_ISREG(inode->i_mode)) {
+
+		if (de->mode) {
+			inode->i_mode = de->mode;
+			inode->i_uid = de->uid;
+			inode->i_gid = de->gid;
+		}
+		if (de->size)
+			inode->i_size = de->size;
+		if (de->nlink)
+			inode->i_nlink = de->nlink;
+		if (de->proc_iops)
+			inode->i_op = de->proc_iops;
+		if (de->proc_fops) {
+			if (S_ISREG(inode->i_mode)) {
 #ifdef CONFIG_COMPAT
-					if (!de->proc_fops->compat_ioctl)
-						inode->i_fop =
-							&proc_reg_file_ops_no_compat;
-					else
+				if (!de->proc_fops->compat_ioctl)
+					inode->i_fop =
+						&proc_reg_file_ops_no_compat;
+				else
 #endif
-						inode->i_fop = &proc_reg_file_ops;
-				} else {
-					inode->i_fop = de->proc_fops;
-				}
+					inode->i_fop = &proc_reg_file_ops;
+			} else {
+				inode->i_fop = de->proc_fops;
 			}
 		}
 		unlock_new_inode(inode);
@@ -433,8 +429,7 @@ struct inode *proc_get_inode(struct supe
 	return inode;
 
 out_ino:
-	if (de != NULL)
-		module_put(de->owner);
+	module_put(de->owner);
 out_mod:
 	return NULL;
 }			
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-xfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

