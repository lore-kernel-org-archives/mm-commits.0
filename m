From: akpm@linux-foundation.org
Subject: + mbind-add-bug_onvma-in-new_vma_page.patch added to -mm tree
Date: Fri, 23 Aug 2013 15:11:53 -0700
Message-ID: <5217de29.LxkKmpfJ3uxq+3qO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3HWWLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 18:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dan.carpenter@oracle.com, n-horiguchi@ah.jp.nec.com

Subject: + mbind-add-bug_onvma-in-new_vma_page.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,dan.carpenter@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 15:11:53 -0700


The patch titled
     Subject: mbind: add BUG_ON(!vma) in new_vma_page()
has been added to the -mm tree.  Its filename is
     mbind-add-bug_onvma-in-new_vma_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mbind-add-bug_onvma-in-new_vma_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mbind-add-bug_onvma-in-new_vma_page.patch

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
Subject: mbind: add BUG_ON(!vma) in new_vma_page()

new_vma_page() is called only by page migration called from do_mbind(),
where pages to be migrated are queued into a pagelist by
queue_pages_range().  queue_pages_range() confirms that a queued page
belongs to some vma, so !vma case is not supposed to be happen.  This
patch adds BUG_ON() to catch this unexpected case.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~mbind-add-bug_onvma-in-new_vma_page mm/mempolicy.c
--- a/mm/mempolicy.c~mbind-add-bug_onvma-in-new_vma_page
+++ a/mm/mempolicy.c
@@ -1194,12 +1194,14 @@ static struct page *new_vma_page(struct
 			break;
 		vma = vma->vm_next;
 	}
+	/*
+	 * queue_pages_range() confirms that @page belongs to some vma,
+	 * so vma shouldn't be NULL.
+	 */
+	BUG_ON(!vma);
 
 	if (PageHuge(page))
 		return alloc_huge_page_noerr(vma, address, 1);
-	/*
-	 * if !vma, alloc_page_vma() will use task or system default policy
-	 */
 	return alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 }
 #else
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
mbind-add-bug_onvma-in-new_vma_page.patch
hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch

