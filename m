From: akpm@linux-foundation.org
Subject: + ocfs2-remove-dlm_lock_is_remote.patch added to -mm tree
Date: Wed, 19 Feb 2020 16:07:35 -0800
Message-ID: <20200220000735.FLSeC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgBTAHg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 19:07:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn, alex.shi@linux.alibaba.com


The patch titled
     Subject: ocfs2: remove dlm_lock_is_remote
has been added to the -mm tree.  Its filename is
     ocfs2-remove-dlm_lock_is_remote.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-dlm_lock_is_remote.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-dlm_lock_is_remote.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
