From: akpm@osdl.org
Subject: + add-truncate_unmap_inode_pages_range.patch added to -mm tree
Date: Wed, 24 Jan 2007 23:23:41 -0800
Message-ID: <200701250723.l0P7NfCI009116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51569 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965669AbXAYHXo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 02:23:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dgc@sgi.com, nickpiggin@yahoo.com.au


The patch titled
     add truncate_unmap_inode_pages_range()
has been added to the -mm tree.  Its filename is
     add-truncate_unmap_inode_pages_range.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add truncate_unmap_inode_pages_range()
From: David Chinner <dgc@sgi.com>

With the recent changes to cancel_dirty_pages(), XFS will dump warnings in
the syslog because it can truncate_inode_pages() on dirty mapped pages.

I've determined that this is indeed correct behaviour for XFS as this can
happen in the case of races on mmap()d files with direct I/O.  In this case
when we do a direct I/O read, we flush the dirty pages to disk, then
truncate them out of the page cache.  Unfortunately, between the flush and
the truncate the mmap could dirty the page again.  At this point we toss a
dirty page that is mapped.

None of the existing functions for truncating pages or invalidating pages
work in this situation.  Invalidating a page only works for non-dirty pages
with non-dirty buffers, and they only work for whole pages and XFS requires
partial page truncation.

On top of that the page invalidation functions don't actually call into the
filesystem to invalidate the page and so the filesystem can't actually
invalidate the page properly (e.g.  do stuff based on private buffer head
flags).

So that leaves us needing to use truncate semantics an the problem is that
none of them unmap pages in a non-racy manner - if they unmap pages they do
it separately tothe truncate of the page, leading to races with mmap
redirtying the page between the unmap and the truncate ofthe page.

Hence we need a truncate function that unmaps the pages while they are
locked for truncate in a similar fashion to
invalidate_inode_pages2_range().  The following patch (unchanged from the
last time it was sent) does this.  The XFS changes are in a second patch.

The patch has been test on ia64 and x86-64 via XFSQA and a lot of fsx
mixing mmap and direct I/O operations.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mm.h |    2 +
 mm/truncate.c      |   60 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 56 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~add-truncate_unmap_inode_pages_range include/linux/mm.h
