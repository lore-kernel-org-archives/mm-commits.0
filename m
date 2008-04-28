From: akpm@linux-foundation.org
Subject: - quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:31 -0700
Message-ID: <200804282156.m3SLuVNb018234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937150AbYD1V4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: ext3: make ext3 handle quotaon on remount
has been removed from the -mm tree.  Its filename was
     quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: ext3: make ext3 handle quotaon on remount
From: Jan Kara <jack@suse.cz>

Update ext3 handle quotaon on remount RW.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/ext3/super.c~quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount fs/ext3/super.c
--- a/fs/ext3/super.c~quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount
+++ a/fs/ext3/super.c
@@ -685,7 +685,8 @@ static int ext3_acquire_dquot(struct dqu
 static int ext3_release_dquot(struct dquot *dquot);
 static int ext3_mark_dquot_dirty(struct dquot *dquot);
 static int ext3_write_info(struct super_block *sb, int type);
-static int ext3_quota_on(struct super_block *sb, int type, int format_id, char *path);
+static int ext3_quota_on(struct super_block *sb, int type, int format_id,
+				char *path, int remount);
 static int ext3_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
@@ -1415,7 +1416,7 @@ static void ext3_orphan_cleanup (struct 
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if (sb_dqopt(sb)->files[i])
-			vfs_quota_off(sb, i);
+			vfs_quota_off(sb, i, 0);
 	}
 #endif
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
@@ -2743,17 +2744,17 @@ static int ext3_quota_on_mount(struct su
  * Standard function to be called on quota_on
  */
 static int ext3_quota_on(struct super_block *sb, int type, int format_id,
-			 char *path)
+			 char *path, int remount)
 {
 	int err;
 	struct nameidata nd;
 
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
-	/* Not journalling quota? */
-	if (!EXT3_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !EXT3_SB(sb)->s_qf_names[GRPQUOTA])
-		return vfs_quota_on(sb, type, format_id, path);
+	/* Not journalling quota or remount? */
+	if ((!EXT3_SB(sb)->s_qf_names[USRQUOTA] &&
+	    !EXT3_SB(sb)->s_qf_names[GRPQUOTA]) || remount)
+		return vfs_quota_on(sb, type, format_id, path, remount);
 	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (err)
 		return err;
@@ -2762,13 +2763,13 @@ static int ext3_quota_on(struct super_bl
 		path_put(&nd.path);
 		return -EXDEV;
 	}
-	/* Quotafile not of fs root? */
+	/* Quotafile not in fs root? */
 	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
 		printk(KERN_WARNING
 			"EXT3-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
 	path_put(&nd.path);
-	return vfs_quota_on(sb, type, format_id, path);
+	return vfs_quota_on(sb, type, format_id, path, remount);
 }
 
 /* Read data from quotafile - avoid pagecache and such because we cannot afford
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch
isofs-use-get-put_unaligned_-helpers.patch

