From: akpm@linux-foundation.org
Subject: + mm-recheck-lock-rlim-after-f_op-mmap-method.patch added to -mm tree
Date: Fri, 13 Jul 2007 01:08:16 -0700
Message-ID: <200707130808.l6D88G47007275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbXGMIJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 04:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, chris.mason@oracle.com, dmonakhov@openvz.org, herbert.van.den.bergh@oracle.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     mm: recheck lock rlim after f_op->mmap() method
has been added to the -mm tree.  Its filename is
     mm-recheck-lock-rlim-after-f_op-mmap-method.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: recheck lock rlim after f_op->mmap() method
From: Dmitry Monakhov <dmonakhov@sw.ru>

Some device drivers can change vm_flags in their f_op->mmap method.  In
order to be on the safe side we have to recheck lock rlimit.  Now we have
to check lock rlimit from two places, let's move this common code to helper
functon.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff -puN mm/mmap.c~mm-recheck-lock-rlim-after-f_op-mmap-method mm/mmap.c
--- a/mm/mmap.c~mm-recheck-lock-rlim-after-f_op-mmap-method
+++ a/mm/mmap.c
@@ -885,6 +885,18 @@ void vm_stat_account(struct mm_struct *m
 }
 #endif /* CONFIG_PROC_FS */
 
+static int check_lock_limit(unsigned long delta, struct mm_struct* mm)
+{
+	unsigned long locked, lock_limit;
+	locked = delta >> PAGE_SHIFT;
+	locked += mm->locked_vm;
+	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit >>= PAGE_SHIFT;
+	if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+		return -EAGAIN;
+	return 0;
+}
+
 /*
  * The caller must hold down_write(current->mm->mmap_sem).
  */
@@ -954,13 +966,9 @@ unsigned long do_mmap_pgoff(struct file 
 	}
 	/* mlock MCL_FUTURE? */
 	if (vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
+		error = check_lock_limit(len, mm);
+		if (error)
+			return error;
 	}
 
 	inode = file ? file->f_path.dentry->d_inode : NULL;
@@ -1101,6 +1109,17 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
+
+		if (vma->vm_flags & VM_LOCKED
+				&& !(vm_flags & VM_LOCKED)) {
+		/*
+		 * VM_LOCKED was added in f_op->mmap() method,
+		 * so we have to recheck limit.
+		 */
+			error = check_lock_limit(len, mm);
+			if (error)
+				goto unmap_and_free_vma;
+		}
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

mspec_mmap-dont-set-vm_locked.patch
mm-recheck-lock-rlim-after-f_op-mmap-method.patch
mm-recheck-lock-rlim-after-f_op-mmap-method-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
deny-partial-write-for-loop-dev-fd.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix.patch
