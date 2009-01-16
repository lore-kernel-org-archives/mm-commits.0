From: akpm@linux-foundation.org
Subject: + pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:22:02 -0800
Message-ID: <200901162222.n0GMM2V7010600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932426AbZAPWWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:22:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, Louis.Rilling@kerlabs.com, ebiederm@xmission.com, roland@redhat.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     pids: improve get_task_pid() to fix the unsafe sys_wait4()->task_pgrp()
has been added to the -mm tree.  Its filename is
     pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch

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
Subject: pids: improve get_task_pid() to fix the unsafe sys_wait4()->task_pgrp()
From: Oleg Nesterov <oleg@redhat.com>

sys_wait4() does get_pid(task_pgrp(current)), this is not safe.  We can
add rcu lock/unlock around, but we already have get_task_pid() which can
be improved to handle the special pids in more reliable manner.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 kernel/pid.c  |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp kernel/exit.c
--- a/kernel/exit.c~pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp
+++ a/kernel/exit.c
@@ -1819,7 +1819,7 @@ SYSCALL_DEFINE4(wait4, pid_t, upid, int 
 		pid = find_get_pid(-upid);
 	} else if (upid == 0) {
 		type = PIDTYPE_PGID;
-		pid = get_pid(task_pgrp(current));
+		pid = get_task_pid(current, PIDTYPE_PGID);
 	} else /* upid > 0 */ {
 		type = PIDTYPE_PID;
 		pid = find_get_pid(upid);
diff -puN kernel/pid.c~pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp kernel/pid.c
--- a/kernel/pid.c~pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp
+++ a/kernel/pid.c
@@ -403,6 +403,8 @@ struct pid *get_task_pid(struct task_str
 {
 	struct pid *pid;
 	rcu_read_lock();
+	if (type != PIDTYPE_PID)
+		task = task->group_leader;
 	pid = get_pid(task->pids[type].pid);
 	rcu_read_unlock();
 	return pid;
_

Patches currently in -mm which might be from oleg@redhat.com are

getrusage-fill-ru_maxrss-value.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch

