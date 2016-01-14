From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2.patch removed from -mm
 tree
Date: Thu, 14 Jan 2016 14:17:56 -0800
Message-ID: <56981e94.isoSwjg3CTvV3yLK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbcANWR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2.patch

This patch was dropped because it was folded into ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2 fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-a-race-between-purge-and-migratio-v2
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1373,6 +1373,7 @@ int dlm_mig_lockres_handler(struct o2net
 	char *buf = NULL;
 	struct dlm_work_item *item = NULL;
 	struct dlm_lock_resource *res = NULL;
+	unsigned int hash;
 
 	if (!dlm_grab(dlm))
 		return -EINVAL;
@@ -1400,33 +1401,14 @@ int dlm_mig_lockres_handler(struct o2net
 	/* lookup the lock to see if we have a secondary queue for this
 	 * already...  just add the locks in and this will have its owner
 	 * and RECOVERY flag changed when it completes. */
-way_up_top:
-	res = dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len);
+	hash = dlm_lockid_hash(mres->lockname, mres->lockname_len);
+	spin_lock(&dlm->spinlock);
+	res = __dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len,
+			hash);
 	if (res) {
 	 	/* this will get a ref on res */
 		/* mark it as recovering/migrating and hash it */
 		spin_lock(&res->spinlock);
-
-		/*
-		 * Right after dlm spinlock was released, dlm_thread could have
-		 * purged the lockres. Check if lockres got unhashed. If so
-		 * start over.
-		 */
-		if (hlist_unhashed(&res->hash_node)) {
-			spin_unlock(&res->spinlock);
-			dlm_lockres_put(res);
-			goto way_up_top;
-		}
-
-		/* Wait on the resource purge to complete before continuing */
-		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
-			__dlm_wait_on_lockres_flags(res,
-					DLM_LOCK_RES_DROPPING_REF);
-			spin_unlock(&res->spinlock);
-			dlm_lockres_put(res);
-			goto way_up_top;
-		}
-
 		if (mres->flags & DLM_MRES_RECOVERY) {
 			res->state |= DLM_LOCK_RES_RECOVERING;
 		} else {
@@ -1443,13 +1425,16 @@ way_up_top:
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

ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch
ocfs2-dlm-return-appropriate-value-when-dlm_grab-returns-null.patch
ocfs2-dlm-ignore-cleaning-the-migration-mle-that-is-inuse.patch
ocfs2-dlm-do-not-insert-a-new-mle-when-another-process-is-already-migrating.patch

