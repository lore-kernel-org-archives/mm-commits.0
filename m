From: akpm@linux-foundation.org
Subject: - fat-optimize-fat_count_free_clusters.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:32:53 -0800
Message-ID: <200801131132.m0DBWXmE009780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36561 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbYAMLch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:32:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: optimize fat_count_free_clusters()
has been removed from the -mm tree.  Its filename was
     fat-optimize-fat_count_free_clusters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: optimize fat_count_free_clusters()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

On large partition, scanning the free clusters is very slow if users
doesn't use "usefree" option.

For optimizing it, this patch uses sb_breadahead() to read of FAT
sectors. On some user's 15GB partition, this patch improved it very
much (1min => 600ms).

The following is the result of 2GB partition on my machine.

without patch:
	root@devron (/)# time df -h > /dev/null

	real    0m1.202s
	user    0m0.000s
	sys     0m0.440s

with patch:
	root@devron (/)# time df -h > /dev/null

	real    0m0.378s
	user    0m0.012s
	sys     0m0.168s

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN fs/fat/fatent.c~fat-optimize-fat_count_free_clusters fs/fat/fatent.c
--- a/fs/fat/fatent.c~fat-optimize-fat_count_free_clusters
+++ a/fs/fat/fatent.c
@@ -590,21 +590,49 @@ error:
 
 EXPORT_SYMBOL_GPL(fat_free_clusters);
 
+/* 128kb is the whole sectors for FAT12 and FAT16 */
+#define FAT_READA_SIZE		(128 * 1024)
+
+static void fat_ent_reada(struct super_block *sb, struct fat_entry *fatent,
+			  unsigned long reada_blocks)
+{
+	struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
+	sector_t blocknr;
+	int i, offset;
+
+	ops->ent_blocknr(sb, fatent->entry, &offset, &blocknr);
+
+	for (i = 0; i < reada_blocks; i++)
+		sb_breadahead(sb, blocknr + i);
+}
+
 int fat_count_free_clusters(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct fatent_operations *ops = sbi->fatent_ops;
 	struct fat_entry fatent;
+	unsigned long reada_blocks, reada_mask, cur_block;
 	int err = 0, free;
 
 	lock_fat(sbi);
 	if (sbi->free_clusters != -1)
 		goto out;
 
+	reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
+	reada_mask = reada_blocks - 1;
+	cur_block = 0;
+
 	free = 0;
 	fatent_init(&fatent);
 	fatent_set_entry(&fatent, FAT_START_ENT);
 	while (fatent.entry < sbi->max_cluster) {
+		/* readahead of fat blocks */
+		if ((cur_block & reada_mask) == 0) {
+			unsigned long rest = sbi->fat_length - cur_block;
+			fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
+		}
+		cur_block++;
+
 		err = fat_ent_read_block(sb, &fatent);
 		if (err)
 			goto out;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fs-fat-refine-chmod-checks.patch
fat-fix-printk-format-strings.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
