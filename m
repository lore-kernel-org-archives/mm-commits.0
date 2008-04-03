From: akpm@linux-foundation.org
Subject: + reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch added to -mm tree
Date: Thu, 03 Apr 2008 13:55:02 -0700
Message-ID: <200804032055.m33Kt24E022033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755630AbYDCUzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 16:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     reiserfs: fix hang on umount with quotas when journal is aborted
has been added to the -mm tree.  Its filename is
     reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch

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

ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
reiserfs-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
git-udf.patch
git-ocfs2.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
quota-various-style-cleanups.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
ext3-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
quota-le_add_cpu-conversion.patch

