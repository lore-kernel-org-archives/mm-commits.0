From: akpm@linux-foundation.org
Subject: [merged] oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:32:41 -0700
Message-ID: <201103232036.p2NKaHGw028097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933322Ab1CWUhJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:37:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, avagin@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     oom: prevent unnecessary oom kills or kernel panics
has been removed from the -mm tree.  Its filename was
     oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: prevent unnecessary oom kills or kernel panics
From: David Rientjes <rientjes@google.com>

This patch prevents unnecessary oom kills or kernel panics by reverting
two commits:

	495789a5 (oom: make oom_score to per-process value)
	cef1d352 (oom: multi threaded process coredump don't make deadlock)

First, 495789a5 (oom: make oom_score to per-process value) ignores the
fact that all threads in a thread group do not necessarily exit at the
same time.

It is imperative that select_bad_process() detect threads that are in the
exit path, specifically those with PF_EXITING set, to prevent needlessly
killing additional tasks.  If a process is oom killed and the thread group
leader exits, select_bad_process() cannot detect the other threads that
are PF_EXITING by iterating over only processes.  Thus, it currently
chooses another task unnecessarily for oom kill or panics the machine when
nothing else is eligible.

By iterating over threads instead, it is possible to detect threads that
are exiting and nominate them for oom kill so they get access to memory
reserves.

Second, cef1d352 (oom: multi threaded process coredump don't make
deadlock) erroneously avoids making the oom killer a no-op when an
eligible thread other than current isfound to be exiting.  We want to
detect this situation so that we may allow that exiting thread time to
exit and free its memory; if it is able to exit on its own, that should
free memory so current is no loner oom.  If it is not able to exit on its
own, the oom killer will nominate it for oom kill which, in this case,
only means it will get access to memory reserves.

Without this change, it is easy for the oom killer to unnecessarily target
tasks when all threads of a victim don't exit before the thread group
leader or, in the worst case, panic the machine.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: <stable@kernel.org>		[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~oom-prevent-unnecessary-oom-kills-or-kernel-panics mm/oom_kill.c
--- a/mm/oom_kill.c~oom-prevent-unnecessary-oom-kills-or-kernel-panics
+++ a/mm/oom_kill.c
@@ -292,11 +292,11 @@ static struct task_struct *select_bad_pr
 		unsigned long totalpages, struct mem_cgroup *mem,
 		const nodemask_t *nodemask)
 {
-	struct task_struct *p;
+	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
 	*ppoints = 0;
 
-	for_each_process(p) {
+	do_each_thread(g, p) {
 		unsigned int points;
 
 		if (oom_unkillable_task(p, mem, nodemask))
@@ -324,7 +324,7 @@ static struct task_struct *select_bad_pr
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if (thread_group_empty(p) && (p->flags & PF_EXITING) && p->mm) {
+		if ((p->flags & PF_EXITING) && p->mm) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
@@ -337,7 +337,7 @@ static struct task_struct *select_bad_pr
 			chosen = p;
 			*ppoints = points;
 		}
-	}
+	} while_each_thread(g, p);
 
 	return chosen;
 }
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

