From: akpm@linux-foundation.org
Subject: +
 mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch
 added to -mm tree
Date: Mon, 19 Aug 2013 16:50:05 -0700
Message-ID: <5212af2d.sxttPZBs+zrTEL66%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3HSXuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 19:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 16:50:05 -0700


The patch titled
     Subject: [PATCH] fix return type of htlb_alloc_mask
has been added to the -mm tree.  Its filename is
     mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch

