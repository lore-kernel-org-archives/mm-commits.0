From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-add-mlock_future_check-helper.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:12:54 -0800
Message-ID: <52e02646.cb/odpJAW227Ygi4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbaAVUMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, riel@redhat.com, davidlohr@hp.com

Subject: [merged] mm-mmapc-add-mlock_future_check-helper.patch removed from -mm tree
To: davidlohr@hp.com,riel@redhat.com,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:54 -0800


The patch titled
     Subject: mm/mmap.c: add mlock_future_check() helper
has been removed from the -mm tree.  Its filename was
     mm-mmapc-add-mlock_future_check-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm/mmap.c: add mlock_future_check() helper

Both do_brk and do_mmap_pgoff verify that we are actually capable of
locking future pages if the corresponding VM_LOCKED flags are used. 
Encapsulate this logic into a single mlock_future_check() helper function.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-add-mlock_future_check-helper mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-add-mlock_future_check-helper
+++ a/mm/mmap.c
@@ -1191,6 +1191,24 @@ static inline unsigned long round_hint_t
 	return hint;
 }
 
+static inline int mlock_future_check(struct mm_struct *mm,
+				     unsigned long flags,
+				     unsigned long len)
+{
+	unsigned long locked, lock_limit;
+
+	/*  mlock MCL_FUTURE? */
+	if (flags & VM_LOCKED) {
+		locked = len >> PAGE_SHIFT;
+		locked += mm->locked_vm;
+		lock_limit = rlimit(RLIMIT_MEMLOCK);
+		lock_limit >>= PAGE_SHIFT;
+		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
+			return -EAGAIN;
+	}
+	return 0;
+}
+
 /*
  * The caller must hold down_write(&current->mm->mmap_sem).
  */
@@ -1252,16 +1270,8 @@ unsigned long do_mmap_pgoff(struct file
 		if (!can_do_mlock())
 			return -EPERM;
 
-	/* mlock MCL_FUTURE? */
-	if (vm_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
-	}
+	if (mlock_future_check(mm, vm_flags, len))
+		return -EAGAIN;
 
 	if (file) {
 		struct inode *inode = file_inode(file);
@@ -2592,18 +2602,9 @@ static unsigned long do_brk(unsigned lon
 	if (error & ~PAGE_MASK)
 		return error;
 
-	/*
-	 * mlock MCL_FUTURE?
-	 */
-	if (mm->def_flags & VM_LOCKED) {
-		unsigned long locked, lock_limit;
-		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
-		lock_limit = rlimit(RLIMIT_MEMLOCK);
-		lock_limit >>= PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			return -EAGAIN;
-	}
+	error = mlock_future_check(mm, mm->def_flags, len);
+	if (error)
+		return error;
 
 	/*
 	 * mm->mmap_sem is required to protect against another thread
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch
ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch
ipc-change-kern_ipc_permdeleted-type-to-bool.patch
ipc-whitespace-cleanup.patch
ipc-standardize-code-comments.patch
ipc-remove-braces-for-single-statements.patch
ipc-remove-useless-return-statement.patch
ipc-simplify-sysvipc_proc_open-return.patch
ipc-delete-seq_max-field-in-struct-ipc_ids.patch
ipcmsg-document-barriers.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
ipc-fix-compat-msgrcv-with-negative-msgtyp.patch

