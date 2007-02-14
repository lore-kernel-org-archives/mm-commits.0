From: akpm@linux-foundation.org
Subject: + mm-remove-gcc-workaround.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:50:22 -0800
Message-ID: <200702142150.l1ELoVHS010367@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47773 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbXBNVuf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:50:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: remove gcc workaround
has been added to the -mm tree.  Its filename is
     mm-remove-gcc-workaround.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: remove gcc workaround
From: Nick Piggin <npiggin@suse.de>

Minimum gcc version is 3.2 now.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ------------
 1 files changed, 12 deletions(-)

diff -puN mm/memory.c~mm-remove-gcc-workaround mm/memory.c
--- a/mm/memory.c~mm-remove-gcc-workaround
+++ a/mm/memory.c
@@ -2539,12 +2539,6 @@ int __pud_alloc(struct mm_struct *mm, pg
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
-#else
-/* Workaround for gcc 2.96 */
-int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
-{
-	return 0;
-}
 #endif /* __PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -2573,12 +2567,6 @@ int __pmd_alloc(struct mm_struct *mm, pu
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
-#else
-/* Workaround for gcc 2.96 */
-int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
-{
-	return 0;
-}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 int make_pages_present(unsigned long addr, unsigned long end)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-block.patch
mm-remove-gcc-workaround.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
