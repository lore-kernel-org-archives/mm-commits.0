From: akpm@linux-foundation.org
Subject: +
 mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb.patch
 added to -mm tree
Date: Wed, 23 Nov 2016 10:51:34 -0800
Message-ID: <5835e536.OJWqwjQj30tqLwaQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933484AbcKWSvf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2016 13:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, doug.nelson@intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix false-positive WARN_ON() in truncate/invalidate for hugetlb
has been added to the -mm tree.  Its filename is
     mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-bug-in-munlock_vma_pages_range.patch
mm-fix-false-positive-warn_on-in-truncate-invalidate-for-hugetlb.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch

