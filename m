From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-dlm_lock_is_remote.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:35:08 -0700
Message-ID: <20200403203508.T2Fp4HGVd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUfK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: remove dlm_lock_is_remote
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-dlm_lock_is_remote.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: ocfs2: remove dlm_lock_is_remote

This macro has been unused since it was introduced.

Link: http://lkml.kernel.org/r/1579578203-254451-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmthread.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-remove-dlm_lock_is_remote
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -39,8 +39,6 @@
 static int dlm_thread(void *data);
 static void dlm_flush_asts(struct dlm_ctxt *dlm);
 
-#define dlm_lock_is_remote(dlm, lock)     ((lock)->ml.node != (dlm)->node_num)
