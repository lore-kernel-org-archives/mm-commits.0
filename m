From: akpm@linux-foundation.org
Subject: - fat-improve-fat_hash.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:19 -0800
Message-ID: <200811102033.mAAKXJve024439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbYKJUin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: improve fat_hash()
has been removed from the -mm tree.  Its filename was
     fat-improve-fat_hash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: improve fat_hash()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

fat_hash() is using the algorithm known as bad. Instead of it, this
uses hash_32(). The following is the summary of test.

old hash:
	hash func (1000 times): 33489 cycles
	total inodes in hash table: 70926
	largest bucket contains: 696
	smallest bucket contains: 54

new hash:
	hash func (1000 times): 33129 cycles
	total inodes in hash table: 70926
	largest bucket contains: 315
	smallest bucket contains: 236

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    1 -
 fs/fat/inode.c |   18 +++++++-----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN fs/fat/fat.h~fat-improve-fat_hash fs/fat/fat.h
--- a/fs/fat/fat.h~fat-improve-fat_hash
+++ a/fs/fat/fat.h
@@ -43,7 +43,6 @@ struct fat_mount_options {
 
 #define FAT_HASH_BITS	8
 #define FAT_HASH_SIZE	(1UL << FAT_HASH_BITS)
-#define FAT_HASH_MASK	(FAT_HASH_SIZE-1)
 
 /*
  * MS-DOS file system in-core superblock data
diff -puN fs/fat/inode.c~fat-improve-fat_hash fs/fat/inode.c
--- a/fs/fat/inode.c~fat-improve-fat_hash
+++ a/fs/fat/inode.c
@@ -26,6 +26,7 @@
 #include <linux/uio.h>
 #include <linux/writeback.h>
 #include <linux/log2.h>
+#include <linux/hash.h>
 #include <asm/unaligned.h>
 #include "fat.h"
 
@@ -247,25 +248,21 @@ static void fat_hash_init(struct super_b
 		INIT_HLIST_HEAD(&sbi->inode_hashtable[i]);
 }
 
-static inline unsigned long fat_hash(struct super_block *sb, loff_t i_pos)
+static inline unsigned long fat_hash(loff_t i_pos)
 {
-	unsigned long tmp = (unsigned long)i_pos | (unsigned long) sb;
-	tmp = tmp + (tmp >> FAT_HASH_BITS) + (tmp >> FAT_HASH_BITS * 2);
-	return tmp & FAT_HASH_MASK;
+	return hash_32(i_pos, FAT_HASH_BITS);
 }
 
 void fat_attach(struct inode *inode, loff_t i_pos)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct hlist_head *head = sbi->inode_hashtable + fat_hash(i_pos);
 
 	spin_lock(&sbi->inode_hash_lock);
 	MSDOS_I(inode)->i_pos = i_pos;
-	hlist_add_head(&MSDOS_I(inode)->i_fat_hash,
-			sbi->inode_hashtable + fat_hash(sb, i_pos));
+	hlist_add_head(&MSDOS_I(inode)->i_fat_hash, head);
 	spin_unlock(&sbi->inode_hash_lock);
 }
-
 EXPORT_SYMBOL_GPL(fat_attach);
 
 void fat_detach(struct inode *inode)
@@ -276,13 +273,12 @@ void fat_detach(struct inode *inode)
 	hlist_del_init(&MSDOS_I(inode)->i_fat_hash);
 	spin_unlock(&sbi->inode_hash_lock);
 }
