From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-double-unlock-in-case-retry-after-free-truncate-log.patch removed from -mm tree
Date: Tue, 20 Sep 2016 12:30:51 -0700
Message-ID: <57e18e6b.RxfcQcdSqI3zAkkM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48704 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbcITTaw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 15:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix double unlock in case retry after free truncate log
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-double-unlock-in-case-retry-after-free-truncate-log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix double unlock in case retry after free truncate log

If ocfs2_reserve_cluster_bitmap_bits fails with ENOSPC, it will try to
free truncate log and then retry.  Since ocfs2_try_to_free_truncate_log
will lock/unlock global bitmap inode, we have to unlock it before calling
this function.  But when retry reserve and it fails with no global bitmap
inode lock taken, it will unlock again in error handling branch and BUG.

This issue also exists if no need retry and then ocfs2_inode_lock fails.
So fix it.

Fixes: 2070ad1aebff ("ocfs2: retry on ENOSPC if sufficient space in
truncate log"
Link: http://lkml.kernel.org/r/57D91939.6030809@huawei.com
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/suballoc.c~ocfs2-fix-double-unlock-in-case-retry-after-free-truncate-log fs/ocfs2/suballoc.c
--- a/fs/ocfs2/suballoc.c~ocfs2-fix-double-unlock-in-case-retry-after-free-truncate-log
+++ a/fs/ocfs2/suballoc.c
@@ -1199,14 +1199,24 @@ retry:
 			inode_unlock((*ac)->ac_inode);
 
 			ret = ocfs2_try_to_free_truncate_log(osb, bits_wanted);
-			if (ret == 1)
+			if (ret == 1) {
+				iput((*ac)->ac_inode);
+				(*ac)->ac_inode = NULL;
 				goto retry;
+			}
 
 			if (ret < 0)
 				mlog_errno(ret);
 
 			inode_lock((*ac)->ac_inode);
-			ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
+			ret = ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
+			if (ret < 0) {
+				mlog_errno(ret);
+				inode_unlock((*ac)->ac_inode);
+				iput((*ac)->ac_inode);
+				(*ac)->ac_inode = NULL;
+				goto bail;
+			}
 		}
 		if (status < 0) {
 			if (status != -ENOSPC)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


