From: akpm@linux-foundation.org
Subject: - posix-timers-sys_timer_create-cleanup-the-error-handling.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:43 -0700
Message-ID: <200810092227.m99MRhUa006007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbYJIW2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: sys_timer_create: cleanup the error handling
has been removed from the -mm tree.  Its filename was
     posix-timers-sys_timer_create-cleanup-the-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-timers: sys_timer_create: cleanup the error handling
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup.

- sys_timer_create() is big and complicated. The code above the "out:"
  label relies on the fact that "error" must be == 0. This is not very
  robust, make the code more explicit. Remove the unneeded initialization
  of error.

- If idr_get_new() succeeds (as it normally should), we check the returned
  value twice. Move the "-EAGAIN" check under "if (error)".

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-sys_timer_create-cleanup-the-error-handling kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-sys_timer_create-cleanup-the-error-handling
+++ a/kernel/posix-timers.c
@@ -469,7 +469,7 @@ sys_timer_create(const clockid_t which_c
 		 struct sigevent __user *timer_event_spec,
 		 timer_t __user * created_timer_id)
 {
-	int error = 0;
+	int error;
 	struct k_itimer *new_timer;
 	int new_timer_id;
 	struct task_struct *process;
@@ -493,9 +493,9 @@ sys_timer_create(const clockid_t which_c
 	error = idr_get_new(&posix_timers_id, (void *) new_timer,
 			    &new_timer_id);
 	spin_unlock_irq(&idr_lock);
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error) {
+	if (error) {
+		if (error == -EAGAIN)
+			goto retry;
 		/*
 		 * Weird looking, but we return EAGAIN if the IDR is
 		 * full (proper POSIX return value for this)
@@ -556,6 +556,8 @@ sys_timer_create(const clockid_t which_c
 	new_timer->it_process = process;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
+
+	return 0;
  	/*
 	 * In the case of the timer belonging to another task, after
 	 * the task is unlocked, the timer is owned by the other task
@@ -563,9 +565,7 @@ sys_timer_create(const clockid_t which_c
 	 * new_timer after the unlock call.
 	 */
 out:
-	if (error)
-		release_posix_timer(new_timer, it_id_set);
