From: akpm@linux-foundation.org
Subject: - pids-introduce-change_pid-helper.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:21 -0700
Message-ID: <200805010931.m419VLJM030863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757671AbYEAJbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pids: introduce change_pid() helper
has been removed from the -mm tree.  Its filename was
     pids-introduce-change_pid-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: introduce change_pid() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Based on Eric W. Biederman's idea.

Without tasklist_lock held task_session()/task_pgrp() can return NULL if the
caller races with setprgp()/setsid() which does detach_pid() + attach_pid(). 
This can happen even if task == current.

Intoduce the new helper, change_pid(), which should be used instead.  This way
the caller always sees the special pid != NULL, either old or new.

Also change the prototype of attach_pid(), it always returns 0 and nobody
check the returned value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc:  "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    6 ++++--
 kernel/pid.c        |   21 ++++++++++++++++-----
 2 files changed, 20 insertions(+), 7 deletions(-)

diff -puN include/linux/pid.h~pids-introduce-change_pid-helper include/linux/pid.h
--- a/include/linux/pid.h~pids-introduce-change_pid-helper
+++ a/include/linux/pid.h
@@ -89,9 +89,11 @@ extern struct pid *get_task_pid(struct t
  * attach_pid() and detach_pid() must be called with the tasklist_lock
  * write-held.
  */
-extern int attach_pid(struct task_struct *task, enum pid_type type,
-		      struct pid *pid);
+extern void attach_pid(struct task_struct *task, enum pid_type type,
+			struct pid *pid);
 extern void detach_pid(struct task_struct *task, enum pid_type);
+extern void change_pid(struct task_struct *task, enum pid_type,
+			struct pid *pid);
 extern void transfer_pid(struct task_struct *old, struct task_struct *new,
 			 enum pid_type);
 
diff -puN kernel/pid.c~pids-introduce-change_pid-helper kernel/pid.c
--- a/kernel/pid.c~pids-introduce-change_pid-helper
+++ a/kernel/pid.c
@@ -317,7 +317,7 @@ EXPORT_SYMBOL_GPL(find_pid);
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
-int attach_pid(struct task_struct *task, enum pid_type type,
+void attach_pid(struct task_struct *task, enum pid_type type,
 		struct pid *pid)
 {
 	struct pid_link *link;
@@ -325,11 +325,10 @@ int attach_pid(struct task_struct *task,
 	link = &task->pids[type];
 	link->pid = pid;
 	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
-
-	return 0;
 }
 
-void detach_pid(struct task_struct *task, enum pid_type type)
+static void __change_pid(struct task_struct *task, enum pid_type type,
+			struct pid *new)
 {
 	struct pid_link *link;
 	struct pid *pid;
@@ -339,7 +338,7 @@ void detach_pid(struct task_struct *task
 	pid = link->pid;
 
 	hlist_del_rcu(&link->node);
-	link->pid = NULL;
+	link->pid = new;
 
 	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
 		if (!hlist_empty(&pid->tasks[tmp]))
@@ -348,6 +347,18 @@ void detach_pid(struct task_struct *task
 	free_pid(pid);
 }
 
+void detach_pid(struct task_struct *task, enum pid_type type)
+{
+	__change_pid(task, type, NULL);
+}
+
+void change_pid(struct task_struct *task, enum pid_type type,
+		struct pid *pid)
+{
+	__change_pid(task, type, pid);
+	attach_pid(task, type, pid);
+}
+
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
 void transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

