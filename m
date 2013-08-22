From: akpm@linux-foundation.org
Subject: +
 hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch added to -mm tree
Date: Thu, 22 Aug 2013 15:52:51 -0700
Message-ID: <52169643.XGLzr/8UZGEp7uEO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3HVWww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 18:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, liwanp@linux.vnet.ibm.com, fengguang.wu@intel.com, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: + hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,fengguang.wu@intel.com,liwanp@linux.vnet.ibm.com,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 15:52:51 -0700


The patch titled
     Subject: hwpoison: always unset MIGRATE_ISOLATE before returning from soft_offline_page()
has been added to the -mm tree.  Its filename is
     hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch

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
Subject: hwpoison: always unset MIGRATE_ISOLATE before returning from soft_offline_page()

Soft offline code expects that MIGRATE_ISOLATE is set on the target page
only during soft offlining work.  But currenly it doesn't work as expected
when get_any_page() fails and returns negative value.  In the result, end
users can have unexpectedly isolated pages.  This patch just fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page
+++ a/mm/memory-failure.c
@@ -1550,7 +1550,7 @@ int soft_offline_page(struct page *page,
 
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
-		return ret;
+		goto unset;
 	if (ret) { /* for in-use pages */
 		if (PageHuge(page))
 			ret = soft_offline_huge_page(page, flags);
@@ -1567,6 +1567,7 @@ int soft_offline_page(struct page *page,
 			atomic_long_inc(&num_poisoned_pages);
 		}
 	}
+unset:
 	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
 	return ret;
 }
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
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2-fix.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch

