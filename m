From: akpm@linux-foundation.org
Subject: + mistaken-ext4_inode_bitmap-for-ext4_block_bitmap.patch added to -mm tree
Date: Mon, 25 Jun 2007 21:52:23 -0700
Message-ID: <200706260452.l5Q4qNt2018655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbXFZEwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 00:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: toshi.okajima@jp.fujitsu.com, tytso@mit.edu


The patch titled
     mistaken ext4_inode_bitmap for ext4_block_bitmap
has been added to the -mm tree.  Its filename is
     mistaken-ext4_inode_bitmap-for-ext4_block_bitmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mistaken ext4_inode_bitmap for ext4_block_bitmap
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

In ext4_new_blocks(), one of two ext4_block_bitmap() calls should be
ext4_inode_bitmap() call.  It is not harmful in normal processing, but it
should be fixed.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/balloc.c~mistaken-ext4_inode_bitmap-for-ext4_block_bitmap fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~mistaken-ext4_inode_bitmap-for-ext4_block_bitmap
+++ a/fs/ext4/balloc.c
@@ -1585,7 +1585,7 @@ allocated:
 	ret_block = grp_alloc_blk + ext4_group_first_block_no(sb, group_no);
 
 	if (in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
-	    in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
+	    in_range(ext4_inode_bitmap(sb, gdp), ret_block, num) ||
 	    in_range(ret_block, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
_

Patches currently in -mm which might be from toshi.okajima@jp.fujitsu.com are

mistaken-ext4_inode_bitmap-for-ext4_block_bitmap.patch
