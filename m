From: akpm@linux-foundation.org
Subject: + mm-support-madvisemadv_free-fix-5.patch added to -mm tree
Date: Mon, 19 Oct 2015 14:32:00 -0700
Message-ID: <56256150.HU/r8JjHYIV0lzf3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbJSVcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 17:32:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: MADV_FREE trivial clean up
has been added to the -mm tree.  Its filename is
     mm-support-madvisemadv_free-fix-5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-madvisemadv_free-fix-5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-madvisemadv_free-fix-5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: MADV_FREE trivial clean up

1. Page table waker already pass the vma it is processing
so we don't need to pass vma.

2. If page table entry is dirty in try_to_unmap_one, the dirtiness
should propagate to PG_dirty of the page. So, it's enough to check
only PageDirty without other pte dirty bit checking.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   17 +++--------------
 mm/rmap.c    |    6 ++----
 2 files changed, 5 insertions(+), 18 deletions(-)

diff -puN mm/madvise.c~mm-support-madvisemadv_free-fix-5 mm/madvise.c
--- a/mm/madvise.c~mm-support-madvisemadv_free-fix-5
+++ a/mm/madvise.c
@@ -24,11 +24,6 @@
 
 #include <asm/tlb.h>
 
-struct madvise_free_private {
-	struct vm_area_struct *vma;
-	struct mmu_gather *tlb;
-};
-
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
  * take mmap_sem for writing. Others, which simply traverse vmas, need
@@ -269,10 +264,9 @@ static int madvise_free_pte_range(pmd_t
 				unsigned long end, struct mm_walk *walk)
 
 {
-	struct madvise_free_private *fp = walk->private;
-	struct mmu_gather *tlb = fp->tlb;
+	struct mmu_gather *tlb = walk->private;
 	struct mm_struct *mm = tlb->mm;
-	struct vm_area_struct *vma = fp->vma;
+	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
 	pte_t *pte, ptent;
 	struct page *page;
@@ -329,15 +323,10 @@ static void madvise_free_page_range(stru
 			     struct vm_area_struct *vma,
 			     unsigned long addr, unsigned long end)
 {
-	struct madvise_free_private fp = {
-		.vma = vma,
-		.tlb = tlb,
-	};
-
 	struct mm_walk free_walk = {
 		.pmd_entry = madvise_free_pte_range,
 		.mm = vma->vm_mm,
-		.private = &fp,
+		.private = tlb,
 	};
 
 	BUG_ON(addr >= end);
diff -puN mm/rmap.c~mm-support-madvisemadv_free-fix-5 mm/rmap.c
--- a/mm/rmap.c~mm-support-madvisemadv_free-fix-5
+++ a/mm/rmap.c
@@ -1376,7 +1376,6 @@ static int try_to_unmap_one(struct page
 	spinlock_t *ptl;
 	int ret = SWAP_AGAIN;
 	enum ttu_flags flags = (enum ttu_flags)arg;
-	int dirty = 0;
 
 	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
@@ -1419,8 +1418,7 @@ static int try_to_unmap_one(struct page
 	}
 
 	/* Move the dirty bit to the physical page now the pte is gone. */
-	dirty = pte_dirty(pteval);
-	if (dirty)
+	if (pte_dirty(pteval))
 		set_page_dirty(page);
 
 	/* Update high watermark before we lower rss */
@@ -1453,7 +1451,7 @@ static int try_to_unmap_one(struct page
 
 		if (flags & TTU_FREE) {
 			VM_BUG_ON_PAGE(PageSwapCache(page), page);
-			if (!dirty && !PageDirty(page)) {
+			if (!PageDirty(page)) {
 				/* It's a freeable page by MADV_FREE */
 				dec_mm_counter(mm, MM_ANONPAGES);
 				goto discard;
_

Patches currently in -mm which might be from minchan@kernel.org are

thp-use-is_zero_pfn-only-after-pte_present-check.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-5.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
mm-skip-huge-zero-page-in-madv_free.patch
mm-clear-pg_dirty-to-mark-page-freeable.patch
mm-simplify-reclaim-path-for-madv_free.patch
mm-mark-stable-page-dirty-in-ksm.patch

