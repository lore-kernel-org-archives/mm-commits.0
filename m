From: akpm@linux-foundation.org
Subject: + posix_timer-move-copy_to_usercreated_timer_id-down-in-timer_create.patch added to -mm tree
Date: Thu, 20 May 2010 12:32:08 -0700
Message-ID: <201005201932.o4KJW89o000396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830Ab0ETTc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 15:32:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, oleg@tv-sign.ru, sgruszka@redhat.com, tglx@linutronix.de, xemul@openvz.org


The patch titled
     posix_timer: move copy_to_user(created_timer_id) down in timer_create()
has been added to the -mm tree.  Its filename is
     posix_timer-move-copy_to_usercreated_timer_id-down-in-timer_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix_timer: move copy_to_user(created_timer_id) down in timer_create()
From: Andrey Vagin <avagin@openvz.org>

According to Oleg Nesterov:
We can move copy_to_user(created_timer_id) down after
"if (timer_event_spec)" block too. (but before CLOCK_DISPATCH(),
of course).

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/posix-timers.c~posix_timer-move-copy_to_usercreated_timer_id-down-in-timer_create kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix_timer-move-copy_to_usercreated_timer_id-down-in-timer_create
+++ a/kernel/posix-timers.c
@@ -560,11 +560,6 @@ SYSCALL_DEFINE3(timer_create, const cloc
 	new_timer->it_clock = which_clock;
 	new_timer->it_overrun = -1;
 
-	if (copy_to_user(created_timer_id,
-			 &new_timer_id, sizeof (new_timer_id))) {
-		error = -EFAULT;
-		goto out;
-	}
 	if (timer_event_spec) {
 		if (copy_from_user(&event, timer_event_spec, sizeof (event))) {
 			error = -EFAULT;
@@ -590,6 +585,12 @@ SYSCALL_DEFINE3(timer_create, const cloc
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
+	if (copy_to_user(created_timer_id,
+			 &new_timer_id, sizeof (new_timer_id))) {
+		error = -EFAULT;
+		goto out;
+	}
+
 	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
 	if (error)
 		goto out;
_

Patches currently in -mm which might be from avagin@openvz.org are

posix_timer-remove-wrong-comment.patch
posix_timer-fix-error-path-in-timer_create.patch
posix_timer-move-copy_to_usercreated_timer_id-down-in-timer_create.patch

