From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:02:41 -0700
Message-ID: <53e3db61.ljKrscMeSukYMN8m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:54833 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUCm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:42 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so611440ykb.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove conversion of total_backoff in dlm_join_domain()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: remove conversion of total_backoff in dlm_join_domain()

The unit of total_backoff is msecs not jiffies, so no need to do the
conversion.  Otherwise, the join timeout is not 90 sec.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-convertion-of-total_backoff-in-dlm_join_domain
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1923,12 +1923,11 @@ static int dlm_join_domain(struct dlm_ct
 				goto bail;
 			}
 
-			if (total_backoff >
-			    msecs_to_jiffies(DLM_JOIN_TIMEOUT_MSECS)) {
+			if (total_backoff > DLM_JOIN_TIMEOUT_MSECS) {
 				status = -ERESTARTSYS;
 				mlog(ML_NOTICE, "Timed out joining dlm domain "
 				     "%s after %u msecs\n", dlm->name,
-				     jiffies_to_msecs(total_backoff));
+				     total_backoff);
 				goto bail;
 			}
 
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

