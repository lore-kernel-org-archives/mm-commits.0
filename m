From: akpm@linux-foundation.org
Subject: + fix-race-between-proc_get_inode-and-remove_proc_entry.patch added to -mm tree
Date: Wed, 07 Mar 2007 12:49:49 -0800
Message-ID: <200703072049.l27Knnwr008253@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56287 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992560AbXCGUuI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 15:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     Fix race between proc_get_inode() and remove_proc_entry()
has been added to the -mm tree.  Its filename is
     fix-race-between-proc_get_inode-and-remove_proc_entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix race between proc_get_inode() and remove_proc_entry()
From: Alexey Dobriyan <adobriyan@openvz.org>

proc_lookup				remove_proc_entry
===========				=================

lock_kernel();
spin_lock(&proc_subdir_lock);
[find PDE with refcount 0]
spin_unlock(&proc_subdir_lock);
					spin_lock(&proc_subdir_lock);
					[find PDE with refcount 0]
					[check refcount and free PDE]
					spin_unlock(&proc_subdir_lock);
proc_get_inode:
	de_get(de); /* boom */

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    2 ++
 fs/proc/inode.c         |   12 ++++--------
 include/linux/proc_fs.h |    3 +++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/proc/generic.c~fix-race-between-proc_get_inode-and-remove_proc_entry fs/proc/generic.c
--- a/fs/proc/generic.c~fix-race-between-proc_get_inode-and-remove_proc_entry
+++ a/fs/proc/generic.c
@@ -398,6 +398,7 @@ struct dentry *proc_lookup(struct inode 
 			if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
 				unsigned int ino = de->low_ino;
 
+				de_get(de);
 				spin_unlock(&proc_subdir_lock);
 				error = -EINVAL;
 				inode = proc_get_inode(dir->i_sb, ino, de);
@@ -414,6 +415,7 @@ struct dentry *proc_lookup(struct inode 
 		d_add(dentry, inode);
 		return NULL;
 	}
+	de_put(de);
 	return ERR_PTR(error);
 }
 
diff -puN fs/proc/inode.c~fix-race-between-proc_get_inode-and-remove_proc_entry fs/proc/inode.c
--- a/fs/proc/inode.c~fix-race-between-proc_get_inode-and-remove_proc_entry
+++ a/fs/proc/inode.c
@@ -21,7 +21,7 @@
 
 #include "internal.h"
 
-static inline struct proc_dir_entry * de_get(struct proc_dir_entry *de)
+struct proc_dir_entry *de_get(struct proc_dir_entry *de)
 {
 	if (de)
 		atomic_inc(&de->count);
@@ -31,7 +31,7 @@ static inline struct proc_dir_entry * de
 /*
  * Decrements the use count and checks for deferred deletion.
  */
-static void de_put(struct proc_dir_entry *de)
+void de_put(struct proc_dir_entry *de)
 {
 	if (de) {	
 		lock_kernel();		
@@ -147,11 +147,6 @@ struct inode *proc_get_inode(struct supe
 {
 	struct inode * inode;
 
-	/*
-	 * Increment the use count so the dir entry can't disappear.
-	 */
-	de_get(de);
-
 	WARN_ON(de && de->deleted);
 
 	if (de != NULL && !try_module_get(de->owner))
@@ -185,7 +180,6 @@ out_ino:
 	if (de != NULL)
 		module_put(de->owner);
 out_mod:
-	de_put(de);
 	return NULL;
 }			
 
@@ -200,6 +194,7 @@ int proc_fill_super(struct super_block *
 	s->s_op = &proc_sops;
 	s->s_time_gran = 1;
 	
+	de_get(&proc_root);
 	root_inode = proc_get_inode(s, PROC_ROOT_INO, &proc_root);
 	if (!root_inode)
 		goto out_no_root;
@@ -213,6 +208,7 @@ int proc_fill_super(struct super_block *
 out_no_root:
 	printk("proc_read_super: get root inode failed\n");
 	iput(root_inode);
+	de_put(&proc_root);
 	return -ENOMEM;
 }
 MODULE_LICENSE("GPL");
diff -puN include/linux/proc_fs.h~fix-race-between-proc_get_inode-and-remove_proc_entry include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~fix-race-between-proc_get_inode-and-remove_proc_entry
+++ a/include/linux/proc_fs.h
@@ -106,6 +106,9 @@ int task_statm(struct mm_struct *, int *
 char *task_mem(struct mm_struct *, char *);
 void clear_refs_smap(struct mm_struct *mm);
 
+struct proc_dir_entry *de_get(struct proc_dir_entry *de);
+void de_put(struct proc_dir_entry *de);
+
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
 extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
_

Patches currently in -mm which might be from adobriyan@openvz.org are

git-parisc.patch
x86_64-wire-up-compat-sched_rr_get_interval2.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
