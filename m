From: akpm@linux-foundation.org
Subject: [patch 005/126] mm: thp: enable thp migration in generic
 path
Date: Fri, 08 Sep 2017 16:10:57 -0700
Message-ID: <20170908231057.tvr6Y574-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757262AbdIHXK7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, zi.yan@cs.rutgers.edu

From: Zi Yan <zi.yan@cs.rutgers.edu>
Subject: mm: thp: enable thp migration in generic path

Add thp migration's core code, including conversions between a PMD entry
and a swap entry, setting PMD migration entry, removing PMD migration
entry, and waiting on PMD migration entries.

This patch makes it possible to support thp migration.  If you fail to
allocate a destination page as a thp, you just split the source thp as we
do now, and then enter the normal page migration.  If you succeed to
allocate destination thp, you enter thp migration.  Subsequent patches
actually enable thp migration for each caller of page migration by
allowing its get_new_page() callback to allocate thps.

[zi.yan@cs.rutgers.edu: fix gcc-4.9.0 -Wmissing-braces warning]
  Link: http://lkml.kernel.org/r/A0ABA698-7486-46C3-B209-E95A9048B22C@cs.rutgers.edu
[akpm@linux-foundation.org: fix x86_64 allnoconfig warning]
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_64.h |    2 
 include/linux/swapops.h           |   73 +++++++++++++++++++++++-
 mm/huge_memory.c                  |   84 ++++++++++++++++++++++++++--
 mm/migrate.c                      |   32 ++++++++++
 mm/page_vma_mapped.c              |   18 +++++-
 mm/pgtable-generic.c              |    3 -
 mm/rmap.c                         |   13 ++++
 7 files changed, 212 insertions(+), 13 deletions(-)

diff -puN arch/x86/include/asm/pgtable_64.h~mm-thp-enable-thp-migration-in-generic-path arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~mm-thp-enable-thp-migration-in-generic-path
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -210,7 +210,9 @@ static inline int pgd_large(pgd_t pgd) {
 					 ((type) << (SWP_TYPE_FIRST_BIT)) \
 					 | ((offset) << SWP_OFFSET_FIRST_BIT) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val((pte)) })
+#define __pmd_to_swp_entry(pmd)		((swp_entry_t) { pmd_val((pmd)) })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
+#define __swp_entry_to_pmd(x)		((pmd_t) { .pmd = (x).val })
 
 extern int kern_addr_valid(unsigned long addr);
 extern void cleanup_highmap(void);
diff -puN include/linux/swapops.h~mm-thp-enable-thp-migration-in-generic-path include/linux/swapops.h
--- a/include/linux/swapops.h~mm-thp-enable-thp-migration-in-generic-path
+++ a/include/linux/swapops.h
@@ -103,7 +103,8 @@ static inline void *swp_to_radix_entry(s
 #ifdef CONFIG_MIGRATION
 static inline swp_entry_t make_migration_entry(struct page *page, int write)
 {
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!PageLocked(compound_head(page)));
+
 	return swp_entry(write ? SWP_MIGRATION_WRITE : SWP_MIGRATION_READ,
 			page_to_pfn(page));
 }
@@ -126,7 +127,7 @@ static inline struct page *migration_ent
 	 * Any use of migration entries may only occur while the
 	 * corresponding page is locked
 	 */
-	BUG_ON(!PageLocked(p));
+	BUG_ON(!PageLocked(compound_head(p)));
 	return p;
 }
 
@@ -148,7 +149,11 @@ static inline int is_migration_entry(swp
 {
 	return 0;
 }
-#define migration_entry_to_page(swp) NULL
+static inline struct page *migration_entry_to_page(swp_entry_t entry)
+{
+	return NULL;
+}
+
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
 					spinlock_t *ptl) { }
@@ -163,6 +168,68 @@ static inline int is_write_migration_ent
 
 #endif
 
+struct page_vma_mapped_walk;
+
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+extern void set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
+		struct page *page);
+
+extern void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
+		struct page *new);
+
+extern void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd);
+
+static inline swp_entry_t pmd_to_swp_entry(pmd_t pmd)
+{
+	swp_entry_t arch_entry;
+
+	arch_entry = __pmd_to_swp_entry(pmd);
+	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
+}
+
+static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
+{
+	swp_entry_t arch_entry;
+
+	arch_entry = __swp_entry(swp_type(entry), swp_offset(entry));
+	return __swp_entry_to_pmd(arch_entry);
+}
+
+static inline int is_pmd_migration_entry(pmd_t pmd)
+{
+	return !pmd_present(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
+}
+#else
+static inline void set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
+		struct page *page)
+{
+	BUILD_BUG();
+}
+
+static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
+		struct page *new)
+{
+	BUILD_BUG();
+}
+
+static inline void pmd_migration_entry_wait(struct mm_struct *m, pmd_t *p) { }
+
+static inline swp_entry_t pmd_to_swp_entry(pmd_t pmd)
+{
+	return swp_entry(0, 0);
+}
+
+static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
+{
+	return __pmd(0);
+}
+
+static inline int is_pmd_migration_entry(pmd_t pmd)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_MEMORY_FAILURE
 
 extern atomic_long_t num_poisoned_pages __read_mostly;
