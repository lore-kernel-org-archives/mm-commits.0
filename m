From: akpm@linux-foundation.org
Subject: + oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch added to -mm tree
Date: Mon, 01 Jun 2009 22:57:08 -0700
Message-ID: <200906020557.n525v8Kj004317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757790AbZFBF60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 01:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, mel@csn.ul.ie, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: avoid unnecessary mm locking and scanning for OOM_DISABLE
has been added to the -mm tree.  Its filename is
     oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch

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
Subject: oom: avoid unnecessary mm locking and scanning for OOM_DISABLE
From: David Rientjes <rientjes@google.com>

This moves the check for OOM_DISABLE to the badness heuristic so it is
only necessary to hold task_lock() once.  If the mm is OOM_DISABLE, the
score is 0, which is also correctly exported via /proc/pid/oom_score. 
This requires that tasks with badness scores of 0 are prohibited from
being oom killed, which makes sense since they would not allow for future
memory freeing anyway.

Since the oom_adj value is a characteristic of an mm and not a task, it is
no longer necessary to check the oom_adj value for threads sharing the
same memory (except when simply issuing SIGKILLs for threads in other
thread groups).

Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   42 ++++++++++--------------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff -puN mm/oom_kill.c~oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable
+++ a/mm/oom_kill.c
@@ -67,6 +67,10 @@ unsigned long badness(struct task_struct
 		return 0;
 	}
 	oom_adj = mm->oom_adj;
+	if (oom_adj == OOM_DISABLE) {
+		task_unlock(p);
+		return 0;
+	}
 
 	/*
 	 * The memory size of the process is the basis for the badness.
@@ -253,15 +257,8 @@ static struct task_struct *select_bad_pr
 			*ppoints = ULONG_MAX;
 		}
 
-		task_lock(p);
-		if (p->mm && p->mm->oom_adj == OOM_DISABLE) {
-			task_unlock(p);
-			continue;
-		}
-		task_unlock(p);
-
 		points = badness(p, uptime.tv_sec);
-		if (points > *ppoints || !chosen) {
+		if (points > *ppoints) {
 			chosen = p;
 			*ppoints = points;
 		}
@@ -354,32 +351,13 @@ static int oom_kill_task(struct task_str
 	struct mm_struct *mm;
 	struct task_struct *g, *q;
 
+	task_lock(p);
 	mm = p->mm;
-
-	/* WARNING: mm may not be dereferenced since we did not obtain its
-	 * value from get_task_mm(p).  This is OK since all we need to do is
-	 * compare mm to q->mm below.
-	 *
-	 * Furthermore, even if mm contains a non-NULL value, p->mm may
-	 * change to NULL at any time since we do not hold task_lock(p).
-	 * However, this is of no concern to us.
-	 */
-
-	if (mm == NULL)
+	if (!mm || mm->oom_adj == OOM_DISABLE) {
+		task_unlock(p);
 		return 1;
-
-	/*
-	 * Don't kill the process if any threads are set to OOM_DISABLE
-	 */
-	do_each_thread(g, q) {
-		task_lock(q);
-		if (q->mm == mm && q->mm && q->mm->oom_adj == OOM_DISABLE) {
-			task_unlock(q);
-			return 1;
-		}
-		task_unlock(q);
-	} while_each_thread(g, q);
-
+	}
+	task_unlock(p);
 	__oom_kill_task(p, 1);
 
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

