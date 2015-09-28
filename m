From: akpm@linux-foundation.org
Subject: [merged] ocfs2-dlm-fix-deadlock-when-dispatch-assert-master.patch removed from -mm tree
Date: Mon, 28 Sep 2015 11:16:11 -0700
Message-ID: <560983eb.8wS5CNSpA0Mb13p/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbI1SQM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 14:16:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix deadlock when dispatch assert master
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-deadlock-when-dispatch-assert-master.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: fix deadlock when dispatch assert master

The order of the following three spinlocks should be:
dlm_domain_lock < dlm_ctxt->spinlock < dlm_lock_resource->spinlock

But dlm_dispatch_assert_master() is called while holding
dlm_ctxt->spinlock and dlm_lock_resource->spinlock, and then it calls
dlm_grab() which will take dlm_domain_lock.

Once another thread (for example, dlm_query_join_handler) has already
taken dlm_domain_lock, and tries to take dlm_ctxt->spinlock deadlock
happens.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: "Junxiao Bi" <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c   |    9 ++++++---
 fs/ocfs2/dlm/dlmrecovery.c |    8 ++++++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-deadlock-when-dispatch-assert-master fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-deadlock-when-dispatch-assert-master
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1439,6 +1439,7 @@ int dlm_master_request_handler(struct o2
 	int found, ret;
 	int set_maybe;
 	int dispatch_assert = 0;
+	int dispatched = 0;
 
 	if (!dlm_grab(dlm))
 		return DLM_MASTER_RESP_NO;
@@ -1658,15 +1659,18 @@ send_response:
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
 			dlm_lockres_put(res);
-		} else
+		} else {
+			dispatched = 1;
 			__dlm_lockres_grab_inflight_worker(dlm, res);
+		}
 		spin_unlock(&res->spinlock);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
 	}
 
-	dlm_put(dlm);
+	if (!dispatched)
+		dlm_put(dlm);
 	return response;
 }
 
@@ -2090,7 +2094,6 @@ int dlm_dispatch_assert_master(struct dl
 
 
 	/* queue up work for dlm_assert_master_worker */
-	dlm_grab(dlm);  /* get an extra ref for the work item */
 	dlm_init_work_item(dlm, item, dlm_assert_master_worker, NULL);
 	item->u.am.lockres = res; /* already have a ref */
 	/* can optionally ignore node numbers higher than this node */
diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-deadlock-when-dispatch-assert-master fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-deadlock-when-dispatch-assert-master
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1694,6 +1694,7 @@ int dlm_master_requery_handler(struct o2
 	unsigned int hash;
 	int master = DLM_LOCK_RES_OWNER_UNKNOWN;
 	u32 flags = DLM_ASSERT_MASTER_REQUERY;
+	int dispatched = 0;
 
 	if (!dlm_grab(dlm)) {
 		/* since the domain has gone away on this
@@ -1719,8 +1720,10 @@ int dlm_master_requery_handler(struct o2
 				dlm_put(dlm);
 				/* sender will take care of this and retry */
 				return ret;
-			} else
+			} else {
+				dispatched = 1;
 				__dlm_lockres_grab_inflight_worker(dlm, res);
+			}
 			spin_unlock(&res->spinlock);
 		} else {
 			/* put.. incase we are not the master */
@@ -1730,7 +1733,8 @@ int dlm_master_requery_handler(struct o2
 	}
 	spin_unlock(&dlm->spinlock);
 
-	dlm_put(dlm);
+	if (!dispatched)
+		dlm_put(dlm);
 	return master;
 }
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-improve-performance-for-localalloc.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

