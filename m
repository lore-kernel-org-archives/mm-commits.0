From: akpm@linux-foundation.org
Subject: + oom-filter-tasks-not-sharing-the-same-cpuset.patch added to -mm tree
Date: Tue, 08 Jun 2010 13:23:47 -0700
Message-ID: <201006082023.o58KNlvc022847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756248Ab0FHUYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 16:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: filter tasks not sharing the same cpuset
has been added to the -mm tree.  Its filename is
     oom-filter-tasks-not-sharing-the-same-cpuset.patch

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
Subject: oom: filter tasks not sharing the same cpuset
From: David Rientjes <rientjes@google.com>

Tasks that do not share the same set of allowed nodes with the task that
triggered the oom should not be considered as candidates for oom kill.

Tasks in other cpusets with a disjoint set of mems would be unfairly
penalized otherwise because of oom conditions elsewhere; an extreme
example could unfairly kill all other applications on the system if a
single task in a user's cpuset sets itself to OOM_DISABLE and then uses
more memory than allowed.

Killing tasks outside of current's cpuset rarely would free memory for
current anyway.  To use a sane heuristic, we must ensure that killing a
task would likely free memory for current and avoid needlessly killing
others at all costs just because their potential memory freeing is
unknown.  It is better to kill current than another task needlessly.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN mm/oom_kill.c~oom-filter-tasks-not-sharing-the-same-cpuset mm/oom_kill.c
--- a/mm/oom_kill.c~oom-filter-tasks-not-sharing-the-same-cpuset
+++ a/mm/oom_kill.c
@@ -184,14 +184,6 @@ unsigned long badness(struct task_struct
 		points /= 4;
 
 	/*
-	 * If p's nodes don't overlap ours, it may still help to kill p
-	 * because p may have allocated or otherwise mapped memory on
-	 * this node before. However it will be less likely.
-	 */
-	if (!has_intersects_mems_allowed(p))
-		points /= 8;
-
-	/*
 	 * Adjust the score by oom_adj.
 	 */
 	if (oom_adj) {
@@ -277,6 +269,8 @@ static struct task_struct *select_bad_pr
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
+		if (!has_intersects_mems_allowed(p))
+			continue;
 
 		/*
 		 * This task already has access to memory reserves and is
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

