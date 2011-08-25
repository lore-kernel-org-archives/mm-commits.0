From: akpm@linux-foundation.org
Subject: + cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch added to -mm tree
Date: Thu, 25 Aug 2011 13:44:36 -0700
Message-ID: <201108252044.p7PKiaHd006997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334Ab1HYUot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 16:44:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bblum@andrew.cmu.edu, fweisbec@gmail.com, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, tj@kernel.org


The patch titled
     cgroups: fix ordering of calls in cgroup_attach_proc
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
Subject: cgroups: fix ordering of calls in cgroup_attach_proc
From: Ben Blum <bblum@andrew.cmu.edu>

awaiting useful changelog...

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
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

