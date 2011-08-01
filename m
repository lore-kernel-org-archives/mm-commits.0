From: akpm@linux-foundation.org
Subject: + oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch added to -mm tree
Date: Mon, 01 Aug 2011 16:03:32 -0700
Message-ID: <201108012303.p71N3WmQ019905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab1HAXDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 19:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     oom: avoid killing kthreads if they assume the oom killed thread's mm
has been added to the -mm tree.  Its filename is
     oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch

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
Subject: oom: avoid killing kthreads if they assume the oom killed thread's mm
From: David Rientjes <rientjes@google.com>

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
@@ -433,7 +433,7 @@ static int oom_kill_task(struct task_str
 	task_unlock(p);
 
 	/*
-	 * Kill all processes sharing p->mm in other thread groups, if any.
+	 * Kill all user processes sharing p->mm in other thread groups, if any.
 	 * They don't get access to memory reserves or a higher scheduler
 	 * priority, though, to avoid depletion of all memory or task
 	 * starvation.  This prevents mm->mmap_sem livelock when an oom killed
@@ -443,7 +443,8 @@ static int oom_kill_task(struct task_str
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
acpi-remove-nid_inval.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch

