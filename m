From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:57 -0700
Message-ID: <533f0835.58o/iIZukWZuvd4e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaDDT36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, wangzongxun@huawei.com

Subject: [merged] ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch removed from -mm tree
To: wangzongxun@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:57 -0700


The patch titled
     Subject: ocfs2: fix null pointer dereference when access dlm_state before launching dlm thread
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-when-access-dlm_state-before-launching-dlm-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

