From: akpm@linux-foundation.org
Subject: + mm-allow-arch-code-to-control-the-user-page-table-ceiling.patch added to -mm tree
Date: Tue, 19 Mar 2013 14:14:02 -0700
Message-ID: <20130319211402.DF2255A4225__48775.903232354$1363727679$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62263 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933980Ab3CSVOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 17:14:05 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so101909qaj.3
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 14:14:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, catalin.marinas@arm.com, linux@arm.linux.org.uk, stable@vger.kernel.org


The patch titled
     Subject: mm: allow arch code to control the user page table ceiling
has been added to the -mm tree.  Its filename is
     mm-allow-arch-code-to-control-the-user-page-table-ceiling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: allow arch code to control the user page table ceiling

On architectures where a pgd entry may be shared between user and kernel
(e.g.  ARM+LPAE), freeing page tables needs a ceiling other than 0.  This
patch introduces a generic USER_PGTABLES_CEILING that arch code can
override.  It is the responsibility of the arch code setting the ceiling
to ensure the complete freeing of the page tables (usually in pgd_free()).

[catalin.marinas@arm.com: commit log; shift_arg_pages(), asm-generic/pgtables.h changes]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: <stable@vger.kernel.org>	[3.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                     |    4 ++--
 include/asm-generic/pgtable.h |   10 ++++++++++
 mm/mmap.c                     |    4 ++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~mm-allow-arch-code-to-control-the-user-page-table-ceiling fs/exec.c
--- a/fs/exec.c~mm-allow-arch-code-to-control-the-user-page-table-ceiling
+++ a/fs/exec.c
@@ -613,7 +613,7 @@ static int shift_arg_pages(struct vm_are
 		 * when the old and new regions overlap clear from new_end.
 		 */
 		free_pgd_range(&tlb, new_end, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	} else {
 		/*
 		 * otherwise, clean from old_start; this is done to not touch
@@ -622,7 +622,7 @@ static int shift_arg_pages(struct vm_are
 		 * for the others its just a little faster.
 		 */
 		free_pgd_range(&tlb, old_start, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	}
 	tlb_finish_mmu(&tlb, new_end, old_end);
 
diff -puN include/asm-generic/pgtable.h~mm-allow-arch-code-to-control-the-user-page-table-ceiling include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-allow-arch-code-to-control-the-user-page-table-ceiling
+++ a/include/asm-generic/pgtable.h
@@ -7,6 +7,16 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 
+/*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
diff -puN mm/mmap.c~mm-allow-arch-code-to-control-the-user-page-table-ceiling mm/mmap.c
--- a/mm/mmap.c~mm-allow-arch-code-to-control-the-user-page-table-ceiling
+++ a/mm/mmap.c
@@ -2300,7 +2300,7 @@ static void unmap_region(struct mm_struc
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : 0);
+				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, start, end);
 }
 
@@ -2680,7 +2680,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, vma, 0, -1);
 
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, 0, -1);
 
 	/*
_

Patches currently in -mm which might be from hughd@google.com are

mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch
mm-shmemc-remove-an-ifdef.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-allow-arch-code-to-control-the-user-page-table-ceiling.patch
arm-set-the-page-table-freeing-ceiling-to-task_size.patch

