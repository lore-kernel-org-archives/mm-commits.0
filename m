From: akpm@linux-foundation.org
Subject: - fix-compilation-warning-in-dquotc.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:53 -0800
Message-ID: <200712202336.lBKNarbJ018831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502AbXLTXpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:45:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Fix compilation warning in dquot.c
has been removed from the -mm tree.  Its filename was
     fix-compilation-warning-in-dquotc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix compilation warning in dquot.c
From: Jan Kara <jack@suse.cz>

Fix compilation warning about discarded const.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dquot.c~fix-compilation-warning-in-dquotc fs/dquot.c
--- a/fs/dquot.c~fix-compilation-warning-in-dquotc
+++ a/fs/dquot.c
@@ -965,7 +965,7 @@ err_out:
 }
 #endif
 
-static inline void flush_warnings(struct dquot **dquots, char *warntype)
+static inline void flush_warnings(struct dquot * const *dquots, char *warntype)
 {
 	int i;
 
@@ -1216,7 +1216,7 @@ warn_put_all:
 		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 			if (inode->i_dquot[cnt])
 				mark_dquot_dirty(inode->i_dquot[cnt]);
-	flush_warnings((struct dquot **)inode->i_dquot, warntype);
+	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fix-computation-of-skb-size-for-quota-messages.patch
dont-send-quota-messages-repeatedly-when-hardlimit-reached.patch
git-ocfs2.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
