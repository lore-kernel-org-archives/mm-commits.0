From: akpm@linux-foundation.org
Subject: + cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch added to -mm tree
Date: Fri, 26 Aug 2011 12:27:15 -0700
Message-ID: <201108261927.p7QJRFbw006954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140Ab1HZT12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bblum@andrew.cmu.edu, fweisbec@gmail.com, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, tj@kernel.org


The patch titled
     cgroups: don't attach task to subsystem if migration failed
has been added to the -mm tree.  Its filename is
     cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: don't attach task to subsystem if migration failed
From: Ben Blum <bblum@andrew.cmu.edu>

If a task has exited to the point it has called cgroup_exit() already,
then we can't migrate it to another cgroup anymore.

This can happen when we are attaching a task to a new cgroup between the
call to ->can_attach_task() on subsystems and the migration that is
eventually tried in cgroup_task_migrate().

In this case cgroup_task_migrate() returns -ESRCH and we don't want to
attach the task to the subsystems because the attachment to the new cgroup
itself failed.

Fix this by only calling ->attach_task() on the subsystems if the cgroup
migration succeeded.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-ordering-of-calls-in-cgroup_attach_proc kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-ordering-of-calls-in-cgroup_attach_proc
+++ a/kernel/cgroup.c
@@ -2135,14 +2135,17 @@ int cgroup_attach_proc(struct cgroup *cg
 		oldcgrp = task_cgroup_from_root(tsk, root);
 		if (cgrp == oldcgrp)
 			continue;
-		/* attach each task to each subsystem */
-		for_each_subsys(root, ss) {
-			if (ss->attach_task)
-				ss->attach_task(cgrp, tsk);
-		}
 		/* if the thread is PF_EXITING, it can just get skipped. */
 		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
-		BUG_ON(retval != 0 && retval != -ESRCH);
+		if (retval == 0) {
+			/* attach each task to each subsystem */
+			for_each_subsys(root, ss) {
+				if (ss->attach_task)
+					ss->attach_task(cgrp, tsk);
+			}
+		} else {
+			BUG_ON(retval != -ESRCH);
+		}
 	}
 	/* nothing is sensitive to fork() after this point. */
 
_

Patches currently in -mm which might be from bblum@andrew.cmu.edu are

cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
cgroups-dont-attach-task-to-subsystem-if-migration-failed.patch

