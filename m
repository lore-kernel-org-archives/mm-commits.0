From: akpm@linux-foundation.org
Subject: + thp-madvisemadv_nohugepage.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:58:25 -0800
Message-ID: <201012152358.oBFNwPfP013716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906Ab0LOX6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: madvise(MADV_NOHUGEPAGE)
has been added to the -mm tree.  Its filename is
     thp-madvisemadv_nohugepage.patch

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
Subject: thp: madvise(MADV_NOHUGEPAGE)
From: Andrea Arcangeli <aarcange@redhat.com>

Add madvise MADV_NOHUGEPAGE to mark regions that are not important to be
hugepage backed.  Return -EINVAL if the vma is not of an anonymous type,
or the feature isn't built into the kernel.  Never silently return
success.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |   14 ++++++-----
 include/linux/khugepaged.h |    7 +++--
 include/linux/mm.h         |    1 
 mm/huge_memory.c           |   41 +++++++++++++++++++++++++----------
 mm/madvise.c               |    4 ++-
 5 files changed, 46 insertions(+), 21 deletions(-)

diff -puN include/linux/huge_mm.h~thp-madvisemadv_nohugepage include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-madvisemadv_nohugepage
+++ a/include/linux/huge_mm.h
@@ -52,10 +52,12 @@ extern pmd_t *page_check_address_pmd(str
 #define HPAGE_PMD_SIZE HPAGE_SIZE
 
 #define transparent_hugepage_enabled(__vma)				\
-	(transparent_hugepage_flags & (1<<TRANSPARENT_HUGEPAGE_FLAG) ||	\
-	 (transparent_hugepage_flags &					\
-	  (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
-	  (__vma)->vm_flags & VM_HUGEPAGE))
+	((transparent_hugepage_flags &					\
+	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
+	  (transparent_hugepage_flags &					\
+	   (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
+	   ((__vma)->vm_flags & VM_HUGEPAGE))) &&			\
+	 !((__vma)->vm_flags & VM_NOHUGEPAGE))
 #define transparent_hugepage_defrag(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)) ||			\
@@ -103,7 +105,7 @@ extern void __split_huge_page_pmd(struct
 #if HPAGE_PMD_ORDER > MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
-extern int hugepage_madvise(unsigned long *vm_flags);
+extern int hugepage_madvise(unsigned long *vm_flags, int advice);
 extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
 				    unsigned long start,
 				    unsigned long end,
@@ -141,7 +143,7 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
-static inline int hugepage_madvise(unsigned long *vm_flags)
+static inline int hugepage_madvise(unsigned long *vm_flags, int advice)
 {
 	BUG();
 	return 0;
diff -puN include/linux/khugepaged.h~thp-madvisemadv_nohugepage include/linux/khugepaged.h
--- a/include/linux/khugepaged.h~thp-madvisemadv_nohugepage
+++ a/include/linux/khugepaged.h
@@ -38,9 +38,10 @@ static inline void khugepaged_exit(struc
 static inline int khugepaged_enter(struct vm_area_struct *vma)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
-		if (khugepaged_always() ||
-		    (khugepaged_req_madv() &&
-		     vma->vm_flags & VM_HUGEPAGE))
+		if ((khugepaged_always() ||
+		     (khugepaged_req_madv() &&
+		      vma->vm_flags & VM_HUGEPAGE)) &&
+		    !(vma->vm_flags & VM_NOHUGEPAGE))
 			if (__khugepaged_enter(vma->vm_mm))
 				return -ENOMEM;
 	return 0;
diff -puN include/linux/mm.h~thp-madvisemadv_nohugepage include/linux/mm.h
--- a/include/linux/mm.h~thp-madvisemadv_nohugepage
+++ a/include/linux/mm.h
@@ -83,6 +83,7 @@ extern unsigned int kobjsize(const void 
 #define VM_GROWSUP	0x00000200
 #else
 #define VM_GROWSUP	0x00000000
+#define VM_NOHUGEPAGE	0x00000200	/* MADV_NOHUGEPAGE marked this vma */
 #endif
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
diff -puN mm/huge_memory.c~thp-madvisemadv_nohugepage mm/huge_memory.c
--- a/mm/huge_memory.c~thp-madvisemadv_nohugepage
+++ a/mm/huge_memory.c
@@ -16,6 +16,7 @@
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
+#include <linux/mman.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -1388,18 +1389,36 @@ out:
 	return ret;
 }
 
-int hugepage_madvise(unsigned long *vm_flags)
+int hugepage_madvise(unsigned long *vm_flags, int advice)
 {
-	/*
-	 * Be somewhat over-protective like KSM for now!
-	 */
-	if (*vm_flags & (VM_HUGEPAGE | VM_SHARED  | VM_MAYSHARE   |
-			 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
-			 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
-			 VM_MIXEDMAP | VM_SAO))
-		return -EINVAL;
-
-	*vm_flags |= VM_HUGEPAGE;
+	switch (advice) {
+	case MADV_HUGEPAGE:
+		/*
+		 * Be somewhat over-protective like KSM for now!
+		 */
+		if (*vm_flags & (VM_HUGEPAGE |
+				 VM_SHARED   | VM_MAYSHARE   |
+				 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
+				 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
+				 VM_MIXEDMAP | VM_SAO))
+			return -EINVAL;
+		*vm_flags &= ~VM_NOHUGEPAGE;
+		*vm_flags |= VM_HUGEPAGE;
+		break;
+	case MADV_NOHUGEPAGE:
+		/*
+		 * Be somewhat over-protective like KSM for now!
+		 */
+		if (*vm_flags & (VM_NOHUGEPAGE |
+				 VM_SHARED   | VM_MAYSHARE   |
+				 VM_PFNMAP   | VM_IO      | VM_DONTEXPAND |
+				 VM_RESERVED | VM_HUGETLB | VM_INSERTPAGE |
+				 VM_MIXEDMAP | VM_SAO))
+			return -EINVAL;
+		*vm_flags &= ~VM_HUGEPAGE;
+		*vm_flags |= VM_NOHUGEPAGE;
+		break;
+	}
 
 	return 0;
 }
diff -puN mm/madvise.c~thp-madvisemadv_nohugepage mm/madvise.c
--- a/mm/madvise.c~thp-madvisemadv_nohugepage
+++ a/mm/madvise.c
@@ -72,7 +72,8 @@ static long madvise_behavior(struct vm_a
 			goto out;
 		break;
 	case MADV_HUGEPAGE:
-		error = hugepage_madvise(&new_flags);
+	case MADV_NOHUGEPAGE:
+		error = hugepage_madvise(&new_flags, behavior);
 		if (error)
 			goto out;
 		break;
@@ -290,6 +291,7 @@ madvise_behavior_valid(int behavior)
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	case MADV_HUGEPAGE:
+	case MADV_NOHUGEPAGE:
 #endif
 		return 1;
 
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

