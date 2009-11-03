From: akpm@linux-foundation.org
Subject: + proc-rename-de_get-to-pde_get-and-inline-it.patch added to -mm tree
Date: Mon, 02 Nov 2009 18:00:15 -0800
Message-ID: <200911030200.nA320FRZ027009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000AbZKCCAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 21:00:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: rename de_get() to pde_get() and inline it
has been added to the -mm tree.  Its filename is
     proc-rename-de_get-to-pde_get-and-inline-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: rename de_get() to pde_get() and inline it
From: Alexey Dobriyan <adobriyan@gmail.com>

* de_get() is trivial -- make inline, save a few bits of code, drop
  "refcount is 0" check -- it should be done in some generic refcount
  code, don't recall it's was helpful

* rename GET and PUT functions to pde_get(), pde_put() for cool prefix!

* remove obvious and incorrent comments

* in remove_proc_entry() use pde_put(), when I fixed PDE refcounting to
  be normal one, remove_proc_entry() was supposed to do "-1" and code now
  reflects that.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/proc/generic.c~proc-rename-de_get-to-pde_get-and-inline-it fs/proc/generic.c
--- a/fs/proc/generic.c~proc-rename-de_get-to-pde_get-and-inline-it
+++ a/fs/proc/generic.c
@@ -429,7 +429,7 @@ struct dentry *proc_lookup_de(struct pro
 			unsigned int ino;
 
 			ino = de->low_ino;
-			de_get(de);
+			pde_get(de);
 			spin_unlock(&proc_subdir_lock);
 			error = -EINVAL;
 			inode = proc_get_inode(dir->i_sb, ino, de);
@@ -445,7 +445,7 @@ out_unlock:
 		return NULL;
 	}
 	if (de)
-		de_put(de);
+		pde_put(de);
 	return ERR_PTR(error);
 }
 
@@ -509,17 +509,17 @@ int proc_readdir_de(struct proc_dir_entr
 				struct proc_dir_entry *next;
 
 				/* filldir passes info to user space */
-				de_get(de);
+				pde_get(de);
 				spin_unlock(&proc_subdir_lock);
 				if (filldir(dirent, de->name, de->namelen, filp->f_pos,
 					    de->low_ino, de->mode >> 12) < 0) {
-					de_put(de);
+					pde_put(de);
 					goto out;
 				}
 				spin_lock(&proc_subdir_lock);
 				filp->f_pos++;
 				next = de->next;
-				de_put(de);
+				pde_put(de);
 				de = next;
 			} while (de);
 			spin_unlock(&proc_subdir_lock);
@@ -763,7 +763,7 @@ out:
 	return NULL;
 }
 
-void free_proc_entry(struct proc_dir_entry *de)
+static void free_proc_entry(struct proc_dir_entry *de)
 {
 	unsigned int ino = de->low_ino;
 
@@ -777,6 +777,12 @@ void free_proc_entry(struct proc_dir_ent
 	kfree(de);
 }
 
+void pde_put(struct proc_dir_entry *pde)
+{
+	if (atomic_dec_and_test(&pde->count))
+		free_proc_entry(pde);
+}
+
 /*
  * Remove a /proc entry and free it if it's not currently in use.
  */
@@ -845,6 +851,5 @@ continue_removing:
 	WARN(de->subdir, KERN_WARNING "%s: removing non-empty directory "
 			"'%s/%s', leaking at least '%s'\n", __func__,
 			de->parent->name, de->name, de->subdir->name);
-	if (atomic_dec_and_test(&de->count))
-		free_proc_entry(de);
+	pde_put(de);
 }
diff -puN fs/proc/inode.c~proc-rename-de_get-to-pde_get-and-inline-it fs/proc/inode.c
--- a/fs/proc/inode.c~proc-rename-de_get-to-pde_get-and-inline-it
+++ a/fs/proc/inode.c
@@ -24,29 +24,6 @@
 
 #include "internal.h"
 
-struct proc_dir_entry *de_get(struct proc_dir_entry *de)
-{
-	atomic_inc(&de->count);
-	return de;
-}
-
-/*
- * Decrements the use count and checks for deferred deletion.
- */
-void de_put(struct proc_dir_entry *de)
-{
-	if (!atomic_read(&de->count)) {
-		printk("de_put: entry %s already free!\n", de->name);
-		return;
-	}
-
-	if (atomic_dec_and_test(&de->count))
-		free_proc_entry(de);
-}
-
-/*
- * Decrement the use count of the proc_dir_entry.
- */
 static void proc_delete_inode(struct inode *inode)
 {
 	struct proc_dir_entry *de;
@@ -59,7 +36,7 @@ static void proc_delete_inode(struct ino
 	/* Let go of any associated proc directory entry */
 	de = PROC_I(inode)->pde;
 	if (de)
-		de_put(de);
+		pde_put(de);
 	if (PROC_I(inode)->sysctl)
 		sysctl_head_put(PROC_I(inode)->sysctl);
 	clear_inode(inode);
@@ -480,7 +457,7 @@ struct inode *proc_get_inode(struct supe
 		}
 		unlock_new_inode(inode);
 	} else
-	       de_put(de);
+	       pde_put(de);
 	return inode;
 }			
 
@@ -495,7 +472,7 @@ int proc_fill_super(struct super_block *
 	s->s_op = &proc_sops;
 	s->s_time_gran = 1;
 	
-	de_get(&proc_root);
+	pde_get(&proc_root);
 	root_inode = proc_get_inode(s, PROC_ROOT_INO, &proc_root);
 	if (!root_inode)
 		goto out_no_root;
@@ -509,6 +486,6 @@ int proc_fill_super(struct super_block *
 out_no_root:
 	printk("proc_read_super: get root inode failed\n");
 	iput(root_inode);
-	de_put(&proc_root);
+	pde_put(&proc_root);
 	return -ENOMEM;
 }
diff -puN fs/proc/internal.h~proc-rename-de_get-to-pde_get-and-inline-it fs/proc/internal.h
--- a/fs/proc/internal.h~proc-rename-de_get-to-pde_get-and-inline-it
+++ a/fs/proc/internal.h
@@ -61,8 +61,6 @@ extern const struct file_operations proc
 extern const struct file_operations proc_net_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
-void free_proc_entry(struct proc_dir_entry *de);
-
 void proc_init_inodecache(void);
 
 static inline struct pid *proc_pid(struct inode *inode)
@@ -101,8 +99,12 @@ unsigned long task_vsize(struct mm_struc
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 void task_mem(struct seq_file *, struct mm_struct *);
 
-struct proc_dir_entry *de_get(struct proc_dir_entry *de);
-void de_put(struct proc_dir_entry *de);
+static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
+{
+	atomic_inc(&pde->count);
+	return pde;
+}
+void pde_put(struct proc_dir_entry *pde);
 
 extern struct vfsmount *proc_mnt;
 int proc_fill_super(struct super_block *);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
proc-fix-stack_start-in-compat-mode.patch
uml-irq-register-race-condition.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
const-struct-quota_format_ops.patch

