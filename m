From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch
 removed from -mm tree
Date: Fri, 03 Oct 2014 11:04:13 -0700
Message-ID: <542ee51d.15t7BUTnNjilq8Cv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbaJCSEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2014 14:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: should put mle when goto kill in dlm_assert_master_handler
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2039,6 +2039,10 @@ kill:
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

origin.patch
ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt.patch
ocfs2-fix-shift-left-operations-overflow.patch
ocfs2-dlm-call-dlm_lockres_put-without-resource-spinlock.patch
ocfs2-fix-deadlock-due-to-wrong-locking-order.patch
ocfs2-fix-deadlock-due-to-wrong-locking-order-fix.patch

