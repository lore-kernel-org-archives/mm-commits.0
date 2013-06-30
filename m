From: akpm@linux-foundation.org
Subject: [withdrawn] wait-introduce-prepare_to_wait_event.patch removed
 from -mm tree
Date: Sun, 30 Jun 2013 13:15:59 -0700
Message-ID: <51d091ff.fGEoUsVxkwy7tNrw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3F3UQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 30 Jun 2013 16:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lczerner@redhat.com, imre.deak@intel.com, daniel.vetter@ffwll.ch, oleg@redhat.com

Subject: [withdrawn] wait-introduce-prepare_to_wait_event.patch removed from -mm tree
To: oleg@redhat.com,daniel.vetter@ffwll.ch,imre.deak@intel.com,lczerner@redhat.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Sun, 30 Jun 2013 13:15:59 -0700


The patch titled
     Subject: wait: introduce prepare_to_wait_event()
has been removed from the -mm tree.  Its filename was
     wait-introduce-prepare_to_wait_event.patch

This patch was dropped because it was withdrawn

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
generated code for every wait_event*() call,

	-	4977769 2930984 10104832        18013585        112dd91 vmlinux
	+	4976847	2930984	10104832	18012663	112d9f7	vmlinux

on my build.

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
@@ -182,19 +182,20 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define __wait_no_timeout(tout)	\
 	(__builtin_constant_p(tout) && (tout) == MAX_SCHEDULE_TIMEOUT)
 
-/* uglified signal_pending_state() optimized for constant state */
-#define __wait_signal_pending(state)					\
-	((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
-	 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
-	  0)
+#define __wait_interruptible(state)					\
+	(!__builtin_constant_p(state) ||				\
+		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)
 
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
 			__ret = __wait_no_timeout(tout);		\
 			if (!__ret)					\
@@ -204,10 +205,8 @@ wait_queue_head_t *bit_waitqueue(void *,
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
@@ -791,6 +790,7 @@ extern long interruptible_sleep_on_timeo
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

origin.patch
linux-next.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
vfree-dont-schedule-free_work-if-llist_add-returns-false.patch
kernel-sysc-do_sysinfo-use-get_monotonic_boottime.patch
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
signals-eventpoll-do-not-use-sigprocmask.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
usermodehelper-kill-the-sub_info-path-check.patch
coredump-format_corename-can-leak-cn-corename.patch
coredump-introduce-cn_vprintf.patch
coredump-cn_vprintf-has-no-reason-to-call-vsnprintf-twice.patch
coredump-kill-cn_escape-introduce-cn_esc_printf.patch
coredump-kill-call_count-add-core_name_size.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic.patch
coredump-%-at-the-end-shouldnt-bypass-core_uses_pid-logic-fix.patch
fs-execc-de_thread-use-change_pid-rather-than-detach_pid-attach_pid.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exitc-unexport-__set_special_pids.patch
fs-proc-uptimec-uptime_proc_show-use-get_monotonic_boottime.patch
kernel-forkc-copy_process-unify-clone_thread-or-thread_group_leader-code.patch
kernel-forkc-copy_process-dont-add-the-uninitialized-child-to-thread-task-pid-lists.patch
kernel-forkc-copy_process-consolidate-the-lockless-clone_thread-checks.patch
fs-execc-do_execve_common-use-current_user.patch
fs-execc-de_thread-mt-exec-should-update-real_start_time.patch

