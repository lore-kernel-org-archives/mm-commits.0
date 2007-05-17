From: akpm@linux-foundation.org
Subject: + recalc_sigpending_tsk-fixes.patch added to -mm tree
Date: Thu, 17 May 2007 11:52:26 -0700
Message-ID: <200705171852.l4HIqQ78030416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbXEQSzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, Steve.Hawkes@motorola.com, akpm@linux-foundation.org, oleg@tv-sign.ru


The patch titled
     recalc_sigpending_tsk fixes
has been added to the -mm tree.  Its filename is
     recalc_sigpending_tsk-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: recalc_sigpending_tsk fixes
From: Roland McGrath <roland@redhat.com>

Steve Hawkes discovered a problem where recalc_sigpending_tsk was called in
do_sigaction but no signal_wake_up call was made, preventing later signals
from waking up blocked threads with TIF_SIGPENDING already set.

In fact, the few other calls to recalc_sigpending_tsk outside the signals
code are also subject to this problem in other race conditions.

This change makes recalc_sigpending_tsk private to the signals code.  It
changes the outside calls, as well as do_sigaction, to use the new
recalc_sigpending_and_wake instead.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: <Steve.Hawkes@motorola.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h  |   12 +++++++-----
 kernel/exit.c          |    7 ++-----
 kernel/power/process.c |    2 +-
 kernel/signal.c        |   24 ++++++++++++++++++------
 4 files changed, 28 insertions(+), 17 deletions(-)

diff -puN include/linux/sched.h~recalc_sigpending_tsk-fixes include/linux/sched.h
--- a/include/linux/sched.h~recalc_sigpending_tsk-fixes
+++ a/include/linux/sched.h
@@ -1615,11 +1615,13 @@ static inline int lock_need_resched(spin
 	return 0;
 }
 
-/* Reevaluate whether the task has signals pending delivery.
-   This is required every time the blocked sigset_t changes.
-   callers must hold sighand->siglock.  */
-
-extern FASTCALL(void recalc_sigpending_tsk(struct task_struct *t));
+/*
+ * Reevaluate whether the task has signals pending delivery.
+ * Wake the task if so.
+ * This is required every time the blocked sigset_t changes.
+ * callers must hold sighand->siglock.
+ */
+extern void recalc_sigpending_and_wake(struct task_struct *t);
 extern void recalc_sigpending(void);
 
 extern void signal_wake_up(struct task_struct *t, int resume_stopped);
diff -puN kernel/exit.c~recalc_sigpending_tsk-fixes kernel/exit.c
--- a/kernel/exit.c~recalc_sigpending_tsk-fixes
+++ a/kernel/exit.c
@@ -762,11 +762,8 @@ static void exit_notify(struct task_stru
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		for (t = next_thread(tsk); t != tsk; t = next_thread(t))
-			if (!signal_pending(t) && !(t->flags & PF_EXITING)) {
-				recalc_sigpending_tsk(t);
-				if (signal_pending(t))
-					signal_wake_up(t, 0);
-			}
+			if (!signal_pending(t) && !(t->flags & PF_EXITING))
+				recalc_sigpending_and_wake(t);
 		spin_unlock_irq(&tsk->sighand->siglock);
 		read_unlock(&tasklist_lock);
 	}
diff -puN kernel/power/process.c~recalc_sigpending_tsk-fixes kernel/power/process.c
--- a/kernel/power/process.c~recalc_sigpending_tsk-fixes
+++ a/kernel/power/process.c
@@ -81,7 +81,7 @@ static void cancel_freezing(struct task_
 		pr_debug("  clean up: %s\n", p->comm);
 		do_not_freeze(p);
 		spin_lock_irqsave(&p->sighand->siglock, flags);
-		recalc_sigpending_tsk(p);
+		recalc_sigpending_and_wake(p);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
diff -puN kernel/signal.c~recalc_sigpending_tsk-fixes kernel/signal.c
--- a/kernel/signal.c~recalc_sigpending_tsk-fixes
+++ a/kernel/signal.c
@@ -96,15 +96,27 @@ static inline int has_pending_signals(si
 
 #define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
 
-fastcall void recalc_sigpending_tsk(struct task_struct *t)
+static int recalc_sigpending_tsk(struct task_struct *t)
 {
 	if (t->signal->group_stop_count > 0 ||
 	    (freezing(t)) ||
 	    PENDING(&t->pending, &t->blocked) ||
-	    PENDING(&t->signal->shared_pending, &t->blocked))
+	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
-	else
-		clear_tsk_thread_flag(t, TIF_SIGPENDING);
+		return 1;
+	}
+	clear_tsk_thread_flag(t, TIF_SIGPENDING);
+	return 0;
+}
+
+/*
+ * After recalculating TIF_SIGPENDING, we need to make sure the task wakes up.
+ * This is superfluous when called on current, the wakeup is a harmless no-op.
+ */
+void recalc_sigpending_and_wake(struct task_struct *t)
+{
+	if (recalc_sigpending_tsk(t))
+		signal_wake_up(t, 0);
 }
 
 void recalc_sigpending(void)
@@ -744,7 +756,7 @@ force_sig_info(int sig, struct siginfo *
 		action->sa.sa_handler = SIG_DFL;
 		if (blocked) {
 			sigdelset(&t->blocked, sig);
-			recalc_sigpending_tsk(t);
+			recalc_sigpending_and_wake(t);
 		}
 	}
 	ret = specific_send_sig_info(sig, info, t);
@@ -2273,7 +2285,7 @@ int do_sigaction(int sig, struct k_sigac
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
 			do {
 				rm_from_queue_full(&mask, &t->pending);
-				recalc_sigpending_tsk(t);
+				recalc_sigpending_and_wake(t);
 				t = next_thread(t);
 			} while (t != current);
 		}
_

Patches currently in -mm which might be from roland@redhat.com are

x86-use-elfnoteh-to-generate-vsyscall-notes.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
recalc_sigpending_tsk-fixes.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
