From: akpm@linux-foundation.org
Subject: - cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:06 -0700
Message-ID: <200804300542.m3U5g6gK029117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760549AbYD3GMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, cpw@sgi.com, harvey.harrison@gmail.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup: fix sparse warning of shadow symbol in cgroup.c
has been removed from the -mm tree.  Its filename was
     cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup: fix sparse warning of shadow symbol in cgroup.c
From: Paul Jackson <pj@sgi.com>

Fix a code warning: symbol 'p' shadows an earlier one

This is a reincarnation of Harvey Harrison's patch:
	cpuset: sparse warnings in cpuset.c

Independently, Cliff Wickman moved the affected code,
from kernel/cpuset.c to kernel/cgroup.c, in his patch:
	cpusets: update_cpumask revision

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Cliff Wickman <cpw@sgi.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/cgroup.c~cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc
+++ a/kernel/cgroup.c
@@ -1913,14 +1913,14 @@ int cgroup_scan_tasks(struct cgroup_scan
 
 	if (heap->size) {
 		for (i = 0; i < heap->size; i++) {
-			struct task_struct *p = heap->ptrs[i];
+			struct task_struct *q = heap->ptrs[i];
 			if (i == 0) {
-				latest_time = p->start_time;
-				latest_task = p;
+				latest_time = q->start_time;
+				latest_task = q;
 			}
 			/* Process the task per the caller's callback */
-			scan->process_task(p, scan);
-			put_task_struct(p);
+			scan->process_task(q, scan);
+			put_task_struct(q);
 		}
 		/*
 		 * If we had to process any tasks at all, scan again
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
git-sched.patch

