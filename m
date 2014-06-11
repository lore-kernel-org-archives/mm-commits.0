From: akpm@linux-foundation.org
Subject: + madvise-cleanup-swapin_walk_pmd_entry.patch added to -mm tree
Date: Wed, 11 Jun 2014 16:21:31 -0700
Message-ID: <5398e47b.k+JNQ6aqDZqNZa5G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaFKXVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:21:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + madvise-cleanup-swapin_walk_pmd_entry.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kirill@shutemov.name,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:21:31 -0700


The patch titled
     Subject: madvise: cleanup swapin_walk_pmd_entry()
has been added to the -mm tree.  Its filename is
     madvise-cleanup-swapin_walk_pmd_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/madvise-cleanup-swapin_walk_pmd_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/madvise-cleanup-swapin_walk_pmd_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalkc-move-pte-null-check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

