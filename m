From: akpm@linux-foundation.org
Subject: + oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:16:34 -0700
Message-ID: <201008232316.o7NNGYLr020402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab0HWXQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:16:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, yinghan@google.com


The patch titled
     oom: kill all threads sharing oom killed task's mm
has been added to the -mm tree.  Its filename is
     oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch

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
Subject: oom: kill all threads sharing oom killed task's mm
From: David Rientjes <rientjes@google.com>

It's necessary to kill all threads that share an oom killed task's mm if
the goal is to lead to future memory freeing.

This patch reintroduces the code removed in 8c5cd6f3 (oom: oom_kill
doesn't kill vfork parent (or child)) since it is obsoleted.

It's now guaranteed that any task passed to oom_kill_task() does not share
an mm with any thread that is unkillable.  Thus, we're safe to issue a
SIGKILL to any thread sharing the same mm.

This is especially necessary to solve an mm->mmap_sem livelock issue
whereas an oom killed thread must acquire the lock in the exit path while
another thread is holding it in the page allocator while trying to
allocate memory itself (and will preempt the oom killer since a task was
already killed).  Since tasks with pending fatal signals are now granted
access to memory reserves, the thread holding the lock may quickly
allocate and release the lock so that the oom killed task may exit.

This mainly is for threads that are cloned with CLONE_VM but not
CLONE_THREAD, so they are in a different thread group.  Non-NPTL threads
exist in the wild and this change is necessary to prevent the livelock in
such cases.  We care more about preventing the livelock than incurring the
additional tasklist in the oom killer when a task has been killed. 
Systems that are sufficiently large to not want the tasklist scan in the
oom killer in the first place already have the option of enabling
/proc/sys/vm/oom_kill_allocating_task, which was designed specifically for
that purpose.

This code had existed in the oom killer for over eight years dating back
to the 2.4 kernel.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN mm/oom_kill.c~oom-kill-all-threads-sharing-oom-killed-tasks-mm mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-all-threads-sharing-oom-killed-tasks-mm
+++ a/mm/oom_kill.c
@@ -401,16 +401,38 @@ static void dump_header(struct task_stru
 #define K(x) ((x) << (PAGE_SHIFT-10))
 static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 {
+	struct task_struct *q;
+	struct mm_struct *mm;
+
 	p = find_lock_task_mm(p);
 	if (!p)
 		return 1;
 
+	/* mm cannot be safely dereferenced after task_unlock(p) */
+	mm = p->mm;
+
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		task_pid_nr(p), p->comm, K(p->mm->total_vm),
 		K(get_mm_counter(p->mm, MM_ANONPAGES)),
 		K(get_mm_counter(p->mm, MM_FILEPAGES)));
 	task_unlock(p);
 
+	/*
+	 * Kill all processes sharing p->mm in other thread groups, if any.
+	 * They don't get access to memory reserves or a higher scheduler
+	 * priority, though, to avoid depletion of all memory or task
+	 * starvation.  This prevents mm->mmap_sem livelock when an oom killed
+	 * task cannot exit because it requires the semaphore and its contended
+	 * by another thread trying to allocate memory itself.  That thread will
+	 * now get access to memory reserves since it has a pending fatal
+	 * signal.
+	 */
+	for_each_process(q)
+		if (q->mm == mm && !same_thread_group(q, p)) {
+			pr_err("Kill process %d (%s) sharing same memory\n",
+				task_pid_nr(q), q->comm);
+			force_sig(SIGKILL, q);
+		}
 
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 	force_sig(SIGKILL, p);
_

Patches currently in -mm which might be from rientjes@google.com are

fs-bio-integrityc-remove-dependency-on-__gfp_nofail.patch
fs-bio-integrityc-return-enomem-on-kmalloc-failure.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
jbd-remove-dependency-on-__gfp_nofail.patch

