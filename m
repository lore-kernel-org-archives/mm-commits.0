From: akpm@linux-foundation.org
Subject: + mm-refactor-truncate_complete_page.patch added to -mm tree
Date: Tue, 17 Oct 2017 16:09:21 -0700
Message-ID: <59e68da1.5NDNEmJDvXB0eN7X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754136AbdJQXJX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor truncate_complete_page()
has been added to the -mm tree.  Its filename is
     mm-refactor-truncate_complete_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-truncate_complete_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-truncate_complete_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-implement-find_get_pages_range_tag.patch
btrfs-use-pagevec_lookup_range_tag.patch
ceph-use-pagevec_lookup_range_tag.patch
ext4-use-pagevec_lookup_range_tag.patch
f2fs-use-pagevec_lookup_range_tag.patch
f2fs-simplify-page-iteration-loops.patch
f2fs-use-find_get_pages_tag-for-looking-up-single-page.patch
gfs2-use-pagevec_lookup_range_tag.patch
nilfs2-use-pagevec_lookup_range_tag.patch
mm-use-pagevec_lookup_range_tag-in-__filemap_fdatawait_range.patch
mm-use-pagevec_lookup_range_tag-in-write_cache_pages.patch
mm-add-variant-of-pagevec_lookup_range_tag-taking-number-of-pages.patch
ceph-use-pagevec_lookup_range_nr_tag.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range_tag.patch
afs-use-find_get_pages_range_tag.patch
cifs-use-find_get_pages_range_tag.patch
mm-speedup-cancel_dirty_page-for-clean-pages.patch
mm-refactor-truncate_complete_page.patch
mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch
mm-move-accounting-updates-before-page_cache_tree_delete.patch
mm-move-clearing-of-page-mapping-to-page_cache_tree_delete.patch
mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch
mm-batch-radix-tree-operations-when-truncating-pages.patch

