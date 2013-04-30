From: akpm@linux-foundation.org
Subject: [merged] mm-allow-arch-code-to-control-the-user-page-table-ceiling.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:47:52 -0700
Message-ID: <20130430184752.7FC4631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36592 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3D3Srx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:47:53 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so85116vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:47:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, catalin.marinas@arm.com, linux@arm.linux.org.uk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow arch code to control the user page table ceiling
has been removed from the -mm tree.  Its filename was
     mm-allow-arch-code-to-control-the-user-page-table-ceiling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2302,7 +2302,7 @@ static void unmap_region(struct mm_struc
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : 0);
+				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, start, end);
 }
 
@@ -2682,7 +2682,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, vma, 0, -1);
 
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, 0, -1);
 
 	/*
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch

