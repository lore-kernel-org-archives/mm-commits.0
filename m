From: akpm@linux-foundation.org
Subject: + ntp-remove-clock_was_set-call-to-prevent-deadlock.patch added to -mm tree
Date: Tue, 03 Jul 2007 12:00:15 -0700
Message-ID: <200707031900.l63J0G5A009381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756217AbXGCTBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 15:01:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, stable@kernel.org, zippel@linux-m68k.org


The patch titled
     NTP: remove clock_was_set() call to prevent deadlock
has been added to the -mm tree.  Its filename is
     ntp-remove-clock_was_set-call-to-prevent-deadlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NTP: remove clock_was_set() call to prevent deadlock
From: Thomas Gleixner <tglx@linutronix.de>

The clock_was_set() call in seconds_overflow() which happens only when leap
seconds are inserted / deleted is wrong in two aspects:

1. it results in a call to on_each_cpu() with interrupts disabled
2. it is potential deadlock source vs. call_lock in smp_call_function()

The only possible side effect of the removal might be, that an absolute
CLOCK_REALTIME timer fires 1 second too late, in the rare case of leap
second deletion and an absolute CLOCK_REALTIME timer which expires in the
affected time frame.  It will never fire too early.

This was probably observed by the reporter of a June 30th -> July 1st hang:
http://lkml.org/lkml/2007/7/3/

A similar problem was observed by Dave Jones, who provided a screen shot
with a lockdep back trace, which allowed to analyse the problem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN kernel/time/ntp.c~ntp-remove-clock_was_set-call-to-prevent-deadlock kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-remove-clock_was_set-call-to-prevent-deadlock
+++ a/kernel/time/ntp.c
@@ -122,7 +122,6 @@ void second_overflow(void)
 			 */
 			time_interpolator_update(-NSEC_PER_SEC);
 			time_state = TIME_OOP;
-			clock_was_set();
 			printk(KERN_NOTICE "Clock: inserting leap second "
 					"23:59:60 UTC\n");
 		}
@@ -137,7 +136,6 @@ void second_overflow(void)
 			 */
 			time_interpolator_update(NSEC_PER_SEC);
 			time_state = TIME_WAIT;
-			clock_was_set();
 			printk(KERN_NOTICE "Clock: deleting leap second "
 					"23:59:59 UTC\n");
 		}
_

Patches currently in -mm which might be from tglx@linutronix.de are

ntp-remove-clock_was_set-call-to-prevent-deadlock.patch
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
highres-improve-debug-output-fix.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
ntp-move-the-cmos-update-code-into-ntpc-fix.patch
ntp-move-the-cmos-update-code-into-ntpc-fix-fix.patch
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
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
sys_time-speedup.patch
sys_time-speedup-build-fixes.patch
futex-tidy-up-the-code-v2.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
