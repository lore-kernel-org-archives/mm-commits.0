From: akpm@linux-foundation.org
Subject: [to-be-updated] fat-fix-incorrect-function-comment.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:18:04 -0800
Message-ID: <20121219201806.7A172200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:54218 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2LSUSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:18:09 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so133034fav.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:18:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyberax82@gmail.com, hirofumi@mail.parknet.co.jp, linkinjeon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix incorrect function comment
has been removed from the -mm tree.  Its filename was
     fat-fix-incorrect-function-comment.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ravishankar N <cyberax82@gmail.com>
Subject: fat: fix incorrect function comment

fat_search_long() returns 0 on success, -ENOENT/ENOMEM on failure.Change
the function comment accordingly.

While at it, fix some trivial typos.
	modified:   fs/fat/dir.c
	modified:   fs/fat/inode.c
	modified:   fs/fat/misc.c

Signed-off-by: Ravishankar N <cyberax82@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c   |    7 +++----
 fs/fat/inode.c |    2 +-
 fs/fat/misc.c  |    1 -
 3 files changed, 4 insertions(+), 6 deletions(-)

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
@@ -1176,7 +1175,7 @@ static int fat_add_new_entries(struct in
 
 	/*
 	 * The minimum cluster size is 512bytes, and maximum entry
-	 * size is 32*slots (672bytes).  So, iff the cluster size is
+	 * size is 32*slots (672bytes).  So, if the cluster size is
 	 * 512bytes, we may need two clusters.
 	 */
 	size = nr_slots * sizeof(struct msdos_dir_entry);
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
@@ -135,7 +135,6 @@ int fat_chain_add(struct inode *inode, i
 		}
 		if (ret < 0)
 			return ret;
-//		fat_cache_add(inode, new_fclus, new_dclus);
 	} else {
 		MSDOS_I(inode)->i_start = new_dclus;
 		MSDOS_I(inode)->i_logstart = new_dclus;
_

Patches currently in -mm which might be from cyberax82@gmail.com are


