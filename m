From: akpm@linux-foundation.org
Subject: + i386-remove-volatile-in-apicc.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:48 -0700
Message-ID: <200706260007.l5Q07m4M014444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbXFZAIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, mingo@elte.hu


The patch titled
     i386: remove volatile in apic.c
has been added to the -mm tree.  Its filename is
     i386-remove-volatile-in-apicc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: remove volatile in apic.c
From: Thomas Gleixner <tglx@linutronix.de>

Remove the volatile in apic.  We have a cpu_relax() in the wait loop.  Fix a
coding style issue while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/apic.c~i386-remove-volatile-in-apicc arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~i386-remove-volatile-in-apicc
+++ a/arch/i386/kernel/apic.c
@@ -318,7 +318,7 @@ static void __devinit setup_APIC_timer(v
 
 #define LAPIC_CAL_LOOPS		(HZ/10)
 
-static __initdata volatile int lapic_cal_loops = -1;
+static __initdata int lapic_cal_loops = -1;
 static __initdata long lapic_cal_t1, lapic_cal_t2;
 static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
 static __initdata unsigned long lapic_cal_pm1, lapic_cal_pm2;
@@ -488,7 +488,7 @@ void __init setup_boot_APIC_clock(void)
 		/* Let the interrupts run */
 		local_irq_enable();
 
-		while(lapic_cal_loops <= LAPIC_CAL_LOOPS)
+		while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
 			cpu_relax();
 
 		local_irq_disable();
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
