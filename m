From: akpm@linux-foundation.org
Subject: - posix-timers-simplify-de_thread-exit_itimers-path.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:57 -0800
Message-ID: <200812291918.mBTJIvwn031248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbYL2TTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:19:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: simplify de_thread()->exit_itimers() path
has been removed from the -mm tree.  Its filename was
     posix-timers-simplify-de_thread-exit_itimers-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: simplify de_thread()->exit_itimers() path
From: Oleg Nesterov <oleg@tv-sign.ru>

de_thread() postpones release_task(leader) until after exit_itimers().
This was needed because !SIGEV_THREAD_ID timers could use ->group_leader
without get_task_struct(). With the recent changes we can release the
leader earlier and simplify the code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Rolanda McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/exec.c~posix-timers-simplify-de_thread-exit_itimers-path fs/exec.c
--- a/fs/exec.c~posix-timers-simplify-de_thread-exit_itimers-path
+++ a/fs/exec.c
@@ -773,7 +773,6 @@ static int de_thread(struct task_struct 
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
-	struct task_struct *leader = NULL;
 	int count;
 
 	if (thread_group_empty(tsk))
@@ -811,7 +810,7 @@ static int de_thread(struct task_struct 
 	 * and to assume its PID:
 	 */
 	if (!thread_group_leader(tsk)) {
-		leader = tsk->group_leader;
+		struct task_struct *leader = tsk->group_leader;
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
@@ -863,8 +862,9 @@ static int de_thread(struct task_struct 
 
 		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
 		leader->exit_state = EXIT_DEAD;
-
 		write_unlock_irq(&tasklist_lock);
+
+		release_task(leader);
 	}
 
 	sig->group_exit_task = NULL;
@@ -873,8 +873,6 @@ static int de_thread(struct task_struct 
 no_thread_group:
 	exit_itimers(sig);
 	flush_itimer_signals();
-	if (leader)
-		release_task(leader);
 
 	if (atomic_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch

