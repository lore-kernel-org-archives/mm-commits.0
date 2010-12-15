From: akpm@linux-foundation.org
Subject: + thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:57 -0800
Message-ID: <201012152357.oBFNvvvi013658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755910Ab0LOX6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: avoid breaking huge pmd invariants in case of vma_adjust failures
has been added to the -mm tree.  Its filename is
     thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: avoid breaking huge pmd invariants in case of vma_adjust failures
From: Andrea Arcangeli <aarcange@redhat.com>

An huge pmd can only be mapped if the corresponding 2M virtual range is
fully contained in the vma.  At times the VM calls split_vma twice, if the
first split_vma succeeds and the second fail, the first split_vma remains
in effect and it's not rolled back.  For split_vma or vma_adjust to fail
an allocation failure is needed so it's a very unlikely event (the out of
memory killer would normally fire before any allocation failure is visible
to kernel and userland and if an out of memory condition happens it's
unlikely to happen exactly here).  Nevertheless it's safer to ensure that
no huge pmd can be left around if the vma is adjusted in a way that can't
fit hugepages anymore at the new vm_start/vm_end address.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   19 +++++++++
 mm/huge_memory.c        |   80 +++++++++++++++++++++++++++++++++++++-
 mm/mmap.c               |    2 
 3 files changed, 99 insertions(+), 2 deletions(-)

diff -puN include/linux/huge_mm.h~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures
+++ a/include/linux/huge_mm.h
@@ -104,6 +104,19 @@ extern void __split_huge_page_pmd(struct
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
 extern int hugepage_madvise(unsigned long *vm_flags);
+extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+				    unsigned long start,
+				    unsigned long end,
+				    long adjust_next);
+static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
+					 unsigned long start,
+					 unsigned long end,
+					 long adjust_next)
+{
+	if (!vma->anon_vma || vma->vm_ops || vma->vm_file)
+		return;
+	__vma_adjust_trans_huge(vma, start, end, adjust_next);
+}
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUG(); 0; })
@@ -125,6 +138,12 @@ static inline int hugepage_madvise(unsig
 	BUG();
 	return 0;
 }
+static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
+					 unsigned long start,
+					 unsigned long end,
+					 long adjust_next)
+{
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff -puN mm/huge_memory.c~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures mm/huge_memory.c
--- a/mm/huge_memory.c~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures
+++ a/mm/huge_memory.c
@@ -1075,8 +1075,16 @@ pmd_t *page_check_address_pmd(struct pag
 		goto out;
 	if (pmd_page(*pmd) != page)
 		goto out;
-	VM_BUG_ON(flag == PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG &&
-		  pmd_trans_splitting(*pmd));
+	/*
+	 * split_vma() may create temporary aliased mappings. There is
+	 * no risk as long as all huge pmd are found and have their
+	 * splitting bit set before __split_huge_page_refcount
+	 * runs. Finding the same huge pmd more than once during the
+	 * same rmap walk is not a problem.
+	 */
+	if (flag == PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG &&
+	    pmd_trans_splitting(*pmd))
+		goto out;
 	if (pmd_trans_huge(*pmd)) {
 		VM_BUG_ON(flag == PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG &&
 			  !pmd_trans_splitting(*pmd));
@@ -2196,3 +2204,71 @@ void __split_huge_page_pmd(struct mm_str
 	put_page(page);
 	BUG_ON(pmd_trans_huge(*pmd));
 }
+
+static void split_huge_page_address(struct mm_struct *mm,
+				    unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		return;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
+		return;
+	/*
+	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
+	 * materialize from under us.
+	 */
+	split_huge_page_pmd(mm, pmd);
+}
+
+void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+			     unsigned long start,
+			     unsigned long end,
+			     long adjust_next)
+{
+	/*
+	 * If the new start address isn't hpage aligned and it could
+	 * previously contain an hugepage: check if we need to split
+	 * an huge pmd.
+	 */
+	if (start & ~HPAGE_PMD_MASK &&
+	    (start & HPAGE_PMD_MASK) >= vma->vm_start &&
+	    (start & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
+		split_huge_page_address(vma->vm_mm, start);
+
+	/*
+	 * If the new end address isn't hpage aligned and it could
+	 * previously contain an hugepage: check if we need to split
+	 * an huge pmd.
+	 */
+	if (end & ~HPAGE_PMD_MASK &&
+	    (end & HPAGE_PMD_MASK) >= vma->vm_start &&
+	    (end & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
+		split_huge_page_address(vma->vm_mm, end);
+
+	/*
+	 * If we're also updating the vma->vm_next->vm_start, if the new
+	 * vm_next->vm_start isn't page aligned and it could previously
+	 * contain an hugepage: check if we need to split an huge pmd.
+	 */
+	if (adjust_next > 0) {
+		struct vm_area_struct *next = vma->vm_next;
+		unsigned long nstart = next->vm_start;
+		nstart += adjust_next << PAGE_SHIFT;
+		if (nstart & ~HPAGE_PMD_MASK &&
+		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
+		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
+			split_huge_page_address(next->vm_mm, nstart);
+	}
+}
diff -puN mm/mmap.c~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures mm/mmap.c
--- a/mm/mmap.c~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures
+++ a/mm/mmap.c
@@ -589,6 +589,8 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
+	vma_adjust_trans_huge(vma, start, end, adjust_next);
+
 	/*
 	 * When changing only vma->vm_end, we don't really need anon_vma
 	 * lock. This is a fairly rare case by itself, but the anon_vma
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

