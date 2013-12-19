From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch
 removed from -mm tree
Date: Thu, 19 Dec 2013 11:53:45 -0800
Message-ID: <52b34ec9.Bz6+F5pKlE635vmz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3LSTxq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:53:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mgorman@suse.de, athorlton@sgi.com, riel@redhat.com

Subject: [merged] mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch removed from -mm tree
To: riel@redhat.com,athorlton@sgi.com,mgorman@suse.de,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:53:45 -0800


The patch titled
     Subject: mm: fix TLB flush race between migration, and change_protection_range
has been removed from the -mm tree.  Its filename was
     mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: fix TLB flush race between migration, and change_protection_range

There are a few subtle races, between change_protection_range (used by
mprotect and change_prot_numa) on one side, and NUMA page migration and
compaction on the other side.

The basic race is that there is a time window between when the PTE gets
made non-present (PROT_NONE or NUMA), and the TLB is flushed.

During that time, a CPU may continue writing to the page.

This is fine most of the time, however compaction or the NUMA migration
code may come in, and migrate the page away.

When that happens, the CPU may continue writing, through the cached
translation, to what is no longer the current memory location of the
process.

This only affects x86, which has a somewhat optimistic pte_accessible. 
All other architectures appear to be safe, and will either always flush,
or flush whenever there is a valid mapping, even with no permissions
(SPARC).

The basic race looks like this:

CPU A			CPU B			CPU C

						load TLB entry
make entry PTE/PMD_NUMA
			fault on entry
						read/write old page
			start migrating page
			change PTE/PMD to new page
						read/write old page [*]
flush TLB
						reload TLB from new entry
						read/write new page
						lose data

[*] the old page may belong to a new user at this point!

The obvious fix is to flush remote TLB entries, by making sure that
pte_accessible aware of the fact that PROT_NONE and PROT_NUMA memory may
still be accessible if there is a TLB flush pending for the mm.

This should fix both NUMA migration and compaction.

[mgorman@suse.de: fix build]
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    4 +-
 arch/x86/include/asm/pgtable.h      |   11 +++++-
 include/asm-generic/pgtable.h       |    2 -
 include/linux/mm_types.h            |   44 ++++++++++++++++++++++++++
 kernel/fork.c                       |    1 
 mm/huge_memory.c                    |    7 ++++
 mm/mprotect.c                       |    2 +
 mm/pgtable-generic.c                |    5 +-
 8 files changed, 69 insertions(+), 7 deletions(-)

diff -puN arch/sparc/include/asm/pgtable_64.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -619,7 +619,7 @@ static inline unsigned long pte_present(
 }
 
 #define pte_accessible pte_accessible
-static inline unsigned long pte_accessible(pte_t a)
+static inline unsigned long pte_accessible(struct mm_struct *mm, pte_t a)
 {
 	return pte_val(a) & _PAGE_VALID;
 }
@@ -847,7 +847,7 @@ static inline void __set_pte_at(struct m
 	 * SUN4V NOTE: _PAGE_VALID is the same value in both the SUN4U
 	 *             and SUN4V pte layout, so this inline test is fine.
 	 */
-	if (likely(mm != &init_mm) && pte_accessible(orig))
+	if (likely(mm != &init_mm) && pte_accessible(mm, orig))
 		tlb_batch_add(mm, addr, ptep, orig, fullmm);
 }
 
diff -puN arch/x86/include/asm/pgtable.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range
+++ a/arch/x86/include/asm/pgtable.h
@@ -452,9 +452,16 @@ static inline int pte_present(pte_t a)
 }
 
 #define pte_accessible pte_accessible
-static inline int pte_accessible(pte_t a)
+static inline bool pte_accessible(struct mm_struct *mm, pte_t a)
 {
-	return pte_flags(a) & _PAGE_PRESENT;
+	if (pte_flags(a) & _PAGE_PRESENT)
+		return true;
+
+	if ((pte_flags(a) & (_PAGE_PROTNONE | _PAGE_NUMA)) &&
+			mm_tlb_flush_pending(mm))
+		return true;
+
+	return false;
 }
 
 static inline int pte_hidden(pte_t pte)
