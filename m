From: akpm@linux-foundation.org
Subject: +
 mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch added
 to -mm tree
Date: Tue, 17 Oct 2017 16:09:24 -0700
Message-ID: <59e68da4.5nEbNnrjeOmXAKZ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932983AbdJQXJZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor out page cache page freeing into a separate function
has been added to the -mm tree.  Its filename is
     mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch

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
Subject: mm: factor out page cache page freeing into a separate function

Factor out page freeing from delete_from_page_cache() into a separate
function.  We will need to call the same when batching pagecache deletion
operations.

invalidate_complete_page2() and replace_page_cache_page() might want to
call this function as well however they currently don't seem to handle
THPs so it's unnecessary for them to take the hit of checking whether a
page is THP or not.

Link: http://lkml.kernel.org/r/20171010151937.26984-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff -puN mm/filemap.c~mm-factor-out-page-cache-page-freeing-into-a-separate-function mm/filemap.c
--- a/mm/filemap.c~mm-factor-out-page-cache-page-freeing-into-a-separate-function
+++ a/mm/filemap.c
@@ -254,6 +254,23 @@ void __delete_from_page_cache(struct pag
 		account_page_cleaned(page, mapping, inode_to_wb(mapping->host));
 }
 
+static void page_cache_free_page(struct address_space *mapping,
+				struct page *page)
+{
+	void (*freepage)(struct page *);
+
+	freepage = mapping->a_ops->freepage;
+	if (freepage)
+		freepage(page);
+
+	if (PageTransHuge(page) && !PageHuge(page)) {
+		page_ref_sub(page, HPAGE_PMD_NR);
+		VM_BUG_ON_PAGE(page_count(page) <= 0, page);
+	} else {
+		put_page(page);
+	}
+}
+
 /**
  * delete_from_page_cache - delete page from page cache
  * @page: the page which the kernel is trying to remove from page cache
@@ -266,25 +283,13 @@ void delete_from_page_cache(struct page
 {
 	struct address_space *mapping = page_mapping(page);
 	unsigned long flags;
-	void (*freepage)(struct page *);
 
 	BUG_ON(!PageLocked(page));
-
-	freepage = mapping->a_ops->freepage;
-
 	spin_lock_irqsave(&mapping->tree_lock, flags);
 	__delete_from_page_cache(page, NULL);
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
 
-	if (freepage)
-		freepage(page);
-
-	if (PageTransHuge(page) && !PageHuge(page)) {
-		page_ref_sub(page, HPAGE_PMD_NR);
-		VM_BUG_ON_PAGE(page_count(page) <= 0, page);
-	} else {
-		put_page(page);
-	}
+	page_cache_free_page(mapping, page);
 }
 EXPORT_SYMBOL(delete_from_page_cache);
 
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

