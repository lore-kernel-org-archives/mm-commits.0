From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:23:07 -0800
Message-ID: <58519c1b.wEYh9nMXJNA2li8x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756499AbcLNTXI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: delete redundant code and set the node bit into maybe_map directly
has been removed from the -mm tree.  Its filename was
     ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from guozhonghua@h3c.com are

ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch

