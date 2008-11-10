From: akpm@linux-foundation.org
Subject: - fat-i_pos-race-fix.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:45 -0800
Message-ID: <200811102033.mAAKXj2S024650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbYKJUeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: ->i_pos race fix
has been removed from the -mm tree.  Its filename was
     fat-i_pos-race-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: ->i_pos race fix
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

i_pos is 64bits value, hence it's not atomic to update.

Important place is fat_write_inode() only, other places without lock
are just for printk().

This adds lock for "BITS_PER_LONG == 32" kernel.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fat-i_pos-race-fix fs/fat/inode.c
--- a/fs/fat/inode.c~fat-i_pos-race-fix
+++ a/fs/fat/inode.c
@@ -542,6 +542,20 @@ static int fat_statfs(struct dentry *den
 	return 0;
 }
 
+static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+				    struct inode *inode)
+{
+	loff_t i_pos;
+#if BITS_PER_LONG == 32
+	spin_lock(&sbi->inode_hash_lock);
+#endif
+	i_pos = MSDOS_I(inode)->i_pos;
+#if BITS_PER_LONG == 32
+	spin_unlock(&sbi->inode_hash_lock);
+#endif
+	return i_pos;
+}
+
 static int fat_write_inode(struct inode *inode, int wait)
 {
 	struct super_block *sb = inode->i_sb;
@@ -551,9 +565,12 @@ static int fat_write_inode(struct inode 
 	loff_t i_pos;
 	int err;
 
+	if (inode->i_ino == MSDOS_ROOT_INO)
+		return 0;
+
 retry:
-	i_pos = MSDOS_I(inode)->i_pos;
-	if (inode->i_ino == MSDOS_ROOT_INO || !i_pos)
+	i_pos = fat_i_pos_read(sbi, inode);
+	if (!i_pos)
 		return 0;
 
 	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

