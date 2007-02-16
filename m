From: akpm@linux-foundation.org
Subject: - time-x86_64-split-x86_64-kernel-timec-up-tidy.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:20:23 -0800
Message-ID: <200702160820.l1G8KNFQ024359@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59847 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966211AbXBPIYC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:24:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@muc.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     time-x86_64-split-x86_64-kernel-timec-up-tidy
has been removed from the -mm tree.  Its filename was
     time-x86_64-split-x86_64-kernel-timec-up-tidy.patch

This patch was dropped because it was folded into time-x86_64-split-x86_64-kernel-timec-up.patch

------------------------------------------------------
Subject: time-x86_64-split-x86_64-kernel-timec-up-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/hpet.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.20-rc6-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.20-rc6-mm/arch/x86_64/kernel/hpet.c
@@ -12,7 +12,7 @@
 #include <asm/timex.h>
 #include <asm/hpet.h>
 
-int nohpet __initdata = 0;
+int nohpet __initdata;
 
 unsigned long hpet_address;
 unsigned long hpet_period;	/* fsecs / HPET clock */
@@ -37,7 +37,7 @@ static __init int late_hpet_init(void)
 	if (!hpet_address)
         	return 0;
 
-	memset(&hd, 0, sizeof (hd));
+	memset(&hd, 0, sizeof(hd));
 
 	ntimer = hpet_readl(HPET_ID);
 	ntimer = (ntimer & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT;
@@ -160,7 +160,6 @@ unsigned int __init hpet_calibrate_tsc(v
 	unsigned long flags;
 
 	local_irq_save(flags);
-	local_irq_disable();
 
 	hpet_start = hpet_readl(HPET_COUNTER);
 	rdtscl(tsc_start);

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
