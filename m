From: akpm@linux-foundation.org
Subject: + x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch added to -mm tree
Date: Wed, 18 Jul 2007 19:54:47 -0700
Message-ID: <200707190254.l6J2slWR010328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659AbXGSCzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 22:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     X86_64: hpet tsc calibration fix broken smi detection logic
has been added to the -mm tree.  Its filename is
     x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: X86_64: hpet tsc calibration fix broken smi detection logic
From: Thomas Gleixner <tglx@linutronix.de>

The current SMI detection logic in read_hpet_tsc() makes sure, that when a
SMI happens between the read of the HPET counter and the read of the TSC,
this wrong value is used for TSC calibration.

This is not the intention of the function.  The comparison must ensure,
that we do _NOT_ use such a value.

Fix the check to use calibration values where delta of the two TSC reads is
smaller than a reasonable threshold.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/hpet.c~x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic arch/x86_64/kernel/hpet.c
--- a/arch/x86_64/kernel/hpet.c~x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic
+++ a/arch/x86_64/kernel/hpet.c
@@ -190,7 +190,7 @@ int hpet_reenable(void)
  */
 
 #define TICK_COUNT 100000000
-#define TICK_MIN   5000
+#define SMI_THRESHOLD 50000
 #define MAX_TRIES  5
 
 /*
@@ -205,7 +205,7 @@ static void __init read_hpet_tsc(int *hp
 		tsc1 = get_cycles_sync();
 		hpet1 = hpet_readl(HPET_COUNTER);
 		tsc2 = get_cycles_sync();
-		if (tsc2 - tsc1 > TICK_MIN)
+		if ((tsc2 - tsc1) < SMI_TRESHOLD)
 			break;
 	}
 	*hpet = hpet1;
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
time-make-sure-sys_gettimeofday-and-sys_time-are-in.patch
add-posix-clocks-and-timers-maintainer.patch
x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch
git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
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
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-mfgpt-clock-event-device-support.patch
i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
