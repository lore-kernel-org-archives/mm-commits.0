From: akpm@osdl.org
Subject: + fix-garbage-instead-of-zeroes-in-ufs.patch added to -mm tree
Date: Wed, 20 Dec 2006 21:36:02 -0800
Message-ID: <200612210536.kBL5a2uX016753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40047 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422732AbWLUFgH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 00:36:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru


The patch titled
     fix garbage instead of zeroes in UFS
has been added to the -mm tree.  Its filename is
     fix-garbage-instead-of-zeroes-in-ufs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix garbage instead of zeroes in UFS
From: Evgeniy Dushistov <dushistov@mail.ru>

Looks like this is the problem, which point Al Viro some time ago:

when we allocate block(in this situation 16K) we mark as new
only one fragment(in this situation 2K),

I don't see _right_ way to do nullification of whole block, if use inode
page cache, some pages may be outside of inode limits (inode size), and
will be lost; if use blockdev page cache it is possible to zero real data,
if later inode page cache will be used.

The simpliest way, as can I see usage of block device page cache, but not
only mark dirty, but also sync it during "nullification".



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ufs/balloc.c |   25 +++++++++++++++++++++++++
 fs/ufs/inode.c  |   41 +++++------------------------------------
 2 files changed, 30 insertions(+), 36 deletions(-)

diff -puN fs/ufs/balloc.c~fix-garbage-instead-of-zeroes-in-ufs fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~fix-garbage-instead-of-zeroes-in-ufs
+++ a/fs/ufs/balloc.c
@@ -275,6 +275,25 @@ static void ufs_change_blocknr(struct in
 	UFSD("EXIT\n");
 }
 
+static void ufs_clear_frags(struct inode *inode, sector_t beg, unsigned int n,
+			    int sync)
+{
+	struct buffer_head *bh;
+	sector_t end = beg + n;
+
+	for (; beg < end; ++beg) {
+		bh = sb_getblk(inode->i_sb, beg);
+		lock_buffer(bh);
+		memset(bh->b_data, 0, inode->i_sb->s_blocksize);
+		set_buffer_uptodate(bh);
+		mark_buffer_dirty(bh);
+		unlock_buffer(bh);
+		if (IS_SYNC(inode) || sync)
+			sync_dirty_buffer(bh);
+		brelse(bh);
+	}
+}
+
 unsigned ufs_new_fragments(struct inode * inode, __fs32 * p, unsigned fragment,
 			   unsigned goal, unsigned count, int * err, struct page *locked_page)
 {
@@ -350,6 +369,8 @@ unsigned ufs_new_fragments(struct inode 
 			*p = cpu_to_fs32(sb, result);
 			*err = 0;
 			UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
+			ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
+					locked_page != NULL);
 		}
 		unlock_super(sb);
 		UFSD("EXIT, result %u\n", result);
@@ -363,6 +384,8 @@ unsigned ufs_new_fragments(struct inode 
 	if (result) {
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
+		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
+				locked_page != NULL);
 		unlock_super(sb);
 		UFSD("EXIT, result %u\n", result);
 		return result;
@@ -398,6 +421,8 @@ unsigned ufs_new_fragments(struct inode 
 		*p = cpu_to_fs32(sb, result);
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
+		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
+				locked_page != NULL);
 		unlock_super(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
diff -puN fs/ufs/inode.c~fix-garbage-instead-of-zeroes-in-ufs fs/ufs/inode.c
--- a/fs/ufs/inode.c~fix-garbage-instead-of-zeroes-in-ufs
+++ a/fs/ufs/inode.c
@@ -156,36 +156,6 @@ out:
 	return ret;
 }
 
-static void ufs_clear_frag(struct inode *inode, struct buffer_head *bh)
-{
-	lock_buffer(bh);
-	memset(bh->b_data, 0, inode->i_sb->s_blocksize);
-	set_buffer_uptodate(bh);
-	mark_buffer_dirty(bh);
-	unlock_buffer(bh);
-	if (IS_SYNC(inode))
-		sync_dirty_buffer(bh);
-}
-
-static struct buffer_head *
-ufs_clear_frags(struct inode *inode, sector_t beg,
-		unsigned int n, sector_t want)
-{
-	struct buffer_head *res = NULL, *bh;
-	sector_t end = beg + n;
-
-	for (; beg < end; ++beg) {
-		bh = sb_getblk(inode->i_sb, beg);
-		ufs_clear_frag(inode, bh);
-		if (want != beg)
-			brelse(bh);
-		else
-			res = bh;
-	}
-	BUG_ON(!res);
-	return res;
-}
-
 /**
  * ufs_inode_getfrag() - allocate new fragment(s)
  * @inode - pointer to inode
@@ -302,7 +272,7 @@ repeat:
 	}
 
 	if (!phys) {
-		result = ufs_clear_frags(inode, tmp, required, tmp + blockoff);
+		result = sb_getblk(sb, tmp + blockoff);
 	} else {
 		*phys = tmp + blockoff;
 		result = NULL;
@@ -403,8 +373,7 @@ repeat:
 
 
 	if (!phys) {
-		result = ufs_clear_frags(inode, tmp, uspi->s_fpb,
-					 tmp + blockoff);
+		result = sb_getblk(sb, tmp + blockoff);
 	} else {
 		*phys = tmp + blockoff;
 		*new = 1;
@@ -471,13 +440,13 @@ int ufs_getfrag_block(struct inode *inod
 #define GET_INODE_DATABLOCK(x) \
 	ufs_inode_getfrag(inode, x, fragment, 1, &err, &phys, &new, bh_result->b_page)
 #define GET_INODE_PTR(x) \
-	ufs_inode_getfrag(inode, x, fragment, uspi->s_fpb, &err, NULL, NULL, bh_result->b_page)
+	ufs_inode_getfrag(inode, x, fragment, uspi->s_fpb, &err, NULL, NULL, NULL)
 #define GET_INDIRECT_DATABLOCK(x) \
 	ufs_inode_getblock(inode, bh, x, fragment,	\
-			  &err, &phys, &new, bh_result->b_page);
+			  &err, &phys, &new, bh_result->b_page)
 #define GET_INDIRECT_PTR(x) \
 	ufs_inode_getblock(inode, bh, x, fragment,	\
-			  &err, NULL, NULL, bh_result->b_page);
+			  &err, NULL, NULL, NULL)
 
 	if (ptr < UFS_NDIR_FRAGMENT) {
 		bh = GET_INODE_DATABLOCK(ptr);
_

Patches currently in -mm which might be from dushistov@mail.ru are

fix-garbage-instead-of-zeroes-in-ufs.patch

