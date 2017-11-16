From: akpm@linux-foundation.org
Subject: [merged] mm-refactor-truncate_complete_page.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 12:03:48 -0800
Message-ID: <20171116200348.hX8-eUbzA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935293AbdKPUDt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor truncate_complete_page()
has been removed from the -mm tree.  Its filename was
     mm-refactor-truncate_complete_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: refactor truncate_complete_page()

Move call of delete_from_page_cache() and page->mapping check out of
truncate_complete_page() into the single caller - truncate_inode_page(). 
Also move page_mapped() check into truncate_complete_page().  That way it
will be easier to batch operations.  Also rename truncate_complete_page()
to truncate_cleanup_page().

Link: http://lkml.kernel.org/r/20171010151937.26984-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN mm/truncate.c~mm-refactor-truncate_complete_page mm/truncate.c
--- a/mm/truncate.c~mm-refactor-truncate_complete_page
+++ a/mm/truncate.c
@@ -134,11 +134,17 @@ void do_invalidatepage(struct page *page
  * its lock, b) when a concurrent invalidate_mapping_pages got there first and
  * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
  */
-static int
-truncate_complete_page(struct address_space *mapping, struct page *page)
+static void
+truncate_cleanup_page(struct address_space *mapping, struct page *page)
 {
-	if (page->mapping != mapping)
-		return -EIO;
+	if (page_mapped(page)) {
+		loff_t holelen;
+
+		holelen = PageTransHuge(page) ? HPAGE_PMD_SIZE : PAGE_SIZE;
+		unmap_mapping_range(mapping,
+				   (loff_t)page->index << PAGE_SHIFT,
+				   holelen, 0);
+	}
 
 	if (page_has_private(page))
 		do_invalidatepage(page, 0, PAGE_SIZE);
@@ -150,8 +156,6 @@ truncate_complete_page(struct address_sp
 	 */
 	cancel_dirty_page(page);
 	ClearPageMappedToDisk(page);
-	delete_from_page_cache(page);
-	return 0;
 }
 
 /*
@@ -180,16 +184,14 @@ invalidate_complete_page(struct address_
 
 int truncate_inode_page(struct address_space *mapping, struct page *page)
 {
-	loff_t holelen;
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
-	holelen = PageTransHuge(page) ? HPAGE_PMD_SIZE : PAGE_SIZE;
-	if (page_mapped(page)) {
-		unmap_mapping_range(mapping,
-				   (loff_t)page->index << PAGE_SHIFT,
-				   holelen, 0);
-	}
-	return truncate_complete_page(mapping, page);
+	if (page->mapping != mapping)
+		return -EIO;
+
+	truncate_cleanup_page(mapping, page);
+	delete_from_page_cache(page);
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch

