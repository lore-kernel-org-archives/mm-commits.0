From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix-2.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 13:58:32 -0700
Message-ID: <5230d978.ebCh5y7CAvDdVBuw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab3IKU6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: [folded-merged] mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix-2.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:58:32 -0700


The patch titled
     Subject: move is_hugepage_active() outside #ifdef CONFIG_MEMORY_FAILURE
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix-2.patch

This patch was dropped because it was folded into mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: move is_hugepage_active() outside #ifdef  CONFIG_MEMORY_FAILURE

This patch fixes the following build error:

  tree:   git://git.cmpxchg.org/linux-mmotm.git master
  head:   1cd1467d27f0fdcc21c34581ab91ed29ead81621
  commit: 12e2508d0cb3168251a0dacdd92fd4cf991ca654 [157/412] mm: memory-hotplug: enable memory hotplug to handle hugepage
  config: x86_64-randconfig-c06-0815 (attached as .config)

  All error/warnings:

     mm/built-in.o: In function `__offline_pages.constprop.33':
  >> memory_hotplug.c:(.ref.text+0x52f): undefined reference to `is_hugepage_active'

This should be merged with the following commit in the same tree:

  commit 12e2508d0cb3168251a0dacdd92fd4cf991ca654
  Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
  Date:   Fri Aug 16 00:06:33 2013 +0000

      mm: memory-hotplug: enable memory hotplug to handle hugepage

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN mm/hugetlb.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix-2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix-2
+++ a/mm/hugetlb.c
@@ -3454,28 +3454,6 @@ static int is_hugepage_on_freelist(struc
 	return 0;
 }
 
-bool is_hugepage_active(struct page *page)
-{
-	VM_BUG_ON(!PageHuge(page));
-	/*
-	 * This function can be called for a tail page because the caller,
-	 * scan_movable_pages, scans through a given pfn-range which typically
-	 * covers one memory block. In systems using gigantic hugepage (1GB
-	 * for x86_64,) a hugepage is larger than a memory block, and we don't
-	 * support migrating such large hugepages for now, so return false
-	 * when called for tail pages.
-	 */
-	if (PageTail(page))
-		return false;
-	/*
-	 * Refcount of a hwpoisoned hugepages is 1, but they are not active,
-	 * so we should return false for them.
-	 */
-	if (unlikely(PageHWPoison(page)))
-		return false;
-	return page_count(page) > 0;
-}
-
 /*
  * This function is called from memory failure code.
  * Assume the caller holds page lock of the head page.
@@ -3524,3 +3502,25 @@ void putback_active_hugepage(struct page
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
 }
+
+bool is_hugepage_active(struct page *page)
+{
+	VM_BUG_ON(!PageHuge(page));
+	/*
+	 * This function can be called for a tail page because the caller,
+	 * scan_movable_pages, scans through a given pfn-range which typically
+	 * covers one memory block. In systems using gigantic hugepage (1GB
+	 * for x86_64,) a hugepage is larger than a memory block, and we don't
+	 * support migrating such large hugepages for now, so return false
+	 * when called for tail pages.
+	 */
+	if (PageTail(page))
+		return false;
+	/*
+	 * Refcount of a hwpoisoned hugepages is 1, but they are not active,
+	 * so we should return false for them.
+	 */
+	if (unlikely(PageHWPoison(page)))
+		return false;
+	return page_count(page) > 0;
+}
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
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch
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

