From: akpm@osdl.org
Subject: + ufs-rellocation-fix.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:21:36 -0800
Message-ID: <200701250421.l0P4LaYs005632@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198AbXAYEVk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:21:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru


The patch titled
     ufs: reallocation fix
has been added to the -mm tree.  Its filename is
     ufs-rellocation-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs: reallocation fix
From: Evgeniy Dushistov <dushistov@mail.ru>

In blocks reallocation function sometimes does not update some of
buffer_head::b_blocknr, which may and cause data damage.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/balloc.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-rellocation-fix fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-rellocation-fix
+++ a/fs/ufs/balloc.c
@@ -231,10 +231,10 @@ static void ufs_change_blocknr(struct in
 			       unsigned int count, unsigned int oldb,
 			       unsigned int newb, struct page *locked_page)
 {
-	unsigned int blk_per_page = 1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	struct address_space *mapping = inode->i_mapping;
+	const unsigned mask = (1 << (PAGE_CACHE_SHIFT - inode->i_blkbits)) - 1;
+	struct address_space * const mapping = inode->i_mapping;
 	pgoff_t index, cur_index;
-	unsigned int i, j;
+	unsigned i, pos, j;
 	struct page *page;
 	struct buffer_head *head, *bh;
 
@@ -246,7 +246,7 @@ static void ufs_change_blocknr(struct in
 
 	cur_index = locked_page->index;
 
-	for (i = 0; i < count; i += blk_per_page) {
+	for (i = 0; i < count; i = (i | mask) + 1) {
 		index = (baseblk+i) >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 		if (likely(cur_index != index)) {
@@ -256,21 +256,32 @@ static void ufs_change_blocknr(struct in
 		} else
 			page = locked_page;
 
-		j = i;
 		head = page_buffers(page);
 		bh = head;
+		pos = i & mask;
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
+					     (unsigned long long)pos + odlb,
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

ufs-alloc-metadata-null-page-fix.patch
ufs-truncate-negative-to-unsigned-fix.patch
ufs-rellocation-fix.patch
