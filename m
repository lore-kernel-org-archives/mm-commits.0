From: akpm@linux-foundation.org
Subject: [merged] oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:32:46 -0700
Message-ID: <201103232036.p2NKaMBI028114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933435Ab1CWUnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, avagin@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     oom: avoid deferring oom killer if exiting task is being traced
has been removed from the -mm tree.  Its filename was
     oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: avoid deferring oom killer if exiting task is being traced
From: David Rientjes <rientjes@google.com>

The oom killer naturally defers killing anything if it finds an eligible
task that is already exiting and has yet to detach its ->mm.  This avoids
unnecessarily killing tasks when one is already in the exit path and may
free enough memory that the oom killer is no longer needed.  This is
detected by PF_EXITING since threads that have already detached its ->mm
are no longer considered at all.

The problem with always deferring when a thread is PF_EXITING, however, is
that it may never actually exit when being traced, specifically if another
task is tracing it with PTRACE_O_TRACEEXIT.  The oom killer does not want
to defer in this case since there is no guarantee that thread will ever
exit without intervention.

This patch will now only defer the oom killer when a thread is PF_EXITING
and no ptracer has stopped its progress in the exit path.  It also ensures
that a child is sacrificed for the chosen parent only if it has a
different ->mm as the comment implies: this ensures that the thread group
leader is always targeted appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff -puN mm/oom_kill.c~oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced mm/oom_kill.c
--- a/mm/oom_kill.c~oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced
+++ a/mm/oom_kill.c
@@ -31,6 +31,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mempolicy.h>
 #include <linux/security.h>
+#include <linux/ptrace.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -316,22 +317,29 @@ static struct task_struct *select_bad_pr
 		if (test_tsk_thread_flag(p, TIF_MEMDIE))
 			return ERR_PTR(-1UL);
 
-		/*
-		 * This is in the process of releasing memory so wait for it
-		 * to finish before killing some other task by mistake.
-		 *
-		 * However, if p is the current task, we allow the 'kill' to
-		 * go ahead if it is exiting: this will simply set TIF_MEMDIE,
-		 * which will allow it to gain access to memory reserves in
-		 * the process of exiting and releasing its resources.
-		 * Otherwise we could get an easy OOM deadlock.
-		 */
 		if (p->flags & PF_EXITING) {
-			if (p != current)
-				return ERR_PTR(-1UL);
-
-			chosen = p;
-			*ppoints = 1000;
+			/*
+			 * If p is the current task and is in the process of
+			 * releasing memory, we allow the "kill" to set
+			 * TIF_MEMDIE, which will allow it to gain access to
+			 * memory reserves.  Otherwise, it may stall forever.
+			 *
+			 * The loop isn't broken here, however, in case other
+			 * threads are found to have already been oom killed.
+			 */
+			if (p == current) {
+				chosen = p;
+				*ppoints = 1000;
+			} else {
+				/*
+				 * If this task is not being ptraced on exit,
+				 * then wait for it to finish before killing
+				 * some other task unnecessarily.
+				 */
+				if (!(task_ptrace(p->group_leader) &
+							PT_TRACE_EXIT))
+					return ERR_PTR(-1UL);
+			}
 		}
 
 		points = oom_badness(p, mem, nodemask, totalpages);
@@ -493,6 +501,8 @@ static int oom_kill_process(struct task_
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
 
+			if (child->mm == p->mm)
+				continue;
 			/*
 			 * oom_badness() returns 0 if the thread is unkillable
 			 */
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch
sysctl-add-some-missing-input-constraint-checks.patch

