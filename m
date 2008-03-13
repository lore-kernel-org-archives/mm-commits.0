From: akpm@linux-foundation.org
Subject: + quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch added to -mm tree
Date: Thu, 13 Mar 2008 14:48:43 -0700
Message-ID: <200803132148.m2DLmh6x002052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757846AbYCMVtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 17:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: ext4: make ext4 handle quotaon on remount
has been added to the -mm tree.  Its filename is
     quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: ext4: make ext4 handle quotaon on remount
From: Jan Kara <jack@suse.cz>

Update ext4 to handle quotaon on remount RW.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/ext4/super.c~quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount fs/ext4/super.c
--- a/fs/ext4/super.c~quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount
+++ a/fs/ext4/super.c
@@ -813,7 +813,7 @@ static int ext4_acquire_dquot(struct dqu
 static int ext4_release_dquot(struct dquot *dquot);
 static int ext4_mark_dquot_dirty(struct dquot *dquot);
 static int ext4_write_info(struct super_block *sb, int type);
-static int ext4_quota_on(struct super_block *sb, int type, int format_id, char *path);
+static int ext4_quota_on(struct super_block *sb, int type, int format_id, char *path, int remount);
 static int ext4_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
@@ -1632,7 +1632,7 @@ static void ext4_orphan_cleanup (struct 
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if (sb_dqopt(sb)->files[i])
-			vfs_quota_off(sb, i);
+			vfs_quota_off(sb, i, 0);
 	}
 #endif
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
@@ -3143,7 +3143,7 @@ static int ext4_quota_on_mount(struct su
  * Standard function to be called on quota_on
  */
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
-			 char *path)
+			 char *path, int remount)
 {
 	int err;
 	struct nameidata nd;
@@ -3151,9 +3151,9 @@ static int ext4_quota_on(struct super_bl
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
 	/* Not journalling quota? */
-	if (!EXT4_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !EXT4_SB(sb)->s_qf_names[GRPQUOTA])
-		return vfs_quota_on(sb, type, format_id, path);
+	if ((!EXT4_SB(sb)->s_qf_names[USRQUOTA] &&
+	    !EXT4_SB(sb)->s_qf_names[GRPQUOTA]) || remount)
+		return vfs_quota_on(sb, type, format_id, path, remount);
 	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (err)
 		return err;
@@ -3168,7 +3168,7 @@ static int ext4_quota_on(struct super_bl
 			"EXT4-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
 	path_put(&nd.path);
-	return vfs_quota_on(sb, type, format_id, path);
+	return vfs_quota_on(sb, type, format_id, path, remount);
 }
 
 /* Read data from quotafile - avoid pagecache and such because we cannot afford
_

Patches currently in -mm which might be from jack@suse.cz are

git-udf.patch
git-ocfs2.patch
quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
quota-add-possibly-missing-iput-when-quotaon-and-quotaoff-races.patch
quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
quota-various-style-cleanups.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
quota-le_add_cpu-conversion.patch

