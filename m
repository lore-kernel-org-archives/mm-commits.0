From: akpm@linux-foundation.org
Subject: [merged] mm-add-the-struct-mm_struct-mm-local-into.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:08:52 -0800
Message-ID: <563d08d4.AWoxuHjlB4yYX9cj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033702AbbKFUIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andreyknvl@google.com, dave@stgolabs.net, hughd@google.com, kirill@shutemov.name, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add the "struct mm_struct *mm" local into
has been removed from the -mm tree.  Its filename was
     mm-add-the-struct-mm_struct-mm-local-into.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: add the "struct mm_struct *mm" local into

Cosmetic, but expand_upwards() and expand_downwards() overuse vma->vm_mm,
a local variable makes sense imho.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/mmap.c~mm-add-the-struct-mm_struct-mm-local-into mm/mmap.c
--- a/mm/mmap.c~mm-add-the-struct-mm_struct-mm-local-into
+++ a/mm/mmap.c
@@ -2148,6 +2148,7 @@ static int acct_stack_growth(struct vm_a
  */
 int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int error;
 
 	if (!(vma->vm_flags & VM_GROWSUP))
@@ -2197,10 +2198,10 @@ int expand_upwards(struct vm_area_struct
 				 * So, we reuse mm->page_table_lock to guard
 				 * against concurrent vma expansions.
 				 */
-				spin_lock(&vma->vm_mm->page_table_lock);
+				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
-					vma->vm_mm->locked_vm += grow;
-				vm_stat_account(vma->vm_mm, vma->vm_flags,
+					mm->locked_vm += grow;
+				vm_stat_account(mm, vma->vm_flags,
 						vma->vm_file, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
@@ -2208,8 +2209,8 @@ int expand_upwards(struct vm_area_struct
 				if (vma->vm_next)
 					vma_gap_update(vma->vm_next);
 				else
-					vma->vm_mm->highest_vm_end = address;
-				spin_unlock(&vma->vm_mm->page_table_lock);
+					mm->highest_vm_end = address;
+				spin_unlock(&mm->page_table_lock);
 
 				perf_event_mmap(vma);
 			}
@@ -2217,7 +2218,7 @@ int expand_upwards(struct vm_area_struct
 	}
 	vma_unlock_anon_vma(vma);
 	khugepaged_enter_vma_merge(vma, vma->vm_flags);
-	validate_mm(vma->vm_mm);
+	validate_mm(mm);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -2228,6 +2229,7 @@ int expand_upwards(struct vm_area_struct
 int expand_downwards(struct vm_area_struct *vma,
 				   unsigned long address)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int error;
 
 	/*
@@ -2272,17 +2274,17 @@ int expand_downwards(struct vm_area_stru
 				 * So, we reuse mm->page_table_lock to guard
 				 * against concurrent vma expansions.
 				 */
-				spin_lock(&vma->vm_mm->page_table_lock);
+				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
-					vma->vm_mm->locked_vm += grow;
-				vm_stat_account(vma->vm_mm, vma->vm_flags,
+					mm->locked_vm += grow;
+				vm_stat_account(mm, vma->vm_flags,
 						vma->vm_file, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				anon_vma_interval_tree_post_update_vma(vma);
 				vma_gap_update(vma);
-				spin_unlock(&vma->vm_mm->page_table_lock);
+				spin_unlock(&mm->page_table_lock);
 
 				perf_event_mmap(vma);
 			}
@@ -2290,7 +2292,7 @@ int expand_downwards(struct vm_area_stru
 	}
 	vma_unlock_anon_vma(vma);
 	khugepaged_enter_vma_merge(vma, vma->vm_flags);
-	validate_mm(vma->vm_mm);
+	validate_mm(mm);
 	return error;
 }
 
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

