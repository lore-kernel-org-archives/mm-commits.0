From: akpm@linux-foundation.org
Subject: + wait-introduce-prepare_to_wait_event.patch added to -mm tree
Date: Mon, 10 Jun 2013 16:13:27 -0700
Message-ID: <51b65d97.Uumtlx6J7419CUCN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3FJXN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 19:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lczerner@redhat.com, imre.deak@intel.com, daniel.vetter@ffwll.ch, oleg@redhat.com

Subject: + wait-introduce-prepare_to_wait_event.patch added to -mm tree
To: oleg@redhat.com,daniel.vetter@ffwll.ch,imre.deak@intel.com,lczerner@redhat.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 16:13:27 -0700


The patch titled
     Subject: wait: introduce prepare_to_wait_event()
has been added to the -mm tree.  Its filename is
     wait-introduce-prepare_to_wait_event.patch

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
Subject: wait: introduce prepare_to_wait_event()

Add the new helper, prepare_to_wait_event() which should only be used by
wait_event_common/etc.

prepare_to_wait_event() returns -ERESTARTSYS if signal_pending_state() is
true, otherwise it calls prepare_to_wait().  This allows to uninline the
signal-pending checks in wait_event_*.

Also, it can initialize wait->private/func.  We do not care they were
already initialized, the values are the same.  This also shaves a couple
of insns from the inlined code.

Unlike the previous change, this patch "reliably" shrinks the size of
generated code for every wait_event*() call.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   22 +++++++++++-----------
 kernel/wait.c        |   13 +++++++++++++
 2 files changed, 24 insertions(+), 11 deletions(-)

diff -puN include/linux/wait.h~wait-introduce-prepare_to_wait_event include/linux/wait.h
--- a/include/linux/wait.h~wait-introduce-prepare_to_wait_event
+++ a/include/linux/wait.h
@@ -182,28 +182,27 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define __wait_no_timeout(tout)	\
 	(__builtin_constant_p(tout) && (tout) == MAX_SCHEDULE_TIMEOUT)
 
-/* uglified signal_pending_state() optimized for constant state */
-#define __wait_signal_pending(state)					\
-	((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
-	 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
-	  0)
+#define __wait_interruptible(state)					\
+	(!__builtin_constant_p(state) ||				\
+	 	state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)
 
 #define __wait_event_common(wq, condition, state, tout)			\
 ({									\
-	DEFINE_WAIT(__wait);						\
-	long __ret = 0, __tout = tout;					\
+	long __ret, __tout = tout;					\
+	wait_queue_t __wait;						\
+									\
+	INIT_LIST_HEAD(&__wait.task_list);				\
+	__wait.flags = 0;						\
 									\
 	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, state);			\
+		__ret = prepare_to_wait_event(&wq, &__wait, state);	\
 		if (condition) {					\
 			__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
 			break;						\
 		}							\
 									\
-		if (__wait_signal_pending(state)) {			\
-			__ret = -ERESTARTSYS;				\
+		if (__wait_interruptible(state) && __ret)		\
 			break;						\
-		}							\
 									\
 		if (__wait_no_timeout(tout))				\
 			schedule();					\
@@ -787,6 +786,7 @@ extern long interruptible_sleep_on_timeo
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
 void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
+int prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
 void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
diff -puN kernel/wait.c~wait-introduce-prepare_to_wait_event kernel/wait.c
--- a/kernel/wait.c~wait-introduce-prepare_to_wait_event
+++ a/kernel/wait.c
@@ -78,6 +78,19 @@ prepare_to_wait(wait_queue_head_t *q, wa
 }
 EXPORT_SYMBOL(prepare_to_wait);
 
+int prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
+{
+	if (signal_pending_state(state, current))
+		return -ERESTARTSYS;
+
+	wait->private = current;
+	wait->func = autoremove_wake_function;
+	prepare_to_wait(q, wait, state);
+
+	return 0;
+}
+EXPORT_SYMBOL(prepare_to_wait_event);
+
 void
 prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
audit-wait_for_auditd-should-use-task_uninterruptible.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
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
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix.patch
fs-execc-do_execve_common-use-current_user.patch
wait-introduce-wait_event_commonwq-condition-state-timeout.patch
wait-introduce-prepare_to_wait_event.patch

