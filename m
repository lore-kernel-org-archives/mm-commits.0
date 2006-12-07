From: akpm@osdl.org
Subject: - ext2-fsid-for-statvfs.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:10 -0800
Message-ID: <200612072301.kB7N1AWl029713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51505 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163664AbWLGXBW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, adilger@clusterfs.com, sct@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ext2: fsid for statvfs
has been removed from the -mm tree.  Its filename was
     ext2-fsid-for-statvfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext2: fsid for statvfs
From: Pekka Enberg <penberg@cs.helsinki.fi>

Update ext2_statfs to return an FSID that is a 64 bit XOR of the 128 bit
filesystem UUID as suggested by Andreas Dilger.  See the following Bugzilla
entry for details:

  http://bugzilla.kernel.org/show_bug.cgi?id=136

Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Stephen Tweedie <sct@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/super.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN fs/ext2/super.c~ext2-fsid-for-statvfs fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-fsid-for-statvfs
+++ a/fs/ext2/super.c
@@ -1090,8 +1090,10 @@ static int ext2_statfs (struct dentry * 
 {
 	struct super_block *sb = dentry->d_sb;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
+	struct ext2_super_block *es = sbi->s_es;
 	unsigned long overhead;
 	int i;
+	u64 fsid;
 
 	if (test_opt (sb, MINIX_DF))
 		overhead = 0;
@@ -1104,7 +1106,7 @@ static int ext2_statfs (struct dentry * 
 		 * All of the blocks before first_data_block are
 		 * overhead
 		 */
-		overhead = le32_to_cpu(sbi->s_es->s_first_data_block);
+		overhead = le32_to_cpu(es->s_first_data_block);
 
 		/*
 		 * Add the overhead attributed to the superblock and
@@ -1125,14 +1127,18 @@ static int ext2_statfs (struct dentry * 
 
 	buf->f_type = EXT2_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
-	buf->f_blocks = le32_to_cpu(sbi->s_es->s_blocks_count) - overhead;
+	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead;
 	buf->f_bfree = ext2_count_free_blocks(sb);
-	buf->f_bavail = buf->f_bfree - le32_to_cpu(sbi->s_es->s_r_blocks_count);
-	if (buf->f_bfree < le32_to_cpu(sbi->s_es->s_r_blocks_count))
+	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
+	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
-	buf->f_files = le32_to_cpu(sbi->s_es->s_inodes_count);
-	buf->f_ffree = ext2_count_free_inodes (sb);
+	buf->f_files = le32_to_cpu(es->s_inodes_count);
+	buf->f_ffree = ext2_count_free_inodes(sb);
 	buf->f_namelen = EXT2_NAME_LEN;
+	fsid = le64_to_cpup((void *)es->s_uuid) ^
+	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
+	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
+	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 	return 0;
 }
 
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
fault-injection-capability-for-kmalloc.patch
slab-leaks3-default-y.patch

