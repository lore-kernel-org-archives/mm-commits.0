From: akpm@linux-foundation.org
Subject: - cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:48 -0800
Message-ID: <200901082247.n08MlmZL027218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763297AbZAHWs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gowrishankar.m@in.ibm.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: skip processes from other namespaces when listing a cgroup
has been removed from the -mm tree.  Its filename was
     cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Gowrishankar M <gowrishankar.m@in.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup
+++ a/kernel/cgroup.c
@@ -2007,14 +2007,16 @@ int cgroup_scan_tasks(struct cgroup_scan
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
+		pid = task_pid_vnr(tsk);
+		if (pid > 0)
+			pidarray[n++] = pid;
 	}
 	cgroup_iter_end(cgrp, &it);
 	return n;
_

Patches currently in -mm which might be from gowrishankar.m@in.ibm.com are

origin.patch

