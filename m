From: akpm@linux-foundation.org
Subject: + mmap_region-cleanup-the-final-vma_merge-related-code.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:54:39 -0800
Message-ID: <200802152054.m1FKsdWP023354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbYBOUzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, hugh@veritas.com, miklos@szeredi.hu


The patch titled
     mmap_region: cleanup the final vma_merge() related code
has been added to the -mm tree.  Its filename is
     mmap_region-cleanup-the-final-vma_merge-related-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap_region: cleanup the final vma_merge() related code
From: Oleg Nesterov <oleg@tv-sign.ru>

It is not easy to actually understand the "if (!file || !vma_merge())"
code, turn it into "if (file && vma_merge())".  This makes immediately
obvious that the subsequent "if (file)" is superfluous.

As Hugh Dickins pointed out, we can also factor out the ->i_writecount
corrections, and add a small comment about that.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN mm/mmap.c~mmap_region-cleanup-the-final-vma_merge-related-code mm/mmap.c
--- a/mm/mmap.c~mmap_region-cleanup-the-final-vma_merge-related-code
+++ a/mm/mmap.c
@@ -1068,7 +1068,6 @@ int vma_wants_writenotify(struct vm_area
 		mapping_cap_account_dirty(vma->vm_file->f_mapping);
 }
 
-
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, unsigned long flags,
 			  unsigned int vm_flags, unsigned long pgoff,
@@ -1181,22 +1180,20 @@ munmap_back:
 	if (vma_wants_writenotify(vma))
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
-	if (!file || !vma_merge(mm, prev, addr, vma->vm_end,
+	if (file && vma_merge(mm, prev, addr, vma->vm_end,
 			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
-		file = vma->vm_file;
-		vma_link(mm, vma, prev, rb_link, rb_parent);
-		if (correct_wcount)
-			atomic_inc(&inode->i_writecount);
-	} else {
-		if (file) {
-			if (correct_wcount)
-				atomic_inc(&inode->i_writecount);
-			fput(file);
-		}
 		mpol_free(vma_policy(vma));
 		kmem_cache_free(vm_area_cachep, vma);
+		fput(file);
+	} else {
+		vma_link(mm, vma, prev, rb_link, rb_parent);
+		file = vma->vm_file;
 	}
-out:	
+
+	/* Once vma denies write, undo our temporary denial count */
+	if (correct_wcount)
+		atomic_inc(&inode->i_writecount);
+out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
