From: akpm@linux-foundation.org
Subject: - ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:52:21 -0700
Message-ID: <200804300552.m3U5qLba030312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755818AbYD3GAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, lioupayphone@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ext4: fix hang on umount with quotas when journal is aborted
has been removed from the -mm tree.  Its filename was
     ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix hang on umount with quotas when journal is aborted
From: Jan Kara <jack@suse.cz>

Call dquot_drop() from ext4_dquot_drop() even if we fail to start a
transaction.  Otherwise we never get to dropping references to quota
structures from the inode and umount will hang indefinitely.  Thanks to
Payphone LIOU for spotting the problem.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Payphone LIOU <lioupayphone@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/ext4/super.c~ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted
+++ a/fs/ext4/super.c
@@ -3116,8 +3116,14 @@ static int ext4_dquot_drop(struct inode 
 
 	/* We may delete quota structure so we need to reserve enough blocks */
 	handle = ext4_journal_start(inode, 2*EXT4_QUOTA_DEL_BLOCKS(inode->i_sb));
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
 	err = ext4_journal_stop(handle);
 	if (!ret)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch

