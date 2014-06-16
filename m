From: akpm@linux-foundation.org
Subject: [nacked] mm-pagewalk-remove-pgd_entry-and-pud_entry.patch removed from -mm tree
Date: Mon, 16 Jun 2014 16:32:26 -0700
Message-ID: <539f7e8a.QdpDYpbvGrow+EMf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaFPXc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm/pagewalk: remove pgd_entry() and pud_entry()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-remove-pgd_entry-and-pud_entry.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/pagewalk: remove pgd_entry() and pud_entry()

Currently no user of page table walker sets ->pgd_entry() or
->pud_entry(), so checking their existence in each loop is just wasting
CPU cycle.  So let's remove it to reduce overhead.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
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

 include/linux/mm.h |    6 ------
 mm/pagewalk.c      |   18 +-----------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff -puN include/linux/mm.h~mm-pagewalk-remove-pgd_entry-and-pud_entry include/linux/mm.h
--- a/include/linux/mm.h~mm-pagewalk-remove-pgd_entry-and-pud_entry
+++ a/include/linux/mm.h
@@ -1100,8 +1100,6 @@ void unmap_vmas(struct mmu_gather *tlb,
 
 /**
  * mm_walk - callbacks for walk_page_range
- * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
- * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
  *	       this handler is required to be able to handle
  *	       pmd_trans_huge() pmds.  They may simply choose to
@@ -1121,10 +1119,6 @@ void unmap_vmas(struct mmu_gather *tlb,
  * (see the comment on walk_page_range() for more details)
  */
 struct mm_walk {
-	int (*pgd_entry)(pgd_t *pgd, unsigned long addr,
-			 unsigned long next, struct mm_walk *walk);
-	int (*pud_entry)(pud_t *pud, unsigned long addr,
-	                 unsigned long next, struct mm_walk *walk);
 	int (*pmd_entry)(pmd_t *pmd, unsigned long addr,
 			 unsigned long next, struct mm_walk *walk);
 	int (*pte_entry)(pte_t *pte, unsigned long addr,
diff -puN mm/pagewalk.c~mm-pagewalk-remove-pgd_entry-and-pud_entry mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalk-remove-pgd_entry-and-pud_entry
+++ a/mm/pagewalk.c
@@ -115,14 +115,6 @@ static int walk_pud_range(pgd_t *pgd, un
 			continue;
 		}
 
-		if (walk->pud_entry) {
-			err = walk->pud_entry(pud, addr, next, walk);
-			if (skip_lower_level_walking(walk))
-				continue;
-			if (err)
-				break;
-		}
-
 		if (walk->pmd_entry || walk->pte_entry) {
 			err = walk_pmd_range(pud, addr, next, walk);
 			if (err)
@@ -152,15 +144,7 @@ static int walk_pgd_range(unsigned long
 			continue;
 		}
 
-		if (walk->pgd_entry) {
-			err = walk->pgd_entry(pgd, addr, next, walk);
-			if (skip_lower_level_walking(walk))
-				continue;
-			if (err)
-				break;
-		}
-
-		if (walk->pud_entry || walk->pmd_entry || walk->pte_entry) {
+		if (walk->pmd_entry || walk->pte_entry) {
 			err = walk_pud_range(pgd, addr, next, walk);
 			if (err)
 				break;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
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

