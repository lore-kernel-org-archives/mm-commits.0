From: akpm@linux-foundation.org
Subject: [patch 15/20] ocfs2: fix double unlock in case retry after free
 truncate log
Date: Mon, 19 Sep 2016 14:44:33 -0700
Message-ID: <57e05c41.i77d4/bWF0ZTvdT8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52866 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932283AbcISVoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 17:44:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com

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
