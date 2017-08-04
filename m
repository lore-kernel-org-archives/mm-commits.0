From: akpm@linux-foundation.org
Subject: + rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl.patch
 added to -mm tree
Date: Fri, 04 Aug 2017 16:30:53 -0700
Message-ID: <598503ad.tC546ZpUigalaSVu%akpm__19426.432674709$1501889464$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50090 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753867AbdHDXay (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2017 19:30:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, Tim.Writer@amd.com, alexander.deucher@amd.com, axie@amd.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: do not call mmu_notifier_invalidate_page() under ptl
has been added to the -mm tree.  Its filename is
     rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: rmap: do not call mmu_notifier_invalidate_page() under ptl

MMU notifiers can sleep, but in page_mkclean_one() we call
mmu_notifier_invalidate_page() under page table lock.

Let's instead use mmu_notifier_invalidate_range() outside
page_vma_mapped_walk() loop.

Link: http://lkml.kernel.org/r/20170804134928.l4klfcnqatni7vsc@black.fi.intel.com
Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: axie <axie@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Writer, Tim" <Tim.Writer@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN mm/rmap.c~rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl mm/rmap.c
--- a/mm/rmap.c~rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl
+++ a/mm/rmap.c
@@ -888,10 +888,10 @@ static bool page_mkclean_one(struct page
 		.flags = PVMW_SYNC,
 	};
 	int *cleaned = arg;
+	bool invalidation_needed = false;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		int ret = 0;
-		address = pvmw.address;
 		if (pvmw.pte) {
 			pte_t entry;
 			pte_t *pte = pvmw.pte;
@@ -899,11 +899,11 @@ static bool page_mkclean_one(struct page
 			if (!pte_dirty(*pte) && !pte_write(*pte))
 				continue;
 
-			flush_cache_page(vma, address, pte_pfn(*pte));
-			entry = ptep_clear_flush(vma, address, pte);
+			flush_cache_page(vma, pvmw.address, pte_pfn(*pte));
+			entry = ptep_clear_flush(vma, pvmw.address, pte);
 			entry = pte_wrprotect(entry);
 			entry = pte_mkclean(entry);
-			set_pte_at(vma->vm_mm, address, pte, entry);
+			set_pte_at(vma->vm_mm, pvmw.address, pte, entry);
 			ret = 1;
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
@@ -913,11 +913,11 @@ static bool page_mkclean_one(struct page
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
 				continue;
 
-			flush_cache_page(vma, address, page_to_pfn(page));
-			entry = pmdp_huge_clear_flush(vma, address, pmd);
+			flush_cache_page(vma, pvmw.address, page_to_pfn(page));
+			entry = pmdp_huge_clear_flush(vma, pvmw.address, pmd);
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
-			set_pmd_at(vma->vm_mm, address, pmd, entry);
+			set_pmd_at(vma->vm_mm, pvmw.address, pmd, entry);
 			ret = 1;
 #else
 			/* unexpected pmd-mapped page? */
@@ -926,11 +926,16 @@ static bool page_mkclean_one(struct page
 		}
 
 		if (ret) {
-			mmu_notifier_invalidate_page(vma->vm_mm, address);
 			(*cleaned)++;
+			invalidation_needed = true;
 		}
 	}
 
+	if (invalidation_needed) {
+		mmu_notifier_invalidate_range(vma->vm_mm, address,
+				address + (1UL << compound_order(page)));
+	}
+
 	return true;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rmap-do-not-call-mmu_notifier_invalidate_page-under-ptl.patch

