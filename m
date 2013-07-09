From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:11 -0700
Message-ID: <51dc9ae7.JVb+O14dwaO8E/2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3GIXVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:11 -0700


The patch titled
     Subject: ptrace: revert "Prepare to fix racy accesses on task breakpoints"
has been removed from the -mm tree.  Its filename was
     ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: revert "Prepare to fix racy accesses on task breakpoints"

This reverts commit bf26c018490c2fce ("Prepare to fix racy accesses on
task breakpoints").

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

Now that ptrace_get_breakpoints/ptrace_put_breakpoints have no callers, we
can kill them and remove task->ptrace_bp_refcnt.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |   10 ----------
 include/linux/sched.h  |    3 ---
 kernel/exit.c          |    2 +-
 kernel/ptrace.c        |   16 ----------------
 4 files changed, 1 insertion(+), 30 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints
+++ a/include/linux/ptrace.h
@@ -142,9 +142,6 @@ static inline void ptrace_init_task(stru
 {
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-	atomic_set(&child->ptrace_bp_refcnt, 1);
-#endif
 	child->jobctl = 0;
 	child->ptrace = 0;
 	child->parent = child->real_parent;
@@ -351,11 +348,4 @@ extern int task_current_syscall(struct t
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-extern int ptrace_get_breakpoints(struct task_struct *tsk);
-extern void ptrace_put_breakpoints(struct task_struct *tsk);
-#else
-static inline void ptrace_put_breakpoints(struct task_struct *tsk) { }
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
-
 #endif
diff -puN include/linux/sched.h~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints include/linux/sched.h
--- a/include/linux/sched.h~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints
+++ a/include/linux/sched.h
@@ -1401,9 +1401,6 @@ struct task_struct {
 	} memcg_batch;
 	unsigned int memcg_kmem_skip_account;
 #endif
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-	atomic_t ptrace_bp_refcnt;
-#endif
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
 #endif
diff -puN kernel/exit.c~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints kernel/exit.c
--- a/kernel/exit.c~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints
+++ a/kernel/exit.c
@@ -808,7 +808,7 @@ void do_exit(long code)
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
-	ptrace_put_breakpoints(tsk);
+	flush_ptrace_hw_breakpoint(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff -puN kernel/ptrace.c~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints
+++ a/kernel/ptrace.c
@@ -1221,19 +1221,3 @@ asmlinkage long compat_sys_ptrace(compat
 	return ret;
 }
 #endif	/* CONFIG_COMPAT */
-
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-int ptrace_get_breakpoints(struct task_struct *tsk)
-{
-	if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
-		return 0;
-
-	return -1;
-}
-
-void ptrace_put_breakpoints(struct task_struct *tsk)
-{
-	if (atomic_dec_and_test(&tsk->ptrace_bp_refcnt))
-		flush_ptrace_hw_breakpoint(tsk);
-}
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

