From: akpm@linux-foundation.org
Subject: - ufs-prepare-write-change-blocks-on-the-fly.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:08:50 -0800
Message-ID: <200703180908.l2I98oEn019978@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60367 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbXCRJI4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: prepare write + change blocks on the fly
has been removed from the -mm tree.  Its filename was
     ufs-prepare-write-change-blocks-on-the-fly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs: prepare write + change blocks on the fly
From: Evgeniy Dushistov <dushistov@mail.ru>

This patch fixes "change blocks numbers on the fly" in case when "prepare
   write page" is in the call chain, in this case some buffers may be not
   uptodate and not mapped, we should care to map them and load from disk.

This patch was tested with:
ufs regressions simple tests
fsx-linux
ltp(20060306)
untar and build kernel

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |   81 ++++++++++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 28 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-prepare-write-change-blocks-on-the-fly fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-prepare-write-change-blocks-on-the-fly
+++ a/fs/ufs/balloc.c
@@ -244,62 +244,87 @@ failed:
  * We can come here from ufs_writepage or ufs_prepare_write,
  * locked_page is argument of these functions, so we already lock it.
  */
-static void ufs_change_blocknr(struct inode *inode, unsigned int beg,
-			       unsigned int count, unsigned int oldb,
-			       unsigned int newb, struct page *locked_page)
+static void ufs_change_blocknr(struct inode *inode, sector_t beg,
+			       unsigned int count, sector_t oldb,
+			       sector_t newb, struct page *locked_page)
 {
-	const unsigned mask = (1 << (PAGE_CACHE_SHIFT - inode->i_blkbits)) - 1;
+	const unsigned blks_per_page =
+		1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	const unsigned mask = blks_per_page - 1;
 	struct address_space * const mapping = inode->i_mapping;
-	pgoff_t index, cur_index;
-	unsigned end, pos, j;
+	pgoff_t index, cur_index, last_index;
+	unsigned pos, j, lblock;
+	sector_t end, i;
 	struct page *page;
 	struct buffer_head *head, *bh;
 
-	UFSD("ENTER, ino %lu, count %u, oldb %u, newb %u\n",
-	      inode->i_ino, count, oldb, newb);
+	UFSD("ENTER, ino %lu, count %u, oldb %llu, newb %llu\n",
+	      inode->i_ino, count,
+	     (unsigned long long)oldb, (unsigned long long)newb);
 
 	BUG_ON(!locked_page);
 	BUG_ON(!PageLocked(locked_page));
 
 	cur_index = locked_page->index;
-
-	for (end = count + beg; beg < end; beg = (beg | mask) + 1) {
-		index = beg >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	end = count + beg;
+	last_index = end >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	for (i = beg; i < end; i = (i | mask) + 1) {
+		index = i >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 		if (likely(cur_index != index)) {
 			page = ufs_get_locked_page(mapping, index);
-			if (!page || IS_ERR(page)) /* it was truncated or EIO */
+			if (!page)/* it was truncated */
+				continue;
+			if (IS_ERR(page)) {/* or EIO */
+				ufs_error(inode->i_sb, __FUNCTION__,
+					  "read of page %llu failed\n",
+					  (unsigned long long)index);
 				continue;
+			}
 		} else
 			page = locked_page;
 
 		head = page_buffers(page);
 		bh = head;
-		pos = beg & mask;
+		pos = i & mask;
 		for (j = 0; j < pos; ++j)
 			bh = bh->b_this_page;
-		j = 0;
+
+
+		if (unlikely(index == last_index))
+			lblock = end & mask;
+		else
+			lblock = blks_per_page;
+
 		do {
-			if (buffer_mapped(bh)) {
-				pos = bh->b_blocknr - oldb;
-				if (pos < count) {
-					UFSD(" change from %llu to %llu\n",
-					     (unsigned long long)pos + oldb,
-					     (unsigned long long)pos + newb);
-					bh->b_blocknr = newb + pos;
-					unmap_underlying_metadata(bh->b_bdev,
-								  bh->b_blocknr);
-					mark_buffer_dirty(bh);
-					++j;
+			if (j >= lblock)
+				break;
+			pos = (i - beg) + j;
+
+			if (!buffer_mapped(bh))
+					map_bh(bh, inode->i_sb, oldb + pos);
+			if (!buffer_uptodate(bh)) {
+				ll_rw_block(READ, 1, &bh);
+				wait_on_buffer(bh);
+				if (!buffer_uptodate(bh)) {
+					ufs_error(inode->i_sb, __FUNCTION__,
+						  "read of block failed\n");
+					break;
 				}
 			}
 
+			UFSD(" change from %llu to %llu, pos %u\n",
+			     (unsigned long long)pos + oldb,
+			     (unsigned long long)pos + newb, pos);
+
+			bh->b_blocknr = newb + pos;
+			unmap_underlying_metadata(bh->b_bdev,
+						  bh->b_blocknr);
+			mark_buffer_dirty(bh);
+			++j;
 			bh = bh->b_this_page;
 		} while (bh != head);
 
-		if (j)
-			set_page_dirty(page);
-
 		if (likely(cur_index != index))
 			ufs_put_locked_page(page);
  	}
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
