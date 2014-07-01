From: akpm@linux-foundation.org
Subject: + mmhugetlb-make-unmap_ref_private-return-void.patch added to -mm tree
Date: Tue, 01 Jul 2014 13:40:37 -0700
Message-ID: <53b31cc5.gnZQqtg7hXCe+8En%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64850 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaGAUkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 16:40:39 -0400
Received: by mail-qa0-f74.google.com with SMTP id w8so1096539qac.3
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 13:40:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr@hp.com, aswin@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: make unmap_ref_private() return void
has been added to the -mm tree.  Its filename is
     mmhugetlb-make-unmap_ref_private-return-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhugetlb-make-unmap_ref_private-return-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhugetlb-make-unmap_ref_private-return-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm,hugetlb: make unmap_ref_private() return void

This function always returns 1, thus no need to check return value in
hugetlb_cow().  By doing so, we can get rid of the unnecessary WARN_ON
call.  While this logic perhaps existed as a way of identifying future
unmap_ref_private() mishandling, reality is it serves no apparent purpose.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
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

tools-msgque-improve-error-handling-when-not-running-as-root.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
zram-remove-global-tb_lock-with-fine-grain-lock.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
shm-make-exit_shm-work-proportional-to-task-activity.patch
shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch
shm-remove-unneeded-extern-for-function.patch