diff -puN mm/huge_memory.c~mm-thp-enable-thp-migration-in-generic-path mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-enable-thp-migration-in-generic-path
+++ a/mm/huge_memory.c
@@ -1684,10 +1684,24 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else {
-		struct page *page = pmd_page(orig_pmd);
-		page_remove_rmap(page, true);
-		VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
-		VM_BUG_ON_PAGE(!PageHead(page), page);
+		struct page *page = NULL;
+		int flush_needed = 1;
+
+		if (pmd_present(orig_pmd)) {
+			page = pmd_page(orig_pmd);
+			page_remove_rmap(page, true);
+			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
+			VM_BUG_ON_PAGE(!PageHead(page), page);
+		} else if (thp_migration_supported()) {
+			swp_entry_t entry;
+
+			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
+			entry = pmd_to_swp_entry(orig_pmd);
+			page = pfn_to_page(swp_offset(entry));
+			flush_needed = 0;
+		} else
+			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+
 		if (PageAnon(page)) {
 			zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
@@ -1696,8 +1710,10 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 				zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, MM_FILEPAGES, -HPAGE_PMD_NR);
 		}
+
 		spin_unlock(ptl);
-		tlb_remove_page_size(tlb, page, HPAGE_PMD_SIZE);
+		if (flush_needed)
+			tlb_remove_page_size(tlb, page, HPAGE_PMD_SIZE);
 	}
 	return 1;
 }
@@ -2745,3 +2761,61 @@ static int __init split_huge_pages_debug
 }
 late_initcall(split_huge_pages_debugfs);
 #endif
