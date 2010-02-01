From: akpm@linux-foundation.org
Subject: + panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:03:05 -0800
Message-ID: <201002012203.o11M36dI015175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918Ab0BAWDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:03:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, mingo@elte.hu


The patch titled
     panic: fix panic_timeout accuracy when running on a hypervisor
has been added to the -mm tree.  Its filename is
     panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor.patch

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
Subject: panic: fix panic_timeout accuracy when running on a hypervisor
From: Anton Blanchard <anton@samba.org>

I've had some complaints about panic_timeout being wildly innacurate on
shared processor PowerPC partitions (a 3 minute panic_timeout taking 30
minutes).

The problem is we loop on mdelay(1) and with a 1ms in 10ms hypervisor
timeslice each of these will take 10ms (ie 10x) longer.  I expect other
platforms with shared processor hypervisors will see the same issue.

This patch keeps the old behaviour if we have a panic_blink (only keyboard
LEDs right now) and does 1 second mdelays if we don't.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff -puN kernel/panic.c~panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor kernel/panic.c
--- a/kernel/panic.c~panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor
+++ a/kernel/panic.c
@@ -36,15 +36,36 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list
 
 EXPORT_SYMBOL(panic_notifier_list);
 
-static long no_blink(long time)
-{
-	return 0;
-}
-
 /* Returns how long it waited in ms */
 long (*panic_blink)(long time);
 EXPORT_SYMBOL(panic_blink);
 
+static void panic_blink_one_second(void)
+{
+	static long i = 0, end;
+
+	if (panic_blink) {
+		end = i + MSEC_PER_SEC;
+
+		while (i < end) {
+			i += panic_blink(i);
+			mdelay(1);
+			i++;
+		}
+	} else {
+		/*
+		 * When running under a hypervisor a small mdelay may get
+		 * rounded up to the hypervisor timeslice. For example, with
+		 * a 1ms in 10ms hypervisor timeslice we might inflate a
+		 * mdelay(1) loop by 10x.
+		 *
+		 * If we have nothing to blink, spin on 1 second calls to
+		 * mdelay to avoid this.
+		 */
+		mdelay(MSEC_PER_SEC);
+	}
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -96,9 +117,6 @@ NORET_TYPE void panic(const char * fmt, 
 
 	bust_spinlocks(0);
 
-	if (!panic_blink)
-		panic_blink = no_blink;
-
 	if (panic_timeout > 0) {
 		/*
 		 * Delay timeout seconds before rebooting the machine.
@@ -106,11 +124,9 @@ NORET_TYPE void panic(const char * fmt, 
 		 */
 		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
 
-		for (i = 0; i < panic_timeout*1000; ) {
+		for (i = 0; i < panic_timeout; i++) {
 			touch_nmi_watchdog();
-			i += panic_blink(i);
-			mdelay(1);
-			i++;
+			panic_blink_one_second();
 		}
 		/*
 		 * This will not be a clean reboot, with everything
@@ -136,11 +152,9 @@ NORET_TYPE void panic(const char * fmt, 
 	}
 #endif
 	local_irq_enable();
-	for (i = 0; ; ) {
+	while (1) {
 		touch_softlockup_watchdog();
-		i += panic_blink(i);
-		mdelay(1);
-		i++;
+		panic_blink_one_second();
 	}
 }
 
_

Patches currently in -mm which might be from anton@samba.org are

linux-next.patch
fault-injection-correct-function-names-in-documentation.patch
percpu_counter-make-__percpu_counter_add-an-inline-function-on-up.patch
sched-cpuacct-use-bigger-percpu-counter-batch-values-for-stats-counters.patch
panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor.patch
panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor-fix.patch
zlib-make-new-optimized-inflate-endian-independent.patch

