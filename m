From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch
 added to -mm tree
Date: Tue, 23 Sep 2014 15:43:27 -0700
Message-ID: <5421f78f.XQJQls8bMGcdD0Og%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaIWWn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 18:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: should put mle when goto kill in dlm_assert_master_handler
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2/dlm: should put mle when goto kill in dlm_assert_master_handler

In dlm_assert_master_handler, the mle is get in dlm_find_mle, should be
put when goto kill, otherwise, this mle will never be released.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2020,6 +2020,10 @@ kill:
 	     "and killing the other node now!  This node is OK and can continue.\n");
 	__dlm_print_one_lock_resource(res);
 	spin_unlock(&res->spinlock);
+	spin_lock(&dlm->master_lock);
+	if (mle)
+		__dlm_put_mle(mle);
+	spin_unlock(&dlm->master_lock);
 	spin_unlock(&dlm->spinlock);
 	*ret_data = (void *)res;
 	dlm_put(dlm);
_

Patches currently in -mm which might be from alex.chen@huawei.com are

ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch
ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt.patch
ocfs2-fix-shift-left-operations-overflow.patch

