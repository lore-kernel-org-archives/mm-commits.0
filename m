From: akpm@linux-foundation.org
Subject: [nacked] madvise-cleanup-swapin_walk_pmd_entry.patch removed from -mm tree
Date: Mon, 16 Jun 2014 16:32:32 -0700
Message-ID: <539f7e90.XKed1lXpwPKYPlJG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaFPXcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: madvise: cleanup swapin_walk_pmd_entry()
has been removed from the -mm tree.  Its filename was
     madvise-cleanup-swapin_walk_pmd_entry.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: madvise: cleanup swapin_walk_pmd_entry()

With the recent update on page table walker, we can use common code for
the walking more.  Unlike many other users, this swapin_walk expects to
handle swap entries.  As a result we should be careful about ptl locking. 
Swapin operation, read_swap_cache_async(), could cause page reclaim, so we
can't keep holding ptl throughout this pte loop.  In order to properly
handle ptl in pte_entry(), this patch adds two new members on struct
mm_walk.

This cleanup is necessary to get to the final form of page table walker,
where we should do all caller's specific work on leaf entries (IOW, all
pmd_entry() should be used for trans_pmd.)

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 +++
 mm/madvise.c       |   56 ++++++++++++++++++-------------------------
 mm/pagewalk.c      |    5 ++-
 3 files changed, 31 insertions(+), 34 deletions(-)

diff -puN include/linux/mm.h~madvise-cleanup-swapin_walk_pmd_entry include/linux/mm.h
--- a/include/linux/mm.h~madvise-cleanup-swapin_walk_pmd_entry
+++ a/include/linux/mm.h
@@ -1112,6 +1112,8 @@ void unmap_vmas(struct mmu_gather *tlb,
  *             walk_page_test() for how the skip control works.
  * @mm:        mm_struct representing the target process of page table walk
  * @vma:       vma currently walked
+ * @pmd:       current pmd entry
+ * @ptl:       page table lock associated with current entry
  * @control:   walk control flag
  * @private:   private data for callbacks' use
  *
@@ -1130,6 +1132,8 @@ struct mm_walk {
 			struct mm_walk *walk);
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
+	pmd_t *pmd;
+	spinlock_t *ptl;
 	int control;
 	void *private;
 };
diff -puN mm/madvise.c~madvise-cleanup-swapin_walk_pmd_entry mm/madvise.c
--- a/mm/madvise.c~madvise-cleanup-swapin_walk_pmd_entry
+++ a/mm/madvise.c
@@ -135,38 +135,31 @@ out:
 }
 
 #ifdef CONFIG_SWAP
-static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
+/*
+ * Assuming that page table walker holds page table lock.
+ */
+static int swapin_walk_pte_entry(pte_t *pte, unsigned long start,
 	unsigned long end, struct mm_walk *walk)
 {
-	pte_t *orig_pte;
-	struct vm_area_struct *vma = walk->private;
-	unsigned long index;
-
-	if (pmd_none_or_trans_huge_or_clear_bad(pmd))
-		return 0;
-
-	for (index = start; index != end; index += PAGE_SIZE) {
-		pte_t pte;
-		swp_entry_t entry;
-		struct page *page;
-		spinlock_t *ptl;
-
-		orig_pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
-		pte = *(orig_pte + ((index - start) / PAGE_SIZE));
-		pte_unmap_unlock(orig_pte, ptl);
-
-		if (pte_present(pte) || pte_none(pte) || pte_file(pte))
-			continue;
-		entry = pte_to_swp_entry(pte);
-		if (unlikely(non_swap_entry(entry)))
-			continue;
-
-		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-								vma, index);
-		if (page)
-			page_cache_release(page);
-	}
-
+	pte_t ptent;
+	pte_t *orig_pte = pte - ((start & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+	swp_entry_t entry;
+	struct page *page;
+
+	ptent = *pte;
+	pte_unmap_unlock(orig_pte, walk->ptl);
+	if (pte_present(ptent) || pte_none(ptent) || pte_file(ptent))
+		goto lock;
+	entry = pte_to_swp_entry(ptent);
+	if (unlikely(non_swap_entry(entry)))
+		goto lock;
+	page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
+				     walk->vma, start);
+	if (page)
+		page_cache_release(page);
+lock:
+	pte_offset_map(walk->pmd, start & PMD_MASK);
+	spin_lock(walk->ptl);
 	return 0;
 }
 
@@ -175,8 +168,7 @@ static void force_swapin_readahead(struc
 {
 	struct mm_walk walk = {
 		.mm = vma->vm_mm,
-		.pmd_entry = swapin_walk_pmd_entry,
-		.private = vma,
+		.pte_entry = swapin_walk_pte_entry,
 	};
 
 	walk_page_range(start, end, &walk);
diff -puN mm/pagewalk.c~madvise-cleanup-swapin_walk_pmd_entry mm/pagewalk.c
--- a/mm/pagewalk.c~madvise-cleanup-swapin_walk_pmd_entry
+++ a/mm/pagewalk.c
@@ -20,7 +20,8 @@ static int walk_pte_range(pmd_t *pmd, un
 	spinlock_t *ptl;
 	int err = 0;
 
-	orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	walk->pmd = pmd;
+	orig_pte = pte = pte_offset_map_lock(mm, pmd, addr, &walk->ptl);
 	do {
 		if (pte_none(*pte)) {
 			if (walk->pte_hole)
@@ -49,7 +50,7 @@ static int walk_pte_range(pmd_t *pmd, un
 		}
 	} while (pte++, addr += PAGE_SIZE, addr < end);
 out_unlock:
-	pte_unmap_unlock(orig_pte, ptl);
+	pte_unmap_unlock(orig_pte, walk->ptl);
 	cond_resched();
 	return addr == end ? 0 : err;
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
madvise-cleanup-swapin_walk_pmd_entry-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

