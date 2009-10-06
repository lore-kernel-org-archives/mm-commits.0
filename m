From: akpm@linux-foundation.org
Subject: + posix-cpu-timers-optimize-and-document-timer_create-callback.patch added to -mm tree
Date: Tue, 06 Oct 2009 15:04:05 -0700
Message-ID: <200910062204.n96M45LH031488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933444AbZJFWFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 18:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de


The patch titled
     posix-cpu-timers: optimize and document timer_create callback
has been added to the -mm tree.  Its filename is
     posix-cpu-timers-optimize-and-document-timer_create-callback.patch

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
Subject: posix-cpu-timers: optimize and document timer_create callback
From: Stanislaw Gruszka <sgruszka@redhat.com>

We have already new_timer initialized to all-zeros hence in function
initializations are not needed. Document function expectation about
new_timer argument as well.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix-cpu-timers-optimize-and-document-timer_create-callback kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-cpu-timers-optimize-and-document-timer_create-callback
+++ a/kernel/posix-cpu-timers.c
@@ -384,7 +384,8 @@ int posix_cpu_clock_get(const clockid_t 
 
 /*
  * Validate the clockid_t for a new CPU-clock timer, and initialize the timer.
- * This is called from sys_timer_create with the new timer already locked.
+ * This is called from sys_timer_create() and do_cpu_nanosleep() with the
+ * new timer already all-zeros initialized.
  */
 int posix_cpu_timer_create(struct k_itimer *new_timer)
 {
@@ -396,8 +397,6 @@ int posix_cpu_timer_create(struct k_itim
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
-	new_timer->it.cpu.incr.sched = 0;
-	new_timer->it.cpu.expires.sched = 0;
 
 	read_lock(&tasklist_lock);
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
_

Patches currently in -mm which might be from sgruszka@redhat.com are

itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch

