From: akpm@linux-foundation.org
Subject: + vfat-fix-vfat_find-error-path-in-vfat_lookup.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:34 -0700
Message-ID: <200810162207.m9GM7Y7V028079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277AbYJPWHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     vfat: Fix vfat_find() error path in vfat_lookup()
has been added to the -mm tree.  Its filename is
     vfat-fix-vfat_find-error-path-in-vfat_lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfat: Fix vfat_find() error path in vfat_lookup()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Current vfat_lookup() creates negetive dentry blindly if vfat_find()
returned a error. It's wrong. If the error isn't -ENOENT, just return
error.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/fat/namei_vfat.c~vfat-fix-vfat_find-error-path-in-vfat_lookup fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~vfat-fix-vfat_find-error-path-in-vfat_lookup
+++ a/fs/fat/namei_vfat.c
@@ -683,7 +683,7 @@ static struct dentry *vfat_lookup(struct
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
-	struct inode *inode = NULL;
+	struct inode *inode;
 	struct dentry *alias;
 	int err, table;
 
@@ -693,14 +693,18 @@ static struct dentry *vfat_lookup(struct
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err) {
-		table++;
+		if (err == -ENOENT) {
+			table++;
+			inode = NULL;
+			goto out;
+		}
 		goto error;
 	}
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
-		unlock_super(sb);
-		return ERR_CAST(inode);
+		err = PTR_ERR(inode);
+		goto error;
 	}
 	alias = d_find_alias(inode);
 	if (alias) {
@@ -713,7 +717,7 @@ static struct dentry *vfat_lookup(struct
 		}
 
 	}
-error:
+out:
 	unlock_super(sb);
 	dentry->d_op = &vfat_dentry_ops[table];
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
@@ -723,6 +727,10 @@ error:
 		dentry->d_time = dentry->d_parent->d_inode->i_version;
 	}
 	return dentry;
+
+error:
+	unlock_super(sb);
+	return ERR_PTR(err);
 }
 
 static int vfat_create(struct inode *dir, struct dentry *dentry, int mode,
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

