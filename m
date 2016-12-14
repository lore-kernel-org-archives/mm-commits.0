From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:23:10 -0800
Message-ID: <58519c1e.T+l1F0CMt+K5R3UG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756499AbcLNTXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: clean up deadcode in dlm_master_request_handler()
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-clean-up-deadcode-in-dlm_master_request_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2/dlm: clean up deadcode in dlm_master_request_handler()

When 'dispatch_assert' is set, 'response' must be DLM_MASTER_RESP_YES, and
'res' won't be null, so execution can't reach these two branch.

Link: http://lkml.kernel.org/r/58174C91.3040004@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi Joseph Qi <jiangqi903@gmail.com>
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


