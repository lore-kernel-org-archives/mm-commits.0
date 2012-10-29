From: akpm@linux-foundation.org
Subject: + fat-add-mutex-lock-to-fat_build_inode.patch added to -mm tree
Date: Mon, 29 Oct 2012 16:50:04 -0700
Message-ID: <20121029235005.97BC020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:34499 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761415Ab2J2XuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 19:50:08 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so350466eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 16:50:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, ravi.n1@samsung.com


The patch titled
     Subject: fat: add mutex lock to fat_build_inode
has been added to the -mm tree.  Its filename is
     fat-add-mutex-lock-to-fat_build_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: add mutex lock to fat_build_inode

fat_nfs_get_inode() does not hold i_mutex of parent directory.  So add
lock to fat_build_inode().

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
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

fat-modify-nfs-mount-option.patch
fat-exportfs-rebuild-inode-if-ilookup-fails.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
fat-exportfs-rebuild-directory-inode-if-fat_dget-fails.patch
documentation-update-nfs-option-in-filesystem-vfattxt.patch
fat-remove-parent_logstart-check-in-fat_get_parent.patch
fat-restructure-export-operations.patch
fat-move-fat_i_pos_read-to-fath.patch
fat-exportfs-move-code-to-rebuild-directory-inode-to-separate-function.patch
fat-add-mutex-lock-to-fat_build_inode.patch

