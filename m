From: akpm@linux-foundation.org
Subject: [merged] mm-pagewalk-remove-pgd_entry-and-pud_entry.patch removed from -mm tree
Date: Thu, 12 Feb 2015 11:38:07 -0800
Message-ID: <54dd011f.2Y3bfuGN9SguhJPA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbbBLTiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagewalk: remove pgd_entry() and pud_entry()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-remove-pgd_entry-and-pud_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/pagewalk: remove pgd_entry() and pud_entry()

Currently no user of page table walker sets ->pgd_entry() or
->pud_entry(), so checking their existence in each loop is just wasting
CPU cycle.  So let's remove it to reduce overhead.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ------
 mm/pagewalk.c      |    9 ++-------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff -puN include/linux/mm.h~mm-pagewalk-remove-pgd_entry-and-pud_entry include/linux/mm.h
--- a/include/linux/mm.h~mm-pagewalk-remove-pgd_entry-and-pud_entry
+++ a/include/linux/mm.h
@@ -1164,8 +1164,6 @@ void unmap_vmas(struct mmu_gather *tlb,
 
 /**
  * mm_walk - callbacks for walk_page_range
- * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
- * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
  *	       this handler is required to be able to handle
  *	       pmd_trans_huge() pmds.  They may simply choose to
@@ -1179,10 +1177,6 @@ void unmap_vmas(struct mmu_gather *tlb,
  * (see walk_page_range for more details)
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
@@ -86,9 +86,7 @@ static int walk_pud_range(pgd_t *pgd, un
 				break;
 			continue;
 		}
-		if (walk->pud_entry)
-			err = walk->pud_entry(pud, addr, next, walk);
-		if (!err && (walk->pmd_entry || walk->pte_entry))
+		if (walk->pmd_entry || walk->pte_entry)
 			err = walk_pmd_range(pud, addr, next, walk);
 		if (err)
 			break;
@@ -237,10 +235,7 @@ int walk_page_range(unsigned long addr,
 			pgd++;
 			continue;
 		}
-		if (walk->pgd_entry)
-			err = walk->pgd_entry(pgd, addr, next, walk);
-		if (!err &&
-		    (walk->pud_entry || walk->pmd_entry || walk->pte_entry))
+		if (walk->pmd_entry || walk->pte_entry)
 			err = walk_pud_range(pgd, addr, next, walk);
 		if (err)
 			break;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

