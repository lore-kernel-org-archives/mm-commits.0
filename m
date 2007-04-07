From: akpm@linux-foundation.org
Subject: + split-mmap.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:42:04 -0700
Message-ID: <200704070542.l375g432028450@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45390 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417AbXDGFmN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, a.p.zijlstra@chello.nl


The patch titled
     split mmap
has been added to the -mm tree.  Its filename is
     split-mmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 mm/mmap.c          |   27 ++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~split-mmap include/linux/mm.h
--- a/include/linux/mm.h~split-mmap
+++ a/include/linux/mm.h
@@ -1075,6 +1075,10 @@ extern unsigned long get_unmapped_area(s
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
@@ -893,14 +893,11 @@ unsigned long do_mmap_pgoff(struct file 
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
@@ -1025,7 +1022,25 @@ unsigned long do_mmap_pgoff(struct file 
 	error = security_file_mmap(file, reqprot, prot, flags);
 	if (error)
 		return error;
-		
+
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
@@ -1170,8 +1185,6 @@ unacct_error:
 	return error;
 }
 
-EXPORT_SYMBOL(do_mmap_pgoff);
-
 /* Get an address range which is currently unmapped.
  * For shmat() with addr=0.
  *
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-validate-rootmode-mount-option.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
add-file-position-info-to-proc-fix.patch
consolidate-generic_writepages-and-mpage_writepages.patch
