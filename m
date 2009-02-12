From: akpm@linux-foundation.org
Subject: + reparent-untrace-do-nothing-if-no-childs-tracees.patch added to -mm tree
Date: Wed, 11 Feb 2009 16:19:46 -0800
Message-ID: <200902120019.n1C0JkTd012285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620AbZBLAUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:20:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, markus.t.metzger@intel.com, roland@redhat.com


The patch titled
     reparent/untrace: do nothing if no childs/tracees
has been added to the -mm tree.  Its filename is
     reparent-untrace-do-nothing-if-no-childs-tracees.patch

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
Subject: reparent/untrace: do nothing if no childs/tracees
From: Oleg Nesterov <oleg@redhat.com>

forget_original_parent() and exit_ptrace() can avoid taking the global
tasklist_lock if there are no childs/tracees.  But I failed to invent the
comment to explain why/when this is safe to do, that is why the separate
patch/changelog.

The problem is, we can race with the concurrent release_task() which can
remove the last child form our ->children/ptraced list.  This means that
list_empty() can return the "false" positive, it is possible that
release_task() is still in progress, it can use the caller's task_struct
somehow, and it is even possible that list_del(sibling/ptrace_entry) has
not yet completed.

But this is fine, before our task_struct will be released we will take
tasklist_lock at least once in release_task(), this will synchronize us
with the possible release_task/ptrace_unlink in flight.

However, forget_original_parent() has another problem.  We can race with
another thread which has already picked us for reparenting before we set
PF_EXITING, so this patch also checks thread_group_empty().

It is possible to be more clever, we can take tasklist for reading, or
ensure that ->thread_group.prev is not PF_EXITING, but this is nasty. 
Perhaps even this optimization is too ugly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c   |   10 ++++++++++
 kernel/ptrace.c |    3 +++
 2 files changed, 13 insertions(+)

diff -puN kernel/exit.c~reparent-untrace-do-nothing-if-no-childs-tracees kernel/exit.c
--- a/kernel/exit.c~reparent-untrace-do-nothing-if-no-childs-tracees
+++ a/kernel/exit.c
@@ -806,6 +806,16 @@ static void forget_original_parent(struc
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(dead_children);
 
+	if (thread_group_empty(father)) {
+		/*
+		 * Make sure no other thread can reparent to
+		 * us after the list_empty(->children) check.
+		 */
+		smp_rmb();
+		if (list_empty(&father->children))
+			return;
+	}
+
 	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
 
diff -puN kernel/ptrace.c~reparent-untrace-do-nothing-if-no-childs-tracees kernel/ptrace.c
--- a/kernel/ptrace.c~reparent-untrace-do-nothing-if-no-childs-tracees
+++ a/kernel/ptrace.c
@@ -323,6 +323,9 @@ void exit_ptrace(struct task_struct *tra
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
 
+	if (list_empty(&tracer->ptraced))
+		return;
+
 	write_lock_irq(&tasklist_lock);
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (__ptrace_detach(tracer, p))
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
move-exit_ptrace-from-forget_original_parent-to-do_exit.patch
reparent-untrace-do-nothing-if-no-childs-tracees.patch
tracehook_notify_death-use-task_detached-helper.patch
workqueue-avoid-recursion-in-run_workqueue.patch
kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

