From: akpm@linux-foundation.org
Subject: + smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:48:12 -0800
Message-ID: <201102240048.p1O0mDMP002179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659Ab1BXAt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:49:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, aarcange@redhat.com, emunson@mgebm.net, hannes@cmpxchg.org, jeremy@goop.org, mel@csn.ul.ie, mjwolf@us.ibm.com, mpm@selenic.com, rientjes@google.com


The patch titled
     smaps: pass pte size argument in to smaps_pte_entry()
has been added to the -mm tree.  Its filename is
     smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smaps: pass pte size argument in to smaps_pte_entry()
From: Dave Hansen <dave@linux.vnet.ibm.com>

Add an argument to the new smaps_pte_entry() function to let it account in
things other than PAGE_SIZE units.  I changed all of the PAGE_SIZE sites,
even though not all of them can be reached for transparent huge pages,
just so this will continue to work without changes as THPs are improved.

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

 fs/proc/task_mmu.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-pass-pte-size-argument-in-to-smaps_pte_entry fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-pass-pte-size-argument-in-to-smaps_pte_entry
+++ a/fs/proc/task_mmu.c
@@ -335,7 +335,7 @@ struct mem_size_stats {
 
 
 static void smaps_pte_entry(pte_t ptent, unsigned long addr,
-		struct mm_walk *walk)
+		unsigned long ptent_size, struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = mss->vma;
@@ -343,7 +343,7 @@ static void smaps_pte_entry(pte_t ptent,
 	int mapcount;
 
 	if (is_swap_pte(ptent)) {
-		mss->swap += PAGE_SIZE;
+		mss->swap += ptent_size;
 		return;
 	}
 
@@ -355,25 +355,25 @@ static void smaps_pte_entry(pte_t ptent,
 		return;
 
 	if (PageAnon(page))
-		mss->anonymous += PAGE_SIZE;
+		mss->anonymous += ptent_size;
 
-	mss->resident += PAGE_SIZE;
+	mss->resident += ptent_size;
 	/* Accumulate the size in pages that have been accessed. */
 	if (pte_young(ptent) || PageReferenced(page))
-		mss->referenced += PAGE_SIZE;
+		mss->referenced += ptent_size;
 	mapcount = page_mapcount(page);
 	if (mapcount >= 2) {
 		if (pte_dirty(ptent) || PageDirty(page))
-			mss->shared_dirty += PAGE_SIZE;
+			mss->shared_dirty += ptent_size;
 		else
-			mss->shared_clean += PAGE_SIZE;
-		mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
+			mss->shared_clean += ptent_size;
+		mss->pss += (ptent_size << PSS_SHIFT) / mapcount;
 	} else {
 		if (pte_dirty(ptent) || PageDirty(page))
-			mss->private_dirty += PAGE_SIZE;
+			mss->private_dirty += ptent_size;
 		else
-			mss->private_clean += PAGE_SIZE;
-		mss->pss += (PAGE_SIZE << PSS_SHIFT);
+			mss->private_clean += ptent_size;
+		mss->pss += (ptent_size << PSS_SHIFT);
 	}
 }
 
@@ -389,7 +389,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
-		smaps_pte_entry(*pte, addr, walk);
+		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
 	return 0;
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch

