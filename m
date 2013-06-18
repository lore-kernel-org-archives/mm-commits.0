From: akpm@linux-foundation.org
Subject: [failures]
 wait-introduce-wait_event_commonwq-condition-state-timeout.patch removed
 from -mm tree
Date: Tue, 18 Jun 2013 15:07:45 -0700
Message-ID: <51c0da31.kLFPL61gEgsjBdek%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481Ab3FRWHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 18:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lczerner@redhat.com, imre.deak@intel.com, daniel.vetter@ffwll.ch, oleg@redhat.com

Subject: [failures] wait-introduce-wait_event_commonwq-condition-state-timeout.patch removed from -mm tree
To: oleg@redhat.com,daniel.vetter@ffwll.ch,imre.deak@intel.com,lczerner@redhat.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 15:07:45 -0700


The patch titled
     Subject: wait: introduce wait_event_common(wq, condition, state, timeout)
has been removed from the -mm tree.  Its filename was
     wait-introduce-wait_event_commonwq-condition-state-timeout.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: wait: introduce wait_event_common(wq, condition, state, timeout)

To remind, I think that 4c663cfc "wait: fix false timeouts when using
wait_event_timeout()" is not enough, wait(wq, true, 0) still returns zero.

But to me the main problem is that wait_event* macros duplicate the same
code again and again.  Imho it would be nice to create a single helper. 
To simplify the review, this is the code after 1/2:

#define __wait_no_timeout(tout)	\
	(__builtin_constant_p(tout) && (tout) == MAX_SCHEDULE_TIMEOUT)

