From: akpm@linux-foundation.org
Subject: - add-task_wakekill.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:13 -0800
Message-ID: <200802012230.m11MUDBV001888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56539 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756404AbYBAWq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:46:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, oleg@tv-sign.ru, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Add TASK_WAKEKILL
has been removed from the -mm tree.  Its filename was
     add-task_wakekill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add TASK_WAKEKILL
From: Matthew Wilcox <matthew@wil.cx>

Set TASK_WAKEKILL for TASK_STOPPED and TASK_TRACED, add TASK_KILLABLE and
use TASK_WAKEKILL in signal_wake_up()

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   22 ++++++++++++++--------
 kernel/signal.c       |    8 ++++----
 2 files changed, 18 insertions(+), 12 deletions(-)

diff -puN include/linux/sched.h~add-task_wakekill include/linux/sched.h
--- a/include/linux/sched.h~add-task_wakekill
+++ a/include/linux/sched.h
@@ -170,27 +170,33 @@ print_cfs_rq(struct seq_file *m, int cpu
 #define TASK_RUNNING		0
 #define TASK_INTERRUPTIBLE	1
 #define TASK_UNINTERRUPTIBLE	2
-#define TASK_STOPPED		4
-#define TASK_TRACED		8
+#define __TASK_STOPPED		4
+#define __TASK_TRACED		8
 /* in tsk->exit_state */
 #define EXIT_ZOMBIE		16
 #define EXIT_DEAD		32
 /* in tsk->state again */
 #define TASK_DEAD		64
+#define TASK_WAKEKILL		128
+
+/* Convenience macros for the sake of set_task_state */
+#define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
+#define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
+#define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
 
 /* Convenience macros for the sake of wake_up */
 #define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
-#define TASK_ALL		(TASK_NORMAL | TASK_STOPPED | TASK_TRACED)
+#define TASK_ALL		(TASK_NORMAL | __TASK_STOPPED | __TASK_TRACED)
 
 /* get_task_state() */
 #define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
-				 TASK_UNINTERRUPTIBLE | TASK_STOPPED | \
-				 TASK_TRACED)
+				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
+				 __TASK_TRACED)
 
-#define is_task_traced(task)	((task->state & TASK_TRACED) != 0)
-#define is_task_stopped(task)	((task->state & TASK_STOPPED) != 0)
+#define is_task_traced(task)	((task->state & __TASK_TRACED) != 0)
+#define is_task_stopped(task)	((task->state & __TASK_STOPPED) != 0)
 #define is_task_stopped_or_traced(task)	\
-			((task->state & (TASK_STOPPED | TASK_TRACED)) != 0)
+			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define is_task_loadavg(task)	((task->state & TASK_UNINTERRUPTIBLE) != 0)
 
 #define __set_task_state(tsk, state_value)		\
diff -puN kernel/signal.c~add-task_wakekill kernel/signal.c
--- a/kernel/signal.c~add-task_wakekill
+++ a/kernel/signal.c
@@ -456,15 +456,15 @@ void signal_wake_up(struct task_struct *
 	set_tsk_thread_flag(t, TIF_SIGPENDING);
 
 	/*
-	 * For SIGKILL, we want to wake it up in the stopped/traced case.
-	 * We don't check t->state here because there is a race with it
+	 * For SIGKILL, we want to wake it up in the stopped/traced/killable
+	 * case. We don't check t->state here because there is a race with it
 	 * executing another processor and just now entering stopped state.
 	 * By using wake_up_state, we ensure the process will wake up and
 	 * handle its death signal.
 	 */
 	mask = TASK_INTERRUPTIBLE;
 	if (resume)
-		mask |= TASK_STOPPED | TASK_TRACED;
+		mask |= TASK_WAKEKILL;
 	if (!wake_up_state(t, mask))
 		kick_process(t);
 }
@@ -620,7 +620,7 @@ static void handle_stop_signal(int sig, 
 			 * Wake up the stopped thread _after_ setting
 			 * TIF_SIGPENDING
 			 */
-			state = TASK_STOPPED;
+			state = __TASK_STOPPED;
 			if (sig_user_defined(t, SIGCONT) && !sigismember(&t->blocked, SIGCONT)) {
 				set_tsk_thread_flag(t, TIF_SIGPENDING);
 				state |= TASK_INTERRUPTIBLE;
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
hash-add-explicit-u32-and-u64-versions-of-hash.patch
make-sure-nobodys-leaking-resources.patch
