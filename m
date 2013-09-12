From: akpm@linux-foundation.org
Subject: [merged]
 mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:13 -0700
Message-ID: <5232198d.+kQmusds/Cea19Db%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:13 -0700


The patch titled
     Subject: mm: soft-offline: use migrate_pages() instead of migrate_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: soft-offline: use migrate_pages() instead of migrate_huge_page()

Currently migrate_huge_page() takes a pointer to a hugepage to be migrated
as an argument, instead of taking a pointer to the list of hugepages to be
migrated.  This behavior was introduced in commit 189ebff28 ("hugetlb:
simplify migrate_huge_page()"), and was OK because until now hugepage
migration is enabled only for soft-offlining which migrates only one
hugepage in a single call.

But the situation will change in the later patches in this series which
enable other users of page migration to support hugepage migration.  They
can kick migration for both of normal pages and hugepages in a single
call, so we need to go back to original implementation which uses linked
lists to collect the hugepages to be migrated.

With this patch, soft_offline_huge_page() switches to use migrate_pages(),
and migrate_huge_page() is not used any more.  So let's remove it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    5 -----
 mm/memory-failure.c     |   15 ++++++++++++---
 mm/migrate.c            |   28 ++--------------------------
 3 files changed, 14 insertions(+), 34 deletions(-)

diff -puN include/linux/migrate.h~mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page include/linux/migrate.h
--- a/include/linux/migrate.h~mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page
+++ a/include/linux/migrate.h
@@ -41,8 +41,6 @@ extern int migrate_page(struct address_s
 			struct page *, struct page *, enum migrate_mode);
 extern int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, enum migrate_mode mode, int reason);
-extern int migrate_huge_page(struct page *, new_page_t x,
-		unsigned long private, enum migrate_mode mode);
 
 extern int fail_migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -62,9 +60,6 @@ static inline void putback_movable_pages
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, enum migrate_mode mode, int reason)
 	{ return -ENOSYS; }
-static inline int migrate_huge_page(struct page *page, new_page_t x,
-		unsigned long private, enum migrate_mode mode)
-	{ return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
diff -puN mm/memory-failure.c~mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page
+++ a/mm/memory-failure.c
@@ -1470,6 +1470,7 @@ static int soft_offline_huge_page(struct
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);
+	LIST_HEAD(pagelist);
 
 	/*
 	 * This double-check of PageHWPoison is to avoid the race with
@@ -1485,12 +1486,20 @@ static int soft_offline_huge_page(struct
 	unlock_page(hpage);
 
 	/* Keep page count to indicate a given hugepage is isolated. */
-	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL,
-				MIGRATE_SYNC);
-	put_page(hpage);
+	list_move(&hpage->lru, &pagelist);
+	ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
+				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
+		/*
+		 * We know that soft_offline_huge_page() tries to migrate
+		 * only one hugepage pointed to by hpage, so we need not
+		 * run through the pagelist here.
+		 */
+		putback_active_hugepage(hpage);
+		if (ret > 0)
+			ret = -EIO;
 	} else {
 		set_page_hwpoison_huge_page(hpage);
 		dequeue_hwpoisoned_huge_page(hpage);
diff -puN mm/migrate.c~mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page mm/migrate.c
--- a/mm/migrate.c~mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page
+++ a/mm/migrate.c
@@ -979,6 +979,8 @@ static int unmap_and_move_huge_page(new_
 
 	unlock_page(hpage);
 out:
+	if (rc != -EAGAIN)
+		putback_active_hugepage(hpage);
 	put_page(new_hpage);
 	if (result) {
 		if (rc)
@@ -1066,32 +1068,6 @@ out:
 	return rc;
 }
 
-int migrate_huge_page(struct page *hpage, new_page_t get_new_page,
-		      unsigned long private, enum migrate_mode mode)
-{
-	int pass, rc;
-
-	for (pass = 0; pass < 10; pass++) {
-		rc = unmap_and_move_huge_page(get_new_page, private,
-						hpage, pass > 2, mode);
-		switch (rc) {
-		case -ENOMEM:
-			goto out;
-		case -EAGAIN:
-			/* try again */
-			cond_resched();
-			break;
-		case MIGRATEPAGE_SUCCESS:
-			goto out;
-		default:
-			rc = -EIO;
-			goto out;
-		}
-	}
-out:
-	return rc;
-}
