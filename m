From: akpm@linux-foundation.org
Subject: + thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch added to -mm tree
Date: Tue, 21 Dec 2010 14:08:24 -0800
Message-ID: <201012212208.oBLM8PIX028845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab0LUWJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 17:09:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um
has been added to the -mm tree.  Its filename is
     thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch

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
Subject: thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um
From: Andrea Arcangeli <aarcange@redhat.com>

Hi everyone,

On Fri, Dec 17, 2010 at 04:58:34PM -0800, Andrew Morton wrote:
> The first one millionth:
>
> include/asm-generic/pgtable.h: In function 'ptep_get_and_clear':
> include/asm-generic/pgtable.h:77: error: expected statement before ')' token
> include/asm-generic/pgtable.h:94: error: invalid storage class for function 'pmdp_get_and_clear'
>
> Due to thp-add-pmd-mangling-generic-functions.patch

Here two fixes for the um build.

This is thp-add-pmd-mangling-generic-functions-fix.patch. I hope I'm
not asking for more build troubles down the road insisting on inline
and returning (pmd_t) { 0 } instead of converting it back to a
preprocessor macro.

========
Subject: thp: fix pgtable.h build for um


make ARCH=um failed because of some typo error in newly written code to cleanup
asm-generic/pgtable.h but that was never compiled in on x86/x64 without um.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    4 ++--
 mm/pgtable-generic.c          |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-generic/pgtable.h~thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um
+++ a/include/asm-generic/pgtable.h
@@ -74,7 +74,7 @@ static inline pte_t ptep_get_and_clear(s
 	pte_t pte = *ptep;
 	pte_clear(mm, address, ptep);
 	return pte;
-)
+}
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_GET_AND_CLEAR
@@ -93,7 +93,7 @@ static inline pmd_t pmdp_get_and_clear(s
 				       pmd_t *pmdp)
 {
 	BUG();
-	return 0;
+	return (pmd_t){ 0 };
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
diff -puN mm/pgtable-generic.c~thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um
+++ a/mm/pgtable-generic.c
@@ -29,7 +29,7 @@ int ptep_set_access_flags(struct vm_area
 		flush_tlb_page(vma, address);
 	}
 	return changed;
-})
+}
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
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
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-kvm-mmu-transparent-hugepage-support.patch
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
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

