From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:53:14 -0700
Message-ID: <56e9b9aa.sQ7K35GbmvG85h+y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: clear DROPPING_REF flag when the master goes down
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: clear DROPPING_REF flag when the master goes down

If the master goes down after return in-progress for deref message.  The
lock resource on non-master node can not be purged.  Clear the
DROPPING_REF flag and recovery it.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2377,14 +2377,16 @@ static void dlm_do_local_recovery_cleanu
 			dlm_revalidate_lvb(dlm, res, dead_node);
 			if (res->owner == dead_node) {
 				if (res->state & DLM_LOCK_RES_DROPPING_REF) {
-					mlog(ML_NOTICE, "%s: res %.*s, Skip "
-					     "recovery as it is being freed\n",
-					     dlm->name, res->lockname.len,
-					     res->lockname.name);
-				} else
-					dlm_move_lockres_to_recovery_list(dlm,
-									  res);
