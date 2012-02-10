From: akpm@linux-foundation.org
Subject: + pagemap-introduce-data-structure-for-pagemap-entry.patch added to -mm tree
Date: Thu, 09 Feb 2012 16:28:12 -0800
Message-ID: <20120210002812.F1E98A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39106 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2BJA2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 19:28:15 -0500
Received: by eaaf13 with SMTP id f13so65726eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 16:28:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: pagemap: introduce data structure for pagemap entry
has been added to the -mm tree.  Its filename is
     pagemap-introduce-data-structure-for-pagemap-entry.patch

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
@@ -589,9 +589,13 @@ const struct file_operations proc_clear_
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
@@ -614,10 +618,15 @@ struct pagemapread {
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
@@ -629,8 +638,10 @@ static int pagemap_pte_hole(unsigned lon
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
@@ -643,36 +654,33 @@ static u64 swap_pte_to_pagemap_entry(pte
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
 
@@ -683,7 +691,7 @@ static int pagemap_pte_range(pmd_t *pmd,
 	struct pagemapread *pm = walk->private;
 	pte_t *pte;
 	int err = 0;
-	u64 pfn = PM_NOT_PRESENT;
+	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
@@ -692,8 +700,8 @@ static int pagemap_pte_range(pmd_t *pmd,
 		for (; addr != end; addr += PAGE_SIZE) {
 			unsigned long offset = (addr & ~PAGEMAP_WALK_MASK)
 				>> PAGE_SHIFT;
-			pfn = thp_pmd_to_pagemap_entry(*pmd, offset);
-			err = add_to_pagemap(addr, pfn, pm);
+			thp_pmd_to_pagemap_entry(&pme, *pmd, offset);
+			err = add_to_pagemap(addr, &pme, pm);
 			if (err)
 				break;
 		}
@@ -712,11 +720,11 @@ static int pagemap_pte_range(pmd_t *pmd,
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
@@ -727,13 +735,12 @@ static int pagemap_pte_range(pmd_t *pmd,
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
@@ -743,12 +750,12 @@ static int pagemap_hugetlb_range(pte_t *
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
Subject: Subject: pagemap: introduce data structure for pagemap entry

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
mm-introduce-pmd_to_pte_t.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

