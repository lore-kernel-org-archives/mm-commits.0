From: akpm@linux-foundation.org
Subject: + audit-wait_for_auditd-should-use-task_uninterruptible.patch
 added to -mm tree
Date: Wed, 29 May 2013 14:59:54 -0700
Message-ID: <51a67a5a.BXRt/slwtui8iNeg%akpm__40468.7697337524$1369864806$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228Ab3E2V7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 17:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, streeter@redhat.com, stable@vger.kernel.org, eparis@redhat.com, oleg@redhat.com

Subject: + audit-wait_for_auditd-should-use-task_uninterruptible.patch added to -mm tree
To: oleg@redhat.com,eparis@redhat.com,stable@vger.kernel.org,streeter@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 14:59:54 -0700


The patch titled
     Subject: audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE
has been added to the -mm tree.  Its filename is
     audit-wait_for_auditd-should-use-task_uninterruptible.patch

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
Subject: audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE

audit_log_start() does wait_for_auditd() in a loop until
audit_backlog_wait_time passes or audit_skb_queue has a room.

If signal_pending() is true this becomes a busy-wait loop, schedule() in
TASK_INTERRUPTIBLE won't block.

(akpm: that'll cause the system to lock up on a non-preemptible
uniprocessor kernel)

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Guy Streeter <streeter@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/audit.c~audit-wait_for_auditd-should-use-task_uninterruptible kernel/audit.c
--- a/kernel/audit.c~audit-wait_for_auditd-should-use-task_uninterruptible
+++ a/kernel/audit.c
@@ -1056,7 +1056,7 @@ static inline void audit_get_stamp(struc
 static void wait_for_auditd(unsigned long sleep_time)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	set_current_state(TASK_INTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&audit_backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
_

Patches currently in -mm which might be from oleg@redhat.com are

audit-wait_for_auditd-should-use-task_uninterruptible.patch
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
ptrace-add-ability-to-get-set-signal-blocked-mask.patch
usermodehelper-kill-the-sub_info-path-check.patch
coredump-format_corename-can-leak-cn-corename.patch
coredump-introduce-cn_vprintf.patch
coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch
coredump-kill-cn_escape-introduce-cn_esc_printf.patch
coredump-kill-call_count-add-core_name_size.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch
fs-execc-do_execve_common-use-current_user.patch

