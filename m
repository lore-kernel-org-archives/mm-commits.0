From: akpm@linux-foundation.org
Subject: [merged] befs-replace-typedef-befs_sb_info-by-structure.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:35 -0700
Message-ID: <5535510b.DFQsOqLsQwCmkLq2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbbDTTMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: replace typedef befs_sb_info by structure
has been removed from the -mm tree.  Its filename was
     befs-replace-typedef-befs_sb_info-by-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: befs: replace typedef befs_sb_info by structure

See Documenation/CodingStyle

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/befs.h       |    9 ++++-----
 fs/befs/datastream.c |    4 ++--
 fs/befs/io.c         |    2 +-
 fs/befs/linuxvfs.c   |    5 ++---
 fs/befs/super.c      |    4 ++--
 5 files changed, 11 insertions(+), 13 deletions(-)

diff -puN fs/befs/befs.h~befs-replace-typedef-befs_sb_info-by-structure fs/befs/befs.h
--- a/fs/befs/befs.h~befs-replace-typedef-befs_sb_info-by-structure
+++ a/fs/befs/befs.h
@@ -28,7 +28,7 @@ struct befs_mount_options {
 	char *iocharset;
 };
 
-typedef struct befs_sb_info {
+struct befs_sb_info {
 	u32 magic1;
 	u32 block_size;
 	u32 block_shift;
@@ -54,8 +54,7 @@ typedef struct befs_sb_info {
 
 	struct befs_mount_options mount_opts;
 	struct nls_table *nls;
-
-} befs_sb_info;
+};
 
 typedef struct befs_inode_info {
 	u32 i_flags;
@@ -105,10 +104,10 @@ void befs_dump_index_node(const struct s
 /* Gets a pointer to the private portion of the super_block
  * structure from the public part
  */
-static inline befs_sb_info *
+static inline struct befs_sb_info *
 BEFS_SB(const struct super_block *super)
 {
-	return (befs_sb_info *) super->s_fs_info;
+	return (struct befs_sb_info *) super->s_fs_info;
 }
 
 static inline befs_inode_info *
diff -puN fs/befs/datastream.c~befs-replace-typedef-befs_sb_info-by-structure fs/befs/datastream.c
--- a/fs/befs/datastream.c~befs-replace-typedef-befs_sb_info-by-structure
+++ a/fs/befs/datastream.c
@@ -168,7 +168,7 @@ befs_count_blocks(struct super_block * s
 	befs_blocknr_t blocks;
 	befs_blocknr_t datablocks;	/* File data blocks */
 	befs_blocknr_t metablocks;	/* FS metadata blocks */
-	befs_sb_info *befs_sb = BEFS_SB(sb);
+	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 
 	befs_debug(sb, "---> %s", __func__);
 
@@ -428,7 +428,7 @@ befs_find_brun_dblindirect(struct super_
 	struct buffer_head *indir_block;
 	befs_block_run indir_run;
 	befs_disk_inode_addr *iaddr_array = NULL;
-	befs_sb_info *befs_sb = BEFS_SB(sb);
+	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 
 	befs_blocknr_t indir_start_blk =
 	    data->max_indirect_range >> befs_sb->block_shift;
diff -puN fs/befs/io.c~befs-replace-typedef-befs_sb_info-by-structure fs/befs/io.c
--- a/fs/befs/io.c~befs-replace-typedef-befs_sb_info-by-structure
+++ a/fs/befs/io.c
@@ -28,7 +28,7 @@ befs_bread_iaddr(struct super_block *sb,
 {
 	struct buffer_head *bh = NULL;
 	befs_blocknr_t block = 0;
-	befs_sb_info *befs_sb = BEFS_SB(sb);
+	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 
 	befs_debug(sb, "---> Enter %s "
 		   "[%u, %hu, %hu]", __func__, iaddr.allocation_group,
diff -puN fs/befs/linuxvfs.c~befs-replace-typedef-befs_sb_info-by-structure fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-replace-typedef-befs_sb_info-by-structure
+++ a/fs/befs/linuxvfs.c
@@ -304,8 +304,7 @@ static struct inode *befs_iget(struct su
 {
 	struct buffer_head *bh = NULL;
 	befs_inode *raw_inode = NULL;
-
-	befs_sb_info *befs_sb = BEFS_SB(sb);
+	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 	befs_inode_info *befs_ino = NULL;
 	struct inode *inode;
 	long ret = -EIO;
@@ -769,7 +768,7 @@ static int
 befs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct buffer_head *bh;
-	befs_sb_info *befs_sb;
+	struct befs_sb_info *befs_sb;
 	befs_super_block *disk_sb;
 	struct inode *root;
 	long ret = -EINVAL;
diff -puN fs/befs/super.c~befs-replace-typedef-befs_sb_info-by-structure fs/befs/super.c
--- a/fs/befs/super.c~befs-replace-typedef-befs_sb_info-by-structure
+++ a/fs/befs/super.c
@@ -24,7 +24,7 @@
 int
 befs_load_sb(struct super_block *sb, befs_super_block * disk_sb)
 {
-	befs_sb_info *befs_sb = BEFS_SB(sb);
+	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 
 	/* Check the byte order of the filesystem */
 	if (disk_sb->fs_byte_order == BEFS_BYTEORDER_NATIVE_LE)
@@ -59,7 +59,7 @@ befs_load_sb(struct super_block *sb, bef
 int
 befs_check_sb(struct super_block *sb)
 {
-	befs_sb_info *befs_sb = BEFS_SB(sb);
+	struct befs_sb_info *befs_sb = BEFS_SB(sb);
 
 	/* Check magic headers of super block */
 	if ((befs_sb->magic1 != BEFS_SUPER_MAGIC1)
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

