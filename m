From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail.patch removed from
 -mm tree
Date: Mon, 29 Feb 2016 12:24:48 -0800
Message-ID: <56d4a910.WP9taptIGpK5td2q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbcB2UYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 15:24:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: unlock inode if deleting inode from orphan fails
has been removed from the -mm tree.  Its filename was
     ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: unlock inode if deleting inode from orphan fails

When doing append direct io cleanup, if deleting inode fails, it goes out
without unlocking inode, which will cause the inode deadlock.  This issue
was introduced by commit cf1776a9e834("ocfs2: fix a tiny race when
truncate dio orohaned entry").

Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>	[4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/aops.c~ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail
+++ a/fs/ocfs2/aops.c
@@ -956,6 +956,7 @@ clean_orphan:
 		tmp_ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
 				update_isize, end);
 		if (tmp_ret < 0) {
+			ocfs2_inode_unlock(inode, 1);
 			ret = tmp_ret;
 			mlog_errno(ret);
 			brelse(di_bh);
_

Patches currently in -mm which might be from guozhonghua@h3c.com are


