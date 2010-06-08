From: akpm@linux-foundation.org
Subject: + oom-sacrifice-child-with-highest-badness-score-for-parent.patch added to -mm tree
Date: Tue, 08 Jun 2010 13:34:07 -0700
Message-ID: <201006082034.o58KY7R7023283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756368Ab0FHUea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 16:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: sacrifice child with highest badness score for parent
has been added to the -mm tree.  Its filename is
     oom-sacrifice-child-with-highest-badness-score-for-parent.patch

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
Subject: oom: sacrifice child with highest badness score for parent
From: David Rientjes <rientjes@google.com>

When a task is chosen for oom kill, the oom killer first attempts to
sacrifice a child not sharing its parent's memory instead.  Unfortunately,
this often kills in a seemingly random fashion based on the ordering of
the selected task's child list.  Additionally, it is not guaranteed at all
to free a large amount of memory that we need to prevent additional oom
killing in the very near future.

Instead, we now only attempt to sacrifice the worst child not sharing its
parent's memory, if one exists.  The worst child is indicated with the
highest badness() score.  This serves two advantages: we kill a
memory-hogging task more often, and we allow the configurable
/proc/pid/oom_adj value to be considered as a factor in which child to
kill.

Reviewers may observe that the previous implementation would iterate
through the children and attempt to kill each until one was successful and
then the parent if none were found while the new code simply kills the
most memory-hogging task or the parent.  Note that the only time
oom_kill_task() fails, however, is when a child does not have an mm or has
a /proc/pid/oom_adj of OOM_DISABLE.  badness() returns 0 for both cases,
so the final oom_kill_task() will always succeed.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~oom-sacrifice-child-with-highest-badness-score-for-parent mm/oom_kill.c
--- a/mm/oom_kill.c~oom-sacrifice-child-with-highest-badness-score-for-parent
+++ a/mm/oom_kill.c
@@ -441,8 +441,11 @@ static int oom_kill_process(struct task_
 			    unsigned long points, struct mem_cgroup *mem,
 			    const char *message)
 {
+	struct task_struct *victim = p;
 	struct task_struct *c;
 	struct task_struct *t = p;
+	unsigned long victim_points = 0;
+	struct timespec uptime;
 
 	if (printk_ratelimit())
 		dump_header(p, gfp_mask, order, mem);
@@ -456,22 +459,30 @@ static int oom_kill_process(struct task_
 		return 0;
 	}
 
-	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
-					message, task_pid_nr(p), p->comm, points);
+	pr_err("%s: Kill process %d (%s) score %lu or sacrifice child\n",
+		message, task_pid_nr(p), p->comm, points);
 
-	/* Try to kill a child first */
+	/* Try to sacrifice the worst child first */
+	do_posix_clock_monotonic_gettime(&uptime);
 	do {
+		unsigned long cpoints;
+
 		list_for_each_entry(c, &t->children, sibling) {
 			if (c->mm == p->mm)
 				continue;
 			if (mem && !task_in_mem_cgroup(c, mem))
 				continue;
-			if (!oom_kill_task(c))
-				return 0;
+
+			/* badness() returns 0 if the thread is unkillable */
+			cpoints = badness(c, uptime.tv_sec);
+			if (cpoints > victim_points) {
+				victim = c;
+				victim_points = cpoints;
+			}
 		}
 	} while_each_thread(p, t);
 
-	return oom_kill_task(p);
+	return oom_kill_task(victim);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
_

Patches currently in -mm which might be from rientjes@google.com are

avr32-invoke-oom-killer-from-page-fault.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch

