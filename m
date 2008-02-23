From: akpm@linux-foundation.org
Subject: + cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch added to -mm tree
Date: Sat, 23 Feb 2008 10:50:05 -0800
Message-ID: <200802231850.m1NIo5ga010075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755014AbYBWSuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 13:50:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, cpw@sgi.com, harvey.harrison@gmail.com, menage@google.com


The patch titled
     cgroup: fix sparse warning of shadow symbol in cgroup.c
has been added to the -mm tree.  Its filename is
     cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1900,14 +1900,14 @@ int cgroup_scan_tasks(struct cgroup_scan
 
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

cpuset-trivial-documentation-fix-s-n_memory-n_high_memory.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
kernel-cpusetc-make-3-functions-static.patch
documentation-patch-tags-one-more-time.patch
