From: akpm@linux-foundation.org
Subject: +
 ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch added to -mm tree
Date: Mon, 20 Apr 2015 14:24:45 -0700
Message-ID: <55356e9d.y4gqTGrQopImG1+S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbDTVYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 17:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: set filesytem read-only when ocfs2_delete_entry failed.
has been added to the -mm tree.  Its filename is
     ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch

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
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed
+++ a/fs/ocfs2/namei.c
@@ -1551,12 +1551,21 @@ static int ocfs2_rename(struct inode *ol
 	status = ocfs2_find_entry(old_dentry->d_name.name,
 				  old_dentry->d_name.len, old_dir,
 				  &old_entry_lookup);
-	if (status)
+	if (status) {
+		ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
+				"is not deleted.",
+				new_dentry->d_name.len, new_dentry->d_name.name,
+				old_dentry->d_name.len, old_dentry->d_name.name);
 		goto bail;
+	}
 
 	status = ocfs2_delete_entry(handle, old_dir, &old_entry_lookup);
 	if (status < 0) {
 		mlog_errno(status);
+		ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
+				"is not deleted.",
+				new_dentry->d_name.len, new_dentry->d_name.name,
+				old_dentry->d_name.len, old_dentry->d_name.name);
 		goto bail;
 	}
 
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

origin.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

