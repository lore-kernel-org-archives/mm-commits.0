From: akpm@linux-foundation.org
Subject: + mm-migrate-add-hugepage-migration-code-to-move_pages.patch
 added to -mm tree
Date: Wed, 14 Aug 2013 16:41:48 -0700
Message-ID: <520c15bc.4af0i82QGrFUsFGB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3HNXlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-migrate-add-hugepage-migration-code-to-move_pages.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:41:48 -0700


The patch titled
     Subject: mm: migrate: add hugepage migration code to move_pages()
has been added to the -mm tree.  Its filename is
     mm-migrate-add-hugepage-migration-code-to-move_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-add-hugepage-migration-code-to-move_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-add-hugepage-migration-code-to-move_pages.patch

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
Subject: mm: migrate: add hugepage migration code to move_pages()

Extend move_pages() to handle vma with VM_HUGETLB set.  We will be able to
migrate hugepage with move_pages(2) after applying the enablement patch
which comes later in this series.

We avoid getting refcount on tail pages of hugepage, because unlike thp,
hugepage is not split and we need not care about races with splitting.

And migration of larger (1GB for x86_64) hugepage are not enabled.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c  |   17 +++++++++++++++--
 mm/migrate.c |   13 +++++++++++--
 2 files changed, 26 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-migrate-add-hugepage-migration-code-to-move_pages mm/memory.c
--- a/mm/memory.c~mm-migrate-add-hugepage-migration-code-to-move_pages
+++ a/mm/memory.c
@@ -1475,7 +1475,8 @@ struct page *follow_page_mask(struct vm_
 	if (pud_none(*pud))
 		goto no_page_table;
 	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
-		BUG_ON(flags & FOLL_GET);
+		if (flags & FOLL_GET)
+			goto out;
 		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
 		goto out;
 	}
@@ -1486,8 +1487,20 @@ struct page *follow_page_mask(struct vm_
 	if (pmd_none(*pmd))
 		goto no_page_table;
 	if (pmd_huge(*pmd) && vma->vm_flags & VM_HUGETLB) {
-		BUG_ON(flags & FOLL_GET);
 		page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
+		if (flags & FOLL_GET) {
+			/*
+			 * Refcount on tail pages are not well-defined and
+			 * shouldn't be taken. The caller should handle a NULL
+			 * return when trying to follow tail pages.
+			 */
+			if (PageHead(page))
+				get_page(page);
+			else {
+				page = NULL;
+				goto out;
+			}
+		}
 		goto out;
 	}
 	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
diff -puN mm/migrate.c~mm-migrate-add-hugepage-migration-code-to-move_pages mm/migrate.c
--- a/mm/migrate.c~mm-migrate-add-hugepage-migration-code-to-move_pages
+++ a/mm/migrate.c
@@ -1092,7 +1092,11 @@ static struct page *new_page_node(struct
 
 	*result = &pm->status;
 
-	return alloc_pages_exact_node(pm->node,
+	if (PageHuge(p))
+		return alloc_huge_page_node(page_hstate(compound_head(p)),
+					pm->node);
+	else
+		return alloc_pages_exact_node(pm->node,
 				GFP_HIGHUSER_MOVABLE | GFP_THISNODE, 0);
 }
 
@@ -1152,6 +1156,11 @@ static int do_move_page_to_node_array(st
 				!migrate_all)
 			goto put_and_set;
 
+		if (PageHuge(page)) {
+			isolate_huge_page(page, &pagelist);
+			goto put_and_set;
+		}
+
 		err = isolate_lru_page(page);
 		if (!err) {
 			list_add_tail(&page->lru, &pagelist);
@@ -1174,7 +1183,7 @@ set_status:
 		err = migrate_pages(&pagelist, new_page_node,
 				(unsigned long)pm, MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
-			putback_lru_pages(&pagelist);
+			putback_movable_pages(&pagelist);
 	}
 
 	up_read(&mm->mmap_sem);
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

