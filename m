From: akpm@linux-foundation.org
Subject: [merged]
 mm-rewrite-pagecache_get_page-documentation.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:36:23 -0700
Message-ID: <20200403203623.Awlg41zoT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUgZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:36:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/filemap.c: rewrite pagecache_get_page documentation
has been removed from the -mm tree.  Its filename was
     mm-rewrite-pagecache_get_page-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap.c: rewrite pagecache_get_page documentation

 - These were never called PCG flags; they've been called FGP flags since
   their introduction in 2014.
 - The FGP_FOR_MMAP flag was misleadingly documented as if it was an
   alternative to FGP_CREAT instead of an option to it.
 - Rename the 'offset' parameter to 'index'.
 - Capitalisation, formatting, rewording.

Link: http://lkml.kernel.org/r/20200318140253.6141-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   55 +++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

--- a/mm/filemap.c~mm-rewrite-pagecache_get_page-documentation
+++ a/mm/filemap.c
@@ -1574,42 +1574,39 @@ repeat:
 EXPORT_SYMBOL(find_lock_entry);
 
 /**
- * pagecache_get_page - find and get a page reference
- * @mapping: the address_space to search
- * @offset: the page index
- * @fgp_flags: PCG flags
- * @gfp_mask: gfp mask to use for the page cache data page allocation
- *
- * Looks up the page cache slot at @mapping & @offset.
- *
- * PCG flags modify how the page is returned.
- *
- * @fgp_flags can be:
- *
- * - FGP_ACCESSED: the page will be marked accessed
- * - FGP_LOCK: Page is return locked
- * - FGP_CREAT: If page is not present then a new page is allocated using
- *   @gfp_mask and added to the page cache and the VM's LRU
- *   list. The page is returned locked and with an increased
- *   refcount.
- * - FGP_FOR_MMAP: Similar to FGP_CREAT, only we want to allow the caller to do
- *   its own locking dance if the page is already in cache, or unlock the page
- *   before returning if we had to add the page to pagecache.
+ * pagecache_get_page - Find and get a reference to a page.
+ * @mapping: The address_space to search.
+ * @index: The page index.
+ * @fgp_flags: %FGP flags modify how the page is returned.
+ * @gfp_mask: Memory allocation flags to use if %FGP_CREAT is specified.
+ *
+ * Looks up the page cache entry at @mapping & @index.
+ *
+ * @fgp_flags can be zero or more of these flags:
+ *
+ * * %FGP_ACCESSED - The page will be marked accessed.
+ * * %FGP_LOCK - The page is returned locked.
+ * * %FGP_CREAT - If no page is present then a new page is allocated using
+ *   @gfp_mask and added to the page cache and the VM's LRU list.
+ *   The page is returned locked and with an increased refcount.
+ * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
+ *   page is already in cache.  If the page was allocated, unlock it before
+ *   returning so the caller can do the same dance.
  *
- * If FGP_LOCK or FGP_CREAT are specified then the function may sleep even
- * if the GFP flags specified for FGP_CREAT are atomic.
+ * If %FGP_LOCK or %FGP_CREAT are specified then the function may sleep even
+ * if the %GFP flags specified for %FGP_CREAT are atomic.
  *
  * If there is a page cache page, it is returned with an increased refcount.
  *
- * Return: the found page or %NULL otherwise.
+ * Return: The found page or %NULL otherwise.
  */
-struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
-	int fgp_flags, gfp_t gfp_mask)
+struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
+		int fgp_flags, gfp_t gfp_mask)
 {
 	struct page *page;
 
 repeat:
-	page = find_get_entry(mapping, offset);
+	page = find_get_entry(mapping, index);
 	if (xa_is_value(page))
 		page = NULL;
 	if (!page)
@@ -1631,7 +1628,7 @@ repeat:
 			put_page(page);
 			goto repeat;
 		}
-		VM_BUG_ON_PAGE(page->index != offset, page);
+		VM_BUG_ON_PAGE(page->index != index, page);
 	}
 
 	if (fgp_flags & FGP_ACCESSED)
@@ -1656,7 +1653,7 @@ no_page:
 		if (fgp_flags & FGP_ACCESSED)
 			__SetPageReferenced(page);
 
-		err = add_to_page_cache_lru(page, mapping, offset, gfp_mask);
+		err = add_to_page_cache_lru(page, mapping, index, gfp_mask);
 		if (unlikely(err)) {
 			put_page(page);
 			page = NULL;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-optimise-find_subpage-for-thp.patch
mm-remove-config_transparent_huge_pagecache.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch
