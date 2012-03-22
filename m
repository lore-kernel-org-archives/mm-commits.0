From: akpm@linux-foundation.org
Subject: [merged] pagemap-introduce-data-structure-for-pagemap-entry.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:08 -0700
Message-ID: <20120322201808.81590A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61078 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2CVUSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:10 -0400
Received: by yenq2 with SMTP id q2so401674yen.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: introduce data structure for pagemap entry
has been removed from the -mm tree.  Its filename was
     pagemap-introduce-data-structure-for-pagemap-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagemap: introduce data structure for pagemap entry

Currently a local variable of pagemap entry in pagemap_pte_range() is
named pfn and typed with u64, but it's not correct (pfn should be unsigned
long.)

This patch introduces special type for pagemap entries and replaces code
with it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   69 +++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-introduce-data-structure-for-pagemap-entry fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-introduce-data-structure-for-pagemap-entry
+++ a/fs/proc/task_mmu.c
@@ -594,9 +594,13 @@ const struct file_operations proc_clear_
 	.llseek		= noop_llseek,
 };
 
+typedef struct {
+	u64 pme;
+} pagemap_entry_t;
+
 struct pagemapread {
 	int pos, len;
-	u64 *buffer;
+	pagemap_entry_t *buffer;
 };
 
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
@@ -619,10 +623,15 @@ struct pagemapread {
 #define PM_NOT_PRESENT      PM_PSHIFT(PAGE_SHIFT)
 #define PM_END_OF_BUFFER    1
 
-static int add_to_pagemap(unsigned long addr, u64 pfn,
+static inline pagemap_entry_t make_pme(u64 val)
+{
+	return (pagemap_entry_t) { .pme = val };
+}
+
+static int add_to_pagemap(unsigned long addr, pagemap_entry_t *pme,
 			  struct pagemapread *pm)
 {
-	pm->buffer[pm->pos++] = pfn;
+	pm->buffer[pm->pos++] = *pme;
 	if (pm->pos >= pm->len)
 		return PM_END_OF_BUFFER;
 	return 0;
@@ -634,8 +643,10 @@ static int pagemap_pte_hole(unsigned lon
 	struct pagemapread *pm = walk->private;
 	unsigned long addr;
 	int err = 0;
+	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		err = add_to_pagemap(addr, PM_NOT_PRESENT, pm);
+		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			break;
 	}
@@ -648,36 +659,33 @@ static u64 swap_pte_to_pagemap_entry(pte
 	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
 }
 
-static u64 pte_to_pagemap_entry(pte_t pte)
+static void pte_to_pagemap_entry(pagemap_entry_t *pme, pte_t pte)
 {
-	u64 pme = 0;
 	if (is_swap_pte(pte))
-		pme = PM_PFRAME(swap_pte_to_pagemap_entry(pte))
-			| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP;
+		*pme = make_pme(PM_PFRAME(swap_pte_to_pagemap_entry(pte))
+				| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP);
 	else if (pte_present(pte))
-		pme = PM_PFRAME(pte_pfn(pte))
-			| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
-	return pme;
+		*pme = make_pme(PM_PFRAME(pte_pfn(pte))
+				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static u64 thp_pmd_to_pagemap_entry(pmd_t pmd, int offset)
+static void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme,
+					pmd_t pmd, int offset)
 {
-	u64 pme = 0;
 	/*
 	 * Currently pmd for thp is always present because thp can not be
 	 * swapped-out, migrated, or HWPOISONed (split in such cases instead.)
 	 * This if-check is just to prepare for future implementation.
 	 */
 	if (pmd_present(pmd))
-		pme = PM_PFRAME(pmd_pfn(pmd) + offset)
-			| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
-	return pme;
+		*pme = make_pme(PM_PFRAME(pmd_pfn(pmd) + offset)
+				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
 }
 #else
-static inline u64 thp_pmd_to_pagemap_entry(pmd_t pmd, int offset)
+static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme,
+						pmd_t pmd, int offset)
 {
-	return 0;
 }
 #endif
 
@@ -688,7 +696,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 	struct pagemapread *pm = walk->private;
 	pte_t *pte;
 	int err = 0;
-	u64 pfn = PM_NOT_PRESENT;
+	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
 
 	if (pmd_trans_unstable(pmd))
 		return 0;
@@ -702,8 +710,8 @@ static int pagemap_pte_range(pmd_t *pmd,
 
 			offset = (addr & ~PAGEMAP_WALK_MASK) >>
 					PAGE_SHIFT;
-			pfn = thp_pmd_to_pagemap_entry(*pmd, offset);
-			err = add_to_pagemap(addr, pfn, pm);
+			thp_pmd_to_pagemap_entry(&pme, *pmd, offset);
+			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
 				break;
 		}
@@ -723,11 +731,11 @@ static int pagemap_pte_range(pmd_t *pmd,
 		if (vma && (vma->vm_start <= addr) &&
 		    !is_vm_hugetlb_page(vma)) {
 			pte = pte_offset_map(pmd, addr);
-			pfn = pte_to_pagemap_entry(*pte);
+			pte_to_pagemap_entry(&pme, *pte);
 			/* unmap before userspace copy */
 			pte_unmap(pte);
 		}
-		err = add_to_pagemap(addr, pfn, pm);
+		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			return err;
 	}
@@ -738,13 +746,12 @@ static int pagemap_pte_range(pmd_t *pmd,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static u64 huge_pte_to_pagemap_entry(pte_t pte, int offset)
+static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme,
+					pte_t pte, int offset)
 {
-	u64 pme = 0;
 	if (pte_present(pte))
-		pme = PM_PFRAME(pte_pfn(pte) + offset)
-			| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
-	return pme;
+		*pme = make_pme(PM_PFRAME(pte_pfn(pte) + offset)
+				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT);
 }
 
 /* This function walks within one hugetlb entry in the single call */
@@ -754,12 +761,12 @@ static int pagemap_hugetlb_range(pte_t *
 {
 	struct pagemapread *pm = walk->private;
 	int err = 0;
-	u64 pfn;
+	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
 
 	for (; addr != end; addr += PAGE_SIZE) {
 		int offset = (addr & ~hmask) >> PAGE_SHIFT;
-		pfn = huge_pte_to_pagemap_entry(*pte, offset);
-		err = add_to_pagemap(addr, pfn, pm);
+		huge_pte_to_pagemap_entry(&pme, *pte, offset);
+		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			return err;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
linux-next.patch

