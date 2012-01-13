From: akpm@linux-foundation.org
Subject: [merged] oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:05 -0800
Message-ID: <20120113203406.38CB15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099Ab2AMUeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:08 -0500
Received: by eeke50 with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, memcg: fix exclusion of memcg threads after they have detached their mm
has been removed from the -mm tree.  Its filename was
     oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: oom, memcg: fix exclusion of memcg threads after they have detached their mm

The oom killer relies on logic that identifies threads that have already
been oom killed when scanning the tasklist and, if found, deferring until
such threads have exited.  This is done by checking for any candidate
threads that have the TIF_MEMDIE bit set.

For memcg ooms, candidate threads are first found by calling
task_in_mem_cgroup() since the oom killer should not defer if there's an
oom killed thread in another memcg.

Unfortunately, task_in_mem_cgroup() excludes threads if they have detached
their mm in the process of exiting so TIF_MEMDIE is never detected for
such conditions.  This is different for global, mempolicy, and cpuset oom
conditions where a detached mm is only excluded after checking for
TIF_MEMDIE and deferring, if necessary, in select_bad_process().

The fix is to return true if a task has a detached mm but is still in the
memcg or its hierarchy that is currently oom.  This will allow the oom
killer to appropriately defer rather than kill unnecessarily or, in the
worst case, panic the machine if nothing else is available to kill.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm mm/memcontrol.c
--- a/mm/memcontrol.c~oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm
+++ a/mm/memcontrol.c
@@ -1238,10 +1238,21 @@ int task_in_mem_cgroup(struct task_struc
 	struct task_struct *p;
 
 	p = find_lock_task_mm(task);
-	if (!p)
-		return 0;
-	curr = try_get_mem_cgroup_from_mm(p->mm);
-	task_unlock(p);
+	if (p) {
+		curr = try_get_mem_cgroup_from_mm(p->mm);
+		task_unlock(p);
+	} else {
+		/*
+		 * All threads may have already detached their mm's, but the oom
+		 * killer still needs to detect if they have already been oom
+		 * killed to prevent needlessly killing additional tasks.
+		 */
+		task_lock(task);
+		curr = mem_cgroup_from_task(task);
+		if (curr)
+			css_get(&curr->css);
+		task_unlock(task);
+	}
 	if (!curr)
 		return 0;
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch

