From: akpm@linux-foundation.org
Subject: [folded] proc-fix-races-against-execve-of-proc-pid-fd-fix.patch removed from -mm tree
Date: Wed, 02 Nov 2011 13:16:44 -0700
Message-ID: <201111022016.pA2KGjfw008961@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:39147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1KBURE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2011 16:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segooon@gmail.com, gorcunov@gmail.com, segoon@openwall.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-fix-races-against-execve-of-proc-pid-fd-fix
has been removed from the -mm tree.  Its filename was
     proc-fix-races-against-execve-of-proc-pid-fd-fix.patch

This patch was dropped because it was folded into proc-fix-races-against-execve-of-proc-pid-fd.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vasiliy Kulikov <segooon@gmail.com>
Subject: proc-fix-races-against-execve-of-proc-pid-fd-fix

In the patch "proc: fix races against execve() of /proc/PID/fd**"
proc_pid_fd_link_getattr() leaked task_struct if ptrace check fails.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-fix-races-against-execve-of-proc-pid-fd-fix fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-races-against-execve-of-proc-pid-fd-fix
+++ a/fs/proc/base.c
@@ -1668,9 +1668,9 @@ static int proc_pid_fd_link_getattr(stru
 
 	generic_fillattr(inode, stat);
 	unlock_trace(task);
-	put_task_struct(task);
 	rc = 0;
 out_task:
+	put_task_struct(task);
 	return rc;
 }
 
_

Patches currently in -mm which might be from segooon@gmail.com are

proc-fix-races-against-execve-of-proc-pid-fd.patch

