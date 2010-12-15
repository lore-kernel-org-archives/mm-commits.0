From: akpm@linux-foundation.org
Subject: + thp-clear_copy_huge_page.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:56:54 -0800
Message-ID: <201012152356.oBFNusME013540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879Ab0LPACc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 19:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     thp: clear_copy_huge_page
has been added to the -mm tree.  Its filename is
     thp-clear_copy_huge_page.patch

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
Subject: thp: clear_copy_huge_page
From: Andrea Arcangeli <aarcange@redhat.com>

Move the copy/clear_huge_page functions to common code to share between
hugetlb.c and huge_memory.c.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++
 mm/hugetlb.c       |   70 +-----------------------------------------
 mm/memory.c        |   71 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 67 deletions(-)

diff -puN include/linux/mm.h~thp-clear_copy_huge_page include/linux/mm.h
--- a/include/linux/mm.h~thp-clear_copy_huge_page
+++ a/include/linux/mm.h
@@ -1594,5 +1594,14 @@ static inline int is_hwpoison_address(un
 
 extern void dump_page(struct page *page);
 
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
+extern void clear_huge_page(struct page *page,
+			    unsigned long addr,
+			    unsigned int pages_per_huge_page);
+extern void copy_user_huge_page(struct page *dst, struct page *src,
+				unsigned long addr, struct vm_area_struct *vma,
+				unsigned int pages_per_huge_page);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN mm/hugetlb.c~thp-clear_copy_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~thp-clear_copy_huge_page
+++ a/mm/hugetlb.c
@@ -394,71 +394,6 @@ static int vma_has_reserves(struct vm_ar
 	return 0;
 }
 
-static void clear_gigantic_page(struct page *page,
-			unsigned long addr, unsigned long sz)
-{
-	int i;
-	struct page *p = page;
-
-	might_sleep();
-	for (i = 0; i < sz/PAGE_SIZE; i++, p = mem_map_next(p, page, i)) {
-		cond_resched();
-		clear_user_highpage(p, addr + i * PAGE_SIZE);
-	}
-}
-static void clear_huge_page(struct page *page,
-			unsigned long addr, unsigned long sz)
-{
-	int i;
-
-	if (unlikely(sz/PAGE_SIZE > MAX_ORDER_NR_PAGES)) {
-		clear_gigantic_page(page, addr, sz);
-		return;
-	}
-
-	might_sleep();
-	for (i = 0; i < sz/PAGE_SIZE; i++) {
-		cond_resched();
-		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
-	}
-}
-
-static void copy_user_gigantic_page(struct page *dst, struct page *src,
-			   unsigned long addr, struct vm_area_struct *vma)
-{
-	int i;
-	struct hstate *h = hstate_vma(vma);
-	struct page *dst_base = dst;
-	struct page *src_base = src;
-
-	for (i = 0; i < pages_per_huge_page(h); ) {
-		cond_resched();
-		copy_user_highpage(dst, src, addr + i*PAGE_SIZE, vma);
-
-		i++;
-		dst = mem_map_next(dst, dst_base, i);
-		src = mem_map_next(src, src_base, i);
-	}
-}
-
-static void copy_user_huge_page(struct page *dst, struct page *src,
-			   unsigned long addr, struct vm_area_struct *vma)
-{
-	int i;
-	struct hstate *h = hstate_vma(vma);
-
-	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
-		copy_user_gigantic_page(dst, src, addr, vma);
-		return;
-	}
-
-	might_sleep();
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		cond_resched();
-		copy_user_highpage(dst + i, src + i, addr + i*PAGE_SIZE, vma);
-	}
-}
-
 static void copy_gigantic_page(struct page *dst, struct page *src)
 {
 	int i;
@@ -2454,7 +2389,8 @@ retry_avoidcopy:
 		return VM_FAULT_OOM;
 	}
 
-	copy_user_huge_page(new_page, old_page, address, vma);
+	copy_user_huge_page(new_page, old_page, address, vma,
+			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
 
 	/*
@@ -2558,7 +2494,7 @@ retry:
 			ret = -PTR_ERR(page);
 			goto out;
 		}
-		clear_huge_page(page, address, huge_page_size(h));
+		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
diff -puN mm/memory.c~thp-clear_copy_huge_page mm/memory.c
--- a/mm/memory.c~thp-clear_copy_huge_page
+++ a/mm/memory.c
@@ -3670,3 +3670,74 @@ void might_fault(void)
 }
 EXPORT_SYMBOL(might_fault);
 #endif
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
+static void clear_gigantic_page(struct page *page,
+				unsigned long addr,
+				unsigned int pages_per_huge_page)
+{
+	int i;
+	struct page *p = page;
+
+	might_sleep();
+	for (i = 0; i < pages_per_huge_page;
+	     i++, p = mem_map_next(p, page, i)) {
+		cond_resched();
+		clear_user_highpage(p, addr + i * PAGE_SIZE);
+	}
+}
+void clear_huge_page(struct page *page,
+		     unsigned long addr, unsigned int pages_per_huge_page)
+{
+	int i;
+
+	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
+		clear_gigantic_page(page, addr, pages_per_huge_page);
+		return;
+	}
+
+	might_sleep();
+	for (i = 0; i < pages_per_huge_page; i++) {
+		cond_resched();
+		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
+	}
+}
+
+static void copy_user_gigantic_page(struct page *dst, struct page *src,
+				    unsigned long addr,
+				    struct vm_area_struct *vma,
+				    unsigned int pages_per_huge_page)
+{
+	int i;
+	struct page *dst_base = dst;
+	struct page *src_base = src;
+
+	for (i = 0; i < pages_per_huge_page; ) {
+		cond_resched();
+		copy_user_highpage(dst, src, addr + i*PAGE_SIZE, vma);
+
+		i++;
+		dst = mem_map_next(dst, dst_base, i);
+		src = mem_map_next(src, src_base, i);
+	}
+}
+
+void copy_user_huge_page(struct page *dst, struct page *src,
+			 unsigned long addr, struct vm_area_struct *vma,
+			 unsigned int pages_per_huge_page)
+{
+	int i;
+
+	if (unlikely(pages_per_huge_page > MAX_ORDER_NR_PAGES)) {
+		copy_user_gigantic_page(dst, src, addr, vma,
+					pages_per_huge_page);
+		return;
+	}
+
+	might_sleep();
+	for (i = 0; i < pages_per_huge_page; i++) {
+		cond_resched();
+		copy_user_highpage(dst + i, src + i, addr + i*PAGE_SIZE, vma);
+	}
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
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

