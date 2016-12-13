From: akpm@linux-foundation.org
Subject: [patch 012/123] ocfs2: delete redundant code and set the node bit into maybe_map directly
Date: Mon, 12 Dec 2016 16:41:11 -0800
Message-ID: <584f43a7.vM6tGszgFsjeTAjM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAlM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:41:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com

From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: delete redundant code and set the node bit into maybe_map directly

The variable `set_maybe' is redundant when the mle has been found in the
map.  So it is ok to set the node_idx into mle's maybe_map directly.

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4A3D490DD@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Reviewed-by: Mark Fasheh <mfasheh@versity.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1609,8 +1609,6 @@ way_up_top:
 		__dlm_insert_mle(dlm, mle);
 		response = DLM_MASTER_RESP_NO;
 	} else {
-		// mlog(0, "mle was found\n");
-		set_maybe = 1;
 		spin_lock(&tmpmle->spinlock);
 		if (tmpmle->master == dlm->node_num) {
 			mlog(ML_ERROR, "no lockres, but an mle with this node as master!\n");
@@ -1625,8 +1623,7 @@ way_up_top:
 			response = DLM_MASTER_RESP_NO;
 		} else
 			response = DLM_MASTER_RESP_MAYBE;
-		if (set_maybe)
-			set_bit(request->node_idx, tmpmle->maybe_map);
+		set_bit(request->node_idx, tmpmle->maybe_map);
 		spin_unlock(&tmpmle->spinlock);
 	}
 	spin_unlock(&dlm->master_lock);
_
