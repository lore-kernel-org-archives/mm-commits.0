From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:23 -0700
Message-ID: <51dc9af3.ZRKuzCkS08ZCW1bM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3GIXVY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:23 -0700


The patch titled
     Subject: ptrace: PTRACE_DETACH should do flush_ptrace_hw_breakpoint(child)
has been removed from the -mm tree.  Its filename was
     ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: PTRACE_DETACH should do flush_ptrace_hw_breakpoint(child)

Change ptrace_detach() to call flush_ptrace_hw_breakpoint(child).  This
frees the slots for non-ptrace PERF_TYPE_BREAKPOINT users, and this
ensures that the tracee won't be killed by SIGTRAP triggered by the active
breakpoints.

Test-case:

	unsigned long encode_dr7(int drnum, int enable, unsigned int type, unsigned int len)
	{
		unsigned long dr7;

		dr7 = ((len | type) & 0xf)
			<< (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
		if (enable)
			dr7 |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE));

		return dr7;
	}

	int write_dr(int pid, int dr, unsigned long val)
	{
		return ptrace(PTRACE_POKEUSER, pid,
				offsetof (struct user, u_debugreg[dr]),
				val);
	}

	void func(void)
	{
	}

	int main(void)
	{
		int pid, stat;
		unsigned long dr7;

		pid = fork();
		if (!pid) {
			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
			kill(getpid(), SIGHUP);

			func();
			return 0x13;
		}

		assert(pid == waitpid(-1, &stat, 0));
		assert(WSTOPSIG(stat) == SIGHUP);

		assert(write_dr(pid, 0, (long)func) == 0);
		dr7 = encode_dr7(0, 1, DR_RW_EXECUTE, DR_LEN_1);
		assert(write_dr(pid, 7, dr7) == 0);

		assert(ptrace(PTRACE_DETACH, pid, 0,0) == 0);
		assert(pid == waitpid(-1, &stat, 0));
		assert(stat == 0x1300);

		return 0;
	}

Before this patch the child is killed after PTRACE_DETACH.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

 kernel/ptrace.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/ptrace.c~ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild
+++ a/kernel/ptrace.c
@@ -469,6 +469,7 @@ static int ptrace_detach(struct task_str
 	/* Architecture-specific hardware disable .. */
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+	flush_ptrace_hw_breakpoint(child);
 
 	write_lock_irq(&tasklist_lock);
 	/*
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

