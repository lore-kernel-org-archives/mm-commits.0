From: akpm@linux-foundation.org
Subject: + namespaces-fix-leak-on-fork-failure.patch added to -mm tree
Date: Tue, 01 May 2012 13:42:21 -0700
Message-ID: <20120501204222.14C32A020E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37928 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab2EAUmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 16:42:24 -0400
Received: by eaaq10 with SMTP id q10so214794eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 13:42:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: efault@gmx.de, ebiederm@xmission.com, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: namespaces, pid_ns: fix leakage on fork() failure
has been added to the -mm tree.  Its filename is
     namespaces-fix-leak-on-fork-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/fork.c~namespaces-fix-leak-on-fork-failure kernel/fork.c
--- a/kernel/fork.c~namespaces-fix-leak-on-fork-failure
+++ a/kernel/fork.c
@@ -48,6 +48,7 @@
 #include <linux/audit.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
+#include <linux/proc_fs.h>
 #include <linux/profile.h>
 #include <linux/rmap.h>
 #include <linux/ksm.h>
@@ -1475,6 +1476,8 @@ bad_fork_cleanup_io:
 	if (p->io_context)
 		exit_io_context(p);
 bad_fork_cleanup_namespaces:
+	if (unlikely(clone_flags & CLONE_NEWPID))
+		pid_ns_release_proc(p->nsproxy->pid_ns);
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
 	if (p->mm)
_
Subject: Subject: namespaces, pid_ns: fix leakage on fork() failure

Patches currently in -mm which might be from efault@gmx.de are

linux-next.patch
namespaces-fix-leak-on-fork-failure.patch
ipc-semc-alternatives-to-preempt_disable.patch

