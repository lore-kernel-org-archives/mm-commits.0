From: akpm@linux-foundation.org
Subject: + tracehook_notify_death-use-task_detached-helper.patch added to -mm tree
Date: Wed, 11 Feb 2009 16:19:48 -0800
Message-ID: <200902120019.n1C0Jmer012312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979AbZBLAUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:20:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, markus.t.metzger@intel.com, roland@redhat.com


The patch titled
     tracehook_notify_death: use task_detached() helper
has been added to the -mm tree.  Its filename is
     tracehook_notify_death-use-task_detached-helper.patch

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
Subject: tracehook_notify_death: use task_detached() helper
From: Oleg Nesterov <oleg@redhat.com>

Now that task_detached() is exported, change tracehook_notify_death() to
use this helper, nobody else checks ->exit_signal == -1 by hand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/tracehook.h~tracehook_notify_death-use-task_detached-helper include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook_notify_death-use-task_detached-helper
+++ a/include/linux/tracehook.h
@@ -507,7 +507,7 @@ static inline int tracehook_notify_jctl(
 static inline int tracehook_notify_death(struct task_struct *task,
 					 void **death_cookie, int group_dead)
 {
-	if (task->exit_signal == -1)
+	if (task_detached(task))
 		return task->ptrace ? SIGCHLD : DEATH_REAP;
 
 	/*
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

