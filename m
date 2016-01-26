From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch added to -mm tree
Date: Tue, 26 Jan 2016 13:21:08 -0800
Message-ID: <56a7e344.sXlwBhUUuTvnSqYo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbcAZVVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:21:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: return in progress if master can not clear the refmap bit right now
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch

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
Subject: ocfs2/dlm: return in progress if master can not clear the refmap bit right now

Master returns in-progress to non-master node when it can not clear the
refmap bit right now.  And non-master node will not purge the lock
resource until receiving deref done message.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
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
ocfs2-dlm-add-deref_done-message.patch
ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch
ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch
ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch

