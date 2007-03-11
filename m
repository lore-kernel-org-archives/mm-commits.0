From: akpm@linux-foundation.org
Subject: + ufs-zeroize-the-rest-of-block-in-truncate.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:47:51 -0800
Message-ID: <200703110747.l2B7lp4d007252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39088 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbXCKHr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru


The patch titled
     ufs: zeroize the rest of block in truncate
has been added to the -mm tree.  Its filename is
     ufs-zeroize-the-rest-of-block-in-truncate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs: zeroize the rest of block in truncate
From: Evgeniy Dushistov <dushistov@mail.ru>

This patch fix behaviour in such test scenario:

lseek(fd, BIG_OFFSET)
write(fd, buf, sizeof(buf))
truncate(BIG_OFFSET)
truncate(BIG_OFFSET + sizeof(buf))
read(fd, buf...)

Because of if file big enough(BIG_OFFSET) we start allocate space by block,
ordinary block size > page size, so we should zeroize the rest of block in
truncate(except last framgnet, about which VFS should care), to not get
garbage, when we extend file.

Also patch corrects conversion from pointer to block to physical block number,
this helps in case of not common used UFS types.

And add to debug output inode number.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c   |    5 +++--
 fs/ufs/inode.c    |   12 ++++++------
 fs/ufs/truncate.c |   36 ++++++++++++++++++++++++++----------
 3 files changed, 35 insertions(+), 18 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-zeroize-the-rest-of-block-in-truncate fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-zeroize-the-rest-of-block-in-truncate
+++ a/fs/ufs/balloc.c
@@ -482,8 +482,9 @@ u64 ufs_new_fragments(struct inode *inod
 	if (result) {
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
-		ufs_change_blocknr(inode, fragment - oldcount, oldcount, tmp,
-				   result, locked_page);
+		ufs_change_blocknr(inode, fragment - oldcount, oldcount,
+				   uspi->s_sbbase + tmp,
+				   uspi->s_sbbase + result, locked_page);
 		ufs_cpu_to_data_ptr(sb, p, result);
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
diff -puN fs/ufs/inode.c~ufs-zeroize-the-rest-of-block-in-truncate fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-zeroize-the-rest-of-block-in-truncate
+++ a/fs/ufs/inode.c
@@ -212,7 +212,7 @@ repeat:
 			brelse (result);
 			goto repeat;
 		} else {
-			*phys = tmp + blockoff;
+			*phys = uspi->s_sbbase + tmp + blockoff;
 			return NULL;
 		}
 	}
@@ -282,9 +282,9 @@ repeat:
 	}
 
 	if (!phys) {
-		result = sb_getblk(sb, tmp + blockoff);
+		result = sb_getblk(sb, uspi->s_sbbase + tmp + blockoff);
 	} else {
-		*phys = tmp + blockoff;
+		*phys = uspi->s_sbbase + tmp + blockoff;
 		result = NULL;
 		*err = 0;
 		*new = 1;
@@ -368,7 +368,7 @@ repeat:
 			brelse (result);
 			goto repeat;
 		} else {
-			*phys = tmp + blockoff;
+			*phys = uspi->s_sbbase + tmp + blockoff;
 			goto out;
 		}
 	}
@@ -389,9 +389,9 @@ repeat:
 
 
 	if (!phys) {
-		result = sb_getblk(sb, tmp + blockoff);
+		result = sb_getblk(sb, uspi->s_sbbase + tmp + blockoff);
 	} else {
-		*phys = tmp + blockoff;
+		*phys = uspi->s_sbbase + tmp + blockoff;
 		*new = 1;
 	}
 
