From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-softlockup-enforce-that-timestamp-is-valid-on-boot.patch removed
 from -mm tree
Date: Tue, 21 Jan 2020 12:32:31 -0800
Message-ID: <20200121203231.DBU7xMkDb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbgAUUce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 21 Jan 2020 15:32:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, keescook@chromium.org, longman@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, pmladek@suse.com, rppt@linux.ibm.com, rrichter@marvell.com, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: watchdog/softlockup: enforce that timestamp is valid on boot
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-enforce-that-timestamp-is-valid-on-boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
