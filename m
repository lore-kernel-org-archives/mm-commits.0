From: akpm@linux-foundation.org
Subject: [patch 7/7] mm: fix false-positive WARN_ON() in
 truncate/invalidate for hugetlb
Date: Wed, 30 Nov 2016 15:54:19 -0800
Message-ID: <583f66ab.PrvzDuK1u1mOPn+I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754830AbcK3XyD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 18:54:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, doug.nelson@intel.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix false-positive WARN_ON() in truncate/invalidate for hugetlb

Hugetlb pages have ->index in size of the huge pages (PMD_SIZE or
PUD_SIZE), not in PAGE_SIZE as other types of pages.  This means we cannot
user page_to_pgoff() to check whether we've got the right page for the
radix-tree index.

Let's introduce page_to_index() which would return radix-tree index for
given page.

We will be able to get rid of this once hugetlb will be switched to
multi-order entries.

Fixes: fc127da085c2 ("truncate: handle file thp")
Link: http://lkml.kernel.org/r/20161123093053.mjbnvn5zwxw5e6lk@black.fi.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Doug Nelson <doug.nelson@intel.com>
Tested-by: Doug Nelson <doug.nelson@intel.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   21 +++++++++++++++------
 mm/truncate.c           |    8 ++++----
 2 files changed, 19 insertions(+), 10 deletions(-)

diff -puN include/linux/pagemap.h~mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb
+++ a/include/linux/pagemap.h
@@ -374,16 +374,13 @@ static inline struct page *read_mapping_
 }
 
 /*
- * Get the offset in PAGE_SIZE.
- * (TODO: hugepage should have ->index in PAGE_SIZE)
+ * Get index of the page with in radix-tree
+ * (TODO: remove once hugetlb pages will have ->index in PAGE_SIZE)
  */
-static inline pgoff_t page_to_pgoff(struct page *page)
+static inline pgoff_t page_to_index(struct page *page)
 {
 	pgoff_t pgoff;
 
-	if (unlikely(PageHeadHuge(page)))
-		return page->index << compound_order(page);
-
 	if (likely(!PageTransTail(page)))
 		return page->index;
 
@@ -397,6 +394,18 @@ static inline pgoff_t page_to_pgoff(stru
 }
 
 /*
+ * Get the offset in PAGE_SIZE.
+ * (TODO: hugepage should have ->index in PAGE_SIZE)
+ */
+static inline pgoff_t page_to_pgoff(struct page *page)
+{
+	if (unlikely(PageHeadHuge(page)))
+		return page->index << compound_order(page);
+
+	return page_to_index(page);
+}
+
+/*
  * Return byte-offset into filesystem object for page.
  */
 static inline loff_t page_offset(struct page *page)
diff -puN mm/truncate.c~mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb mm/truncate.c
--- a/mm/truncate.c~mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb
+++ a/mm/truncate.c
@@ -283,7 +283,7 @@ void truncate_inode_pages_range(struct a
 
 			if (!trylock_page(page))
 				continue;
-			WARN_ON(page_to_pgoff(page) != index);
+			WARN_ON(page_to_index(page) != index);
 			if (PageWriteback(page)) {
 				unlock_page(page);
 				continue;
@@ -371,7 +371,7 @@ void truncate_inode_pages_range(struct a
 			}
 
 			lock_page(page);
-			WARN_ON(page_to_pgoff(page) != index);
+			WARN_ON(page_to_index(page) != index);
 			wait_on_page_writeback(page);
 			truncate_inode_page(mapping, page);
 			unlock_page(page);
@@ -492,7 +492,7 @@ unsigned long invalidate_mapping_pages(s
 			if (!trylock_page(page))
 				continue;
 
-			WARN_ON(page_to_pgoff(page) != index);
+			WARN_ON(page_to_index(page) != index);
 
 			/* Middle of THP: skip */
 			if (PageTransTail(page)) {
@@ -612,7 +612,7 @@ int invalidate_inode_pages2_range(struct
 			}
 
 			lock_page(page);
-			WARN_ON(page_to_pgoff(page) != index);
+			WARN_ON(page_to_index(page) != index);
 			if (page->mapping != mapping) {
 				unlock_page(page);
 				continue;
_
