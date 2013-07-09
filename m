From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:25 -0700
Message-ID: <51dc9af5.i+cIJkNPzi287RNL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab3GIXV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:25 -0700


The patch titled
     Subject: ptrace/x86: flush_ptrace_hw_breakpoint() shoule clear the virtual debug registers
has been removed from the -mm tree.  Its filename was
     ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/x86: flush_ptrace_hw_breakpoint() shoule clear the virtual debug registers

flush_ptrace_hw_breakpoint() destroys the counters set by ptrace, but
"leaks" ->debugreg6 and ->ptrace_dr7.

The problem is minor, but still it doesn't look right and flush_thread()
did this until 66cb5917 ("hw-breakpoints: use the new wrapper routines to
access debug registers in process/thread code").  Now that PTRACE_DETACH
does flush_ too this makes even more sense.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/hw_breakpoint.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/kernel/hw_breakpoint.c~ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers arch/x86/kernel/hw_breakpoint.c
--- a/arch/x86/kernel/hw_breakpoint.c~ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers
+++ a/arch/x86/kernel/hw_breakpoint.c
@@ -393,6 +393,9 @@ void flush_ptrace_hw_breakpoint(struct t
 		unregister_hw_breakpoint(t->ptrace_bps[i]);
 		t->ptrace_bps[i] = NULL;
 	}
+
+	t->debugreg6 = 0;
+	t->ptrace_dr7 = 0;
 }
 
 void hw_breakpoint_restore(void)
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

