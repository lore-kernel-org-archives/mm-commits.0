From: akpm@linux-foundation.org
Subject: + pidns-make-killed-children-autoreap.patch added to -mm tree
Date: Tue, 08 May 2012 15:51:51 -0700
Message-ID: <20120508225151.EF1C6A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:58475 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2EHWvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:51:54 -0400
Received: by lbbgp10 with SMTP id gp10so345056lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:51:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, efault@gmx.de, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: pidns: make killed children autoreap
has been added to the -mm tree.  Its filename is
     pidns-make-killed-children-autoreap.patch

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
Subject: pidns: make killed children autoreap

Force SIGCHLD handling to SIG_IGN so that signals are not generated and so
that the children autoreap.  This increases the parallelize and in general
the speed of network namespace shutdown.

Note self reaping childrean can exist past zap_pid_ns_processess but they
will all be reaped before we allow the pid namespace init task with pid ==
1 to be reaped.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~pidns-make-killed-children-autoreap kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-make-killed-children-autoreap
+++ a/kernel/pid_namespace.c
@@ -149,7 +149,12 @@ void zap_pid_ns_processes(struct pid_nam
 {
 	int nr;
 	int rc;
-	struct task_struct *task;
+	struct task_struct *task, *me = current;
+
+	/* Ignore SIGCHLD causing any terminated children to autoreap */
+	spin_lock_irq(&me->sighand->siglock);
+	me->sighand->action[SIGCHLD -1].sa.sa_handler = SIG_IGN;
+	spin_unlock_irq(&me->sighand->siglock);
 
 	/*
 	 * The last thread in the cgroup-init thread group is terminating.
_
Subject: Subject: pidns: make killed children autoreap

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

