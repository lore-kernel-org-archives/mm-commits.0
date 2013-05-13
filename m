From: akpm@linux-foundation.org
Subject: + ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch added to -mm tree
Date: Mon, 13 May 2013 16:07:17 -0700
Message-ID: <20130513230717.ED14F5A4211@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:38596 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:07:19 -0400
Received: by mail-ve0-f202.google.com with SMTP id 14so265956vea.1
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:07:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/x86: flush_ptrace_hw_breakpoint() shoule clear the virtual debug registers
has been added to the -mm tree.  Its filename is
     ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch

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

