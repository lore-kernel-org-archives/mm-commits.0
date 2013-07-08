From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:36:01 -0700
Message-ID: <51db14a1.zLRPsLZx2bMFyMO7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GHTgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tsmetana@redhat.com, tjanouse@redhat.com, johnstul@us.ibm.com, ebiederm@xmission.com, oleg@redhat.com

Subject: [merged] fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime.patch removed from -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,johnstul@us.ibm.com,tjanouse@redhat.com,tsmetana@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:01 -0700


The patch titled
     Subject: fs/proc/uptime.c:uptime_proc_show(): use get_monotonic_boottime()
has been removed from the -mm tree.  Its filename was
     fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/uptime.c:uptime_proc_show(): use get_monotonic_boottime()

Change uptime_proc_show() to use get_monotonic_boottime() instead of
do_posix_clock_monotonic_gettime() + monotonic_to_bootbased().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Tomas Janousek <tjanouse@redhat.com>
Cc: Tomas Smetana <tsmetana@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/uptime.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/uptime.c~fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime fs/proc/uptime.c
--- a/fs/proc/uptime.c~fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime
+++ a/fs/proc/uptime.c
@@ -20,8 +20,7 @@ static int uptime_proc_show(struct seq_f
 	for_each_possible_cpu(i)
 		idletime += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
 
-	do_posix_clock_monotonic_gettime(&uptime);
-	monotonic_to_bootbased(&uptime);
+	get_monotonic_boottime(&uptime);
 	nsec = cputime64_to_jiffies64(idletime) * TICK_NSEC;
 	idle.tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
 	idle.tv_nsec = rem;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
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
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

