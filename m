From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down.patch
 added to -mm tree
Date: Mon, 28 Dec 2015 16:06:08 -0800
Message-ID: <5681ce70.6hyJXpLPeqHRSx28%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbL2AGJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Dec 2015 19:06:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: clear migration_pending when migration target goes down
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: clear migration_pending when migration target goes down

We have found a BUG on res->migration_pending when migrating
lock resources. The situation is as follows.

dlm_mark_lockres_migration
  res->migration_pending = 1;
  __dlm_lockres_reserve_ast
  dlm_lockres_release_ast returns with res->migration_pending remains
      because other threads reserve asts
  wait dlm_migration_can_proceed returns 1
  >>>>>>> o2hb found that target goes down and remove target
          from domain_map
  dlm_migration_can_proceed returns 1
  dlm_mark_lockres_migrating returns -ESHOTDOWN with
      res->migration_pending still remains.

When reentering dlm_mark_lockres_migrating(), it will trigger the BUG_ON
with res->migration_pending.  So clear migration_pending when target is
down.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2843,6 +2843,8 @@ again:
 	res->state &= ~DLM_LOCK_RES_BLOCK_DIRTY;
 	if (!ret)
 		BUG_ON(!(res->state & DLM_LOCK_RES_MIGRATING));
+	else
+		res->migration_pending = 0;
 	spin_unlock(&res->spinlock);
 
 	/*
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down.patch
ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch
ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2.patch
ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

