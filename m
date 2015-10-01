From: akpm@linux-foundation.org
Subject: + mm-fix-the-racy-mm-locked_vm-change-in.patch added to -mm tree
Date: Thu, 01 Oct 2015 14:49:23 -0700
Message-ID: <560daa63.AdMAE8iyEhuoqM1y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbJAVtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 17:49:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andreyknvl@google.com, dave@stgolabs.net, hughd@google.com, kirill@shutemov.name, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix the racy mm->locked_vm change in
has been added to the -mm tree.  Its filename is
     mm-fix-the-racy-mm-locked_vm-change-in.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-the-racy-mm-locked_vm-change-in.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-the-racy-mm-locked_vm-change-in.patch

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

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch

