From: akpm@linux-foundation.org
Subject: - ext4-add-missing-unlock-to-an-error-path-in-ext4_quota_write.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:00:40 -0700
Message-ID: <200807070301.m6730ewp004561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbYGGDDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ext4: add missing unlock to an error path in ext4_quota_write()
has been removed from the -mm tree.  Its filename was
     ext4-add-missing-unlock-to-an-error-path-in-ext4_quota_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: add missing unlock to an error path in ext4_quota_write()
From: Jan Kara <jack@suse.cz>

When write in ext4_quota_write() fails, we have to properly release
i_mutex.  One error path has been missing the unlock...

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ext4/super.c~ext4-add-missing-unlock-to-an-error-path-in-ext4_quota_write fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-add-missing-unlock-to-an-error-path-in-ext4_quota_write
+++ a/fs/ext4/super.c
@@ -3337,8 +3337,10 @@ static ssize_t ext4_quota_write(struct s
 		blk++;
 	}
 out:
-	if (len == towrite)
+	if (len == towrite) {
+		mutex_unlock(&inode->i_mutex);
 		return err;
+	}
 	if (inode->i_size < off+len-towrite) {
 		i_size_write(inode, off+len-towrite);
 		EXT4_I(inode)->i_disksize = inode->i_size;
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
jbd-positively-dispose-the-unmapped-data-buffers-in-journal_commit_transaction.patch
jbd-dont-abort-if-flushing-file-data-failed.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
quota-rename-quota-functions-from-upper-case-make-bigger-ones-non-inline.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch
quota-convert-macros-to-inline-functions.patch

