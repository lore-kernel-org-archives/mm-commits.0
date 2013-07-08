From: akpm@linux-foundation.org
Subject: [merged]
 kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:11 -0700
Message-ID: <51db14ab.B4J/whaF7QSRxGic%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3GHTgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: [merged] kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch removed from -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:11 -0700


The patch titled
     Subject: kernel/fork.c:copy_process(): consolidate the lockless CLONE_THREAD checks
has been removed from the -mm tree.  Its filename was
     kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel/fork.c:copy_process(): consolidate the lockless CLONE_THREAD checks

copy_process() does a lot of "chaotic" initializations and checks
CLONE_THREAD twice before it takes tasklist.  In particular it sets
"p->group_leader = p" and then changes it again under tasklist if
!thread_group_leader(p).

This looks a bit confusing, lets create a single "if (CLONE_THREAD)" block
which initializes ->exit_signal, ->group_leader, and ->tgid.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff -puN kernel/fork.c~kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks
+++ a/kernel/fork.c
@@ -1360,11 +1360,6 @@ static struct task_struct *copy_process(
 			goto bad_fork_cleanup_io;
 	}
 
-	p->pid = pid_nr(pid);
-	p->tgid = p->pid;
-	if (clone_flags & CLONE_THREAD)
-		p->tgid = current->tgid;
-
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
@@ -1400,12 +1395,19 @@ static struct task_struct *copy_process(
 	clear_all_latency_tracing(p);
 
 	/* ok, now we should be set up.. */
-	if (clone_flags & CLONE_THREAD)
+	p->pid = pid_nr(pid);
+	if (clone_flags & CLONE_THREAD) {
 		p->exit_signal = -1;
-	else if (clone_flags & CLONE_PARENT)
-		p->exit_signal = current->group_leader->exit_signal;
-	else
-		p->exit_signal = (clone_flags & CSIGNAL);
+		p->group_leader = current->group_leader;
+		p->tgid = current->tgid;
+	} else {
+		if (clone_flags & CLONE_PARENT)
+			p->exit_signal = current->group_leader->exit_signal;
+		else
+			p->exit_signal = (clone_flags & CSIGNAL);
+		p->group_leader = p;
+		p->tgid = p->pid;
+	}
 
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
@@ -1414,15 +1416,13 @@ static struct task_struct *copy_process(
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when = 0;
 
-	/*
-	 * Ok, make it visible to the rest of the system.
-	 * We dont wake it up yet.
-	 */
-	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 
-	/* Need tasklist lock for parent etc handling! */
+	/*
+	 * Make it visible to the rest of the system, but dont wake it up yet.
+	 * Need tasklist lock for parent etc handling!
+	 */
 	write_lock_irq(&tasklist_lock);
 
 	/* CLONE_PARENT re-uses the old parent */
@@ -1476,7 +1476,6 @@ static struct task_struct *copy_process(
 			current->signal->nr_threads++;
 			atomic_inc(&current->signal->live);
 			atomic_inc(&current->signal->sigcnt);
-			p->group_leader = current->group_leader;
 			list_add_tail_rcu(&p->thread_group,
 					  &p->group_leader->thread_group);
 		}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

