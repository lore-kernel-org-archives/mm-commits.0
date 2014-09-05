From: akpm@linux-foundation.org
Subject: [alternative-merged]
 ext4-use-non-movable-memory-for-the-ext4-superblock.patch removed from -mm
 tree
Date: Fri, 05 Sep 2014 12:12:50 -0700
Message-ID: <540a0b32.WfaV66Fmm5S4GUCA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaIETMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 15:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gioh.kim@lge.com, adilger.kernel@dilger.ca, gunho.lee@lge.com, jack@suse.cz, js1304@gmail.com, minchan@kernel.org, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: use non-movable memory for the ext4 superblock
has been removed from the -mm tree.  Its filename was
     ext4-use-non-movable-memory-for-the-ext4-superblock.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Gioh Kim <gioh.kim@lge.com>
Subject: ext4: use non-movable memory for the ext4 superblock

A buffer-cache for superblock is disturbing page migration, because the
buffer-cache is not released until unmount.  The buffer-cache must be
allocated from non-movable area.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Gunho Lee <gunho.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext4/super.c~ext4-use-non-movable-memory-for-the-ext4-superblock fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-use-non-movable-memory-for-the-ext4-superblock
+++ a/fs/ext4/super.c
@@ -3436,7 +3436,7 @@ static int ext4_fill_super(struct super_
 		logical_sb_block = sb_block;
 	}
 
-	if (!(bh = sb_bread(sb, logical_sb_block))) {
+	if (!(bh = sb_bread_unmovable(sb, logical_sb_block))) {
 		ext4_msg(sb, KERN_ERR, "unable to read superblock");
 		goto out_fail;
 	}
@@ -3646,7 +3646,7 @@ static int ext4_fill_super(struct super_
 		brelse(bh);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
-		bh = sb_bread(sb, logical_sb_block);
+		bh = sb_bread_unmovable(sb, logical_sb_block);
 		if (!bh) {
 			ext4_msg(sb, KERN_ERR,
 			       "Can't read superblock on 2nd try");
@@ -3868,7 +3868,7 @@ static int ext4_fill_super(struct super_
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
-		sbi->s_group_desc[i] = sb_bread(sb, block);
+		sbi->s_group_desc[i] = sb_bread_unmovable(sb, block);
 		if (!sbi->s_group_desc[i]) {
 			ext4_msg(sb, KERN_ERR,
 			       "can't read group descriptor %d", i);
_

Patches currently in -mm which might be from gioh.kim@lge.com are

jbd-jbd2-use-non-movable-memory-for-the-jbd-superblock.patch
linux-next.patch

