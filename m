From: akpm@linux-foundation.org
Subject: + fat-fix-incorrect-function-comment.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:18:33 -0800
Message-ID: <20121220201834.15926200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:52174 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTUSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:18:36 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so207243wey.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:18:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cyberax82@gmail.com, hirofumi@mail.parknet.co.jp, linkinjeon@gmail.com


The patch titled
     Subject: fat:fix incorrect function comment
has been added to the -mm tree.  Its filename is
     fat-fix-incorrect-function-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ravishankar N <cyberax82@gmail.com>
Subject: fat:fix incorrect function comment

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

fat-fix-incorrect-function-comment.patch

