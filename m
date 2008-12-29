From: akpm@linux-foundation.org
Subject: - posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:55 -0800
Message-ID: <200812291918.mBTJItZc031233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbYL2T0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:26:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: check ->it_signal instead of ->it_pid to validate the timer
has been removed from the -mm tree.  Its filename was
     posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: check ->it_signal instead of ->it_pid to validate the timer
From: Oleg Nesterov <oleg@tv-sign.ru>

->it_pid (was ->it_process) has also a special meaning: if it is NULL,
the timer is under deletion or it wasn't initialized yet. We can check
->it_signal != NULL instead, this way we can

	- simplify sys_timer_create() a bit

	- remove yet another check from lock_timer()

	- move put_pid(->it_pid) into release_posix_timer() which
	  runs outside of ->it_lock

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer
+++ a/kernel/posix-timers.c
@@ -464,6 +464,7 @@ static void release_posix_timer(struct k
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
+	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
 	kmem_cache_free(posix_timers_cache, tmr);
 }
@@ -477,7 +478,6 @@ sys_timer_create(const clockid_t which_c
 {
 	struct k_itimer *new_timer;
 	int error, new_timer_id;
-	struct pid *it_pid;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
@@ -531,9 +531,9 @@ sys_timer_create(const clockid_t which_c
 			goto out;
 		}
 		rcu_read_lock();
-		it_pid = get_pid(good_sigevent(&event));
+		new_timer->it_pid = get_pid(good_sigevent(&event));
 		rcu_read_unlock();
-		if (!it_pid) {
+		if (!new_timer->it_pid) {
 			error = -EINVAL;
 			goto out;
 		}
@@ -541,7 +541,7 @@ sys_timer_create(const clockid_t which_c
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
-		it_pid = get_pid(task_tgid(current));
+		new_timer->it_pid = get_pid(task_tgid(current));
 	}
 
 	new_timer->it_sigev_notify     = event.sigev_notify;
@@ -551,7 +551,6 @@ sys_timer_create(const clockid_t which_c
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_pid = it_pid;
 	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
@@ -587,7 +586,7 @@ static struct k_itimer *lock_timer(timer
 	timr = idr_find(&posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock(&timr->it_lock);
-		if (timr->it_pid && timr->it_signal == current->signal) {
+		if (timr->it_signal == current->signal) {
 			spin_unlock(&idr_lock);
 			return timr;
 		}
@@ -834,8 +833,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_pid(timer->it_pid);
-	timer->it_pid = NULL;
+	timer->it_signal = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -861,8 +859,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	put_pid(timer->it_pid);
-	timer->it_pid = NULL;
+	timer->it_signal = NULL;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch

