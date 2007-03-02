From: akpm@linux-foundation.org
Subject: + fix-nmi-appears-to-be-stuck.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:16:16 -0800
Message-ID: <200703022216.l22MGGRc020648@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43456 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030603AbXCBWQY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:16:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, mingo@elte.hu


The patch titled
     fix "NMI appears to be stuck"
has been added to the -mm tree.  Its filename is
     fix-nmi-appears-to-be-stuck.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix "NMI appears to be stuck"
From: Thomas Gleixner <tglx@linutronix.de>

  Testing NMI watchdog ... CPU#0: NMI appears to be stuck (54->54)!
  CPU#1: NMI appears to be stuck (0->0)!

Keep the PIT/HPET alive when nmi_watchdog = 1 is given on the command
line.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/apic.c~fix-nmi-appears-to-be-stuck arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~fix-nmi-appears-to-be-stuck
+++ a/arch/i386/kernel/apic.c
@@ -493,8 +493,15 @@ void __init setup_boot_APIC_clock(void)
 		/* No broadcast on UP ! */
 		if (num_possible_cpus() == 1)
 			return;
-	} else
-		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+	} else {
+		/*
+		 * If nmi_watchdog is set to IO_APIC, we need the
+		 * PIT/HPET going.  Otherwise register lapic as a dummy
+		 * device.
+		 */
+		if (nmi_watchdog != NMI_IO_APIC)
+			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+	}
 
 	/* Setup the lapic or request the broadcast */
 	setup_APIC_timer();
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
fix-nmi-appears-to-be-stuck.patch
git-block.patch
log-reason-why-tsc-was-marked-unstable.patch
timer-run-calc_load-halfway-through-each-round_jiffies.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
