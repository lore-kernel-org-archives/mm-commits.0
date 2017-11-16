From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-remove-redundant-variable-cend.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:02:31 -0800
Message-ID: <20171116200231.L_ZR_6aHu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964820AbdKPUCc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap.c: remove redundant variable cend
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-redundant-variable-cend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/rmap.c: remove redundant variable cend

Variable cend is set but never read, hence it is redundant and can be
removed.

Cleans up clang build warning: Value stored to 'cend' is never read

Link: http://lkml.kernel.org/r/20171011174942.1372-1-colin.king@canonical.com
Fixes: 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic v2")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/rmap.c~mm-rmap-remove-redundant-variable-cend mm/rmap.c
--- a/mm/rmap.c~mm-rmap-remove-redundant-variable-cend
+++ a/mm/rmap.c
@@ -899,7 +899,7 @@ static bool page_mkclean_one(struct page
 	mmu_notifier_invalidate_range_start(vma->vm_mm, start, end);
 
 	while (page_vma_mapped_walk(&pvmw)) {
-		unsigned long cstart, cend;
+		unsigned long cstart;
 		int ret = 0;
 
 		cstart = address = pvmw.address;
@@ -915,7 +915,6 @@ static bool page_mkclean_one(struct page
 			entry = pte_wrprotect(entry);
 			entry = pte_mkclean(entry);
 			set_pte_at(vma->vm_mm, address, pte, entry);
-			cend = cstart + PAGE_SIZE;
 			ret = 1;
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
@@ -931,7 +930,6 @@ static bool page_mkclean_one(struct page
 			entry = pmd_mkclean(entry);
 			set_pmd_at(vma->vm_mm, address, pmd, entry);
 			cstart &= PMD_MASK;
-			cend = cstart + PMD_SIZE;
 			ret = 1;
 #else
 			/* unexpected pmd-mapped page? */
_

Patches currently in -mm which might be from colin.king@canonical.com are

fat-remove-redundant-assignment-of-0-to-slots.patch

