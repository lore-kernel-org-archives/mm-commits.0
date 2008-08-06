From: akpm@linux-foundation.org
Subject: - tracehook-kerneldoc-fix.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:55:49 -0700
Message-ID: <200808062055.m76Ktn1d014607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758094AbYHFU4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     tracehook: kerneldoc fix
has been removed from the -mm tree.  Its filename was
     tracehook-kerneldoc-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: kerneldoc fix
From: Roland McGrath <roland@redhat.com>

My last change to tracehook.h made it confuse the kerneldoc parser.
Move the #define's before the comment so it's happy again.

Signed-off-by: Roland McGrath <roland@redhat.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-kerneldoc-fix include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-kerneldoc-fix
+++ a/include/linux/tracehook.h
@@ -487,6 +487,9 @@ static inline int tracehook_notify_jctl(
 	return notify || (current->ptrace & PT_PTRACED);
 }
 
+#define DEATH_REAP			-1
+#define DEATH_DELAYED_GROUP_LEADER	-2
+
 /**
  * tracehook_notify_death - task is dead, ready to notify parent
  * @task:		@current task now exiting
@@ -501,8 +504,6 @@ static inline int tracehook_notify_jctl(
  *
  * Called with write_lock_irq(&tasklist_lock) held.
  */
-#define DEATH_REAP			-1
-#define DEATH_DELAYED_GROUP_LEADER	-2
 static inline int tracehook_notify_death(struct task_struct *task,
 					 void **death_cookie, int group_dead)
 {
_

Patches currently in -mm which might be from roland@redhat.com are

x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

