From: akpm@linux-foundation.org
Subject: + proc-fix-races-against-execve-of-proc-pid-fd-fix.patch added to -mm tree
Date: Fri, 02 Sep 2011 15:21:13 -0700
Message-ID: <201109022221.p82MLDYS013607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab1IBWVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 18:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, gorcunov@gmail.com, segoon@openwall.com


The patch titled
     proc-fix-races-against-execve-of-proc-pid-fd-fix
has been added to the -mm tree.  Its filename is
     proc-fix-races-against-execve-of-proc-pid-fd-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-fix-races-against-execve-of-proc-pid-fd-fix
From: Vasiliy Kulikov <segooon@gmail.com>

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
@@ -1681,9 +1681,9 @@ static int proc_pid_fd_link_getattr(stru
 
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

proc-fix-races-against-execve-of-proc-pid-fd-fix.patch

