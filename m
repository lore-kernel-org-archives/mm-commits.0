From: akpm@linux-foundation.org
Subject: [merged] fat-constify-fatent_operations-structures.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 14:59:42 -0800
Message-ID: <56a162de.nQzDhz7PXuMy0kMe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbcAUW7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:59:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: constify fatent_operations structures
has been removed from the -mm tree.  Its filename was
     fat-constify-fatent_operations-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: fat: constify fatent_operations structures

The fatent_operations structures are never modified, so declare them as
const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h    |    2 +-
 fs/fat/fatent.c |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/fat/fat.h~fat-constify-fatent_operations-structures fs/fat/fat.h
--- a/fs/fat/fat.h~fat-constify-fatent_operations-structures
+++ a/fs/fat/fat.h
@@ -87,7 +87,7 @@ struct msdos_sb_info {
 	unsigned int vol_id;		/*volume ID*/
 
 	int fatent_shift;
-	struct fatent_operations *fatent_ops;
+	const struct fatent_operations *fatent_ops;
 	struct inode *fat_inode;
 	struct inode *fsinfo_inode;
 
diff -puN fs/fat/fatent.c~fat-constify-fatent_operations-structures fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-constify-fatent_operations-structures
+++ a/fs/fat/fatent.c
@@ -99,7 +99,7 @@ err:
 static int fat_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 			 int offset, sector_t blocknr)
 {
-	struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
+	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
 
 	WARN_ON(blocknr < MSDOS_SB(sb)->fat_start);
 	fatent->fat_inode = MSDOS_SB(sb)->fat_inode;
@@ -246,7 +246,7 @@ static int fat32_ent_next(struct fat_ent
 	return 0;
 }
 
-static struct fatent_operations fat12_ops = {
+static const struct fatent_operations fat12_ops = {
 	.ent_blocknr	= fat12_ent_blocknr,
 	.ent_set_ptr	= fat12_ent_set_ptr,
 	.ent_bread	= fat12_ent_bread,
@@ -255,7 +255,7 @@ static struct fatent_operations fat12_op
 	.ent_next	= fat12_ent_next,
 };
 
-static struct fatent_operations fat16_ops = {
+static const struct fatent_operations fat16_ops = {
 	.ent_blocknr	= fat_ent_blocknr,
 	.ent_set_ptr	= fat16_ent_set_ptr,
 	.ent_bread	= fat_ent_bread,
@@ -264,7 +264,7 @@ static struct fatent_operations fat16_op
 	.ent_next	= fat16_ent_next,
 };
 
-static struct fatent_operations fat32_ops = {
+static const struct fatent_operations fat32_ops = {
 	.ent_blocknr	= fat_ent_blocknr,
 	.ent_set_ptr	= fat32_ent_set_ptr,
 	.ent_bread	= fat_ent_bread,
@@ -320,7 +320,7 @@ static inline int fat_ent_update_ptr(str
 				     int offset, sector_t blocknr)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
-	struct fatent_operations *ops = sbi->fatent_ops;
+	const struct fatent_operations *ops = sbi->fatent_ops;
 	struct buffer_head **bhs = fatent->bhs;
 
 	/* Is this fatent's blocks including this entry? */
@@ -349,7 +349,7 @@ int fat_ent_read(struct inode *inode, st
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
-	struct fatent_operations *ops = sbi->fatent_ops;
+	const struct fatent_operations *ops = sbi->fatent_ops;
 	int err, offset;
 	sector_t blocknr;
 
@@ -407,7 +407,7 @@ int fat_ent_write(struct inode *inode, s
 		  int new, int wait)
 {
 	struct super_block *sb = inode->i_sb;
-	struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
+	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
 	int err;
 
 	ops->ent_put(fatent, new);
@@ -432,7 +432,7 @@ static inline int fat_ent_next(struct ms
 static inline int fat_ent_read_block(struct super_block *sb,
 				     struct fat_entry *fatent)
 {
-	struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
+	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
 	sector_t blocknr;
 	int offset;
 
@@ -463,7 +463,7 @@ int fat_alloc_clusters(struct inode *ino
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
-	struct fatent_operations *ops = sbi->fatent_ops;
+	const struct fatent_operations *ops = sbi->fatent_ops;
 	struct fat_entry fatent, prev_ent;
 	struct buffer_head *bhs[MAX_BUF_PER_PAGE];
 	int i, count, err, nr_bhs, idx_clus;
@@ -551,7 +551,7 @@ int fat_free_clusters(struct inode *inod
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
-	struct fatent_operations *ops = sbi->fatent_ops;
+	const struct fatent_operations *ops = sbi->fatent_ops;
 	struct fat_entry fatent;
 	struct buffer_head *bhs[MAX_BUF_PER_PAGE];
 	int i, err, nr_bhs;
@@ -636,7 +636,7 @@ EXPORT_SYMBOL_GPL(fat_free_clusters);
 static void fat_ent_reada(struct super_block *sb, struct fat_entry *fatent,
 			  unsigned long reada_blocks)
 {
-	struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
+	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
 	sector_t blocknr;
 	int i, offset;
 
@@ -649,7 +649,7 @@ static void fat_ent_reada(struct super_b
 int fat_count_free_clusters(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
-	struct fatent_operations *ops = sbi->fatent_ops;
+	const struct fatent_operations *ops = sbi->fatent_ops;
 	struct fat_entry fatent;
 	unsigned long reada_blocks, reada_mask, cur_block;
 	int err = 0, free;
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are


