From: akpm@linux-foundation.org
Subject: [merged] do_wait-wakeup-optimization-simplify-task_pid_type.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:17 -0700
Message-ID: <200909241935.n8OJZHtc032627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbZIXTfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait-wakeup-optimization: simplify task_pid_type()
has been removed from the -mm tree.  Its filename was
     do_wait-wakeup-optimization-simplify-task_pid_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait-wakeup-optimization: simplify task_pid_type()
From: Oleg Nesterov <oleg@redhat.com>

task_pid_type() is only used by eligible_pid() which has to check wo_type
!= PIDTYPE_MAX anyway.  Remove this check from task_pid_type() and factor
out ->pids[type] access, this shrinks .text a bit and simplifies the code.

The matches the behaviour of other similar helpers, say get_task_pid(). 
The caller must ensure that pid_type is valid, not the callee.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN kernel/exit.c~do_wait-wakeup-optimization-simplify-task_pid_type kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization-simplify-task_pid_type
+++ a/kernel/exit.c
@@ -1101,17 +1101,15 @@ struct wait_opts {
 	int			notask_error;
 };
 
-static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
+static inline
+struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
 {
-	struct pid *pid = NULL;
-	if (type == PIDTYPE_PID)
-		pid = task->pids[type].pid;
-	else if (type < PIDTYPE_MAX)
-		pid = task->group_leader->pids[type].pid;
-	return pid;
+	if (type != PIDTYPE_PID)
+		task = task->group_leader;
+	return task->pids[type].pid;
 }
 
-static inline int eligible_pid(struct wait_opts *wo, struct task_struct *p)
+static int eligible_pid(struct wait_opts *wo, struct task_struct *p)
 {
 	return	wo->wo_type == PIDTYPE_MAX ||
 		task_pid_type(p, wo->wo_type) == wo->wo_pid;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch

