From: akpm@osdl.org
Subject: - ufs-alloc-metadata-null-page-fix.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:45 -0800
Message-ID: <200701302146.l0ULkjVn030125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51877 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbXA3Vqz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: alloc metadata null page fix
has been removed from the -mm tree.  Its filename was
     ufs-alloc-metadata-null-page-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ufs: alloc metadata null page fix
From: Evgeniy Dushistov <dushistov@mail.ru>

These series of patches result of UFS1 write support stress testing, like
running fsx-linux, untar and build linux kernel etc

We pass from ufs::get_block_t to levels below: pointer to the current page, to
make possible things like reallocation of blocks on the fly, and we also uses
this pointer for indication, what actually we allocate data block or meta data
block, but currently we make decision about what we allocate on the wrong
level, this may and cause oops if we allocate blocks in some special order.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/balloc.c |    5 ++++-
 fs/ufs/inode.c  |   14 +++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-alloc-metadata-null-page-fix fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-alloc-metadata-null-page-fix
+++ a/fs/ufs/balloc.c
@@ -233,7 +233,7 @@ static void ufs_change_blocknr(struct in
 {
 	unsigned int blk_per_page = 1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
 	struct address_space *mapping = inode->i_mapping;
-	pgoff_t index, cur_index = locked_page->index;
+	pgoff_t index, cur_index;
 	unsigned int i, j;
 	struct page *page;
 	struct buffer_head *head, *bh;
@@ -241,8 +241,11 @@ static void ufs_change_blocknr(struct in
 	UFSD("ENTER, ino %lu, count %u, oldb %u, newb %u\n",
 	      inode->i_ino, count, oldb, newb);
 
+	BUG_ON(!locked_page);
 	BUG_ON(!PageLocked(locked_page));
 
+	cur_index = locked_page->index;
+
 	for (i = 0; i < count; i += blk_per_page) {
 		index = (baseblk+i) >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
diff -puN fs/ufs/inode.c~ufs-alloc-metadata-null-page-fix fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-alloc-metadata-null-page-fix
+++ a/fs/ufs/inode.c
@@ -242,7 +242,8 @@ repeat:
 			goal = tmp + uspi->s_fpb;
 		tmp = ufs_new_fragments (inode, p, fragment - blockoff, 
 					 goal, required + blockoff,
-					 err, locked_page);
+					 err,
+					 phys != NULL ? locked_page : NULL);
 	}
 	/*
 	 * We will extend last allocated block
@@ -250,7 +251,7 @@ repeat:
 	else if (lastblock == block) {
 		tmp = ufs_new_fragments(inode, p, fragment - (blockoff - lastblockoff),
 					fs32_to_cpu(sb, *p), required +  (blockoff - lastblockoff),
-					err, locked_page);
+					err, phys != NULL ? locked_page : NULL);
 	} else /* (lastblock > block) */ {
 	/*
 	 * We will allocate new block before last allocated block
@@ -261,7 +262,8 @@ repeat:
 				goal = tmp + uspi->s_fpb;
 		}
 		tmp = ufs_new_fragments(inode, p, fragment - blockoff,
-					goal, uspi->s_fpb, err, locked_page);
+					goal, uspi->s_fpb, err,
+					phys != NULL ? locked_page : NULL);
 	}
 	if (!tmp) {
 		if ((!blockoff && *p) || 
@@ -438,9 +440,11 @@ int ufs_getfrag_block(struct inode *inod
 	 * it much more readable:
 	 */
 #define GET_INODE_DATABLOCK(x) \
-	ufs_inode_getfrag(inode, x, fragment, 1, &err, &phys, &new, bh_result->b_page)
+	ufs_inode_getfrag(inode, x, fragment, 1, &err, &phys, &new,\
+			  bh_result->b_page)
 #define GET_INODE_PTR(x) \
-	ufs_inode_getfrag(inode, x, fragment, uspi->s_fpb, &err, NULL, NULL, NULL)
+	ufs_inode_getfrag(inode, x, fragment, uspi->s_fpb, &err, NULL, NULL,\
+			  bh_result->b_page)
 #define GET_INDIRECT_DATABLOCK(x) \
 	ufs_inode_getblock(inode, bh, x, fragment,	\
 			  &err, &phys, &new, bh_result->b_page)
_

Patches currently in -mm which might be from dushistov@mail.ru are

origin.patch
ufs2-write-mount-as-rw.patch
ufs2-write-inodes-write.patch
ufs2-write-block-allocation-update.patch
