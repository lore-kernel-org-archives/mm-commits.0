From: akpm@linux-foundation.org
Subject: + posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:32:27 -0700
Message-ID: <200808042132.m74LWRuS032011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1770658AbYHDVlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix-timers: sys_timer_create: simplify and s/tasklist/rcu/
has been added to the -mm tree.  Its filename is
     posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch

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
Subject: posix-timers: sys_timer_create: simplify and s/tasklist/rcu/
From: Oleg Nesterov <oleg@tv-sign.ru>

- Change the code to do rcu_read_lock() instead of taking tasklist_lock,
  it is safe to get_task_struct(p) if p was found under RCU.

  However, now we must not use process's sighand/signal, they may be NULL.
  We can use current->sighand/signal instead, this "process" must belong
  to the current's thread-group.

- Factor out the common code for 2 "if (timer_event_spec)" branches, the
  !timer_event_spec case can use current too.

- use spin_lock_irq() instead of _irqsave(), kill "flags".

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu
+++ a/kernel/posix-timers.c
@@ -478,7 +478,6 @@ sys_timer_create(const clockid_t which_c
 	struct k_itimer *new_timer;
 	int new_timer_id;
 	struct task_struct *process;
-	unsigned long flags;
 	sigevent_t event;
 	int it_id_set = IT_ID_NOT_SET;
 
@@ -536,16 +535,11 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_signo = event.sigev_signo;
 		new_timer->it_sigev_value = event.sigev_value;
 
-		read_lock(&tasklist_lock);
-		if ((process = good_sigevent(&event))) {
+		rcu_read_lock();
+		process = good_sigevent(&event);
+		if (process)
 			get_task_struct(process);
-			spin_lock_irqsave(&process->sighand->siglock, flags);
-			new_timer->it_process = process;
-			list_add(&new_timer->list,
-				&process->signal->posix_timers);
-			spin_unlock_irqrestore(&process->sighand->siglock, flags);
-		}
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		if (!process) {
 			error = -EINVAL;
 			goto out;
@@ -556,19 +550,18 @@ sys_timer_create(const clockid_t which_c
 		new_timer->it_sigev_value.sival_int = new_timer->it_id;
 		process = current->group_leader;
 		get_task_struct(process);
-		spin_lock_irqsave(&process->sighand->siglock, flags);
-		new_timer->it_process = process;
-		list_add(&new_timer->list, &process->signal->posix_timers);
-		spin_unlock_irqrestore(&process->sighand->siglock, flags);
 	}
 
+	spin_lock_irq(&current->sighand->siglock);
+	new_timer->it_process = process;
+	list_add(&new_timer->list, &current->signal->posix_timers);
+	spin_unlock_irq(&current->sighand->siglock);
  	/*
 	 * In the case of the timer belonging to another task, after
 	 * the task is unlocked, the timer is owned by the other task
 	 * and may cease to exist at any time.  Don't use or modify
 	 * new_timer after the unlock call.
 	 */
