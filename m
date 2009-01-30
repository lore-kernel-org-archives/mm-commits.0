From: akpm@linux-foundation.org
Subject: + reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:21:02 -0800
Message-ID: <200901302021.n0UKL2Ht013063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbZA3UVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:21:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com


The patch titled
     reparent_thread: don't call kill_orphaned_pgrp() if task_detached()
has been added to the -mm tree.  Its filename is
     reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch

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
Subject: reparent_thread: don't call kill_orphaned_pgrp() if task_detached()
From: Oleg Nesterov <oleg@redhat.com>

If task_detached(p) == T, then either

  a) p is not the main thread, we will find the group leader on the
     ->children list.

or

  b) p is the group leader but its ->exit_state = EXIT_DEAD.  This
     can only happen when the last sub-thread has died, but in that case
     that thread has already called kill_orphaned_pgrp() from
     exit_notify().

In both cases kill_orphaned_pgrp() looks bogus.

Move the task_detached() check up and simplify the code, this is also
right from the "common sense" pov: we should do nothing with the detached
childs, except move them to the new parent's ->children list.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached kernel/exit.c
--- a/kernel/exit.c~reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached
+++ a/kernel/exit.c
@@ -812,6 +812,8 @@ static void reparent_thread(struct task_
 
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
+	if (task_detached(p))
+		return;
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
 	 */
@@ -819,15 +821,13 @@ static void reparent_thread(struct task_
 		return;
 
 	/* We don't want people slaying init.  */
-	if (!task_detached(p))
-		p->exit_signal = SIGCHLD;
+	p->exit_signal = SIGCHLD;
 
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
 	if (!ptrace_reparented(p) &&
-	    p->exit_state == EXIT_ZOMBIE &&
-	    !task_detached(p) && thread_group_empty(p))
+	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
 	kill_orphaned_pgrp(p, father);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
wait-prevent-exclusive-waiter-starvation.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-cleanup-ptrace-pathes.patch
kthread-dont-looking-for-a-task-in-create_kthread-2.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

