From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:54 -0800
Message-ID: <5699735a.aJ66EvG1s5YW6gPS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbcAOWbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: access orphan dinode before delete entry in ocfs2_orphan_del
has been removed from the -mm tree.  Its filename was
     ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-access-orphan-dinode-before-delete-entry-in-ocfs2_orphan_del
+++ a/fs/ocfs2/namei.c
@@ -2372,6 +2372,15 @@ int ocfs2_orphan_del(struct ocfs2_super
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
@@ -2385,15 +2394,6 @@ int ocfs2_orphan_del(struct ocfs2_super
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
-	}
