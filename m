From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch added to -mm tree
Date: Tue, 11 Feb 2014 12:48:09 -0800
Message-ID: <52fa8c89.nX6IxKEiNwnTcTZ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaBKUsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 15:48:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, wangzongxun@huawei.com

Subject: + ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch added to -mm tree
To: wangzongxun@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 12:48:09 -0800


The patch titled
     Subject: ocfs2: fix null pointer dereference when access dlm_state before launching dlm thread
has been added to the -mm tree.  Its filename is
     ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zongxun Wang <wangzongxun@huawei.com>
Subject: ocfs2: fix null pointer dereference when access dlm_state before launching dlm thread

When mounting an ocfs2 volume, it will firstly generate a file
/sys/kernel/debug/o2dlm/<uuid>/dlm_state, and then launch the dlm thread. 
So the following situation will cause a null pointer dereference. 
dlm_debug_init -> access file dlm_state which will call dlm_state_print ->
dlm_launch_thread

Move dlm_debug_init after dlm_launch_thread and dlm_launch_recovery_thread
can fix this issue.

Signed-off-by: Zongxun Wang <wangzongxun@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1877,19 +1877,19 @@ static int dlm_join_domain(struct dlm_ct
 		goto bail;
 	}
 
-	status = dlm_debug_init(dlm);
+	status = dlm_launch_thread(dlm);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	status = dlm_launch_thread(dlm);
+	status = dlm_launch_recovery_thread(dlm);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	status = dlm_launch_recovery_thread(dlm);
+	status = dlm_debug_init(dlm);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
_

Patches currently in -mm which might be from wangzongxun@huawei.com are

ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch

