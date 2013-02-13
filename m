From: akpm@linux-foundation.org
Subject: + mm-limit-pgd-range-freeing-to-mm-task_size.patch added to -mm tree
Date: Wed, 13 Feb 2013 13:48:09 -0800
Message-ID: <20130213214809.D22FC31C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51174 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3BMVsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 16:48:13 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so172808vbi.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 13:48:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, aarcange@redhat.com, linux@arm.linux.org.uk


The patch titled
     Subject: mm: Limit pgd range freeing to mm->task_size
has been added to the -mm tree.  Its filename is
     mm-limit-pgd-range-freeing-to-mm-task_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: Limit pgd range freeing to mm->task_size

ARM processors with LPAE enabled use 3 levels of page tables, with an
entry in the top level (pgd) covering 1GB of virtual space. Because of
the branch relocation limitations on ARM, the loadable modules are
mapped 16MB below PAGE_OFFSET, making the corresponding 1GB pgd shared
between kernel modules and user space.

Since free_pgtables() is called with ceiling == 0, free_pgd_range() (and
subsequently called functions) also frees the page table
shared between user space and kernel modules (which is normally handled
by the ARM-specific pgd_free() function).

This patch changes the ceiling argument to mm->task_size for the
free_pgtables() and free_pgd_range() function calls. We cannot use
TASK_SIZE since this macro may not be a run-time constant on 64-bit
systems supporting compat applications.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    4 ++--
 mm/mmap.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~mm-limit-pgd-range-freeing-to-mm-task_size fs/exec.c
--- a/fs/exec.c~mm-limit-pgd-range-freeing-to-mm-task_size
+++ a/fs/exec.c
@@ -613,7 +613,7 @@ static int shift_arg_pages(struct vm_are
 		 * when the old and new regions overlap clear from new_end.
 		 */
 		free_pgd_range(&tlb, new_end, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : mm->task_size);
 	} else {
 		/*
 		 * otherwise, clean from old_start; this is done to not touch
@@ -622,7 +622,7 @@ static int shift_arg_pages(struct vm_are
 		 * for the others its just a little faster.
 		 */
 		free_pgd_range(&tlb, old_start, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : mm->task_size);
 	}
 	tlb_finish_mmu(&tlb, new_end, old_end);
 
diff -puN mm/mmap.c~mm-limit-pgd-range-freeing-to-mm-task_size mm/mmap.c
--- a/mm/mmap.c~mm-limit-pgd-range-freeing-to-mm-task_size
+++ a/mm/mmap.c
@@ -2253,7 +2253,7 @@ static void unmap_region(struct mm_struc
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : 0);
+				 next ? next->vm_start : mm->task_size);
 	tlb_finish_mmu(&tlb, start, end);
 }
 
@@ -2627,7 +2627,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, vma, 0, -1);
 
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, mm->task_size);
 	tlb_finish_mmu(&tlb, 0, -1);
 
 	/*
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
mm-add-section_in_page_flags.patch
mm-add-use-zone_end_pfn-and-zone_spans_pfn.patch
mm-add-zone_is_empty-and-zone_is_initialized.patch
mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch
mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
mm-add-helper-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-ensure_zone_is_initialized.patch
mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch
mm-limit-pgd-range-freeing-to-mm-task_size.patch