diff -puN include/asm-generic/pgtable.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range
+++ a/include/asm-generic/pgtable.h
@@ -217,7 +217,7 @@ static inline int pmd_same(pmd_t pmd_a,
 #endif
 
 #ifndef pte_accessible
-# define pte_accessible(pte)		((void)(pte),1)
+# define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
 
 #ifndef flush_tlb_fix_spurious_fault
diff -puN include/linux/mm_types.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-fix-tlb-flush-race-between-migration-and-change_protection_range
+++ a/include/linux/mm_types.h
@@ -443,6 +443,14 @@ struct mm_struct {
 	/* numa_scan_seq prevents two threads setting pte_numa */
 	int numa_scan_seq;
 #endif
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+	/*
+	 * An operation with batched TLB flushing is going on. Anything that
+	 * can move process memory needs to flush the TLB when moving a
+	 * PROT_NONE or PROT_NUMA mapped page.
+	 */
+	bool tlb_flush_pending;
+#endif
 	struct uprobes_state uprobes_state;
 };
 
@@ -459,4 +467,40 @@ static inline cpumask_t *mm_cpumask(stru
 	return mm->cpu_vm_mask_var;
 }
 
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
+/*
+ * Memory barriers to keep this state in sync are graciously provided by
+ * the page table locks, outside of which no page table modifications happen.
+ * The barriers below prevent the compiler from re-ordering the instructions
+ * around the memory barriers that are already present in the code.
+ */
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+{
+	barrier();
+	return mm->tlb_flush_pending;
+}
+static inline void set_tlb_flush_pending(struct mm_struct *mm)
+{
+	mm->tlb_flush_pending = true;
+	barrier();
+}
+/* Clearing is done after a TLB flush, which also provides a barrier. */
+static inline void clear_tlb_flush_pending(struct mm_struct *mm)
+{
+	barrier();
+	mm->tlb_flush_pending = false;
+}
+#else
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+{
+	return false;
+}
+static inline void set_tlb_flush_pending(struct mm_struct *mm)
+{
+}
+static inline void clear_tlb_flush_pending(struct mm_struct *mm)
+{
+}
+#endif
+
 #endif /* _LINUX_MM_TYPES_H */
diff -puN kernel/fork.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range kernel/fork.c
--- a/kernel/fork.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range
+++ a/kernel/fork.c
@@ -537,6 +537,7 @@ static struct mm_struct *mm_init(struct
 	spin_lock_init(&mm->page_table_lock);
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	clear_tlb_flush_pending(mm);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
diff -puN mm/huge_memory.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range mm/huge_memory.c
--- a/mm/huge_memory.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range
+++ a/mm/huge_memory.c
@@ -1377,6 +1377,13 @@ int do_huge_pmd_numa_page(struct mm_stru
 	}
 
 	/*
+	 * The page_table_lock above provides a memory barrier
+	 * with change_protection_range.
+	 */
+	if (mm_tlb_flush_pending(mm))
+		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+
+	/*
 	 * Migrate the THP to the requested node, returns with page unlocked
 	 * and pmd_numa cleared.
 	 */
diff -puN mm/mprotect.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range mm/mprotect.c
--- a/mm/mprotect.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range
+++ a/mm/mprotect.c
@@ -188,6 +188,7 @@ static unsigned long change_protection_r
 	BUG_ON(addr >= end);
 	pgd = pgd_offset(mm, addr);
 	flush_cache_range(vma, addr, end);
+	set_tlb_flush_pending(mm);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
@@ -199,6 +200,7 @@ static unsigned long change_protection_r
 	/* Only flush the TLB if we actually modified any entries: */
 	if (pages)
 		flush_tlb_range(vma, start, end);
+	clear_tlb_flush_pending(mm);
 
 	return pages;
 }
diff -puN mm/pgtable-generic.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-fix-tlb-flush-race-between-migration-and-change_protection_range
+++ a/mm/pgtable-generic.c
@@ -110,9 +110,10 @@ int pmdp_clear_flush_young(struct vm_are
 pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
 		       pte_t *ptep)
 {
+	struct mm_struct *mm = (vma)->vm_mm;
 	pte_t pte;
-	pte = ptep_get_and_clear((vma)->vm_mm, address, ptep);
-	if (pte_accessible(pte))
+	pte = ptep_get_and_clear(mm, address, ptep);
+	if (pte_accessible(mm, pte))
 		flush_tlb_page(vma, address);
 	return pte;
 }
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered.patch
mm-munlock-fix-a-bug-where-thp-tail-page-is-encountered-v2.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
mm-fix-use-after-free-in-sys_remap_file_pages.patch
mmnumathp-initialize-hstate-for-thp-page-size.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
proc-meminfo-provide-estimated-available-memory.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-numa-make-numa-migrate-related-functions-static.patch
mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch
mm-numa-do-not-automatically-migrate-ksm-pages.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
mm-migratec-fix-set-cpupid-on-page-migration-twice-against-thp.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