diff -puN fs/ufs/truncate.c~ufs-zeroize-the-rest-of-block-in-truncate fs/ufs/truncate.c
--- a/fs/ufs/truncate.c~ufs-zeroize-the-rest-of-block-in-truncate
+++ a/fs/ufs/truncate.c
@@ -74,7 +74,7 @@ static int ufs_trunc_direct(struct inode
 	unsigned i, tmp;
 	int retry;
 	
-	UFSD("ENTER\n");
+	UFSD("ENTER: ino %lu\n", inode->i_ino);
 
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
@@ -96,8 +96,8 @@ static int ufs_trunc_direct(struct inode
 		block2 = ufs_fragstoblks (frag3);
 	}
 
-	UFSD("frag1 %llu, frag2 %llu, block1 %llu, block2 %llu, frag3 %llu,"
-	     " frag4 %llu\n",
+	UFSD("ino %lu, frag1 %llu, frag2 %llu, block1 %llu, block2 %llu,"
+	     " frag3 %llu, frag4 %llu\n", inode->i_ino,
 	     (unsigned long long)frag1, (unsigned long long)frag2,
 	     (unsigned long long)block1, (unsigned long long)block2,
 	     (unsigned long long)frag3, (unsigned long long)frag4);
@@ -163,7 +163,7 @@ next1:
 	mark_inode_dirty(inode);
  next3:
 
-	UFSD("EXIT\n");
+	UFSD("EXIT: ino %lu\n", inode->i_ino);
 	return retry;
 }
 
@@ -248,7 +248,7 @@ static int ufs_trunc_indirect(struct ino
 	}
 	ubh_brelse (ind_ubh);
 	
-	UFSD("EXIT\n");
+	UFSD("EXIT: ino %lu\n", inode->i_ino);
 	
 	return retry;
 }
@@ -262,7 +262,7 @@ static int ufs_trunc_dindirect(struct in
 	void *dind;
 	int retry = 0;
 	
-	UFSD("ENTER\n");
+	UFSD("ENTER: ino %lu\n", inode->i_ino);
 	
 	sb = inode->i_sb;
 	uspi = UFS_SB(sb)->s_uspi;
@@ -312,7 +312,7 @@ static int ufs_trunc_dindirect(struct in
 	}
 	ubh_brelse (dind_bh);
 	
-	UFSD("EXIT\n");
+	UFSD("EXIT: ino %lu\n", inode->i_ino);
 	
 	return retry;
 }
@@ -327,7 +327,7 @@ static int ufs_trunc_tindirect(struct in
 	void *tind, *p;
 	int retry;
 	
-	UFSD("ENTER\n");
+	UFSD("ENTER: ino %lu\n", inode->i_ino);
 
 	retry = 0;
 	
@@ -372,19 +372,21 @@ static int ufs_trunc_tindirect(struct in
 	}
 	ubh_brelse (tind_bh);
 	
-	UFSD("EXIT\n");
+	UFSD("EXIT: ino %lu\n", inode->i_ino);
 	return retry;
 }
 
 static int ufs_alloc_lastblock(struct inode *inode)
 {
 	int err = 0;
+	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
-	struct ufs_sb_private_info *uspi = UFS_SB(inode->i_sb)->s_uspi;
+	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	unsigned i, end;
 	sector_t lastfrag;
 	struct page *lastpage;
 	struct buffer_head *bh;
+	u64 phys64;
 
 	lastfrag = (i_size_read(inode) + uspi->s_fsize - 1) >> uspi->s_fshift;
 
@@ -424,6 +426,20 @@ static int ufs_alloc_lastblock(struct in
 	       set_page_dirty(lastpage);
        }
 
+       if (lastfrag >= UFS_IND_FRAGMENT) {
+	       end = uspi->s_fpb - ufs_fragnum(lastfrag) - 1;
+	       phys64 = bh->b_blocknr + 1;
+	       for (i = 0; i < end; ++i) {
+		       bh = sb_getblk(sb, i + phys64);
+		       lock_buffer(bh);
+		       memset(bh->b_data, 0, sb->s_blocksize);
+		       set_buffer_uptodate(bh);
+		       mark_buffer_dirty(bh);
+		       unlock_buffer(bh);
+		       sync_dirty_buffer(bh);
+		       brelse(bh);
+	       }
+       }
 out_unlock:
        ufs_put_locked_page(lastpage);
 out:
_

Patches currently in -mm which might be from dushistov@mail.ru are

ufs2-more-correct-work-with-time.patch
ufs-prepare-write-change-blocks-on-the-fly.patch
ufs-zeroize-the-rest-of-block-in-truncate.patch
ufs2-tindirect-truncate-fix.patch
