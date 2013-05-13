From: akpm@linux-foundation.org
Subject: + ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch added to -mm tree
Date: Mon, 13 May 2013 16:07:14 -0700
Message-ID: <20130513230715.133D15A4211@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:50792 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:07:16 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so50302qeb.1
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:07:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace: PTRACE_DETACH should do flush_ptrace_hw_breakpoint(child)
has been added to the -mm tree.  Its filename is
     ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
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
x86-kill-tif_debug.patch

