From: akpm@linux-foundation.org
Subject: [merged] ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:33 -0800
Message-ID: <56997345.UjV28O8aM38BkEu+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbcAOWbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix a race between purge and migration
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: fix a race between purge and migration

We found a race between purge and migration when doing code review.  Node
A put lockres to purgelist before receiving the migrate message from node
B which is the master.  Node A call dlm_mig_lockres_handler to handle this
message.

dlm_mig_lockres_handler
  dlm_lookup_lockres
  >>>>>> race window, dlm_run_purge_list may run and send
         deref message to master, waiting the response
  spin_lock(&res->spinlock);
  res->state |= DLM_LOCK_RES_MIGRATING;
  spin_unlock(&res->spinlock);
  dlm_mig_lockres_handler returns

  >>>>>> dlm_thread receives the response from master for the deref
  message and triggers the BUG because the lockres has the state
  DLM_LOCK_RES_MIGRATING with the following message:

dlm_purge_lockres:209 ERROR: 6633EB681FA7474A9C280A4E1A836F0F: res
M0000000000000000030c0300000000 in use after deref

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-a-race-between-purge-and-migratio fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-a-race-between-purge-and-migratio
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1373,6 +1373,7 @@ int dlm_mig_lockres_handler(struct o2net
 	char *buf = NULL;
 	struct dlm_work_item *item = NULL;
 	struct dlm_lock_resource *res = NULL;
+	unsigned int hash;
 
 	if (!dlm_grab(dlm))
 		return -EINVAL;
@@ -1400,7 +1401,10 @@ int dlm_mig_lockres_handler(struct o2net
 	/* lookup the lock to see if we have a secondary queue for this
 	 * already...  just add the locks in and this will have its owner
 	 * and RECOVERY flag changed when it completes. */
-	res = dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len);
+	hash = dlm_lockid_hash(mres->lockname, mres->lockname_len);
+	spin_lock(&dlm->spinlock);
+	res = __dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len,
+			hash);
 	if (res) {
 	 	/* this will get a ref on res */
 		/* mark it as recovering/migrating and hash it */
@@ -1421,13 +1425,16 @@ int dlm_mig_lockres_handler(struct o2net
 				     mres->lockname_len, mres->lockname);
 				ret = -EFAULT;
 				spin_unlock(&res->spinlock);
+				spin_unlock(&dlm->spinlock);
 				dlm_lockres_put(res);
 				goto leave;
 			}
 			res->state |= DLM_LOCK_RES_MIGRATING;
 		}
 		spin_unlock(&res->spinlock);
+		spin_unlock(&dlm->spinlock);
 	} else {
+		spin_unlock(&dlm->spinlock);
 		/* need to allocate, just like if it was
 		 * mastered here normally  */
 		res = dlm_new_lockres(dlm, mres->lockname, mres->lockname_len);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

