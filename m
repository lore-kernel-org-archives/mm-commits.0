From: akpm@linux-foundation.org
Subject: [merged] allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:16 -0700
Message-ID: <200906182246.n5IMkGC5005271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758292AbZFRW6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     allow_signal: kill the bogus ->mm check, add a note about CLONE_SIGHAND
has been removed from the -mm tree.  Its filename was
     allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: allow_signal: kill the bogus ->mm check, add a note about CLONE_SIGHAND
From: Oleg Nesterov <oleg@redhat.com>

allow_signal() checks ->mm == NULL.  Not sure why.  Perhaps to make sure
current is the kernel thread.  But this helper must not be used unless we
are the kernel thread, kill this check.

Also, document the fact that the CLONE_SIGHAND kthread must not use
allow_signal(), unless the caller really wants to change the parent's
->sighand->action as well.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand kernel/exit.c
--- a/kernel/exit.c~allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand
+++ a/kernel/exit.c
@@ -375,9 +375,8 @@ static void set_special_pids(struct pid 
 }
 
 /*
- * Let kernel threads use this to say that they
- * allow a certain signal (since daemonize() will
- * have disabled all of them by default).
+ * Let kernel threads use this to say that they allow a certain signal.
+ * Must not be used if kthread was cloned with CLONE_SIGHAND.
  */
 int allow_signal(int sig)
 {
@@ -385,14 +384,14 @@ int allow_signal(int sig)
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
+	/* This is only needed for daemonize()'ed kthreads */
 	sigdelset(&current->blocked, sig);
-	if (!current->mm) {
-		/* Kernel threads handle their own signals.
-		   Let the signal code know it'll be handled, so
-		   that they don't get converted to SIGKILL or
-		   just silently dropped */
-		current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	}
+	/*
+	 * Kernel threads handle their own signals. Let the signal code
+	 * know it'll be handled, so that they don't get converted to
+	 * SIGKILL or just silently dropped.
+	 */
+	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

