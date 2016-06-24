From: akpm@linux-foundation.org
Subject: + fs-befs-replace-befs_bread-by-sb_bread.patch added to -mm tree
Date: Fri, 24 Jun 2016 14:00:36 -0700
Message-ID: <576d9f74.xfDakl2d8WlsTyQZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbcFXVAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: befs: replace befs_bread by sb_bread
has been added to the -mm tree.  Its filename is
     fs-befs-replace-befs_bread-by-sb_bread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-befs-replace-befs_bread-by-sb_bread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-befs-replace-befs_bread-by-sb_bread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Salah Triki <salah.triki@gmail.com>
Subject: fs: befs: replace befs_bread by sb_bread

Since befs_bread merely calls sb_bread, replace it by sb_bread.

Link: http://lkml.kernel.org/r/1466800258-4542-1-git-send-email-salah.triki@gmail.com
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/datastream.c |    6 +++---
 fs/befs/io.c         |   24 ------------------------
 fs/befs/io.h         |    2 --
 fs/befs/linuxvfs.c   |    2 +-
 4 files changed, 4 insertions(+), 30 deletions(-)

diff -puN fs/befs/datastream.c~fs-befs-replace-befs_bread-by-sb_bread fs/befs/datastream.c
--- a/fs/befs/datastream.c~fs-befs-replace-befs_bread-by-sb_bread
+++ a/fs/befs/datastream.c
@@ -326,7 +326,7 @@ befs_find_brun_indirect(struct super_blo
 
 	/* Examine blocks of the indirect run one at a time */
 	for (i = 0; i < indirect.len; i++) {
-		indirblock = befs_bread(sb, indirblockno + i);
+		indirblock = sb_bread(sb, indirblockno + i);
 		if (indirblock == NULL) {
 			befs_debug(sb, "---> %s failed to read "
 				   "disk block %lu from the indirect brun",
@@ -471,7 +471,7 @@ befs_find_brun_dblindirect(struct super_
 	}
 
 	dbl_indir_block =
-	    befs_bread(sb, iaddr2blockno(sb, &data->double_indirect) +
+	    sb_bread(sb, iaddr2blockno(sb, &data->double_indirect) +
 					dbl_which_block);
 	if (dbl_indir_block == NULL) {
 		befs_error(sb, "%s couldn't read the "
@@ -499,7 +499,7 @@ befs_find_brun_dblindirect(struct super_
 	}
 
 	indir_block =
-	    befs_bread(sb, iaddr2blockno(sb, &indir_run) + which_block);
+	    sb_bread(sb, iaddr2blockno(sb, &indir_run) + which_block);
 	if (indir_block == NULL) {
 		befs_error(sb, "%s couldn't read the indirect block "
 			   "at blockno %lu", __func__, (unsigned long)
diff -puN fs/befs/io.c~fs-befs-replace-befs_bread-by-sb_bread fs/befs/io.c
--- a/fs/befs/io.c~fs-befs-replace-befs_bread-by-sb_bread
+++ a/fs/befs/io.c
@@ -59,27 +59,3 @@ befs_bread_iaddr(struct super_block *sb,
 	befs_debug(sb, "<--- %s ERROR", __func__);
 	return NULL;
 }
-
-struct buffer_head *
-befs_bread(struct super_block *sb, befs_blocknr_t block)
-{
-	struct buffer_head *bh;
-
-	befs_debug(sb, "---> Enter %s %lu", __func__, (unsigned long)block);
-
-	bh = sb_bread(sb, block);
-
-	if (bh == NULL) {
-		befs_error(sb, "Failed to read block %lu",
-			   (unsigned long)block);
-		goto error;
-	}
-
-	befs_debug(sb, "<--- %s", __func__);
-
-	return bh;
-
-      error:
-	befs_debug(sb, "<--- %s ERROR", __func__);
-	return NULL;
-}
diff -puN fs/befs/io.h~fs-befs-replace-befs_bread-by-sb_bread fs/befs/io.h
--- a/fs/befs/io.h~fs-befs-replace-befs_bread-by-sb_bread
+++ a/fs/befs/io.h
@@ -5,5 +5,3 @@
 struct buffer_head *befs_bread_iaddr(struct super_block *sb,
 				     befs_inode_addr iaddr);
 
-struct buffer_head *befs_bread(struct super_block *sb, befs_blocknr_t block);
