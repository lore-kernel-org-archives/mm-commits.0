From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
 removed from -mm tree
Date: Fri, 21 Aug 2015 14:31:12 -0700
Message-ID: <55d798a0.fDW/ZbkJT+h/J1wy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbHUVbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Aug 2015 17:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch

This patch was dropped because it was folded into ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2 fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2
+++ a/fs/ocfs2/namei.c
@@ -1545,20 +1545,24 @@ static int ocfs2_rename(struct inode *ol
 				  old_dentry->d_name.len, old_dir,
 				  &old_entry_lookup);
 	if (status) {
-		ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
-				"is not deleted.",
-				new_dentry->d_name.len, new_dentry->d_name.name,
-				old_dentry->d_name.len, old_dentry->d_name.name);
+		if (!is_journal_aborted(osb->journal->j_journal)) {
+			ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
+					"is not deleted.",
+					new_dentry->d_name.len, new_dentry->d_name.name,
+					old_dentry->d_name.len, old_dentry->d_name.name);
+		}
 		goto bail;
 	}
 
 	status = ocfs2_delete_entry(handle, old_dir, &old_entry_lookup);
 	if (status < 0) {
 		mlog_errno(status);
-		ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
-				"is not deleted.",
-				new_dentry->d_name.len, new_dentry->d_name.name,
-				old_dentry->d_name.len, old_dentry->d_name.name);
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

ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

