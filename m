From: akpm@linux-foundation.org
Subject: - use-page_cache_xxx-in-mm-mpagec.patch removed from -mm tree
Date: Tue, 04 Mar 2008 11:47:56 -0800
Message-ID: <200803041947.m24JluBS025708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288AbYCDTtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:49:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dgc@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use page_cache_xxx in mm/mpage.c
has been removed from the -mm tree.  Its filename was
     use-page_cache_xxx-in-mm-mpagec.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx in mm/mpage.c
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx in mm/mpage.c

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN fs/mpage.c~use-page_cache_xxx-in-mm-mpagec fs/mpage.c
--- a/fs/mpage.c~use-page_cache_xxx-in-mm-mpagec
+++ a/fs/mpage.c
@@ -125,7 +125,8 @@ mpage_alloc(struct block_device *bdev,
 static void 
 map_buffer_to_page(struct page *page, struct buffer_head *bh, int page_block) 
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
 	struct buffer_head *page_bh, *head;
 	int block = 0;
 
@@ -134,9 +135,9 @@ map_buffer_to_page(struct page *page, st
 		 * don't make any buffers if there is only one buffer on
 		 * the page and the page just needs to be set up to date
 		 */
-		if (inode->i_blkbits == PAGE_CACHE_SHIFT && 
+		if (inode->i_blkbits == page_cache_shift(mapping) &&
 		    buffer_uptodate(bh)) {
-			SetPageUptodate(page);    
+			SetPageUptodate(page);
 			return;
 		}
 		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
@@ -169,9 +170,10 @@ do_mpage_readpage(struct bio *bio, struc
 		sector_t *last_block_in_bio, struct buffer_head *map_bh,
 		unsigned long *first_logical_block, get_block_t get_block)
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
-	const unsigned blocks_per_page = PAGE_CACHE_SIZE >> blkbits;
+	const unsigned blocks_per_page = page_cache_size(mapping) >> blkbits;
 	const unsigned blocksize = 1 << blkbits;
 	sector_t block_in_file;
 	sector_t last_block;
@@ -188,7 +190,7 @@ do_mpage_readpage(struct bio *bio, struc
 	if (page_has_buffers(page))
 		goto confused;
 
-	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
+	block_in_file = (sector_t)page->index << (page_cache_shift(mapping) - blkbits);
 	last_block = block_in_file + nr_pages * blocks_per_page;
 	last_block_in_file = (i_size_read(inode) + blocksize - 1) >> blkbits;
 	if (last_block > last_block_in_file)
@@ -276,7 +278,8 @@ do_mpage_readpage(struct bio *bio, struc
 	}
 
 	if (first_hole != blocks_per_page) {
-		zero_user_segment(page, first_hole << blkbits, PAGE_CACHE_SIZE);
+		zero_user_segment(page, first_hole << blkbits,
+					page_cache_size(mapping));
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -454,7 +457,7 @@ static int __mpage_writepage(struct page
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	unsigned long end_index;
-	const unsigned blocks_per_page = PAGE_CACHE_SIZE >> blkbits;
+	const unsigned blocks_per_page = page_cache_size(mapping) >> blkbits;
 	sector_t last_block;
 	sector_t block_in_file;
 	sector_t blocks[MAX_BUF_PER_PAGE];
@@ -523,7 +526,8 @@ static int __mpage_writepage(struct page
 	 * The page has no buffers: map it to disk
 	 */
 	BUG_ON(!PageUptodate(page));
-	block_in_file = (sector_t)page->index << (PAGE_CACHE_SHIFT - blkbits);
+	block_in_file = (sector_t)page->index <<
+			(page_cache_shift(mapping) - blkbits);
 	last_block = (i_size - 1) >> blkbits;
 	map_bh.b_page = page;
 	for (page_block = 0; page_block < blocks_per_page; ) {
@@ -555,7 +559,7 @@ static int __mpage_writepage(struct page
 	first_unmapped = page_block;
 
 page_is_mapped:
-	end_index = i_size >> PAGE_CACHE_SHIFT;
+	end_index = page_cache_index(mapping, i_size);
 	if (page->index >= end_index) {
 		/*
 		 * The page straddles i_size.  It must be zeroed out on each
@@ -565,11 +569,11 @@ page_is_mapped:
 		 * is zeroed when mapped, and writes to that region are not
 		 * written out to the file."
 		 */
-		unsigned offset = i_size & (PAGE_CACHE_SIZE - 1);
+		unsigned offset = page_cache_offset(mapping, i_size);
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		zero_user_segment(page, offset, PAGE_CACHE_SIZE);
+		zero_user_segment(page, offset, page_cache_size(mapping));
 	}
 
 	/*
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

