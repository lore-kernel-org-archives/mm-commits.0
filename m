From: akpm@linux-foundation.org
Subject: +
 mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch
 added to -mm tree
Date: Tue, 17 Oct 2017 16:09:33 -0700
Message-ID: <59e68dad.CaE23tB2THescS1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754136AbdJQXJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:09:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor out checks and accounting from __delete_from_page_cache()
has been added to the -mm tree.  Its filename is
     mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-factor-out-checks-and-accounting-from-__delete_from_page_cache.patch

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

