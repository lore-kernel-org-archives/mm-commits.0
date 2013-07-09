From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:03 -0700
Message-ID: <51dc9adf.YhBQgdzJQjLzLKWB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3GIXVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:03 -0700


The patch titled
     Subject: ptrace/x86: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"
has been removed from the -mm tree.  Its filename was
     ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/x86: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"

This reverts commit 87dc669ba257 ("hw_breakpoints: Fix racy access to
ptrace breakpoints").

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

The patch only removes ptrace_get_breakpoints/ptrace_put_breakpoints and
does a couple of "while at it" cleanups, it doesn't remove other changes
from the reverted commit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints
+++ a/arch/x86/kernel/ptrace.c
@@ -641,9 +641,6 @@ static int ptrace_write_dr7(struct task_
 	unsigned len, type;
 	struct perf_event *bp;
 
-	if (ptrace_get_breakpoints(tsk) < 0)
-		return -ESRCH;
-
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
@@ -692,9 +689,7 @@ restore:
 		goto restore;
 	}
 
-	ptrace_put_breakpoints(tsk);
-
-	return ((orig_ret < 0) ? orig_ret : rc);
+	return orig_ret < 0 ? orig_ret : rc;
 }
 
 /*
@@ -706,18 +701,10 @@ static unsigned long ptrace_get_debugreg
 	unsigned long val = 0;
 
 	if (n < HBP_NUM) {
-		struct perf_event *bp;
-
-		if (ptrace_get_breakpoints(tsk) < 0)
-			return -ESRCH;
+		struct perf_event *bp = thread->ptrace_bps[n];
 
-		bp = thread->ptrace_bps[n];
-		if (!bp)
-			val = 0;
-		else
+		if (bp)
 			val = bp->hw.info.address;
-
-		ptrace_put_breakpoints(tsk);
 	} else if (n == 6) {
 		val = thread->debugreg6;
 	 } else if (n == 7) {
@@ -734,9 +721,6 @@ static int ptrace_set_breakpoint_addr(st
 	struct perf_event_attr attr;
 	int err = 0;
 
-	if (ptrace_get_breakpoints(tsk) < 0)
-		return -ESRCH;
-
 	if (!t->ptrace_bps[nr]) {
 		ptrace_breakpoint_init(&attr);
 		/*
@@ -762,7 +746,7 @@ static int ptrace_set_breakpoint_addr(st
 		 */
 		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
-			goto put;
+			goto out;
 		}
 
 		t->ptrace_bps[nr] = bp;
@@ -773,9 +757,7 @@ static int ptrace_set_breakpoint_addr(st
 		attr.bp_addr = addr;
 		err = modify_user_hw_breakpoint(bp, &attr);
 	}
-
-put:
-	ptrace_put_breakpoints(tsk);
+out:
 	return err;
 }
 
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

