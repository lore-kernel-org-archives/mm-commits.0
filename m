From: akpm@linux-foundation.org
Subject: - reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:23 -0700
Message-ID: <200804282201.m3SM1NrK018859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964970AbYD1WB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix hang on umount with quotas when journal is aborted
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix hang on umount with quotas when journal is aborted
From: Jan Kara <jack@suse.cz>

Call dquot_drop() from reiserfs_dquot_drop() even if we fail to start a
transaction.  Otherwise we never get to dropping references to quota
structures from the inode and umount will hang indefinitely.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/super.c~reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted
+++ a/fs/reiserfs/super.c
@@ -1890,8 +1890,14 @@ static int reiserfs_dquot_drop(struct in
 	ret =
 	    journal_begin(&th, inode->i_sb,
 			  2 * REISERFS_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (ret)
+	if (ret) {
+		/*
+		 * We call dquot_drop() anyway to at least release references
+		 * to quota structures so that umount does not hang.
+		 */
+		dquot_drop(inode);
 		goto out;
+	}
 	ret = dquot_drop(inode);
 	err =
 	    journal_end(&th, inode->i_sb,
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

