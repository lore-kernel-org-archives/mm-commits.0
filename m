From: akpm@linux-foundation.org
Subject: +
 ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly.patch added to -mm tree
Date: Fri, 28 Oct 2016 15:12:07 -0700
Message-ID: <5813cd37.w6t+9PqQOwKNYIls%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754750AbcJ1WMJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 18:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: delete redundant code and set the node bit into maybe_map directly
has been added to the -mm tree.  Its filename is
     ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: delete redundant code and set the node bit into maybe_map directly

The variable `set_maybe' is redundant when the mle has been found in the
map.  So it is ok to set the node_idx into mle's maybe_map directly.

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4A3D490DD@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
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

ocfs2-delete-redundant-code-and-set-the-node-bit-into-maybe_map-directly.patch

