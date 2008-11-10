From: akpm@linux-foundation.org
Subject: - fat-cleanup-msdos_lookup.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:31 -0800
Message-ID: <200811102033.mAAKXVnN024551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbYKJUeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Cleanup msdos_lookup()
has been removed from the -mm tree.  Its filename was
     fat-cleanup-msdos_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Cleanup msdos_lookup()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Use same style with vfat_lookup().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_msdos.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff -puN fs/fat/namei_msdos.c~fat-cleanup-msdos_lookup fs/fat/namei_msdos.c
--- a/fs/fat/namei_msdos.c~fat-cleanup-msdos_lookup
+++ a/fs/fat/namei_msdos.c
@@ -203,33 +203,37 @@ static struct dentry *msdos_lookup(struc
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
-	struct inode *inode = NULL;
-	int res;
-
-	dentry->d_op = &msdos_dentry_operations;
+	struct inode *inode;
+	int err;
 
 	lock_super(sb);
-	res = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
-	if (res == -ENOENT)
-		goto add;
-	if (res < 0)
-		goto out;
+
+	err = msdos_find(dir, dentry->d_name.name, dentry->d_name.len, &sinfo);
+	if (err) {
+		if (err == -ENOENT) {
+			inode = NULL;
+			goto out;
+		}
+		goto error;
+	}
+
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
-		res = PTR_ERR(inode);
-		goto out;
+		err = PTR_ERR(inode);
+		goto error;
 	}
-add:
-	res = 0;
+out:
+	unlock_super(sb);
+	dentry->d_op = &msdos_dentry_operations;
 	dentry = d_splice_alias(inode, dentry);
 	if (dentry)
 		dentry->d_op = &msdos_dentry_operations;
-out:
+	return dentry;
+
+error:
 	unlock_super(sb);
-	if (!res)
-		return dentry;
-	return ERR_PTR(res);
+	return ERR_PTR(err);
 }
 
 /***** Creates a directory entry (name is already formatted). */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

