From: akpm@linux-foundation.org
Subject: - revoke-core-code-break-cow-for-private-mappings.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:51 -0700
Message-ID: <200705090955.l499tpXS020530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757225AbXEIJz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke: break cow for private mappings
has been removed from the -mm tree.  Its filename was
     revoke-core-code-break-cow-for-private-mappings.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: revoke: break cow for private mappings
From: Pekka Enberg <penberg@cs.helsinki.fi>

We need to break COW for private mappings to make sure a process cannot
read new data after an inode has been revoked.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |   85 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 73 insertions(+), 12 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-break-cow-for-private-mappings fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-break-cow-for-private-mappings
+++ a/fs/revoke.c
@@ -175,12 +175,58 @@ static inline bool need_revoke(struct vm
 	if (file->f_path.dentry->d_inode != inode)
 		return false;
 
-	if (!(vma->vm_flags & VM_SHARED))
-		return false;
-
 	return file != to_exclude;
 }
 
+static int __revoke_break_cow(struct task_struct *tsk, struct inode *inode,
+			      struct file *to_exclude)
+{
+	struct mm_struct *mm = tsk->mm;
+	struct vm_area_struct *vma;
+	int err = 0;
+
+	down_write(&mm->mmap_sem);
+	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		int ret;
+
+		if (vma->vm_flags & VM_SHARED)
+			continue;
+
+		if (!need_revoke(vma, inode, to_exclude))
+			continue;
+
+		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
+				     vma->vm_end-vma->vm_start, 1, 1, NULL,
+				     NULL);
+		if (ret < 0) {
+			err = ret;
+			break;
+		}
+	}
+	up_write(&mm->mmap_sem);
+	return err;
+}
+
+static int revoke_break_cow(struct revoke_table *table, struct inode *inode,
+			    struct file *to_exclude)
+{
+	unsigned long i;
+	int err = 0;
+
+	for (i = 0; i < table->end; i++) {
+		struct revokefs_inode_info *info;
+		struct file *this;
+
+		this = table->files[i];
+		info = revokefs_i(this->f_dentry->d_inode);
+
+		err = __revoke_break_cow(info->owner, inode, to_exclude);
+		if (err)
+			break;
+	}
+	return err;
+}
+
 /*
  *	 LOCKING: down_write(&mm->mmap_sem)
  *	 	    -> spin_lock(&mapping->i_mmap_lock)
@@ -236,6 +282,9 @@ static int revoke_mm(struct mm_struct *m
 		goto out;
 	}
 	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
+		if (!(vma->vm_flags & VM_SHARED))
+			continue;
+
 		if (!need_revoke(vma, mapping->host, to_exclude))
 			continue;
 
@@ -262,6 +311,9 @@ static void revoke_mapping_tree(struct a
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
 		int err;
 
+		if (!(vma->vm_flags & VM_SHARED))
+			continue;
+
 		if (likely(!need_revoke(vma, mapping->host, to_exclude)))
 			continue;
 
@@ -381,12 +433,9 @@ static int revoke_files(struct revoke_ta
 		put_task_struct(info->owner);
 		info->owner = NULL;	/* To avoid restoring closed file. */
 		if (err)
-			goto failed;
+			goto out;
 	}
-	return 0;
-
-  failed:
-	restore_files(table);
+  out:
 	return err;
 }
 
@@ -528,10 +577,8 @@ static int do_revoke(struct inode *inode
   exit_loop:
 	read_unlock(&tasklist_lock);
 
-	if (err) {
-		restore_files(table);
-		goto out_free_table;
-	}
+	if (err)
+		goto out_restore;
 
 	/*
 	 * Take down shared memory mappings.
@@ -539,13 +586,27 @@ static int do_revoke(struct inode *inode
 	revoke_mapping(inode->i_mapping, to_exclude);
 
 	/*
+ 	 * Break COW for private mappings.
+ 	 */
+	err = revoke_break_cow(table, inode, to_exclude);
+	if (err)
+		goto out_restore;
+
+	/*
 	 * Now, revoke the files for good.
 	 */
 	err = revoke_files(table);
+	if (err)
+		goto out_restore;
+
   out_free_table:
 	free_revoke_table(table);
   out:
 	return err;
+
+  out_restore:
+	restore_files(table);
+	goto out_free_table;
 }
 
 asmlinkage long sys_revokeat(int dfd, const char __user * filename)
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-break-cow-for-private-mappings.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
revoke-core-code-break-cow-fixes.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
