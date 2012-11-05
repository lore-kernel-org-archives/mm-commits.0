From: akpm@linux-foundation.org
Subject: [nacked] fat-add-mutex-lock-to-fat_build_inode.patch removed from -mm tree
Date: Mon, 05 Nov 2012 12:07:23 -0800
Message-ID: <20121105200723.B467F100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61916 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2KEUHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:07:24 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so704950yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:07:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add mutex lock to fat_build_inode
has been removed from the -mm tree.  Its filename was
     fat-add-mutex-lock-to-fat_build_inode.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: add mutex lock to fat_build_inode

fat_nfs_get_inode() does not hold i_mutex of parent directory.  So add
lock to fat_build_inode().

We are making use of fat_build_inode to build the inode using 'i_pos'.
Since, this function is local to FAT and when mounted over NFS. We can
make use of FAT parallely from local NFS Server and mounted from NFS
client. So, in order to avoid race to multiple regeneration for the
same 'i_pos' - we have introduced this locking.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    1 +
 fs/fat/inode.c |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff -puN fs/fat/fat.h~fat-add-mutex-lock-to-fat_build_inode fs/fat/fat.h
--- a/fs/fat/fat.h~fat-add-mutex-lock-to-fat_build_inode
+++ a/fs/fat/fat.h
@@ -75,6 +75,7 @@ struct msdos_sb_info {
 	unsigned long fsinfo_sector;  /* sector number of FAT32 fsinfo */
 	struct mutex fat_lock;
 	struct mutex s_lock;
+	struct mutex nfs_build_inode_lock;
 	unsigned int prev_free;      /* previously allocated cluster number */
 	unsigned int free_clusters;  /* -1 if undefined */
 	unsigned int free_clus_valid; /* is free_clusters valid? */
diff -puN fs/fat/inode.c~fat-add-mutex-lock-to-fat_build_inode fs/fat/inode.c
--- a/fs/fat/inode.c~fat-add-mutex-lock-to-fat_build_inode
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
 
@@ -1173,6 +1187,7 @@ int fat_fill_super(struct super_block *s
 	sb->s_magic = MSDOS_SUPER_MAGIC;
 	sb->s_op = &fat_sops;
 	sb->s_export_op = &fat_export_ops;
+	mutex_init(&sbi->nfs_build_inode_lock);
 	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
 			     DEFAULT_RATELIMIT_BURST);
 
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are


