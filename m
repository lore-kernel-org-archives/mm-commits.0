From: akpm@linux-foundation.org
Subject: + thp-khugepaged-make-khugepaged-aware-of-madvise.patch added to -mm tree
Date: Wed, 22 Dec 2010 14:05:57 -0800
Message-ID: <201012222205.oBMM5vNn022052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751637Ab0LVWGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 17:06:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: khugepaged: make khugepaged aware about madvise
has been added to the -mm tree.  Its filename is
     thp-khugepaged-make-khugepaged-aware-of-madvise.patch

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
Subject: thp: khugepaged: make khugepaged aware about madvise
From: Andrea Arcangeli <aarcange@redhat.com>

MADV_HUGEPAGE and MADV_NOHUGEPAGE were fully effective only if run after
mmap and before touching the memory.  While this is enough for most
usages, it's little effort to make madvise more dynamic at runtime on an
existing mapping by making khugepaged aware about madvise.

MADV_HUGEPAGE: register in khugepaged immediately without waiting a page
fault (that may not ever happen if all pages are already mapped and the
"enabled" knob was set to madvise during the initial page faults).

MADV_NOHUGEPAGE: skip vmas marked VM_NOHUGEPAGE in khugepaged to stop
collapsing pages where not needed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ++++--
 mm/huge_memory.c        |   24 ++++++++++++++++++++----
 mm/madvise.c            |    2 +-
 3 files changed, 25 insertions(+), 7 deletions(-)

diff -puN include/linux/huge_mm.h~thp-khugepaged-make-khugepaged-aware-of-madvise include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-khugepaged-make-khugepaged-aware-of-madvise
+++ a/include/linux/huge_mm.h
@@ -105,7 +105,8 @@ extern void __split_huge_page_pmd(struct
 #if HPAGE_PMD_ORDER > MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
-extern int hugepage_madvise(unsigned long *vm_flags, int advice);
+extern int hugepage_madvise(struct vm_area_struct *vma,
+			    unsigned long *vm_flags, int advice);
 extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
 				    unsigned long start,
 				    unsigned long end,
@@ -143,7 +144,8 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
-static inline int hugepage_madvise(unsigned long *vm_flags, int advice)
+static inline int hugepage_madvise(struct vm_area_struct *vma,
+				   unsigned long *vm_flags, int advice)
 {
 	BUG();
 	return 0;
diff -puN mm/huge_memory.c~thp-khugepaged-make-khugepaged-aware-of-madvise mm/huge_memory.c
--- a/mm/huge_memory.c~thp-khugepaged-make-khugepaged-aware-of-madvise
+++ a/mm/huge_memory.c
@@ -1389,7 +1389,8 @@ out:
 	return ret;
 }
 
-int hugepage_madvise(unsigned long *vm_flags, int advice)
+int hugepage_madvise(struct vm_area_struct *vma,
+		     unsigned long *vm_flags, int advice)
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
@@ -1404,6 +1405,13 @@ int hugepage_madvise(unsigned long *vm_f
 			return -EINVAL;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
+		/*
+		 * If the vma become good for khugepaged to scan,
+		 * register it here without waiting a page fault that
+		 * may not happen any time soon.
+		 */
+		if (unlikely(khugepaged_enter_vma_merge(vma)))
+			return -ENOMEM;
 		break;
 	case MADV_NOHUGEPAGE:
 		/*
@@ -1417,6 +1425,12 @@ int hugepage_madvise(unsigned long *vm_f
 			return -EINVAL;
 		*vm_flags &= ~VM_HUGEPAGE;
 		*vm_flags |= VM_NOHUGEPAGE;
+		/*
+		 * Setting VM_NOHUGEPAGE will prevent khugepaged to
+		 * scan this vma even if we leave the mm registered in
+		 * khugepaged if it got registered before
+		 * VM_NOHUGEPAGE was set.
+		 */
 		break;
 	}
 
@@ -1784,7 +1798,8 @@ static void collapse_huge_page(struct mm
 	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
 		goto out;
 
-	if (!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always())
+	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
+	    (vma->vm_flags & VM_NOHUGEPAGE))
 		goto out;
 
 	/* VM_PFNMAP vmas may have vm_ops null but vm_file set */
@@ -2007,8 +2022,9 @@ static unsigned int khugepaged_scan_mm_s
 			break;
 		}
 
-		if (!(vma->vm_flags & VM_HUGEPAGE) &&
-		    !khugepaged_always()) {
+		if ((!(vma->vm_flags & VM_HUGEPAGE) &&
+		     !khugepaged_always()) ||
+		    (vma->vm_flags & VM_NOHUGEPAGE)) {
 			progress++;
 			continue;
 		}
diff -puN mm/madvise.c~thp-khugepaged-make-khugepaged-aware-of-madvise mm/madvise.c
--- a/mm/madvise.c~thp-khugepaged-make-khugepaged-aware-of-madvise
+++ a/mm/madvise.c
@@ -73,7 +73,7 @@ static long madvise_behavior(struct vm_a
 		break;
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
-		error = hugepage_madvise(&new_flags, behavior);
+		error = hugepage_madvise(vma, &new_flags, behavior);
 		if (error)
 			goto out;
 		break;
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
thp-config_transparent_hugepage-fix.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-pte-alloc-trans-splitting-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
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
thp-compound_trans_order-fix.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch

