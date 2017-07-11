From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-hugetlb-soft-offline-dissolve-source-hugepage-after-su?=
 =?US-ASCII?Q?ccessful-migration.patch?= removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:05 -0700
Message-ID: <20170711192305.Q-Si7ZY3L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTXG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm: hugetlb: soft-offline: dissolve source hugepage after successful migration
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm: hugetlb: soft-offline: dissolve source hugepage after successful migration

Currently hugepage migrated by soft-offline (i.e.  due to correctable
memory errors) is contained as a hugepage, which means many non-error
pages in it are unreusable, i.e.  wasted.

This patch solves this issue by dissolving source hugepages into buddy. 
As done in previous patch, PageHWPoison is set only on a head page of the
error hugepage.  Then in dissoliving we move the PageHWPoison flag to the
raw error page so that all healthy subpages return back to buddy.

[arnd@arndb.de: fix warnings: replace some macros with inline functions]
  Link: http://lkml.kernel.org/r/20170609102544.2947326-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/1496305019-5493-5-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   31 +++++++++++++++++++++++++++----
 mm/hugetlb.c            |   10 +++++++++-
 mm/memory-failure.c     |    5 +----
 mm/migrate.c            |    2 ++
 4 files changed, 39 insertions(+), 9 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration
+++ a/include/linux/hugetlb.h
@@ -472,6 +472,7 @@ static inline pgoff_t basepage_index(str
 	return __basepage_index(page);
 }
 
+extern int dissolve_free_huge_page(struct page *page);
 extern int dissolve_free_huge_pages(unsigned long start_pfn,
 				    unsigned long end_pfn);
 static inline bool hugepage_migration_supported(struct hstate *h)
@@ -550,15 +551,37 @@ static inline unsigned int pages_per_hug
 {
 	return 1;
 }
-#define hstate_index_to_shift(index) 0
-#define hstate_index(h) 0
+
+static inline unsigned hstate_index_to_shift(unsigned index)
+{
+	return 0;
+}
+
+static inline int hstate_index(struct hstate *h)
+{
+	return 0;
+}
 
 static inline pgoff_t basepage_index(struct page *page)
 {
 	return page->index;
 }
-#define dissolve_free_huge_pages(s, e)	0
-#define hugepage_migration_supported(h)	false
+
+static inline int dissolve_free_huge_page(struct page *page)
+{
+	return 0;
+}
+
+static inline int dissolve_free_huge_pages(unsigned long start_pfn,
+					   unsigned long end_pfn)
+{
+	return 0;
+}
+
+static inline bool hugepage_migration_supported(struct hstate *h)
+{
+	return false;
+}
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
diff -puN mm/hugetlb.c~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration
+++ a/mm/hugetlb.c
@@ -1459,7 +1459,7 @@ static int free_pool_huge_page(struct hs
  * number of free hugepages would be reduced below the number of reserved
  * hugepages.
  */
-static int dissolve_free_huge_page(struct page *page)
+int dissolve_free_huge_page(struct page *page)
 {
 	int rc = 0;
 
@@ -1472,6 +1472,14 @@ static int dissolve_free_huge_page(struc
 			rc = -EBUSY;
 			goto out;
 		}
+		/*
+		 * Move PageHWPoison flag from head page to the raw error page,
+		 * which makes any subpages rather than the error page reusable.
+		 */
+		if (PageHWPoison(head) && page != head) {
+			SetPageHWPoison(page);
+			ClearPageHWPoison(head);
+		}
 		list_del(&head->lru);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
diff -puN mm/memory-failure.c~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration
+++ a/mm/memory-failure.c
@@ -1575,11 +1575,8 @@ static int soft_offline_huge_page(struct
 		if (ret > 0)
 			ret = -EIO;
 	} else {
-		/* overcommit hugetlb page will be freed to buddy */
-		SetPageHWPoison(page);
 		if (PageHuge(page))
-			dequeue_hwpoisoned_huge_page(hpage);
-		num_poisoned_pages_inc();
+			dissolve_free_huge_page(page);
 	}
 	return ret;
 }
diff -puN mm/migrate.c~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration mm/migrate.c
--- a/mm/migrate.c~mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration
+++ a/mm/migrate.c
@@ -1252,6 +1252,8 @@ put_anon:
 out:
 	if (rc != -EAGAIN)
 		putback_active_hugepage(hpage);
+	if (reason == MR_MEMORY_FAILURE && !test_set_page_hwpoison(hpage))
+		num_poisoned_pages_inc();
 
 	/*
 	 * If migration was not successful and there's a freeing callback, use
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are


