From: akpm@linux-foundation.org
Subject: [merged]
 mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:38:29 -0700
Message-ID: <20170911193829.jkJOTh6mC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdIKTic (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm: soft-dirty: keep soft-dirty bits over thp migration
has been removed from the -mm tree.  Its filename was
     mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: soft-dirty: keep soft-dirty bits over thp migration

Soft dirty bit is designed to keep tracked over page migration.  This
patch makes it work in the same manner for thp migration too.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   17 +++++++++++++++
 fs/proc/task_mmu.c             |   23 ++++++++++++--------
 include/asm-generic/pgtable.h  |   34 ++++++++++++++++++++++++++++++-
 include/linux/swapops.h        |    2 +
 mm/huge_memory.c               |   27 +++++++++++++++++++++---
 5 files changed, 90 insertions(+), 13 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration
+++ a/arch/x86/include/asm/pgtable.h
@@ -1172,6 +1172,23 @@ static inline pte_t pte_swp_clear_soft_d
 {
 	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
 }
+
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SWP_SOFT_DIRTY);
+}
+
+static inline int pmd_swp_soft_dirty(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SWP_SOFT_DIRTY;
+}
+
+static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_SWP_SOFT_DIRTY);
+}
+#endif
 #endif
 
 #define PKRU_AD_BIT 0x1
diff -puN fs/proc/task_mmu.c~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration
+++ a/fs/proc/task_mmu.c
@@ -978,17 +978,22 @@ static inline void clear_soft_dirty_pmd(
 {
 	pmd_t pmd = *pmdp;
 
-	/* See comment in change_huge_pmd() */
-	pmdp_invalidate(vma, addr, pmdp);
-	if (pmd_dirty(*pmdp))
-		pmd = pmd_mkdirty(pmd);
-	if (pmd_young(*pmdp))
-		pmd = pmd_mkyoung(pmd);
+	if (pmd_present(pmd)) {
+		/* See comment in change_huge_pmd() */
+		pmdp_invalidate(vma, addr, pmdp);
+		if (pmd_dirty(*pmdp))
+			pmd = pmd_mkdirty(pmd);
+		if (pmd_young(*pmdp))
+			pmd = pmd_mkyoung(pmd);
 
-	pmd = pmd_wrprotect(pmd);
-	pmd = pmd_clear_soft_dirty(pmd);
+		pmd = pmd_wrprotect(pmd);
+		pmd = pmd_clear_soft_dirty(pmd);
 
-	set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
+		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
+	} else if (is_migration_entry(pmd_to_swp_entry(pmd))) {
+		pmd = pmd_swp_clear_soft_dirty(pmd);
+		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
+	}
 }
 #else
 static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
diff -puN include/asm-generic/pgtable.h~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration
+++ a/include/asm-generic/pgtable.h
@@ -630,7 +630,24 @@ static inline void ptep_modify_prot_comm
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
-#ifndef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline int pmd_swp_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+#else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return 0;
@@ -675,6 +692,21 @@ static inline pte_t pte_swp_clear_soft_d
 {
 	return pte;
 }
+
+static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline int pmd_swp_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
 #endif
 
 #ifndef __HAVE_PFNMAP_TRACKING
diff -puN include/linux/swapops.h~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration include/linux/swapops.h
--- a/include/linux/swapops.h~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration
+++ a/include/linux/swapops.h
@@ -183,6 +183,8 @@ static inline swp_entry_t pmd_to_swp_ent
 {
 	swp_entry_t arch_entry;
 
+	if (pmd_swp_soft_dirty(pmd))
+		pmd = pmd_swp_clear_soft_dirty(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
diff -puN mm/huge_memory.c~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration mm/huge_memory.c
--- a/mm/huge_memory.c~mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration
+++ a/mm/huge_memory.c
@@ -937,6 +937,8 @@ int copy_huge_pmd(struct mm_struct *dst_
 		if (is_write_migration_entry(entry)) {
 			make_migration_entry_read(&entry);
 			pmd = swp_entry_to_pmd(entry);
+			if (pmd_swp_soft_dirty(*src_pmd))
+				pmd = pmd_swp_mksoft_dirty(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 		set_pmd_at(dst_mm, addr, dst_pmd, pmd);
@@ -1756,6 +1758,17 @@ static inline int pmd_move_must_withdraw
 }
 #endif
 
+static pmd_t move_soft_dirty_pmd(pmd_t pmd)
+{
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	if (unlikely(is_pmd_migration_entry(pmd)))
+		pmd = pmd_swp_mksoft_dirty(pmd);
+	else if (pmd_present(pmd))
+		pmd = pmd_mksoft_dirty(pmd);
+#endif
+	return pmd;
+}
+
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, unsigned long old_end,
 		  pmd_t *old_pmd, pmd_t *new_pmd, bool *need_flush)
@@ -1798,7 +1811,8 @@ bool move_huge_pmd(struct vm_area_struct
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
-		set_pmd_at(mm, new_addr, new_pmd, pmd_mksoft_dirty(pmd));
+		pmd = move_soft_dirty_pmd(pmd);
+		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (new_ptl != old_ptl)
 			spin_unlock(new_ptl);
 		if (force_flush)
@@ -1846,6 +1860,8 @@ int change_huge_pmd(struct vm_area_struc
 			 */
 			make_migration_entry_read(&entry);
 			newpmd = swp_entry_to_pmd(entry);
+			if (pmd_swp_soft_dirty(*pmd))
+				newpmd = pmd_swp_mksoft_dirty(newpmd);
 			set_pmd_at(mm, addr, pmd, newpmd);
 		}
 		goto unlock;
@@ -2824,6 +2840,7 @@ void set_pmd_migration_entry(struct page
 	unsigned long address = pvmw->address;
 	pmd_t pmdval;
 	swp_entry_t entry;
+	pmd_t pmdswp;
 
 	if (!(pvmw->pmd && !pvmw->pte))
 		return;
@@ -2837,8 +2854,10 @@ void set_pmd_migration_entry(struct page
 	if (pmd_dirty(pmdval))
 		set_page_dirty(page);
 	entry = make_migration_entry(page, pmd_write(pmdval));
-	pmdval = swp_entry_to_pmd(entry);
-	set_pmd_at(mm, address, pvmw->pmd, pmdval);
+	pmdswp = swp_entry_to_pmd(entry);
+	if (pmd_soft_dirty(pmdval))
+		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, true);
 	put_page(page);
 
@@ -2861,6 +2880,8 @@ void remove_migration_pmd(struct page_vm
 	entry = pmd_to_swp_entry(*pvmw->pmd);
 	get_page(new);
 	pmde = pmd_mkold(mk_huge_pmd(new, vma->vm_page_prot));
+	if (pmd_swp_soft_dirty(*pvmw->pmd))
+		pmde = pmd_mksoft_dirty(pmde);
 	if (is_write_migration_entry(entry))
 		pmde = maybe_pmd_mkwrite(pmde, vma);
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