+
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+void set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
+		struct page *page)
+{
+	struct vm_area_struct *vma = pvmw->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long address = pvmw->address;
+	pmd_t pmdval;
+	swp_entry_t entry;
+
+	if (!(pvmw->pmd && !pvmw->pte))
+		return;
+
+	mmu_notifier_invalidate_range_start(mm, address,
+			address + HPAGE_PMD_SIZE);
+
+	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
+	pmdval = *pvmw->pmd;
+	pmdp_invalidate(vma, address, pvmw->pmd);
+	if (pmd_dirty(pmdval))
+		set_page_dirty(page);
+	entry = make_migration_entry(page, pmd_write(pmdval));
+	pmdval = swp_entry_to_pmd(entry);
+	set_pmd_at(mm, address, pvmw->pmd, pmdval);
+	page_remove_rmap(page, true);
+	put_page(page);
+
+	mmu_notifier_invalidate_range_end(mm, address,
+			address + HPAGE_PMD_SIZE);
+}
+
+void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
+{
+	struct vm_area_struct *vma = pvmw->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long address = pvmw->address;
+	unsigned long mmun_start = address & HPAGE_PMD_MASK;
+	pmd_t pmde;
+	swp_entry_t entry;
+
+	if (!(pvmw->pmd && !pvmw->pte))
+		return;
+
+	entry = pmd_to_swp_entry(*pvmw->pmd);
+	get_page(new);
+	pmde = pmd_mkold(mk_huge_pmd(new, vma->vm_page_prot));
+	if (is_write_migration_entry(entry))
+		pmde = maybe_pmd_mkwrite(pmde, vma);
+
+	flush_cache_range(vma, mmun_start, mmun_start + HPAGE_PMD_SIZE);
+	page_add_anon_rmap(new, vma, mmun_start, true);
+	set_pmd_at(mm, mmun_start, pvmw->pmd, pmde);
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_vma_page(new);
+	update_mmu_cache_pmd(vma, address, pvmw->pmd);
+}
+#endif
diff -puN mm/migrate.c~mm-thp-enable-thp-migration-in-generic-path mm/migrate.c
--- a/mm/migrate.c~mm-thp-enable-thp-migration-in-generic-path
+++ a/mm/migrate.c
@@ -216,6 +216,15 @@ static bool remove_migration_pte(struct
 			new = page - pvmw.page->index +
 				linear_page_index(vma, pvmw.address);
 
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+		/* PMD-mapped THP migration entry */
+		if (!pvmw.pte) {
+			VM_BUG_ON_PAGE(PageHuge(page) || !PageTransCompound(page), page);
+			remove_migration_pmd(&pvmw, new);
+			continue;
+		}
+#endif
+
 		get_page(new);
 		pte = pte_mkold(mk_pte(new, READ_ONCE(vma->vm_page_prot)));
 		if (pte_swp_soft_dirty(*pvmw.pte))
@@ -330,6 +339,27 @@ void migration_entry_wait_huge(struct vm
 	__migration_entry_wait(mm, pte, ptl);
 }
 
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
+{
+	spinlock_t *ptl;
+	struct page *page;
+
+	ptl = pmd_lock(mm, pmd);
+	if (!is_pmd_migration_entry(*pmd))
+		goto unlock;
+	page = migration_entry_to_page(pmd_to_swp_entry(*pmd));
+	if (!get_page_unless_zero(page))
+		goto unlock;
+	spin_unlock(ptl);
+	wait_on_page_locked(page);
+	put_page(page);
+	return;
+unlock:
+	spin_unlock(ptl);
+}
+#endif
+
 #ifdef CONFIG_BLOCK
 /* Returns true if all buffers are successfully locked */
 static bool buffer_migrate_lock_buffers(struct buffer_head *head,
@@ -1088,7 +1118,7 @@ static ICE_noinline int unmap_and_move(n
 		goto out;
 	}
 
-	if (unlikely(PageTransHuge(page))) {
+	if (unlikely(PageTransHuge(page) && !PageTransHuge(newpage))) {
 		lock_page(page);
 		rc = split_huge_page(page);
 		unlock_page(page);
diff -puN mm/page_vma_mapped.c~mm-thp-enable-thp-migration-in-generic-path mm/page_vma_mapped.c
--- a/mm/page_vma_mapped.c~mm-thp-enable-thp-migration-in-generic-path
+++ a/mm/page_vma_mapped.c
@@ -138,16 +138,28 @@ restart:
 	if (!pud_present(*pud))
 		return false;
 	pvmw->pmd = pmd_offset(pud, pvmw->address);
-	if (pmd_trans_huge(*pvmw->pmd)) {
+	if (pmd_trans_huge(*pvmw->pmd) || is_pmd_migration_entry(*pvmw->pmd)) {
 		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-		if (!pmd_present(*pvmw->pmd))
-			return not_found(pvmw);
 		if (likely(pmd_trans_huge(*pvmw->pmd))) {
 			if (pvmw->flags & PVMW_MIGRATION)
 				return not_found(pvmw);
 			if (pmd_page(*pvmw->pmd) != page)
 				return not_found(pvmw);
 			return true;
+		} else if (!pmd_present(*pvmw->pmd)) {
+			if (thp_migration_supported()) {
+				if (!(pvmw->flags & PVMW_MIGRATION))
+					return not_found(pvmw);
+				if (is_migration_entry(pmd_to_swp_entry(*pvmw->pmd))) {
+					swp_entry_t entry = pmd_to_swp_entry(*pvmw->pmd);
+
+					if (migration_entry_to_page(entry) != page)
+						return not_found(pvmw);
+					return true;
+				}
+			} else
+				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+			return not_found(pvmw);
 		} else {
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
diff -puN mm/pgtable-generic.c~mm-thp-enable-thp-migration-in-generic-path mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-enable-thp-migration-in-generic-path
+++ a/mm/pgtable-generic.c
@@ -124,7 +124,8 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(!pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
+	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp) &&
+			   !pmd_devmap(*pmdp)) || !pmd_present(*pmdp));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
diff -puN mm/rmap.c~mm-thp-enable-thp-migration-in-generic-path mm/rmap.c
--- a/mm/rmap.c~mm-thp-enable-thp-migration-in-generic-path
+++ a/mm/rmap.c
@@ -1360,6 +1360,19 @@ static bool try_to_unmap_one(struct page
 	mmu_notifier_invalidate_range_start(vma->vm_mm, start, end);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+		/* PMD-mapped THP migration entry */
+		if (!pvmw.pte && (flags & TTU_MIGRATION)) {
+			VM_BUG_ON_PAGE(PageHuge(page) || !PageTransCompound(page), page);
+
+			if (!PageAnon(page))
+				continue;
+
+			set_pmd_migration_entry(&pvmw, page);
+			continue;
+		}
+#endif
+
 		/*
 		 * If the page is mlock()d, we cannot swap it out.
 		 * If it's recently referenced (perhaps page_referenced
_
