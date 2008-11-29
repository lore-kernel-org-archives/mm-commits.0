From: akpm@linux-foundation.org
Subject: - do_mpage_readpage-remove-first_logical_block-parameter.patch removed from -mm tree
Date: Sat, 29 Nov 2008 01:23:23 -0800
Message-ID: <200811290923.mAT9NNAW017005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbYK2JX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 04:23:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fbuihuu@gmail.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     do_mpage_readpage(): remove first_logical_block parameter
has been removed from the -mm tree.  Its filename was
     do_mpage_readpage-remove-first_logical_block-parameter.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_mpage_readpage(): remove first_logical_block parameter
From: Franck Bui-Huu <fbuihuu@gmail.com>

Mak this function more readable by getting rid of its parameter
'first_logical_block'.

This parameter was previously used to remember the original block number
in the file (ie the page index) that 'map_bh' was pointing at first. 
Indeed this was needed since 'map_bh->page' was modified even if 'map_bh'
maps the whole current page (IOW when get_block() is not used).  This had
the bad effect to make the state of 'map_bh' inconsistent too.

This patch changes 'map_bh->page' only when get_block() is called hence
removes the need of the 'first_logical_block' argument.

The value stored in 'logical_block_parameter' is now recalculated each
time do_mpage_readpage() but it shouldn't matter since the operation is
trivial.

While at it, this patch does a few extra cleanups such as removing a
trailing space, moving 2 declarations of local variables closer to the
place they're used.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |   64 ++++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff -puN fs/mpage.c~do_mpage_readpage-remove-first_logical_block-parameter fs/mpage.c
--- a/fs/mpage.c~do_mpage_readpage-remove-first_logical_block-parameter
+++ a/fs/mpage.c
@@ -168,7 +168,7 @@ map_buffer_to_page(struct page *page, st
 static struct bio *
 do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 		sector_t *last_block_in_bio, struct buffer_head *map_bh,
-		unsigned long *first_logical_block, get_block_t get_block)
+		get_block_t get_block)
 {
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
@@ -183,8 +183,6 @@ do_mpage_readpage(struct bio *bio, struc
 	struct block_device *bdev = NULL;
 	int length;
 	int fully_mapped = 1;
-	unsigned nblocks;
-	unsigned relative_block;
 
 	if (page_has_buffers(page))
 		goto confused;
@@ -199,40 +197,45 @@ do_mpage_readpage(struct bio *bio, struc
 	/*
 	 * Map blocks using the result from the previous get_blocks call first.
 	 */
-	nblocks = map_bh->b_size >> blkbits;
-	if (buffer_mapped(map_bh) && block_in_file > *first_logical_block &&
-			block_in_file < (*first_logical_block + nblocks)) {
-		unsigned map_offset = block_in_file - *first_logical_block;
-		unsigned last = nblocks - map_offset;
-
-		for (relative_block = 0; ; relative_block++) {
-			if (relative_block == last) {
-				clear_buffer_mapped(map_bh);
-				break;
+	if (buffer_mapped(map_bh)) {
+		unsigned nblocks = map_bh->b_size >> blkbits;
+		sector_t map_block = (sector_t)map_bh->b_page->index <<
+						(PAGE_CACHE_SHIFT - blkbits);
+
+		if (block_in_file > map_block &&
+		    block_in_file < map_block + nblocks) {
+			unsigned blocknr_off = block_in_file - map_block;
+			sector_t map_blocknr = map_bh->b_blocknr;
+
+			for (;; blocknr_off++) {
+				if (blocknr_off == nblocks) {
+					clear_buffer_mapped(map_bh);
+					break;
+				}
+				if (page_block == blocks_per_page)
+					break;
+				blocks[page_block] = map_blocknr + blocknr_off;
+				page_block++;
+				block_in_file++;
 			}
-			if (page_block == blocks_per_page)
-				break;
-			blocks[page_block] = map_bh->b_blocknr + map_offset +
-						relative_block;
-			page_block++;
-			block_in_file++;
+			bdev = map_bh->b_bdev;
 		}
-		bdev = map_bh->b_bdev;
 	}
 
 	/*
 	 * Then do more get_blocks calls until we are done with this page.
 	 */
-	map_bh->b_page = page;
 	while (page_block < blocks_per_page) {
+		unsigned nblocks, blocknr_off = 0;
+
 		map_bh->b_state = 0;
 		map_bh->b_size = 0;
 
 		if (block_in_file < last_block) {
+			map_bh->b_page = page;
 			map_bh->b_size = (last_block-block_in_file) << blkbits;
 			if (get_block(inode, block_in_file, map_bh, 0))
 				goto confused;
-			*first_logical_block = block_in_file;
 		}
 
 		if (!buffer_mapped(map_bh)) {
@@ -254,21 +257,23 @@ do_mpage_readpage(struct bio *bio, struc
 			map_buffer_to_page(page, map_bh, page_block);
 			goto confused;
 		}
-	
+
 		if (first_hole != blocks_per_page)
 			goto confused;		/* hole -> non-hole */
 
 		/* Contiguous blocks? */
 		if (page_block && blocks[page_block-1] != map_bh->b_blocknr-1)
 			goto confused;
+
 		nblocks = map_bh->b_size >> blkbits;
-		for (relative_block = 0; ; relative_block++) {
-			if (relative_block == nblocks) {
+		for (;; blocknr_off++) {
+			if (blocknr_off == nblocks) {
 				clear_buffer_mapped(map_bh);
 				break;
-			} else if (page_block == blocks_per_page)
+			}
+			if (page_block == blocks_per_page)
 				break;
-			blocks[page_block] = map_bh->b_blocknr+relative_block;
+			blocks[page_block] = map_bh->b_blocknr + blocknr_off;
 			page_block++;
 			block_in_file++;
 		}
@@ -378,7 +383,6 @@ mpage_readpages(struct address_space *ma
 	unsigned page_idx;
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
-	unsigned long first_logical_block = 0;
 
 	clear_buffer_mapped(&map_bh);
 	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
@@ -391,7 +395,6 @@ mpage_readpages(struct address_space *ma
 			bio = do_mpage_readpage(bio, page,
 					nr_pages - page_idx,
 					&last_block_in_bio, &map_bh,
-					&first_logical_block,
 					get_block);
 		}
 		page_cache_release(page);
@@ -411,11 +414,10 @@ int mpage_readpage(struct page *page, ge
 	struct bio *bio = NULL;
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
-	unsigned long first_logical_block = 0;
 
 	clear_buffer_mapped(&map_bh);
 	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
-			&map_bh, &first_logical_block, get_block);
+			&map_bh, get_block);
 	if (bio)
 		mpage_bio_submit(READ, bio);
 	return 0;
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

do_mpage_readpage-remove-useless-clear_buffer_mapped-call.patch
do_mpage_readpage-remove-first_logical_block-parameter.patch

