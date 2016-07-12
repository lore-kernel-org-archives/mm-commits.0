From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler.patch added to -mm tree
Date: Tue, 12 Jul 2016 13:50:43 -0700
Message-ID: <57855823.2FtiAc4UxnPrzhVo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbcGLUuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 16:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: disable BUG_ON when DLM_LOCK_RES_DROPPING_REF is cleared before dlm_deref_lockres_done_handler
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2/dlm: disable BUG_ON when DLM_LOCK_RES_DROPPING_REF is cleared before dlm_deref_lockres_done_handler

We found a BUG situation in which DLM_LOCK_RES_DROPPING_REF is cleared
unexpected that described below.  To solve the bug, we disable the BUG_ON
and purge lockres in dlm_do_local_recovery_cleanup.

Node 1                               Node 2(master)
dlm_purge_lockres
                                     dlm_deref_lockres_handler

                                     DLM_LOCK_RES_SETREF_INPROG is set
                                     response DLM_DEREF_RESPONSE_INPROG

receive DLM_DEREF_RESPONSE_INPROG
stop puring in dlm_purge_lockres
and wait for DLM_DEREF_RESPONSE_DONE

                                     dispatch dlm_deref_lockres_worker
                                     response DLM_DEREF_RESPONSE_DONE

receive DLM_DEREF_RESPONSE_DONE and
prepare to purge lockres

                                     Node 2 goes down

find Node2 down and do local
clean up for Node2:
dlm_do_local_recovery_cleanup
  -> clear DLM_LOCK_RES_DROPPING_REF

when purging lockres, BUG_ON happens
because DLM_LOCK_RES_DROPPING_REF is clear:
dlm_deref_lockres_done_handler
  ->BUG_ON(!(res->state & DLM_LOCK_RES_DROPPING_REF));

Fixes: 60d663cb5273 ("ocfs2/dlm: add DEREF_DONE message")
Link: http://lkml.kernel.org/r/57845055.9080702@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2416,7 +2416,17 @@ int dlm_deref_lockres_done_handler(struc
 	}
 
 	spin_lock(&res->spinlock);
-	BUG_ON(!(res->state & DLM_LOCK_RES_DROPPING_REF));
+	if (!(res->state & DLM_LOCK_RES_DROPPING_REF)) {
+		spin_unlock(&res->spinlock);
+		spin_unlock(&dlm->spinlock);
+		mlog(ML_NOTICE, "%s:%.*s: node %u sends deref done "
+			"but it is already derefed!\n", dlm->name,
+			res->lockname.len, res->lockname.name, node);
+		dlm_lockres_put(res);
+		ret = 0;
+		goto done;
+	}
+
 	if (!list_empty(&res->purge)) {
 		mlog(0, "%s: Removing res %.*s from purgelist\n",
 			dlm->name, res->lockname.len, res->lockname.name);
@@ -2457,6 +2467,8 @@ int dlm_deref_lockres_done_handler(struc
 
 	ret = 0;
 
+	ret = 0;
+
 done:
 	dlm_put(dlm);
 	return ret;
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler.patch
ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref.patch
ocfs2-dlm-continue-to-purge-recovery-lockres-when-recovery-master-goes-down.patch

