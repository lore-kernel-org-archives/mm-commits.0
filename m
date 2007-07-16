From: akpm@linux-foundation.org
Subject: - split-mmap.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:00 -0700
Message-ID: <200707162050.l6GKo0tn001210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759616AbXGPV1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:27:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     split mmap
has been removed from the -mm tree.  Its filename was
     split-mmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: split mmap
From: Miklos Szeredi <mszeredi@suse.cz>

This is a straightforward split of do_mmap_pgoff() into two functions:

 - do_mmap_pgoff() checks the parameters, and calculates the vma
   flags.  Then it calls

 - mmap_region(), which does the actual mapping

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++++
 mm/mmap.c          |   25 +++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~split-mmap include/linux/mm.h
--- a/include/linux/mm.h~split-mmap
+++ a/include/linux/mm.h
@@ -1071,6 +1071,10 @@ extern unsigned long get_unmapped_area(s
 extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long pgoff);
+extern unsigned long mmap_region(struct file *file, unsigned long addr,
+	unsigned long len, unsigned long flags,
+	unsigned int vm_flags, unsigned long pgoff,
+	int accountable);
 
 static inline unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
diff -puN mm/mmap.c~split-mmap mm/mmap.c
--- a/mm/mmap.c~split-mmap
+++ a/mm/mmap.c
@@ -894,14 +894,11 @@ unsigned long do_mmap_pgoff(struct file 
 			unsigned long flags, unsigned long pgoff)
 {
 	struct mm_struct * mm = current->mm;
-	struct vm_area_struct * vma, * prev;
 	struct inode *inode;
 	unsigned int vm_flags;
-	int correct_wcount = 0;
 	int error;
-	struct rb_node ** rb_link, * rb_parent;
 	int accountable = 1;
-	unsigned long charged = 0, reqprot = prot;
+	unsigned long reqprot = prot;
 
 	/*
 	 * Does the application expect PROT_READ to imply PROT_EXEC?
@@ -1027,6 +1024,24 @@ unsigned long do_mmap_pgoff(struct file 
 	if (error)
 		return error;
 
+	return mmap_region(file, addr, len, flags, vm_flags, pgoff,
+			   accountable);
+}
+EXPORT_SYMBOL(do_mmap_pgoff);
+
+unsigned long mmap_region(struct file *file, unsigned long addr,
+			  unsigned long len, unsigned long flags,
+			  unsigned int vm_flags, unsigned long pgoff,
+			  int accountable)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
+	int correct_wcount = 0;
+	int error;
+	struct rb_node **rb_link, *rb_parent;
+	unsigned long charged = 0;
+	struct inode *inode =  file ? file->f_path.dentry->d_inode : NULL;
+
 	/* Clear old maps */
 	error = -ENOMEM;
 munmap_back:
@@ -1175,8 +1190,6 @@ unacct_error:
 	return error;
 }
 
-EXPORT_SYMBOL(do_mmap_pgoff);
-
 /* Get an address range which is currently unmapped.
  * For shmat() with addr=0.
  *
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
fuse-convert-to-new-aops.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
