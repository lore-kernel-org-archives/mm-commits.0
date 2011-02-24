From: akpm@linux-foundation.org
Subject: + pagewalk-only-split-huge-pages-when-necessary.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:48:06 -0800
Message-ID: <201102240048.p1O0m6R1002172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205Ab1BXAtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:49:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, aarcange@redhat.com, emunson@mgebm.net, hannes@cmpxchg.org, jeremy@goop.org, mel@csn.ul.ie, mjwolf@us.ibm.com, mpm@selenic.com, rientjes@google.com


The patch titled
     pagewalk: only split huge pages when necessary
has been added to the -mm tree.  Its filename is
     pagewalk-only-split-huge-pages-when-necessary.patch

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
Subject: pagewalk: only split huge pages when necessary
From: Dave Hansen <dave@linux.vnet.ibm.com>

Right now, if a mm_walk has either ->pte_entry or ->pmd_entry set, it will
unconditionally split any transparent huge pages it runs in to.  In
practice, that means that anyone doing a

	cat /proc/$pid/smaps

will unconditionally break down every huge page in the process and depend
on khugepaged to re-collapse it later.  This is fairly suboptimal.

This patch changes that behavior.  It teaches each ->pmd_entry handler
(there are five) that they must break down the THPs themselves.  Also, the
_generic_ code will never break down a THP unless a ->pte_entry handler is
actually set.

This means that the ->pmd_entry handlers can now choose to deal with THPs
without breaking them down.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Cc: Michael J Wolf <mjwolf@us.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 ++++++
 include/linux/mm.h |    3 +++
 mm/memcontrol.c    |    5 +++--
 mm/pagewalk.c      |   24 ++++++++++++++++++++----
 4 files changed, 32 insertions(+), 6 deletions(-)

diff -puN fs/proc/task_mmu.c~pagewalk-only-split-huge-pages-when-necessary fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagewalk-only-split-huge-pages-when-necessary
+++ a/fs/proc/task_mmu.c
@@ -343,6 +343,8 @@ static int smaps_pte_range(pmd_t *pmd, u
 	struct page *page;
 	int mapcount;
 
+	split_huge_page_pmd(walk->mm, pmd);
+
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
@@ -467,6 +469,8 @@ static int clear_refs_pte_range(pmd_t *p
 	spinlock_t *ptl;
 	struct page *page;
 
+	split_huge_page_pmd(walk->mm, pmd);
+
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
@@ -623,6 +627,8 @@ static int pagemap_pte_range(pmd_t *pmd,
 	pte_t *pte;
 	int err = 0;
 
+	split_huge_page_pmd(walk->mm, pmd);
+
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
 	for (; addr != end; addr += PAGE_SIZE) {
diff -puN include/linux/mm.h~pagewalk-only-split-huge-pages-when-necessary include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-only-split-huge-pages-when-necessary
+++ a/include/linux/mm.h
@@ -907,6 +907,9 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
  * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
+ * 	       this handler is required to be able to handle
+ * 	       pmd_trans_huge() pmds.  They may simply choose to
+ * 	       split_huge_page() instead of handling it explicitly.
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
diff -puN mm/memcontrol.c~pagewalk-only-split-huge-pages-when-necessary mm/memcontrol.c
--- a/mm/memcontrol.c~pagewalk-only-split-huge-pages-when-necessary
+++ a/mm/memcontrol.c
@@ -4763,7 +4763,8 @@ static int mem_cgroup_count_precharge_pt
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
+	split_huge_page_pmd(walk->mm, pmd);
+
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		if (is_target_pte_for_mc(vma, addr, *pte, NULL))
@@ -4925,8 +4926,8 @@ static int mem_cgroup_move_charge_pte_ra
 	pte_t *pte;
 	spinlock_t *ptl;
 
+	split_huge_page_pmd(walk->mm, pmd);
 retry:
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; addr += PAGE_SIZE) {
 		pte_t ptent = *(pte++);
diff -puN mm/pagewalk.c~pagewalk-only-split-huge-pages-when-necessary mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-only-split-huge-pages-when-necessary
+++ a/mm/pagewalk.c
@@ -33,19 +33,35 @@ static int walk_pmd_range(pud_t *pud, un
 
 	pmd = pmd_offset(pud, addr);
 	do {
+	again:
 		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(walk->mm, pmd);
-		if (pmd_none_or_clear_bad(pmd)) {
+		if (pmd_none(*pmd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
 			continue;
 		}
+		/*
+		 * This implies that each ->pmd_entry() handler
+		 * needs to know about pmd_trans_huge() pmds
+		 */
 		if (walk->pmd_entry)
 			err = walk->pmd_entry(pmd, addr, next, walk);
-		if (!err && walk->pte_entry)
-			err = walk_pte_range(pmd, addr, next, walk);
+		if (err)
+			break;
+
+		/*
+		 * Check this here so we only break down trans_huge
+		 * pages when we _need_ to
+		 */
+		if (!walk->pte_entry)
+			continue;
+
+		split_huge_page_pmd(walk->mm, pmd);
+		if (pmd_none_or_clear_bad(pmd))
+			goto again;
+		err = walk_pte_range(pmd, addr, next, walk);
 		if (err)
 			break;
 	} while (pmd++, addr = next, addr != end);
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch

