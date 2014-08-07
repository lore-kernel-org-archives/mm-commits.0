From: akpm@linux-foundation.org
Subject: [merged] mmhugetlb-make-unmap_ref_private-return-void.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:17 -0700
Message-ID: <53e3dbfd.bwshrYCglgZKAye6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:41846 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbaHGUFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:18 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so610079yha.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr@hp.com, aswin@hp.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: make unmap_ref_private() return void
has been removed from the -mm tree.  Its filename was
     mmhugetlb-make-unmap_ref_private-return-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm,hugetlb: make unmap_ref_private() return void

This function always returns 1, thus no need to check return value in
hugetlb_cow().  By doing so, we can get rid of the unnecessary WARN_ON
call.  While this logic perhaps existed as a way of identifying future
unmap_ref_private() mishandling, reality is it serves no apparent purpose.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN mm/hugetlb.c~mmhugetlb-make-unmap_ref_private-return-void mm/hugetlb.c
--- a/mm/hugetlb.c~mmhugetlb-make-unmap_ref_private-return-void
+++ a/mm/hugetlb.c
@@ -2754,8 +2754,8 @@ void unmap_hugepage_range(struct vm_area
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
-static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
-				struct page *page, unsigned long address)
+static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
+			      struct page *page, unsigned long address)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
@@ -2794,8 +2794,6 @@ static int unmap_ref_private(struct mm_s
 					     address + huge_page_size(h), page);
 	}
 	mutex_unlock(&mapping->i_mmap_mutex);
-
-	return 1;
 }
 
 /*
@@ -2857,20 +2855,18 @@ retry_avoidcopy:
 		 */
 		if (outside_reserve) {
 			BUG_ON(huge_pte_none(pte));
-			if (unmap_ref_private(mm, vma, old_page, address)) {
-				BUG_ON(huge_pte_none(pte));
-				spin_lock(ptl);
-				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
-				if (likely(ptep &&
-					   pte_same(huge_ptep_get(ptep), pte)))
-					goto retry_avoidcopy;
-				/*
-				 * race occurs while re-acquiring page table
-				 * lock, and our job is done.
-				 */
-				return 0;
-			}
-			WARN_ON_ONCE(1);
+			unmap_ref_private(mm, vma, old_page, address);
+			BUG_ON(huge_pte_none(pte));
+			spin_lock(ptl);
+			ptep = huge_pte_offset(mm, address & huge_page_mask(h));
+			if (likely(ptep &&
+				   pte_same(huge_ptep_get(ptep), pte)))
+				goto retry_avoidcopy;
+			/*
+			 * race occurs while re-acquiring page table
+			 * lock, and our job is done.
+			 */
+			return 0;
 		}
 
 		/* Caller expects lock to be held */
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
shm-make-exit_shm-work-proportional-to-task-activity.patch
shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch
shm-remove-unneeded-extern-for-function.patch
linux-next.patch

