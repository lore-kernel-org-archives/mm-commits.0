From: akpm@linux-foundation.org
Subject: - fat-use-fat_detach-in-fat_clear_inode.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:23 -0800
Message-ID: <200811102033.mAAKXNG8024461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbYKJUfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:35:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: use fat_detach() in fat_clear_inode()
has been removed from the -mm tree.  Its filename was
     fat-use-fat_detach-in-fat_clear_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: use fat_detach() in fat_clear_inode()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Use fat_detach() instead of opencoding it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN fs/fat/inode.c~fat-use-fat_detach-in-fat_clear_inode fs/fat/inode.c
--- a/fs/fat/inode.c~fat-use-fat_detach-in-fat_clear_inode
+++ a/fs/fat/inode.c
@@ -429,13 +429,8 @@ static void fat_delete_inode(struct inod
 
 static void fat_clear_inode(struct inode *inode)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
