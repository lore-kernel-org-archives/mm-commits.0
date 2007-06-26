From: akpm@linux-foundation.org
Subject: + timekeeping-fixup-shadow-variable-argument.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:26 -0700
Message-ID: <200706260007.l5Q07Qqq014406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbXFZAIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com


The patch titled
     timekeeping: fixup shadow variable argument
has been added to the -mm tree.  Its filename is
     timekeeping-fixup-shadow-variable-argument.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timekeeping: fixup shadow variable argument
From: Thomas Gleixner <tglx@linutronix.de>

clocksource_adjust() has a clock argument, which shadows the file global clock
variable.  Fix this up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/time/timekeeping.c~timekeeping-fixup-shadow-variable-argument kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~timekeeping-fixup-shadow-variable-argument
+++ a/kernel/time/timekeeping.c
@@ -391,7 +391,7 @@ static __always_inline int clocksource_b
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
-static void clocksource_adjust(struct clocksource *clock, s64 offset)
+static void clocksource_adjust(s64 offset)
 {
 	s64 error, interval = clock->cycle_interval;
 	int adj;
@@ -466,7 +466,7 @@ void update_wall_time(void)
 	}
 
 	/* correct the clock when NTP error is too big */
-	clocksource_adjust(clock, offset);
+	clocksource_adjust(offset);
 
 	/* store full nanoseconds into xtime */
 	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
sys_time-speedup.patch
lguest-the-host-code.patch
