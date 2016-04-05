From: akpm@linux-foundation.org
Subject: + huge-mm-move_huge_pmd-does-not-need-new_vma.patch added to -mm
 tree
Date: Tue, 05 Apr 2016 15:53:59 -0700
Message-ID: <57044207.BmzGaLYr2UNnkLDy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbcDEWyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 18:54:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@techsingularity.net, quning@gmail.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge mm: move_huge_pmd does not need new_vma
has been added to the -mm tree.  Its filename is
     huge-mm-move_huge_pmd-does-not-need-new_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-mm-move_huge_pmd-does-not-need-new_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-mm-move_huge_pmd-does-not-need-new_vma.patch

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
Subject: huge mm: move_huge_pmd does not need new_vma

Remove move_huge_pmd()'s redundant new_vma arg: all it was used for was a
VM_NOHUGEPAGE check on new_vma flags, but the new_vma is cloned from the
old vma, so a trans_huge_pmd in the new_vma will be as acceptable as it
was in the old vma, alignment and size permitting.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 +---
 mm/huge_memory.c        |    7 ++-----
 mm/mremap.c             |    5 ++---
 3 files changed, 5 insertions(+), 11 deletions(-)

diff -puN include/linux/huge_mm.h~huge-mm-move_huge_pmd-does-not-need-new_vma include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~huge-mm-move_huge_pmd-does-not-need-new_vma
+++ a/include/linux/huge_mm.h
@@ -28,9 +28,7 @@ extern int zap_huge_pmd(struct mmu_gathe
 extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
 			unsigned char *vec);
-extern bool move_huge_pmd(struct vm_area_struct *vma,
-			 struct vm_area_struct *new_vma,
-			 unsigned long old_addr,
+extern bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			 unsigned long new_addr, unsigned long old_end,
 			 pmd_t *old_pmd, pmd_t *new_pmd);
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
diff -puN mm/huge_memory.c~huge-mm-move_huge_pmd-does-not-need-new_vma mm/huge_memory.c
--- a/mm/huge_memory.c~huge-mm-move_huge_pmd-does-not-need-new_vma
+++ a/mm/huge_memory.c
@@ -1704,20 +1704,17 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	return 1;
 }
 
-bool move_huge_pmd(struct vm_area_struct *vma, struct vm_area_struct *new_vma,
-		  unsigned long old_addr,
+bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, unsigned long old_end,
 		  pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	spinlock_t *old_ptl, *new_ptl;
 	pmd_t pmd;
-
 	struct mm_struct *mm = vma->vm_mm;
 
 	if ((old_addr & ~HPAGE_PMD_MASK) ||
 	    (new_addr & ~HPAGE_PMD_MASK) ||
-	    old_end - old_addr < HPAGE_PMD_SIZE ||
-	    (new_vma->vm_flags & VM_NOHUGEPAGE))
+	    old_end - old_addr < HPAGE_PMD_SIZE)
 		return false;
 
 	/*
diff -puN mm/mremap.c~huge-mm-move_huge_pmd-does-not-need-new_vma mm/mremap.c
--- a/mm/mremap.c~huge-mm-move_huge_pmd-does-not-need-new_vma
+++ a/mm/mremap.c
@@ -198,9 +198,8 @@ unsigned long move_page_tables(struct vm
 				/* See comment in move_ptes() */
 				if (need_rmap_locks)
 					anon_vma_lock_write(vma->anon_vma);
-				moved = move_huge_pmd(vma, new_vma, old_addr,
-						    new_addr, old_end,
-						    old_pmd, new_pmd);
+				moved = move_huge_pmd(vma, old_addr, new_addr,
+						    old_end, old_pmd, new_pmd);
 				if (need_rmap_locks)
 					anon_vma_unlock_write(vma->anon_vma);
 				if (moved) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch

