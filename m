From: akpm@linux-foundation.org
Subject: - x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:34 -0700
Message-ID: <200707192008.l6JK8Yx9020471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60342 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761565AbXGSUSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     X86_64: hpet tsc calibration fix broken smi detection logic
has been removed from the -mm tree.  Its filename was
     x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <john stultz <johnstul@us.ibm.com>>
Cc: <stable@kernel.org>
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
git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
