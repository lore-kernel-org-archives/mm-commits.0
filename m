From: akpm@linux-foundation.org
Subject: [merged] ocfs2-do-not-lock-unlock-inode-dlm-lock.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:31:47 -0800
Message-ID: <56997353.GDi7UX0HZsVM+Ooi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbcAOWbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: do not lock/unlock() inode DLM lock
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-lock-unlock-inode-dlm-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: ocfs2: do not lock/unlock() inode DLM lock

DLM does not cache locks.  So, blocking lock and unlock will only make the
performance worse where contention over the locks is high.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-do-not-lock-unlock-inode-dlm-lock fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-do-not-lock-unlock-inode-dlm-lock
+++ a/fs/ocfs2/dlmglue.c
@@ -2432,12 +2432,6 @@ bail:
  * done this we have to return AOP_TRUNCATED_PAGE so the aop method
  * that called us can bubble that back up into the VFS who will then
  * immediately retry the aop call.
- *
- * We do a blocking lock and immediate unlock before returning, though, so that
- * the lock has a great chance of being cached on this node by the time the VFS
- * calls back to retry the aop.    This has a potential to livelock as nodes
- * ping locks back and forth, but that's a risk we're willing to take to avoid
- * the lock inversion simply.
  */
 int ocfs2_inode_lock_with_page(struct inode *inode,
 			      struct buffer_head **ret_bh,
@@ -2449,8 +2443,6 @@ int ocfs2_inode_lock_with_page(struct in
 	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
 	if (ret == -EAGAIN) {
 		unlock_page(page);
-		if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
-			ocfs2_inode_unlock(inode, ex);
 		ret = AOP_TRUNCATED_PAGE;
 	}
 
_

Patches currently in -mm which might be from rgoldwyn@suse.com are


