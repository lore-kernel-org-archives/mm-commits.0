From: akpm@linux-foundation.org
Subject: + tracehook-kerneldoc-fix.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:12:12 -0700
Message-ID: <200808042112.m74LCCK9031085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269AbYHDVNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:13:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, randy.dunlap@oracle.com


The patch titled
     tracehook: kerneldoc fix
has been added to the -mm tree.  Its filename is
     tracehook-kerneldoc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
semaphore-__down_common-use-signal_pending_state.patch
tracehook-kerneldoc-fix.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

