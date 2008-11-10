From: akpm@linux-foundation.org
Subject: - vfat-fix-vfat_find-error-path-in-vfat_lookup.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:25 -0800
Message-ID: <200811102033.mAAKXPji024464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbYKJUd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     vfat: Fix vfat_find() error path in vfat_lookup()
has been removed from the -mm tree.  Its filename was
     vfat-fix-vfat_find-error-path-in-vfat_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

