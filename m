From: akpm@linux-foundation.org
Subject: + pidns-use-task_active_pid_ns-in-do_notify_parent.patch added to -mm tree
Date: Tue, 08 May 2012 15:51:38 -0700
Message-ID: <20120508225139.38937A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:44732 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2EHWvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:51:40 -0400
Received: by yhgm50 with SMTP id m50so848526yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:51:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, efault@gmx.de, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: pidns: use task_active_pid_ns in do_notify_parent
has been added to the -mm tree.  Its filename is
     pidns-use-task_active_pid_ns-in-do_notify_parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1666,19 +1666,18 @@ bool do_notify_parent(struct task_struct
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
 	info.si_uid = map_cred_ns(__task_cred(tsk),
 			task_cred_xxx(tsk->parent, user_ns));
 	rcu_read_unlock();
_
Subject: Subject: pidns: use task_active_pid_ns in do_notify_parent

Patches currently in -mm which might be from ebiederm@xmission.com are

linux-next.patch
namespaces-fix-leak-on-fork-failure.patch
connector-userns-replace-netlink-uses-of-cap_raised-with-capable.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped.patch
pidns-make-killed-children-autoreap.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

