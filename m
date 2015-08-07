From: akpm@linux-foundation.org
Subject: [alternative-merged]
 page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch removed from -mm tree
Date: Fri, 07 Aug 2015 16:15:38 -0700
Message-ID: <55c53c1a.Z1lsd1HMTBFa4z20%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946357AbbHGXPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 19:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mel@csn.ul.ie, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,compaction: fix isolate_migratepages_block() for THP=n
has been removed from the -mm tree.  Its filename was
     page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm,compaction: fix isolate_migratepages_block() for THP=n

PageTrans* helpers are always false if THP is disabled at compile-time. 
It means isolate_migratepages_block() will fail to detect hugetlb pages in
this case.

Let's use PageCompound() instead.  With a small tweak to how we calculate
next low_pfn it will make isolate_migratepages_block() ready to see tail
pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN mm/compaction.c~page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix mm/compaction.c
--- a/mm/compaction.c~page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix
+++ a/mm/compaction.c
@@ -763,18 +763,18 @@ isolate_migratepages_block(struct compac
 		 * splitting and collapsing (collapsing has already happened
 		 * if PageLRU is set) but the lock is not necessarily taken
 		 * here and it is wasteful to take it just to check transhuge.
-		 * Check TransHuge without lock and skip the whole pageblock if
-		 * it's either a transhuge or hugetlbfs page, as calling
+		 * Check PageCompound without lock and skip the whole pageblock
+		 * if it's either a transhuge or hugetlbfs page, as calling
 		 * compound_order() without preventing THP from splitting the
 		 * page underneath us may return surprising results.
 		 */
-		if (PageTransHuge(page)) {
-			if (!locked)
-				low_pfn = ALIGN(low_pfn + 1,
-						pageblock_nr_pages) - 1;
+		if (PageCompound(page)) {
+			int nr;
+			if (locked)
+				nr = 1 << compound_order(page);
 			else
-				low_pfn += (1 << compound_order(page)) - 1;
-
+				nr = pageblock_nr_pages;
+			low_pfn = ALIGN(low_pfn + 1, nr) - 1;
 			continue;
 		}
 
@@ -794,11 +794,12 @@ isolate_migratepages_block(struct compac
 			if (!locked)
 				break;
 
-			/* Recheck PageLRU and PageTransHuge under lock */
+			/* Recheck PageLRU and PageCompound under lock */
 			if (!PageLRU(page))
 				continue;
-			if (PageTransHuge(page)) {
-				low_pfn += (1 << compound_order(page)) - 1;
+			if (PageCompound(page)) {
+				int nr = 1 << compound_order(page);
+				low_pfn = ALIGN(low_pfn + 1, nr) - 1;
 				continue;
 			}
 		}
@@ -809,7 +810,7 @@ isolate_migratepages_block(struct compac
 		if (__isolate_lru_page(page, isolate_mode) != 0)
 			continue;
 
-		VM_BUG_ON_PAGE(PageTransCompound(page), page);
+		VM_BUG_ON_PAGE(PageCompound(page), page);
 
 		/* Successfully isolated */
 		del_page_from_lru_list(page, lruvec, page_lru(page));
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

user_ns-use-correct-check-for-single-threadedness.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch
mm-fix-status-code-move_pages-returns-for-zero-page.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
dax-ensure-that-zero-pages-are-removed-from-other-processes.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch
vm_flags-vm_flags_t-and-__nocast.patch
mm-compaction-always-skip-compound-pages-by-order-in-migrate-scanner.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
fix-list_poison12-offset.patch
use-poison_pointer_delta-for-poison-pointers.patch
remove-not-used-poison-pointer-macros.patch
mm-mark-most-vm_operations_struct-const.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

