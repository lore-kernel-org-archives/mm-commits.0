From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:32:34 -0800
Message-ID: <20180201193234.eXw0pLebO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58726 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754563AbeBATcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:32:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, davem@davemloft.net, david.daney@cavium.com, hpa@zytor.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, nitin.m.gupta@oracle.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, vbabka@suse.cz, vgupta@synopsys.com


The patch titled
     Subject: mm: use updated pmdp_invalidate() interface to track dirty/accessed bits
has been removed from the -mm tree.  Its filename was
     mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: use updated pmdp_invalidate() interface to track dirty/accessed bits

Use the modifed pmdp_invalidate() that returns the previous value of pmd
to transfer dirty and accessed bits.

Link: http://lkml.kernel.org/r/20171213105756.69879-12-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Daney <david.daney@cavium.com>
Cc: David Miller <davem@davemloft.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nitin Gupta <nitin.m.gupta@oracle.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Vlastimil Babka <vbabka@suse.cz>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++----
 mm/huge_memory.c   |   29 ++++++++++++-----------------
 2 files changed, 16 insertions(+), 21 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits
+++ a/fs/proc/task_mmu.c
@@ -982,14 +982,14 @@ static inline void clear_soft_dirty(stru
 static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
-	pmd_t pmd = *pmdp;
+	pmd_t old, pmd = *pmdp;
 
 	if (pmd_present(pmd)) {
 		/* See comment in change_huge_pmd() */
-		pmdp_invalidate(vma, addr, pmdp);
-		if (pmd_dirty(*pmdp))
+		old = pmdp_invalidate(vma, addr, pmdp);
+		if (pmd_dirty(old))
 			pmd = pmd_mkdirty(pmd);
-		if (pmd_young(*pmdp))
+		if (pmd_young(old))
 			pmd = pmd_mkyoung(pmd);
 
 		pmd = pmd_wrprotect(pmd);
diff -puN mm/huge_memory.c~mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits mm/huge_memory.c
--- a/mm/huge_memory.c~mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits
+++ a/mm/huge_memory.c
@@ -1910,17 +1910,7 @@ int change_huge_pmd(struct vm_area_struc
 	 * pmdp_invalidate() is required to make sure we don't miss
 	 * dirty/young flags set by hardware.
 	 */
-	entry = *pmd;
-	pmdp_invalidate(vma, addr, pmd);
-
-	/*
-	 * Recover dirty/young flags.  It relies on pmdp_invalidate to not
-	 * corrupt them.
-	 */
-	if (pmd_dirty(*pmd))
-		entry = pmd_mkdirty(entry);
-	if (pmd_young(*pmd))
-		entry = pmd_mkyoung(entry);
+	entry = pmdp_invalidate(vma, addr, pmd);
 
 	entry = pmd_modify(entry, newprot);
 	if (preserve_write)
@@ -2073,8 +2063,8 @@ static void __split_huge_pmd_locked(stru
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
 	pgtable_t pgtable;
-	pmd_t _pmd;
-	bool young, write, dirty, soft_dirty, pmd_migration = false;
+	pmd_t old, _pmd;
+	bool young, write, soft_dirty, pmd_migration = false;
 	unsigned long addr;
 	int i;
 
@@ -2130,7 +2120,6 @@ static void __split_huge_pmd_locked(stru
 	page_ref_add(page, HPAGE_PMD_NR - 1);
 	write = pmd_write(*pmd);
 	young = pmd_young(*pmd);
-	dirty = pmd_dirty(*pmd);
 	soft_dirty = pmd_soft_dirty(*pmd);
 
 	pmdp_huge_split_prepare(vma, haddr, pmd);
@@ -2160,8 +2149,6 @@ static void __split_huge_pmd_locked(stru
 			if (soft_dirty)
 				entry = pte_mksoft_dirty(entry);
 		}
-		if (dirty)
-			SetPageDirty(page + i);
 		pte = pte_offset_map(&_pmd, addr);
 		BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, addr, pte, entry);
@@ -2209,7 +2196,15 @@ static void __split_huge_pmd_locked(stru
 	 * for this pmd), then we flush the SMP TLB and finally we write the
 	 * non-huge version of the pmd entry with pmd_populate.
 	 */
-	pmdp_invalidate(vma, haddr, pmd);
+	old = pmdp_invalidate(vma, haddr, pmd);
+
+	/*
+	 * Transfer dirty bit using value returned by pmd_invalidate() to be
+	 * sure we don't race with CPU that can set the bit under us.
+	 */
+	if (pmd_dirty(old))
+		SetPageDirty(page);
+
 	pmd_populate(mm, pmd, pgtable);
 
 	if (freeze) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


