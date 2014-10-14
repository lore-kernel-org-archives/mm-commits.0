From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-let-sender-retry-if-dlm_dispatch_assert_master-failed-with-enomem.patch added to -mm tree
Date: Tue, 14 Oct 2014 15:18:56 -0700
Message-ID: <543da150.rRO/Has8OVnhbyod%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaJNWS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 18:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: let sender retry if dlm_dispatch_assert_master failed with -ENOMEM
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-let-sender-retry-if-dlm_dispatch_assert_master-failed-with-enomem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-let-sender-retry-if-dlm_dispatch_assert_master-failed-with-enomem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-let-sender-retry-if-dlm_dispatch_assert_master-failed-with-enomem.patch

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
Subject: ocfs2/dlm: let sender retry if dlm_dispatch_assert_master failed with -ENOMEM

Do not BUG() if GFP_ATOMIC allocation fails in dlm_dispatch_assert_master.
 Instead, return -ENOMEM to the sender and then retry.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-let-sender-retry-if-dlm_dispatch_assert_master-failed-with-enomem fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-let-sender-retry-if-dlm_dispatch_assert_master-failed-with-enomem
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1656,14 +1656,18 @@ int dlm_do_master_requery(struct dlm_ctx
 	req.namelen = res->lockname.len;
 	memcpy(req.name, res->lockname.name, res->lockname.len);
 
+resend:
 	ret = o2net_send_message(DLM_MASTER_REQUERY_MSG, dlm->key,
 				 &req, sizeof(req), nodenum, &status);
-	/* XXX: negative status not handled properly here. */
 	if (ret < 0)
 		mlog(ML_ERROR, "Error %d when sending message %u (key "
 		     "0x%x) to node %u\n", ret, DLM_MASTER_REQUERY_MSG,
 		     dlm->key, nodenum);
-	else {
+	else if (status == -ENOMEM) {
+		mlog_errno(status);
+		msleep(50);
+		goto resend;
+	} else {
 		BUG_ON(status < 0);
 		BUG_ON(status > DLM_LOCK_RES_OWNER_UNKNOWN);
 		*real_master = (u8) (status & 0xff);
@@ -1705,9 +1709,13 @@ int dlm_master_requery_handler(struct o2
 			int ret = dlm_dispatch_assert_master(dlm, res,
 							     0, 0, flags);
 			if (ret < 0) {
-				mlog_errno(-ENOMEM);
-				/* retry!? */
-				BUG();
+				mlog_errno(ret);
+				spin_unlock(&res->spinlock);
+				dlm_lockres_put(res);
+				spin_unlock(&dlm->spinlock);
+				dlm_put(dlm);
+				/* sender will take care of this and retry */
+				return ret;
 			} else
 				__dlm_lockres_grab_inflight_worker(dlm, res);
 			spin_unlock(&res->spinlock);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-dlm-let-sender-retry-if-dlm_dispatch_assert_master-failed-with-enomem.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

