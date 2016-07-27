From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 11:58:57 -0700
Message-ID: <57990471.ex+YmfPWRRCUbcsF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbcG0S66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cleanup unneeded goto in ocfs2_create_new_inode_locks
has been removed from the -mm tree.  Its filename was
     ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: cleanup unneeded goto in ocfs2_create_new_inode_locks

The last goto is unneeded, so remove it.

Link: http://lkml.kernel.org/r/576213D3.6080002@huawei.com
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-cleanup-unneeded-goto-in-ocfs2_create_new_inode_locks
+++ a/fs/ocfs2/dlmglue.c
@@ -1665,10 +1665,8 @@ int ocfs2_create_new_inode_locks(struct
 	}
 
 	ret = ocfs2_create_new_lock(osb, &OCFS2_I(inode)->ip_open_lockres, 0, 0);
-	if (ret) {
+	if (ret)
 		mlog_errno(ret);
-		goto bail;
-	}
 
 bail:
 	return ret;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


