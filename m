From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse.patch added to -mm tree
Date: Tue, 29 Dec 2015 13:19:16 -0800
Message-ID: <5682f8d4.uLtGU/qW8gDzdAl+%akpm__41114.7891580642$1451423985$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbbL2VTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 16:19:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: ignore cleaning the migration mle that is inuse
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse.patch

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
Subject: ocfs2/dlm: ignore cleaning the migration mle that is inuse

We have found that migration source will trigger a BUG that the
refcount of mle is already zero before put when the target is
down during migration. The situation is as follows:

dlm_migrate_lockres
  dlm_add_migration_mle
  dlm_mark_lockres_migrating
  dlm_get_mle_inuse
  <<<<<< Now the refcount of the mle is 2.
  dlm_send_one_lockres and wait for the target to become the
  new master.
  <<<<<< o2hb detect the target down and clean the migration
  mle. Now the refcount is 1.

dlm_migrate_lockres woken, and put the mle twice when found
the target goes down which trigger the BUG with the following
message:
"ERROR: bad mle: ".

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2519,6 +2519,11 @@ static int dlm_migrate_lockres(struct dl
 	spin_lock(&dlm->master_lock);
 	ret = dlm_add_migration_mle(dlm, res, mle, &oldmle, name,
 				    namelen, target, dlm->node_num);
+	/* get an extra reference on the mle.
+	 * otherwise the assert_master from the new
+	 * master will destroy this.
+	 */
+	dlm_get_mle_inuse(mle);
 	spin_unlock(&dlm->master_lock);
 	spin_unlock(&dlm->spinlock);
 
@@ -2554,6 +2559,7 @@ fail:
 		if (mle_added) {
 			dlm_mle_detach_hb_events(dlm, mle);
 			dlm_put_mle(mle);
+			dlm_put_mle_inuse(mle);
 		} else if (mle) {
 			kmem_cache_free(dlm_mle_cache, mle);
 			mle = NULL;
@@ -2571,17 +2577,6 @@ fail:
 	 * ensure that all assert_master work is flushed. */
 	flush_workqueue(dlm->dlm_worker);
 
-	/* get an extra reference on the mle.
-	 * otherwise the assert_master from the new
-	 * master will destroy this.
-	 * also, make sure that all callers of dlm_get_mle
-	 * take both dlm->spinlock and dlm->master_lock */
-	spin_lock(&dlm->spinlock);
-	spin_lock(&dlm->master_lock);
-	dlm_get_mle_inuse(mle);
-	spin_unlock(&dlm->master_lock);
-	spin_unlock(&dlm->spinlock);
-
 	/* notify new node and send all lock state */
 	/* call send_one_lockres with migration flag.
 	 * this serves as notice to the target node that a
@@ -3312,6 +3307,15 @@ top:
 			    mle->new_master != dead_node)
 				continue;
 
+			if (mle->new_master == dead_node && mle->inuse) {
+				mlog(ML_NOTICE, "%s: target %u died during "
+						"migration from %u, the MLE is "
+						"still keep used, ignore it!\n",
+						dlm->name, dead_node,
+						mle->master);
+				continue;
+			}
+
 			/* If we have reached this point, this mle needs to be
 			 * removed from the list and freed. */
 			dlm_clean_migration_mle(dlm, mle);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-clear-migration_pending-when-migration-target-goes-down.patch
ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch
ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2.patch
ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch
ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

