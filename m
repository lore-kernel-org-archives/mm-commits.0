From: akpm@linux-foundation.org
Subject: [merged]
 mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:03:51 -0800
Message-ID: <20171116200351.2dnzBpfbs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47152 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934285AbdKPUDw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor out page cache page freeing into a separate function
has been removed from the -mm tree.  Its filename was
     mm-factor-out-page-cache-page-freeing-into-a-separate-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
