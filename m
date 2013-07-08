From: akpm@linux-foundation.org
Subject: [merged]
 fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:57 -0700
Message-ID: <51db149d.p3buBsKLlWZFUm5N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GHTf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, oleg@redhat.com

Subject: [merged] fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch removed from -mm tree
To: oleg@redhat.com,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:57 -0700


The patch titled
     Subject: fs/exec.c:de_thread(): use change_pid() rather than detach_pid/attach_pid
has been removed from the -mm tree.  Its filename was
     fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/exec.c:de_thread(): use change_pid() rather than detach_pid/attach_pid

de_thread() can use change_pid() instead of detach + attach.  This looks
better and this ensures that, say, next_thread() can never see a task with
->pid == NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/exec.c~fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid fs/exec.c
--- a/fs/exec.c~fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid
+++ a/fs/exec.c
@@ -947,9 +947,8 @@ static int de_thread(struct task_struct
 		 * Note: The old leader also uses this pid until release_task
 		 *       is called.  Odd but simple and correct.
 		 */
-		detach_pid(tsk, PIDTYPE_PID);
 		tsk->pid = leader->pid;
-		attach_pid(tsk, PIDTYPE_PID,  task_pid(leader));
+		change_pid(tsk, PIDTYPE_PID, task_pid(leader));
 		transfer_pid(leader, tsk, PIDTYPE_PGID);
 		transfer_pid(leader, tsk, PIDTYPE_SID);
 
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

