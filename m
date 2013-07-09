From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:07 -0700
Message-ID: <51dc9ae3.0jSGeerGxFnGxm/H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3GIXVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:07 -0700


The patch titled
     Subject: ptrace/arm: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"
has been removed from the -mm tree.  Its filename was
     ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/arm: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"

This reverts commit bf0b8f4b55e ("hw_breakpoints: Fix racy access to
ptrace breakpoints").

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ptrace.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN arch/arm/kernel/ptrace.c~ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints
+++ a/arch/arm/kernel/ptrace.c
@@ -886,20 +886,12 @@ long arch_ptrace(struct task_struct *chi
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		case PTRACE_GETHBPREGS:
-			if (ptrace_get_breakpoints(child) < 0)
-				return -ESRCH;
-
 			ret = ptrace_gethbpregs(child, addr,
 						(unsigned long __user *)data);
-			ptrace_put_breakpoints(child);
 			break;
 		case PTRACE_SETHBPREGS:
-			if (ptrace_get_breakpoints(child) < 0)
-				return -ESRCH;
-
 			ret = ptrace_sethbpregs(child, addr,
 						(unsigned long __user *)data);
-			ptrace_put_breakpoints(child);
 			break;
 #endif
 
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

