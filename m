From: akpm@linux-foundation.org
Subject: [merged] pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:22 -0700
Message-ID: <200904061936.n36JaMub012430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbZDFTlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, Louis.Rilling@kerlabs.com, ebiederm@xmission.com, roland@redhat.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pids: document task_pgrp/task_session is not safe without tasklist/rcu
has been removed from the -mm tree.  Its filename was
     pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: document task_pgrp/task_session is not safe without tasklist/rcu
From: Oleg Nesterov <oleg@redhat.com>

Even if task == current, it is not safe to dereference the result of
task_pgrp/task_session.  We can race with another thread which changes the
special pid via setpgid/setsid.

Document this.  The next 2 patches give an example of the unsafe usage, we
have more bad users.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/sched.h~pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu include/linux/sched.h
--- a/include/linux/sched.h~pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu
+++ a/include/linux/sched.h
@@ -1489,6 +1489,11 @@ static inline struct pid *task_tgid(stru
 	return task->group_leader->pids[PIDTYPE_PID].pid;
 }
 
+/*
+ * Without tasklist or rcu lock it is not safe to dereference
+ * the result of task_pgrp/task_session even if task == current,
+ * we can race with another thread doing sys_setsid/sys_setpgid.
+ */
 static inline struct pid *task_pgrp(struct task_struct *task)
 {
 	return task->group_leader->pids[PIDTYPE_PGID].pid;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

