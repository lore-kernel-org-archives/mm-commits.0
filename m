From: akpm@linux-foundation.org
Subject: + hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch added to -mm tree
Date: Thu, 08 Mar 2012 13:24:19 -0800
Message-ID: <20120308212419.91A4AA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:56800 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2CHVYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 16:24:21 -0500
Received: by eaaq10 with SMTP id q10so32848eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 13:24:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: hugetlb: remove prev_vma from hugetlb_get_unmapped_area_topdown()
has been added to the -mm tree.  Its filename is
     hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: hugetlb: remove prev_vma from hugetlb_get_unmapped_area_topdown()

After looking up the vma which covers or follows the cached search
address, the following condition is always true:

	!prev_vma || (addr >= prev_vma->vm_end)

so we can stop checking the previous VMA altogether.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown
+++ a/arch/x86/mm/hugetlbpage.c
@@ -308,7 +308,7 @@ static unsigned long hugetlb_get_unmappe
 {
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev_vma;
+	struct vm_area_struct *vma;
 	unsigned long base = mm->mmap_base;
 	unsigned long addr = addr0;
 	unsigned long largest_hole = mm->cached_hole_size;
@@ -340,22 +340,14 @@ try_again:
 		if (!vma)
 			return addr;
 
-		/*
-		 * new region fits between prev_vma->vm_end and
-		 * vma->vm_start, use it:
-		 */
-		prev_vma = vma->vm_prev;
-		if (addr + len <= vma->vm_start &&
-		            (!prev_vma || (addr >= prev_vma->vm_end))) {
+		if (addr + len <= vma->vm_start) {
 			/* remember the address as a hint for next time */
 		        mm->cached_hole_size = largest_hole;
 		        return (mm->free_area_cache = addr);
-		} else {
+		} else if (mm->free_area_cache == vma->vm_end) {
 			/* pull free_area_cache down to the first hole */
-		        if (mm->free_area_cache == vma->vm_end) {
-				mm->free_area_cache = vma->vm_start;
-				mm->cached_hole_size = largest_hole;
-			}
+			mm->free_area_cache = vma->vm_start;
+			mm->cached_hole_size = largest_hole;
 		}
 
 		/* remember the largest hole we saw so far */
_
Subject: Subject: hugetlb: remove prev_vma from hugetlb_get_unmapped_area_topdown()

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
rmap-remove-__anon_vma_link.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch
prio_tree-cleanup-prio_tree_left-prio_tree_right.patch
prio_tree-simplify-prio_tree_expand.patch
prio_tree-introduce-prio_set_parent.patch

