From: akpm@linux-foundation.org
Subject: + mm-move-accounting-updates-before-page_cache_tree_delete.patch
 added to -mm tree
Date: Tue, 17 Oct 2017 16:09:27 -0700
Message-ID: <59e68da7.GSif5MhZl9Dih9xU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932983AbdJQXJ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move accounting updates before page_cache_tree_delete()
has been added to the -mm tree.  Its filename is
     mm-move-accounting-updates-before-page_cache_tree_delete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-accounting-updates-before-page_cache_tree_delete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-accounting-updates-before-page_cache_tree_delete.patch

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
Subject: mm: move accounting updates before page_cache_tree_delete()

Move updates of various counters before page_cache_tree_delete() call.  It
will be easier to batch things this way and there is no difference whether
the counters get updated before or after removal from the radix tree.

Link: http://lkml.kernel.org/r/20171010151937.26984-5-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff -puN mm/filemap.c~mm-move-accounting-updates-before-page_cache_tree_delete mm/filemap.c
--- a/mm/filemap.c~mm-move-accounting-updates-before-page_cache_tree_delete
+++ a/mm/filemap.c
@@ -224,34 +224,35 @@ void __delete_from_page_cache(struct pag
 		}
 	}
 
-	page_cache_tree_delete(mapping, page, shadow);
-
-	page->mapping = NULL;
-	/* Leave page->index set: truncation lookup relies upon it */
-
 	/* hugetlb pages do not participate in page cache accounting. */
-	if (PageHuge(page))
-		return;
+	if (!PageHuge(page)) {
+		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+		if (PageSwapBacked(page)) {
+			__mod_node_page_state(page_pgdat(page), NR_SHMEM, -nr);
+			if (PageTransHuge(page))
+				__dec_node_page_state(page, NR_SHMEM_THPS);
+		} else {
+			VM_BUG_ON_PAGE(PageTransHuge(page), page);
+		}
 
-	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
-	if (PageSwapBacked(page)) {
-		__mod_node_page_state(page_pgdat(page), NR_SHMEM, -nr);
-		if (PageTransHuge(page))
-			__dec_node_page_state(page, NR_SHMEM_THPS);
-	} else {
-		VM_BUG_ON_PAGE(PageTransHuge(page), page);
+		/*
+		 * At this point page must be either written or cleaned by
+		 * truncate.  Dirty page here signals a bug and loss of
+		 * unwritten data.
+		 *
+		 * This fixes dirty accounting after removing the page entirely
+		 * but leaves PageDirty set: it has no effect for truncated
+		 * page and anyway will be cleared before returning page into
+		 * buddy allocator.
+		 */
+		if (WARN_ON_ONCE(PageDirty(page)))
+			account_page_cleaned(page, mapping,
+					     inode_to_wb(mapping->host));
 	}
+	page_cache_tree_delete(mapping, page, shadow);
 
-	/*
-	 * At this point page must be either written or cleaned by truncate.
-	 * Dirty page here signals a bug and loss of unwritten data.
-	 *
-	 * This fixes dirty accounting after removing the page entirely but
-	 * leaves PageDirty set: it has no effect for truncated page and
-	 * anyway will be cleared before returning page into buddy allocator.
-	 */
-	if (WARN_ON_ONCE(PageDirty(page)))
-		account_page_cleaned(page, mapping, inode_to_wb(mapping->host));
+	page->mapping = NULL;
+	/* Leave page->index set: truncation lookup relies upon it */
 }
 
 static void page_cache_free_page(struct address_space *mapping,
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

