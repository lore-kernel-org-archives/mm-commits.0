From: akpm@linux-foundation.org
Subject: + oom-hold-tasklist_lock-when-dumping-tasks.patch added to -mm tree
Date: Fri, 02 Apr 2010 15:25:50 -0700
Message-ID: <201004022225.o32MPoIq008833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402Ab0DBW0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 18:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com


The patch titled
     oom: hold tasklist_lock when dumping tasks
has been added to the -mm tree.  Its filename is
     oom-hold-tasklist_lock-when-dumping-tasks.patch

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
Subject: oom: hold tasklist_lock when dumping tasks
From: David Rientjes <rientjes@google.com>

dump_header() always requires tasklist_lock to be held because it calls
dump_tasks() which iterates through the tasklist.  There are a few places
where this isn't maintained, so make sure tasklist_lock is always held
whenever calling dump_header().

This also fixes the pagefault case where oom_kill_process() is called on
current without tasklist_lock.  It is necessary to hold a readlock for
both calling dump_header() and iterating its children.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN mm/oom_kill.c~oom-hold-tasklist_lock-when-dumping-tasks mm/oom_kill.c
--- a/mm/oom_kill.c~oom-hold-tasklist_lock-when-dumping-tasks
+++ a/mm/oom_kill.c
@@ -400,6 +400,9 @@ static void dump_tasks(const struct mem_
 	} while_each_thread(g, p);
 }
 
+/*
+ * Call with tasklist_lock read-locked.
+ */
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 							struct mem_cgroup *mem)
 {
@@ -646,8 +649,8 @@ retry:
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		read_unlock(&tasklist_lock);
 		dump_header(NULL, gfp_mask, order, NULL);
+		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
 
@@ -680,11 +683,6 @@ void out_of_memory(struct zonelist *zone
 		/* Got some memory back in the last second. */
 		return;
 
-	if (sysctl_panic_on_oom == 2) {
-		dump_header(NULL, gfp_mask, order, NULL);
-		panic("out of memory. Compulsory panic_on_oom is selected.\n");
-	}
-
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
@@ -693,15 +691,12 @@ void out_of_memory(struct zonelist *zone
 						&totalpages);
 	read_lock(&tasklist_lock);
 	if (unlikely(sysctl_panic_on_oom)) {
-		/*
-		 * panic_on_oom only affects CONSTRAINT_NONE, the kernel
-		 * should not panic for cpuset or mempolicy induced memory
-		 * failures.
-		 */
-		if (constraint == CONSTRAINT_NONE) {
+		if (sysctl_panic_on_oom == 2 || constraint == CONSTRAINT_NONE) {
 			dump_header(NULL, gfp_mask, order, NULL);
 			read_unlock(&tasklist_lock);
-			panic("Out of memory: panic_on_oom is enabled\n");
+			panic("Out of memory: %s panic_on_oom is enabled\n",
+				sysctl_panic_on_oom == 2 ? "compulsory" :
+							   "system-wide");
 		}
 	}
 	__out_of_memory(gfp_mask, order, totalpages, constraint, nodemask);
@@ -729,8 +724,10 @@ void pagefault_out_of_memory(void)
 
 	if (try_set_system_oom()) {
 		constrained_alloc(NULL, 0, NULL, &totalpages);
+		read_lock(&tasklist_lock);
 		err = oom_kill_process(current, 0, 0, 0, totalpages, NULL,
 					"Out of memory (pagefault)");
+		read_unlock(&tasklist_lock);
 		if (err)
 			out_of_memory(NULL, 0, 0, NULL);
 		clear_system_oom();
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
acpi-map-pxms-to-low-node-ids.patch
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
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
oom-move-sysctl-declarations-to-oomh.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

