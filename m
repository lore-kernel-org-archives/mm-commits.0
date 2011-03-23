From: akpm@linux-foundation.org
Subject: [merged] smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:38 -0700
Message-ID: <201103232040.p2NKeEmP028510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933394Ab1CWUld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, aarcange@redhat.com, emunson@mgebm.net, hannes@cmpxchg.org, jeremy@goop.org, mel@csn.ul.ie, mjwolf@us.ibm.com, mpm@selenic.com, rientjes@google.com, mm-commit


The patch titled
     smaps: break out smaps_pte_entry() from smaps_pte_range()
has been removed from the -mm tree.  Its filename was
     smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smaps: break out smaps_pte_entry() from smaps_pte_range()
From: Dave Hansen <dave@linux.vnet.ibm.com>

We will use smaps_pte_entry() in a moment to handle both small and
transparent large pages.  But, we must break it out of smaps_pte_range()
first.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Cc: Michael J Wolf <mjwolf@us.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   85 +++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-break-out-smaps_pte_entry-from-smaps_pte_range fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-break-out-smaps_pte_entry-from-smaps_pte_range
+++ a/fs/proc/task_mmu.c
@@ -333,56 +333,63 @@ struct mem_size_stats {
 	u64 pss;
 };
 
-static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
-			   struct mm_walk *walk)
+
+static void smaps_pte_entry(pte_t ptent, unsigned long addr,
+		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
 	struct page *page;
 	int mapcount;
 
-	split_huge_page_pmd(walk->mm, pmd);
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = *pte;
+	if (is_swap_pte(ptent)) {
+		mss->swap += PAGE_SIZE;
+		return;
+	}
 
-		if (is_swap_pte(ptent)) {
-			mss->swap += PAGE_SIZE;
-			continue;
-		}
+	if (!pte_present(ptent))
+		return;
 
-		if (!pte_present(ptent))
-			continue;
+	page = vm_normal_page(vma, addr, ptent);
+	if (!page)
+		return;
+
+	if (PageAnon(page))
+		mss->anonymous += PAGE_SIZE;
+
+	mss->resident += PAGE_SIZE;
+	/* Accumulate the size in pages that have been accessed. */
+	if (pte_young(ptent) || PageReferenced(page))
+		mss->referenced += PAGE_SIZE;
+	mapcount = page_mapcount(page);
+	if (mapcount >= 2) {
+		if (pte_dirty(ptent) || PageDirty(page))
+			mss->shared_dirty += PAGE_SIZE;
+		else
+			mss->shared_clean += PAGE_SIZE;
+		mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
+	} else {
+		if (pte_dirty(ptent) || PageDirty(page))
+			mss->private_dirty += PAGE_SIZE;
+		else
+			mss->private_clean += PAGE_SIZE;
+		mss->pss += (PAGE_SIZE << PSS_SHIFT);
+	}
+}
 
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
-			continue;
+static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			   struct mm_walk *walk)
+{
+	struct mem_size_stats *mss = walk->private;
+	struct vm_area_struct *vma = mss->vma;
+	pte_t *pte;
+	spinlock_t *ptl;
 
-		if (PageAnon(page))
-			mss->anonymous += PAGE_SIZE;
+	split_huge_page_pmd(walk->mm, pmd);
 
-		mss->resident += PAGE_SIZE;
-		/* Accumulate the size in pages that have been accessed. */
-		if (pte_young(ptent) || PageReferenced(page))
-			mss->referenced += PAGE_SIZE;
-		mapcount = page_mapcount(page);
-		if (mapcount >= 2) {
-			if (pte_dirty(ptent) || PageDirty(page))
-				mss->shared_dirty += PAGE_SIZE;
-			else
-				mss->shared_clean += PAGE_SIZE;
-			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
-		} else {
-			if (pte_dirty(ptent) || PageDirty(page))
-				mss->private_dirty += PAGE_SIZE;
-			else
-				mss->private_clean += PAGE_SIZE;
-			mss->pss += (PAGE_SIZE << PSS_SHIFT);
-		}
-	}
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE)
+		smaps_pte_entry(*pte, addr, walk);
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 	return 0;
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch

