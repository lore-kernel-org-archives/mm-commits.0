From: akpm@linux-foundation.org
Subject: [merged] pidns-use-task_active_pid_ns-in-do_notify_parent.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:35:08 -0700
Message-ID: <20120601193508.7009CA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:52866 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab2FATfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:35:09 -0400
Received: by yhgm50 with SMTP id m50so288149yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:35:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, efault@gmx.de, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: use task_active_pid_ns in do_notify_parent
has been removed from the -mm tree.  Its filename was
     pidns-use-task_active_pid_ns-in-do_notify_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Eric W. Biederman <ebiederm@xmission.com>
Subject: pidns: use task_active_pid_ns in do_notify_parent

Using task_active_pid_ns is more robust because it works even after we
have called exit_namespaces.  This change allows us to have parent
processes that are zombies.  Normally a zombie parent processes is crazy
and the last thing you would want to have but in the case of not letting
the init process of a pid namespace be reaped until all of it's children
are dead and reaped a zombie parent process is exactly what we want.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN kernel/signal.c~pidns-use-task_active_pid_ns-in-do_notify_parent kernel/signal.c
--- a/kernel/signal.c~pidns-use-task_active_pid_ns-in-do_notify_parent
+++ a/kernel/signal.c
@@ -1656,19 +1656,18 @@ bool do_notify_parent(struct task_struct
 	info.si_signo = sig;
 	info.si_errno = 0;
 	/*
-	 * we are under tasklist_lock here so our parent is tied to
-	 * us and cannot exit and release its namespace.
+	 * We are under tasklist_lock here so our parent is tied to
+	 * us and cannot change.
 	 *
-	 * the only it can is to switch its nsproxy with sys_unshare,
-	 * bu uncharing pid namespaces is not allowed, so we'll always
-	 * see relevant namespace
+	 * task_active_pid_ns will always return the same pid namespace
+	 * until a task passes through release_task.
 	 *
 	 * write_lock() currently calls preempt_disable() which is the
 	 * same as rcu_read_lock(), but according to Oleg, this is not
 	 * correct to rely on this
 	 */
 	rcu_read_lock();
-	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_pid = task_pid_nr_ns(tsk, task_active_pid_ns(tsk->parent));
 	info.si_uid = from_kuid_munged(task_cred_xxx(tsk->parent, user_ns),
 				       task_uid(tsk));
 	rcu_read_unlock();
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
pidns-make-killed-children-autoreap.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

