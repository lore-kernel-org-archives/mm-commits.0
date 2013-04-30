From: akpm@linux-foundation.org
Subject: [merged] fat-exportfs-rebuild-inode-if-ilookup-fails.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:51 -0700
Message-ID: <20130430190151.7F2A45A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55607 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab3D3TBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:52 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so87593vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat (exportfs): rebuild inode if ilookup() fails
has been removed from the -mm tree.  Its filename was
     fat-exportfs-rebuild-inode-if-ilookup-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat (exportfs): rebuild inode if ilookup() fails

If the cache lookups fail,use the i_pos value to find the directory entry
of the inode and rebuild the inode.Since this involves accessing the FAT
media, do this only if the nostale_ro nfs mount option is specified.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    1 +
 fs/fat/inode.c |   15 +++++++++++++++
 fs/fat/nfs.c   |   41 ++++++++++++++++++++++++++++++++++++-----
 3 files changed, 52 insertions(+), 5 deletions(-)

diff -puN fs/fat/fat.h~fat-exportfs-rebuild-inode-if-ilookup-fails fs/fat/fat.h
--- a/fs/fat/fat.h~fat-exportfs-rebuild-inode-if-ilookup-fails
+++ a/fs/fat/fat.h
@@ -75,6 +75,7 @@ struct msdos_sb_info {
 	unsigned long root_cluster;   /* first cluster of the root directory */
 	unsigned long fsinfo_sector;  /* sector number of FAT32 fsinfo */
 	struct mutex fat_lock;
+	struct mutex nfs_build_inode_lock;
 	struct mutex s_lock;
 	unsigned int prev_free;      /* previously allocated cluster number */
 	unsigned int free_clusters;  /* -1 if undefined */
diff -puN fs/fat/inode.c~fat-exportfs-rebuild-inode-if-ilookup-fails fs/fat/inode.c
--- a/fs/fat/inode.c~fat-exportfs-rebuild-inode-if-ilookup-fails
+++ a/fs/fat/inode.c
@@ -443,12 +443,25 @@ static int fat_fill_inode(struct inode *
 	return 0;
 }
 
+static inline void fat_lock_build_inode(struct msdos_sb_info *sbi)
+{
+	if (sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+		mutex_lock(&sbi->nfs_build_inode_lock);
+}
+
+static inline void fat_unlock_build_inode(struct msdos_sb_info *sbi)
+{
+	if (sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+		mutex_unlock(&sbi->nfs_build_inode_lock);
+}
+
 struct inode *fat_build_inode(struct super_block *sb,
 			struct msdos_dir_entry *de, loff_t i_pos)
 {
 	struct inode *inode;
 	int err;
 
+	fat_lock_build_inode(MSDOS_SB(sb));
 	inode = fat_iget(sb, i_pos);
 	if (inode)
 		goto out;
@@ -468,6 +481,7 @@ struct inode *fat_build_inode(struct sup
 	fat_attach(inode, i_pos);
 	insert_inode_hash(inode);
 out:
+	fat_unlock_build_inode(MSDOS_SB(sb));
 	return inode;
 }
 
@@ -1247,6 +1261,7 @@ int fat_fill_super(struct super_block *s
 	sb->s_magic = MSDOS_SUPER_MAGIC;
 	sb->s_op = &fat_sops;
 	sb->s_export_op = &fat_export_ops;
+	mutex_init(&sbi->nfs_build_inode_lock);
 	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
 			     DEFAULT_RATELIMIT_BURST);
 
diff -puN fs/fat/nfs.c~fat-exportfs-rebuild-inode-if-ilookup-fails fs/fat/nfs.c
--- a/fs/fat/nfs.c~fat-exportfs-rebuild-inode-if-ilookup-fails
+++ a/fs/fat/nfs.c
@@ -50,19 +50,50 @@ static struct inode *fat_dget(struct sup
 	return inode;
 }
 
+static struct inode *fat_ilookup(struct super_block *sb, u64 ino, loff_t i_pos)
+{
+	if (MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO)
+		return fat_iget(sb, i_pos);
+
+	else {
+		if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
+			return NULL;
+		return ilookup(sb, ino);
+	}
+}
+
 static struct inode *__fat_nfs_get_inode(struct super_block *sb,
 				       u64 ino, u32 generation, loff_t i_pos)
 {
-	struct inode *inode;
-
-	if ((ino < MSDOS_ROOT_INO) || (ino == MSDOS_FSINFO_INO))
-		return NULL;
+	struct inode *inode = fat_ilookup(sb, ino, i_pos);
 
-	inode = ilookup(sb, ino);
 	if (inode && generation && (inode->i_generation != generation)) {
 		iput(inode);
 		inode = NULL;
 	}
+	if (inode == NULL && MSDOS_SB(sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
+		struct buffer_head *bh = NULL;
+		struct msdos_dir_entry *de ;
+		sector_t blocknr;
+		int offset;
+		fat_get_blknr_offset(MSDOS_SB(sb), i_pos, &blocknr, &offset);
+		bh = sb_bread(sb, blocknr);
+		if (!bh) {
+			fat_msg(sb, KERN_ERR,
+				"unable to read block(%llu) for building NFS inode",
+				(llu)blocknr);
+			return inode;
+		}
+		de = (struct msdos_dir_entry *)bh->b_data;
+		/* If a file is deleted on server and client is not updated
+		 * yet, we must not build the inode upon a lookup call.
+		 */
+		if (IS_FREE(de[offset].name))
+			inode = NULL;
+		else
+			inode = fat_build_inode(sb, &de[offset], i_pos);
+		brelse(bh);
+	}
 
 	return inode;
 }
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
linux-next.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix.patch

