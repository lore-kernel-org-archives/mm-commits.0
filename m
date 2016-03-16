From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:11 -0700
Message-ID: <56e9b9a7.ClrozHWICeiuV8nS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTxM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: return in progress if master can not clear the refmap bit right now
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: return in progress if master can not clear the refmap bit right now

Master returns in-progress to non-master node when it can not clear the
refmap bit right now.  And non-master node will not purge the lock
resource until receiving deref done message.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |    5 +++++
 fs/ocfs2/dlm/dlmmaster.c |    8 +++++---
 fs/ocfs2/dlm/dlmthread.c |    7 +++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -783,6 +783,11 @@ struct dlm_deref_lockres
 	u8 name[O2NM_MAX_NAME_LEN];
 };
 
+enum {
+	DLM_DEREF_RESPONSE_DONE = 0,
+	DLM_DEREF_RESPONSE_INPROG = 1,
+};
+
 struct dlm_deref_lockres_done {
 	u32 pad1;
 	u16 pad2;
diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2278,7 +2278,7 @@ int dlm_drop_lockres_ref(struct dlm_ctxt
 		dlm_print_one_lock_resource(res);
 		BUG();
 	}
-	return ret;
+	return ret ? ret : r;
 }
 
 int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
@@ -2345,7 +2345,7 @@ int dlm_deref_lockres_handler(struct o2n
 		     	res->lockname.len, res->lockname.name, node);
 			dlm_print_one_lock_resource(res);
 		}
-		ret = 0;
+		ret = DLM_DEREF_RESPONSE_DONE;
 		goto done;
 	}
 
@@ -2365,7 +2365,7 @@ int dlm_deref_lockres_handler(struct o2n
 	spin_unlock(&dlm->work_lock);
 
 	queue_work(dlm->dlm_worker, &dlm->dispatched_work);
-	return 0;
+	return DLM_DEREF_RESPONSE_INPROG;
 
 done:
 	if (res)
@@ -2511,6 +2511,8 @@ static void dlm_deref_lockres_worker(str
 	}
 	spin_unlock(&res->spinlock);
 
+	dlm_drop_lockres_ref_done(dlm, res, node);
+
 	if (cleared) {
 		mlog(0, "%s:%.*s node %u ref dropped in dispatch\n",
 		     dlm->name, res->lockname.len, res->lockname.name, node);
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -202,6 +202,13 @@ static void dlm_purge_lockres(struct dlm
 		dlm->purge_count--;
 	}
 
+	if (!master && ret != 0) {
+		mlog(0, "%s: deref %.*s in progress or master goes down\n",
+			dlm->name, res->lockname.len, res->lockname.name);
+		spin_unlock(&res->spinlock);
+		return;
+	}
+
 	if (!__dlm_lockres_unused(res)) {
 		mlog(ML_ERROR, "%s: res %.*s in use after deref\n",
 		     dlm->name, res->lockname.len, res->lockname.name);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