/* uglified signal_pending_state() optimized for constant state */
#define __wait_signal_pending(state)					\
	((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
	 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
	  0)

#define __wait_event_common(wq, condition, state, tout)			\
({									\
	DEFINE_WAIT(__wait);						\
	long __ret = 0, __tout = tout;					\
									\
	for (;;) {							\
		prepare_to_wait(&wq, &__wait, state);			\
		if (condition) {					\
			__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
			break;						\
		}							\
									\
		if (__wait_signal_pending(state)) {			\
			__ret = -ERESTARTSYS;				\
			break;						\
		}							\
									\
		if (__wait_no_timeout(tout))				\
			schedule();					\
		else if (__tout)					\
			__tout = schedule_timeout(__tout);		\
		else							\
			break;						\
	}								\
	finish_wait(&wq, &__wait);					\
	__ret;								\
})

#define wait_event_common(wq, condition, state, tout)			\
({									\
	long __ret;							\
	if (condition)							\
		__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;		\
	else								\
		__ret = __wait_event_common(wq, condition, state, tout);\
	__ret;								\
})

2/2 doesn't look like a cleanup. But personally I think that it makes
sense to shrink .text,

	-	4977769 2930984 10104832        18013585        112dd91 vmlinux
	+	4976847	2930984	10104832	18012663	112d9f7	vmlinux

on my build.



This patch:

1. wait_event_timeout(wq, true, 0) returns zero, I think this is
   wrong and should be fixed.

   __wait_event_timeout() was already changed by 4c663cfc but we
   need the same logic in wait_event_timeout() if the fast-path
   check succeeds.

2. wait_event_timeout/__wait_event_timeout interface do not match
   wait_event(), you can't use __wait_event_timeout() instead of
   wait_event_timeout() if you do not need the fast-path check.

3. wait_event_* macros duplicate the same code.

This patch adds a single helper wait_event_common() which hopefully
does everything right. Compiler optimizes out the "dead" code when
we do not need signal_pending/schedule_timeout.

With this patch "size vmlinux" reports that .text/data shrinks but
I think this depends on gcc/config.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |  183 +++++++++++++++--------------------------
 1 file changed, 71 insertions(+), 112 deletions(-)

diff -puN include/linux/wait.h~wait-introduce-wait_event_commonwq-condition-state-timeout include/linux/wait.h
--- a/include/linux/wait.h~wait-introduce-wait_event_commonwq-condition-state-timeout
+++ a/include/linux/wait.h
@@ -179,18 +179,52 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
-#define __wait_event(wq, condition) 					\
-do {									\
+#define __wait_no_timeout(tout)	\
+	(__builtin_constant_p(tout) && (tout) == MAX_SCHEDULE_TIMEOUT)
+
+/* uglified signal_pending_state() optimized for constant state */
+#define __wait_signal_pending(state)					\
+	((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
+	 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
+	  0)
+
+#define __wait_event_common(wq, condition, state, tout)			\
+({									\
 	DEFINE_WAIT(__wait);						\
+	long __ret = 0, __tout = tout;					\
 									\
 	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
+		prepare_to_wait(&wq, &__wait, state);			\
+		if (condition) {					\
+			__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
+			break;						\
+		}							\
+									\
+		if (__wait_signal_pending(state)) {			\
+			__ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+									\
+		if (__wait_no_timeout(tout))				\
+			schedule();					\
+		else if (__tout)					\
+			__tout = schedule_timeout(__tout);		\
+		else							\
 			break;						\
-		schedule();						\
 	}								\
 	finish_wait(&wq, &__wait);					\
-} while (0)
+	__ret;								\
+})
+
+#define wait_event_common(wq, condition, state, tout)			\
+({									\
+	long __ret;							\
+	if (condition)							\
+		__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;		\
+	else								\
+		__ret = __wait_event_common(wq, condition, state, tout);\
+	__ret;								\
+})
 
 /**
  * wait_event - sleep until a condition gets true
@@ -204,29 +238,13 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  */
-#define wait_event(wq, condition) 					\
-do {									\
-	if (condition)	 						\
-		break;							\
-	__wait_event(wq, condition);					\
-} while (0)
-
-#define __wait_event_timeout(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		ret = schedule_timeout(ret);				\
-		if (!ret)						\
-			break;						\
-	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event(wq, condition)					\
+	__wait_event_common(wq, condition,				\
+			TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)	\
+
+#define wait_event(wq, condition)					\
+	wait_event_common(wq, condition,				\
+			TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)	\
 
 /**
  * wait_event_timeout - sleep until a condition gets true or a timeout elapses
@@ -245,31 +263,13 @@ do {									\
  * jiffies (at least 1) if the @condition evaluated to %true before
  * the @timeout elapsed.
  */
-#define wait_event_timeout(wq, condition, timeout)			\
-({									\
-	long __ret = timeout;						\
-	if (!(condition)) 						\
-		__wait_event_timeout(wq, condition, __ret);		\
-	__ret;								\
-})
+#define __wait_event_timeout(wq, condition, timeout)			\
+	__wait_event_common(wq, condition,				\
+			TASK_UNINTERRUPTIBLE, timeout)
 
-#define __wait_event_interruptible(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (!signal_pending(current)) {				\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define wait_event_timeout(wq, condition, timeout)			\
+	wait_event_common(wq, condition,				\
+			TASK_UNINTERRUPTIBLE, timeout)
 
 /**
  * wait_event_interruptible - sleep until a condition gets true
@@ -286,35 +286,13 @@ do {									\
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible(wq, condition)				\
-({									\
-	int __ret = 0;							\
-	if (!(condition))						\
-		__wait_event_interruptible(wq, condition, __ret);	\
-	__ret;								\
-})
+#define __wait_event_interruptible(wq, condition)			\
+	__wait_event_common(wq, condition,				\
+			TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)
 
-#define __wait_event_interruptible_timeout(wq, condition, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (!signal_pending(current)) {				\
-			ret = schedule_timeout(ret);			\
-			if (!ret)					\
-				break;					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define wait_event_interruptible(wq, condition)				\
+	wait_event_common(wq, condition,				\
+			TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)
 
 /**
  * wait_event_interruptible_timeout - sleep until a condition gets true or a timeout elapses
@@ -334,13 +312,13 @@ do {									\
  * a signal, or the remaining jiffies (at least 1) if the @condition
  * evaluated to %true before the @timeout elapsed.
  */
+#define __wait_event_interruptible_timeout(wq, condition, timeout)	\
+	__wait_event_common(wq, condition,				\
+			TASK_INTERRUPTIBLE, timeout)
+
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
-({									\
-	long __ret = timeout;						\
-	if (!(condition))						\
-		__wait_event_interruptible_timeout(wq, condition, __ret); \
-	__ret;								\
-})
+	wait_event_common(wq, condition,				\
+			TASK_INTERRUPTIBLE, timeout)
 
 #define __wait_event_hrtimeout(wq, condition, timeout, state)		\
 ({									\
@@ -607,24 +585,6 @@ do {									\
 
 
 
-#define __wait_event_killable(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_KILLABLE);		\
-		if (condition)						\
-			break;						\
-		if (!fatal_signal_pending(current)) {			\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
-
 /**
  * wait_event_killable - sleep until a condition gets true
  * @wq: the waitqueue to wait on
@@ -640,14 +600,13 @@ do {									\
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_killable(wq, condition)				\
-({									\
-	int __ret = 0;							\
-	if (!(condition))						\
-		__wait_event_killable(wq, condition, __ret);		\
-	__ret;								\
-})
+#define __wait_event_killable(wq, condition)				\
+	__wait_event_common(wq, condition,				\
+			TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT)
 
+#define wait_event_killable(wq, condition)				\
+	wait_event_common(wq, condition,				\
+			TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT)
 
 #define __wait_event_lock_irq(wq, condition, lock, cmd)			\
 do {									\
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
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
wait-introduce-prepare_to_wait_event.patch

