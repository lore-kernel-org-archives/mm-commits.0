From: akpm@linux-foundation.org
Subject: [merged]
 kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:07 -0700
Message-ID: <51db14a7.RYzTOaglm0TF3ubP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3GHTgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: [merged] kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch removed from -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:07 -0700


The patch titled
     Subject: kernel/fork.c:copy_process(): unify CLONE_THREAD-or-thread_group_leader code
has been removed from the -mm tree.  Its filename was
     kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel/fork.c:copy_process(): unify CLONE_THREAD-or-thread_group_leader code

Cleanup and preparation for the next changes.

Move the "if (clone_flags & CLONE_THREAD)" code down under "if
(likely(p->pid))" and turn it into into the "else" branch.  This makes the
process/thread initialization more symmetrical and removes one check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN kernel/fork.c~kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code kernel/fork.c
--- a/kernel/fork.c~kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code
+++ a/kernel/fork.c
@@ -1446,14 +1446,6 @@ static struct task_struct *copy_process(
 		goto bad_fork_free_pid;
 	}
 
-	if (clone_flags & CLONE_THREAD) {
-		current->signal->nr_threads++;
-		atomic_inc(&current->signal->live);
-		atomic_inc(&current->signal->sigcnt);
-		p->group_leader = current->group_leader;
-		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
-	}
-
 	if (likely(p->pid)) {
 		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
 
@@ -1470,6 +1462,13 @@ static struct task_struct *copy_process(
 			list_add_tail(&p->sibling, &p->real_parent->children);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__this_cpu_inc(process_counts);
+		} else {
+			current->signal->nr_threads++;
+			atomic_inc(&current->signal->live);
+			atomic_inc(&current->signal->sigcnt);
+			p->group_leader = current->group_leader;
+			list_add_tail_rcu(&p->thread_group,
+					  &p->group_leader->thread_group);
 		}
 		attach_pid(p, PIDTYPE_PID, pid);
 		nr_threads++;
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

