From: akpm@linux-foundation.org
Subject: - use-page_cache_xxx-in-mm-truncatec.patch removed from -mm tree
Date: Tue, 04 Mar 2008 11:47:41 -0800
Message-ID: <200803041947.m24JlfOx025687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbYCDTsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:48:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dgc@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use page_cache_xxx in mm/truncate.c
has been removed from the -mm tree.  Its filename was
     use-page_cache_xxx-in-mm-truncatec.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx in mm/truncate.c
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx in mm/truncate.c

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN mm/truncate.c~use-page_cache_xxx-in-mm-truncatec mm/truncate.c
--- a/mm/truncate.c~use-page_cache_xxx-in-mm-truncatec
+++ a/mm/truncate.c
@@ -46,9 +46,10 @@ void do_invalidatepage(struct page *page
 		(*invalidatepage)(page, offset);
 }
 
-static inline void truncate_partial_page(struct page *page, unsigned partial)
+static inline void truncate_partial_page(struct address_space *mapping,
+			struct page *page, unsigned partial)
 {
-	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
+	zero_user_segment(page, partial, page_cache_size(mapping));
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
@@ -101,7 +102,7 @@ truncate_complete_page(struct address_sp
 	if (PagePrivate(page))
 		do_invalidatepage(page, 0);
 
-	cancel_dirty_page(page, PAGE_CACHE_SIZE);
+	cancel_dirty_page(page, page_cache_size(mapping));
 
 	remove_from_page_cache(page);
 	ClearPageUptodate(page);
@@ -160,9 +161,9 @@ invalidate_complete_page(struct address_
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, loff_t lend)
 {
-	const pgoff_t start = (lstart + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
+	const pgoff_t start = page_cache_next(mapping, lstart);
 	pgoff_t end;
-	const unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
+	const unsigned partial = page_cache_offset(mapping, lstart);
 	struct pagevec pvec;
 	pgoff_t next;
 	int i;
@@ -170,8 +171,9 @@ void truncate_inode_pages_range(struct a
 	if (mapping->nrpages == 0)
 		return;
 
-	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
-	end = (lend >> PAGE_CACHE_SHIFT);
+	BUG_ON(page_cache_offset(mapping, lend) !=
+				page_cache_size(mapping) - 1);
+	end = page_cache_index(mapping, lend);
 
 	pagevec_init(&pvec, 0);
 	next = start;
@@ -197,8 +199,8 @@ void truncate_inode_pages_range(struct a
 			}
 			if (page_mapped(page)) {
 				unmap_mapping_range(mapping,
-				  (loff_t)page_index<<PAGE_CACHE_SHIFT,
-				  PAGE_CACHE_SIZE, 0);
+				  page_cache_pos(mapping, page_index, 0),
+				  page_cache_size(mapping), 0);
 			}
 			truncate_complete_page(mapping, page);
 			unlock_page(page);
@@ -211,7 +213,7 @@ void truncate_inode_pages_range(struct a
 		struct page *page = find_lock_page(mapping, start - 1);
 		if (page) {
 			wait_on_page_writeback(page);
-			truncate_partial_page(page, partial);
+			truncate_partial_page(mapping, page, partial);
 			unlock_page(page);
 			page_cache_release(page);
 		}
@@ -239,8 +241,8 @@ void truncate_inode_pages_range(struct a
 			wait_on_page_writeback(page);
 			if (page_mapped(page)) {
 				unmap_mapping_range(mapping,
-				  (loff_t)page->index<<PAGE_CACHE_SHIFT,
-				  PAGE_CACHE_SIZE, 0);
+				  page_cache_pos(mapping, page->index, 0),
+				  page_cache_size(mapping), 0);
 			}
 			if (page->index > next)
 				next = page->index;
@@ -425,9 +427,8 @@ int invalidate_inode_pages2_range(struct
 					 * Zap the rest of the file in one hit.
 					 */
 					unmap_mapping_range(mapping,
-					   (loff_t)page_index<<PAGE_CACHE_SHIFT,
-					   (loff_t)(end - page_index + 1)
-							<< PAGE_CACHE_SHIFT,
+					   page_cache_pos(mapping, page_index, 0),
+					   page_cache_pos(mapping, end - page_index + 1, 0),
 					    0);
 					did_range_unmap = 1;
 				} else {
@@ -435,8 +436,8 @@ int invalidate_inode_pages2_range(struct
 					 * Just zap this page
 					 */
 					unmap_mapping_range(mapping,
-					  (loff_t)page_index<<PAGE_CACHE_SHIFT,
-					  PAGE_CACHE_SIZE, 0);
+					  page_cache_pos(mapping, page_index, 0),
+					  page_cache_size(mapping), 0);
 				}
 			}
 			BUG_ON(page_mapped(page));
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
ntfs-fix-nommu-build.patch
slub-fix-possible-null-pointer-dereference.patch
slub-fix-possible-null-pointer-dereference-fix.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
use-page_cache_xxx-in-mm-truncatec.patch
use-page_cache_xxx-in-mm-rmapc.patch
use-page_cache_xxx-in-mm-filemap_xipc.patch
use-page_cache_xxx-in-mm-migratec.patch
use-page_cache_xxx-in-fs-libfsc.patch
use-page_cache_xxx-in-fs-sync.patch
use-page_cache_xxx-in-fs-bufferc.patch
use-page_cache_xxx-in-mm-mpagec.patch
use-page_cache_xxx-in-mm-fadvisec.patch
mm-move-cache_line_size-to-linux-cacheh.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-ext2-fix.patch
use-page_cache_xxx-in-ext2-fix-2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

