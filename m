From: akpm@linux-foundation.org
Subject: - quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:35 -0700
Message-ID: <200804282156.m3SLuZS1018243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937266AbYD1V4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: reiserfs: make reiserfs handle quotaon on remount
has been removed from the -mm tree.  Its filename was
     quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: reiserfs: make reiserfs handle quotaon on remount
From: Jan Kara <jack@suse.cz>

Update reiserfs to handle quotaon on remount RW.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/reiserfs/super.c~quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount
+++ a/fs/reiserfs/super.c
@@ -304,7 +304,7 @@ static int finish_unfinished(struct supe
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if (sb_dqopt(s)->files[i])
-			vfs_quota_off(s, i);
+			vfs_quota_off(s, i, 0);
 	}
 	if (ms_active_set)
 		/* Restore the flag back */
@@ -634,7 +634,7 @@ static int reiserfs_acquire_dquot(struct
 static int reiserfs_release_dquot(struct dquot *);
 static int reiserfs_mark_dquot_dirty(struct dquot *);
 static int reiserfs_write_info(struct super_block *, int);
-static int reiserfs_quota_on(struct super_block *, int, int, char *);
+static int reiserfs_quota_on(struct super_block *, int, int, char *, int);
 
 static struct dquot_operations reiserfs_quota_operations = {
 	.initialize = reiserfs_dquot_initialize,
@@ -2015,13 +2015,16 @@ static int reiserfs_quota_on_mount(struc
  * Standard function to be called on quota_on
  */
 static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
-			     char *path)
+			     char *path, int remount)
 {
 	int err;
 	struct nameidata nd;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
+	/* No more checks needed? Path and format_id are bogus anyway... */
+	if (remount)
+		return vfs_quota_on(sb, type, format_id, path, 1);
 	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (err)
 		return err;
@@ -2041,7 +2044,7 @@ static int reiserfs_quota_on(struct supe
 	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
 	    !REISERFS_SB(sb)->s_qf_names[GRPQUOTA]) {
 		path_put(&nd.path);
-		return vfs_quota_on(sb, type, format_id, path);
+		return vfs_quota_on(sb, type, format_id, path, 0);
 	}
 	/* Quotafile not of fs root? */
 	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
@@ -2049,7 +2052,7 @@ static int reiserfs_quota_on(struct supe
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
 	path_put(&nd.path);
-	return vfs_quota_on(sb, type, format_id, path);
+	return vfs_quota_on(sb, type, format_id, path, 0);
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

