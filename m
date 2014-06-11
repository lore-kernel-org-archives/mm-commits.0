From: akpm@linux-foundation.org
Subject: + mm-pagewalk-remove-pgd_entry-and-pud_entry.patch added to -mm
 tree
Date: Wed, 11 Jun 2014 16:23:42 -0700
Message-ID: <5398e4fe.U+/FvmBOF6eTWh8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaFKXXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:23:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-pagewalk-remove-pgd_entry-and-pud_entry.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kirill@shutemov.name,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:23:42 -0700


The patch titled
     Subject: mm/pagewalk: remove pgd_entry() and pud_entry()
has been added to the -mm tree.  Its filename is
     mm-pagewalk-remove-pgd_entry-and-pud_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagewalk-remove-pgd_entry-and-pud_entry.patch

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
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

