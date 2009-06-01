From: akpm@linux-foundation.org
Subject: + time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load.patch added to -mm tree
Date: Mon, 01 Jun 2009 16:32:19 -0700
Message-ID: <200906012332.n51NWJ8d016597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbZFAXdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 19:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arve@android.com, a.p.zijlstra@chello.nl, mingo@elte.hu, rmk@arm.linux.org.uk, swetland@google.com, tglx@linutronix.de


The patch titled
     time: nohz: fix ondemand governor not always ramping up on 100% load.
has been added to the -mm tree.  Its filename is
     time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load.patch

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
Subject: time: nohz: fix ondemand governor not always ramping up on 100% load.
From: Arve Hjonnevag <arve@android.com>

On systems that perform the context switch with interrupts enabled (e.g. 
ARM) get_cpu_idle_time_us could get stuck returning the last idle time
when the cpu is busy.  If an interrupt occurs while switching to the idle
thread, and this interrupt wakes up a thread, need-resched will be set on
the idle thread, but since we have not finished switching to the idle
thread tick_nohz_stop_sched_tick will be called.  (idle_cpu is true since
the head of the runqueue is the idle thread, but need_resched returns
false since we are still running in the context of the old thread)

Fix this by not calling tick_nohz_start_idle when returning from an
interrupt while the idle thread is in its schedule phase.  (!ts->inidle)

Signed-off-by: Arve Hjonnevag <arve@android.com>
Cc: Brian Sewtland <swetland@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load
+++ a/kernel/time/tick-sched.c
@@ -224,7 +224,6 @@ void tick_nohz_stop_sched_tick(int inidl
 
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
-	now = tick_nohz_start_idle(ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
@@ -244,6 +243,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	if (!inidle && !ts->inidle)
 		goto end;
 
+	now = tick_nohz_start_idle(ts);
 	ts->inidle = 1;
 
 	if (need_resched())
_

Patches currently in -mm which might be from arve@android.com are

linux-next.patch
time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load.patch

