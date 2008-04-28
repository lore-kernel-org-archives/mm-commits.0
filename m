From: akpm@linux-foundation.org
Subject: - ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:53 -0700
Message-ID: <200804282200.m3SM0rUs018784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965644AbYD1WA6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, lioupayphone@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ext3: fix hang on umount with quotas when journal is aborted
has been removed from the -mm tree.  Its filename was
     ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix hang on umount with quotas when journal is aborted
From: Jan Kara <jack@suse.cz>

Call dquot_drop() from ext3_dquot_drop() even if we fail to start a
transaction.  Otherwise we never get to dropping references to quota
structures from the inode and umount will hang indefinitely.  Thanks to
Payphone LIOU for spotting the problem.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Payphone LIOU <lioupayphone@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/ext3/super.c~ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-hang-on-umount-with-quotas-when-journal-is-aborted
+++ a/fs/ext3/super.c
@@ -2639,8 +2639,14 @@ static int ext3_dquot_drop(struct inode 
 
 	/* We may delete quota structure so we need to reserve enough blocks */
 	handle = ext3_journal_start(inode, 2*EXT3_QUOTA_DEL_BLOCKS(inode->i_sb));
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		/*
+		 * We call dquot_drop() anyway to at least release references
+		 * to quota structures so that umount does not hang.
+		 */
+		dquot_drop(inode);
 		return PTR_ERR(handle);
+	}
 	ret = dquot_drop(inode);
 	err = ext3_journal_stop(handle);
 	if (!ret)
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

