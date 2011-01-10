From: akpm@linux-foundation.org
Subject: + thp-add-compound_trans_head-helper.patch added to -mm tree
Date: Mon, 10 Jan 2011 14:55:26 -0800
Message-ID: <201101102255.p0AMtRWW016295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab1AJW4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Jan 2011 17:56:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, avi@redhat.com, hughd@google.com, jweiner@redhat.com, mtosatti@redhat.com


The patch titled
     thp: add compound_trans_head() helper
has been added to the -mm tree.  Its filename is
     thp-add-compound_trans_head-helper.patch

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
Subject: thp: add compound_trans_head() helper
From: Andrea Arcangeli <aarcange@redhat.com>

Cleanup some code with common compound_trans_head helper.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   18 ++++++++++++++++++
 mm/ksm.c                |   15 +++------------
 virt/kvm/kvm_main.c     |   38 ++++++++++++++------------------------
 3 files changed, 35 insertions(+), 36 deletions(-)

diff -puN include/linux/huge_mm.h~thp-add-compound_trans_head-helper include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-add-compound_trans_head-helper
+++ a/include/linux/huge_mm.h
@@ -126,6 +126,23 @@ static inline int hpage_nr_pages(struct 
 		return HPAGE_PMD_NR;
 	return 1;
 }
+static inline struct page *compound_trans_head(struct page *page)
+{
+	if (PageTail(page)) {
+		struct page *head;
+		head = page->first_page;
+		smp_rmb();
+		/*
+		 * head may be a dangling pointer.
+		 * __split_huge_page_refcount clears PageTail before
+		 * overwriting first_page, so if PageTail is still
+		 * there it means the head pointer isn't dangling.
+		 */
+		if (PageTail(page))
+			return head;
+	}
+	return page;
+}
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUG(); 0; })
@@ -144,6 +161,7 @@ static inline int split_huge_page(struct
 	do { } while (0)
 #define wait_split_huge_page(__anon_vma, __pmd)	\
 	do { } while (0)
+#define compound_trans_head(page) compound_head(page)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
 {
diff -puN mm/ksm.c~thp-add-compound_trans_head-helper mm/ksm.c
--- a/mm/ksm.c~thp-add-compound_trans_head-helper
+++ a/mm/ksm.c
@@ -415,20 +415,11 @@ out:
 static struct page *page_trans_compound_anon(struct page *page)
 {
 	if (PageTransCompound(page)) {
-		struct page *head;
-		head = compound_head(page);
+		struct page *head = compound_trans_head(page);
 		/*
-		 * head may be a dangling pointer.
-		 * __split_huge_page_refcount clears PageTail
-		 * before overwriting first_page, so if
-		 * PageTail is still there it means the head
-		 * pointer isn't dangling.
+		 * head may actually be splitted and freed from under
+		 * us but it's ok here.
 		 */
-		if (head != page) {
-			smp_rmb();
-			if (!PageTransCompound(page))
-				return NULL;
-		}
 		if (PageAnon(head))
 			return head;
 	}
diff -puN virt/kvm/kvm_main.c~thp-add-compound_trans_head-helper virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~thp-add-compound_trans_head-helper
+++ a/virt/kvm/kvm_main.c
@@ -104,34 +104,24 @@ static pfn_t fault_pfn;
 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
 	if (pfn_valid(pfn)) {
-		struct page *head;
+		int reserved;
 		struct page *tail = pfn_to_page(pfn);
-		head = compound_head(tail);
+		struct page *head = compound_trans_head(tail);
+		reserved = PageReserved(head);
 		if (head != tail) {
-			smp_rmb();
 			/*
-			 * head may be a dangling pointer.
-			 * __split_huge_page_refcount clears PageTail
-			 * before overwriting first_page, so if
-			 * PageTail is still there it means the head
-			 * pointer isn't dangling.
+			 * "head" is not a dangling pointer
+			 * (compound_trans_head takes care of that)
+			 * but the hugepage may have been splitted
+			 * from under us (and we may not hold a
+			 * reference count on the head page so it can
+			 * be reused before we run PageReferenced), so
+			 * we've to check PageTail before returning
+			 * what we just read.
 			 */
-			if (PageTail(tail)) {
-				/*
-				 * the "head" is not a dangling
-				 * pointer but the hugepage may have
-				 * been splitted from under us (and we
-				 * may not hold a reference count on
-				 * the head page so it can be reused
-				 * before we run PageReferenced), so
-				 * we've to recheck PageTail before
-				 * returning what we just read.
-				 */
-				int reserved = PageReserved(head);
-				smp_rmb();
-				if (PageTail(tail))
-					return reserved;
-			}
+			smp_rmb();
+			if (PageTail(tail))
+				return reserved;
 		}
 		return PageReserved(tail);
 	}
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
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um-2patch.patch
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
thp-kvm-mmu-transparent-hugepage-support-fix.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
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
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
thp-ksm-on-thp.patch
thp-add-compound_trans_head-helper.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix.patch
hugetlb-fix-handling-of-parse-errors-in-sysfs.patch

