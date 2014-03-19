From: akpm@linux-foundation.org
Subject: [nacked]
 ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch removed from -mm tree
Date: Wed, 19 Mar 2014 16:05:03 -0700
Message-ID: <532a229f.7evtl3zk9KdgV8kI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaCSXFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 19:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [nacked] ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 16:05:03 -0700


The patch titled
     Subject: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()
has been removed from the -mm tree.  Its filename was
     ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()

While deleting a file into orphan dir in ocfs2_orphan_del(), it calls
ocfs2_delete_entry() before ocfs2_journal_access_di().  If
ocfs2_delete_entry() succeeded and ocfs2_journal_access_di() failed, there
would be a inconsistency: the file is deleted from orphan dir, but orphan
dir dinode is not updated.

So we need to call ocfs2_journal_access_di() before ocfs2_orphan_del().

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jensen <shencanquan@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del
+++ a/fs/ocfs2/namei.c
@@ -2261,17 +2261,17 @@ int ocfs2_orphan_del(struct ocfs2_super
 		goto leave;
 	}
 
-	/* remove it from the orphan directory */
-	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(orphan_dir_inode),
+					 orphan_dir_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
-	status = ocfs2_journal_access_di(handle,
-					 INODE_CACHE(orphan_dir_inode),
-					 orphan_dir_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
+	/* remove it from the orphan directory */
+	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
_

Patches currently in -mm which might be from younger.liu@huawei.com are


