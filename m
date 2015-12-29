From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating.patch added to -mm tree
Date: Tue, 29 Dec 2015 13:32:12 -0800
Message-ID: <5682fbdc.4kPS52jhyeZjjWt8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbbL2VcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 16:32:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: do not insert a new mle when another process is already migrating
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating.patch

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
Subject: ocfs2/dlm: do not insert a new mle when another process is already migrating

When two processes are migrating the same lockres, dlm_add_migration_mle()
return -EEXIST, but insert a new mle in hash list.  dlm_migrate_lockres()
will detach the old mle and free the new one which is already in hash
list, that will destroy the list.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
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

ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down.patch
ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch
ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2.patch
ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch
ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse.patch
ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

