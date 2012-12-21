From: akpm@linux-foundation.org
Subject: [merged] fat-fix-incorrect-function-comment.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:17 -0800
Message-ID: <20121221204018.214DE200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:49113 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2LUUkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:20 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so259723lah.4
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyberax82@gmail.com, hirofumi@mail.parknet.co.jp, linkinjeon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix incorrect function comment
has been removed from the -mm tree.  Its filename was
     fat-fix-incorrect-function-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ravishankar N <cyberax82@gmail.com>
Subject: fat: fix incorrect function comment

fat_search_long() returns 0 on success, -ENOENT/ENOMEM on failure.Change
the function comment accordingly.

While at it, fix some trivial typos.

Signed-off-by: Ravishankar N <cyberax82@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c   |    5 ++---
 fs/fat/inode.c |    2 +-
 fs/fat/misc.c  |    4 ++++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/fat/dir.c~fat-fix-incorrect-function-comment fs/fat/dir.c
--- a/fs/fat/dir.c~fat-fix-incorrect-function-comment
+++ a/fs/fat/dir.c
@@ -461,8 +461,7 @@ static int fat_parse_short(struct super_
 }
 
 /*
- * Return values: negative -> error, 0 -> not found, positive -> found,
- * value is the total amount of slots, including the shortname entry.
+ * Return values: negative -> error/not found, 0 -> found.
  */
 int fat_search_long(struct inode *inode, const unsigned char *name,
 		    int name_len, struct fat_slot_info *sinfo)
@@ -1255,7 +1254,7 @@ int fat_add_entries(struct inode *dir, v
 
 	sinfo->nr_slots = nr_slots;
 
-	/* First stage: search free direcotry entries */
+	/* First stage: search free directory entries */
 	free_slots = nr_bhs = 0;
 	bh = prev = NULL;
 	pos = 0;
diff -puN fs/fat/inode.c~fat-fix-incorrect-function-comment fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-incorrect-function-comment
+++ a/fs/fat/inode.c
@@ -1344,7 +1344,7 @@ int fat_fill_super(struct super_block *s
 	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
-			fat_msg(sb, KERN_ERR, "bogus directroy-entries per block"
+			fat_msg(sb, KERN_ERR, "bogus directory-entries per block"
 			       " (%u)", sbi->dir_entries);
 		brelse(bh);
 		goto out_invalid;
diff -puN fs/fat/misc.c~fat-fix-incorrect-function-comment fs/fat/misc.c
--- a/fs/fat/misc.c~fat-fix-incorrect-function-comment
+++ a/fs/fat/misc.c
@@ -135,6 +135,10 @@ int fat_chain_add(struct inode *inode, i
 		}
 		if (ret < 0)
 			return ret;
+		/*
+		 * FIXME:Although we can add this cache, fat_cache_add() is
+		 * assuming to be called after linear search with fat_cache_id.
+		 */
 //		fat_cache_add(inode, new_fclus, new_dclus);
 	} else {
 		MSDOS_I(inode)->i_start = new_dclus;
_

Patches currently in -mm which might be from cyberax82@gmail.com are

origin.patch

