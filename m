From: akpm@linux-foundation.org
Subject: - fat-kill-is_bad_inode-check.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:28 -0700
Message-ID: <200804282201.m3SM1Seh018865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965759AbYD1WBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: kill is_bad_inode() check
has been removed from the -mm tree.  Its filename was
     fat-kill-is_bad_inode-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: kill is_bad_inode() check
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

FAT doesn't need to check bad inode anymore.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN fs/fat/inode.c~fat-kill-is_bad_inode-check fs/fat/inode.c
--- a/fs/fat/inode.c~fat-kill-is_bad_inode-check
+++ a/fs/fat/inode.c
@@ -433,11 +433,8 @@ EXPORT_SYMBOL_GPL(fat_build_inode);
 static void fat_delete_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-
-	if (!is_bad_inode(inode)) {
-		inode->i_size = 0;
-		fat_truncate(inode);
-	}
+	inode->i_size = 0;
+	fat_truncate(inode);
 	clear_inode(inode);
 }
 
@@ -445,8 +442,6 @@ static void fat_clear_inode(struct inode
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 
-	if (is_bad_inode(inode))
-		return;
 	lock_kernel();
 	spin_lock(&sbi->inode_hash_lock);
 	fat_cache_inval_inode(inode);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
vfs-fix-unconditional-write_super-call-in-file_fsync.patch
fat-use-get-put_unaligned_-helpers.patch