--- a/include/linux/mm.h~add-truncate_unmap_inode_pages_range
+++ a/include/linux/mm.h
@@ -1059,6 +1059,8 @@ extern unsigned long page_unuse(struct p
 extern void truncate_inode_pages(struct address_space *, loff_t);
 extern void truncate_inode_pages_range(struct address_space *,
 				       loff_t lstart, loff_t lend);
+extern void truncate_unmap_inode_pages_range(struct address_space *,
+				       loff_t lstart, loff_t lend, int unmap);
 
 /* generic vm_area_ops exported for stackable file systems */
 extern struct page *filemap_nopage(struct vm_area_struct *, unsigned long, int *);
diff -puN mm/truncate.c~add-truncate_unmap_inode_pages_range mm/truncate.c
--- a/mm/truncate.c~add-truncate_unmap_inode_pages_range
+++ a/mm/truncate.c
@@ -59,7 +59,7 @@ void cancel_dirty_page(struct page *page
 
 		WARN_ON(++warncount < 5);
 	}
-		
+
 	if (TestClearPageDirty(page)) {
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
@@ -122,16 +122,34 @@ invalidate_complete_page(struct address_
 	return ret;
 }
 
+/*
+ * This is a helper for truncate_unmap_inode_page. Unmap the page we
+ * are passed. Page must be locked by the caller.
+ */
+static void
+unmap_single_page(struct address_space *mapping, struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	while (page_mapped(page)) {
+		unmap_mapping_range(mapping,
+			(loff_t)page->index << PAGE_CACHE_SHIFT,
+			PAGE_CACHE_SIZE, 0);
+	}
+}
+
 /**
- * truncate_inode_pages - truncate range of pages specified by start and
+ * truncate_unmap_inode_pages_range - truncate range of pages specified by
+ * start and end byte offsets and optionally unmap them first.
  * end byte offsets
  * @mapping: mapping to truncate
  * @lstart: offset from which to truncate
  * @lend: offset to which to truncate
+ * @unmap: unmap whole truncated pages if non-zero
  *
  * Truncate the page cache, removing the pages that are between
  * specified offsets (and zeroing out partial page
- * (if lstart is not page aligned)).
+ * (if lstart is not page aligned)). If specified, unmap the pages
+ * before they are removed.
  *
  * Truncate takes two passes - the first pass is nonblocking.  It will not
  * block on page locks and it will not block on writeback.  The second pass
@@ -146,8 +164,8 @@ invalidate_complete_page(struct address_
  * mapping is large, it is probably the case that the final pages are the most
  * recently touched, and freeing happens in ascending file offset order.
  */
-void truncate_inode_pages_range(struct address_space *mapping,
-				loff_t lstart, loff_t lend)
+void truncate_unmap_inode_pages_range(struct address_space *mapping,
+				loff_t lstart, loff_t lend, int unmap)
 {
 	const pgoff_t start = (lstart + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	pgoff_t end;
@@ -162,6 +180,14 @@ void truncate_inode_pages_range(struct a
 	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
 	end = (lend >> PAGE_CACHE_SHIFT);
 
+	/*
+	 * if unmapping, do a range unmap up front to minimise the
+	 * overhead of unmapping the pages
+	 */
+	if (unmap) {
+		unmap_mapping_range(mapping, (loff_t)start << PAGE_CACHE_SHIFT,
+					   (loff_t)end << PAGE_CACHE_SHIFT, 0);
+	}
 	pagevec_init(&pvec, 0);
 	next = start;
 	while (next <= end &&
@@ -184,6 +210,8 @@ void truncate_inode_pages_range(struct a
 				unlock_page(page);
 				continue;
 			}
+			if (unmap)
+				unmap_single_page(mapping, page);
 			truncate_complete_page(mapping, page);
 			unlock_page(page);
 		}
@@ -195,6 +223,8 @@ void truncate_inode_pages_range(struct a
 		struct page *page = find_lock_page(mapping, start - 1);
 		if (page) {
 			wait_on_page_writeback(page);
+			if (unmap)
+				unmap_single_page(mapping, page);
 			truncate_partial_page(page, partial);
 			unlock_page(page);
 			page_cache_release(page);
@@ -224,12 +254,30 @@ void truncate_inode_pages_range(struct a
 			if (page->index > next)
 				next = page->index;
 			next++;
+			if (unmap)
+				unmap_single_page(mapping, page);
 			truncate_complete_page(mapping, page);
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
 	}
 }
+EXPORT_SYMBOL(truncate_unmap_inode_pages_range);
+
+/**
+ * truncate_inode_pages_range - truncate range of pages specified by start and
+ * end byte offsets
+ * @mapping: mapping to truncate
+ * @lstart: offset from which to truncate
+ * @lend: offset to which to truncate
+ *
+ * Called under (and serialised by) inode->i_mutex.
+ */
+void truncate_inode_pages_range(struct address_space *mapping,
+				loff_t lstart, loff_t lend)
+{
+	truncate_unmap_inode_pages_range(mapping, lstart, lend, 0);
+}
 EXPORT_SYMBOL(truncate_inode_pages_range);
 
 /**
@@ -241,7 +289,7 @@ EXPORT_SYMBOL(truncate_inode_pages_range
  */
 void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 {
-	truncate_inode_pages_range(mapping, lstart, (loff_t)-1);
+	truncate_unmap_inode_pages_range(mapping, lstart, (loff_t)-1, 0);
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
_

Patches currently in -mm which might be from dgc@sgi.com are

add-truncate_unmap_inode_pages_range.patch
xfs-remove-useless-wmb-memory-barrier.patch
make-bh_unwritten-a-first-class-bufferhead-flag-v2.patch
make-xfs-use-bh_unwritten-and-bh_delay-correctly.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
