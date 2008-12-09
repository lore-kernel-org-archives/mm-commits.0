From: akpm@linux-foundation.org
Subject: + cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:19:52 -0800
Message-ID: <200812090019.mB90JqG4007869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbYLIAUB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:20:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gowrishankar.m@in.ibm.com, menage@google.com


The patch titled
     cgroups: skip processes from other namespaces when listing a cgroup
has been added to the -mm tree.  Its filename is
     cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch

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
Subject: cgroups: skip processes from other namespaces when listing a cgroup
From: Gowrishankar M <gowrishankar.m@in.ibm.com>

Once tasks are populated from system namespace inside cgroup, container
replaces other namespace task with 0 while listing tasks, inside
container.

Though this is expected behaviour from container end, there is no use of
showing unwanted 0s.

In this patch, we check if a process is in same namespace before loading
into pid array.

Signed-off-by: Gowrishankar M <gowrishankar.m@in.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup
+++ a/kernel/cgroup.c
@@ -2007,14 +2007,15 @@ int cgroup_scan_tasks(struct cgroup_scan
  */
 static int pid_array_load(pid_t *pidarray, int npids, struct cgroup *cgrp)
 {
-	int n = 0;
+	int n = 0, pid;
 	struct cgroup_iter it;
 	struct task_struct *tsk;
 	cgroup_iter_start(cgrp, &it);
 	while ((tsk = cgroup_iter_next(cgrp, &it))) {
 		if (unlikely(n == npids))
 			break;
-		pidarray[n++] = task_pid_vnr(tsk);
+		if ((pid = task_pid_vnr(tsk)) > 0)
+			pidarray[n++] = pid;
 	}
 	cgroup_iter_end(cgrp, &it);
 	return n;
_

Patches currently in -mm which might be from gowrishankar.m@in.ibm.com are

cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch

