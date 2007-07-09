From: akpm@linux-foundation.org
Subject: - fix-rmmod-read-write-races-in-proc-entries-cleanup.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:18:49 -0700
Message-ID: <200707092118.l69LInrT012426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbXGIVUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: introduce and use pde_users_dec()
has been removed from the -mm tree.  Its filename was
     fix-rmmod-read-write-races-in-proc-entries-cleanup.patch

This patch was dropped because it was folded into fix-rmmod-read-write-races-in-proc-entries.patch

------------------------------------------------------
Subject: proc: introduce and use pde_users_dec()
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |  135 ++++++++++++++++++----------------------------
 1 files changed, 54 insertions(+), 81 deletions(-)

diff -puN fs/proc/inode.c~fix-rmmod-read-write-races-in-proc-entries-cleanup fs/proc/inode.c
--- a/fs/proc/inode.c~fix-rmmod-read-write-races-in-proc-entries-cleanup
+++ a/fs/proc/inode.c
@@ -140,6 +140,15 @@ static const struct super_operations pro
 	.remount_fs	= proc_remount,
 };
 
+static void pde_users_dec(struct proc_dir_entry *pde)
+{
+	spin_lock(&pde->pde_unload_lock);
+	pde->pde_users--;
+	if (pde->pde_unload_completion && pde->pde_users == 0)
+		complete(pde->pde_unload_completion);
+	spin_unlock(&pde->pde_unload_lock);
+}
+
 static loff_t proc_reg_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
@@ -151,8 +160,10 @@ static loff_t proc_reg_llseek(struct fil
 	 * remove_proc_entry() is going to delete PDE (as part of module
 	 * cleanup sequence). No new callers into module allowed.
 	 */
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	/*
 	 * Bump refcount so that remove_proc_entry will wail for ->llseek to
 	 * complete.
@@ -169,13 +180,7 @@ static loff_t proc_reg_llseek(struct fil
 		llseek = default_llseek;
 	rv = llseek(file, offset, whence);
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -186,8 +191,10 @@ static ssize_t proc_reg_read(struct file
 	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	pde->pde_users++;
 	read = pde->proc_fops->read;
 	spin_unlock(&pde->pde_unload_lock);
@@ -195,13 +202,7 @@ static ssize_t proc_reg_read(struct file
 	if (read)
 		rv = read(file, buf, count, ppos);
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -212,8 +213,10 @@ static ssize_t proc_reg_write(struct fil
 	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	pde->pde_users++;
 	write = pde->proc_fops->write;
 	spin_unlock(&pde->pde_unload_lock);
@@ -221,13 +224,7 @@ static ssize_t proc_reg_write(struct fil
 	if (write)
 		rv = write(file, buf, count, ppos);
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -238,8 +235,10 @@ static unsigned int proc_reg_poll(struct
 	unsigned int (*poll)(struct file *, struct poll_table_struct *);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	pde->pde_users++;
 	poll = pde->proc_fops->poll;
 	spin_unlock(&pde->pde_unload_lock);
@@ -247,13 +246,7 @@ static unsigned int proc_reg_poll(struct
 	if (poll)
 		rv = poll(file, pts);
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -265,8 +258,10 @@ static long proc_reg_unlocked_ioctl(stru
 	int (*ioctl)(struct inode *, struct file *, unsigned int, unsigned long);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	pde->pde_users++;
 	unlocked_ioctl = pde->proc_fops->unlocked_ioctl;
 	ioctl = pde->proc_fops->ioctl;
@@ -282,13 +277,7 @@ static long proc_reg_unlocked_ioctl(stru
 		unlock_kernel();
 	}
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -300,8 +289,10 @@ static long proc_reg_compat_ioctl(struct
 	long (*compat_ioctl)(struct file *, unsigned int, unsigned long);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	pde->pde_users++;
 	compat_ioctl = pde->proc_fops->compat_ioctl;
 	spin_unlock(&pde->pde_unload_lock);
@@ -309,13 +300,7 @@ static long proc_reg_compat_ioctl(struct
 	if (compat_ioctl)
 		rv = compat_ioctl(file, cmd, arg);
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 #endif
@@ -327,8 +312,10 @@ static int proc_reg_mmap(struct file *fi
 	int (*mmap)(struct file *, struct vm_area_struct *);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	pde->pde_users++;
 	mmap = pde->proc_fops->mmap;
 	spin_unlock(&pde->pde_unload_lock);
@@ -336,13 +323,7 @@ static int proc_reg_mmap(struct file *fi
 	if (mmap)
 		rv = mmap(file, vma);
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -353,8 +334,10 @@ static int proc_reg_open(struct inode *i
 	int (*open)(struct inode *, struct file *);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;
 	spin_unlock(&pde->pde_unload_lock);
@@ -362,13 +345,7 @@ static int proc_reg_open(struct inode *i
 	if (open)
 		rv = open(inode, file);
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 
@@ -379,8 +356,10 @@ static int proc_reg_release(struct inode
 	int (*release)(struct inode *, struct file *);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (!pde->proc_fops)
-		goto out_unlock;
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
 	pde->pde_users++;
 	release = pde->proc_fops->release;
 	spin_unlock(&pde->pde_unload_lock);
@@ -388,13 +367,7 @@ static int proc_reg_release(struct inode
 	if (release)
 		rv = release(inode, file);
 
-	spin_lock(&pde->pde_unload_lock);
-	pde->pde_users--;
-	if (pde->pde_unload_completion && pde->pde_users == 0)
-		complete(pde->pde_unload_completion);
-out_unlock:
-	spin_unlock(&pde->pde_unload_lock);
-
+	pde_users_dec(pde);
 	return rv;
 }
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

make-proc-slabinfo-use-seq_list_xxx-helpers.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch
gitignore-update.patch
