From: akpm@linux-foundation.org
Subject: [merged] pidns-make-killed-children-autoreap.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:35:10 -0700
Message-ID: <20120601193510.6927FA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51315 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353Ab2FATfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:35:12 -0400
Received: by wibhn6 with SMTP id hn6so59969wib.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:35:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, efault@gmx.de, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: make killed children autoreap
has been removed from the -mm tree.  Its filename was
     pidns-make-killed-children-autoreap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Eric W. Biederman <ebiederm@xmission.com>
Subject: pidns: make killed children autoreap

Force SIGCHLD handling to SIG_IGN so that signals are not generated and so
that the children autoreap.  This increases the parallelize and in general
the speed of network namespace shutdown.

Note self reaping childrean can exist past zap_pid_ns_processess but they
will all be reaped before we allow the pid namespace init task with pid ==
1 to be reaped.

[akpm@linux-foundation.org: checkpatch fixes]
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
+	me->sighand->action[SIGCHLD - 1].sa.sa_handler = SIG_IGN;
+	spin_unlock_irq(&me->sighand->siglock);
 
 	/*
 	 * The last thread in the cgroup-init thread group is terminating.
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

