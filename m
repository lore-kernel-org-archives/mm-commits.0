From: akpm@linux-foundation.org
Subject: [patch 099/131] mm: move accounting updates before
 page_cache_tree_delete()
Date: Wed, 15 Nov 2017 17:37:22 -0800
Message-ID: <20171116013722.5MVQCj2je%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933632AbdKPBhY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, dave.hansen@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
