From: akpm@linux-foundation.org
Subject: [merged] namespaces-fix-leak-on-fork-failure.patch removed from -mm tree
Date: Wed, 16 May 2012 11:46:53 -0700
Message-ID: <20120516184653.8A65FA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:32966 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab2EPSqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:46:55 -0400
Received: by qcsp5 with SMTP id p5so126689qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:46:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, ebiederm@xmission.com, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, stable@vger.kernel.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: namespaces, pid_ns: fix leakage on fork() failure
has been removed from the -mm tree.  Its filename was
     namespaces-fix-leak-on-fork-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mike Galbraith <efault@gmx.de>
Subject: namespaces, pid_ns: fix leakage on fork() failure

Fork() failure post namespace creation for a child cloned with
CLONE_NEWPID leaks pid_namespace/mnt_cache due to proc being mounted
during creation, but not unmounted during cleanup.  Call
pid_ns_release_proc() during cleanup.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/fork.c~namespaces-fix-leak-on-fork-failure kernel/fork.c
--- a/kernel/fork.c~namespaces-fix-leak-on-fork-failure
+++ a/kernel/fork.c
@@ -47,6 +47,7 @@
 #include <linux/audit.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
+#include <linux/proc_fs.h>
 #include <linux/profile.h>
 #include <linux/rmap.h>
 #include <linux/ksm.h>
@@ -1464,6 +1465,8 @@ bad_fork_cleanup_io:
 	if (p->io_context)
 		exit_io_context(p);
 bad_fork_cleanup_namespaces:
+	if (unlikely(clone_flags & CLONE_NEWPID))
+		pid_ns_release_proc(p->nsproxy->pid_ns);
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
 	if (p->mm)
_

Patches currently in -mm which might be from efault@gmx.de are

linux-next.patch
ipc-semc-alternatives-to-preempt_disable.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped.patch
pidns-make-killed-children-autoreap.patch

