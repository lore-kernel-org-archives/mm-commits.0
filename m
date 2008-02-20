From: akpm@linux-foundation.org
Subject: + procfs-task-exe-symlink-fix-2.patch added to -mm tree
Date: Wed, 20 Feb 2008 01:46:26 -0800
Message-ID: <200802200947.m1K9lMKX027100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759051AbYBTJsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Feb 2008 04:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthltc@us.ibm.com, dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de, hugh@veritas.com, oleg@tv-sign.ru, vapier.adi@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     fix nommu path broken by procfs task exe symlink
has been added to the -mm tree.  Its filename is
     procfs-task-exe-symlink-fix-2.patch

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
Subject: fix nommu path broken by procfs task exe symlink
From: Matt Helsley <matthltc@us.ibm.com>

nommu configurations will not compile because the "mm" variable does not
exist.  Replace usage of the mm variable and the empty vma->vm_mm field
with correct mm pointers.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/nommu.c~procfs-task-exe-symlink-fix-2 mm/nommu.c
--- a/mm/nommu.c~procfs-task-exe-symlink-fix-2
+++ a/mm/nommu.c
@@ -964,8 +964,10 @@ unsigned long do_mmap_pgoff(struct file 
 	atomic_set(&vma->vm_usage, 1);
 	if (file) {
 		get_file(file);
-		if (vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
+		if (vm_flags & VM_EXECUTABLE) {
+			added_exe_file_vma(current->mm);
+			vma->vm_mm = current->mm;
+		}
 	}
 	vma->vm_file	= file;
 	vma->vm_flags	= vm_flags;
@@ -1055,7 +1057,7 @@ EXPORT_SYMBOL(do_mmap_pgoff);
 /*
  * handle mapping disposal for uClinux
  */
-static void put_vma(struct vm_area_struct *vma)
+static void put_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	if (vma) {
 		down_write(&nommu_vma_sem);
@@ -1080,7 +1082,7 @@ static void put_vma(struct vm_area_struc
 			if (vma->vm_file) {
 				fput(vma->vm_file);
 				if (vma->vm_flags & VM_EXECUTABLE)
-					removed_exe_file_vma(vma->vm_mm);
+					removed_exe_file_vma(mm);
 			}
 			kfree(vma);
 		}
@@ -1118,7 +1120,7 @@ int do_munmap(struct mm_struct *mm, unsi
  found:
 	vml = *parent;
 
-	put_vma(vml->vma);
+	put_vma(mm, vml->vma);
 
 	*parent = vml->next;
 	realalloc -= kobjsize(vml);
@@ -1163,7 +1165,7 @@ void exit_mmap(struct mm_struct * mm)
 
 		while ((tmp = mm->context.vmlist)) {
 			mm->context.vmlist = tmp->next;
-			put_vma(tmp->vma);
+			put_vma(mm, tmp->vma);
 
 			realalloc -= kobjsize(tmp);
 			askedalloc -= sizeof(*tmp);
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
