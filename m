From: akpm@linux-foundation.org
Subject: + ext3-statfs-speed-up.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:13:10 -0700
Message-ID: <200707052213.l65MDBA4021861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760060AbXGEWNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, adilger@clusterfs.com


The patch titled
     ext3: statfs speed up
has been added to the -mm tree.  Its filename is
     ext3-statfs-speed-up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: statfs speed up
From: Badari Pulavarty <pbadari@us.ibm.com>

This is a patch that speeds up statfs.  It is very simple - the "overhead"
calculation, which takes a huge amount of time for large filesystems, never
changes unless the size of the filesystem itself changes.  That means we can
store it in memory and only recalculate if the filesystem has been resized
(almost never).

It also fixes a minor problem that we never update the on-disk superblock free
blocks/inodes counts until the filesystem is unmounted.  While not fatal, we
may as well update that on disk when we have the information, and it makes
things like debugfs and dumpe2fs report a bit more accurate info.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c            |   25 +++++++++++++++----------
 include/linux/ext3_fs_sb.h |    2 ++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff -puN fs/ext3/super.c~ext3-statfs-speed-up fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-statfs-speed-up
+++ a/fs/ext3/super.c
@@ -2426,19 +2426,19 @@ static int ext3_statfs (struct dentry * 
 	struct super_block *sb = dentry->d_sb;
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	struct ext3_super_block *es = sbi->s_es;
-	ext3_fsblk_t overhead;
-	int i;
 	u64 fsid;
 
-	if (test_opt (sb, MINIX_DF))
-		overhead = 0;
-	else {
-		unsigned long ngroups;
-		ngroups = EXT3_SB(sb)->s_groups_count;
+	if (test_opt(sb, MINIX_DF)) {
+		sbi->s_overhead_last = 0;
+	} else if (sbi->s_blocks_last != le32_to_cpu(es->s_blocks_count)) {
+		unsigned long ngroups = sbi->s_groups_count, i;
+		ext3_fsblk_t overhead = 0;
 		smp_rmb();
 
 		/*
-		 * Compute the overhead (FS structures)
+		 * Compute the overhead (FS structures).  This is constant
+		 * for a given filesystem unless the number of block groups
+		 * changes so we cache the previous value until it does.
 		 */
 
 		/*
@@ -2462,18 +2462,23 @@ static int ext3_statfs (struct dentry * 
 		 * Every block group has an inode bitmap, a block
 		 * bitmap, and an inode table.
 		 */
-		overhead += (ngroups * (2 + EXT3_SB(sb)->s_itb_per_group));
+		overhead += ngroups * (2 + sbi->s_itb_per_group);
+		sbi->s_overhead_last = overhead;
+		smp_wmb();
+		sbi->s_blocks_last = le32_to_cpu(es->s_blocks_count);
 	}
 
 	buf->f_type = EXT3_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
-	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead;
+	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
+	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
+	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT3_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
diff -puN include/linux/ext3_fs_sb.h~ext3-statfs-speed-up include/linux/ext3_fs_sb.h
--- a/include/linux/ext3_fs_sb.h~ext3-statfs-speed-up
+++ a/include/linux/ext3_fs_sb.h
@@ -38,6 +38,8 @@ struct ext3_sb_info {
 	unsigned long s_gdb_count;	/* Number of group descriptor blocks */
 	unsigned long s_desc_per_block;	/* Number of group descriptors per block */
 	unsigned long s_groups_count;	/* Number of groups in the fs */
+	unsigned long s_overhead_last;  /* Last calculated overhead */
+	unsigned long s_blocks_last;    /* Last seen block count */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext3_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
mm-fix-create_new_namespaces-return-value.patch
ext2-statfs-speed-up.patch
ext3-statfs-speed-up.patch
ext4-statfs-speed-up.patch
