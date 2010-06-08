From: akpm@linux-foundation.org
Subject: + oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch added to -mm tree
Date: Tue, 08 Jun 2010 12:42:53 -0700
Message-ID: <201006081942.o58JgsrW021043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675Ab0FHTnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 15:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     oom: introduce find_lock_task_mm() to fix !mm false positives
has been added to the -mm tree.  Its filename is
     oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch

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
Subject: oom: introduce find_lock_task_mm() to fix !mm false positives
From: Oleg Nesterov <oleg@redhat.com>

Almost all ->mm == NULL checks in oom_kill.c are wrong.

The current code assumes that the task without ->mm has already released
its memory and ignores the process.  However this is not necessarily true
when this process is multithreaded, other live sub-threads can use this
->mm.

- Remove the "if (!p->mm)" check in select_bad_process(), it is
  just wrong.

- Add the new helper, find_lock_task_mm(), which finds the live
  thread which uses the memory and takes task_lock() to pin ->mm

- change oom_badness() to use this helper instead of just checking
  ->mm != NULL.

- As David pointed out, select_bad_process() must never choose the
  task without ->mm, but no matter what oom_badness() returns the
  task can be chosen if nothing else has been found yet.

  Change oom_badness() to return int, change it to return -1 if
  find_lock_task_mm() fails, and change select_bad_process() to
  check points >= 0.

Note! This patch is not enough, we need more changes.

	- oom_badness() was fixed, but oom_kill_task() still ignores
	  the task without ->mm

	- oom_forkbomb_penalty() should use find_lock_task_mm() too,
	  and it also needs other changes to actually find the first
	  first-descendant children

This will be addressed later.

[kosaki.motohiro@jp.fujitsu.com: use in badness(), __oom_kill_task()]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   74 +++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 31 deletions(-)

diff -puN mm/oom_kill.c~oom-introduce-find_lock_task_mm-to-fix-mm-false-positives mm/oom_kill.c
--- a/mm/oom_kill.c~oom-introduce-find_lock_task_mm-to-fix-mm-false-positives
+++ a/mm/oom_kill.c
@@ -52,6 +52,20 @@ static int has_intersects_mems_allowed(s
 	return 0;
 }
 
+static struct task_struct *find_lock_task_mm(struct task_struct *p)
+{
+	struct task_struct *t = p;
+
+	do {
+		task_lock(t);
+		if (likely(t->mm))
+			return t;
+		task_unlock(t);
+	} while_each_thread(p, t);
+
+	return NULL;
+}
+
 /**
  * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
@@ -74,8 +88,8 @@ static int has_intersects_mems_allowed(s
 unsigned long badness(struct task_struct *p, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time;
-	struct mm_struct *mm;
 	struct task_struct *child;
+	struct task_struct *c, *t;
 	int oom_adj = p->signal->oom_adj;
 	struct task_cputime task_time;
 	unsigned long utime;
@@ -84,17 +98,14 @@ unsigned long badness(struct task_struct
 	if (oom_adj == OOM_DISABLE)
 		return 0;
 
-	task_lock(p);
-	mm = p->mm;
-	if (!mm) {
-		task_unlock(p);
+	p = find_lock_task_mm(p);
+	if (!p)
 		return 0;
-	}
 
 	/*
 	 * The memory size of the process is the basis for the badness.
 	 */
-	points = mm->total_vm;
+	points = p->mm->total_vm;
 
 	/*
 	 * After this unlock we can no longer dereference local variable `mm'
@@ -115,12 +126,17 @@ unsigned long badness(struct task_struct
 	 * child is eating the vast majority of memory, adding only half
 	 * to the parents will make the child our kill candidate of choice.
 	 */
-	list_for_each_entry(child, &p->children, sibling) {
-		task_lock(child);
-		if (child->mm != mm && child->mm)
-			points += child->mm->total_vm/2 + 1;
-		task_unlock(child);
-	}
+	t = p;
+	do {
+		list_for_each_entry(c, &t->children, sibling) {
+			child = find_lock_task_mm(c);
+			if (child) {
+				if (child->mm != p->mm)
+					points += child->mm->total_vm/2 + 1;
+				task_unlock(child);
+			}
+		}
+	} while_each_thread(p, t);
 
 	/*
 	 * CPU time is in tens of seconds and run time is in thousands
@@ -256,9 +272,6 @@ static struct task_struct *select_bad_pr
 	for_each_process(p) {
 		unsigned long points;
 
-		/* skip tasks that have already released their mm */
-		if (!p->mm)
-			continue;
 		/* skip the init task and kthreads */
 		if (is_global_init(p) || (p->flags & PF_KTHREAD))
 			continue;
@@ -385,14 +398,9 @@ static void __oom_kill_task(struct task_
 		return;
 	}
 
-	task_lock(p);
-	if (!p->mm) {
-		WARN_ON(1);
-		printk(KERN_WARNING "tried to kill an mm-less task %d (%s)!\n",
-			task_pid_nr(p), p->comm);
-		task_unlock(p);
+	p = find_lock_task_mm(p);
+	if (!p)
 		return;
-	}
 
 	if (verbose)
 		printk(KERN_ERR "Killed process %d (%s) "
@@ -437,6 +445,7 @@ static int oom_kill_process(struct task_
 			    const char *message)
 {
 	struct task_struct *c;
+	struct task_struct *t = p;
 
 	if (printk_ratelimit())
 		dump_header(p, gfp_mask, order, mem);
@@ -454,14 +463,17 @@ static int oom_kill_process(struct task_
 					message, task_pid_nr(p), p->comm, points);
 
 	/* Try to kill a child first */
-	list_for_each_entry(c, &p->children, sibling) {
-		if (c->mm == p->mm)
-			continue;
-		if (mem && !task_in_mem_cgroup(c, mem))
-			continue;
-		if (!oom_kill_task(c))
-			return 0;
-	}
+	do {
+		list_for_each_entry(c, &t->children, sibling) {
+			if (c->mm == p->mm)
+				continue;
+			if (mem && !task_in_mem_cgroup(c, mem))
+				continue;
+			if (!oom_kill_task(c))
+				return 0;
+		}
+	} while_each_thread(p, t);
+
 	return oom_kill_task(p);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch

