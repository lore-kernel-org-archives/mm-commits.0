From: akpm@linux-foundation.org
Subject: [patch 013/123] ocfs2/dlm: clean up deadcode in
 dlm_master_request_handler()
Date: Mon, 12 Dec 2016 16:41:14 -0800
Message-ID: <584f43aa.e3Nzk7P9HlIE7Qx/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40446 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAlP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, piaojun@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com

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
