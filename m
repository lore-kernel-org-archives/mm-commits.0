From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:05 -0700
Message-ID: <51dc9ae1.XCE9E/sJPg5wxZ3A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3GIXVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:05 -0700


The patch titled
     Subject: ptrace/powerpc: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"
has been removed from the -mm tree.  Its filename was
     ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/powerpc: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"

This reverts commit 07fa7a0a8a586 ("hw_breakpoints: Fix racy access to
ptrace breakpoints") and removes ptrace_get/put_breakpoints() added by
other commits.

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ptrace.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff -puN arch/powerpc/kernel/ptrace.c~ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints
+++ a/arch/powerpc/kernel/ptrace.c
@@ -975,16 +975,12 @@ int ptrace_set_debugreg(struct task_stru
 	hw_brk.type = (data & HW_BRK_TYPE_DABR) | HW_BRK_TYPE_PRIV_ALL;
 	hw_brk.len = 8;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(task) < 0)
-		return -ESRCH;
-
 	bp = thread->ptrace_bps[0];
 	if ((!data) || !(hw_brk.type & HW_BRK_TYPE_RDWR)) {
 		if (bp) {
 			unregister_hw_breakpoint(bp);
 			thread->ptrace_bps[0] = NULL;
 		}
-		ptrace_put_breakpoints(task);
 		return 0;
 	}
 	if (bp) {
@@ -997,11 +993,9 @@ int ptrace_set_debugreg(struct task_stru
 
 		ret =  modify_user_hw_breakpoint(bp, &attr);
 		if (ret) {
-			ptrace_put_breakpoints(task);
 			return ret;
 		}
 		thread->ptrace_bps[0] = bp;
-		ptrace_put_breakpoints(task);
 		thread->hw_brk = hw_brk;
 		return 0;
 	}
@@ -1016,12 +1010,9 @@ int ptrace_set_debugreg(struct task_stru
 					       ptrace_triggered, NULL, task);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
-		ptrace_put_breakpoints(task);
 		return PTR_ERR(bp);
 	}
 
-	ptrace_put_breakpoints(task);
-
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 	task->thread.hw_brk = hw_brk;
 #else /* CONFIG_PPC_ADV_DEBUG_REGS */
@@ -1440,26 +1431,19 @@ static long ppc_set_hwdebug(struct task_
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
 		brk.type |= HW_BRK_TYPE_WRITE;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(child) < 0)
-		return -ESRCH;
-
 	/*
 	 * Check if the request is for 'range' breakpoints. We can
 	 * support it if range < 8 bytes.
 	 */
-	if (bp_info->addr_mode == PPC_BREAKPOINT_MODE_RANGE_INCLUSIVE) {
+	if (bp_info->addr_mode == PPC_BREAKPOINT_MODE_RANGE_INCLUSIVE)
 		len = bp_info->addr2 - bp_info->addr;
-	} else if (bp_info->addr_mode == PPC_BREAKPOINT_MODE_EXACT)
+	else if (bp_info->addr_mode == PPC_BREAKPOINT_MODE_EXACT)
 		len = 1;
-	else {
-		ptrace_put_breakpoints(child);
+	else
 		return -EINVAL;
-	}
 	bp = thread->ptrace_bps[0];
-	if (bp) {
-		ptrace_put_breakpoints(child);
+	if (bp)
 		return -ENOSPC;
-	}
 
 	/* Create a new breakpoint request if one doesn't exist already */
 	hw_breakpoint_init(&attr);
@@ -1471,11 +1455,9 @@ static long ppc_set_hwdebug(struct task_
 					       ptrace_triggered, NULL, child);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
-		ptrace_put_breakpoints(child);
 		return PTR_ERR(bp);
 	}
 
-	ptrace_put_breakpoints(child);
 	return 1;
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
@@ -1519,16 +1501,12 @@ static long ppc_del_hwdebug(struct task_
 		return -EINVAL;
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(child) < 0)
-		return -ESRCH;
-
 	bp = thread->ptrace_bps[0];
 	if (bp) {
 		unregister_hw_breakpoint(bp);
 		thread->ptrace_bps[0] = NULL;
 	} else
 		ret = -ENOENT;
-	ptrace_put_breakpoints(child);
 	return ret;
 #else /* CONFIG_HAVE_HW_BREAKPOINT */
 	if (child->thread.hw_brk.address == 0)
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

