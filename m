From: akpm@linux-foundation.org
Subject: [merged] mm-fix-the-racy-mm-locked_vm-change-in.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:08:49 -0800
Message-ID: <563d08d1.27QjwEt/3lCptmzH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033572AbbKFUIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andreyknvl@google.com, dave@stgolabs.net, hughd@google.com, kirill@shutemov.name, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix the racy mm->locked_vm change in
has been removed from the -mm tree.  Its filename was
     mm-fix-the-racy-mm-locked_vm-change-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: fix the racy mm->locked_vm change in

"mm->locked_vm += grow" and vm_stat_account() in acct_stack_growth() are
not safe; multiple threads using the same ->mm can do this at the same
time trying to expans different vma's under down_read(mmap_sem).  This
means that one of the "locked_vm += grow" changes can be lost and we can
miss munlock_vma_pages_all() later.

Move this code into the caller(s) under mm->page_table_lock.  All other
updates to ->locked_vm hold mmap_sem for writing.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mm-fix-the-racy-mm-locked_vm-change-in mm/mmap.c
--- a/mm/mmap.c~mm-fix-the-racy-mm-locked_vm-change-in
+++ a/mm/mmap.c
@@ -2138,10 +2138,6 @@ static int acct_stack_growth(struct vm_a
 	if (security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
-	/* Ok, everything looks good - let it rip */
-	if (vma->vm_flags & VM_LOCKED)
-		mm->locked_vm += grow;
-	vm_stat_account(mm, vma->vm_flags, vma->vm_file, grow);
 	return 0;
 }
 
@@ -2202,6 +2198,10 @@ int expand_upwards(struct vm_area_struct
 				 * against concurrent vma expansions.
 				 */
 				spin_lock(&vma->vm_mm->page_table_lock);
+				if (vma->vm_flags & VM_LOCKED)
+					vma->vm_mm->locked_vm += grow;
+				vm_stat_account(vma->vm_mm, vma->vm_flags,
+						vma->vm_file, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				anon_vma_interval_tree_post_update_vma(vma);
@@ -2273,6 +2273,10 @@ int expand_downwards(struct vm_area_stru
 				 * against concurrent vma expansions.
 				 */
 				spin_lock(&vma->vm_mm->page_table_lock);
+				if (vma->vm_flags & VM_LOCKED)
+					vma->vm_mm->locked_vm += grow;
+				vm_stat_account(vma->vm_mm, vma->vm_flags,
+						vma->vm_file, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
_

Patches currently in -mm which might be from oleg@redhat.com are

proc-actually-make-proc_fd_permission-thread-friendly.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

