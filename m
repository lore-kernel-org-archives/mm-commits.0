From: akpm@linux-foundation.org
Subject: +
 watchdog-softlockup-enforce-that-timestamp-is-valid-on-boot.patch added to
 -mm tree
Date: Thu, 16 Jan 2020 17:58:43 -0800
Message-ID: <20200117015843.T-2W7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgAQB6p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jan 2020 20:58:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will@kernel.org, rrichter@marvell.com, rppt@linux.ibm.com, pmladek@suse.com, peterz@infradead.org, mingo@kernel.org, longman@redhat.com, keescook@chromium.org, catalin.marinas@arm.com, tglx@linutronix.de


The patch titled
     Subject: watchdog/softlockup: enforce that timestamp is valid on boot
has been added to the -mm tree.  Its filename is
     watchdog-softlockup-enforce-that-timestamp-is-valid-on-boot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-softlockup-enforce-that-timestamp-is-valid-on-boot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-softlockup-enforce-that-timestamp-is-valid-on-boot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: watchdog/softlockup: enforce that timestamp is valid on boot

Robert reported that during boot the watchdog timestamp is set to 0 for
one second which is the indicator for a watchdog reset.

The reason for this is that the timestamp is in seconds and the time is
taken from sched clock and divided by ~1e9.  sched clock starts at 0 which
means that for the first second during boot the watchdog timestamp is 0,
i.e.  reset.

Use ULONG_MAX as the reset indicator value so the watchdog works correctly
right from the start.  ULONG_MAX would only conflict with a real timestamp
if the system reaches an uptime of 136 years on 32bit and almost eternity
on 64bit.

Link: http://lkml.kernel.org/r/87o8v3uuzl.fsf@nanos.tec.linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Robert Richter <rrichter@marvell.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/watchdog.c~watchdog-softlockup-enforce-that-timestamp-is-valid-on-boot
+++ a/kernel/watchdog.c
@@ -161,6 +161,8 @@ static void lockup_detector_update_enabl
 
 #ifdef CONFIG_SOFTLOCKUP_DETECTOR
 
+#define SOFTLOCKUP_RESET	ULONG_MAX
+
 /* Global variables, exported for sysctl */
 unsigned int __read_mostly softlockup_panic =
 			CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
@@ -274,7 +276,7 @@ notrace void touch_softlockup_watchdog_s
 	 * Preemption can be enabled.  It doesn't matter which CPU's timestamp
 	 * gets zeroed here, so use the raw_ operation.
 	 */
-	raw_cpu_write(watchdog_touch_ts, 0);
+	raw_cpu_write(watchdog_touch_ts, SOFTLOCKUP_RESET);
 }
 
 notrace void touch_softlockup_watchdog(void)
@@ -298,14 +300,14 @@ void touch_all_softlockup_watchdogs(void
 	 * the softlockup check.
 	 */
 	for_each_cpu(cpu, &watchdog_allowed_mask)
-		per_cpu(watchdog_touch_ts, cpu) = 0;
+		per_cpu(watchdog_touch_ts, cpu) = SOFTLOCKUP_RESET;
 	wq_watchdog_touch(-1);
 }
 
 void touch_softlockup_watchdog_sync(void)
 {
 	__this_cpu_write(softlockup_touch_sync, true);
-	__this_cpu_write(watchdog_touch_ts, 0);
+	__this_cpu_write(watchdog_touch_ts, SOFTLOCKUP_RESET);
 }
 
 static int is_softlockup(unsigned long touch_ts)
@@ -383,7 +385,7 @@ static enum hrtimer_restart watchdog_tim
 	/* .. and repeat */
 	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
 
-	if (touch_ts == 0) {
+	if (touch_ts == SOFTLOCKUP_RESET) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
 			/*
 			 * If the time stamp was touched atomically
_

Patches currently in -mm which might be from tglx@linutronix.de are

watchdog-softlockup-enforce-that-timestamp-is-valid-on-boot.patch
