From: akpm@linux-foundation.org
Subject: [merged]
 posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:46 -0700
Message-ID: <51db150a.oboFiaxqm/TSl+xp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3GHThr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, sgruszka@redhat.com, oleg@redhat.com, mingo@elte.hu, gang.chen@asianux.com, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com

Subject: [merged] posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch removed from -mm tree
To: fweisbec@gmail.com,a.p.zijlstra@chello.nl,akpm@linux-foundation.org,gang.chen@asianux.com,mingo@elte.hu,oleg@redhat.com,sgruszka@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:46 -0700


The patch titled
     Subject: posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()
has been removed from the -mm tree.  Its filename was
     posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()

In order to re-arm a timer after it fired, we take a sample of the current
process or thread cputime.

If the task is dying though, we don't arm anything but we cache the
remaining timer expiration delta for further reads.

Something similar is performed in posix_cpu_timer_get() but here we forget
to take the process wide cputime sample before caching it.

As a result we are storing random stack content, leading every further
reads of that timer to return junk values.

Fix this by taking the appropriate sample in the case of process wide
timers.

This probably doesn't matter much in practice because, at this stage, the
thread is the last one in the group and we reached exit_notify().  This
implies that we called exit_itimers() and there should be no more timers
to handle for that task.

So this is likely dead code anyway but let's fix the current logic
and the warning that came along:

    kernel/posix-cpu-timers.c: In function 'posix_cpu_timer_schedule':
    kernel/posix-cpu-timers.c:1127: warning: 'now' may be used uninitialized in this function

Then we can start to think further about cleaning up that code.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/posix-cpu-timers.c~posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule
+++ a/kernel/posix-cpu-timers.c
@@ -1097,6 +1097,7 @@ void posix_cpu_timer_schedule(struct k_i
 			 * not yet reaped.  Take this opportunity to
 			 * drop our task ref.
 			 */
+			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
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

