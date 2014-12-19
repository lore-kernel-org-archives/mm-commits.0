From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch removed from -mm tree
Date: Fri, 19 Dec 2014 12:36:55 -0800
Message-ID: <54948c67.8NYiXRmHVjKlWYQw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaLSUg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 15:36:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix race between dispatched_work and dlm_lockres_grab_inflight_worker
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: fix race between dispatched_work and dlm_lockres_grab_inflight_worker

ac4fef4d23ed ("ocfs2/dlm: do not purge lockres that is queued for assert
master") may have the following possible race case:

dlm_dispatch_assert_master       dlm_wq
========================================================================
queue_work(dlm->quedlm_worker,
	&dlm->dispatched_work);
                                 dispatch work,
				 dlm_lockres_drop_inflight_worker
				 *BUG_ON(res->inflight_assert_workers == 0)*
dlm_lockres_grab_inflight_worker
inflight_assert_workers++

So ensure inflight_assert_workers to be increased first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Xue jiufei <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -695,14 +695,6 @@ void __dlm_lockres_grab_inflight_worker(
 			res->inflight_assert_workers);
 }
 
-static void dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
-		struct dlm_lock_resource *res)
-{
-	spin_lock(&res->spinlock);
-	__dlm_lockres_grab_inflight_worker(dlm, res);
-	spin_unlock(&res->spinlock);
-}
-
 static void __dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
 		struct dlm_lock_resource *res)
 {
@@ -1646,6 +1638,7 @@ send_response:
 		}
 		mlog(0, "%u is the owner of %.*s, cleaning everyone else\n",
 			     dlm->node_num, res->lockname.len, res->lockname.name);
+		spin_lock(&res->spinlock);
 		ret = dlm_dispatch_assert_master(dlm, res, 0, request->node_idx,
 						 DLM_ASSERT_MASTER_MLE_CLEANUP);
 		if (ret < 0) {
@@ -1653,7 +1646,8 @@ send_response:
 			response = DLM_MASTER_RESP_ERROR;
 			dlm_lockres_put(res);
 		} else
-			dlm_lockres_grab_inflight_worker(dlm, res);
+			__dlm_lockres_grab_inflight_worker(dlm, res);
+		spin_unlock(&res->spinlock);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-remove-bogus-check-in-dlm_process_recovery_data.patch
ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch
ocfs2-fix-leftover-orphan-entry-caused-by-append-o_direct-write-crash.patch

