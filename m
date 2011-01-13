From: akpm@linux-foundation.org
Subject: [folded] thp-pte-alloc-trans-splitting-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:31:06 -0800
Message-ID: <201101132331.p0DNV6B3007179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142Ab1AMXbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:31:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp-pte-alloc-trans-splitting-fix
has been removed from the -mm tree.  Its filename was
     thp-pte-alloc-trans-splitting-fix.patch

This patch was dropped because it was folded into thp-pte-alloc-trans-splitting.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp-pte-alloc-trans-splitting-fix
From: Andrea Arcangeli <aarcange@redhat.com>

vma can be NULL safely for archs not implementing THP.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/pgd.c           |    2 +-
 arch/ia64/mm/hugetlbpage.c  |    2 +-
 arch/sh/mm/hugetlbpage.c    |    2 +-
 arch/sparc/mm/generic_32.c  |    2 +-
 arch/sparc/mm/generic_64.c  |    2 +-
 arch/sparc/mm/hugetlbpage.c |    2 +-
 arch/um/kernel/skas/mmu.c   |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/arm/mm/pgd.c~thp-pte-alloc-trans-splitting-fix arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~thp-pte-alloc-trans-splitting-fix
+++ a/arch/arm/mm/pgd.c
@@ -50,7 +50,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 		if (!new_pmd)
 			goto no_pmd;
 
-		new_pte = pte_alloc_map(mm, new_pmd, 0);
+		new_pte = pte_alloc_map(mm, NULL, new_pmd, 0);
 		if (!new_pte)
 			goto no_pte;
 
diff -puN arch/ia64/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting-fix arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting-fix
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -38,7 +38,7 @@ huge_pte_alloc(struct mm_struct *mm, uns
 	if (pud) {
 		pmd = pmd_alloc(mm, pud, taddr);
 		if (pmd)
-			pte = pte_alloc_map(mm, pmd, taddr);
+			pte = pte_alloc_map(mm, NULL, pmd, taddr);
 	}
 	return pte;
 }
diff -puN arch/sh/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting-fix arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting-fix
+++ a/arch/sh/mm/hugetlbpage.c
@@ -35,7 +35,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		if (pud) {
 			pmd = pmd_alloc(mm, pud, addr);
 			if (pmd)
-				pte = pte_alloc_map(mm, pmd, addr);
+				pte = pte_alloc_map(mm, NULL, pmd, addr);
 		}
 	}
 
diff -puN arch/sparc/mm/generic_32.c~thp-pte-alloc-trans-splitting-fix arch/sparc/mm/generic_32.c
--- a/arch/sparc/mm/generic_32.c~thp-pte-alloc-trans-splitting-fix
+++ a/arch/sparc/mm/generic_32.c
@@ -50,7 +50,7 @@ static inline int io_remap_pmd_range(str
 		end = PGDIR_SIZE;
 	offset -= address;
 	do {
-		pte_t * pte = pte_alloc_map(mm, pmd, address);
+		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);
 		if (!pte)
 			return -ENOMEM;
 		io_remap_pte_range(mm, pte, address, end - address, address + offset, prot, space);
diff -puN arch/sparc/mm/generic_64.c~thp-pte-alloc-trans-splitting-fix arch/sparc/mm/generic_64.c
--- a/arch/sparc/mm/generic_64.c~thp-pte-alloc-trans-splitting-fix
+++ a/arch/sparc/mm/generic_64.c
@@ -92,7 +92,7 @@ static inline int io_remap_pmd_range(str
 		end = PGDIR_SIZE;
 	offset -= address;
 	do {
-		pte_t * pte = pte_alloc_map(mm, pmd, address);
+		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);
 		if (!pte)
 			return -ENOMEM;
 		io_remap_pte_range(mm, pte, address, end - address, address + offset, prot, space);
diff -puN arch/sparc/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting-fix arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~thp-pte-alloc-trans-splitting-fix
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -214,7 +214,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	if (pud) {
 		pmd = pmd_alloc(mm, pud, addr);
 		if (pmd)
-			pte = pte_alloc_map(mm, pmd, addr);
+			pte = pte_alloc_map(mm, NULL, pmd, addr);
 	}
 	return pte;
 }
diff -puN arch/um/kernel/skas/mmu.c~thp-pte-alloc-trans-splitting-fix arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~thp-pte-alloc-trans-splitting-fix
+++ a/arch/um/kernel/skas/mmu.c
@@ -31,7 +31,7 @@ static int init_stub_pte(struct mm_struc
 	if (!pmd)
 		goto out_pmd;
 
-	pte = pte_alloc_map(mm, pmd, proc);
+	pte = pte_alloc_map(mm, NULL, pmd, proc);
 	if (!pte)
 		goto out_pte;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
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
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-kvm-mmu-transparent-hugepage-support.patch
thp-kvm-mmu-transparent-hugepage-support-fix.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-transparent-hugepage-core-fixlet.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
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
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode-fix.patch
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
thp-compound_trans_order-fix.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
thp-ksm-on-thp.patch
thp-add-compound_trans_head-helper.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix.patch
hugetlb-fix-handling-of-parse-errors-in-sysfs.patch
ksm-drain-pagevecs-to-lru.patch

