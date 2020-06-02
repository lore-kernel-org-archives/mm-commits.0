From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-add-missing-annotation-for-dlm_empty_lockres.patch removed from -mm
 tree
Date: Tue, 02 Jun 2020 14:37:30 -0700
Message-ID: <20200602213730.MxXS-6HuD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbgFBVhb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jbi.octave@gmail.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: add missing annotation for dlm_empty_lockres()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-missing-annotation-for-dlm_empty_lockres.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: ocfs2: add missing annotation for dlm_empty_lockres()

Sparse reports a warning at dlm_empty_lockres()

warning: context imbalance in dlm_purge_lockres() - unexpected unlock

The root cause is the missing annotation at dlm_purge_lockres()

Add the missing __must_hold(&dlm->spinlock)

Link: http://lkml.kernel.org/r/20200403160505.2832-4-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-add-missing-annotation-for-dlm_empty_lockres
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2760,6 +2760,7 @@ leave:
  * Returns: 1 if dlm->spinlock was dropped/retaken, 0 if never dropped
  */
 int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
+	__must_hold(&dlm->spinlock)
 {
 	int ret;
 	int lock_dropped = 0;
_

Patches currently in -mm which might be from jbi.octave@gmail.com are

ipc-msg-add-missing-annotation-for-freeque.patch
