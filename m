From: akpm@linux-foundation.org
Subject: + generic-one-shot-bug.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:32:31 -0800
Message-ID: <200702272032.l1RKWZc0027450@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50604 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbXB0Uck (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, tglx@linutronix.de


The patch titled
     generic one-shot bug
has been added to the -mm tree.  Its filename is
     generic-one-shot-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: generic one-shot bug
From: David Miller <davem@davemloft.net>

As I suspected, the one-shot code wasn't very well tested and I'd be the
one to debug this thing on sparc64 :-)

When a timer exceeds the timer period, the one-shot handling code does
the following loop:

	for (;;) {
		ktime_t next = ktime_add(dev->next_event, tick_period);

		if (!clockevents_program_event(dev, next, ktime_get()))
			return;
		tick_periodic(cpu);
	}

So it just keeps running tick_periodic() until we "catch up".

Problem is, if clockevents_program_event() gets a "next" time in the past,
the very case where we'll loop, it DOES NOT update dev->next_event.  It
returns the error before doing so.

As a result of this, we'll loop forever here, the softlockup watchdog will
trigger, and the system will wedge completely.

I was getting a softlockup and immediate system hang, so to debug this I
kept a history of the last 8 TSC values when tick_periodic() was invoked. 
At softlockup trigger, I'd dump the log.  And what I saw were TSC deltas
that we so tiny as to be just enough to indicate tick_periodic() was
running in a tight loop :-)

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/time/tick-common.c~generic-one-shot-bug kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~generic-one-shot-bug
+++ a/kernel/time/tick-common.c
@@ -77,6 +77,7 @@ static void tick_periodic(int cpu)
 void tick_handle_periodic(struct clock_event_device *dev)
 {
 	int cpu = smp_processor_id();
+	ktime_t next;
 
 	tick_periodic(cpu);
 
@@ -86,12 +87,12 @@ void tick_handle_periodic(struct clock_e
 	 * Setup the next period for devices, which do not have
 	 * periodic mode:
 	 */
+	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
-		ktime_t next = ktime_add(dev->next_event, tick_period);
-
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;
 		tick_periodic(cpu);
+		next = ktime_add(next, tick_period);
 	}
 }
 
_

Patches currently in -mm which might be from davem@davemloft.net are

tick-schedc-build-fix.patch
generic-one-shot-bug.patch
git-net.patch
resend-iphase-64bit-cleanup.patch
simplify-the-stacktrace-code.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
ipvs-flush-defense_work-before-module-unload.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
local_t-sparc64-cleanup.patch
