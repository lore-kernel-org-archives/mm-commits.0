From: akpm@linux-foundation.org
Subject: + ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail.patch
 added to -mm tree
Date: Wed, 24 Feb 2016 14:11:30 -0800
Message-ID: <56ce2a92.+wCQQG2BUJGX0bca%akpm__44486.5207690329$1456351929$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbcBXWLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2016 17:11:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: unlock inode if deleting inode from orphan fails
has been added to the -mm tree.  Its filename is
     ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-unlock-inode-if-deleting-inode-from-orphan-fail.patch

