From: akpm@osdl.org
Subject: - ufs-rellocation-fix.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:50 -0800
Message-ID: <200701302146.l0ULkoea030132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXA3Vqy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: reallocation fix
has been removed from the -mm tree.  Its filename was
     ufs-rellocation-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs: reallocation fix
From: Evgeniy Dushistov <dushistov@mail.ru>

In blocks reallocation function sometimes does not update some of
buffer_head::b_blocknr, which may and cause data damage.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/balloc.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-rellocation-fix fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-rellocation-fix
+++ a/fs/ufs/balloc.c
@@ -227,14 +227,14 @@ failed:
  * We can come here from ufs_writepage or ufs_prepare_write,
  * locked_page is argument of these functions, so we already lock it.
  */
-static void ufs_change_blocknr(struct inode *inode, unsigned int baseblk,
+static void ufs_change_blocknr(struct inode *inode, unsigned int beg,
 			       unsigned int count, unsigned int oldb,
 			       unsigned int newb, struct page *locked_page)
 {
-	unsigned int blk_per_page = 1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	struct address_space *mapping = inode->i_mapping;
+	const unsigned mask = (1 << (PAGE_CACHE_SHIFT - inode->i_blkbits)) - 1;
+	struct address_space * const mapping = inode->i_mapping;
 	pgoff_t index, cur_index;
-	unsigned int i, j;
+	unsigned end, pos, j;
 	struct page *page;
 	struct buffer_head *head, *bh;
 
@@ -246,8 +246,8 @@ static void ufs_change_blocknr(struct in
 
 	cur_index = locked_page->index;
 
-	for (i = 0; i < count; i += blk_per_page) {
-		index = (baseblk+i) >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	for (end = count + beg; beg < end; beg = (beg | mask) + 1) {
+		index = beg >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 		if (likely(cur_index != index)) {
 			page = ufs_get_locked_page(mapping, index);
@@ -256,21 +256,32 @@ static void ufs_change_blocknr(struct in
 		} else
 			page = locked_page;
 
-		j = i;
 		head = page_buffers(page);
 		bh = head;
+		pos = beg & mask;
+		for (j = 0; j < pos; ++j)
+			bh = bh->b_this_page;
+		j = 0;
 		do {
-			if (likely(bh->b_blocknr == j + oldb && j < count)) {
-				unmap_underlying_metadata(bh->b_bdev,
-							  bh->b_blocknr);
-				bh->b_blocknr = newb + j++;
-				mark_buffer_dirty(bh);
+			if (buffer_mapped(bh)) {
+				pos = bh->b_blocknr - oldb;
+				if (pos < count) {
+					UFSD(" change from %llu to %llu\n",
+					     (unsigned long long)pos + oldb,
+					     (unsigned long long)pos + newb);
+					bh->b_blocknr = newb + pos;
+					unmap_underlying_metadata(bh->b_bdev,
+								  bh->b_blocknr);
+					mark_buffer_dirty(bh);
+					++j;
+				}
 			}
 
 			bh = bh->b_this_page;
 		} while (bh != head);
 
-		set_page_dirty(page);
+		if (j)
+			set_page_dirty(page);
 
 		if (likely(cur_index != index))
 			ufs_put_locked_page(page);
@@ -418,14 +429,14 @@ unsigned ufs_new_fragments(struct inode 
 	}
 	result = ufs_alloc_fragments (inode, cgno, goal, request, err);
 	if (result) {
+		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
+				locked_page != NULL);
 		ufs_change_blocknr(inode, fragment - oldcount, oldcount, tmp,
 				   result, locked_page);
 
 		*p = cpu_to_fs32(sb, result);
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
-		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
-				locked_page != NULL);
 		unlock_super(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch
