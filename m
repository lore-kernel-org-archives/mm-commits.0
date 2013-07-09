From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:19 -0700
Message-ID: <51dc9aef.ebbI4ZDWgkMkiTUh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3GIXVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:19 -0700


The patch titled
     Subject: ptrace/x86: ptrace_write_dr7() should create bp if !disabled
has been removed from the -mm tree.  Its filename was
     ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/x86: ptrace_write_dr7() should create bp if !disabled

24f1e32c ("hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf
events") introduced the minor regression.  Before this commit

	PTRACE_POKEUSER DR7, enableDR0
	PTRACE_POKEUSER DR0, address

was perfectly valid, now PTRACE_POKEUSER(DR7) fails if DR0 was not
previously initialized by PTRACE_POKEUSER(DR0).

Change ptrace_write_dr7() to do ptrace_register_breakpoint(addr => 0) if
!bp && !disabled.  This fixes watchpoint-zeroaddr from ptrace-tests, see
https://bugzilla.redhat.com/show_bug.cgi?id=660204.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled
+++ a/arch/x86/kernel/ptrace.c
@@ -670,13 +670,16 @@ restore:
 		if (!bp) {
 			if (disabled)
 				continue;
-			/*
-			 * We should have at least an inactive breakpoint at
-			 * this slot. It means the user is writing dr7 without
-			 * having written the address register first.
-			 */
-			rc = -EINVAL;
-			break;
+
+			bp = ptrace_register_breakpoint(tsk,
+					len, type, 0, disabled);
+			if (IS_ERR(bp)) {
+				rc = PTR_ERR(bp);
+				break;
+			}
+
+			thread->ptrace_bps[i] = bp;
+			continue;
 		}
 
 		rc = ptrace_modify_breakpoint(bp, len, type, disabled);
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

