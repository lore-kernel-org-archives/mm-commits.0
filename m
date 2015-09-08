From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:02:18 -0700
Message-ID: <55ef22aa.5YdGFmlSOsKTYxWi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbIHSCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: set filesytem read-only when ocfs2_delete_entry failed.
has been removed from the -mm tree.  Its filename was
     ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: set filesytem read-only when ocfs2_delete_entry failed.

In ocfs2_rename, it will lead to an inode with two entried(old and new) if
ocfs2_delete_entry(old) failed.  Thus, filesystem will be inconsistent.

The case is described below:

ocfs2_rename
    -> ocfs2_start_trans
    -> ocfs2_add_entry(new)
    -> ocfs2_delete_entry(old)
        -> __ocfs2_journal_access *failed* because of -ENOMEM
    -> ocfs2_commit_trans

So filesystem should be set to read-only at the moment.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed
+++ a/fs/ocfs2/namei.c
@@ -1569,12 +1569,25 @@ static int ocfs2_rename(struct inode *ol
 	status = ocfs2_find_entry(old_dentry->d_name.name,
 				  old_dentry->d_name.len, old_dir,
 				  &old_entry_lookup);
-	if (status)
+	if (status) {
+		if (!is_journal_aborted(osb->journal->j_journal)) {
+			ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
+					"is not deleted.",
+					new_dentry->d_name.len, new_dentry->d_name.name,
+					old_dentry->d_name.len, old_dentry->d_name.name);
+		}
 		goto bail;
+	}
 
 	status = ocfs2_delete_entry(handle, old_dir, &old_entry_lookup);
 	if (status < 0) {
 		mlog_errno(status);
+		if (!is_journal_aborted(osb->journal->j_journal)) {
+			ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
+					"is not deleted.",
+					new_dentry->d_name.len, new_dentry->d_name.name,
+					old_dentry->d_name.len, old_dentry->d_name.name);
+		}
 		goto bail;
 	}
 
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are


