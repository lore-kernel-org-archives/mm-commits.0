From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 13:59:07 -0700
Message-ID: <5230d99b.+c9sWihsEVyxAf9S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab3IKU7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: [folded-merged] mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:59:07 -0700


The patch titled
     Subject: [PATCH] fix return type of htlb_alloc_mask
has been removed from the -mm tree.  Its filename was
     mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch

This patch was dropped because it was folded into mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH] fix return type of htlb_alloc_mask

This is to fix the incorrect return type of htlb_alloc_mask().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix
+++ a/mm/hugetlb.c
@@ -539,7 +539,7 @@ static struct page *dequeue_huge_page_no
 }
 
 /* Movability of hugepages depends on migration support. */
-static inline int htlb_alloc_mask(struct hstate *h)
+static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
 	if (hugepages_treat_as_movable || hugepage_migration_support(h))
 		return GFP_HIGHUSER_MOVABLE;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
mbind-add-bug_onvma-in-new_vma_page.patch
hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch
mm-hwpoison-fix-loss-of-pg_dirty-for-errors-on-mlocked-pages.patch
mm-hwpoison-dont-need-to-hold-compound-lock-for-hugetlbfs-page.patch
mm-hwpoison-fix-race-against-poison-thp.patch
mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec.patch
mm-hwpoison-dont-set-migration-type-twice-to-avoid-holding-heavily-contend-zone-lock.patch
mm-hwpoison-drop-forward-reference-declarations-__soft_offline_page.patch
mm-hwpoison-add-to-madvise_hwpoison.patch
mm-hwpoisonc-fix-held-reference-count-after-unpoisoning-empty-zero-page.patch
mm-hwpoison-injectc-change-permission-of-corrupt-pfn-unpoison-pfn-to-0200.patch
mm-memory-failurec-fix-bug-triggered-by-unpoisoning-empty-zero-page.patch
mm-hwpoison-fix-return-value-of-madvise_hwpoison.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch

