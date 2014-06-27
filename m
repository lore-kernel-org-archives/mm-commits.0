From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch added to -mm tree
Date: Fri, 27 Jun 2014 12:33:39 -0700
Message-ID: <53adc713.53Bf660EXI2RAYZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:57348 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaF0Tdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jun 2014 15:33:40 -0400
Received: by mail-ie0-f201.google.com with SMTP id lx4so1246690iec.4
        for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2014 12:33:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix race between dispatched_work and dlm_lockres_grab_inflight_worker
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -694,14 +694,6 @@ void __dlm_lockres_grab_inflight_worker(
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
@@ -1635,6 +1627,7 @@ send_response:
 		}
 		mlog(0, "%u is the owner of %.*s, cleaning everyone else\n",
 			     dlm->node_num, res->lockname.len, res->lockname.name);
+		spin_lock(&res->spinlock);
 		ret = dlm_dispatch_assert_master(dlm, res, 0, request->node_idx,
 						 DLM_ASSERT_MASTER_MLE_CLEANUP);
 		if (ret < 0) {
@@ -1642,7 +1635,8 @@ send_response:
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
ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch
ocfs2-o2net-dont-shutdown-connection-when-idle-timeout.patch
ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch
ocfs2-quorum-add-a-log-for-node-not-fenced.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

