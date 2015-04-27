From: akpm@linux-foundation.org
Subject: +
 ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch added to -mm tree
Date: Mon, 27 Apr 2015 16:21:17 -0700
Message-ID: <553ec46d.qjXkxypRlyg89MN7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbbD0XVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Apr 2015 19:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2
has been added to the -mm tree.  Its filename is
     ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1552,20 +1552,24 @@ static int ocfs2_rename(struct inode *ol
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
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

