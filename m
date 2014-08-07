From: akpm@linux-foundation.org
Subject: [merged] mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:19 -0700
Message-ID: <53e3dbff.QBAD44eMokWUaUUY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:54620 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaHGUFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:20 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so609141qgd.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidlohr@hp.com, aswin@hp.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hugetlb: simplify error handling in hugetlb_cow()
has been removed from the -mm tree.  Its filename was
     mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm,hugetlb: simplify error handling in hugetlb_cow()

When returning from hugetlb_cow(), we always (1) put back the refcount for
each referenced page -- always 'old', and 'new' if allocation was
successful.  And (2) retake the page table lock right before returning, as
the callers expects.  This logic can be simplified and encapsulated, as
proposed in this patch.  In addition to cleaner code, we also shave a few
bytes off the instruction text:

   text    data     bss     dec     hex filename
  28399     462   41328   70189   1122d mm/hugetlb.o-baseline
  28367     462   41328   70157   1120d mm/hugetlb.o-patched

Passes libhugetlbfs testcases.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff -puN mm/hugetlb.c~mmhugetlb-simplify-error-handling-in-hugetlb_cow mm/hugetlb.c
--- a/mm/hugetlb.c~mmhugetlb-simplify-error-handling-in-hugetlb_cow
+++ a/mm/hugetlb.c
@@ -2808,7 +2808,7 @@ static int hugetlb_cow(struct mm_struct
 {
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
-	int outside_reserve = 0;
+	int ret = 0, outside_reserve = 0;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
@@ -2838,14 +2838,14 @@ retry_avoidcopy:
 
 	page_cache_get(old_page);
 
-	/* Drop page table lock as buddy allocator may be called */
+	/*
+	 * Drop page table lock as buddy allocator may be called. It will
+	 * be acquired again before returning to the caller, as expected.
+	 */
 	spin_unlock(ptl);
 	new_page = alloc_huge_page(vma, address, outside_reserve);
 
 	if (IS_ERR(new_page)) {
-		long err = PTR_ERR(new_page);
-		page_cache_release(old_page);
-
 		/*
 		 * If a process owning a MAP_PRIVATE mapping fails to COW,
 		 * it is due to references held by a child and an insufficient
@@ -2854,6 +2854,7 @@ retry_avoidcopy:
 		 * may get SIGKILLed if it later faults.
 		 */
 		if (outside_reserve) {
+			page_cache_release(old_page);
 			BUG_ON(huge_pte_none(pte));
 			unmap_ref_private(mm, vma, old_page, address);
 			BUG_ON(huge_pte_none(pte));
@@ -2869,12 +2870,9 @@ retry_avoidcopy:
 			return 0;
 		}
 
-		/* Caller expects lock to be held */
-		spin_lock(ptl);
-		if (err == -ENOMEM)
-			return VM_FAULT_OOM;
-		else
-			return VM_FAULT_SIGBUS;
+		ret = (PTR_ERR(new_page) == -ENOMEM) ?
+			VM_FAULT_OOM : VM_FAULT_SIGBUS;
+		goto out_release_old;
 	}
 
 	/*
@@ -2882,11 +2880,8 @@ retry_avoidcopy:
 	 * anon_vma prepared.
 	 */
 	if (unlikely(anon_vma_prepare(vma))) {
-		page_cache_release(new_page);
-		page_cache_release(old_page);
-		/* Caller expects lock to be held */
-		spin_lock(ptl);
-		return VM_FAULT_OOM;
+		ret = VM_FAULT_OOM;
+		goto out_release_all;
 	}
 
 	copy_user_huge_page(new_page, old_page, address, vma,
@@ -2896,6 +2891,7 @@ retry_avoidcopy:
 	mmun_start = address & huge_page_mask(h);
 	mmun_end = mmun_start + huge_page_size(h);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
 	/*
 	 * Retake the page table lock to check for racing updates
 	 * before the page tables are altered
@@ -2916,12 +2912,13 @@ retry_avoidcopy:
 	}
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+out_release_all:
 	page_cache_release(new_page);
+out_release_old:
 	page_cache_release(old_page);
 
-	/* Caller expects lock to be held */
-	spin_lock(ptl);
-	return 0;
+	spin_lock(ptl); /* Caller expects lock to be held */
+	return ret;
 }
 
 /* Return the pagecache page at a given address within a VMA */
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
shm-make-exit_shm-work-proportional-to-task-activity.patch
shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch
shm-remove-unneeded-extern-for-function.patch
linux-next.patch

