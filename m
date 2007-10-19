From: akpm@linux-foundation.org
Subject: - use-task_pid_nr-instead-of-pid_nrtask_pid.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:22 -0700
Message-ID: <200710192253.l9JMrMCW024421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299AbXJSXFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, menage@google.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Use task_pid_nr() instead of pid_nr(task_pid())
has been removed from the -mm tree.  Its filename was
     use-task_pid_nr-instead-of-pid_nrtask_pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use task_pid_nr() instead of pid_nr(task_pid())
From: Pavel Emelyanov <xemul@openvz.org>

There are two places that do so - the cgroups subsystem and the autofs
code.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Ian Kent <raven@themaw.net>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/root.c |    2 +-
 kernel/cgroup.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/autofs/root.c~use-task_pid_nr-instead-of-pid_nrtask_pid fs/autofs/root.c
--- a/fs/autofs/root.c~use-task_pid_nr-instead-of-pid_nrtask_pid
+++ a/fs/autofs/root.c
@@ -214,7 +214,7 @@ static struct dentry *autofs_root_lookup
 
 	oz_mode = autofs_oz_mode(sbi);
 	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
-				"oz_mode = %d\n", pid_nr(task_pid(current)),
+				"oz_mode = %d\n", task_pid_nr(current),
 				task_pgrp_nr(current), sbi->catatonic,
 				oz_mode));
 
diff -puN kernel/cgroup.c~use-task_pid_nr-instead-of-pid_nrtask_pid kernel/cgroup.c
--- a/kernel/cgroup.c~use-task_pid_nr-instead-of-pid_nrtask_pid
+++ a/kernel/cgroup.c
@@ -1763,7 +1763,7 @@ static int pid_array_load(pid_t *pidarra
 	while ((tsk = cgroup_iter_next(cont, &it))) {
 		if (unlikely(n == npids))
 			break;
-		pidarray[n++] = pid_nr(task_pid(tsk));
+		pidarray[n++] = task_pid_nr(tsk);
 	}
 	cgroup_iter_end(cont, &it);
 	return n;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
