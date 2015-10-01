From: akpm@linux-foundation.org
Subject: + mm-add-the-struct-mm_struct-mm-local-into.patch added to -mm
 tree
Date: Thu, 01 Oct 2015 14:49:25 -0700
Message-ID: <560daa65.iajNlqra2mUKG1Kg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbJAVt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 17:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andreyknvl@google.com, dave@stgolabs.net, hughd@google.com, kirill@shutemov.name, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add the "struct mm_struct *mm" local into
has been added to the -mm tree.  Its filename is
     mm-add-the-struct-mm_struct-mm-local-into.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-the-struct-mm_struct-mm-local-into.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-the-struct-mm_struct-mm-local-into.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch

