From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:51 -0800
Message-ID: <56997357.pPhSL3GbjgrULqa8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbcAOWbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: do not insert a new mle when another process is already migrating
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: do not insert a new mle when another process is already migrating

When two processes are migrating the same lockres, dlm_add_migration_mle()
return -EEXIST, but insert a new mle in hash list.  dlm_migrate_lockres()
will detach the old mle and free the new one which is already in hash
list, that will destroy the list.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2549,7 +2549,7 @@ static int dlm_migrate_lockres(struct dl
 	}
 
 fail:
-	if (oldmle) {
+	if (ret != -EEXIST && oldmle) {
 		/* master is known, detach if not already detached */
 		dlm_mle_detach_hb_events(dlm, oldmle);
 		dlm_put_mle(oldmle);
@@ -3136,7 +3136,8 @@ static int dlm_add_migration_mle(struct
 				mlog(0, "tried to migrate %.*s, but some "
 				     "process beat me to it\n",
 				     namelen, name);
-				ret = -EEXIST;
+				spin_unlock(&tmp->spinlock);
+				return -EEXIST;
 			} else {
 				/* bad.  2 NODES are trying to migrate! */
 				mlog(ML_ERROR, "migration error  mle: "
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

