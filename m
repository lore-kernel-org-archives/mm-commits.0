From: akpm@linux-foundation.org
Subject: [merged]
 mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:04:00 -0800
Message-ID: <20171116200400.4fYCuFnh2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47242 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdKPUEC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:04:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor out checks and accounting from __delete_from_page_cache()
has been removed from the -mm tree.  Its filename was
     mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: factor out checks and accounting from __delete_from_page_cache()

Move checks and accounting updates from __delete_from_page_cache() into a
separate function.  We will reuse it when batching page cache truncation
operations.

Link: http://lkml.kernel.org/r/20171010151937.26984-7-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   72 +++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 31 deletions(-)

diff -puN mm/filemap.c~mm-factor-out-checks-and-accounting-from-__delete_from_page_cache mm/filemap.c
--- a/mm/filemap.c~mm-factor-out-checks-and-accounting-from-__delete_from_page_cache
+++ a/mm/filemap.c
@@ -181,17 +181,11 @@ static void page_cache_tree_delete(struc
 	mapping->nrpages -= nr;
 }
 
-/*
- * Delete a page from the page cache and free it. Caller has to make
- * sure the page is locked and that nobody else uses it - or that usage
- * is safe.  The caller must hold the mapping's tree_lock.
- */
-void __delete_from_page_cache(struct page *page, void *shadow)
+static void unaccount_page_cache_page(struct address_space *mapping,
+				      struct page *page)
 {
-	struct address_space *mapping = page->mapping;
-	int nr = hpage_nr_pages(page);
+	int nr;
 
-	trace_mm_filemap_delete_from_page_cache(page);
 	/*
 	 * if we're uptodate, flush out into the cleancache, otherwise
 	 * invalidate any existing cleancache entries.  We can't leave
@@ -228,30 +222,46 @@ void __delete_from_page_cache(struct pag
 	}
 
 	/* hugetlb pages do not participate in page cache accounting. */
-	if (!PageHuge(page)) {
-		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
-		if (PageSwapBacked(page)) {
-			__mod_node_page_state(page_pgdat(page), NR_SHMEM, -nr);
-			if (PageTransHuge(page))
-				__dec_node_page_state(page, NR_SHMEM_THPS);
-		} else {
-			VM_BUG_ON_PAGE(PageTransHuge(page), page);
-		}
+	if (PageHuge(page))
+		return;
+
+	nr = hpage_nr_pages(page);
 
-		/*
-		 * At this point page must be either written or cleaned by
-		 * truncate.  Dirty page here signals a bug and loss of
-		 * unwritten data.
-		 *
-		 * This fixes dirty accounting after removing the page entirely
-		 * but leaves PageDirty set: it has no effect for truncated
-		 * page and anyway will be cleared before returning page into
-		 * buddy allocator.
-		 */
-		if (WARN_ON_ONCE(PageDirty(page)))
-			account_page_cleaned(page, mapping,
-					     inode_to_wb(mapping->host));
+	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
+	if (PageSwapBacked(page)) {
+		__mod_node_page_state(page_pgdat(page), NR_SHMEM, -nr);
+		if (PageTransHuge(page))
+			__dec_node_page_state(page, NR_SHMEM_THPS);
+	} else {
+		VM_BUG_ON_PAGE(PageTransHuge(page), page);
 	}
+
+	/*
+	 * At this point page must be either written or cleaned by
+	 * truncate.  Dirty page here signals a bug and loss of
+	 * unwritten data.
+	 *
+	 * This fixes dirty accounting after removing the page entirely
+	 * but leaves PageDirty set: it has no effect for truncated
+	 * page and anyway will be cleared before returning page into
+	 * buddy allocator.
+	 */
+	if (WARN_ON_ONCE(PageDirty(page)))
+		account_page_cleaned(page, mapping, inode_to_wb(mapping->host));
+}
+
+/*
+ * Delete a page from the page cache and free it. Caller has to make
+ * sure the page is locked and that nobody else uses it - or that usage
+ * is safe.  The caller must hold the mapping's tree_lock.
+ */
+void __delete_from_page_cache(struct page *page, void *shadow)
+{
+	struct address_space *mapping = page->mapping;
+
+	trace_mm_filemap_delete_from_page_cache(page);
+
+	unaccount_page_cache_page(mapping, page);
 	page_cache_tree_delete(mapping, page, shadow);
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

mm-readahead-increase-maximum-readahead-window.patch

