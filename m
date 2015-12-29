From: akpm@linux-foundation.org
Subject: +
 ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del.patch
 added to -mm tree
Date: Tue, 29 Dec 2015 13:42:24 -0800
Message-ID: <5682fe40.HDCEs9+1drsV+88R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbL2Vm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 16:42:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: access orphan dinode before delete entry in ocfs2_orphan_del
has been added to the -mm tree.  Its filename is
     ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: access orphan dinode before delete entry in ocfs2_orphan_del

In ocfs2_orphan_del, currently it finds and deletes entry first, and then
access orphan dir dinode.  This will have a problem once
ocfs2_journal_access_di fails.  In this case, entry will be removed from
orphan dir, but in deed the inode hasn't been deleted successfully.  In
other words, the file is missing but not actually deleted.  So we should
access orphan dinode first like unlink and rename.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del
+++ a/fs/ocfs2/namei.c
@@ -2371,6 +2371,15 @@ int ocfs2_orphan_del(struct ocfs2_super
 	     (unsigned long long)OCFS2_I(orphan_dir_inode)->ip_blkno,
 	     name, strlen(name));
 
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(orphan_dir_inode),
+					 orphan_dir_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
 	/* find it's spot in the orphan directory */
 	status = ocfs2_find_entry(name, strlen(name), orphan_dir_inode,
 				  &lookup);
@@ -2384,15 +2393,6 @@ int ocfs2_orphan_del(struct ocfs2_super
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
-	}
