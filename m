From: akpm@linux-foundation.org
Subject: + cpuset-code-cleanup-for-started_after.patch added to -mm tree
Date: Wed, 16 Jul 2008 13:27:31 -0700
Message-ID: <200807162027.m6GKRV1V011434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbYGPU1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 16:27:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com


The patch titled
     cpuset: code-cleanup for started_after
has been added to the -mm tree.  Its filename is
     cpuset-code-cleanup-for-started_after.patch

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
Subject: cpuset: code-cleanup for started_after
From: Lai Jiangshan <laijs@cn.fujitsu.com>

cgroup(cgroup_scan_tasks) will initialize heap->gt for us.  This patch
removes started_after() and its helper-function.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff -puN kernel/cpuset.c~cpuset-code-cleanup-for-started_after kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-code-cleanup-for-started_after
+++ a/kernel/cpuset.c
@@ -709,36 +709,6 @@ done:
 	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
 }
 
-static inline int started_after_time(struct task_struct *t1,
-				     struct timespec *time,
-				     struct task_struct *t2)
-{
-	int start_diff = timespec_compare(&t1->start_time, time);
-	if (start_diff > 0) {
-		return 1;
-	} else if (start_diff < 0) {
-		return 0;
-	} else {
-		/*
-		 * Arbitrarily, if two processes started at the same
-		 * time, we'll say that the lower pointer value
-		 * started first. Note that t2 may have exited by now
-		 * so this may not be a valid pointer any longer, but
-		 * that's fine - it still serves to distinguish
-		 * between two tasks started (effectively)
-		 * simultaneously.
-		 */
-		return t1 > t2;
-	}
-}
-
-static inline int started_after(void *p1, void *p2)
-{
-	struct task_struct *t1 = p1;
-	struct task_struct *t2 = p2;
-	return started_after_time(t1, &t2->start_time, t2);
-}
-
 /**
  * cpuset_test_cpumask - test a task's cpus_allowed versus its cpuset's
  * @tsk: task to test
@@ -790,7 +760,12 @@ static int update_tasks_cpumask(struct c
 	struct ptr_heap heap;
 	int retval;
 
-	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
+	/*
+	 * cgroup_scan_tasks() will initialize heap->gt for us.
+	 * heap_init() is still needed here for we should not change
+	 * cs->cpus_allowed when heap_init() fails.
+	 */
+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
rcu-classic-update-qlen-when-cpu-offline.patch
cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains.patch
cpuset-code-cleanup-for-started_after.patch
cpuset-two-minor-code-cleanups.patch

