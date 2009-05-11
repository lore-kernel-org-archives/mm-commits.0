From: akpm@linux-foundation.org
Subject: + oom-fix-possible-oom_dump_tasks-null-pointer.patch added to -mm tree
Date: Mon, 11 May 2009 14:14:36 -0700
Message-ID: <200905112114.n4BLEaVO026161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759614AbZEKVRC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 17:17:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, npiggin@suse.de


The patch titled
     oom: fix possible oom_dump_tasks NULL pointer
has been added to the -mm tree.  Its filename is
     oom-fix-possible-oom_dump_tasks-null-pointer.patch

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
Subject: oom: fix possible oom_dump_tasks NULL pointer
From: David Rientjes <rientjes@google.com>

When /proc/sys/vm/oom_dump_tasks is enabled, it is possible to get a NULL
pointer for tasks that have detached mm's since task_lock() is not held
during the tasklist scan.

Fix this by checking for a NULL mm_struct pointer and avoiding the
dereference if the race occurred.

Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN mm/oom_kill.c~oom-fix-possible-oom_dump_tasks-null-pointer mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fix-possible-oom_dump_tasks-null-pointer
+++ a/mm/oom_kill.c
@@ -284,22 +284,28 @@ static void dump_tasks(const struct mem_
 	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
 	       "name\n");
 	do_each_thread(g, p) {
-		/*
-		 * total_vm and rss sizes do not exist for tasks with a
-		 * detached mm so there's no need to report them.
-		 */
-		if (!p->mm)
-			continue;
+		struct mm_struct *mm;
+
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
 		if (!thread_group_leader(p))
 			continue;
 
 		task_lock(p);
+		mm = p->mm;
+		if (!mm) {
+			/*
+			 * total_vm and rss sizes do not exist for tasks with no
+			 * mm so there's no need to report them; they can't be
+			 * oom killed anyway.
+			 */
+			task_unlock(p);
+			continue;
+		}
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
-		       p->pid, __task_cred(p)->uid, p->tgid,
-		       p->mm->total_vm, get_mm_rss(p->mm), (int)task_cpu(p),
-		       p->oomkilladj, p->comm);
+		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
+		       get_mm_rss(mm), (int)task_cpu(p), p->oomkilladj,
+		       p->comm);
 		task_unlock(p);
 	} while_each_thread(g, p);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
mm-invoke-oom-killer-for-__gfp_nofail.patch
oom-fix-possible-oom_dump_tasks-null-pointer.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

