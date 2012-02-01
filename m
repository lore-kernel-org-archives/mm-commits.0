From: akpm@linux-foundation.org
Subject: + hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch added to -mm tree
Date: Wed, 01 Feb 2012 14:45:44 -0800
Message-ID: <20120201224545.1E437A03A7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:49105 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2BAWpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 17:45:47 -0500
Received: by wgbds12 with SMTP id ds12so60680wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 14:45:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mingo@redhat.com, tglx@linutronix.de


The patch titled
     Subject: hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown()
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
Subject: hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown()

After the call find_vma_prev(mm, addr, &prev_vma), the following condition
is always true:

	!prev_vma || (addr >= prev_vma->vm_end)

it can happily drop prev_vma and use find_vma() instead of find_vma_prev().

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown
+++ a/arch/x86/mm/hugetlbpage.c
@@ -308,7 +308,7 @@ static unsigned long hugetlb_get_unmappe
 {
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev_vma;
+	struct vm_area_struct *vma;
 	unsigned long base = mm->mmap_base, addr = addr0;
 	unsigned long largest_hole = mm->cached_hole_size;
 	int first_time = 1;
@@ -333,24 +333,15 @@ try_again:
 		 * Lookup failure means no vma is above this address,
 		 * i.e. return with success:
 		 */
-		if (!(vma = find_vma_prev(mm, addr, &prev_vma)))
-			return addr;
-
-		/*
-		 * new region fits between prev_vma->vm_end and
-		 * vma->vm_start, use it:
-		 */
-		if (addr + len <= vma->vm_start &&
-		            (!prev_vma || (addr >= prev_vma->vm_end))) {
+		vma = find_vma(mm, addr);
+		if (!vma || addr + len <= vma->vm_start) {
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
Subject: Subject: hugetlb: drop prev_vma in hugetlb_get_unmapped_area_topdown()

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch

