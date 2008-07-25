From: akpm@linux-foundation.org
Subject: - reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:08 -0700
Message-ID: <200807252257.m6PMv8o5003156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012AbYGYW5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, reiserfs-devel@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix synchronization of quota files in journal=data mode
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix synchronization of quota files in journal=data mode
From: Jan Kara <jack@suse.cz>

In journal=data mode, it is not enough to do write_inode_now() as done in
vfs_quota_on() to write all data to their final location (which is needed for
quota_read to work correctly).  Calling journal_end_sync() before calling
vfs_quota_on() does it's job because transactions are committed to the journal
and data marked as dirty in memory so write_inode_now() writes them to their
final locations.

Cc: <reiserfs-devel@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -puN fs/reiserfs/super.c~reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode
+++ a/fs/reiserfs/super.c
@@ -2026,6 +2026,7 @@ static int reiserfs_quota_on(struct supe
 	int err;
 	struct nameidata nd;
 	struct inode *inode;
+	struct reiserfs_transaction_handle th;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
@@ -2053,17 +2054,28 @@ static int reiserfs_quota_on(struct supe
 		}
 		mark_inode_dirty(inode);
 	}
-	/* Not journalling quota? No more tests needed... */
-	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !REISERFS_SB(sb)->s_qf_names[GRPQUOTA]) {
-		path_put(&nd.path);
-		return vfs_quota_on(sb, type, format_id, path, 0);
-	}
-	/* Quotafile not of fs root? */
-	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
-		reiserfs_warning(sb,
+	/* Journaling quota? */
+	if (REISERFS_SB(sb)->s_qf_names[type]) {
+		/* Quotafile not of fs root? */
+		if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
+			reiserfs_warning(sb,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
+	}
+
+	/*
+	 * When we journal data on quota file, we have to flush journal to see
+	 * all updates to the file when we bypass pagecache...
+	 */
+	if (reiserfs_file_data_log(inode)) {
+		/* Just start temporary transaction and finish it */
+		err = journal_begin(&th, sb, 1);
+		if (err)
+			return err;
+		err = journal_end_sync(&th, sb, 1);
+		if (err)
+			return err;
+	}
 	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path, 0);
 }
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch

