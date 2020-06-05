From: akpm@linux-foundation.org
Subject: [merged] fat-improve-the-readahead-for-fat-entries.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:19:37 -0700
Message-ID: <20200605201937.cVlDBJ2Ip%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgFEUTi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, hyeongseok.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: improve the readahead for FAT entries
has been removed from the -mm tree.  Its filename was
     fat-improve-the-readahead-for-fat-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: improve the readahead for FAT entries

Current readahead for FAT entries is very simple but is having some flaws,
so it is not working well for some environments.  This patch improves the
readahead more or less.

The key points of modification are,

  - make the readahead size tunable by using bdi->ra_pages
  - care the bdi->io_pages to avoid the small size I/O request
  - update readahead window before fully exhausting

With this patch, on slow USB connected 2TB hdd:

[before]
383.18sec

[after]
51.03sec

Link: http://lkml.kernel.org/r/87d08e1dlh.fsf@mail.parknet.co.jp
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Tested-by: hyeongseok.kim <hyeongseok.kim@lge.com>
Reviewed-by: hyeongseok.kim <hyeongseok.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |  103 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 75 insertions(+), 28 deletions(-)

--- a/fs/fat/fatent.c~fat-improve-the-readahead-for-fat-entries
+++ a/fs/fat/fatent.c
@@ -632,20 +632,80 @@ error:
 }
 EXPORT_SYMBOL_GPL(fat_free_clusters);
 
-/* 128kb is the whole sectors for FAT12 and FAT16 */
-#define FAT_READA_SIZE		(128 * 1024)
+struct fatent_ra {
+	sector_t cur;
+	sector_t limit;
+
+	unsigned int ra_blocks;
+	sector_t ra_advance;
+	sector_t ra_next;
+	sector_t ra_limit;
+};
 
-static void fat_ent_reada(struct super_block *sb, struct fat_entry *fatent,
-			  unsigned long reada_blocks)
+static void fat_ra_init(struct super_block *sb, struct fatent_ra *ra,
+			struct fat_entry *fatent, int ent_limit)
 {
-	const struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
-	sector_t blocknr;
-	int i, offset;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	const struct fatent_operations *ops = sbi->fatent_ops;
+	sector_t blocknr, block_end;
+	int offset;
+	/*
+	 * This is the sequential read, so ra_pages * 2 (but try to
+	 * align the optimal hardware IO size).
+	 * [BTW, 128kb covers the whole sectors for FAT12 and FAT16]
+	 */
+	unsigned long ra_pages = sb->s_bdi->ra_pages;
+	unsigned int reada_blocks;
+
+	if (ra_pages > sb->s_bdi->io_pages)
+		ra_pages = rounddown(ra_pages, sb->s_bdi->io_pages);
+	reada_blocks = ra_pages << (PAGE_SHIFT - sb->s_blocksize_bits + 1);
 
+	/* Initialize the range for sequential read */
 	ops->ent_blocknr(sb, fatent->entry, &offset, &blocknr);
+	ops->ent_blocknr(sb, ent_limit - 1, &offset, &block_end);
+	ra->cur = 0;
+	ra->limit = (block_end + 1) - blocknr;
+
+	/* Advancing the window at half size */
+	ra->ra_blocks = reada_blocks >> 1;
+	ra->ra_advance = ra->cur;
+	ra->ra_next = ra->cur;
+	ra->ra_limit = ra->cur + min_t(sector_t, reada_blocks, ra->limit);
+}
 
-	for (i = 0; i < reada_blocks; i++)
-		sb_breadahead(sb, blocknr + i);
+/* Assuming to be called before reading a new block (increments ->cur). */
+static void fat_ent_reada(struct super_block *sb, struct fatent_ra *ra,
+			  struct fat_entry *fatent)
+{
+	if (ra->ra_next >= ra->ra_limit)
+		return;
+
+	if (ra->cur >= ra->ra_advance) {
+		struct msdos_sb_info *sbi = MSDOS_SB(sb);
+		const struct fatent_operations *ops = sbi->fatent_ops;
+		struct blk_plug plug;
+		sector_t blocknr, diff;
+		int offset;
+
+		ops->ent_blocknr(sb, fatent->entry, &offset, &blocknr);
+
+		diff = blocknr - ra->cur;
+		blk_start_plug(&plug);
+		/*
+		 * FIXME: we would want to directly use the bio with
+		 * pages to reduce the number of segments.
+		 */
+		for (; ra->ra_next < ra->ra_limit; ra->ra_next++)
+			sb_breadahead(sb, ra->ra_next + diff);
+		blk_finish_plug(&plug);
+
+		/* Advance the readahead window */
+		ra->ra_advance += ra->ra_blocks;
+		ra->ra_limit += min_t(sector_t,
+				      ra->ra_blocks, ra->limit - ra->ra_limit);
+	}
+	ra->cur++;
 }
 
 int fat_count_free_clusters(struct super_block *sb)
@@ -653,27 +713,20 @@ int fat_count_free_clusters(struct super
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	const struct fatent_operations *ops = sbi->fatent_ops;
 	struct fat_entry fatent;
-	unsigned long reada_blocks, reada_mask, cur_block;
+	struct fatent_ra fatent_ra;
 	int err = 0, free;
 
 	lock_fat(sbi);
 	if (sbi->free_clusters != -1 && sbi->free_clus_valid)
 		goto out;
 
-	reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
-	reada_mask = reada_blocks - 1;
-	cur_block = 0;
-
 	free = 0;
 	fatent_init(&fatent);
 	fatent_set_entry(&fatent, FAT_START_ENT);
+	fat_ra_init(sb, &fatent_ra, &fatent, sbi->max_cluster);
 	while (fatent.entry < sbi->max_cluster) {
 		/* readahead of fat blocks */
-		if ((cur_block & reada_mask) == 0) {
-			unsigned long rest = sbi->fat_length - cur_block;
-			fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
-		}
-		cur_block++;
+		fat_ent_reada(sb, &fatent_ra, &fatent);
 
 		err = fat_ent_read_block(sb, &fatent);
 		if (err)
@@ -707,9 +760,9 @@ int fat_trim_fs(struct inode *inode, str
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	const struct fatent_operations *ops = sbi->fatent_ops;
 	struct fat_entry fatent;
+	struct fatent_ra fatent_ra;
 	u64 ent_start, ent_end, minlen, trimmed = 0;
 	u32 free = 0;
-	unsigned long reada_blocks, reada_mask, cur_block = 0;
 	int err = 0;
 
 	/*
@@ -727,19 +780,13 @@ int fat_trim_fs(struct inode *inode, str
 	if (ent_end >= sbi->max_cluster)
 		ent_end = sbi->max_cluster - 1;
 
-	reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
-	reada_mask = reada_blocks - 1;
