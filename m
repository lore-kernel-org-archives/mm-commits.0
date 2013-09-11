From: akpm@linux-foundation.org
Subject: [folded-merged]
 migrate-add-hugepage-migration-code-to-migrate_pages-add-check-to-avoid-queuing-hugepage-under-migration.patch removed from -mm tree
Date: Wed, 11 Sep 2013 13:58:11 -0700
Message-ID: <5230d963.2Y8Wjc6fQuORXALQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3IKU6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [folded-merged] migrate-add-hugepage-migration-code-to-migrate_pages-add-check-to-avoid-queuing-hugepage-under-migration.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:58:11 -0700


The patch titled
     Subject: mm/mempolicy.c: add check to avoid queuing hugepage under migration
has been removed from the -mm tree.  Its filename was
     migrate-add-hugepage-migration-code-to-migrate_pages-add-check-to-avoid-queuing-hugepage-under-migration.patch

This patch was dropped because it was folded into migrate-add-hugepage-migration-code-to-migrate_pages.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/mempolicy.c: add check to avoid queuing hugepage under migration

queue_pages_pmd_range() checks pmd_huge() to find hugepage, but this check
assumes the pmd is in the normal format and does not work on migration
entry whoes format is like swap entry.  We can distinguish them with
present bit, so we need to check it before cheking pmd_huge().  Otherwise,
pmd_huge() can wrongly return false for hugepage, and the behavior is
unpredictable.

This patch is against mmotm-2013-08-27.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mempolicy.c~migrate-add-hugepage-migration-code-to-migrate_pages-add-check-to-avoid-queuing-hugepage-under-migration mm/mempolicy.c
--- a/mm/mempolicy.c~migrate-add-hugepage-migration-code-to-migrate_pages-add-check-to-avoid-queuing-hugepage-under-migration
+++ a/mm/mempolicy.c
@@ -550,6 +550,8 @@ static inline int check_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		if (!pmd_present(*pmd))
+			continue;
 		if (pmd_huge(*pmd) && is_vm_hugetlb_page(vma)) {
 			check_hugetlb_pmd_range(vma, pmd, nodes,
 						flags, private);
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
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix-2.patch
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

