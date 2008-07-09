From: akpm@linux-foundation.org
Subject: + quota-fix-possible-infinite-loop-in-quota-code.patch added to -mm tree
Date: Wed, 09 Jul 2008 15:10:56 -0700
Message-ID: <200807092216.m69MGKtJ027526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbYGIWQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jul 2008 18:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, dingdinghua85@gmail.com


The patch titled
     quota: fix possible infinite loop in quota code
has been added to the -mm tree.  Its filename is
     quota-fix-possible-infinite-loop-in-quota-code.patch

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
Subject: quota: fix possible infinite loop in quota code
From: Jan Kara <jack@suse.cz>

When quota structure is going to be dropped and it is dirty, quota code tries
to write it.  If the write fails for some reason (e.  g.  transaction cannot
be started because the journal is aborted), we try writing again and again and
again...  Fix the problem by clearing the dirty bit even if the write failed.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: dingdinghua <dingdinghua85@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/dquot.c~quota-fix-possible-infinite-loop-in-quota-code fs/dquot.c
--- a/fs/dquot.c~quota-fix-possible-infinite-loop-in-quota-code
+++ a/fs/dquot.c
@@ -562,6 +562,8 @@ static struct shrinker dqcache_shrinker 
  */
 static void dqput(struct dquot *dquot)
 {
+	int ret;
+
 	if (!dquot)
 		return;
 #ifdef __DQUOT_PARANOIA
@@ -594,7 +596,19 @@ we_slept:
 	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags) && dquot_dirty(dquot)) {
 		spin_unlock(&dq_list_lock);
 		/* Commit dquot before releasing */
-		dquot->dq_sb->dq_op->write_dquot(dquot);
+		ret = dquot->dq_sb->dq_op->write_dquot(dquot);
+		if (ret < 0) {
+			printk(KERN_ERR "VFS: cannot write quota structure on "
+				"device %s (error %d). Quota may get out of "
+				"sync!\n", dquot->dq_sb->s_id, ret);
+			/*
+			 * We clear dirty bit anyway, so that we avoid
+			 * infinite loop here
+			 */
+			spin_lock(&dq_list_lock);
+			clear_dquot_dirty(dquot);
+			spin_unlock(&dq_list_lock);
+		}
 		goto we_slept;
 	}
 	/* Clear flag in case dquot was inactive (something bad happened) */
_

Patches currently in -mm which might be from jack@suse.cz are

quota-fix-possible-infinite-loop-in-quota-code.patch
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

