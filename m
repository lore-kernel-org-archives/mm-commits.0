From: akpm@linux-foundation.org
Subject: + oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:22:16 -0700
Message-ID: <201003222022.o2MKMGbW025257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905Ab0CVUXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: avoid race for oom killed tasks detaching mm prior to exit
has been added to the -mm tree.  Its filename is
     oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch

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
Subject: oom: avoid race for oom killed tasks detaching mm prior to exit
From: David Rientjes <rientjes@google.com>

Tasks detach its ->mm prior to exiting so it's possible that in progress
oom kills or already exiting tasks may be missed during the oom killer's
tasklist scan.  When an eligible task is found with either TIF_MEMDIE or
PF_EXITING set, the oom killer is supposed to be a no-op to avoid
needlessly killing additional tasks.  This closes the race between a task
detaching its ->mm and being removed from the tasklist.

Out of memory conditions as the result of memory controllers will
automatically filter tasks that have detached their ->mm (since
task_in_mem_cgroup() will return 0).  This is acceptable, however, since
memcg constrained ooms aren't the result of a lack of memory resources but
rather a limit imposed by userspace that requires a task be killed
regardless.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit
+++ a/mm/oom_kill.c
@@ -290,12 +290,6 @@ static struct task_struct *select_bad_pr
 	for_each_process(p) {
 		unsigned int points;
 
-		/*
-		 * skip kernel threads and tasks which have already released
-		 * their mm.
-		 */
-		if (!p->mm)
-			continue;
 		/* skip the init task */
 		if (is_global_init(p))
 			continue;
@@ -336,6 +330,12 @@ static struct task_struct *select_bad_pr
 			*ppoints = 1000;
 		}
 
+		/*
+		 * skip kernel threads and tasks which have already released
+		 * their mm.
+		 */
+		if (!p->mm)
+			continue;
 		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 			continue;
 
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
cpuset-alloc-nodemask_t-on-the-heap-rather-than-the-stack.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

