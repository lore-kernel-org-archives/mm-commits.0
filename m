From: akpm@linux-foundation.org
Subject: + reiserfs-add-missing-unlock-to-an-error-path-in-reiserfs_quota_write.patch added to -mm tree
Date: Thu, 26 Jun 2008 09:01:43 -0700
Message-ID: <200806261601.m5QG1hjt006693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250AbYFZQCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jun 2008 12:02:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     reiserfs: add missing unlock to an error path in reiserfs_quota_write()
has been added to the -mm tree.  Its filename is
     reiserfs-add-missing-unlock-to-an-error-path-in-reiserfs_quota_write.patch

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
Subject: reiserfs: add missing unlock to an error path in reiserfs_quota_write()
From: Jan Kara <jack@suse.cz>

When write in reiserfs_quota_write() fails, we have to properly release
i_mutex. One error path has been missing the unlock...

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/super.c~reiserfs-add-missing-unlock-to-an-error-path-in-reiserfs_quota_write fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-add-missing-unlock-to-an-error-path-in-reiserfs_quota_write
+++ a/fs/reiserfs/super.c
@@ -2165,8 +2165,10 @@ static ssize_t reiserfs_quota_write(stru
 		blk++;
 	}
 out:
-	if (len == towrite)
+	if (len == towrite) {
+		mutex_unlock(&inode->i_mutex);
 		return err;
+	}
 	if (inode->i_size < off + len - towrite)
 		i_size_write(inode, off + len - towrite);
 	inode->i_version++;
_

Patches currently in -mm which might be from jack@suse.cz are

ext3-add-missing-unlock-to-error-path-in-ext3_quota_write.patch
ext4-add-missing-unlock-to-an-error-path-in-ext4_quota_write.patch
reiserfs-add-missing-unlock-to-an-error-path-in-reiserfs_quota_write.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-validate-directory-entry-data-before-use.patch
jbd-positively-dispose-the-unmapped-data-buffers-in-journal_commit_transaction.patch
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

