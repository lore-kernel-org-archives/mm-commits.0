From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler.patch added to -mm tree
Date: Tue, 08 Nov 2016 15:23:37 -0800
Message-ID: <58225e79.7vX+DvCk3oWa2nii%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbcKHXXi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 18:23:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: clean up deadcode in dlm_master_request_handler()
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler.patch

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
Subject: ocfs2/dlm: clean up deadcode in dlm_master_request_handler()

When 'dispatch_assert' is set, 'response' must be DLM_MASTER_RESP_YES, and
'res' won't be null, so execution can't reach these two branch.

Link: http://lkml.kernel.org/r/58174C91.3040004@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1641,12 +1641,6 @@ send_response:
 	 * dlm_assert_master_worker() isn't called, we drop it here.
 	 */
 	if (dispatch_assert) {
-		if (response != DLM_MASTER_RESP_YES)
-			mlog(ML_ERROR, "invalid response %d\n", response);
-		if (!res) {
-			mlog(ML_ERROR, "bad lockres while trying to assert!\n");
-			BUG();
-		}
 		mlog(0, "%u is the owner of %.*s, cleaning everyone else\n",
 			     dlm->node_num, res->lockname.len, res->lockname.name);
 		spin_lock(&res->spinlock);
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch
ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler.patch

