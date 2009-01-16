From: akpm@linux-foundation.org
Subject: + pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:21:57 -0800
Message-ID: <200901162221.n0GMLwdc010518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932377AbZAPWWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:22:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, Louis.Rilling@kerlabs.com, ebiederm@xmission.com, roland@redhat.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     pids: document task_pgrp/task_session is not safe without tasklist/rcu
has been added to the -mm tree.  Its filename is
     pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch

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
Subject: pids: document task_pgrp/task_session is not safe without tasklist/rcu
From: Oleg Nesterov <oleg@redhat.com>

Even if task == current, it is not safe to dereference the result of
task_pgrp/task_session.  We can race with another thread which changes the
special pid via setpgid/setsid.

Document this.  The next 2 patches give an example of the unsafe usage, we
have more bad users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/sched.h~pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu include/linux/sched.h
--- a/include/linux/sched.h~pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu
+++ a/include/linux/sched.h
@@ -1449,6 +1449,13 @@ static inline struct pid *task_tgid(stru
 	return task->group_leader->pids[PIDTYPE_PID].pid;
 }
 
+/*
+ * Without tasklist or rcu lock it is not safe to dereference
+ * the result of task_pgrp/task_session even if task == current,
+ * we can race with another thread doing sys_setsid/sys_setpgid.
+ *
+ */
+
 static inline struct pid *task_pgrp(struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_PGID].pid;
_

Patches currently in -mm which might be from oleg@redhat.com are

getrusage-fill-ru_maxrss-value.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch

