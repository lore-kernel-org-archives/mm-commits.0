From: akpm@linux-foundation.org
Subject: - quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:14 -0700
Message-ID: <200805132133.m4DLXEG3000798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761195AbYEMVdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: don't call sync_fs() from vfs_quota_off() when there's no quota turn off
has been removed from the -mm tree.  Its filename was
     quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: don't call sync_fs() from vfs_quota_off() when there's no quota turn off
From: Jan Kara <jack@suse.cz>

Sometimes, vfs_quota_off() is called on a partially set up super block (for
example when fill_super() fails for some reason).  In such cases we cannot
call ->sync_fs() because it can Oops because of not properly filled in super
block.  So in case we find there's not quota to turn off, we just skip
everything and return which fixes the above problem.

[akpm@linux-foundation.org: fxi tpyo]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/dquot.c~quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off fs/dquot.c
--- a/fs/dquot.c~quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off
+++ a/fs/dquot.c
@@ -1491,6 +1491,16 @@ int vfs_quota_off(struct super_block *sb
 
 	/* We need to serialize quota_off() for device */
 	mutex_lock(&dqopt->dqonoff_mutex);
+
+	/*
+	 * Skip everything if there's nothing to do. We have to do this because
+	 * sometimes we are called when fill_super() failed and calling
+	 * sync_fs() in such cases does no good.
+	 */
+	if (!sb_any_quota_enabled(sb) && !sb_any_quota_suspended(sb)) {
+		mutex_unlock(&dqopt->dqonoff_mutex);
+		return 0;
+	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		toputinode[cnt] = NULL;
 		if (type != -1 && cnt != type)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
reiserfs-fix-synchronization-of-quota-files-in-journal=data-mode.patch
reiserfs-fix-typos-in-messages-and-comments-journalled-journaled.patch
reiserfs-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch
ext4-fix-mount-messages-when-quota-disabled.patch
ext4-fix-synchronization-of-quota-files-in-journal=data-mode.patch
ext4-fix-typos-in-messages-and-comments-journalled-journaled.patch
ext4-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

