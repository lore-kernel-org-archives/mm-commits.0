From: akpm@linux-foundation.org
Subject: - pidns-remove-now-unused-kill_proc-function.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:29 -0700
Message-ID: <200807252302.m6PN2TJC003828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755053AbYGYXGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pidns: remove now unused kill_proc function
has been removed from the -mm tree.  Its filename was
     pidns-remove-now-unused-kill_proc-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: remove now unused kill_proc function
From: Pavel Emelyanov <xemul@openvz.org>

This function operated on a pid_t to kill a task, which is no longer valid
in a containerized system.

It has finally lost all its users and we can safely remove it from the
tree.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 kernel/signal.c       |   12 ------------
 2 files changed, 13 deletions(-)

diff -puN include/linux/sched.h~pidns-remove-now-unused-kill_proc-function include/linux/sched.h
--- a/include/linux/sched.h~pidns-remove-now-unused-kill_proc-function
+++ a/include/linux/sched.h
@@ -1800,7 +1800,6 @@ extern void force_sig(int, struct task_s
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
 extern void zap_other_threads(struct task_struct *p);
-extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
diff -puN kernel/signal.c~pidns-remove-now-unused-kill_proc-function kernel/signal.c
--- a/kernel/signal.c~pidns-remove-now-unused-kill_proc-function
+++ a/kernel/signal.c
@@ -1228,17 +1228,6 @@ int kill_pid(struct pid *pid, int sig, i
 }
 EXPORT_SYMBOL(kill_pid);
 
-int
-kill_proc(pid_t pid, int sig, int priv)
-{
-	int ret;
-
-	rcu_read_lock();
-	ret = kill_pid_info(sig, __si_special(priv), find_pid(pid));
-	rcu_read_unlock();
-	return ret;
-}
-
 /*
  * These functions support sending signals using preallocated sigqueue
  * structures.  This is needed "because realtime applications cannot
@@ -1906,7 +1895,6 @@ EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
-EXPORT_SYMBOL(kill_proc);
 EXPORT_SYMBOL(ptrace_notify);
 EXPORT_SYMBOL(send_sig);
 EXPORT_SYMBOL(send_sig_info);
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

