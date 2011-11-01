From: akpm@linux-foundation.org
Subject: [merged] oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:17 -0700
Message-ID: <201111012108.pA1L8HAI011404@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15369 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab1KAVJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: avoid killing kthreads if they assume the oom killed thread's mm
has been removed from the -mm tree.  Its filename was
     oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: oom: avoid killing kthreads if they assume the oom killed thread's mm

After selecting a task to kill, the oom killer iterates all processes and
kills all other threads that share the same mm_struct in different thread
groups.  It would not otherwise be helpful to kill a thread if its memory
would not be subsequently freed.

A kernel thread, however, may assume a user thread's mm by using
use_mm().  This is only temporary and should not result in sending a
SIGKILL to that kthread.

This patch ensures that only user threads and not kthreads are sent a
SIGKILL if they share the same mm_struct as the oom killed task.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm
+++ a/mm/oom_kill.c
@@ -439,7 +439,7 @@ static int oom_kill_task(struct task_str
 	task_unlock(p);
 
 	/*
-	 * Kill all processes sharing p->mm in other thread groups, if any.
+	 * Kill all user processes sharing p->mm in other thread groups, if any.
 	 * They don't get access to memory reserves or a higher scheduler
 	 * priority, though, to avoid depletion of all memory or task
 	 * starvation.  This prevents mm->mmap_sem livelock when an oom killed
@@ -449,7 +449,8 @@ static int oom_kill_task(struct task_str
 	 * signal.
 	 */
 	for_each_process(q)
-		if (q->mm == mm && !same_thread_group(q, p)) {
+		if (q->mm == mm && !same_thread_group(q, p) &&
+		    !(q->flags & PF_KTHREAD)) {
 			task_lock(q);	/* Protect ->comm from prctl() */
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(q), q->comm);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch
cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch

