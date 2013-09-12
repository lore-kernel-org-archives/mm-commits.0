From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-add-hugepage-migration-code-to-move_pages.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:17 -0700
Message-ID: <52321991.2vNQ3JN+v9bk3NXQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-migrate-add-hugepage-migration-code-to-move_pages.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:17 -0700


The patch titled
     Subject: mm: migrate: add hugepage migration code to move_pages()
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-hugepage-migration-code-to-move_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1481,7 +1481,8 @@ struct page *follow_page_mask(struct vm_
 	if (pud_none(*pud))
 		goto no_page_table;
 	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
-		BUG_ON(flags & FOLL_GET);
+		if (flags & FOLL_GET)
+			goto out;
 		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
 		goto out;
 	}
@@ -1492,8 +1493,20 @@ struct page *follow_page_mask(struct vm_
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

origin.patch

