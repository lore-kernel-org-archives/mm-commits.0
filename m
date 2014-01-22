From: akpm@linux-foundation.org
Subject: [merged] mm-mlock-prepare-params-outside-critical-region.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:56 -0800
Message-ID: <52e02648.wXZe6Vjg+4h0coLy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz, riel@redhat.com, davidlohr@hp.com

Subject: [merged] mm-mlock-prepare-params-outside-critical-region.patch removed from -mm tree
To: davidlohr@hp.com,riel@redhat.com,vbabka@suse.cz,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:56 -0800


The patch titled
     Subject: mm/mlock: prepare params outside critical region
has been removed from the -mm tree.  Its filename was
     mm-mlock-prepare-params-outside-critical-region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm/mlock: prepare params outside critical region

All mlock related syscalls prepare lock limits, lengths and start
parameters with the mmap_sem held.  Move this logic outside of the
critical region.  For the case of mlock, continue incrementing the amount
already locked by mm->locked_vm with the rwsem taken.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/mlock.c~mm-mlock-prepare-params-outside-critical-region mm/mlock.c
--- a/mm/mlock.c~mm-mlock-prepare-params-outside-critical-region
+++ a/mm/mlock.c
@@ -709,19 +709,21 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 
 	lru_add_drain_all();	/* flush pagevec */
 
-	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
 
-	locked = len >> PAGE_SHIFT;
-	locked += current->mm->locked_vm;
-
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
+	locked = len >> PAGE_SHIFT;
+
+	down_write(&current->mm->mmap_sem);
+
+	locked += current->mm->locked_vm;
 
 	/* check against resource limits */
 	if ((locked <= lock_limit) || capable(CAP_IPC_LOCK))
 		error = do_mlock(start, len, 1);
+
 	up_write(&current->mm->mmap_sem);
 	if (!error)
 		error = __mm_populate(start, len, 0);
@@ -732,11 +734,13 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 {
 	int ret;
 
-	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
+
+	down_write(&current->mm->mmap_sem);
 	ret = do_mlock(start, len, 0);
 	up_write(&current->mm->mmap_sem);
+
 	return ret;
 }
 
@@ -781,12 +785,12 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (flags & MCL_CURRENT)
 		lru_add_drain_all();	/* flush pagevec */
 
-	down_write(&current->mm->mmap_sem);
-
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 
 	ret = -ENOMEM;
+	down_write(&current->mm->mmap_sem);
+
 	if (!(flags & MCL_CURRENT) || (current->mm->total_vm <= lock_limit) ||
 	    capable(CAP_IPC_LOCK))
 		ret = do_mlockall(flags);
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

